;;;;;;;;;;;;;;;;;;;;;;;
;; load-pathを追加する ;;
;;;;;;;;;;;;;;;;;;;;;;;
(when (< emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d/"))

(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "elisp" "conf" "public_repos")

;; package.elの設定
(when (require 'package nil t)
  (add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
  (package-initialize))

;;;;;;;;;;;;;;;;;;;;;
;; キーバインドの設定 ;;
;;;;;;;;;;;;;;;;;;;;;
;; C-mにnewline-and-indentを割り当てる。初期値はnewline
(define-key global-map (kbd "C-m") 'newline-and-indent)

;; C-hをバックスペースにする
(keyboard-translate ?\C-h ?\C-?)

(define-key global-map (kbd "C-x ?") 'help-command)

;; C-c lを折り返しトグルコマンドにする
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)

;; C-tでウィンドウを切り替える。初期値はtranspose-chars
(define-key global-map (kbd "C-t") 'other-window)

;; C-x bでAnythingを起動
(define-key global-map (kbd "C-x b") 'anything)

;;;;;;;;;;;;;;;;;;;
;; 文字コードの設定 ;;
;;;;;;;;;;;;;;;;;;;
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;;;;;;;;;;;;;;;;;;;;;
;; モードラインの設定 ;;
;;;;;;;;;;;;;;;;;;;;;
;; カラム番号も表示
(column-number-mode t)

;; ファイルサイズを表示
(size-indication-mode t)

;;;;;;;;;;;;;;;;;;;;;
;; タイトルバーの設定 ;;
;;;;;;;;;;;;;;;;;;;;;
;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")

;;;;;;;;;;;;;;;;;;;
;; インデントの設定 ;;
;;;;;;;;;;;;;;;;;;;
;; インデントにタブ文字を使用しない
(setq-default indent-tabs-mode nil)

;;;;;;;;;;;;;
;; 表示設定 ;;
;;;;;;;;;;;;;
;; 表示テーマの設定
(when (require 'color-theme nil t)
  (color-theme-initialize)
  (color-theme-gray30))

;; 対応する括弧のハイライト
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 改行、全角スペース、Tabの表示 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (require 'jaspace nil t)
  (setq jaspace-alternate-jaspace-string "□")
  (setq jaspace-alternate-eol-string "↓\n")
  (setq jaspace-highlight-tabs t)
  (setq jaspace-modes (append jaspace-modes
                              (list 'scheme-mode 'text-mode))))

;;;;;;;;;;;;;;;;
;; フックの設定 ;;
;;;;;;;;;;;;;;;;
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; バックアップとオートセーブ設定 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; バックアップとオートセーブファイルを~/.emacs.d/backupsへ集める
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups/"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

;;;;;;;;;;;;;;;;;;;
;; cua-modeの設定 ;;
;;;;;;;;;;;;;;;;;;;
(cua-mode t)
(setq cua-enable-cua-keys nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 拡張機能の自動インストール設定 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-installの設定
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

;;;;;;;;;;;;;;;;;;;
;; Anythingの設定 ;;
;;;;;;;;;;;;;;;;;;;
(when (require 'anything nil t)
  (setq
   ;; 候補を表示するまでの時間。デフォルトは0.5
   anything-idle-delay 0.3
   ;; タイプして再描写するまでの時間。デフォルトは0.1
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数。デフォルトは50
   anything-candidate-number-limit 100
   ;; 候補が多いときに体感速度を早くする
   anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    ;; root権限でアクションを実行するときのコマンド
    ;; デフォルトは"su"
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
    ;; lispシンボルの補間候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnythingに置き換える
    (descbinds-anything-install)))

;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-completeの設定 ;;
;;;;;;;;;;;;;;;;;;;;;;;;
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;;;;;;;;;;;;;;;;;
;; gaucheの設定 ;;
;;;;;;;;;;;;;;;;;
(setq process-coding-system-alist
      (cons '("gosh" utf-8 . utf-8) process-coding-system-alist))

(setq scheme-program-name "gosh -i")
(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process." t)

(defun scheme-other-window ()
  "Run Gauche on other window"
  (interactive)
  (split-window-horizontally (/ (frame-width) 2))
  (let ((buf-name (buffer-name (current-buffer))))
    (scheme-mode)
    (switch-to-buffer-other-window
     (get-buffer-create "*scheme*"))
    (run-scheme scheme-program-name)
    (switch-to-buffer-other-window
     (get-buffer-create buf-name))))

(define-key global-map "\C-cs" 'scheme-other-window)

;;;;;;;;;;;;;;;;;;
;; haskellの設定 ;;
;;;;;;;;;;;;;;;;;;
(autoload 'haskell-mode "haskell-mode" nil t)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-hook 'haskell-mode-hook 'imenu-add-menubar-index)
