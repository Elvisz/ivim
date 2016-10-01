# myvim
vim config and plugins for web development. 
Language support: 
* JavaScript

## Requirements
  * python 2.7+
  * vim 7.4+ with lua or `brew install vim --with-lua`
  * node & npm & tern `npm install -g tern`
  * Install [Powerline Fonts](https://github.com/powerline/fonts) and set your terminal font with `* powerline`

Recomment nvm for nodejs `curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash`

## Get Start
  * Copy this repo: `git clone https://github.com/Elvisz/ivim ~/.ivim && cd ~/.ivim` (You can clone repo to any path, default is `~/.ivim`)
  * Export `ivim` dir: `export IVIM_DIR="$PWD" >> ~/.bash_profile`
  * Add `ivim` command: `echo "alias ivim='vim -u $IVIM_DIR/.vimrc'" >> ~/.bash_profile`
  * Install submodule: `git submodule update --init --remote --recursive`
  * Link `.tern-config`: `ln -s ~/.ivim/.tern-config ~/.tern-config`

## Enable Meta Key

### macOS
`Terminal` > `Preferences`(⌘+,) > `Profile` Tab > `Keyboard` Tab, check on `Use Option as Meta key`

### XTerm
Add this line anywhere in your personal `.Xdefaults` file (~/.Xdefaults):
`xterm*metaSendsEscape: true`
Then reload the config with xrdb. Without this step the changes in .Xdefaults won't take effect until the next X restart:
`xrdb -l ~/.Xdefaults`

## Keymaps
`<leader>`: `,`

### Files
* Open explorer: `<leader>e`
* Open a file: `<leader>o`
* Close a file `<leader>w`
* Close vim: `<leader>q`
* Close vim with save all: `<leader>Q`

### Buffer Tabs
* Switch to previous tab: `<tab>j`
* Switch to next tab: `<tab>k`
* Switch to first tab: `<tab>h`
* Switch to last tab: `<tab>l`

### Editor
* Fast selection: `ww`/`WW`
* Search text: `<leader>f`
* Foldering: `<F4>`
* Format current file: `<leader>l`
