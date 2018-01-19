;;
;; This is a script file to generate Munsell inversion datas.
;; Instructions:
;; 1. Uncomment the (do-task...) lines below.
;; 2. Just do
;; $ sbcl --load "gen-mid.lisp" --eval "(quit)"
;;

(in-package :cl-user)

(require :dufy)
(require :mid)

(defparameter current-path *load-pathname*)
(defparameter dat-dir-name "dat/")
(defparameter dat-dir-path (merge-pathnames dat-dir-name current-path))

(defparameter task-lst
  (list (cons "mid-srgb-d65" dufy:srgb)
	(cons "mid-srgb-d50" dufy:srgbd50)
	(cons "mid-adobergb-d65" dufy:adobe)
	(cons "mid-adobergb-d50" dufy:adobed50)))

(defun do-task (basename rgbspace)
  (let* ((filename (concatenate 'string basename ".dat"))
	 (path (merge-pathnames filename dat-dir-path)))
    (format t "Now generating ~A...~%" filename)
    (mid:save-munsell-inversion-data
     (mid::make-munsell-inversion-data rgbspace t)
     path)))
  
;; (dolist (task task-lst)
;;   (do-task (car task) (cdr task))
;;   ))

;; (defparameter mid (mid:load-munsell-inversion-data (merge-pathnames "mid-srgb-d65.dat" current-path)))



;; (do-task "mid-srgb-d65" dufy:srgb)
;; (do-task "mid-srgb-d50" dufy:srgbd50)
;; (do-task "mid-adobergb-d65" dufy:adobe)
;; (do-task "mid-adobergb-d50" dufy:adobed50)))
