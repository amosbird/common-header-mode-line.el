;;; common-header-mode-line.el --- per-frame header-mode-line.

;; Copyright (C) 2017 Constantin Kulikov
;;
;; Author: Constantin Kulikov (Bad_ptr) <zxnotdead@gmail.com>
;; Version: 0.1
;; Package-Requires: ()
;; Date: 2017/01/29 09:05:26
;; License: GPL either version 3 or any later version
;; Keywords: mode-line, header-line, convenience, frames, windows
;; X-URL: http://github.com/Bad-ptr/common-header-mode-line.el

;;; License:

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; Draw per-frame header-mode-line.

;; Put this file into your load-path and the following into your ~/.emacs:

;; (require 'common-header-mode-line)
;; (common-header-line-mode)
;; (common-mode-line-mode)

;; M-x customize-group RET common-heade-header-mode-line RET
;; M-x customize-group RET common-header-line RET
;; M-x customize-group RET common-mode-line RET

;;; Code:

(defgroup common-header-mode-line nil "Customize common-header-mode-line." :prefix "common-header-mode-line-" :group 'convenience :link
  '(url-link :tag "Github page" "https://github.com/Bad-ptr/common-header-mode-line.el"))

(defgroup common-mode-line nil "Customize common-mode-line." :prefix "common-mode-line-" :group 'common-header-mode-line)

(defgroup common-header-line nil "Customize common-header-line." :prefix "common-header-line-" :group 'common-header-mode-line)

(defcustom common-mode-line-display-type nil "How to draw common-mode-line." :group 'common-mode-line :type
  '(choice
    (const :tag "Use ordinary window" :value nil)
    (const :tag "Use side window" :value side-window)
    (function :tag "Use this function to get or create a display for mode-line" :value
	      (lambda nil nil))))

(defcustom common-header-line-display-type nil "How to draw common-header-line." :group 'common-header-line :type
  '(choice
    (const :tag "Use ordinary window" :value nil)
    (const :tag "Use side window" :value side-window)
    (function :tag "Use this function to get or create a display for header-line" :value
	      (lambda nil nil))))

(defcustom common-mode-line-window-side 'bottom "Side of the frame where mode-line will be displayed." :group 'common-mode-line :type
  '(choice
    (const :tag "At the bottom" :value bottom)
    (const :tag "At the top" :value top)))

(defcustom common-header-line-window-side 'top "Side of the frame where header-line will be displayed." :group 'common-header-line :type
  '(choice
    (const :tag "At the bottom" :value bottom)
    (const :tag "At the top" :value top)))

(defcustom common-mode-line-window-slot
  (cond
   ((eq 'bottom common-mode-line-window-side)
    1)
   (t -1))
  "Slot to use for side window." :group 'common-mode-line :type
  '(choice
    (const :tag "Middle slot" :value nil)
    (iteger :tag "See doc for `display-buffer-in-side-window'" :value 0)))

(defcustom common-header-line-window-slot
  (cond
   ((eq 'bottom common-header-line-window-side)
    1)
   (t -1))
  "Slot to use for side window." :group 'common-header-line :type
  '(choice
    (const :tag "Middle slot" :value nil)
    (iteger :tag "See doc for `display-buffer-in-side-window'" :value 0)))

(defvar common-mode-line--buffer nil "Buffer used to display mode-line.")

(defvar common-header-line--buffer nil "Buffer used to display header-line.")

(defcustom common-mode-line-buffer-name " *common-mode-line*" "Name of the buffer used to display mode-line." :group 'common-mode-line :type 'string :set
  #'(lambda
      (sym val)
      (custom-set-default sym val)
      (when
	  (buffer-live-p common-mode-line--buffer)
	(with-current-buffer common-mode-line--buffer
	  (rename-buffer val)))))

(defcustom common-header-line-buffer-name " *common-header-line*" "Name of the buffer used to display header-line." :group 'common-header-line :type 'string :set
  #'(lambda
      (sym val)
      (custom-set-default sym val)
      (when
	  (buffer-live-p common-header-line--buffer)
	(with-current-buffer common-header-line--buffer
	  (rename-buffer val)))))

(defvar common-header-mode-line--delayed-update-timer nil "Timer used to delay updates.")

(defcustom common-header-mode-line-update-delay 0.5 "Time to delay updates." :group 'common-header-mode-line :type 'float)

(defcustom common-mode-line-get-create-display-function #'common-mode-line--get-create-display-function "Function to create display. Optional argument -- frame." :group 'common-mode-line :type 'function)

(defcustom common-header-line-get-create-display-function #'common-header-line--get-create-display-function "Function to create display. Optional argument -- frame." :group 'common-header-line :type 'function)

(defcustom common-mode-line-update-display-function #'common-mode-line--update-display-function "Function to update display. Display is the argument." :group 'common-mode-line :type 'function)

(defcustom common-header-line-update-display-function #'common-header-line--update-display-function "Function to update display. Display is the argument." :group 'common-header-line :type 'function)

(defcustom common-mode-line-kill-display-function #'common-mode-line--kill-display-function "Function to kill display passed as argument." :group 'common-mode-line :type 'function)

(defcustom common-header-line-kill-display-function #'common-header-line--kill-display-function "Function to kill display passed as argument." :group 'common-header-line :type 'function)

(defcustom common-mode-line-per-window-format-function #'common-mode-line--per-window-format-function "Function, takes window, returns mode-line-format for window." :group 'common-mode-line :type 'function)

(defcustom common-header-line-per-window-format-function #'common-header-line--per-window-format-function "Function, takes window, returns header-line-format for window." :group 'common-header-line :type 'function)

(defvar common-mode-line--saved-emacs-mode-line-format
  (default-value 'mode-line-format)
  "Default format.")

(defvar common-header-line--saved-emacs-header-line-format
  (default-value 'header-line-format)
  "Default format.")

(defvar common-header-mode-line--selected-window nil "Used to track current window.")

(unless
    (facep 'common-mode-line-face)
  (defface common-mode-line-face
    '((default :inherit mode-line))
    "Face for common mode-line.")
  (copy-face 'mode-line 'common-mode-line-face))

(unless
    (facep 'common-header-line-face)
  (defface common-header-line-face
    '((default :inherit mode-line))
    "Face for common header-line.")
  (copy-face 'header-line 'common-header-line-face))

(defface common-mode-line-inactive-window-mode-line-face
  '((default :inherit mode-line-inactive :height 0.3))
  "Face to use for per-window mode-line when window is inactive.")

(defface common-mode-line-active-window-mode-line-face
  '((default :inherit mode-line :height 0.3))
  "Face to use for per-window mode-line when window is active.")

(defface common-header-line-active-window-header-line-face
  '((default :inherit header-line :height 0.3))
  "Face to use for per-window header-line when window is active.")

(defun common-header-mode-line--init-buffer
    (b)
  (with-current-buffer b
    (buffer-disable-undo)
    (setq-local header-line-format nil)
    (setq-local mode-line-format nil)
    (setq-local cursor-type nil)
    (setq-local cursor-in-non-selected-windows nil)
    (setq-local left-fringe-width 0)
    (setq-local right-fringe-width 0)
    (setq-local overflow-newline-into-fringe nil)
    (setq-local word-wrap nil)
    (setq-local show-trailing-whitespace nil)
    (toggle-truncate-lines 1)
    (current-buffer)))

(defun common-mode-line--get-create-buffer nil
  (if
      (buffer-live-p common-mode-line--buffer)
      common-mode-line--buffer
    (setq common-mode-line--buffer
	  (common-header-mode-line--init-buffer
	   (with-current-buffer
	       (get-buffer-create common-mode-line-buffer-name)
	     (face-remap-add-relative 'default 'common-mode-line-face)
	     (current-buffer))))))

(defun common-header-line--get-create-buffer nil
  (if
      (buffer-live-p common-header-line--buffer)
      common-header-line--buffer
    (setq common-header-line--buffer
	  (common-header-mode-line--init-buffer
	   (with-current-buffer
	       (get-buffer-create common-header-line-buffer-name)
	     (face-remap-add-relative 'default 'common-header-line-face)
	     (current-buffer))))))

(defun common-mode-line--kill-buffer nil
  (when
      (buffer-live-p common-mode-line--buffer)
    (kill-buffer common-mode-line-buffer)))

(defun common-header-line--kill-buffer nil
  (when
      (buffer-live-p common-header-line--buffer)
    (kill-buffer common-header-line-buffer)))

(defun common-header-mode-line--init-window-with-buffer
    (win buf)
  (with-selected-window win
    (with-current-buffer buf
      (set-window-buffer win buf)
      (set-window-dedicated-p win t)
      (set-window-parameter win 'no-other-window t)
      (setq-local window-min-height 1)
      (setq-local window-safe-min-height 1)
      (setq-local window-size-fixed nil)
      (fit-window-to-buffer win 1 1)
      (when
	  (fboundp 'window-preserve-size)
	(window-preserve-size win nil t))
      (setq-local window-size-fixed t))
    win))

(defun common-mode-line--create-window-1
    (&optional frame)
  (let
      (win)
    (with-selected-frame
	(or frame
	    (selected-frame))
      (setq win
	    (if common-mode-line-display-type
		(display-buffer-in-side-window buf
					       `((side \, common-mode-line-window-side)
						 (slot \, common-mode-line-window-slot)
						 (window-height . 1)))
	      (split-window
	       (frame-root-window)
	       nil
	       (if
		   (eq 'bottom common-mode-line-window-side)
		   'below 'above)))))
    win))

(defun common-header-line--create-window-1
    (&optional frame)
  (let
      (win)
    (with-selected-frame
	(or frame
	    (selected-frame))
      (setq win
	    (if common-header-line-display-type
		(display-buffer-in-side-window buf
					       `((side \, common-header-line-window-side)
						 (slot \, common-header-line-window-slot)
						 (window-height . 1)))
	      (split-window
	       (frame-root-window)
	       nil
	       (if
		   (eq 'bottom common-header-line-window-side)
		   'below 'above)))))
    win))

(defun common-mode-line--create-window
    (&optional frame)
  (let*
      (window-configuration-change-hook
       (buf
	(common-mode-line--get-create-buffer))
       (win
	(common-mode-line--create-window-1 frame)))
    (set-frame-parameter frame 'common-mode-line-window win)
    (set-window-parameter win 'common-mode-line-window t)
    (common-header-mode-line--init-window-with-buffer win buf)))

(defun common-header-line--create-window
    (&optional frame)
  (let*
      (window-configuration-change-hook
       (buf
	(common-header-line--get-create-buffer))
       (win
	(common-header-line--create-window-1 frame)))
    (set-frame-parameter frame 'common-header-line-window win)
    (set-window-parameter win 'common-header-line-window t)
    (common-header-mode-line--init-window-with-buffer win buf)))

(defun common-mode-line--get-create-window
    (&optional frame)
  (let
      ((win
	(frame-parameter frame 'common-mode-line-window)))
    (unless
	(window-live-p win)
      (setq win
	    (window-with-parameter 'common-mode-line-window t frame)))
    (unless
	(window-live-p win)
      (setq win
	    (common-mode-line--create-window frame)))
    win))

(defun common-header-line--get-create-window
    (&optional frame)
  (let
      ((win
	(frame-parameter frame 'common-header-line-window)))
    (unless
	(window-live-p win)
      (setq win
	    (window-with-parameter 'common-header-line-window t frame)))
    (unless
	(window-live-p win)
      (setq win
	    (common-header-line--create-window frame)))
    win))

(defun common-mode-line--kill-window
    (&optional frame)
  (let
      ((win
	(frame-parameter frame 'common-mode-line-window)))
    (when
	(window-live-p win)
      (delete-window win))
    (set-frame-parameter frame 'common-mode-line-window nil)))

(defun common-header-line--kill-window
    (&optional frame)
  (let
      ((win
	(frame-parameter frame 'common-header-line-window)))
    (when
	(window-live-p win)
      (delete-window win))
    (set-frame-parameter frame 'common-header-line-window nil)))

(defun common-mode-line--kill-display-function
    (display)
  (let
      ((winc
	(assq 'win display))
       (bufc
	(assq 'buf display)))
    (common-mode-line--kill-window
     (cdr winc))
    (common-mode-line--kill-buffer
     (cdr bufc))
    (setcdr winc nil)
    (setcdr bufc nil)
    (set-frame-parameter frame 'common-mode-line-display display)
    display))

(defun common-header-line--kill-display-function
    (display)
  (let
      ((winc
	(assq 'win display))
       (bufc
	(assq 'buf display)))
    (common-header-line--kill-window
     (cdr winc))
    (common-header-line--kill-buffer
     (cdr bufc))
    (setcdr winc nil)
    (setcdr bufc nil)
    (set-frame-parameter frame 'common-header-line-display display)
    display))

(defun common-mode-line--kill-display
    (display)
  (funcall common-mode-line-kill-display-function display))

(defun common-header-line--kill-display
    (display)
  (funcall common-header-line-kill-display-function display))

(defun common-mode-line--display-valid-p
    (display)
  (let
      ((win
	(cdr
	 (assq 'win display)))
       (buf
	(cdr
	 (assq 'buf display))))
    (and
     (window-live-p win)
     (buffer-live-p buf))))

(defun common-header-line--display-valid-p
    (display)
  (let
      ((win
	(cdr
	 (assq 'win display)))
       (buf
	(cdr
	 (assq 'buf display))))
    (and
     (window-live-p win)
     (buffer-live-p buf))))

(defun common-mode-line--get-create-display-function
    (&optional frame)
  (let
      ((display
	(frame-parameter frame 'common-mode-line-display)))
    (if
	(common-mode-line--display-valid-p display)
	display
      (let*
	  ((buf
	    (common-mode-line--get-create-buffer))
	   (win
	    (common-mode-line--get-create-window frame))
	   (display
	    (cons
	     (cons 'buf buf)
	     (cons
	      (cons 'win win)
	      (cons
	       (cons 'frame
		     (or frame
			 (selected-frame)))
	       nil)))))
	(set-frame-parameter frame 'common-mode-line-display display)
	display))))

(defun common-header-line--get-create-display-function
    (&optional frame)
  (let
      ((display
	(frame-parameter frame 'common-header-line-display)))
    (if
	(common-header-line--display-valid-p display)
	display
      (let*
	  ((buf
	    (common-header-line--get-create-buffer))
	   (win
	    (common-header-line--get-create-window frame))
	   (display
	    (cons
	     (cons 'buf buf)
	     (cons
	      (cons 'win win)
	      (cons
	       (cons 'frame
		     (or frame
			 (selected-frame)))
	       nil)))))
	(set-frame-parameter frame 'common-header-line-display display)
	display))))

(defun common-mode-line--get-create-display
    (&optional frame)
  (funcall common-mode-line-get-create-display-function frame))

(defun common-header-line--get-create-display
    (&optional frame)
  (funcall common-header-line-get-create-display-function frame))

(defun common-mode-line--update-display-function
    (display)
  (let
      ((buf
	(cdr
	 (assq 'buf display))))
    (with-current-buffer buf
      (setq-local buffer-read-only nil)
      (erase-buffer)
      (let*
	  ((mode-l-str
	    (format-mode-line
	     (list ""
		   '(eldoc-mode-line-string
		     (" " eldoc-mode-line-string " "))
		   (default-value 'mode-line-format))
	     'common-mode-line-face common-header-mode-line--selected-window))
	   (win
	    (cdr
	     (assq 'win display))))
	(insert mode-l-str))
      (setq-local mode-line-format nil)
      (setq-local header-line-format nil)
      (setq-local buffer-read-only t))))

(defun common-header-line--update-display-function
    (display)
  (let
      ((buf
	(cdr
	 (assq 'buf display))))
    (with-current-buffer buf
      (setq-local buffer-read-only nil)
      (erase-buffer)
      (let*
	  ((header-l-str
	    (format-mode-line
	     (default-value 'header-line-format)
	     'common-header-line-face common-header-mode-line--selected-window))
	   (win
	    (cdr
	     (assq 'win display))))
	(insert header-l-str))
      (setq-local mode-line-format nil)
      (setq-local header-line-format nil)
      (setq-local buffer-read-only t))))

(defun common-mode-line--update-display
    (display)
  (funcall common-mode-line-update-display-function display))

(defun common-header-line--update-display
    (display)
  (funcall common-header-line-update-display-function display))

(defun common-mode-line--per-window-format-function
    (win)
  "" " ")

(defun common-header-line--per-window-format-function
    (win)
  "" " ")

(defun common-mode-line--per-window-format
    (win)
  (funcall common-mode-line-per-window-format-function win))

(defun common-header-line--per-window-format
    (win)
  (funcall common-header-line-per-window-format-function win))

(defun common-mode-line--update nil
  (let*
      ((display
	(common-mode-line--get-create-display))
       (win
	(cdr
	 (assq 'win display)))
       (cwin
	(selected-window)))
    (unless
	(eq win cwin)
      (setq common-header-mode-line--selected-window
	    (if
		(eq
		 (minibuffer-window)
		 cwin)
		(minibuffer-selected-window)
	      cwin)))
    (common-mode-line--update-display display)
    (with-current-buffer
	(window-buffer common-header-mode-line--selected-window)
      (setq-local mode-line-format
		  (common-mode-line--per-window-format common-header-mode-line--selected-window)))))

(defun common-header-line--update nil
  (let*
      ((display
	(common-header-line--get-create-display))
       (win
	(cdr
	 (assq 'win display)))
       (cwin
	(selected-window)))
    (unless
	(eq win cwin)
      (setq common-header-mode-line--selected-window
	    (if
		(eq
		 (minibuffer-window)
		 cwin)
		(minibuffer-selected-window)
	      cwin)))
    (common-header-line--update-display display)
    (with-current-buffer
	(window-buffer common-header-mode-line--selected-window)
      (setq-local header-line-format
		  (common-header-line--per-window-format common-header-mode-line--selected-window)))))

(defun common-header-mode-line--delayed-update
    (&rest args)
  (unless
      (timerp common-header-mode-line--delayed-update-timer)
    (setq common-header-mode-line--delayed-update-timer
	  (run-with-idle-timer common-header-mode-line-update-delay nil
			       #'(lambda nil
				   (progn
				     (progn
				       (when common-mode-line-mode
					 (common-mode-line--update))
				       (when common-header-line-mode
					 (common-header-line--update))))
				   (setq common-header-mode-line--delayed-update-timer nil))))))

(defun common-mode-line--activate
    (&optional frames)
  (unless
      (listp frames)
    (setq frames
	  (list frames)))
  (unless frames
    (setq frames
	  (if
	      (and
	       (fboundp 'daemonp)
	       (daemonp))
	      (filtered-frame-list
	       #'(lambda
		   (f)
		   (and
		    (frame-live-p f)
		    (not
		     (eq f terminal-frame)))))
	    (frame-list))))
  (dolist
      (frame frames)
    (common-mode-line--get-create-display frame))
  (setq common-mode-line--saved-emacs-mode-line-format
	(default-value 'mode-line-format)
	mode-line-format nil)
  (add-to-list 'window-persistent-parameters
	       '(common-mode-line-window . writable))
  (add-to-list 'window-persistent-parameters
	       '(no-other-window . writable))
  (add-to-list 'face-remapping-alist
	       '(mode-line common-mode-line-active-window-mode-line-face))
  (progn
    (add-to-list 'face-remapping-alist
		 '(mode-line-inactive common-mode-line-inactive-window-mode-line-face))
    (ad-activate #'force-mode-line-update))
  (ad-activate #'delete-window)
  (add-hook 'post-command-hook #'common-header-mode-line--delayed-update))

(defun common-header-line--activate
    (&optional frames)
  (unless
      (listp frames)
    (setq frames
	  (list frames)))
  (unless frames
    (setq frames
	  (if
	      (and
	       (fboundp 'daemonp)
	       (daemonp))
	      (filtered-frame-list
	       #'(lambda
		   (f)
		   (and
		    (frame-live-p f)
		    (not
		     (eq f terminal-frame)))))
	    (frame-list))))
  (dolist
      (frame frames)
    (common-header-line--get-create-display frame))
  (setq common-header-line--saved-emacs-header-line-format
	(default-value 'header-line-format)
	header-line-format nil)
  (add-to-list 'window-persistent-parameters
	       '(common-header-line-window . writable))
  (add-to-list 'window-persistent-parameters
	       '(no-other-window . writable))
  (add-to-list 'face-remapping-alist
	       '(header-line common-header-line-active-window-header-line-face))
  nil
  (ad-activate #'delete-window)
  (add-hook 'post-command-hook #'common-header-mode-line--delayed-update))

(defun common-mode-line--deactivate
    (&optional frames)
  (unless
      (or common-header-line-mode common-mode-line-mode)
    (when
	(timerp common-header-mode-line--delayed-update-timer)
      (cancel-timer common-header-mode-line--delayed-update-timer)
      (setq common-header-mode-line--delayed-update-timer nil)))
  (unless
      (listp frames)
    (setq frames
	  (list frames)))
  (let
      (all-frames win all)
    (unless frames
      (setq frames
	    (frame-list)
	    all-frames t))
    (dolist
	(frame frames)
      (setq win
	    (window-with-parameter 'common-mode-line-window t frame))
      (when
	  (window-live-p win)
	(set-window-dedicated-p win nil)
	(delete-window win))
      (set-frame-parameter frame 'common-mode-line-window nil))
    (unless
	(window-with-parameter 'common-mode-line-window t)
      (setq all-frames t))
    (when all-frames
      (kill-buffer
       (common-mode-line--get-create-buffer))
      (remove-hook 'post-command-hook #'common-header-mode-line--delayed-update)
      (setq face-remapping-alist
	    (delq
	     (assq 'mode-line face-remapping-alist)
	     face-remapping-alist))
      (setq face-remapping-alist
	    (delq
	     (assq 'mode-line-inactive face-remapping-alist)
	     face-remapping-alist))
      (dolist
	  (w
	   (window-list))
	(with-current-buffer
	    (window-buffer w)
	  (setq mode-line-format common-mode-line--saved-emacs-mode-line-format)))
      (ad-deactivate #'delete-window)
      (ad-deactivate #'force-mode-line-update))))

(defun common-header-line--deactivate
    (&optional frames)
  (unless
      (or common-header-line-mode common-mode-line-mode)
    (when
	(timerp common-header-mode-line--delayed-update-timer)
      (cancel-timer common-header-mode-line--delayed-update-timer)
      (setq common-header-mode-line--delayed-update-timer nil)))
  (unless
      (listp frames)
    (setq frames
	  (list frames)))
  (let
      (all-frames win all)
    (unless frames
      (setq frames
	    (frame-list)
	    all-frames t))
    (dolist
	(frame frames)
      (setq win
	    (window-with-parameter 'common-header-line-window t frame))
      (when
	  (window-live-p win)
	(set-window-dedicated-p win nil)
	(delete-window win))
      (set-frame-parameter frame 'common-header-line-window nil))
    (unless
	(window-with-parameter 'common-header-line-window t)
      (setq all-frames t))
    (when all-frames
      (kill-buffer
       (common-header-line--get-create-buffer))
      (remove-hook 'post-command-hook #'common-header-mode-line--delayed-update)
      (setq face-remapping-alist
	    (delq
	     (assq 'header-line face-remapping-alist)
	     face-remapping-alist))
      nil
      (dolist
	  (w
	   (window-list))
	(with-current-buffer
	    (window-buffer w)
	  (setq header-line-format common-header-line--saved-emacs-header-line-format)))
      (ad-deactivate #'delete-window)
      nil)))

(defadvice force-mode-line-update
    (after common-header-mode-line--delayed-update-adv)
  (common-header-mode-line--delayed-update)
  nil)

(defun common-header-mode-line--can-delete-window-p
    (win)
  (if
      (or common-header-line-mode common-mode-line-mode)
      (not
       (or
	(window-parameter win 'common-header-line-window)
	(window-parameter win 'common-mode-line-window)
	(<
	 (length
	  (window-list nil 0 win))
	 3)))
    t))

(defadvice delete-window
    (around common-header-mode-line--delete-window-adv)
  (if
      (not
       (common-header-mode-line--can-delete-window-p
	(or
	 (ad-get-arg 0)
	 (selected-window))))
      nil ad-do-it))

;;;###autoload
(define-minor-mode common-mode-line-mode "Toggle the common-mode-line-mode.\nWhen active it draws a mode-line at the bottom(or top) of\nthe frame." :require 'common-header-mode-line-mode :group 'common-header-mode-line-mode :init-value nil :global t
  (if common-mode-line-mode
      (common-mode-line--activate)
    (common-mode-line--deactivate)))

;;;###autoload
(define-minor-mode common-header-line-mode "Toggle the common-header-line-mode.\nWhen active it draws a header-line at the bottom(or top) of\nthe frame." :require 'common-header-mode-line-mode :group 'common-header-mode-line-mode :init-value nil :global t
  (if common-header-line-mode
      (common-header-line--activate)
    (common-header-line--deactivate)))

(provide 'common-header-mode-line)


;;; common-header-mode-line.el ends here
