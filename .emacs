(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (idea-darkula)))
 '(custom-safe-themes
   (quote
    ("e87a2bd5abc8448f8676365692e908b709b93f2d3869c42a4371223aab7d9cf8" "a34a2e362f029c5c811b0e9d1a7ba3472378a087e18ebe617b8d0354fbf616f5" "52459c804ac3ba8fc0ef71781b09bf0e5cd631aee80de01df873a8a596e930ff" "82b67c7e21c3b12be7b569af7c84ec0fb2d62105629a173e2479e1053cff94bd" "959a77d21e6f15c5c63d360da73281fdc40db3e9f94e310fc1e8213f665d0278" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
)

(add-to-list 'load-path "~/EToolkit/")

;;;                  ;;;
;;;     PACKAGES     ;;;
;;;                  ;;;

;; Import MELPA repository
 (require 'package)  ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) 
;; Finish import

;;  ----SMEX-----
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
;; (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; ----auto-complete----
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")

;; ----power-line----
(require 'cl)
(require 'powerline)
(init-powerline)

;; ----evil-mode----


;;;                        ;;;
;;;     CONFIGURATIONS     ;;;
;;;                        ;;;



;; Hook "show-paren-mode" on "elisp-mode"
(add-hook 'emacs-lisp-mode-hook (lambda () (show-paren-mode 1)))

;; Set default tab indent to 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
;(setq indent-line-function 'insert-tab)
    
;; Disable backup
(setq backup-inhibited t)
;; Disable auto save
(setq auto-save-default nil)
;; Hide scroll bar
(setq scroll-bar-mode nil)
;; Show line number
(global-linum-mode 't)
(setq linum-format " %d  ")
(set-face-attribute 'linum nil :foreground "#191919")
;; Change mode line color
;(face-remap-add-relative
;             'mode-line '((:foreground "#575757" :background "#232323" :box nil) mode-line))
(face-remap-add-relative
 'mode-line '((:foreground "#000000"  :box nil) mode-line))

;; Change cursor type
(setq-default cursor-type '(bar . 2))
;(setq cursor-type 'box)
(set-face-attribute 'cursor nil :background "#7DD4A8")


;; Only open one dired buffer (require dired+ package)
(diredp-toggle-find-file-reuse-dir 1)



;;;                      ;;;
;;;    CUSTOMIZATION     ;;;
;;;                      ;;;


;; Enhanced bookmark
;; Add key \"g\" to bookmark menu. After press \"g\", C-x C-f is invoked with default directory which is the location of current bookmark.
(require 'bookmark)
(defun bookmark-go ()
  "Add key \"g\" to bookmark menu. After press \"g\", C-x C-f is invoked with default directory which is the location of current bookmark."
  (interactive)
  (let* ((bmk (bookmark-bmenu-bookmark))
        (location (bookmark-location bmk)))
    (find-file (read-file-name "Find file: " location))))
(define-key bookmark-bmenu-mode-map "g" 'bookmark-go)
;; End enhance

;; Customized mode
(defconst CyDIW-font-lock-keywords
  (list
   `("$[a-zA-Z]+:\>" . 'font-lock-constant-face)
   `("/\\*[^\\`]*\\*/" . 'font-lock-comment-face)
   `("//.*" . 'font-lock-comment-face)))

(defconst CyDIW-nil-keywords
  (list
   '(nil t)))

(define-minor-mode CyDIW-mode  "CyDIW for COMS661"
  :lighter " CyDIW"
  (if (eq CyDIW-mode t)
      (progn
        (set (make-local-variable 'font-lock-defaults) `(CyDIW-font-lock-keywords))
        (font-lock-mode))
    (font-lock-mode 0)))
;; End Customized mode

;; Recursivly search files
(require 'dired-search)
;; End

;; Sticky window ;;
(require 'sticky-windows)
(global-set-key (kbd "C-x 9") 'sticky-window-keep-window-visible)
(global-set-key (kbd "C-x 0") 'sticky-window-delete-window)
(global-set-key (kbd "C-x 1") 'sticky-window-delete-other-windows)
;; End


;; Enhanced emacs-lisp-mode
(require 'eelisp)


