;; -*- lexical-binding: t; -*-

;; Temporarily increase GC threshold for faster startup
(setq gc-cons-threshold (* 100 1024 1024)) ;; 100MB
(setq gc-cons-percentage 0.6)

(setq native-comp-deferred-compilation t)

(require 'package)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

;; Ensure use-package is installed (Emacs 29+ includes it but without :ensure support)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

;; Define paths
(add-to-list 'load-path "~/.dotfiles/.emacs.d/")
(defvar toa/emacs-dir (expand-file-name "~/.dotfiles/.emacs.d/"))
(defvar toa/config-org (expand-file-name "config.org" toa/emacs-dir))
(defvar toa/config-el  (expand-file-name "config.el" toa/emacs-dir))
(defvar toa/config-elc (expand-file-name "config.elc" toa/emacs-dir))

;; Load the compiled config if available, otherwise tangle and load
(if (file-exists-p toa/config-elc)
    (progn
      (message "Loading byte-compiled config.elc...")
      (load toa/config-elc))
  (progn
    (message "Loading and tangling config.org...")
    (org-babel-load-file toa/config-org)))

;; Restore normal GC thresholds after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 10 1024 1024)) ;; 10MB
            (setq gc-cons-percentage 0.1)))
;;            (message "GC restored to normal settings")))

