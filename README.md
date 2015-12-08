# dotfiles

My configuration files for Emacs and more.
It uses [pallet](https://github.com/rdallasgray/pallet).

Move the Cask file to `~/.emacs.d/` and then you should be able to do `M-x pallet-mode` and then `M-x pallet-install` and have it auto-install everything.

### Elm 
elm-mode, elm-oracle autocomplete (you have to install elm-oracle on your own), flycheck.

If autocomplete doesn't work try cleaning all the compilation artifact and elm-package.json and start compiling from scratch.

### Erlang
flycheck, autocomplete, distel

### Convenience
ido everywhere, etc
