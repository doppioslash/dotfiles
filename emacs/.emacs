
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'cask "/usr/local/share/emacs/site-lisp/cask/cask.el") ;;<- home-brew cask
(cask-initialize)
(require 'pallet)
(pallet-mode t)
(setq debug-on-error t)
;; ido - always keep this, no deps
(ido-mode t)
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-max-prospects 10)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-use-filename-at-point 'guess)

;; dep: ido-ubiquitous
(require 'ido-ubiquitous)
(ido-ubiquitous-mode t)
(require 'togetherly)

;; misc - no deps
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(global-auto-revert-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(menu-bar-mode -1)
(recentf-mode 1)
(show-paren-mode 1)
(auto-compression-mode t)
(setq-default fill-column 80)
(setq-default default-tab-width 2)
(set-default 'indent-tabs-mode nil)
(set-default 'indicate-empty-lines t)
(set-default 'imenu-auto-rescan t)
(setq dotfiles-dir (file-name-directory
		    (or (buffer-file-name) load-file-name)))
(setq backup-directory-alist `(("." . ,(expand-file-name
					(concat dotfiles-dir "backups")))))
(setq x-select-enable-clipboard t)

;; set utf-8 for everything
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; syntax highlight all buffers
(global-font-lock-mode t)

;; line numbers
(line-number-mode 1)
(column-number-mode 1)

;; ignore case in completion
(setq read-file-name-completion-ignore-case t)

;; VC
(require 'ahg)

;; dep: smex
(require 'smex)
(smex-initialize)
(autoload 'smex "smex"
      "Smex is a M-x enhancement for Emacs, it provides a convenient interface to
your recently and most frequently used commands.")

(global-set-key (kbd "M-x") 'smex)

;; use-package
(require 'use-package)
(setq use-package-always-ensure t)

;; some functions stolen from ohai
(use-package f)
(use-package s)
(use-package dash)

(defun ohai/font-lock-replace-symbol (mode reg sym)
    "Given a major mode `mode', replace the regular expression `reg' with
the symbol `sym' when rendering."
    (font-lock-add-keywords
     mode `((,reg
             (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                                                            ,sym 'decompose-region)))))))

;;-------------------
;; LANGUAGES

;; UTILS
(require 'flycheck)
 (add-hook 'after-init-hook #'global-flycheck-mode) ;; global flycheck mode, still need to set a checker
(require 'flycheck-tip)
;;(define-key your-prog-mode (kbd "C-c C-n") 'flycheck-tip-cycle)
;;(flycheck-tip-use-timer 'verbose)

;; COMPANY
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(add-to-list 'company-backends 'company-tern)
(global-set-key (kbd "M-TAB") 'company-complete)

;; AUTO-COMPLETE
;(require 'auto-complete-config)
;(ac-config-default)

;;-----------------
;; Shen
(quelpa
 '(shen-elisp
   :repo "deech/shen-elisp"
   :fetcher github
   :files ("shen*.el"))
    :upgrade 't)

;;-----------------
;; Idris

(require 'idris-mode)

;;-----------------
;; Ansible

(add-hook 'yaml-mode-hook '(lambda () (ansible 1)))

;;----------------
;; HASKELL

(add-hook 'haskell-mode-hook 'intero-mode)

;;-----------------
;; Purescript

(use-package purescript-mode
             :commands purescript-mode
             :mode (("\\.purs$" . purescript-mode))
             :config
             (add-hook 'purescript-mode-hook 'turn-on-purescript-indentation)
             ;; Change some ASCII art syntax into their corresponding Unicode characters.
             ;; Rebind the same Unicode characters to insert their ASCII art versions
             ;; if entered from the keyboard.
             (with-eval-after-load "purescript-mode"
               (ohai/font-lock-replace-symbol 'purescript-mode "\\(->\\)" "→")
               (ohai/font-lock-replace-symbol 'purescript-mode "\\(<-\\)" "←")
               (ohai/font-lock-replace-symbol 'purescript-mode "\\(=>\\)" "⇒")
               (define-key purescript-mode-map (kbd "→") (lambda () (interactive) (insert "->")))
               (define-key purescript-mode-map (kbd "←") (lambda () (interactive) (insert "<-")))
                   (define-key purescript-mode-map (kbd "⇒") (lambda () (interactive) (insert "=>")))))

(require 'psc-ide)
(add-hook 'purescript-mode-hook
          (lambda ()
            (psc-ide-mode)
            (company-mode)
            (flycheck-mode)
            (turn-on-purescript-indentation)
            (customize-set-variable 'psc-ide-add-import-on-completion t)))

(use-package psc-ide
             :ensure nil
             :load-path "site-lisp/psc-ide-emacs"
             :init
             ;; psc-ide
             (setq psc-ide-client-executable "/Users/doppioslash/.psvm/current/bin/psc-ide-client")
             (setq psc-ide-server-executable "/Users/doppioslash/.psvm/current/bin/psc-ide-server")
             (setq psc-ide-rebuild-on-save nil)
             :config
               (add-hook 'purescript-mode-hook 'psc-ide-mode))
;((purescript-mode
;  . ((psc-ide-source-globs
;      . ("src/**/*.purs" "bower_components/purescript-*/src/**/*.purs")))))

;;-----------------
;; Rust

(add-hook 'rust-mode-hook
          '(lambda ()
             (setq tab-width 2)
             (setq racer-cmd (concat (getenv "HOME") "/.cargo/bin/racer")) ;; Rustup binaries PATH
             (setq racer-rust-src-path (concat (getenv "HOME") "/.rust/rust/src"))
             (setq company-tooltip-align-annotations t)
             (add-hook 'rust-mode-hook #'racer-mode)
             (add-hook 'racer-mode-hook #'eldoc-mode)
             (add-hook 'racer-mode-hook #'company-mode)

             (add-hook 'rust-mode-hook 'cargo-minor-mode)
             (local-set-key (kbd "TAB") #'company-indent-or-complete-common)
             (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
;(add-hook 'rust-mode-hook #'racer-mode)
;(add-hook 'racer-mode-hook #'eldoc-mode)
;(add-hook 'racer-mode-hook #'company-mode)
;(add-hook 'rust-mode-hook
;          '(lambda ()
;             (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
;                          (local-set-key (kbd "TAB") #'company-indent-or-complete-common)))
;(setq racer-rust-src-path (getenv "RUST_SRC_PATH"))
;(global-set-key (kbd "TAB") #'company-indent-or-complete-common) ;
;(setq company-tooltip-align-annotations t)

;;-----------------
;; Javascript
(autoload 'tern-mode "tern.el" nil t)
(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(setq js2-highlight-level 3)
(add-hook 'js2-mode-hook (lambda () (tern-mode t)))

;;-----------------
;; ERLANG
(setq load-path (cons "~/.erlangs/18.2.1/lib/tools-2.8.2/emacs"
                      load-path))
(require 'erlang-start)
(setq erlang-root-dir "~/.erlangs/18.2.1/")
(setq exec-path (cons "~/.erlangs/18.2.1/bin" exec-path))
(setq erlang-man-root-dir "~/.erlangs/18.2.1/man")

;; FLYCHECK
;(flycheck-define-checker erlang-otp
;                         "An Erlang syntax checker using the Erlang interpreter."
;                         :command ("erlc" "-o" temporary-directory "-Wall"
;                                   "-I" "../include" "-I" "../../include"
;                                   "-I" "../../../include" source)
;                         :error-patterns
;                         ((warning line-start (file-name) ":" line ": Warning:" (message) line-end)
;                          (error line-start (file-name) ":" line ": " (message) line-end)))
;;(add-to-list 'flycheck-checkers 'erlang-otp)
;(add-hook 'erlang-mode-hook
;          (lambda ()
;            (flycheck-select-checker 'erlang-otp)
;            (flycheck-mode)))

;; DISTEL
(push "~/.emacs.d/distel/elisp/" load-path)
(require 'distel)
(distel-setup)
;; prevent annoying hang-on-compile
(defvar inferior-erlang-prompt-timeout t)
;; default node name to emacs@localhost
(setq inferior-erlang-machine-options '("-sname" "emacs"))
;; tell distel to default to that node
(setq erl-nodename-cache
      (make-symbol
       (concat
        "emacs@"
        ;; Mac OS X uses "name.local" instead of "name", this should work
        ;; pretty much anywhere without having to muck with NetInfo
        ;; ... but I only tested it on Mac OS X.
                (car (split-string (shell-command-to-string "hostname"))))))

(push "~/.emacs.d/company-distel/" load-path)
(require 'company-distel)

(add-hook 'erlang-mode-hook
          (lambda ()
            (setq company-backends '(company-distel))))
;            (set (make-local-variable 'company-backends) '(company-distel))))
(require 'company-distel-frontend)

;;-----------------
;; ELM
(require 'elm-mode)

(add-hook 'flycheck-mode-hook 'flycheck-elm-setup)
(add-hook 'elm-mode-hook
          (lambda ()
            (setq company-backends '(company-elm))))
;            (set (make-local-variable 'company-backends) '(company-elm))))

(add-hook 'elm-mode-hook #'elm-oracle-setup-completion)

;;-----------------
;; LFE

(setq load-path (cons "~/Code/LFE/lfe/emacs" load-path))
(require 'lfe-start)

;;-----------------
;; MARKDOWN

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;-----------------
;; COQ

(load-file "~/.emacs.d/ProofGeneral-4.2/generic/proof-site.el")

;;----------------
;; ELIXIR

(require 'alchemist)
(defun mg/alchemist-run-credo-on-project ()
  "Run credo on project"
  (interactive)
  (alchemist-mix-execute "credo"))
(define-key alchemist-mode-keymap (kbd "p c") 'mg/alchemist-run-credo-on-project)
(load-file "~/.emacs.d/flycheck-elixir-credo/flycheck-elixir-credo.el")
(use-package flycheck-elixir-credo
  :defer t
  :ensure f
  :init (add-hook 'elixir-mode-hook 'flycheck-elixir-credo-setup))


;;----------------
;; JS

(require 'json-mode)


;;----------------
;; AGDA

;(load-file (let ((coding-system-for-read 'utf-8))
;                (shell-command-to-string "agda-mode locate")))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (alchemist auto-complete cask company dash f flycheck haskell-mode highlight package-build rust-mode seq use-package elixir-mode s toml-mode togetherly smex shen-elisp racket-mode racer quelpa-use-package purescript-mode psc-ide pallet markdown-mode json-mode js2-mode intero idris-mode ido-ubiquitous flycheck-tip flycheck-rust flycheck-elm flycheck-cask floobits elm-mode company-tern cargo ansible ahg ac-alchemist))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
