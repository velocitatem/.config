(require 'ox-publish)
(require 'ox-html)
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
  (compile (concat "g++ -std=c++20 " buffer-file-name " -o " (file-name-sans-extension buffer-file-name) " && " (file-name-sans-extension buffer-file-name)))
  ;; now we need to run the program, but also need to possible get the users input
  ;; so we need to run it in a terminal
  )
