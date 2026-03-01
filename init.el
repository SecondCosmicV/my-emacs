(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(use-package yaml-mode :ensure t)
(use-package dockerfile-mode :ensure t)
(use-package dired-subtree
  :ensure t
  :after dired
  :bind (:map dired-mode-map
              ("TAB" . dired-subtree-toggle)
              ("n" . dired-create-empty-file)))
(use-package spacemacs-theme
  :ensure t
  :defer t
  :init (load-theme 'spacemacs-dark t))
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq inhibit-startup-screen t)
(setq initial-buffer-choice t)
(setq initial-scratch-message "")
(setq ring-bell-function 'ignore)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(defun my-apply-on-region-lines (fn)
  (let ((beg (region-beginning))
        (end (region-end)))
    (save-excursion
      (goto-char beg)
      (setq beg (line-beginning-position))
      (goto-char end)
      (when (and (bolp) (> (point) beg))
        (forward-line -1))
      (setq end (line-beginning-position))
      (let ((lines '()))
        (goto-char beg)
        (while (<= (point) end)
          (push (line-beginning-position) lines)
          (forward-line 1))
        (dolist (pos lines)
          (goto-char pos)
          (back-to-indentation)
          (funcall fn (point)))))
    (setq deactivate-mark nil)))
(defun my-detect-indent (fallback)
  (save-excursion
    (goto-char (point-min))
    (if (re-search-forward "^\\( +\\|\t+\\)" nil t)
      (let ((ws (match-string 1)))
        (if (string-match-p "^\t" ws)
          (progn
            (setq-local indent-tabs-mode t)
            (setq-local tab-width fallback))
          (setq-local indent-tabs-mode nil)
          (setq-local tab-width (length ws))))
      (setq-local indent-tabs-mode nil)
      (setq-local tab-width fallback))))
(defun my-get-line-leading-ws ()
  (save-excursion
    (beginning-of-line)
    (buffer-substring-no-properties
      (point)
      (progn (skip-chars-forward " \t") (point)))))
(defun my-indent-at (pos)
  (goto-char pos)
  (let* ((indent (my-get-line-leading-ws))
         (indent-end (+ (line-beginning-position) (length indent))))
    (if (> (point) indent-end)
      (indent-for-tab-command)
      (if indent-tabs-mode
        (when (not (string-match-p " " indent))
          (insert "\t"))
        (when (not (string-match-p "\t" indent))
          (let* ((col (current-column))
                 (spaces (- tab-width (mod col tab-width))))
            (insert (make-string spaces ?\s))))))))
(defun my-deindent-at (pos)
  (goto-char pos)
  (if (bolp)
    (delete-char -1)
    (let* ((indent (my-get-line-leading-ws))
           (indent-end (+ (line-beginning-position) (length indent))))
      (if (> (point) indent-end)
        (delete-char -1)
        (if indent-tabs-mode
          (delete-char -1)
          (let* ((col (current-column))
                 (to-delete (if (= (mod col tab-width) 0) tab-width (mod col tab-width))))
            (delete-char (- to-delete))))))))
(defun my-newline ()
  (interactive)
  (if (eolp)
    (let ((indent (my-get-line-leading-ws)))
      (insert "\n")
      (insert indent))
    (newline)))
(defun my-tab ()
  (interactive)
  (if (use-region-p)
    (my-apply-on-region-lines #'my-indent-at)
    (my-indent-at (point))))
(defun my-shift-tab ()
  (interactive)
  (when (use-region-p)
    (my-apply-on-region-lines #'my-deindent-at)))
(defun my-backspace ()
  (interactive)
  (if (use-region-p)
    (delete-region (region-beginning) (region-end))
    (my-deindent-at (point))))
(defvar my-keys-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") 'my-newline)
    (define-key map (kbd "TAB") 'my-tab)
    (define-key map (kbd "<backtab>") 'my-shift-tab)
    (define-key map (kbd "<backspace>") 'my-backspace)
    map))
(define-minor-mode my-keys-mode
  "Minor mode for custom keybindings that override major modes."
  :lighter " MyKeys"
  :keymap my-keys-mode-map)
(dolist (hook '(lisp-interaction-mode-hook
                emacs-lisp-mode-hook
                sh-mode-hook
                c-mode-hook
                c++-mode-hook
                python-mode-hook
                js-mode-hook
                json-mode-hook
                yaml-mode-hook
                html-mode-hook
                mhtml-mode-hook
                css-mode-hook
                latex-mode-hook
                dockerfile-mode-hook))
  (add-hook hook #'my-keys-mode))
(dolist (hook '(sh-mode-hook
                c-mode-hook
                c++-mode-hook
                python-mode-hook
                html-mode-hook
                mhtml-mode-hook
                css-mode-hook
                latex-mode-hook
                dockerfile-mode-hook))
  (add-hook hook (lambda () (my-detect-indent 4))))
(dolist (hook '(emacs-lisp-mode-hook
                lisp-interaction-mode-hook
                js-mode-hook
                json-mode-hook
                yaml-mode-hook))
  (add-hook hook (lambda () (my-detect-indent 2))))

