(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/"))

(setq inhibit-startup-message t)
(setq auto-save-default nil)
(setq auto-save-list-file-name nil)
(setq auto-save-list-file-prefix nil)
(setq make-backup-files nil)
(global-font-lock-mode t)
(column-number-mode 1)
(line-number-mode 1)
(menu-bar-mode nil)
(setq transient-mark-mode nil)

(setq-default truncate-lines t)
(setq-default truncate-partial-width-windows t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; paren
(show-paren-mode 1)
(setq show-paren-style 'mixed)
(set-face-background 'show-paren-match-face "grey")
(set-face-foreground 'show-paren-match-face "black")

;; keybinds
(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\M-s" 'eshell)
(global-set-key "\C-x\C-i" 'indent-region)
(global-set-key (kbd "C-c ;") 'comment-or-uncomment-region)
(global-set-key "\M-gf" 'moccur-grep-find)

;; ruby
(setq ruby-insert-encoding-magic-comment nil)

;; eshell
(setq eshell-ask-to-save-history (quote always))
(setq eshell-history-file-name "~/.zsh_history")
(setq eshell-history-size 100000)

(defun trim-string (string)
  (replace-regexp-in-string "\\`[ \t\n]*" "" (replace-regexp-in-string "[ \t\n]*\\'" "" string)))

(defun curr-dir-git-branch-string (pwd)
  (interactive)
  (if (and (eshell-search-path "git")
           (locate-dominating-file pwd ".git"))
      (let (
            (git-output (trim-string (shell-command-to-string (concat "git branch | grep '\\*' | sed -e 's/^\\* //'")))))
        (propertize
         (concat "[±:"
                 (if (> (length git-output) 0)
                     git-output
                   "no branch")
                 "]")
         'face `(:foreground "#D1D62D")))
    (propertize
     "" 'face `(:foreground "#555555"))))

(setq eshell-highlight-prompt nil)
(setq eshell-prompt-function
      (lambda ()
        (concat
         (propertize (eshell/whoami)
                     'face '(:foreground "green"))
         (propertize "@"
                     'face '(:foreground "white"))
         (propertize (system-name)
                     'face '(:foreground "red"))
         (propertize ":"
                     'face '(:foreground "white"))
         (propertize (abbreviate-file-name (eshell/pwd))
                     'face '(:foreground "yellow"))
         (curr-dir-git-branch-string (eshell/pwd))
         "\n"
         (propertize "$ "
                     'face '(:foreground "red")))))

(add-hook 'eshell-directory-change-hook
          `(lambda ()
             (eshell/ls "-lha")))

;;for tramp + ssh + sudo
(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))

;;
;; package configuratin
;;
;; package
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; el-get
(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(el-get-bundle magit
  (global-set-key "\M-gs" 'magit-status))

(el-get-bundle markdown-mode)
(el-get-bundle less-css-mode)
(el-get-bundle htmlize)

(el-get-bundle php-mode
  (add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl$" . html-mode)))

(el-get-bundle yasnippet
  (let* ((library-dir (file-name-directory (locate-library "yasnippet")))
         (default-snippets-dir (format "%ssnippets" library-dir)))
    (setq yas-snippet-dirs (list "~/.emacs.d/snippets" default-snippets-dir)))

  
  (yas-global-mode 1)
  (custom-set-variables '(yas-trigger-key "TAB"))
  (define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)
  (define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
  (define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file))

(el-get-bundle js2-mode
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)))

(el-get-bundle auto-complete
  (require 'auto-complete-config)
  (ac-config-default)
  (setq ac-use-menu-map t)
  (define-key ac-menu-map "\C-n" 'ac-next)
  (define-key ac-menu-map "\C-p" 'ac-previous))

(el-get-bundle anything
  (require 'anything-config)
  (add-to-list 'ac-modes 'eshell-mode)
  (add-to-list 'anything-sources 'anything-c-source-emacs-commands)

  (defun my-anything ()
    (interactive)
      (cond
       ((eq major-mode 'eshell-mode) (call-interactively 'anything-eshell))
       (t (call-interactively 'anything))))
  
  (define-key global-map (kbd "C-x b") `my-anything)
  (define-key global-map (kbd "C-;") `my-anything)

  (require 'anything-complete)
  (anything-read-string-mode 1)

  (defvar anything-c-eshell-directory-history
  '((name . "Directory History")
    (candidates . (lambda () 
                    (set-buffer anything-current-buffer) 
                    (delete-dups (ring-elements eshell-last-dir-ring))))
    (action . (("Change Directory" . anything-eshell-change-directory)))))

(defvar anything-c-eshell-command-history
  '((name . "Command History")
    (candidates . (lambda ()
                    (set-buffer anything-current-buffer)
                    (remove-if (lambda (str) (string-match "^cd *" str))
                               (delete-dups (ring-elements eshell-history-ring)))))
    (action . (("Insert" . insert)))))

(defun anything-eshell-change-directory (dir)
  (insert (concat "cd " dir))
  (eshell-send-input))

(defun anything-eshell ()
  (interactive)
  (anything
   (list
    anything-c-eshell-directory-history
    anything-c-source-files-in-current-dir+
    anything-c-eshell-command-history
    anything-c-source-buffers+
    anything-c-source-recentf
    anything-c-source-bookmarks))))

(el-get-bundle popwin
  (setq display-buffer-function 'popwin:display-buffer))

(defun eshell/clear ()
 "Clear the current buffer, leaving one prompt at the top."
 (interactive)
 (let ((inhibit-read-only t))
   (erase-buffer)))

(add-to-list 'eshell-command-aliases-list (list "ls" "ls -lha"))

;; color
(custom-set-faces
 '(default ((t (:background "black" :foreground "#FFFFFF"))))
 '(cursor ((((class color)
             (background dark))
            (:background "#00AA00"))
           (((class color)
             (background light))
            (:background "#999999"))
           (t ()))))
