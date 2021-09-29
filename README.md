# Project
Hacky project system for Vim.

## Install
- Use your plugin manager of choice to install this plugin.

| Plugin manager                                    | Command                                    |
| ------------------------------------------------- | ------------------------------------------ |
| [Vim Plug](https://github.com/junegunn/vim-plug)  | `Plug 'shoumodip/project.vim'`             |
| [Vundle](https://github.com/VundleVim/Vundle.vim) | `Plugin 'shoumodip/project.vim'`           |
| [Dein](https://github.com/Shougo/dein.vim)        | `call dein#add('shoumodip/project.vim')`   |
| [Minpac](https://github.com/k-takata/minpac)      | `call minpac#add('shoumodip/project.vim')` |

- Or use the builtin packages feature.

| Editor | Path                                   |
| ------ | -------------------------------------- |
| Vim    | `cd ~/.vim/pack/plugins/start`         |
| NeoVim | `cd ~/.config/nvim/pack/plugins/start` |

```console
$ git clone https://github.com/shoumodip/project.vim
```

## Usage
The mapping `<plug>(ProjectEntry)` starts the entry point in the project functions. By default, `<c-p>` in normal mode is mapped to this. Any subsequent key presses after initiating the entry point defines the project function to be used.

| Key          | Description                                                                                   |
| ------------ | --------------------------------------------------------------------------------------------- |
| <kbd>s</kbd> | Select a project from `g:project#location`. (requires [fzf](https://github.com/junegunn/fzf)) |
| <kbd>r</kbd> | Run the reload/build command for the project                                                  |
| <kbd>k</kbd> | Kill the terminal associated with the project                                                 |
| <kbd>n</kbd> | Goto the next error from the project terminal                                                 |
| <kbd>p</kbd> | Goto the previous error from the project terminal                                             |
| <kbd>f</kbd> | Run `:GFiles` (requires [fzf.vim](https://github.com/junegunn/fzf.vim))                       |

## Setup
The `project#setup()` function searches for a file `project.ini` (`g:project#config_path`) in the current directory. This file defines the project configuration of the project. There are three posible variables which can be set.

| Variable | Description                        | Default     |
| -------- | ---------------------------------- | ----------- |
| `build`  | The command to build the project   | `"make -B"` |
| `repl`   | The command to start the repl      | `""`        |
| `reload` | The command to reload the terminal | `""`        |

An example configuration for a Haskell project.
```ini
build = cabal v2-build
repl = cabal v2-repl
reload = :r
```

## Variables
| Variable                | Description                                       | Default         |
| ----------------------- | ------------------------------------------------- | --------------- |
| `g:project#location`    | The directory where all the projects are located  | `""`            |
| `g:project#config_path` | The project configuration file path               | `"project.ini" `|
| `g:project#repl`        | The command to run to open the repl for a project | `""`            |
| `g:project#build`       | The command to run to build the project           | `"make -B"`     |
| `g:project#reload`      | The command to run to reload the project          | `""`            |

## Disclaimer
This is a **very** hacky plugin. Use at your own risk.
