(in-package :cl-user)
(defpackage my-scheme-2-test
  (:use :cl :prove :my-scheme-2))
(in-package #:my-scheme-2-test)

(subtest "arithmetic operations"
  (is 3 (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(+ 1 2)"))))
  (is 10 (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(- 11 1)"))))
  (is 20 (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(* 10 2)"))))
  (is 5 (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(/ 10 2)"))))
  ;; deep
  (is 6 (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(* (+ 1 2) (- 3 1))"))))
  (is 10 (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(/ (* 10 2) 2)"))))
  )

(subtest "special structures"
  ;; lambda
  (is 3 (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "((lambda (x y) (+ x y)) 1 2)"))))
  ;; if
  (is 3 (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(if t 3 1)"))))
  (is 1 (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(if nil 3 1)"))))
  ;; def
  (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(def x 3)")))
  (is 5 (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(+ x 2)"))))
  ;; set!
  (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(set! y 3)")))
  (is 5 (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(+ y 2)"))))
  ;; quote
  (is '(10 20) (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(quote (10 20))"))))
  (is '(10 20 (30)) (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(quote (10 20 (30)))"))))
  ;; define
  (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(define (hoge x y) (+ x y))")))
  (is 10 (my-scheme-2:my-eval (my-scheme-2:semantic-analysis (my-scheme-2:lexer "(hoge 3 7)"))))
  )
