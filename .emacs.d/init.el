(add-to-list 'load-path "~/.emacs.d/")

(setq inhibit-startup-message t)
(setq auto-save-default nil)
(setq auto-save-list-file-name nil)
(setq auto-save-list-file-prefix nil)
(setq make-backup-files nil)
(global-font-lock-mode t)
(column-number-mode 1)
(line-number-mode 1)
(menu-bar-mode nil)

;; paren
(show-paren-mode 1)
(setq show-paren-style 'mixed)
(set-face-background 'show-paren-match-face "grey")
(set-face-foreground 'show-paren-match-face "black")

;; keybinds
(global-set-key "\C-h" 'delete-backward-char)

;; package
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(require 'package-require)
(package-require 'js2-mode)
(package-require 'php-mode)
(package-require 'magit)
(package-require 'markdown-mode)

(when (package-require 'color-moccur)
  (require 'moccur-edit))

(when (package-require `helm)
  (require 'helm-config)
  (define-key global-map (kbd "C-x b") 'helm-mini)
  (define-key helm-map (kbd "C-h") 'delete-backward-char))
  
(when (and (or (executable-find "migemo")
               (executable-find "cmigemo"))
           (require 'migemo nil t))
  (when (executable-find "cmigemo")
    (package-require 'helm-migemo)
    (setq migemo-command "cmigemo")
    (setq migemo-options '("-q" "--emacs"))
    (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
    (setq migemo-coding-system 'utf-8-unix)
    (setq migemo-user-dictionary nil)
    (setq migemo-regex-dictionary nil))
  (migemo-init))
