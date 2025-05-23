;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/") t)

(setq load-prefer-newer t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package better-defaults)

(load-theme 'modus-operandi t)

(use-package magit
  :bind (("C-c g" . magit-status)))

(use-package vertico
  :config
  (vertico-mode)
  (setq ido-mode nil))
(use-package consult)
(use-package marginalia
  :config
  (marginalia-mode))
(use-package orderless
  :custom
  (completion-styles '(orderless)))
(use-package embark
  :bind
  (("C-c ." . embark-act)))
(use-package embark-consult)

(setq python-shell-interpreter "ipython")
(setq python-shell-interpreter-args "--colors=Linux --profile=default --simple-prompt")

(use-package py-yapf
  :config
  (add-hook 'python-mode-hook 'py-yapf-enable-on-save)
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

(use-package eglot
  :config
  (add-hook 'c-mode-common-hook 'eglot-ensure)
  (add-hook 'python-mode-hook 'eglot-ensure))

(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package flycheck)

(use-package clang-format+
  :config
  (add-hook 'c-mode-common-hook #'clang-format+-mode))

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

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

(add-hook 'prog-mode-hook #'flyspell-prog-mode)

(use-package wgrep)

(use-package ace-window
  :bind (("M-o" . ace-window)))

(use-package copilot
  :vc (:url "https://github.com/copilot-emacs/copilot.el"
            :rev :newest
            :branch "main")
  :config
  ;;(add-hook 'prog-mode-hook 'copilot-mode)
  (define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
  (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion))

(use-package copilot-chat
  :after (request org markdown-mode))

(use-package breadcrumb
  :config
  (breadcrumb-mode))

(use-package treemacs
  :config
  (setq treemacs-persist-file nil))

(use-package consult-xref-stack
  :vc
  (:url "https://github.com/brett-lempereur/consult-xref-stack" :branch "main")
  :bind (("C-c b" . consult-xref-stack-backward)
         ("C-c f" . consult-xref-stack-forward)))

;; (require 'consult-xref)
;; (setq xref-show-xrefs-function #'consult-xref)

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
(setq-default fill-column 99)
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

(defun c++-format-hook ()
  (setq c-basic-offset 4)
  (c-set-offset 'innamespace 0))

(defun c-format-hook ()
  (setq c-basic-offset 2))

(add-hook 'c++-mode-hook 'c++-format-hook)
(add-hook 'c-mode-hook 'c-format-hook)

(electric-pair-mode t)
;;(global-display-line-numbers-mode t)

;; This should be loaded automatically...
(load-file "~/.emacs.d/custom.el")

(global-hl-line-mode)

(use-package gptel
  :config
  (setq gptel-backend (gptel-make-azure "azure-m1"
                        :host "minusone-corp-eastus2.openai.azure.com"
                        :endpoint "/openai/deployments/gpt-4o/chat/completions?api-version=2024-12-01-preview"
                        :stream t
                        :key (getenv "AZURE_MINUSONE_API_KEY")
                        :models '(gpt-4o)))
  (gptel-make-gemini "gemini" :key (getenv "GEMINI_API_KEY") :stream t)
  (gptel-make-openai "openai" :key (getenv "CHATGPT_API_KEY") :stream t))
