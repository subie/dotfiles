;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package better-defaults)

(use-package solarized-theme
  :config
  (load-theme 'solarized-light t))

(use-package magit
  :bind (("C-c g" . magit-status)))

(use-package helm
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-buffers-list)))

;; This doesn't work -- it seems emacs needs to be started from a python environment.
;; (use-package elpy
;;   :config
;;   (elpy-enable))

(use-package org
  :config
  (setq org-startup-indented t))

;; BASIC CUSTOMIZATION
;; --------------------------------------

(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-x\C-o" (lambda () (interactive) (other-window -1)))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(setq inhibit-startup-message t)
(global-linum-mode t)
(column-number-mode t)
(setq fill-column 80)

;; Don't split windows when opening new buffers if the window is already split.
(setq-default split-height-threshold nil)
(setq-default split-width-threshold nil)

(setq-default visible-bell nil)

(winner-mode)

;; http://emacs.stackexchange.com/questions/2189/how-can-i-prevent-a-command-from-using-specific-windows
(defun toggle-window-dedicated ()
  "Control whether or not Emacs is allowed to display another
buffer in current window."
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
         (set-window-dedicated-p window (not (window-dedicated-p window))))
       "%s is dedicated."
     "%s is not dedicated.")
   (current-buffer)))
(global-set-key (kbd "C-c d") 'toggle-window-dedicated)

;; Suppress 'file changed on disk' error messaged when working with git branches.
(global-auto-revert-mode t)
(require 'vc-git)
(add-hook 'find-file-hook '(lambda ()
   "Activates `auto-revert-check-vc-info' for files under Git version control."
   (if (eq 'GIT (vc-backend buffer-file-name))
    (set (make-local-variable 'auto-revert-check-vc-info) t))))
