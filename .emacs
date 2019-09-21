(global-font-lock-mode t)
(winner-mode)
(setq-default indent-tabs-mode nil)
(setq-default split-height-threshold nil)
(setq-default split-width-threshold nil)
(menu-bar-mode -1)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(eval-after-load 'package
  '(add-to-list 'package-archives
                '("GELPA" . "http://internal-elpa.appspot.com/packages/")))
(package-initialize)

;; (require 'ido)
;; (ido-mode t)
;; (ivy-mode 1)
(require 'helm-config)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-x b") #'helm-buffers-list)

(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-x\C-o" (lambda () (interactive) (other-window -1)))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; (add-to-list 'custom-theme-load-path (substitute-in-file-name "~/git_external/emacs-color-theme-solarized-master"))
;; (if (display-graphic-p)
;;     (load-theme 'solarized t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(browse-url-browser-function (quote browse-url-chrome))
 '(buffers-menu-buffer-name-length nil)
 '(column-number-mode t)
 '(fill-column 80)
 '(global-linum-mode t)
 '(global-whitespace-mode t)
 '(helm-buffer-max-length nil)
 '(inhibit-startup-screen t)
 '(package-selected-packages (quote (helm ivy ido-ubiquitous slime)))
 '(require-final-newline t)
 '(sentence-end-double-space nil)
 '(show-paren-mode t)
 '(slime-startup-animation nil)
 '(tool-bar-mode nil)
 '(transient-mark-mode nil)
 '(undo-outer-limit 6000000)
 '(vc-follow-symlinks t)
 '(warning-suppress-types (quote ((\(undo\ discard-info\)))))
 '(whitespace-line-column 80)
 '(whitespace-style (quote (face empty tabs tab-mark lines-tail trailing))))

(add-hook 'c-mode-common-hook 'company-mode)

(global-set-key (kbd "C-M-/") 'company-complete)

(require 'magit2-git5)
(global-set-key (kbd "C-c g") #'magit-status)
;; (setq magit-last-seen-setup-instructions "1.4.0")

 ;; Set your lisp system and, optionally, some contribs
(setq inferior-lisp-program "/usr/bin/sbcl")
(require 'slime)
(require 'slime-autoloads)
(setq slime-contribs '(slime-fancy))
(global-set-key "\C-cs" 'slime-selector)

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

;; (setq compliation-scroll-output 'first-error)

;; Suppress 'file changed on disk' error messaged when working with git branches.
(global-auto-revert-mode t)
(require 'vc-git)
(add-hook 'find-file-hook '(lambda ()
   "Activates `auto-revert-check-vc-info' for files under Git version control."
   (if (eq 'GIT (vc-backend buffer-file-name))
    (set (make-local-variable 'auto-revert-check-vc-info) t))))

(require 'org)

(setq org-startup-indented t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Andale Mono" :foundry "MONO" :slant normal :weight normal :height 102 :width normal)))))
