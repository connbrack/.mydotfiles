var oldGeometry = null;

function fakeMaximize() {
    var w = workspace.activeWindow;

    if (!w)
        return;

    if (oldGeometry) {
        w.frameGeometry = oldGeometry;
        oldGeometry = null;
        return;
    }

    oldGeometry = w.frameGeometry;

    var area = workspace.clientArea(
        KWin.MaximizeArea,
        w
    );

    w.frameGeometry = area;
}

registerShortcut(
    "Fake Maximize",
    "Fake Maximize",
    "Meta+F",
    fakeMaximize
);
