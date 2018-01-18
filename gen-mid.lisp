;;
;; This is a script file to generate Munsell inversion datas.
;;

(in-package :cl-user)

(require :dufy)
(require :mid)

(defparameter current-path *load-pathname*)

(defparameter task-lst
  (list (cons "mid-srgb-d65" dufy:srgb)
	(cons "mid-srgb-d50" dufy:srgbd50)
	(cons "mid-adobergb-d65" dufy:adobe)
	(cons "mid-adobergb-d50" dufy:adobed50)))

(defun do-task (basename rgbspace)
  (let* ((filename (concatenate 'string basename ".dat"))
	 (path (merge-pathnames filename current-path)))
    (format t "Now generating ~A...~%" filename)
    (mid:save-munsell-inversion-data
     (mid::make-munsell-inversion-data rgbspace t)
     path)))
  
;; (dolist (task task-lst)
;;   (do-task (car task) (cdr task))
;;   ))


;; (defparameter mid (mid:load-munsell-inversion-data (merge-pathnames "srgb-d65.dat" current-path)))
