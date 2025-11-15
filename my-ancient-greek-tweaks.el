;;; greek-hebrew.el --- Greek and Hebrew input methods and display -*- lexical-binding: t; -*-

;; Author: Raoul Comninos
;;
;; Greek and Hebrew Input Method and Display Configuration
;;
;; This file provides:
;; - Alternative input method switching for Greek and Hebrew
;; - Dynamic cursor style based on nearby text
;; - Text cleaning utilities for Greek/Hebrew text
;; - Flyspell integration to skip Greek/Hebrew spell-checking
;; - Font configuration using Liberation Mono for Biblical Greek and Hebrew

;;; Input Methods Configuration

;; Key bindings:
;; - Toggle Hebrew (biblical-sil): C-\
;; - Toggle Greek (babel): C-|
;; - Insert hard break (Hebrew to English): C-x 8 f

;; Type hard break for Hebrew to English
(define-key 'iso-transl-ctl-x-8-map "f" [?‎])

;; Input method and key binding configuration
(setq alternative-input-methods
      '(("hebrew-biblical-sil" . [?\C-\\])
        ("greek-babel" . [?\C-|])))

(setq default-input-method
      (caar alternative-input-methods))

(defun toggle-alternative-input-method (method &optional arg interactive)
  "Toggle input METHOD similar to `toggle-input-method'.
Uses METHOD instead of `default-input-method'.
With ARG, behaves like standard toggle-input-method."
  (if arg
      (toggle-input-method arg interactive)
    (let ((previous-input-method current-input-method))
      (when current-input-method
        (deactivate-input-method))
      (unless (and previous-input-method
                   (string= previous-input-method method))
        (activate-input-method method)))))

(defun reload-alternative-input-methods ()
  "Set up global key bindings for alternative input methods.
Creates toggle functions for each method in `alternative-input-methods'."
  (dolist (config alternative-input-methods)
    (let ((method (car config)))
      (global-set-key (cdr config)
                      `(lambda (&optional arg interactive)
                         ,(concat "Behaves similar to `toggle-input-method', but uses \""
                                  method "\" instead of `default-input-method'")
                         (interactive "P\np")
                         (toggle-alternative-input-method ,method arg interactive))))))

(reload-alternative-input-methods)

;;; Dynamic Cursor Adjustment

(defun my-adjust-cursor-for-language ()
  "Set cursor to bar in Greek/Hebrew region, box otherwise.
Checks characters within 5 positions before and after point."
  (let ((greek-or-hebrew-nearby nil))
    ;; Check characters within 5 positions before and after
    (save-excursion
      (let ((start (max (point-min) (- (point) 5)))
            (end (min (point-max) (+ (point) 5))))
        (goto-char start)
        (while (and (< (point) end) (not greek-or-hebrew-nearby))
          (let ((char (char-after)))
            (when (and char
                       (memq (char-table-range char-script-table char)
                             '(greek hebrew)))
              (setq greek-or-hebrew-nearby t)))
          (forward-char 1))))
    (setq-local cursor-type (if greek-or-hebrew-nearby '(bar . 2) 'box))))

(add-hook 'post-command-hook #'my-adjust-cursor-for-language)

;;; Text Cleaning Utilities

(defun strip-numbers-and-brackets (beg end)
  "Remove numbers and brackets from selected region between BEG and END.
Also removes leading/trailing spaces and collapses multiple spaces between words.
Useful for cleaning up Greek/Hebrew text with verse numbers."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      ;; Remove numbers and brackets
      (goto-char (point-min))
      (while (re-search-forward "\\([0-9]+\\|\\[\\|\\]\\)" nil t)
        (replace-match ""))
      ;; Collapse multiple spaces into single space
      (goto-char (point-min))
      (while (re-search-forward " \\{2,\\}" nil t)
        (replace-match " "))
      ;; Remove leading and trailing whitespace from each line
      (goto-char (point-min))
      (while (re-search-forward "^[[:space:]]+" nil t)
        (replace-match ""))
      (goto-char (point-min))
      (while (re-search-forward "[[:space:]]+$" nil t)
        (replace-match "")))))

(defalias 'grk 'strip-numbers-and-brackets)

;;; Flyspell Configuration

(defun greek-hebrew-flyspell-verify ()
  "Return nil if word at point contains Greek or Hebrew characters.
This tells flyspell to skip checking this word."
  (save-excursion
    (let ((case-fold-search t)
          (pos (point))
          (greek-hebrew-found nil))
      ;; Check if current word contains Greek or Hebrew
      (skip-chars-backward "^ \t\n\r")
      (while (and (< (point) pos) (not greek-hebrew-found))
        (let* ((char (char-after))
               (script (and char (char-table-range char-script-table char))))
          (when (memq script '(greek hebrew))
            (setq greek-hebrew-found t)))
        (forward-char 1))
      ;; Return t to check word, nil to skip
      (not greek-hebrew-found))))

;; Advice to add Greek/Hebrew checking to existing flyspell predicates
(defun greek-hebrew-flyspell-advice (orig-fun &rest args)
  "Advice to skip Greek/Hebrew words in addition to mode-specific checks."
  (and (greek-hebrew-flyspell-verify)
       (apply orig-fun args)))

;; Apply advice to markdown-mode's flyspell predicate
(with-eval-after-load 'markdown-mode
  (advice-add 'markdown-flyspell-check-word-p :around
              #'greek-hebrew-flyspell-advice))

;; For text-mode and org-mode, set the predicate directly
(add-hook 'text-mode-hook
          (lambda ()
            (unless (derived-mode-p 'markdown-mode)
              (setq-local flyspell-generic-check-word-predicate
                          #'greek-hebrew-flyspell-verify))))

(add-hook 'org-mode-hook
          (lambda ()
            (setq-local flyspell-generic-check-word-predicate
                        #'greek-hebrew-flyspell-verify)))

;;; Font Configuration

;; Use Liberation Mono for Greek and Hebrew
;; Alternative option - SBL BibLit (download from: https://www.sbl-site.org/resources/fonts/):
(set-fontset-font "fontset-default" 'greek (font-spec :family "SBL BibLit" :size 22))
(set-fontset-font "fontset-default" 'hebrew (font-spec :family "SBL BibLit" :size 20))

;; (set-fontset-font "fontset-default" 'greek (font-spec :family "Liberation Mono" :size 22))
;; (set-fontset-font "fontset-default" 'hebrew (font-spec :family "Liberation Mono" :size 22))

(provide 'my-ancient-greek-tweaks)

;;; greek-hebrew.el ends here
