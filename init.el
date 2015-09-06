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
  (color-theme-hober))

;; 対応する括弧のハイライト
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; バックアップとオートセーブ設定 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; バックアップとオートセーブファイルを~/.emacs.d/backupsへ集める
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups/"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 拡張機能の自動インストール設定 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-installの設定
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

;; Anythingの設定
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


    