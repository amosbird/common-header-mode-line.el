(
 (:text
  ";;; common-$@-line.el --- per-frame $@-line.

;; Copyright (C) 2017 Constantin Kulikov
;;
;; Author: Constantin Kulikov (Bad_ptr) <zxnotdead@gmail.com>
;; Version: 0.2
;; Package-Requires: ()
;; Date: 2017/01/29 09:05:26
;; License: GPL either version 3 or any later version
;; Keywords: mode-line, header-line, convenience, frames, windows
;; X-URL: http://github.com/Bad-ptr/common-$@-line.el

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

;; This file is autogenerated. Do not edit manually.

;; Draw per-frame $@-line.

;; Put this file into your load-path and the following into your ~/.emacs:

;; (require 'common-$@-line)
;; (common-$0-line-mode)
;; (common-$1-line-mode)

;; M-x customize-group RET common-heade-$@-line RET
;; M-x customize-group RET common-$0-line RET
;; M-x customize-group RET common-$1-line RET

;;; Code:
")

 (defgroup common-$@-line nil
   "Customize common-$@-line."
   :prefix "common-$@-line-"
   :group 'convenience
   :link '(url-link :tag "Github page"
                    "https://github.com/Bad-ptr/common-$@-line.el"))

 (defgroup common-$*-line nil
   "Customize common-$*-line."
   :prefix "common-$*-line-"
   :group 'common-$@-line)

 (defcustom common-$*-line-display-type nil
   "How to draw common-$*-line."
   :group 'common-$*-line
   :type '(choice
           (const :tag "Use ordinary window" :value nil)
           (const :tag "Use side window" :value side-window)
           (function :tag "Use this function to get or create a display for $*-line"
                     :value (lambda () nil))))

 (defcustom common-$*-line-window-side
   ($eval
    (cond
     ((eq '$1 '$*) ''bottom)
     (t ''top)))
   "Side of the frame where $*-line will be displayed."
   :group 'common-$*-line
   :type '(choice
           (const :tag "At the bottom" :value bottom)
           (const :tag "At the top" :value top)))

 (defcustom common-$*-line-window-slot
   (cond
    ((eq 'bottom common-$*-line-window-side) 1)
    (t -1))
   "Slot to use for side window."
   :group 'common-$*-line
   :type '(choice
           (const :tag "Middle slot" :value nil)
           (iteger :tag "See doc for `display-buffer-in-side-window'"
                   :value 0)))


 (defvar common-$*-line--buffer nil
   "Buffer used to display $*-line.")

 (defcustom common-$*-line-buffer-name " *common-$*-line*"
   "Name of the buffer used to display $*-line."
   :group 'common-$*-line
   :type 'string
   :set #'(lambda (sym val)
            (custom-set-default sym val)
            (when (buffer-live-p common-$*-line--buffer)
              (with-current-buffer common-$*-line--buffer
                (rename-buffer val)))))


 (defvar common-$@-line--delayed-update-timer nil
   "Timer used to delay updates.")

 (defcustom common-$@-line-update-delay 0.5
   "Time to delay updates."
   :group 'common-$@-line
   :type 'float)


 (defcustom common-$*-line-get-create-display-function
   #'common-$*-line--get-create-display-function
   "Function to create display. Optional argument -- frame."
   :group 'common-$*-line
   :type 'function)

 (defcustom common-$*-line-update-display-function
   #'common-$*-line--update-display-function
   "Function to update display. Display is the argument."
   :group 'common-$*-line
   :type 'function)

 (defcustom common-$*-line-kill-display-function
   #'common-$*-line--kill-display-function
   "Function to kill display passed as argument."
   :group 'common-$*-line
   :type 'function)


 (defcustom common-$*-line-per-window-format-function
   #'common-$*-line--per-window-format-function
   "Function, takes window, returns $*-line-format for window."
   :group 'common-$*-line
   :type 'function)


 (defvar common-$*-line--saved-emacs-$*-line-format
   (default-value '$*-line-format)
   "Default format.")

 (defvar common-$@-line--selected-window nil
   "Used to track current window.")

 (defvar common-$@-line--inhibit-delete-window-advice nil
   "Used to locally allow deleting any window.")


 (defface common-$*-line-face
   '((default :inherit $*-line))
   "Face for common $*-line.")

 (defface common-$1-line-inactive-window-$1-line-face
   '((default :inherit $1-line-inactive :height 0.3))
   "Face to use for per-window $1-line when window is inactive.")

 (defface common-$*-line-active-window-$*-line-face
   '((default :inherit $*-line :height 0.3))
   "Face to use for per-window $*-line when window is active.")


 (defun common-$@-line--init-buffer (b)
   (with-current-buffer b
     (buffer-disable-undo)
     (setq-local $0-line-format nil)
     (setq-local $1-line-format nil)
     (setq-local cursor-type nil)
     (setq-local cursor-in-non-selected-windows nil)
     (setq-local left-fringe-width 0)
     (setq-local right-fringe-width 0)
     (setq-local overflow-newline-into-fringe nil)
     (setq-local word-wrap nil)
     (setq-local show-trailing-whitespace nil)
     (toggle-truncate-lines 1)
     (current-buffer)))

 (defun common-$*-line--get-create-buffer ()
   (if (buffer-live-p common-$*-line--buffer)
       common-$*-line--buffer
     (setq common-$*-line--buffer
           (common-$@-line--init-buffer
            (with-current-buffer
                (get-buffer-create common-$*-line-buffer-name)
              (face-remap-add-relative 'default 'common-$*-line-face)
              (current-buffer))))))

 (defun common-$*-line--kill-buffer ()
   (when (buffer-live-p common-$*-line--buffer)
     (kill-buffer common-$*-line-buffer)))


 (defun common-$@-line--init-window-with-buffer (win buf)
   (with-selected-window win
     (with-current-buffer buf
       (set-window-buffer win buf)
       (set-window-dedicated-p win t)
       (set-window-parameter win 'no-other-window t)
       (setq-local window-min-height 1)
       (setq-local window-safe-min-height 1)
       (setq-local window-size-fixed nil)
       (fit-window-to-buffer win 1 1)
       (when (fboundp 'window-preserve-size)
         (window-preserve-size win nil t))
       ;; (shrink-window-if-larger-than-buffer)
       ;; (window-preserve-size win nil t)
       (setq-local window-size-fixed t))
     win))

 (defun common-$*-line--create-window-1 (&optional frame)
   (let (win)
     (with-selected-frame (or frame (selected-frame))
       (setq win
             (if common-$*-line-display-type
                 (display-buffer-in-side-window
                  buf `((side . ,common-$*-line-window-side)
                        (slot . ,common-$*-line-window-slot)
                        (window-height . 1)))
               (split-window (frame-root-window) nil
                             (if (eq 'bottom common-$*-line-window-side)
                                 'below 'above)))))
     win))

 (defun common-$*-line--create-window (&optional frame)
   (let* (window-configuration-change-hook
          (buf (common-$*-line--get-create-buffer))
          (win (common-$*-line--create-window-1 frame)))
     (set-frame-parameter frame 'common-$*-line-window win)
     (set-window-parameter win 'common-$*-line-window t)
     (common-$@-line--init-window-with-buffer win buf)))

 (defun common-$*-line--get-create-window (&optional frame)
   (let ((win (frame-parameter frame 'common-$*-line-window)))
     (unless (window-live-p win)
       (setq win (window-with-parameter 'common-$*-line-window t frame)))
     (unless (window-live-p win)
       (setq win (common-$*-line--create-window frame)))
     win))

 (defun common-$*-line--kill-window (&optional frame)
   (let ((win (frame-parameter frame 'common-$*-line-window))
         (common-$@-line--inhibit-delete-window-advice t))
     (when (window-live-p win)
       (delete-window win))
     (set-frame-parameter frame 'common-$*-line-window nil)))


 (defun common-$*-line--kill-display-function (display)
   (when display
     (let ((winc (assq 'win display))
           (bufc (assq 'buf display))
           (frame (cdr (assq 'frame display))))
       (common-$*-line--kill-window (cdr winc))
       (common-$*-line--kill-buffer (cdr bufc))
       (setcdr winc nil)
       (setcdr bufc nil)
       (set-frame-parameter frame 'common-$*-line-display
                            nil)
       display)))

 (defun common-$*-line--kill-display (display)
   (funcall common-$*-line-kill-display-function display))

 (defun common-$*-line--display-valid-p (display)
   (let ((win (cdr (assq 'win display)))
         (buf (cdr (assq 'buf display))))
     (and (window-live-p win) (buffer-live-p buf))))

 (defun common-$*-line--get-create-display-function (&optional frame)
   (let ((display (frame-parameter frame 'common-$*-line-display)))
     (if (common-$*-line--display-valid-p display)
         display
       (let* ((buf (common-$*-line--get-create-buffer))
              (win (common-$*-line--get-create-window frame))
              (display (cons (cons 'buf buf)
                             (cons (cons 'win win)
                                   (cons (cons 'frame (or frame
                                                          (selected-frame)))
                                         nil)))))
         (set-frame-parameter frame 'common-$*-line-display
                              display)
         display))))

 (defun common-$*-line--get-create-display (&optional frame)
   (funcall common-$*-line-get-create-display-function frame))

 (defun common-$*-line--update-display-function (display)
   (let ((buf (cdr (assq 'buf display))))
     (with-current-buffer buf
       (setq-local buffer-read-only nil)
       (erase-buffer)
       (let* (($*-l-str
               (format-mode-line
                ($eval
                 (if (eq '$1 '$*)
                     `(list "" '(eldoc-$1-line-string
                                 (" " eldoc-$1-line-string " "))
                            (default-value '$1-line-format))
                   `(default-value '$*-line-format)))
                'common-$*-line-face
                common-$@-line--selected-window))
              (win (cdr (assq 'win display)))
              ;; (win-w (window-width win))
              ;; (fill-w (max 0 (- win-w (string-width $*-l-str))))
              )
         (insert
          ;; (concat $*-l-str (propertize (make-string fill-w ?\ )
          ;;                              'face 'common-$*-line-face))
          $*-l-str))
       (setq-local mode-line-format nil)
       (setq-local header-line-format nil)
       ;;(goto-char (point-min))
       (setq-local buffer-read-only t))))

 (defun common-$*-line--update-display (display)
   (funcall common-$*-line-update-display-function display))

 (defun common-$*-line--per-window-format-function (win)
   ""
   " ")

 (defun common-$*-line--per-window-format (win)
   (funcall common-$*-line-per-window-format-function win))

 (defun common-$*-line--update ()
   (let* ((display (common-$*-line--get-create-display))
          (win (cdr (assq 'win display)))
          (cwin (selected-window)))
     (unless (eq win cwin)
       (setq common-$@-line--selected-window
             (if (eq (minibuffer-window) cwin)
                 (minibuffer-selected-window)
               cwin)))
     (common-$*-line--update-display display)
     (with-current-buffer (window-buffer
                           common-$@-line--selected-window)
       (setq-local $*-line-format
                   (common-$*-line--per-window-format
                    common-$@-line--selected-window)))))

 (defun common-$@-line--update ()
   ($subloop
    (when common-$*-line-mode
      (common-$*-line--update))))

 (defun common-$@-line--delayed-update (&rest args)
   (unless (timerp common-$@-line--delayed-update-timer)
     (setq common-$@-line--delayed-update-timer
           (run-with-idle-timer
            common-$@-line-update-delay nil
            #'(lambda ()
                (common-$@-line--update)
                (setq common-$@-line--delayed-update-timer nil))))))

 (defun common-$@-line-update-all-windows (&optional all-frames)
   (interactive "P")
   (setq all-frames (not (null all-frames)))
   (save-excursion
     (let*
         ((start-win
           (selected-window))
          (cwin
           (next-window start-win 0 all-frames)))
       (while (not (eq cwin start-win))
         (with-selected-window cwin
           (common-$@-line--update))
         (setq cwin (next-window cwin 0 all-frames))))))

 (defun common-$*-line--activate (&optional frames)
   (unless (listp frames) (setq frames (list frames)))
   (unless frames (setq frames
                        (if (and (fboundp 'daemonp) (daemonp))
                            (filtered-frame-list
                             #'(lambda (f)
                                 (and (frame-live-p f)
                                      (not (eq f terminal-frame)))))
                          (frame-list))))
   (dolist (frame frames)
     (common-$*-line--get-create-display frame))
   (setq common-$*-line--saved-emacs-$*-line-format
         (default-value '$*-line-format)
         $*-line-format nil)

   (add-to-list 'window-persistent-parameters
                '(common-$*-line-window . writable))
   (add-to-list 'window-persistent-parameters
                '(no-other-window . writable))

   (unless (assq '$*-line (default-value 'face-remapping-alist))
     (push '($*-line common-$*-line-active-window-$*-line-face)
           (default-value 'face-remapping-alist)))

   ($eval
    (when (eq '$1 '$*)
      `(progn
         (unless (assq '$1-line-inactive (default-value 'face-remapping-alist))
           (push '($1-line-inactive common-$1-line-inactive-window-$1-line-face)
                 (default-value 'face-remapping-alist)))
         (ad-activate #'force-mode-line-update))))
   (ad-activate #'delete-window)
   (add-hook 'post-command-hook #'common-$@-line--delayed-update))

 (defun common-$*-line--deactivate (&optional frames)
   (unless (or common-$0-line-mode common-$1-line-mode)
     (when (timerp common-$@-line--delayed-update-timer)
       (cancel-timer common-$@-line--delayed-update-timer)
       (setq common-$@-line--delayed-update-timer nil)))
   (unless (listp frames) (setq frames (list frames)))
   (let (all-frames win all)
     (unless frames
       (setq frames (frame-list)
             all-frames t))
     (dolist (frame frames)
       (common-$*-line--kill-display
        (frame-parameter frame 'common-$*-line-display)))
     (unless (window-with-parameter 'common-$*-line-window t)
       (setq all-frames t))
     (when all-frames
       (progn
         (ad-deactivate #'delete-window)
         ($eval
          (when (eq '$1 '$*)
            `(ad-deactivate #'force-mode-line-update)))
         (remove-hook 'post-command-hook #'common-$@-line--delayed-update)
         (kill-buffer (common-$*-line--get-create-buffer))
         (setq-default face-remapping-alist
                       (delq
                        (assq '$*-line
                              (default-value 'face-remapping-alist))
                        (default-value 'face-remapping-alist)))
         ($eval
          (when (eq '$1 '$*)
            `(setq-default face-remapping-alist
                           (delq
                            (assq '$1-line-inactive
                                  (default-value 'face-remapping-alist))
                            (default-value 'face-remapping-alist)))))
         (dolist (b (buffer-list))
           (with-current-buffer b
             (setq $*-line-format common-$*-line--saved-emacs-$*-line-format)))))))

 (defadvice force-mode-line-update
     (after common-$@-line--delayed-update-adv)
   (common-$@-line--delayed-update)
   nil)

 (defun common-$@-line--can-delete-window-p (win)
   (if (or common-$0-line-mode common-$1-line-mode)
       (not
        (or (window-parameter win 'common-$0-line-window)
            (window-parameter win 'common-$1-line-window)
            (< (length (window-list nil 0 win)) 3)))
     t))

 (defadvice delete-window
     (around common-$@-line--delete-window-adv)
   (if (and
        (not common-$@-line--inhibit-delete-window-advice)
        (not (common-$@-line--can-delete-window-p
              (or (ad-get-arg 0)
                  (selected-window)))))
       nil
     ad-do-it))

 (:autoload
  (define-minor-mode common-$*-line-mode
    "Toggle the common-$*-line-mode.
When active it draws a $*-line at the bottom(or top) of
the frame."
    :require 'common-$@-line-mode
    :group   'common-$@-line-mode
    :init-value nil
    :global     t
    (if common-$*-line-mode
        (common-$*-line--activate)
      (common-$*-line--deactivate))))

 (provide 'common-$@-line)

 (:text
  "
;;; common-$@-line.el ends here")
 )
