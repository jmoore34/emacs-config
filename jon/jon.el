(tool-bar-mode 0)
(menu-bar-mode 0)

;; (load-theme 'wombat)

(defun transparency (opacity)
  "Set the window transparency
T: 0-100"
  (interactive "nopacity: ")
  (set-frame-parameter (selected-frame) 'alpha opacity)
  )

(set-frame-parameter (selected-frame) 'alpha 97)

(find-file "~/.emacs.d/init.el")
(find-file "~/.emacs.d/jon/jon.el")

(defun candl ()
  (interactive)
  ;; (find-file "/plink:jtm170330@ctf-vm1.utdallas.edu:/home/jtm170330/.bashrc")
  ;; (find-file "/plink:jtm170330@ctf-vm1.utdallas.edu:/home/jtm170330"))
  (find-file "/plink:jtm170330@ctf-vm1.syssec.run#2221:/home/jtm170330/.bashrc")
  (find-file "/plink:jtm170330@ctf-vm1.syssec.run#2221:/home/jtm170330"))

(defun candl2 ()
  (interactive)
  ;; (find-file "/plink:jtm170330@ctf-vm2.utdallas.edu:/home/jtm170330/.bashrc")
  ;; (find-file "/plink:jtm170330@ctf-vm2.utdallas.edu:/home/jtm170330"))
  (find-file "/plink:jtm170330@ctf-vm2.syssec.run#2222:/home/jtm170330/.bashrc")
  (find-file "/plink:jtm170330@ctf-vm2.syssec.run#2222:/home/jtm170330"))

(defun candl3 ()
  (interactive)
  (find-file "/plink:jtm170330@fiona.utdallas.edu:/home/jtm170330/"))

(switch-to-buffer "*scratch*")

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


(add-hook 'prog-mode-hook 'linum-mode)

;; linum fix
(eval-after-load "linum"
  '(set-face-attribute 'linum nil :height 100))

;; Autosave (#)
;; (add-hook 'focus-out-hook 'save-buffer)
(auto-save-visited-mode)
(setq compilation-ask-about-save nil)
;; automatically save buffers associated with files on buffer switch
;; and on windows switch
;; https://batsov.com/articles/2012/03/08/emacs-tip-number-5-save-buffers-automatically-on-buffer-or-window-switch/

;; Backups (~)
;; https://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files
;; (setq backup-directory-alist `(("." . "~/.saves"))
     ;; backup-by-copying :true
     ;; delete-old-versions :true
     ;; kept-new-versions 6
     ;; kept-old-versions 2
     ;; version-contol :true)
(defvar --backup-directory (concat user-emacs-directory "backups"))
(if (not (file-exists-p --backup-directory))
        (make-directory --backup-directory t))
(setq backup-directory-alist `(("." . ,--backup-directory)))
(setq make-backup-files t               ; backup of a file the first time it is saved.
      backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      delete-by-moving-to-trash t
      kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t               ; auto-save every buffer that visits a file
      auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
      )



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



;; quick compile
(global-set-key (kbd "C-c b") #'compile)
(global-set-key (kbd "C-c B") #'recompile)

;; Shell fix to allow for clearing with C-l
(add-hook 'comint-mode-hook
          (defun rm-comint-postoutput-scroll-to-bottom ()
            (remove-hook 'comint-output-filter-functions
                         'comint-postoutput-scroll-to-bottom)))



;; Shell fix to use bash aliases
;; (setq shell-file-name "bash")
;; (setq shell-command-switch "-ic")


;; Terminal fixes
;; TODO: Helm yank ring integration
(add-hook 'term-mode-hook
   (lambda ()
     ;; C-x is the prefix command, rather than C-c
     (term-set-escape-char ?\C-x)
     (define-key term-raw-map "\M-y" 'yank-pop)
     (define-key term-raw-map "\M-w" 'kill-ring-save)))

;; (use-package dirtrack
  ;; :if (eq system-type 'gnu/linux)
  ;; :defer t
  ;; :config
  ;; (add-hook 'shell-mode-hook
            ;; (lambda ()
              ;; (shell-dirtrack-mode 0) ;stop the usual shell-dirtrack mode
              ;; (setq dirtrack-list '("^[^:]+:\\([^\\$#]+\\)[\\$#]" 1)) 
					;; (dirtrack-debug-mode) ;this shows any change in directory that dirtrack mode sees
              ;; (dirtrack-mode)))) ;enable the more powerful dirtrack mode


;; Charles's custom functions

(defun save-all ()
  "Save all buffers."
  (interactive)
  (message "Saving all changes...")
  (if (save-some-buffers t)
      (message "Saved")
             (message "(No changes need to be saved)")))



(global-set-key
 (kbd "C-c c")
 (lambda ()
   (interactive)
   (let ((current-prefix-arg '(4)))
     (call-interactively #'shell))))


;; ligatures
(defconst jetbrains-ligature-mode--ligatures
   '("-->" "//" "/**" "/*" "*/" "<!--" ":=" "->>" "<<-" "->" "<-"
     "<=>" "==" "!=" "<=" ">=" "=:=" "!==" "&&" "||" "..." ".."
     "|||" "///" "&&&" "===" "++" "--" "=>" "|>" "<|" "||>" "<||"
     "|||>" "<|||" ">>" "<<" "::=" "|]" "[|" "{|" "|}"
     "[<" ">]" ":?>" ":?" "/=" "[||]" "!!" "?:" "?." "::"
     "+++" "??" "###" "##" ":::" "####" ".?" "?=" "=!=" "<|>"
     "<:" ":<" ":>" ">:" "<>" "***" ";;" "/==" ".=" ".-" "__"
     "=/=" "<-<" "<<<" ">>>" "<=<" "<<=" "<==" "<==>" "==>" "=>>"
     ">=>" ">>=" ">>-" ">-" "<~>" "-<" "-<<" "=<<" "---" "<-|"
     "<=|" "/\\" "\\/" "|=>" "|~>" "<~~" "<~" "~~" "~~>" "~>"
     "<$>" "<$" "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</>" "</" "/>"
     "<->" "..<" "~=" "~-" "-~" "~@" "^=" "-|" "_|_" "|-" "||-"
     "|=" "||=" "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#="
     "&="))

(sort jetbrains-ligature-mode--ligatures (lambda (x y) (> (length x) (length y))))

(dolist (pat jetbrains-ligature-mode--ligatures)
  (set-char-table-range composition-function-table
                      (aref pat 0)
                      (nconc (char-table-range composition-function-table (aref pat 0))
                             (list (vector (regexp-quote pat)
                                           0
                                    'compose-gstring-for-graphic)))))

(provide 'jon)
