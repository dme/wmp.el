;;; wmp.el --- interactive window manipulation

;; Copyright © 2015 David Edmondson

;; Authors: David Edmondson <dme@dme.org>
;; Keywords: window, convenience
;; Version: 0.0.1
;; URL: https://github.com/dme/wmp.el

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License along
;; with this program; if not, write to the Free Software Foundation, Inc.,
;; 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

;;; Acknowledgements:

;; The original idea for `wmp-in-direction' came from rlb in the
;; #notmuch IRC channel.

;;; Commentary:

;; Selecting and deleting windows, moving a buffer from one window to
;; another, etc. are all common tasks for which there are a variety of
;; emacs lisp packages. Unfortunately, it's usually the case that each
;; package implements only one part of the solution - windmove is good
;; for selecting windows, buffer-move is good for swapping buffers,
;; etc. This package attempts to provide a simple way to implement
;; many such schemes in a centralised manner.

;; To use it, this code should be loaded using `(require 'wmp)' (or
;; `use-package' or whatever your preference), then some bindings are
;; configured.

;; In all cases the <up>, <down>, <left> and <right> keys are used as
;; the last element of the binding. Bindings can be set using modifier
;; prefixes (for example "M-" or "C-S-") or multi-key prefix sequence
;; (for example "C-c s " or "M-t ").

;; If the binding will use a multi-key prefix, the prefix string used
;; _must_ have a trailing space.

;; Bindings are configured using `wmp-group', which is passed a
;; binding prefix and a function to be called when the key sequence is
;; used. The function should take a single argument - the window on
;; which to operate.

;; Typical functions to use are `select-window' and `delete-window'. A
;; function to swap the buffers in two windows (`wmp-swap-window') is
;; provided.

;;; Examples:

;; (wmp-group "M-S-" 'select-window)
;;
;;   bind "meta-shift-<direction>" to select a window in the relevant
;;   direction. Similar to `windmove'.
;;
;; (wmp-group "C-c d " 'delete-window)
;;
;;   bind "C-c s <direction>" to delete a window in the relevant
;;   direction.

;;; Code:

(require 'windmove)		   ; For `windmove-find-other-window'.

;; 

(defun wmp-in-direction (dir fn)
  (let ((win (windmove-find-other-window dir nil)))
    (when win
      (funcall fn win))))

(defun wmp-symbol-name (prefix fn)
  (concat "wmp-prefix-" (symbol-name fn)))

(defun wmp-group (prefix func)

  ;; Defining a prefix command is only appropriate if `prefix' is a
  ;; complete prefix (such as "C-c s "). It is not appropriate if
  ;; `prefix' is a list of modifiers (such as "M-" or "S-M-"). What is
  ;; the right way to determine that? At the moment we look for a
  ;; trailing space, and assume that if one is present this is a
  ;; complete prefix.
  (when (string= " " (substring prefix -1))
    (let ((prefix-symbol (make-symbol (wmp-symbol-name prefix func))))
      (define-prefix-command prefix-symbol)
      (global-set-key (kbd prefix) prefix-symbol)))
  
  (mapc (lambda (direction)
	  (global-set-key
	   (kbd (concat prefix "<" (symbol-name direction) ">"))
	   `(lambda () (interactive)
	      (wmp-in-direction ',direction ',func))))
	'(up down left right)))

;; 

(defun wmp-swap-window (window)
  "Swap the buffers shown in WINDOW and the current window."
  (let ((this-buffer (window-buffer))
	(that-buffer (window-buffer window)))
    (set-window-buffer nil that-buffer)
    (set-window-buffer window this-buffer)))

;; 

(provide 'wmp)

;;; wmp.el ends here
