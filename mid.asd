;;;; dufy-tools.asd -*- Mode: Lisp;-*-

(cl:in-package :asdf)

(defsystem :mid
  :description "Tools for Munsell inversion data"
  :author "privet-kitty"
  :license "MIT"
  :serial t
  :depends-on (:dufy :alexandria :fast-io)
  :components ((:file "mid"))
)
