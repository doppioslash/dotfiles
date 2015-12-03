;; cask
(require 'cask "/Users/doppioslash/.emacs.d/.cask/24.5.1/elpa/cask-20151123.528/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

;; package
;;(require 'package) ;; You might already have this line

;;(add-to-list 'package-archives
;;	                  '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;;(add-to-list 'package-archives
;;	     '("melpa" . "https://melpa.org/packages/"))

;;(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
;;  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
;;(package-initialize) ;; You might already have this line

;; ido-mode settings
(ido-mode t)
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-max-prospects 10)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-use-filename-at-point 'guess)

(require 'ido-ubiquitous)
(ido-ubiquitous-mode t)

;; misc stuff
(global-auto-revert-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)
;(menu-bar-mode -1)
(require 'saveplace)
(setq-default save-place t)
(recentf-mode 1)
(show-paren-mode 1)
(auto-compression-mode t)
(set-default 'indent-tabs-mode nil)
(set-default 'indicate-empty-lines t)
(set-default 'imenu-auto-rescan t)
(setq dotfiles-dir (file-name-directory
                                        (or (buffer-file-name) load-file-name)))
(setq backup-directory-alist `(("." . ,(expand-file-name
                                         (concat dotfiles-dir "backups")))))
(setq x-select-enable-clipboard t)

;;erlang stuff
(setq load-path (cons "~/.erlangs/18.1/lib/tools-2.8.1/emacs"
		      load-path))
(setq erlang-root-dir "~/.erlangs/18.1/")
(setq exec-path (cons "~/.erlangs/18.1/bin" exec-path))
(require 'erlang-start)

(add-to-list 'load-path "~/.emacs.d/distel/elisp")
;(require 'distel)
;(distel-setup)

(add-to-list 'load-path
             "~/.erlangs/18.1/lib/wrangler-1.2.0/elisp")
(require 'wrangler)
;(require 'erlang-flymake)
(require 'flycheck)
;; erlang flycheck
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
(require 'flycheck-dialyzer)
(add-hook 'erlang-mode-hook 'flycheck-mode)

(require 'smex)
(smex-initialize)
(autoload 'smex "smex"
    "Smex is a M-x enhancement for Emacs, it provides a convenient interface to
your recently and most frequently used commands.")

(global-set-key (kbd "M-x") 'smex)
;(require 'project-persist)
;(project-persist-mode t)
;(require 'project-persist-drawer)
;(require 'ppd-sr-speedbar) ;; or another adaptor
;(project-persist-drawer-mode t)

;(add-hook 'project-persist-before-load-hook 'kill-all-buffers)
;(add-hook 'project-persist-after-close-hook 'kill-all-buffers)

(require 'elm-mode)
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-elm))
(add-hook 'elm-mode-hook #'elm-oracle-setup-completion)
(eval-after-load 'flycheck
      '(add-hook 'flycheck-mode-hook #'flycheck-elm-setup))
;erlang-mode, edts, auto-complete
;auto-highlight-symbol
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default)))
 '(flycheck-checkers
   (quote
    (ada-gnat asciidoc c/c++-clang c/c++-gcc c/c++-cppcheck cfengine chef-foodcritic coffee coffee-coffeelint coq css-csslint d-dmd elm emacs-lisp emacs-lisp-checkdoc erlang eruby-erubis fortran-gfortran go-gofmt go-golint go-vet go-build go-test go-errcheck groovy haml handlebars haskell-stack-ghc haskell-ghc haskell-hlint html-tidy jade javascript-jshint javascript-eslint javascript-gjslint javascript-jscs javascript-standard json-jsonlint json-python-json less luacheck lua perl perl-perlcritic php php-phpmd php-phpcs puppet-parser puppet-lint python-flake8 python-pylint python-pycompile r-lintr rpm-rpmlint rst-sphinx rst ruby-rubocop ruby-rubylint ruby ruby-jruby rust-cargo rust sass scala scala-scalastyle scss-lint scss sh-bash sh-posix-dash sh-posix-bash sh-zsh sh-shellcheck slim sql-sqlint tex-chktex tex-lacheck texinfo verilog-verilator xml-xmlstarlet xml-xmllint yaml-jsyaml yaml-ruby erlang-dialyzer)))
 '(pallet-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;dockerfile mode
(add-to-list 'load-path "~/.emacs.d/.cask/24.5.1/elpa/dockerfile-mode-20151003.501/")
(require 'dockerfile-mode)
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
