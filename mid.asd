;;;; dufy-tools.asd -*- Mode: Lisp;-*-

(cl:in-package :asdf)

(defsystem :mid
  :description "Tools for Munsell inversion data"
  :version "0.1.0"
  :author "privet-kitty"
  :license "MIT"
  :serial t
  :depends-on (:dufy :alexandria :fast-io :lparallel)
  :components ((:file "mid"))
)
