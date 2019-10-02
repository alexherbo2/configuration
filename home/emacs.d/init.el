(tool-bar-mode -1)

(add-to-list 'load-path "~/repositories/github.com/emacs-evil/evil")
(require 'evil)
(evil-mode 1)

(add-to-list 'load-path "~/repositories/dr-qubit.org/git/undo-tree")
(require 'undo-tree)
(global-undo-tree-mode)

(add-to-list 'load-path "~/repositories/github.com/emacs-evil/goto-chg")
(require 'goto-chg)

(add-to-list 'custom-theme-load-path "~/repositories/github.com/dracula/emacs")
(load-theme 'dracula t)
