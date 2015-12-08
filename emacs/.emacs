(require 'cask "/usr/local/share/emacs/site-lisp/cask/cask.el") ;;<- home-brew cask
(cask-initialize)
(require 'pallet)
(pallet-mode t)
; (setq debug-on-error t)
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

;; misc - no deps
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

;; dep: smex
(require 'smex)
(smex-initialize)
(autoload 'smex "smex"
      "Smex is a M-x enhancement for Emacs, it provides a convenient interface to
your recently and most frequently used commands.")

(global-set-key (kbd "M-x") 'smex)

;;-------------------
;; LANGUAGES

;; UTILS
(require 'flycheck)
 (add-hook 'after-init-hook #'global-flycheck-mode) ;; global flycheck mode, still need to set a checker
(require 'flycheck-tip)
;;(define-key your-prog-mode (kbd "C-c C-n") 'flycheck-tip-cycle)
(flycheck-tip-use-timer 'verbose)

;; COMPANY
(add-hook 'after-init-hook 'global-company-mode)

;; AUTO-COMPLETE
(require 'auto-complete-config)
(ac-config-default)

;;-----------------
;; ERLANG
(setq load-path (cons "~/.erlangs/18.1/lib/tools-2.8.1/emacs"
                      load-path))
(require 'erlang-start)
(setq erlang-root-dir "~/.erlangs/18.1/")
(setq exec-path (cons "~/.erlangs/18.1/bin" exec-path))
(setq erlang-man-root-dir "~/.erlangs/18.1/man")

;; FLYCHECK
(flycheck-define-checker erlang-otp
                         "An Erlang syntax checker using the Erlang interpreter."
                         :command ("erlc" "-o" temporary-directory "-Wall"
                                   "-I" "../include" "-I" "../../include"
                                   "-I" "../../../include" source)
                         :error-patterns
                         ((warning line-start (file-name) ":" line ": Warning:" (message) line-end)
                          (error line-start (file-name) ":" line ": " (message) line-end)))

(add-hook 'erlang-mode-hook
          (lambda ()
            (flycheck-select-checker 'erlang-otp)
            (flycheck-mode)))

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
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-distel))
(require 'company-distel-frontend)

;;-----------------
;; ELM
(require 'elm-mode)

(add-hook 'flycheck-mode-hook 'flycheck-elm-setup)
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-elm))

(add-hook 'elm-mode-hook #'elm-oracle-setup-completion)

;(add-hook 'elm-mode-hook
;          '(lambda ()
;            (flycheck-select-checker 'elm)
;                        (flycheck-mode)))

;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;'(flycheck-checkers
  ; (quote
   ; (ada-gnat asciidoc c/c++-clang c/c++-gcc c/c++-cppcheck cfengine chef-foodcritic coffee coffee-coffeelint coq css-csslint d-dmd elm emacs-lisp emacs-lisp-checkdoc erlang eruby-erubis fortran-gfortran go-gofmt go-golint go-vet go-build go-test go-errcheck groovy haml handlebars haskell-stack-ghc haskell-ghc haskell-hlint html-tidy jade javascript-jshint javascript-eslint javascript-gjslint javascript-jscs javascript-standard json-jsonlint json-python-json less luacheck lua perl perl-perlcritic php php-phpmd php-phpcs puppet-parser puppet-lint python-flake8 python-pylint python-pycompile r-lintr rpm-rpmlint rst-sphinx rst ruby-rubocop ruby-rubylint ruby ruby-jruby rust-cargo rust sass scala scala-scalastyle scss-lint scss sh-bash sh-posix-dash sh-posix-bash sh-zsh sh-shellcheck slim sql-sqlint tex-chktex tex-lacheck texinfo verilog-verilator xml-xmlstarlet xml-xmllint yaml-jsyaml yaml-ruby))))
;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;)
