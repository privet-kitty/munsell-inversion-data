;;
;; This is a script file to generate Munsell inversion datas.
;; Instructions:
;; 1. Uncomment the (do-task...) lines below.
;; 2. Just do
;; $ sbcl --load "gen-mid.lisp" --eval "(quit)"
;;

(in-package :cl-user)

(asdf:load-system :mid)

(defparameter version "")
(defparameter current-path *load-pathname*)
(defparameter dat-dir-name "dat/")
(defparameter dat-dir-path (merge-pathnames dat-dir-name current-path))


(defparameter +srgbd50+
  (dufy:copy-rgbspace dufy:+srgb+ :illuminant dufy:+illum-d50+))

(defparameter +adobed50+
  (dufy:copy-rgbspace dufy:+adobe+ :illuminant dufy:+illum-d50+))

(defparameter task-lst
  (list (cons "mid-srgb-d65" dufy:+srgb+)
	(cons "mid-srgb-d50" +srgbd50+)
	(cons "mid-adobergb-d65" dufy:+adobe+)
	(cons "mid-adobergb-d50" +adobed50+)))

(defun do-task (basename rgbspace)
  (let* ((filename (format nil "~A~A~A~A"
			   basename
			   (if (string= version "") "" "-")
			   version
			   ".dat"))
	 (path (merge-pathnames filename dat-dir-path)))
    (format t "Now generating ~A...~%" filename)
    (let ((mid (time (mid::make-munsell-inversion-data rgbspace t))))
      (mid:save-munsell-inversion-data mid path)
      (multiple-value-bind (mean-ab maximum-ab)
	  (mid:examine-interpolation-error mid
					   :silent t
					   :rgbspace rgbspace
					   :deltae #'dufy:xyz-deltae
					   :all-data t)
	(multiple-value-bind (mean-00 maximum-00)
	    (mid:examine-interpolation-error mid
					     :silent t
					     :rgbspace rgbspace
					     :deltae #'dufy:xyz-deltae00
					     :all-data t)
	  (format t "| ~A | ~A | ~A | ~A | ~A |~%"
		  (mid:count-interpolated mid)
		  mean-ab maximum-ab
		  mean-00 maximum-00))))))
  
;; (dolist (task task-lst)
;;   (do-task (car task) (cdr task))
;;   ))



;; (do-task "mid-srgb-d65" dufy:+srgb+)
(do-task "mid-srgb-d50" +srgbd50+)
;; (do-task "mid-adobergb-d65" dufy:+adobe+)
;; (do-task "mid-adobergb-d50" +adobed50+)))
