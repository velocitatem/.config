(defun my-replace-newlines-with-spaces (beg end)
  "Replace all newlines with spaces in the region from BEG to END."
  (interactive "r")
  (save-excursion
    (goto-char beg)
    (while (search-forward "\n" end t)
      (replace-match " " nil t))))


(defun open-copilot ()
  (interactive)
  (define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
  (define-key copilot-completion-map (kbd "C-a") 'copilot-next-completion)
  (define-key evil-insert-state-map (kbd "<tab>") 'copilot-accept-completion-by-word)

  (setq my-header (concat " " (propertize "Copilot" 'face '(:foreground "white" :background "blue")) " "))
  (setq header-line-format '(:eval (substring my-header
                                              (min (length my-header)
                                                   (window-hscroll)))))

  (defun copilot--before-complete-hook ()
    (setq my-header (concat " " (propertize "Copilot" 'face '(:foreground "white" :background "red")) " "))
    )
  (defun copilot--after-complete-hook ()
    (setq my-header (concat " " (propertize "Copilot" 'face '(:foreground "white" :background "green")) " "))
    )

  )


(defun publish-website ()
  (interactive)
  (shell-command "cd /home/velocitatem/Documents/Me/personal-website/ && bash copy-notes.sh")

  (setq org-html-validation-link nil
        org-html-head-include-scripts t
        org-src-fontify-natively t
        org-html-htmlify-output-type 'css
        org-confirm-babel-evaluate nil
        org-html-head "<script src=\"tracking.js\"></script>")
  ;; Define the publishing project
  (setq org-publish-project-alist
        (list
        (list "my-org-site"
              :recursive t
              :base-directory "./content"
              :publishing-directory "./public"
              :publishing-function 'org-html-publish-to-html
              :with-author nil           ;; Don't include author name
              :with-creator nil            ;; Include Emacs and Org versions in footer
              :with-toc nil                ;; Include a table of contents
              :section-numbers nil       ;; Don't include section numbers
              :time-stamp-file nil)))
  ;; Generate the site output
  (org-publish-all t)
  ;; wait for the process to finish
  (while (get-process "org-publish-all")
    (sleep-for 1))

  (message "Build Complete")

  (magit-status "/home/velocitatem/Documents/Me/personal-website/" ))

(defun compile-and-run ()
  (interactive)
  (compile (concat "gcc -g " buffer-file-name " -o " (file-name-sans-extension buffer-file-name) " && " (file-name-sans-extension buffer-file-name)))
  ;; now we need to run the program, but also need to possible get the users input
  ;; so we need to run it in a terminal
  )

;; add hook to c-mode under C-c C-c
(add-hook 'c-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-c") 'compile-and-run)))



;; Jupyter notebok functionality ein
;; when I open any ipynb file if there is no server running in the directory already, start it up
;; also turn on undo tree mode and copilot mode
(add-hook 'ein:notebook-mode-hook
          (lambda ()
            (local-set-key (kbd "C-<return>") 'ein:worksheet-execute-cell-and-goto-next-km)
            (local-set-key (kbd "S-<return>") 'ein:worksheet-insert-cell-below-km)
            (local-set-key (kbd "C-S-<return>") 'ein:worksheet-insert-cell-above-km)
              ;; turn on undo tree mode
              (undo-tree-mode)
              ;; turn on copilot mode
              (open-copilot)
              ;; turn on flyspell mode
              (flyspell-mode)
              )

          )


(defun vterm-nushell ()
  "Open a new vterm buffer running Nushell."
  (interactive)
  (let ((vterm-buffer-name "*nushell*")
        (nushell-path "/home/velocitatem/.cargo/bin/nu"))
    (vterm)
    (vterm-send-string nushell-path)
    (vterm-send-return)))


;; gotta start ssh agent and add the key to it
;;  $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent.socket"
(defun start-ssh-agent ()
  (interactive)
  (setenv "SSH_AUTH_SOCK" (concat (getenv "XDG_RUNTIME_DIR") "/ssh-agent.socket"))
  ;; get password
  (shell-command "ssh-add -l || ssh-add")
  (message "SSH Agent started")

  )



(start-ssh-agent)


(setq mu4e-maildir "~/Maildir/gmail"
      mu4e-get-mail-command "mbsync -a"
      mu4e-update-interval 300
      mu4e-compose-signature-auto-include nil
      mu4e-view-show-images t
      mu4e-view-show-addresses t
      mu4e-compose-format-flowed t
      mu4e-drafts-folder "/[Gmail].Drafts"
      mu4e-sent-folder   "/[Gmail].Sent Mail"
      mu4e-refile-folder "/[Gmail].All Mail"
      mu4e-trash-folder  "/[Gmail].Trash")

(setq mu4e-maildir-shortcuts
      '( ("/Inbox"             . ?i)
         ("/[Gmail].Sent Mail" . ?s)
         ("/[Gmail].Trash"     . ?t)
         ("/[Gmail].Drafts"    . ?d)
         ("/[Gmail].All Mail"  . ?a)))


(require 'smtpmail)

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials (expand-file-name "~/.authinfo")
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info t)
