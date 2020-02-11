(in-package :cl-user)
(defpackage my-scheme-2-test
  (:use :cl :prove :my-scheme-2))
(in-package #:my-scheme-2-test)

(plan 1)

(subtest "Four arithmetic operations Testing"
  (is (my-scheme-2:my-eval "(+ 1 2)") 3)
  (is (my-scheme-2:my-eval "(- 2 1)") 1)
  (is (my-scheme-2:my-eval "(* 1 2)") 2)
  (is (my-scheme-2:my-eval "(/ 2 1)") 2))

(subtest "Special operations Testing"
  (my-scheme-2:my-eval "(def x 2)")
  (is (my-scheme-2:my-eval "(+ 1 x)") 3)
  (my-scheme-2:my-eval "(def x 10)")
  (is (my-scheme-2:my-eval "(+ 1 x)") 11))
