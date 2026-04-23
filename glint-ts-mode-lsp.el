;;; glint-ts-mode-lsp.el --- LSP support for Ember Glint -*- lexical-binding: t; -*-

;; Copyright (C) 2026 overcast-software

;; Author: Doug Headley <doug@dougheadley.com>
;; Keywords: languages, tools, lsp, ember, glint
;; URL: https://github.com/overcast-software/glint-ts-mode
;; SPDX-License-Identifier: MIT

;;; Commentary:
;; LSP support for Ember Glint (.gts/.gjs) files using glint-language-server.
;;
;; To enable, call `glint-ts-mode-lsp-setup' or add it to your init file:
;;
;;   (with-eval-after-load 'glint-ts-mode
;;     (require 'glint-ts-mode-lsp)
;;     (glint-ts-mode-lsp-setup))

;;; Code:

(require 'lsp-mode)
(require 'glint-ts-mode)

(defgroup glint-ts-mode-lsp nil
  "LSP support for Ember Glint."
  :group 'lsp-mode)

;; ---------------------------------------------------------------------
;; Project root detection
;; ---------------------------------------------------------------------

(defun glint-ts-mode-lsp--project-root ()
  "Return project root directory for Glint."
  (or (locate-dominating-file default-directory "glint.json")
      (locate-dominating-file default-directory "tsconfig.json")
      (locate-dominating-file default-directory "package.json")
      (lsp-workspace-root)))

;; ---------------------------------------------------------------------
;; Language server command resolution
;; ---------------------------------------------------------------------

(defun glint-ts-mode-lsp--server-command ()
  "Return the command to start glint-language-server."
  (let* ((root (glint-ts-mode-lsp--project-root))
         (local (when root
                  (expand-file-name "node_modules/.bin/glint-language-server" root)))
         (cmd (cond
               ((and local (file-executable-p local)) local)
               ((executable-find "glint-language-server") "glint-language-server")
               (t (error "Glint language server not found")))))
    (list cmd "--stdio")))

;; ---------------------------------------------------------------------
;; LSP client registration
;; ---------------------------------------------------------------------

;;;###autoload
(with-eval-after-load 'lsp-mode
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection #'glint-ts-mode-lsp--server-command)
    :major-modes '(glint-ts-mode)
    :priority 10
    :server-id 'glint
    :multi-root t
    :initialized-fn (lambda (workspace)
                      (with-lsp-workspace workspace
                        (lsp--set-configuration
                         `(:languageId "typescript"))))))
  (add-to-list 'lsp-language-id-configuration '(glint-ts-mode . "typescript")))

;; ---------------------------------------------------------------------
;; Disable TypeScript LSP in Glint buffers
;; ---------------------------------------------------------------------

(defun glint-ts-mode-lsp--disable-ts-ls ()
  "Disable TypeScript LSP in Glint buffers."
  (setq-local lsp-disabled-clients
              (append lsp-disabled-clients '(ts-ls))))

;; ---------------------------------------------------------------------
;; User entry point
;; ---------------------------------------------------------------------

;;;###autoload
(defun glint-ts-mode-lsp-setup ()
  "Enable LSP integration for `glint-ts-mode' buffers."
  (interactive)
  (add-hook 'glint-ts-mode-hook #'glint-ts-mode-lsp--disable-ts-ls)
  (add-hook 'glint-ts-mode-hook #'lsp-deferred))

(provide 'glint-ts-mode-lsp)
;;; glint-ts-mode-lsp.el ends here
