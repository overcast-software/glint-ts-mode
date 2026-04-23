;;; glint-ts-mode.el --- Tree-sitter major mode for Ember Glint -*- lexical-binding: t; -*-

;; Copyright (C) 2026 overcast-software

;; Author: Doug Headley <doug@dougheadley.com>
;; Keywords: languages, typescript, ember, glint
;; Package-Requires: ((emacs "30.1") (lsp-mode "9.0"))
;; Version: 0.1.0
;; URL: https://github.com/overcast-software/glint-ts-mode
;; SPDX-License-Identifier: MIT

;;; Commentary:
;; Major mode for Ember Glint template-backed TypeScript files (.gts/.gjs).
;; Derived from tsx-ts-mode to reuse the Tree-sitter TSX grammar.
;;
;; LSP support is provided by the companion file `glint-ts-mode-lsp.el'.

;;; Code:

(require 'typescript-ts-mode) ;; provides tsx-ts-mode

;;;###autoload
(define-derived-mode glint-ts-mode tsx-ts-mode "Glint[TS]"
  "Major mode for editing Ember Glint (.gts/.gjs) files."
  ;; Nothing special yet; inherit all tsx-ts-mode behavior
  )

;; ---------------------------------------------------------------------
;; File associations
;; ---------------------------------------------------------------------

;;;###autoload
(dolist (ext '("\\.gts\\'" "\\.gjs\\'"))
  (add-to-list 'auto-mode-alist `(,ext . glint-ts-mode)))

(provide 'glint-ts-mode)
;;; glint-ts-mode.el ends here
