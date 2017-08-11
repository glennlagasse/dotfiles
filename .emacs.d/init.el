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

(setq-default custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

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
  (local-set-key [tab] 'tab-to-tab-stop))
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
(setq display-time-default-load-average nil) ; don't display load average in modeline
(setq mouse-yank-at-point t)            ; Middle-click pastes at point, not at mouse position
(setq help-window-select t)             ; automatically select help window

;; Better scroll settings (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; Make files that start with !# executable on save
(add-hook 'after-save-hook
          #'executable-make-buffer-file-executable-if-script-p)

(use-package general
  :ensure t)

;; Define keys without a prefix
(general-define-key
  :states '(normal visual emacs)
  "/" 'swiper
  ; replace default M-x with ivy backend
  "M-x" 'counsel-M-x)

;; Define keys with a prefix
(general-define-key
  :states '(normal visual emacs)
  :prefix "SPC"
  "e"  '(elfeed)
  "ln" '(linum-mode)
  "lr" '(linum-relative-toggle)
  "fe" '(counsel-find-file)
  "fr" '(counsel-recentf)
  "fd" '(gl/find-user-init-file)
  "bb" '(ivy-switch-buffer)
  "bd" '(kill-this-buffer)
  "w/" '(split-window-horizontally)
  "wj" '(evil-window-down)
  "wk" '(evil-window-up)
  "wh" '(evil-window-left)
  "wl" '(evil-window-right)
  "wd" '(delete-window))

(use-package elfeed
  :ensure t
  :commands (elfeed-search-mode elfeed-show-mode)
  :init
  (setq elfeed-max-connections 10)
  (setq url-queue-timeout 30)
  (setq elfeed-feeds
	'(("http://usesthis.com/feed/")
	   ))
  :config
  ;; mappings for entry list
  (evil-define-key 'normal elfeed-search-mode-map
    ;; fetch feed updates; default: G
    "o" 'elfeed-update
    ;; refreash view of feed listing; default: g
    "O" 'elfeed-search-update--force
    ;; filter
    "f" 'elfeed-search-live-filter
    ;; reset to default filter
    "F" '(lambda () (interactive) (elfeed-search-set-filter "@3-weeks-ago +unread "))
    ;; open url in specified browser
    "b" 'elfeed-search-browse-url
    ;; read current entry or selected (remove unread tag)
    "h" 'elfeed-search-untag-all-unread
    ;; enter show mode on entry
    (kbd "RET") 'elfeed-search-show-entry
    ;; mark current entry or selected unread
    "u" 'elfeed-search-tag-all-unread
    ;; add a tag to current entry or selected
    "a" 'elfeed-search-tag-all
    ;; star entries to come back later to and do something about
    "s" '(lambda () (interactive) (elfeed-search-toggle-all '*))
    ;; remove a tag from current entry or selected
    "d" 'elfeed-search-untag-all)

  ;; mappings for when reading a post
  (evil-define-key 'normal elfeed-show-mode-map
    (kbd "RET") 'elfeed-search-browse-url
    "h" 'elfeed-kill-buffer
    ;; next post
    "i" 'elfeed-show-next
    ;; add a tag to current entry
    "a" 'elfeed-show-tag
    "s" '(lambda () (interactive) (elfeed-search-toggle-all '*))
    ;; remove a tag from current entry
    "d" 'elfeed-show-untag)

  (use-package elfeed-goodies
    :ensure t
    :config
    (setq elfeed-goodies/entry-pane-position 'bottom)
    (elfeed-goodies/setup)))

(use-package paradox
  :ensure t
  :config
  (paradox-enable))

(use-package linum-relative
  :ensure t)

(use-package which-key
  :ensure t
  :config
  (setq which-key-idle-delay 0.5)
  :init
  (which-key-mode)
  :diminish which-key-mode)

(use-package company
  :ensure t
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

(use-package counsel
  :ensure t)

(use-package evil
  :ensure t
  :config
  (progn
    (setq evil-default-cursor t)
    (setq evil-emacs-state-modes nil)
    (setq evil-insert-state-modes nil)
    (setq evil-motion-state-modes nil)
    (evil-mode 1)))

(use-package evil-escape
  :ensure t
  :diminish evil-escape-mode
  :config
  (setq-default evil-escape-key-sequence "kj")
  (evil-escape-mode 1))

(use-package magit
  :ensure t)

(defmacro rename-modeline (package-name mode new-name)
  "For PACKAGE-NAME, rename MODE to NEW-NAME."
  `(eval-after-load ,package-name
     '(defadvice ,mode (after rename-modeline activate)
        (setq mode-name ,new-name))))

(use-package enh-ruby-mode
  :ensure t
  :mode
  (("Capfile" . enh-ruby-mode)
   ("Gemfile\\'" . enh-ruby-mode)
   ("Rakefile" . enh-ruby-mode)
   ("Vagrantfile" . enh-ruby-mode)
   ("\\.rb" . enh-ruby-mode)
   ("\\.ru" . enh-ruby-mode))
  :init
  (rename-modeline "enh-ruby-mode" enh-ruby-mode "Ruby"))

(use-package smart-mode-line
  :ensure t
  :init
  (smart-mode-line-enable)
  :diminish
  :config
  (progn
    (setq sml/no-confirm-load-theme t)
    (sml/setup)))

(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))

(use-package solarized-theme
  :ensure t
  :defer t
  ;:config
  ;(load-theme 'solarized-light t)
  )

(use-package muttrc-mode
  :ensure t
  :defer t
  :mode "muttrc\\'")

(use-package vimrc-mode
  :ensure t
  :defer t)

(use-package rainbow-delimiters
  :ensure t
  :diminish
  :defer t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :config
  (add-hook 'prog-mode-hook (lambda () (flycheck-mode))))

(use-package flycheck-color-mode-line
  :ensure t
  :defer t
  :config
  (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))

(use-package yaml-mode
  :ensure t
  :defer t
  :diminish)

(use-package anzu
  :ensure t
  :bind ([remap query-replace] . anzu-query-replace-regexp)
  :diminish
  :config
  (global-anzu-mode +1)
  (set-face-attribute 'anzu-mode-line nil
		      :foreground "yellow" :weight 'bold)
  (custom-set-variables
   '(anzu-mode-lighter "")
   '(anzu-deactivate-region t)
   '(anzu-search-threshold 1000)
   '(anzu-replace-threshold 50)
   '(anzu-replace-to-string-separator " => ")))

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

(defvar show-paren-delay 0
  "Delay (in seconds) before matching paren is highlighted.")
(show-paren-mode 1)

;; Mac specific settings
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta)
  (custom-set-variables '(epg-gpg-program  "/usr/local/bin/gpg2"))

  (defun iterm-focus ()
    (interactive)
    (do-applescript
     " do shell script \"open -a iTerm\"\n"))

  (general-define-key
   :states '(normal visual emacs)
   :prefix "SPC"
   "'" '(iterm-focus :which-key "focus iterm")
    ;;"?" '(iterm-goto-filedir-or-home :which-key "focus iterm - goto dir")
   ))
  
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

(defun gl/date-iso ()
  "Insert the current date, ISO format, eg. 2016-12-09."
  (interactive)
  (insert (format-time-string "%F")))

(defun gl/date-iso-with-time ()
  "Insert the current date, ISO format with time, eg. 2016-12-09T14:34:54+0100."
  (interactive)
  (insert (format-time-string "%FT%T%z")))

(defun gl/date-long ()
  "Insert the current date, long format, eg. December 09, 2016."
  (interactive)
  (insert (format-time-string "%B %d, %Y")))

(defun gl/date-long-with-time ()
  "Insert the current date, long format, eg. December 09, 2016 - 14:34."
  (interactive)
  (insert (capitalize (format-time-string "%B %d, %Y - %H:%M"))))

(defun gl/date-short ()
  "Insert the current date, short format, eg. 2016.12.09."
  (interactive)
  (insert (format-time-string "%Y.%m.%d")))

(defun gl/date-short-with-time ()
  "Insert the current date, short format with time, eg. 2016.12.09 14:34."
  (interactive)
  (insert (format-time-string "%Y.%m.%d %H:%M")))

(defun gl/find-user-init-file ()
  "Edit the `user-init-file', in the current window."
  (interactive)
  (find-file-existing user-init-file))

(provide 'init)
;;; init.el ends here
