#!/bin/bash
export PATH="/opt/homebrew/bin/git:$PATH"

if type mise &>/dev/null; then
  eval "$(mise activate zsh)"
  eval "$(mise activate --shims)"
fi