(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
;; (package-refresh-contents)

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

(use-package evil
  :ensure t
  :config
  (progn
    (setq evil-default-cursor t)
    (evil-mode 1)))

(use-package magit
  :ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("316d29f8cd6ca980bf2e3f1c44d3a64c1a20ac5f825a167f76e5c619b4e92ff4" default))))

(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

(use-package muttrc-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("muttrc\\'" . muttrc-mode)))

(use-package vimrc-mode
  :ensure t)

;; Set default font to my liking
(set-face-attribute 'default nil :font "Input Mono-13")
(set-frame-font "Input Mono-13")

;; Configure backups behaviour
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; Disable chrome
(when window-system
  (tooltip-mode -1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1))

;; Display day/time/date
(setq display-time-day-and-date t)
(display-time-mode 1)

(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message "glagasse")

;; Sentences end with a single space
(setq sentence-end-double-space nil)

;; Change "yes or no" to "y or n"
(fset 'yes-or-no-p 'y-or-n-p)

;; New lines are always indented
(global-set-key (kbd "RET") 'newline-and-indent)

(column-number-mode 1)
(show-paren-mode 1)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:foreground "#7F9F7F" :slant italic :family "Input Mono")))))
