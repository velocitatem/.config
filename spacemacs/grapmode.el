(defvar grap-font-lock-keywords
  (let* (
         ;; define several category of keywords
         (x-keywords '("mem" "io" "bits"))
         (x-constants '("save" "get" "say" "set" "unset" "flip" "and" "or" "xor" "not" "<<" ">>"))
         ;; generate regex string for each category of keywords
         (x-keywords-regexp (regexp-opt x-keywords 'words))
         (x-constants-regexp (regexp-opt x-constants 'words)))

    `(
      (,x-constants-regexp . font-lock-constant-face)
      (,x-keywords-regexp . font-lock-keyword-face)
      )))

(define-derived-mode grap-mode fundamental-mode
  "grap mode"
  "Major mode for editing Grap Language…"

  ;; code for syntax highlighting
  (setq font-lock-defaults '((grap-font-lock-keywords))))


;; setup C-c C-c to run grap {filename}
(defun grap-compile ()
  "Compile the current buffer"
  (interactive)
  (compile (concat "grap " (buffer-file-name))))

(define-key grap-mode-map (kbd "C-c C-c") 'grap-compile)

;; add the mode to the `features' list
(provide 'grap-mode)

;; Automatically use grap mode for .grap files
(add-to-list 'auto-mode-alist '("\\.grap\\'" . grap-mode))
