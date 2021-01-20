(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(load-theme 'wombat)

(defun transparency (opacity)
  "Set the window transparency
T: 0-100"
  (interactive "nopacity: ")
  (set-frame-parameter (selected-frame) 'alpha opacity)
  )

(set-frame-parameter (selected-frame) 'alpha 60)

(find-file "~/.emacs.d/init.el")
(switch-to-buffer "*scratch*")


;; Research
(setq revert-without-query (quote ("^obs(.org)?")))

;; Enable packages
;; Add opam emacs directory to you load paths:

;; Opam / BAP
(defun opam-path (path)
  (let ((opam-share-dir (ignore-errors (car (process-lines "opam" "config" "var" "share")))))
    (concat opam-share-dir "/" path)))
(add-to-list 'load-path (opam-path "emacs/site-lisp"))
;; load bap-emacs-goodies
(require 'bap-mode)
(require 'dot)

;; yasnippet
;; (yas-global-mode 1)

;; Togetherly
(require 'togetherly)

(global-undo-tree-mode)
;; (treemacs)

(add-hook 'org-mode-hook (lambda ()
			   (org-indent-mode)
			   (org-bullets-mode)
			   (local-set-key (kbd "C-<down>") #'org-forward-heading-same-level)
			   (local-set-key (kbd "C-<up>") #'org-backward-heading-same-level)
			   (local-set-key (kbd "C-S-<left>") #'windmove-left)
			   (local-set-key (kbd "C-S-<right>") #'windmove-right)
			   (local-set-key (kbd "C-S-<up>") #'windmove-up)
			   (local-set-key (kbd "C-S-<down>") #'windmove-down)
			   (local-set-key (kbd "C-M-<right>") #'org-ctrl-c-star)
			   ))


(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.[tj]sx?\\'" . web-mode))


(require 'eglot)
;; (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
(add-to-list 'eglot-server-programs '(python-mode . ("pyls")))

;; (add-to-list 'eglot-server-programs '((c++-mode c-mode) "/home/Jon/build2/bin/clangd")) 
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'python-mode-hook 'eglot-ensure)

(add-hook 'prog-mode-hook 'linum-mode)

(require 'company)
(global-set-key (kbd "M-/") #'company-complete)
;; (setq company-idle-delay 0)
;; (setq company-minimum-prefix-length 2)
(add-hook 'after-init-hook 'global-company-mode)
;; Fuzzy company
;; (global-company-fuzzy-mode 1)


(advice-add 'eglot-eldoc-function :around
            (lambda (oldfun)
              (let ((help (help-at-pt-kbd-string)))
                (if help (message "%s" help) (funcall oldfun)))))


;; Telephone line (powerline)
(require 'telephone-line)
(telephone-line-mode 1)
;; Forge (magit addon)
(with-eval-after-load 'magit
  (require 'forge))


;; Ranger
(ranger-override-dired-mode nil)
(setq ranger-preview-file t)
(setq ranger-dont-show-binary t)
(setq ranger-max-preview-size 10)
(setq ranger-width-preview 0.40)


;; Helm
(setq helm-display-function 'helm-display-buffer-in-own-frame
        helm-display-buffer-reuse-frame t
        helm-use-undecorated-frame-option t)

;; Ivy
(setq ivy-re-builders-alist
      '((t . ivy--regex-plus)))


;; Rainbow delimiters
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)


;; Projectile
;;(setq projectile-completion-system 'ivy)
;;(define-key projectile-mode-map (kbd "M-p") 'projectile-command-map)

;; Mic-paren
(paren-activate)     ; activating

;; Autosave (#)
(add-hook 'focus-out-hook 'save-buffer)
(auto-save-visited-mode)
(setq compilation-ask-about-save nil)
;; automatically save buffers associated with files on buffer switch
;; and on windows switch
;; https://batsov.com/articles/2012/03/08/emacs-tip-number-5-save-buffers-automatically-on-buffer-or-window-switch/
(defadvice switch-to-buffer (before save-buffer-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice other-window (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-up (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-down (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-left (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-right (before other-window-now activate)
  (when buffer-file-name (save-buffer)))


;; Backups (~)
;; https://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files
(setq backup-directory-alist `(("." . "~/.saves"))
     backup-by-copying :true
     delete-old-versions :true
     kept-new-versions 6
     kept-old-versions 2
     version-contol :true)

;; Key Bindings


;; Corral
(global-set-key (kbd "M-9") 'corral-parentheses-backward)
(global-set-key (kbd "M-0") 'corral-parentheses-forward)
(global-set-key (kbd "M-[") 'corral-brackets-backward)
(global-set-key (kbd "M-]") 'corral-brackets-forward)
(global-set-key (kbd "M-{") 'corral-braces-backward)
(global-set-key (kbd "M-}") 'corral-braces-forward)
(global-set-key (kbd "M-\"") 'corral-double-quotes-backward)

;; Helm
(global-set-key (kbd "M-y") #'helm-show-kill-ring)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "<menu>") #'helm-M-x)

;; Ivy
(global-set-key (kbd "C-x B") #'ivy-push-view)
(global-set-key (kbd "C-s") #'swiper)
(global-set-key (kbd "C-x b") #'ivy-switch-buffer)
(global-set-key (kbd "C-b") #'ivy-switch-buffer) ; overwrite
(global-set-key (kbd "C-x C-f") #'counsel-find-file)

;; window management
;; (global-set-key (kbd "C-o") #'(lambda () (interactive) (other-window 1)))
(global-set-key (kbd "M-o") #'(lambda () (interactive) (other-window -1))) ;overwrite
(global-set-key (kbd "C-q") #'delete-window) ;overwrite
(global-set-key (kbd "M-q") #'(lambda () (interactive) (kill-buffer (current-buffer)))) ;overwrite
(global-set-key (kbd "M-'") #'quoted-insert) ;overwrite

(global-set-key (kbd "M-k") #'kill-whole-line) ;overwrite
(global-set-key (kbd "C-x M-s") #'save-all)   ;overwrite
(global-set-key (kbd "C-h a") #'apropos)   ;overwrite
(global-set-key (kbd "M-z") #'zap-up-to-char)  ;overwrite

(define-key key-translation-map (kbd "<escape>") (kbd "C-g"))

;; transpose lines
(global-set-key (kbd "<M-up>") #'move-line-up)
(global-set-key (kbd "<M-down>") #'move-line-down)
;; treemacs
(global-set-key (kbd "C-x d") #'treemacs)
;; multiple cursors
(global-set-key (kbd "C-c C-e") #'mc/edit-lines)
(global-set-key (kbd "C->") #'mc/mark-next-like-this)
(global-set-key (kbd "C-c M->") #'mc/mark-skip-next-like-this)
(global-set-key (kbd "C-<") #'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-a") #'mc/mark-all-like-this)
;; quick compile
(global-set-key (kbd "C-c b") #'compile)
(global-set-key (kbd "C-c B") #'recompile)
;; expand region
(global-set-key (kbd "C-=") #'er/expand-region)
(global-set-key (kbd "M-=") (lambda (arg) (interactive "p") (er/expand-region (- arg))))


(global-set-key (kbd "C-x w") #'windresize)
(global-set-key (kbd "C-;") #'comment-line)

(global-set-key (kbd "C-x g") #'magit-status)

(global-set-key (kbd "C-S-<left>") #'windmove-left)
(global-set-key (kbd "C-S-<right>") #'windmove-right)
(global-set-key (kbd "C-S-<up>") #'windmove-up)
(global-set-key (kbd "C-S-<down>") #'windmove-down)


;; Eglot bindings
(global-set-key (kbd "C-c a") #'eglot-code-actions)
(global-set-key (kbd "C-c ;") #'eglot-rename)
(global-set-key (kbd "C-c d") #'xref-find-definitions)
(global-set-key (kbd "C-c i") #'eglot-find-implementation)
(global-set-key (kbd "C-c r") #'xref-find-references)
(global-set-key (kbd "C-c l") #'eglot-format)



;; Semantic refactor bindings
(require 'srefactor)
(require 'srefactor-lisp)

;; OPTIONAL: ADD IT ONLY IF YOU USE C/C++. 
(semantic-mode 1) ;; -> this is optional for Lisp

(define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
(define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
(global-set-key (kbd "M-RET o") 'srefactor-lisp-one-line)
(global-set-key (kbd "M-RET m") 'srefactor-lisp-format-sexp)
(global-set-key (kbd "M-RET d") 'srefactor-lisp-format-defun)
(global-set-key (kbd "M-RET b") 'srefactor-lisp-format-buffer)



;;;;;; Custom open shell keybindings
(global-set-key (kbd "C-c <left>") #'(lambda () (interactive) (my-display-buffer (shell-get-buffer-create) nil 'left)))
(global-set-key (kbd "C-c <right>") #'(lambda () (interactive) (my-display-buffer (shell-get-buffer-create) nil 'right)))
(global-set-key (kbd "C-c <up>") #'(lambda () (interactive) (my-display-buffer (shell-get-buffer-create) nil 'above)))
(global-set-key (kbd "C-c <down>") #'(lambda () (interactive) (my-display-buffer (shell-get-buffer-create) nil 'below)))
(global-set-key
 (kbd "C-c c")
 (lambda ()
   (interactive)
   (let ((current-prefix-arg '(4)))
     (call-interactively #'shell))))

;; Shell fix to allow for clearing with C-l
(add-hook 'comint-mode-hook
          (defun rm-comint-postoutput-scroll-to-bottom ()
            (remove-hook 'comint-output-filter-functions
                         'comint-postoutput-scroll-to-bottom)))

;; Shell fix to use bash aliases
(setq shell-file-name "bash")
(setq shell-command-switch "-ic")

;; Terminal fixes
(add-hook 'term-mode-hook
   (lambda ()
     ;; C-x is the prefix command, rather than C-c
     (term-set-escape-char ?\C-x)
     (define-key term-raw-map "\M-y" 'yank-pop)
     (define-key term-raw-map "\M-w" 'kill-ring-save)))

;; Linux only -- dirtrack mode
(require 'dirtrack) ;change the method used to determine the current directory in a shell
(add-hook 'shell-mode-hook
          (lambda ()
            (shell-dirtrack-mode 0) ;stop the usual shell-dirtrack mode
            (setq dirtrack-list '("^[^:]+:\\([^\\$#]+\\)[\\$#]" 1)) 
            ;(dirtrack-debug-mode) ;this shows any change in directory that dirtrack mode sees
            (dirtrack-mode))) ;enable the more powerful dirtrack mode



;; Charles's custom functions

(defun save-all ()
  "Save all buffers."
  (interactive)
  (message "Saving all changes...")
  (if (save-some-buffers t)
      (message "Saved")
             (message "(No changes need to be saved)")))

(defun move-line-up ()
       "Swap the line at point with the previous line."
       (interactive)
       (beginning-of-line)
       (unless (bobp)
         (next-line)
         (transpose-lines -1)
         (previous-line))
       (end-of-line nil))
     (defun move-line-down ()
       "Swap the line at point with the next line."
       (interactive)
       (next-line)
       (transpose-lines 1)
       (previous-line)
       (end-of-line nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom functions for opening shell
;; a la https://emacs.stackexchange.com/questions/28909/how-i-can-open-shell-in-current-buffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'shell)

(defun shell-get-buffer-create (&optional buffer)
  "Run an inferior shell, with I/O through BUFFER (which defaults to `*shell*').
Interactively, a prefix arg means to prompt for BUFFER.
If `default-directory' is a remote file name, it is also prompted
to change if called with a prefix arg.

If BUFFER exists but shell process is not running, make new shell.
If BUFFER exists and shell process is running, just switch to BUFFER.
Program used comes from variable `explicit-shell-file-name',
 or (if that is nil) from the ESHELL environment variable,
 or (if that is nil) from `shell-file-name'.
If a file `~/.emacs_SHELLNAME' exists, or `~/.emacs.d/init_SHELLNAME.sh',
it is given as initial input (but this may be lost, due to a timing
error, if the shell discards input when it starts up).
The buffer is put in Shell mode, giving commands for sending input
and controlling the subjobs of the shell.  See `shell-mode'.
See also the variable `shell-prompt-pattern'.

To specify a coding system for converting non-ASCII characters
in the input and output to the shell, use \\[universal-coding-system-argument]
before \\[shell].  You can also specify this with \\[set-buffer-process-coding-system]
in the shell buffer, after you start the shell.
The default comes from `process-coding-system-alist' and
`default-process-coding-system'.

The shell file name (sans directories) is used to make a symbol name
such as `explicit-csh-args'.  If that symbol is a variable,
its value is used as a list of arguments when invoking the shell.
Otherwise, one argument `-i' is passed to the shell.

\(Type \\[describe-mode] in the shell buffer for a list of commands.)"
  (interactive
   (list
    (and current-prefix-arg
   (prog1
       (read-buffer "Shell buffer: "
        ;; If the current buffer is an inactive
        ;; shell buffer, use it as the default.
        (if (and (eq major-mode 'shell-mode)
           (null (get-buffer-process (current-buffer))))
            (buffer-name)
          (generate-new-buffer-name "*shell*")))
     (if (file-remote-p default-directory)
         ;; It must be possible to declare a local default-directory.
               ;; FIXME: This can't be right: it changes the default-directory
               ;; of the current-buffer rather than of the *shell* buffer.
         (setq default-directory
         (expand-file-name
          (read-directory-name
           "Default directory: " default-directory default-directory
           t nil))))))))
  (setq buffer (if (or buffer (not (derived-mode-p 'shell-mode))
                       (comint-check-proc (current-buffer)))
                   (get-buffer-create (or buffer "*shell*"))
                 ;; If the current buffer is a dead shell buffer, use it.
                 (current-buffer)))

  ;; On remote hosts, the local `shell-file-name' might be useless.
  (if (and (called-interactively-p 'any)
     (file-remote-p default-directory)
     (null explicit-shell-file-name)
     (null (getenv "ESHELL")))
      (with-current-buffer buffer
  (set (make-local-variable 'explicit-shell-file-name)
       (file-remote-p
        (expand-file-name
         (read-file-name
    "Remote shell path: " default-directory shell-file-name
    t shell-file-name))
        'localname))))

  ;; The buffer's window must be correctly set when we call comint (so
  ;; that comint sets the COLUMNS env var properly).
  (with-current-buffer buffer
    (unless (comint-check-proc buffer)
      (let* ((prog (or explicit-shell-file-name
           (getenv "ESHELL") shell-file-name))
       (name (file-name-nondirectory prog))
       (startfile (concat "~/.emacs_" name))
       (xargs-name (intern-soft (concat "explicit-" name "-args"))))
        (unless (file-exists-p startfile)
    (setq startfile (concat user-emacs-directory "init_" name ".sh")))
        (apply 'make-comint-in-buffer "shell" buffer prog
         (if (file-exists-p startfile) startfile)
         (if (and xargs-name (boundp xargs-name))
       (symbol-value xargs-name)
           '("-i")))
        (shell-mode))))
  buffer)

(defun my-display-buffer (buffer alist direction &optional size pixelwise)
"BUFFER:  The buffer that will be displayed.
ALIST:  See the doc-string of `display-buffer' for more information.
DIRECTION:  Must use one of these symbols:  'left 'right 'below 'above
SIZE:  See the doc-string for `split-window'.
PIXELWISE:  See the doc-string for `split-window'.
There are three possibilities:
-  (1) If a window on the frame already displays the target buffer,
then just reuse the same window.
-  (2) If there is already a window in the specified direction in relation
to the selected window, then display the target buffer in said window.
-  (3) If there is no window in the specified direction, then create one
in that direction and display the target buffer in said window."
  (let ((window
          (cond
            ((get-buffer-window buffer (selected-frame)))
            ((window-in-direction direction))
            (t
              (split-window (selected-window) size direction pixelwise)))))
    (window--display-buffer buffer window 'window alist display-buffer-mark-dedicated)
    window))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (solarized-zenburn)))
 '(custom-safe-themes
   (quote
    ("51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" default)))
 '(diff-hl-flydiff-mode t)
 '(diff-hl-margin-mode t)
 '(electric-pair-mode t)
 '(helm-allow-mouse t)
 '(helm-frame-alpha 95)
 '(hl-todo-keyword-faces
   (quote
    (("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#4f97d7")
     ("OKAY" . "#4f97d7")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#86dc2f")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f"))))
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (yafolding counsel-projectile projectile corral ranger togetherly org-bullets list-packages-ext tuareg web-mode spacemacs-theme solarized-theme mic-paren perspective workgroups2 company-fuzzy flx counsel ivy eyebrowse srefactor helm browse-kill-ring realgud forge diff-hl git-gutter telephone-line ## yasnippet yasnippet-snippets undo-tree spaceline rainbow-delimiters magit windresize treemacs multiple-cursors expand-region eglot company)))
 '(pdf-view-midnight-colors (quote ("#b2b2b2" . "#292b2e")))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(yas-global-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

