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
  ;; When running in the terminal, use terminal colors.
  (when (display-graphic-p)
    (load-theme 'solarized-light t)))

(use-package magit
  :bind (("C-c g" . magit-status)))

(use-package helm
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-buffers-list)))

(setq python-python-command "python")

;; (use-package py-yapf
;;   :config
;;   (add-hook 'python-mode-hook 'py-yapf-enable-on-save))

(defun list-pydefs ()
  "List python definitions in a file."
  (interactive)
  (list-matching-lines "^ *\\(def \\|class \\)"))

(use-package org
  :config
  (setq org-startup-indented t))

(use-package register-list)

(use-package markdown-mode)

(use-package lsp-mode
  :config (add-hook 'prog-mode-hook #'lsp))

(use-package flycheck)

(use-package lsp-ui)

(use-package company-lsp)

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package hlinum
  :config
  (hlinum-activate))

(use-package beacon
  :config
  (beacon-mode 1))

;; BASIC CUSTOMIZATION
;; --------------------------------------

(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-x\C-o" (lambda () (interactive) (other-window -1)))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(setq inhibit-startup-message t)
(global-linum-mode t)
(column-number-mode t)
(setq-default fill-column 79)

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" default)))
 '(package-selected-packages
   (quote
    (beacon editorconfig lsp-ui lsp-mode py-yapf register-list jedi-direx use-package-ensure-system-package solarized-theme material-theme magit helm better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
