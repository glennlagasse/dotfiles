;;; init.el -- My Emacs configuration
;-*-Emacs-Lisp-*-

;;; Commentary:
;;
;; I have nothing substantial to say here.
;;
;;; Code:

(require 'package)

(setq package-enable-at-startup nil) ; tells emacs not to load any packages before starting up

;;
;; The following lines tell emacs where on the internet to look for
;; new packages.
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "https://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package) ; unless it is already installed
  (package-refresh-contents) ; updage packages archive
  (package-install 'use-package)) ; and install the most recent version of use-package

(require 'use-package)

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

(setq user-full-name "Glenn Lagasse"
      user-mail-address "glagasse@glagasse.org")

(setq delete-old-versions -1)           ; delete excess backup versions silently
(setq version-control t )               ; use version control
(setq vc-make-backup-files t)		; make backups file even when in version controlled dir
(setq backup-directory-alist
      `(("." . "~/.emacs.d/backups")))  ; which directory to put backups file
(setq vc-follow-symlinks t)             ; don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/auto-save-list/" t))) ;transform backups file name
(setq inhibit-startup-screen t)	        ; inhibit useless and old-school startup screen
(setq ring-bell-function 'ignore)       ; silent bell when you make a mistake
(setq coding-system-for-read 'utf-8)    ; use utf-8 by default
(setq coding-system-for-write 'utf-8)
(setq sentence-end-double-space nil)    ; sentence SHOULD end with only a point.
(setq fill-column 80)                   ; toggle wrapping text at the 80th character
(run-at-time nil (* 5 60) 'recentf-save-list) ; update recent files list every 5 minutes
(global-auto-revert-mode t)             ; automatically reload buffer from disk when changed
(global-linum-mode)

;; Better scroll settings (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; Make files that start with !# executable on save
(add-hook 'after-save-hook
          #'executable-make-buffer-file-executable-if-script-p)

(use-package general :ensure t)

;; Define keys without a prefix
(general-define-key
  :states '(normal visual emacs)
  ;; replace default keybindings
  "/" 'swiper
  "M-x" 'counsel-M-x        ; replace default M-x with ivy backend
)

;; Define keys with a prefix
(general-define-key
  :states '(normal visual emacs)
  :prefix "SPC"
  "n" '(linum-relative-toggle)
  "fe" '(counsel-find-file)
  "fr" '(counsel-recentf)
  "bb" '(ivy-switch-buffer)
  "bd" '(kill-this-buffer)
  "w/" '(split-window-horizontally)
  "wj" '(evil-window-down)
  "wk" '(evil-window-up)
  "wh" '(evil-window-left)
  "wl" '(evil-window-right)
  "wd" '(delete-window)
)

(use-package linum-relative
  :ensure t
  )

(use-package which-key :ensure t
  :config
  (setq which-key-idle-delay 0.5)
  :init
  (which-key-mode)
  :diminish which-key-mode
)

(use-package company :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode))

(use-package ivy
  :ensure t
  :diminish (ivy-mode . "") ; does not display ivy in the modeline
  :init (ivy-mode 1)        ; enable ivy globally at startup
  :bind (:map ivy-mode-map  ; bind in the ivy buffer
         ("C-'" . ivy-avy)) ; C-' to ivy-avy
  :config
  (setq ivy-use-virtual-buffers t)   ; extend searching to bookmarks and …
  (setq ivy-height 20)               ; set height of the ivy window
  (setq ivy-count-format "(%d/%d) ") ; count format, from the ivy help page
  )

(use-package counsel :ensure t)

(use-package evil
  :ensure t
  :config
  (progn
    (setq evil-default-cursor t)
    (evil-mode 1)))

(use-package magit
  :ensure t)

(defmacro rename-modeline (package-name mode new-name)
  "For PACKAGE-NAME, rename MODE to NEW-NAME."
  `(eval-after-load ,package-name
     '(defadvice ,mode (after rename-modeline activate)
        (setq mode-name ,new-name))))

(use-package enh-ruby-mode :ensure t
  :mode
  (("Capfile" . enh-ruby-mode)
   ("Gemfile\\'" . enh-ruby-mode)
   ("Rakefile" . enh-ruby-mode)
   ("Vagrantfile" . enh-ruby-mode)
   ("\\.rb" . enh-ruby-mode)
   ("\\.ru" . enh-ruby-mode))
  :init
  (rename-modeline "enh-ruby-mode" enh-ruby-mode "Ruby")
)

(use-package smart-mode-line
  :ensure t
  :init
  (smart-mode-line-enable)
  :diminish
  :config
  (progn
    (setq sml/no-confirm-load-theme t)
    (sml/setup)
    )
  )

(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t)
  )

(use-package solarized-theme
  :ensure t
  ;:config
  ;(load-theme 'solarized-dark t)
  )

(use-package muttrc-mode
  :ensure t
  :defer t
  :mode "muttrc\\'"
  )

(use-package vimrc-mode
  :ensure t
  :defer t)

(use-package rainbow-delimiters
  :ensure t
  :diminish
  :defer t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
)

(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :config
  (add-hook 'prog-mode-hook (lambda () (flycheck-mode)))
)

(use-package flycheck-color-mode-line
  :ensure t
  :defer t
  :config
  (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)
)

(use-package yaml-mode
  :ensure t
  :defer t
  :diminish
)

;; Display day/time/date
(setq display-time-day-and-date t)
(display-time-mode 1)

(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message "glagasse")

;; Change "yes or no" to "y or n"
(fset 'yes-or-no-p 'y-or-n-p)

;; New lines are always indented
(global-set-key (kbd "RET") 'newline-and-indent)

(column-number-mode 1)

(setq show-paren-delay 0)
(show-paren-mode 1)

;; Mac specific settings
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta)
  (custom-set-variables '(epg-gpg-program  "/usr/local/bin/gpg2"))

  (defun iterm-focus ()
    (interactive)
    (do-applescript
     " do shell script \"open -a iTerm\"\n"
     ))

  (general-define-key
   :states '(normal visual emacs)
   :prefix "SPC"
   "'" '(iterm-focus :which-key "focus iterm")
    ;;"?" '(iterm-goto-filedir-or-home :which-key "focus iterm - goto dir")
    )
)
  
(require 'cl-lib)
(defun font-candidate (&rest fonts)
  "Return existing FONTS which first match."
  (cl-find-if (lambda (f) (find-font (font-spec :name f))) fonts))

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
(defvar gl/my-font-name (font-candidate "Input Mono" "Inconsolata" "Menlo" "Monospace"))

(defun choose-font-size (screen-pixel-height)
  "Figure out what font size to use based on SCREEN-PIXEL-HEIGHT."
  (cond ((eq 1080 screen-pixel-height) "18") ;; Dell Work Monitor
        ((eq 1440 screen-pixel-height) "14") ;; Dell U2713HM
        ((eq 900 screen-pixel-height) "18") ;; Macbook Air
        ((eq 600 screen-pixel-height) "12") ;; Acer Aspire One
        (t "12")))

;; Pick an appropriate size for my font based on the pixel width of
;; the screen I'm using.
(defvar gl/my-font-spec (concat gl/my-font-name "-"
				(choose-font-size (display-pixel-height))))

(set-face-attribute 'default nil :font gl/my-font-spec)
(set-frame-font gl/my-font-spec)

(provide 'init)
;;; init.el ends here
