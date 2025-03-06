;; -*- lexical-binding: t; -*-
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

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

(defun toa/tangle-and-compile-config ()
  "Tangle `config.org` to `config.el`, then byte-compile `config.el` if it changed."
  (when (string-equal (buffer-file-name) toa/config-org)
    (message "Tangling config.org to config.el...")
    (org-babel-tangle)
    (when (file-exists-p toa/config-el)
      (message "Byte-compiling config.el...")
      (byte-compile-file toa/config-el)
      (message "Compilation complete!"))))

;; Add hook to automatically tangle and compile on save
(add-hook 'after-save-hook #'toa/tangle-and-compile-config)

;; Load the compiled config if available, otherwise tangle and load
(if (file-exists-p toa/config-elc)
    (progn
      (message "Loading byte-compiled config.elc...")
      (load toa/config-elc))
  (progn
    (message "Loading and tangling config.org...")
    (org-babel-load-file toa/config-org)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(all-the-icons conda corfu dashboard doom-modeline doom-themes
		   evil-org ligature no-littering org-roam treemacs
		   vertico))
 '(safe-local-variable-directories '("/home/tunc/work/test3/" "/home/tunc/tmp/")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
