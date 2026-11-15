/**
 * copy-mode: tmux/vim-style copy mode over the current session transcript.
 *
 * Enter:  /copy-mode  or  alt+c
 *
 * Normal:  h j k l, arrows, w b e, W B E, 0 ^ $, gg G, H M L,
 *          ctrl+u/d (half page), ctrl+b/f (page), ctrl+e/y (scroll),
 *          { } (paragraph), / ? n N (search), counts (e.g. 5j)
 * Select:  v (char), V (line), ctrl+v (block/rectangle), o (swap ends),
 *          y / Enter (copy + exit), Esc (clear selection)
 * Exit:    q / Esc (no selection)
 *
 * Inspired by tmux copy-mode-vi and @luan.sh/pi-copy-mode.
 */
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { matchesKey, truncateToWidth } from "@earendil-works/pi-tui";
import { spawnSync } from "node:child_process";

type Sel = "none" | "char" | "line" | "block";
interface Pos { row: number; col: number }

// ---------- transcript extraction ----------

function textOf(content: unknown): string {
  if (typeof content === "string") return content;
  if (!Array.isArray(content)) return "";
  return content
    .map((b: any) => {
      if (b?.type === "text") return b.text ?? "";
      if (b?.type === "toolCall") return `[tool ${b.name}] ${JSON.stringify(b.arguments ?? {})}`;
      if (b?.type === "image") return "[image]";
      return "";
    })
    .filter(Boolean)
    .join("\n");
}

function buildTranscript(ctx: ExtensionContext): string[] {
  const out: string[] = [];
  for (const e of ctx.sessionManager.getBranch() as any[]) {
    let header: string | undefined;
    let body = "";
    if (e.type === "message") {
      const m = e.message;
      if (m.role === "system") continue;
      header = m.role === "toolResult" ? `── tool result (${m.toolName}) ──` : `── ${m.role} ──`;
      body = textOf(m.content);
    } else if (e.type === "custom_message" && e.display) {
      header = `── ${e.customType} ──`;
      body = textOf(e.content);
    } else if (e.type === "compaction" || e.type === "branch_summary") {
      header = `── ${e.type} ──`;
      body = e.summary ?? "";
    }
    if (!header || !body.trim()) continue;
    out.push(header, ...body.replace(/\t/g, "    ").split("\n"), "");
  }
  return out.length ? out : ["(empty transcript)"];
}

/** Hard-wrap logical lines to width; returns display rows. */
function wrap(lines: string[], width: number): string[] {
  const rows: string[] = [];
  for (const l of lines) {
    const chars = [...l];
    if (!chars.length) { rows.push(""); continue; }
    for (let i = 0; i < chars.length; i += width) rows.push(chars.slice(i, i + width).join(""));
  }
  return rows;
}

// ---------- clipboard ----------

function copy(text: string): string {
  const tries: [string, string[]][] = [
    ["wl-copy", []],
    ["xclip", ["-selection", "clipboard"]],
    ["xsel", ["--clipboard", "--input"]],
    ["pbcopy", []],
  ];
  // OSC 52 always (works through tmux/ssh if allowed)
  const osc = `\x1b]52;c;${Buffer.from(text).toString("base64")}\x07`;
  process.stdout.write(process.env.TMUX ? `\x1bPtmux;\x1b${osc}\x1b\\` : osc);
  for (const [cmd, args] of tries) {
    try {
      const r = spawnSync(cmd, args, { input: text, timeout: 2000, stdio: ["pipe", "ignore", "ignore"] });
      if (r.status === 0) return cmd;
    } catch {}
  }
  return "OSC 52";
}

// ---------- word motions ----------

const cls = (c: string | undefined, big: boolean) =>
  c === undefined || /\s/.test(c) ? 0 : big ? 1 : /\w/.test(c) ? 1 : 2;

// ---------- extension ----------

export default function (pi: ExtensionAPI) {
  const open = async (ctx: ExtensionContext) => {
    if (ctx.mode !== "tui") return ctx.ui.notify("copy-mode requires interactive TUI", "error");
    const logical = buildTranscript(ctx);

    const msg = await ctx.ui.custom<string | undefined>((tui, theme, _kb, done) => {
      let width = 80;
      let rows: string[] = wrap(logical, width);
      let cur: Pos = { row: rows.length - 1, col: 0 };
      let top = 0;
      let sel: Sel = "none";
      let anchor: Pos = { ...cur };
      let count = "";
      let pending = ""; // "g" or "/" or "?"
      let query = "";
      let lastSearch = { q: "", fwd: true };
      let status = "";
      let wantCol = 0;

      const height = () => Math.max(3, ((tui as any).terminal?.rows ?? process.stdout.rows ?? 24) - 2);
      const lineLen = (r: number) => [...(rows[r] ?? "")].length;
      const charAt = (p: Pos) => [...(rows[p.row] ?? "")][p.col];
      const clampCol = () => { cur.col = Math.max(0, Math.min(cur.col, Math.max(0, lineLen(cur.row) - 1))); };
      const clamp = () => {
        cur.row = Math.max(0, Math.min(cur.row, rows.length - 1));
        clampCol();
        const h = height();
        if (cur.row < top) top = cur.row;
        if (cur.row >= top + h) top = cur.row - h + 1;
        top = Math.max(0, Math.min(top, Math.max(0, rows.length - h)));
      };
      const vmove = (n: number) => { cur.row += n; cur.col = wantCol; clamp(); };
      const hset = (c: number) => { cur.col = c; clampCol(); wantCol = cur.col; };

      // linear stepping across rows for word motions
      const step = (p: Pos, d: 1 | -1): Pos | undefined => {
        let { row, col } = p;
        col += d;
        if (col >= lineLen(row) || (d === 1 && lineLen(row) === 0)) { row++; col = 0; if (row >= rows.length) return; return { row, col }; }
        if (col < 0) { row--; if (row < 0) return; col = Math.max(0, lineLen(row) - 1); }
        return { row, col };
      };
      const wordFwd = (big: boolean) => {
        let p: Pos | undefined = { ...cur };
        const c0 = cls(charAt(p), big);
        while (p && c0 && cls(charAt(p), big) === c0 && lineLen(p.row)) { const n = step(p, 1); if (!n || n.row !== p.row) { p = n; break; } p = n; }
        while (p && cls(charAt(p), big) === 0 && lineLen(p.row)) p = step(p, 1);
        if (p) cur = p;
      };
      const wordEnd = (big: boolean) => {
        let p = step(cur, 1);
        while (p && cls(charAt(p), big) === 0) p = step(p, 1);
        if (!p) return;
        const c = cls(charAt(p), big);
        let n = step(p, 1);
        while (n && n.row === p.row && cls(charAt(n), big) === c) { p = n; n = step(p, 1); }
        cur = p;
      };
      const wordBack = (big: boolean) => {
        let p = step(cur, -1);
        while (p && cls(charAt(p), big) === 0) p = step(p, -1);
        if (!p) return;
        const c = cls(charAt(p), big);
        let n = step(p, -1);
        while (n && n.row === p.row && cls(charAt(n), big) === c) { p = n; n = step(p, -1); }
        cur = p;
      };
      const search = (q: string, fwd: boolean) => {
        if (!q) return;
        const ql = q.toLowerCase();
        const N = rows.length;
        for (let i = 0; i <= N; i++) {
          const r = (cur.row + (fwd ? i : -i) + N * 2) % N;
          const chars = [...rows[r]].join("").toLowerCase();
          let idx: number;
          if (fwd) idx = chars.indexOf(ql, i === 0 ? cur.col + 1 : 0);
          else idx = i === 0 ? (cur.col > 0 ? chars.lastIndexOf(ql, cur.col - 1) : -1) : chars.lastIndexOf(ql);
          if (idx >= 0) { cur = { row: r, col: [...chars.slice(0, idx)].length }; wantCol = cur.col; clamp(); return; }
        }
        status = `Pattern not found: ${q}`;
      };

      const range = () => {
        const [a, b] = anchor.row < cur.row || (anchor.row === cur.row && anchor.col <= cur.col) ? [anchor, cur] : [cur, anchor];
        return { a, b, c0: Math.min(anchor.col, cur.col), c1: Math.max(anchor.col, cur.col) };
      };
      const inSel = (r: number, c: number) => {
        if (sel === "none") return false;
        const { a, b, c0, c1 } = range();
        if (r < a.row || r > b.row) return false;
        if (sel === "line") return true;
        if (sel === "block") return c >= c0 && c <= c1;
        if (r === a.row && c < a.col) return false;
        if (r === b.row && c > b.col) return false;
        return true;
      };
      const selectedText = (): string => {
        const { a, b, c0, c1 } = range();
        const out: string[] = [];
        for (let r = a.row; r <= b.row; r++) {
          const ch = [...rows[r]];
          if (sel === "line") out.push(ch.join(""));
          else if (sel === "block") out.push(ch.slice(c0, c1 + 1).join("").padEnd(c1 - c0 + 1).trimEnd());
          else {
            const s = r === a.row ? a.col : 0;
            const e = r === b.row ? b.col + 1 : ch.length;
            out.push(ch.slice(s, e).join("").trimEnd());
          }
        }
        return out.join("\n") + (sel === "line" ? "\n" : "");
      };

      const toggle = (mode: Sel) => {
        if (sel === mode) sel = "none";
        else { if (sel === "none") anchor = { ...cur }; sel = mode; }
      };

      const render = (w: number): string[] => {
        if (w !== width) {
          // keep roughly same position on resize
          const frac = rows.length ? cur.row / rows.length : 1;
          width = Math.max(10, w);
          rows = wrap(logical, width);
          cur.row = Math.round(frac * rows.length);
          sel = "none";
          clamp();
        }
        const h = height();
        const lines: string[] = [];
        for (let i = 0; i < h; i++) {
          const r = top + i;
          if (r >= rows.length) { lines.push(theme.fg("dim", "~")); continue; }
          const ch = [...rows[r]];
          const n = Math.max(ch.length, r === cur.row || sel === "block" ? Math.max(cur.col, anchor.col) + 1 : 0);
          let s = "";
          for (let c = 0; c < n; c++) {
            const g = ch[c] ?? " ";
            if (r === cur.row && c === cur.col) s += `\x1b[7m${g}\x1b[27m`;
            else if (inSel(r, c)) s += theme.bg("selectedBg", g);
            else s += g;
          }
          if (sel === "line" && inSel(r, 0) && ch.length === 0 && r !== cur.row) s = theme.bg("selectedBg", " ");
          lines.push(truncateToWidth(s, width));
        }
        const mode = { none: "", char: " VISUAL", line: " V-LINE", block: " V-BLOCK" }[sel];
        const left = pending === "/" || pending === "?" ? `${pending}${query}` : theme.fg("accent", `[COPY${mode}]`) + (status ? "  " + status : "") + (count ? "  " + count : "");
        const right = theme.fg("dim", `${cur.row + 1}/${rows.length},${cur.col + 1}`);
        lines.push(theme.fg("dim", "─".repeat(width)));
        lines.push(truncateToWidth(left + "  " + right, width));
        return lines;
      };

      const handleInput = (data: string) => {
        status = "";
        // search prompt
        if (pending === "/" || pending === "?") {
          if (matchesKey(data, "escape")) { pending = ""; query = ""; }
          else if (matchesKey(data, "enter")) { lastSearch = { q: query, fwd: pending === "/" }; search(query, lastSearch.fwd); pending = ""; query = ""; }
          else if (matchesKey(data, "backspace")) query = query.slice(0, -1);
          else if (data.length === 1 && data >= " ") query += data;
          return tui.requestRender();
        }

        const n = Math.max(1, parseInt(count || "1", 10));
        const k = data;

        if (/^[1-9]$/.test(k) || (k === "0" && count)) { count += k; return tui.requestRender(); }

        if (pending === "g") {
          pending = "";
          if (k === "g") { cur.row = count ? n - 1 : 0; cur.col = 0; wantCol = 0; clamp(); }
          count = "";
          return tui.requestRender();
        }

        const h = height();
        const half = Math.floor(h / 2);
        let handled = true;

        if (matchesKey(k, "ctrl+v")) toggle("block");
        else if (matchesKey(k, "ctrl+u")) { top -= half * n; vmove(-half * n); }
        else if (matchesKey(k, "ctrl+d")) { top += half * n; vmove(half * n); }
        else if (matchesKey(k, "ctrl+b") || matchesKey(k, "pageUp")) { top -= h * n; vmove(-h * n); }
        else if (matchesKey(k, "ctrl+f") || matchesKey(k, "pageDown")) { top += h * n; vmove(h * n); }
        else if (matchesKey(k, "ctrl+e")) { top = Math.min(top + n, Math.max(0, rows.length - h)); if (cur.row < top) cur.row = top; clamp(); }
        else if (matchesKey(k, "ctrl+y")) { top = Math.max(0, top - n); if (cur.row >= top + h) cur.row = top + h - 1; clamp(); }
        else if (matchesKey(k, "escape")) { if (sel !== "none") sel = "none"; else return done(undefined); }
        else if (matchesKey(k, "enter") || k === "y") {
          if (sel === "none") { status = "No selection"; }
          else return done(selectedText());
        }
        else if (matchesKey(k, "up")) vmove(-n);
        else if (matchesKey(k, "down")) vmove(n);
        else if (matchesKey(k, "left")) hset(cur.col - n);
        else if (matchesKey(k, "right")) hset(cur.col + n);
        else switch (k) {
          case "q": return done(undefined);
          case "h": hset(cur.col - n); break;
          case "l": hset(cur.col + n); break;
          case "j": vmove(n); break;
          case "k": vmove(-n); break;
          case "0": hset(0); break;
          case "^": hset(Math.max(0, (rows[cur.row].match(/^\s*/)?.[0].length ?? 0))); break;
          case "$": hset(lineLen(cur.row) - 1); wantCol = Infinity; break;
          case "w": case "W": for (let i = 0; i < n; i++) wordFwd(k === "W"); clamp(); wantCol = cur.col; break;
          case "e": case "E": for (let i = 0; i < n; i++) wordEnd(k === "E"); clamp(); wantCol = cur.col; break;
          case "b": case "B": for (let i = 0; i < n; i++) wordBack(k === "B"); clamp(); wantCol = cur.col; break;
          case "G": cur.row = count ? n - 1 : rows.length - 1; hset(0); clamp(); break;
          case "g": pending = "g"; return tui.requestRender();
          case "H": cur.row = top; clamp(); break;
          case "M": cur.row = top + Math.floor(Math.min(h, rows.length - top) / 2); clamp(); break;
          case "L": cur.row = Math.min(rows.length - 1, top + h - 1); clamp(); break;
          case "}": for (let i = 0; i < n; i++) { let r = cur.row + 1; while (r < rows.length - 1 && rows[r].trim()) r++; cur.row = r; } hset(0); clamp(); break;
          case "{": for (let i = 0; i < n; i++) { let r = cur.row - 1; while (r > 0 && rows[r].trim()) r--; cur.row = Math.max(0, r); } hset(0); clamp(); break;
          case "v": case " ": toggle("char"); break;
          case "V": toggle("line"); break;
          case "o": if (sel !== "none") { const t = anchor; anchor = cur; cur = { ...t }; wantCol = cur.col; clamp(); } break;
          case "/": case "?": pending = k; query = ""; break;
          case "n": for (let i = 0; i < n; i++) search(lastSearch.q, lastSearch.fwd); break;
          case "N": for (let i = 0; i < n; i++) search(lastSearch.q, !lastSearch.fwd); break;
          default: handled = false;
        }
        if (handled) count = "";
        clamp();
        tui.requestRender();
      };

      clamp();
      return { render, handleInput, invalidate() {} };
    });

    if (msg) ctx.ui.notify(`Copied ${msg.split("\n").length} line(s) via ${copy(msg)}`, "info");
  };

  pi.registerCommand("copy-mode", { description: "Vim/tmux-style copy mode over transcript", handler: async (_a, ctx) => open(ctx) });
  pi.registerShortcut("alt+c", { description: "Enter copy mode", handler: async (ctx) => open(ctx) });
}
