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

(global-undo-tree-mode)
(treemacs)

(require 'company)
(global-company-mode 1)
(global-set-key (kbd "M-/") #'company-complete)
(add-hook 'after-init-hook 'global-company-mode)

(require 'eglot)
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
;; (add-to-list 'eglot-server-programs '((c++-mode c-mode) "/home/Jon/build2/bin/clangd")) 
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

(advice-add 'eglot-eldoc-function :around
            (lambda (oldfun)
              (let ((help (help-at-pt-kbd-string)))
                (if help (message "%s" help) (funcall oldfun)))))



;; Key Bindings

;; window management
(global-set-key (kbd "C-o") #'(lambda () (interactive) (other-window 1)))
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
(global-set-key (kbd "C-c M-e") #'mc/edit-lines)
(global-set-key (kbd "C->") #'mc/mark-next-like-this)
(global-set-key (kbd "C-c M->") #'mc/mark-skip-next-like-this)
(global-set-key (kbd "C-<") #'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-a") #'mc/mark-all-like-this)
;; quick compile
(global-set-key (kbd "ESC <f5>") #'compile)
(global-set-key (kbd "<f5>") #'recompile)
;; expand region
(global-set-key (kbd "C-=") #'er/expand-region)

(global-set-key (kbd "C-x w") #'windresize)
(global-set-key (kbd "C-;") #'comment-line)

(global-set-key (kbd "C-x g") #'magit-status)

(global-set-key (kbd "C-S-<left>") #'windmove-left)
(global-set-key (kbd "C-S-<right>") #'windmove-right)
(global-set-key (kbd "C-S-<up>") #'windmove-up)
(global-set-key (kbd "C-S-<down>") #'windmove-down)

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
 '(electric-pair-mode t)
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (magit windresize treemacs multiple-cursors expand-region eglot company)))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
