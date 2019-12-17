# SEmacs

SEmacs is an Emacs like text editor written in Chez Scheme. With the main focus on letting users to hack and tweak their config and customize on whatever they want.

  - Write some scheme code
  - C-x C-e (eval-last-sexp)
  - Magic

# Different from Emacs!

  - Using lexical scope
  - No windows-buffers design
  - Multi-thread support

### Installation

SEmacs requires Chez Scheme to run

```sh
$ sudo apt install chezscheme
```

Git clone the repo and enter to the path to run makefile

```sh
$ git clone https://github.com/BooAA/SEmacs.git
$ cd <path-you-download-the-source-code>
$ make
```

### Run

```sh
./run.sh <filename>
```

### Todos

 - Write more plugins
 - Add split window function

