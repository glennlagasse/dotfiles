
;; Disable chrome
(if (display-graphic-p)
    (progn
      (if (fboundp 'tooltip-mode) (tooltip-mode -1))
      (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
      (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1)))
  ;; Make tab key work in tty mode
  (local-set-key [tab] 'tab-to-tab-stop)
)

(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
;;(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("elpy" . "https://jorgenschaefer.github.io/packages/"))

;; (package-refresh-contents)

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

(use-package enh-ruby-mode
  :mode "\\.rb\\'"
  :config
    (setq enh-ruby-deep-indent-paren nil) ; Don't indent ruby function parameters at column index of function parentheses
    )

(use-package ruby-end)

(use-package robe
  :init
  (add-hook 'enh-ruby-mode-hook 'robe-mode)
  :config
  (push 'company-robe company-backends))

(use-package company
  :ensure t
  :defer t
  :init
  (global-company-mode)
  :config
  (setq company-idle-delay 0.2)
  (setq company-selection-wrap-around t)
  (define-key company-active-map [tab] 'company-complete)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

(use-package helm
  :ensure t
  :diminish helm-mode
  :config
  (helm-mode 1)
  (setq helm-buffers-fuzzy-matching t)
  (setq helm-autoresize-mode t)
  (setq helm-buffer-max-length 40)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
  (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
  (define-key helm-find-files-map (kbd "<C-backspace>") #'backward-kill-word)
  (define-key helm-map (kbd "S-SPC") 'helm-toggle-visible-mark)
  (define-key helm-find-files-map (kbd "C-k") 'helm-find-files-up-one-level))

(use-package elpy
  ;; pip install --user rope jedi flake8 importmagic autopep8 yapf
  :ensure t
  :config
  (progn
    (elpy-enable)))

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

;; Configure backups behaviour
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

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

(if (eq system-type 'darwin) ;; mac specific settings
    (progn
      (setq mac-option-modifier 'alt)
      (setq mac-command-modifier 'meta)
      ;;(global-set-key [kp-delete] 'delete-char) ;; sets fn-delete to be right-delete
      ))

(require 'cl)
(defun font-candidate (&rest fonts)
  "Return existing font which first match."
  (find-if (lambda (f) (find-font (font-spec :name f))) fonts))

;; I've got three screen sizes that I run on
;; Dell U2713HM- 2560x1440
;; Macbook Air - 1440x900
;; Dell Work Monitor - 1920x1080
;; I also use different platforms (Linux, OS X) and I want to set
;; a font and appropriate size based on which fonts are available on the
;; platform I happen to be running on as well as what screen I happen
;; to be using. The following lines figure that out.
;;
;; Find an appropriate font to use based on what the system provides
;; I always want to use Input Mono if available, if not fallback to
;; Inconsolata. If neither of those are found (perhaps I'm running on
;; OS X) then look for Menlo and then if all else fails use Monospace.
(setq gl/my-font-name (font-candidate "Input Mono" "Inconsolata" "Menlo" "Monospace"))

(defun choose-font-size (screen-pixel-height)
  "Figure out what font size to use"
  (cond ((eq 1080 screen-pixel-height) "14") ;; Dell Work Monitor
        ((eq 1440 screen-pixel-height) "14") ;; Dell U2713HM
        ((eq 900 screen-pixel-height) "16") ;; Macbook Air
        ((eq 600 screen-pixel-height) "12") ;; Acer Aspire One
        (t "12")))

;; Pick an appropriate size for my font based on the pixel width of the
;; screen I'm using.
;;(setq gl/my-font-spec (concat gl/my-font-name "-" (choose-font-size)))
(setq gl/my-font-spec (concat gl/my-font-name "-" (choose-font-size (display-pixel-height))))

(set-face-attribute 'default nil :font gl/my-font-spec)
(set-frame-font gl/my-font-spec)

;; It would be good to put this in the use-package declarartion for zenburn-theme
(custom-set-faces
 '(font-lock-comment-face ((t (:foreground "#7F9F7F" :slant italic :family gl/my-font-spec)))))
