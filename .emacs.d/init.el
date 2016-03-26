(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
;; (package-refresh-contents)

(setq package-enable-at-startup nil)
(package-initialize)

(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; Activate installed packages
(package-initialize)

;; Ensure my packages are installed
(ensure-package-installed 'evil
			  'zenburn-theme
			  'muttrc-mode
			  'vimrc-mode
			  'molokai-theme)

;; Set default font to my liking
(set-face-attribute 'default nil :font "Input Mono-13")
(set-frame-font "Input Mono-13")

;; Enable evil-mode
(require 'evil)
(evil-mode t)

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("b571f92c9bfaf4a28cb64ae4b4cdbda95241cd62cf07d942be44dc8f46c491f4" "38ba6a938d67a452aeb1dada9d7cdeca4d9f18114e9fc8ed2b972573138d4664" "705f3f6154b4e8fac069849507fd8b660ece013b64a0a31846624ca18d6cf5e1" "708df3cbb25425ccbf077a6e6f014dc3588faba968c90b74097d11177b711ad1" default)))
 '(global-font-lock-mode t))

;; Set my theme
(load-theme 'zenburn)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:foreground "#7F9F7F" :slant italic :family "Input Mono")))))

;; Load muttrc-mode when editing muttrc file
(setq auto-mode-alist
      (append '(("muttrc\\'" . muttrc-mode))
	      auto-mode-alist))
