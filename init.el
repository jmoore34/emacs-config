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


;; Enable packages

;; yasnippet
;; (yas-global-mode 1)

(global-undo-tree-mode)
(treemacs)



(require 'eglot)
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
(add-to-list 'eglot-server-programs '(python-mode . ("pyls")))

;; (add-to-list 'eglot-server-programs '((c++-mode c-mode) "/home/Jon/build2/bin/clangd")) 
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'python-mode-hook 'eglot-ensure)


(require 'company)
(global-set-key (kbd "M-/") #'company-complete)
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
(ranger-override-dired-mode t)
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

;; Key Bindings

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


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-hl-flydiff-mode t)
 '(diff-hl-margin-mode t)
 '(electric-pair-mode t)
 '(helm-allow-mouse t)
 '(helm-frame-alpha 95)
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (perspective workgroups2 company-fuzzy flx counsel ivy eyebrowse srefactor ranger helm browse-kill-ring realgud forge diff-hl git-gutter telephone-line ## yasnippet yasnippet-snippets undo-tree spaceline rainbow-delimiters magit windresize treemacs multiple-cursors expand-region eglot company)))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(yas-global-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

