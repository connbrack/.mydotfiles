#bin/bash

if command -v tmux >/dev/null 2>&1; then
  if ! [ -d $HOME/.local/share/tmux/plugins ]; then
    mkdir -p $HOME/.local/share/tmux/plugins
    git clone https://github.com/tmux-plugins/tpm $HOME/.local/share/tmux/plugins/tpm
  fi
fi

if command -v bat >/dev/null 2>&1; then
  \bat cache --build
fi
