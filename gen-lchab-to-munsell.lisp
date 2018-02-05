;;
;; This is a script file to generate LCH(ab)-to-Munsell data.
;; $ sbcl --load "gen-lchab-to-munsell.lisp" --eval "(quit)"
;;

(in-package :cl-user)

(require :dufy)
(require :mid)
(require :alexandria)

(defparameter current-path (asdf:system-source-directory :mid))
(defparameter dat-dir-name "dat/")
(defparameter dat-dir-path (merge-pathnames dat-dir-name current-path))
;; (defparameter obj-path (merge-pathnames obj-name dat-dir-path))

(defparameter rough-lst '((10 20 30 40 50 60 70 80 90 100) 9 5))
(defparameter fine-lst `(,(alexandria:iota 50 :start 2 :step 2) 3 5))
(defun write-dat (filename &key (illuminant dufy:+illum-c+) (threshold 1d-11) (factor 0.2d0) (fine nil))
  ;; (declare (ignore illuminant))
  (let ((path (merge-pathnames filename dat-dir-path))
	(lst (if fine fine-lst rough-lst))
	(max-ite 2000)
	(cat (dufy:gen-cat-function illuminant dufy:+illum-c+)))
    (with-open-file (out path
			 :direction :output
			 :if-exists :supersede)
      (format out "~9@A ~9@A ~9@A ~9@A ~9@A ~9@A ~9@A~%"
	      "L*" "C*ab" "hab" "H" "V" "C" "H360")
      (dolist (lstar (first lst))
	(loop for hab from 0 below 360 by (second lst) do
	     (loop for cstarab from 10 to 1000 by (third lst) do
		  (destructuring-bind (l-cated c-cated h-cated)
		      (apply (alexandria:rcurry #'dufy:xyz-to-lchab dufy:+illum-c+)
			     (apply cat
				    (dufy:lchab-to-xyz lstar cstarab hab illuminant)))
		    (multiple-value-bind (hvc ite)
			(dufy:lchab-to-mhvc l-cated c-cated h-cated
					    :max-iteration max-ite
					    :factor factor
					    :threshold threshold)
		      (if (= max-ite ite)
			  (format t "can't do inversion at (L C H) = (~A ~A ~A)~%"
				  lstar cstarab hab)
			  (destructuring-bind (hue40 value chroma) hvc
			    (if (dufy:mhvc-out-of-mrd-p hue40 value chroma)
				(return)
				(destructuring-bind (h-str disused disused2)
				    (cl-ppcre:split "[ /]" (dufy:mhvc-to-munsell hue40 value chroma 4))
				  (declare (ignore disused disused2))
				  (format out "~9@A ~9@A ~9@A ~9@A ~9,5F ~9,5F ~9,4F~%"
					  lstar cstarab hab
					  h-str value chroma
					  (* hue40 9))))))))))))
    (format t "saved in ~A.~%" path)))

(write-dat "lchab-to-munsell.dat"
	   :illuminant dufy:+illum-c+
	   :fine nil)
(write-dat "lchab-to-munsell-large.dat"
	   :illuminant dufy:+illum-c+
	   :fine t)
(write-dat "lchab-to-munsell-d65.dat"
	   :illuminant dufy:+illum-d65+
	   :fine nil)
(write-dat "lchab-to-munsell-d65-large.dat"
	   :illuminant dufy:+illum-d65+
	   :fine t
	   :factor 0.15d0)
(write-dat "lchab-to-munsell-d50.dat"
	   :illuminant dufy:+illum-d50+
	   :fine nil)
(write-dat "lchab-to-munsell-d50-large.dat"
	   :illuminant dufy:+illum-d50+
	   :fine t)
