;; (require \'asdf)

(in-package :cl-user)
(defpackage my-scheme-2-asd
  (:use :cl :asdf))
(in-package :my-scheme-2-asd)

(defsystem :my-scheme-2
  :version "1.0.0"
  :author "wasu"
  :license "MIT"
  :components ((:file "package")
			   (:module "src" :components ((:file "my-scheme-2")))))
