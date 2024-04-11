;; Package manager
(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; Install and configure packages
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(yasnippet verilog-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;; '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight normal :height 123 :width normal))))
;; '(font-lock-builtin-face ((t (:foreground "LightCoral"))))
;; '(font-lock-comment-delimiter-face ((t (:foreground "#969896"))))
;; '(font-lock-comment-face ((t (:foreground "green"))))
;; '(font-lock-constant-face ((t (:foreground "DarkOliveGreen3"))))
;; '(font-lock-function-name-face ((t (:foreground "red"))))
;; '(font-lock-keyword-face ((t (:foreground "tomato"))))
;; '(font-lock-negation-char-face ((t (:foreground "DeepSkyBlue"))))
;; '(font-lock-preprocessor-face ((t (:foreground "gold"))))
;; '(font-lock-regexp-grouping-backslash ((t (:foreground "#c397d8" :weight bold))))
;; '(font-lock-type-face ((t (:foreground "deep sky blue")))))
 )

;; Load verilog mode only when needed
(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
;; Any files that end in .v, .dv or .sv should be in verilog mode
(add-to-list 'auto-mode-alist '("\\.[ds]?va?h?\\'" . verilog-mode))
(add-hook 'verilog-mode-hook '(lambda () (font-lock-mode 1)))

;; Insert header
(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
  (yas-global-mode 1))

;; Write backups to ~/.emacs.d/backup/
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying      t  ; Don't de-link hard links
      version-control        t  ; Use version numbers on backups
      delete-old-versions    t  ; Automatically delete excess backups:
      kept-new-versions      20 ; how many of the newest versions to keep
      kept-old-versions      5) ; and how many of the old

;; Start-up options
(setq warning-minimum-level :emergency)
(setq frame-title-format "%b")
(setq inhibit-startup-screen t)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
(setq-default cursor-type 'bar)
(setq-default truncate-lines t)
(when window-system (set-frame-size (selected-frame) 160 48))
(add-hook 'before-save-hook 'my-prog-nuke-trailing-whitespace)
(defun my-prog-nuke-trailing-whitespace ()
  (when (derived-mode-p 'prog-mode)
    (delete-trailing-whitespace)))
(setq-default show-trailing-whitespace t)
;; (add-hook 'prog-mode-hook 'linum-mode) ; This function is considered obsolete as of version 29.1 (Read more https://www.emacswiki.org/emacs/LinumMode)
;; Change to this from Emacs 29.x version to show line number
;; Preset `nlinum-format' for minimum width.
;; Alternatively, to use it only in programming modes:
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
