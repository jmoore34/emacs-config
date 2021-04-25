(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(eval-when-compile
  (require 'use-package))


(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package undo-tree
  :defer 7
  :config
  (global-undo-tree-mode))

(use-package jon
  :load-path "~/.emacs.d/jon/")

(use-package solarized-theme
  :defer t
  :config
  (load-theme 'solarized-zenburn t))


(use-package company
  :defer 5
  :bind
  (("M-/" . 'company-complete)
   ("C-<return>" . 'company-complete))
  :config
  (global-company-mode)
;; (setq company-idle-delay 0)
  )

(use-package eglot
  :defer 6
  :after (company)
  :bind
  (("C-c a" . 'eglot-code-actions)
   ("C-c ;" . 'eglot-rename)
   ("C-c d" . 'xref-find-definitions)
   ("C-c i" . 'eglot-find-implementation)
   ("C-c r" . 'xref-find-references)
   ("C-c l" . 'eglot-format))
  :config
  (advice-add 'eglot-eldoc-function :around
            (lambda (oldfun)
              (let ((help (help-at-pt-kbd-string)))
                (if help (message "%s" help) (funcall oldfun))))))

(use-package telephone-line
  :defer 5
  :if (window-system)
  :config
  (telephone-line-mode 1))

(use-package drag-stuff
  :defer 5
  :config
  (drag-stuff-global-mode 1)
  (drag-stuff-define-keys))

(use-package fix-word
  :defer 6
  :bind
  (("M-u" . 'fix-word-upcase)
   ("M-l" . 'fix-word-downcase)
   ("M-c" . 'fix-word-capitalize)))

(use-package ranger
  :defer 5
  :init
  (setq ranger-preview-file t)
  (setq ranger-dont-show-binary t)
  (setq ranger-max-preview-size 10)
  (setq ranger-width-preview 0.40)
  :config
  (ranger-override-dired-mode nil))

(use-package helm
  :defer 4
  :init
  (setq helm-display-function 'helm-display-buffer-in-own-frame
        helm-display-buffer-reuse-frame t
        helm-use-undecorated-frame-option t)
  :bind
  (("M-y" . 'helm-show-kill-ring)
   ("M-x" . 'helm-M-x)
   ("<menu>" . 'helm-M-x)
   ("<apps>" . 'helm-M-x)))

(use-package ivy
  :defer 4
  :init
  (setq ivy-re-builders-alist
	'((t . ivy--regex-plus)))
  :bind
  (("C-s" . 'swiper)
   ("C-x b" . 'ivy-switch-buffer)
   ("C-b" . 'ivy-switch-buffer)))

(use-package counsel
  :after (ivy)
  :bind
  ("C-x C-f" . 'counsel-find-file))
  
(use-package mic-paren
  :defer 5
  :config
  (paren-activate))



(use-package windswap
  :defer 5
  :bind
  (("C-S-<left>" . 'windmove-left)
  ("C-S-<right>" . 'windmove-right)
  ("C-S-<up>" . 'windmove-up)
  ("C-S-<down>" . 'windmove-down)
  ("C-M-S-<left>" . 'windswap-left)
  ("C-M-S-<right>" . 'windswap-right)
  ("C-M-S-<up>" . 'windswap-up)
  ("C-M-S-<down>" . 'windswap-down))
  :config
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
    (when buffer-file-name (save-buffer))))




(use-package multiple-cursors
  :defer 5
  :bind
  (("C->" . 'mc/mark-next-like-this)
   ("C-<" . 'mc/mark-previous-like-this)
   ("C-c C-a" . 'mc/mark-all-like-this)
   ("C-c C-e" . 'mc/edit-lines)))

(use-package expand-region
  :defer 5
  :bind
  (("C-=" . 'er/expand-region)
   ("M-=" . (lambda (arg) (interactive "p" (er/expand-region (- arg)))))))



(use-package windresize
  :defer 5
  :bind
  (("C-x w" . 'windresize)))

(global-set-key (kbd "C-;") #'comment-line)

(use-package magit
  :defer 5
  :bind
  (("C-x g" . 'magit-status)))


;; (use-package php-mode
  ;; :defer 6)


;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(solarized-zenburn))
 '(custom-safe-themes
   '("51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" default))
 '(diff-hl-flydiff-mode t)
 '(diff-hl-margin-mode t)
 '(electric-pair-mode t)
 '(helm-allow-mouse t)
 '(helm-frame-alpha 95)
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f")
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
     ("\\?\\?\\?+" . "#dc752f")))
 '(inhibit-startup-screen t)
 '(package-selected-packages '(php-mode use-package list-packages-ext ##))
 '(pdf-view-midnight-colors '("#b2b2b2" . "#292b2e"))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(yas-global-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "JetBrainsMono NF" :foundry "outline" :slant normal :weight normal :height 98 :width normal)))))

