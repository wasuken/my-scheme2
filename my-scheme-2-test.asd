;; (require \'asdf)
 
 (in-package :cl-user)
 (defpackage my-scheme-2-test-asd
 (:use :cl :asdf))
 (in-package :my-scheme-2-test-asd)
 
 (defsystem my-scheme-2-test
 :depends-on (:my-scheme-2)
 :version "1.0.0"
 :author "wasu"
 :license "MIT"
 :components ((:module "t" :components ((:file "my-scheme-2-test"))))
 :perform (test-op :after (op c)
 (funcall (intern #.(string :run) :prove) c)))

