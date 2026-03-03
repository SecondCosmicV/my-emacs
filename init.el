(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(use-package yaml-mode :ensure t)
(use-package dockerfile-mode :ensure t)
(use-package dired-subtree
  :ensure t
  :after dired
  :bind (:map dired-mode-map
              ("TAB" . dired-subtree-toggle)))
(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))
(use-package magit :ensure t)
(use-package spacemacs-theme
  :ensure t
  :defer t
  :init (load-theme 'spacemacs-dark t))
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(define-key dired-mode-map (kbd "e") 'dired-create-empty-file)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq inhibit-startup-screen t)
(setq initial-buffer-choice t)
(setq initial-scratch-message "")
(setq ring-bell-function 'ignore)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default truncate-lines t)
(load custom-file 'noerror)
(load (expand-file-name "./src/indent.el" user-emacs-directory))
(load (expand-file-name "./src/email.el" user-emacs-directory) 'noerror)
(dolist (x (directory-files (expand-file-name "plugins" user-emacs-directory) t))
  (let ((basename (file-name-nondirectory x)))
    (when (not (member basename '("." "..")))
      (add-to-list 'load-path x)
      (require (intern basename)))))

