(defun my-apply-on-region-lines (fn)
  (let ((beg (line-number-at-pos (region-beginning)))
        (end (line-number-at-pos (region-end))))
    (save-excursion
      (goto-line beg)
      (while (<= (line-number-at-pos) end)
        (back-to-indentation)
        (funcall fn)
        (forward-line 1))))
  (setq deactivate-mark nil))
(defun my-detect-indent (fallback)
  (save-excursion
    (beginning-of-buffer)
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
(defun my-get-num-spaces ()
  (- (point)
     (save-excursion
       (skip-chars-backward " " (line-beginning-position))
       (point))))
(defun my-indent ()
  (if indent-tabs-mode
    (insert "\t")
    (insert (make-string (- tab-width (mod (my-get-num-spaces) tab-width)) ?\s))))
(defun my-dedent ()
  (let ((to-delete 1))
    (when (not indent-tabs-mode)
      (let ((num-spaces (my-get-num-spaces)))
        (when (not (zerop num-spaces))
          (setq to-delete (mod num-spaces tab-width))
          (when (zerop to-delete)
            (setq to-delete tab-width)))))
    (delete-char (- to-delete))))
(defun my-newline ()
  (interactive)
  (let ((indent (save-excursion
                  (back-to-indentation)
                  (buffer-substring (line-beginning-position) (point))))
        (rest (delete-and-extract-region (point) (line-end-position))))
    (insert "\n" indent rest))
  (back-to-indentation))
(defun my-tab ()
  (interactive)
  (if (use-region-p)
    (my-apply-on-region-lines #'my-indent)
    (my-indent)))
(defun my-shift-tab ()
  (interactive)
  (when (use-region-p)
    (my-apply-on-region-lines #'my-dedent)))
(defun my-backspace ()
  (interactive)
  (if (use-region-p)
    (delete-region (region-beginning) (region-end))
    (my-dedent)))
(defvar my-indent-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") 'my-newline)
    (define-key map (kbd "TAB") 'my-tab)
    (define-key map (kbd "<backtab>") 'my-shift-tab)
    (define-key map (kbd "<backspace>") 'my-backspace)
    map))
(define-minor-mode my-indent-mode
  "Minor mode for better indentation logic."
  :lighter " MyIndent"
  :keymap my-indent-mode-map)
(add-hook 'before-save-hook
          (lambda ()
            (delete-trailing-whitespace)
            (save-excursion
              (goto-char (point-max))
              (unless (looking-back "\n\n" nil)
                (insert "\n")))))
(add-hook 'c++-mode-hook
  (lambda ()
    (setq-local c-electric-flag nil)))
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
  (add-hook hook #'my-indent-mode))
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

