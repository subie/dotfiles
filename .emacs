;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/") t)

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
         ("C-x b" . helm-buffers-list)
         ("C-c C-j" . helm-imenu))
  :config
  (helm-mode 1)
  ;; This is a tool-tip like window.
  ;; (setq helm-always-two-windows 1)
  (setq helm-split-window-inside-p 1))

(setq python-shell-interpreter "ipython")
(setq python-shell-interpreter-args "--colors=Linux --profile=default --simple-prompt")

(use-package py-yapf
  :config
  ;; (add-hook 'python-mode-hook 'py-yapf-enable-on-save)
  )

(defun list-pydefs ()
  "List python definitions in a file."
  (interactive)
  (list-matching-lines "^ *\\(def \\|class \\)"))

(use-package org
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :ensure org-plus-contrib
  :config
  (setq org-startup-indented t)
  (setq org-default-notes-file (concat org-directory "/notes.org"))
  (setq org-agenda-window-setup 'other-window)

  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines))

  ;; https://cpbotha.net/2019/11/02/forming-and-maintaining-habits-using-orgmode/
  (add-to-list 'org-modules 'org-habit t)
  (setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d)")))
  )

(use-package register-list)

(use-package markdown-mode)

(use-package lsp-mode
  :config (add-hook 'prog-mode-hook #'lsp))

(use-package lsp-treemacs)

(use-package flycheck)

;; (use-package lsp-ui)

(use-package company-lsp)

(use-package clang-format+
  :config
  (add-hook 'c-mode-common-hook #'clang-format+-mode))

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

(use-package winum)

(use-package dired-subtree
  :config
  (setq dired-subtree-use-backgrounds nil)
  (define-key dired-mode-map "i" 'dired-subtree-insert)
  (define-key dired-mode-map ";" 'dired-subtree-remove))

(use-package cmake-mode)

(use-package slime
  :config
  (setq inferior-lisp-program "sbcl"))

(use-package treemacs)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-x\C-o" (lambda () (interactive) (other-window -1)))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(setq inhibit-startup-message t)
;; Save precious characters on laptop :(
;;(global-linum-mode t)
(column-number-mode t)
;; This will override the fill column from editor-config.
(setq-default fill-column 79)
(setq-default sentence-end-double-space nil)

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
    ("c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "732b807b0543855541743429c9979ebfb363e27ec91e82f463c91e68c772f6e3" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" default)))
 '(org-agenda-files (quote ("~/Dropbox/git/backlog.org" "~/Dropbox/zet")))
 '(package-selected-packages
   (quote
    (slime flycheck yasnippet-snippets cmake-mode org-contrib-plus org-plus-extras dired-subtree clang-format+ clang-format winum beacon editorconfig py-yapf register-list jedi-direx use-package-ensure-system-package solarized-theme material-theme magit helm better-defaults)))
 '(winum-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(defun c-format-hook ()
  (c-set-offset 'innamespace 0))

(add-hook 'c-mode-common-hook 'c-format-hook)

(electric-pair-mode t)
