(in-package #:my-scheme-2)

(defvar *var-lst* '(("+" (lambda (x y) (+ x y)))
					("-" (lambda (x y) (- x y)))
					("*" (lambda (x y) (* x y)))
					("/" (lambda (x y) (/ x y)))
					("cons" (lambda (x y) (cons x y)))
					("if" (lambda (x y z) (if x y z)))
					("lambda" (lambda (x y) (eval `(lambda))))))

(defun string->string-one (text)
  (mapcar #'(lambda (x) (coerce `(,x) 'string)) (concatenate 'list text)))

(defun search-lparen-pos-lst (node-lst)
  (let ((lparen-pos-lst '())
		(pos 0))
	(dolist (n node-lst)
	  (cond ((string= n "(")
			 (setq lparen-pos-lst (append lparen-pos-lst `(,pos)))))
	  (incf pos))
	lparen-pos-lst))

(defun zip (pair-lst)
  (mapcar #'(lambda (x y) `(,x ,y))
		  (car pair-lst)
		  (nth 1 pair-lst)))

(defun nth-range (begin end lst)
  (when (not (and (<= begin (length lst))
				  (>= (length lst) end)))
	(error "invalid begin or end."))
  (reverse (nthcdr (- (length lst) (1+ end)) (reverse (nthcdr begin lst)))))

(defun range-replace (begin end old-lst new-lst)
  (let ((pos 0)
		(result '()))
	(dolist (old old-lst)
	  (cond
		((= begin pos)
		 (setq result (append result new-lst)))
		((and (<= begin pos)
			  (>= end pos)))
		(t (setq result (append result `(,old)))))
	  (incf pos))
	result))

(defun paren-pos-pair-lst-sort (lparen-pos-lst node-lst)
  (mapcar #'(lambda (x)
			  (let ((lparen 0)
					(pos 0)
					(result -1))
				(dolist (n (nthcdr (1+ x) node-lst))
				  (when (< result 0)
					(cond ((string= n ")")
						   (if (zerop lparen)
							   (setq result (+ x pos))
							   (decf lparen)))
						  ((string= n "(")
						   (incf lparen))))
				  (incf pos))
				result))
		  lparen-pos-lst))

(defun lexer (text)
  (let ((str-list (string->string-one text))
		(node-lst '())
		(variable-tmp ""))
	(labels ((clear-vt-and-add-nlst ()
			   (setq node-lst (append node-lst `(,variable-tmp)))
			   (setq variable-tmp "")))
	  (dolist (str str-list)
		(cond ((string= "(" str)
			   (if (< 0 (length variable-tmp))
				   (clear-vt-and-add-nlst))
			   (setq node-lst (append node-lst `(,str))))
			  ((string= ")" str)
			   (if (< 0 (length variable-tmp))
				   (clear-vt-and-add-nlst))
			   (setq node-lst (append node-lst `(,str))))
			  ((string= " " str)
			   (if (< 0 (length variable-tmp))
				   (clear-vt-and-add-nlst)))
			  (t (setq variable-tmp (concatenate 'string variable-tmp str))))))
	(values node-lst (search-lparen-pos-lst node-lst))))

(defun type-convert (str)
  (cond ((ppcre:scan "\"" str)
		 (ppcre:regex-replace-all "\"" str ""))
		((ppcre:scan "^[0-9]+$" str)
		 (parse-integer str))
		(t (cadr (find str *var-lst* :key #'car :test #'string=)))))

(defun eval-formula (lst)
  (eval (mapcar #'type-convert lst)))

(defun semantic-analysis (n-lst)
  (let ((node-lst n-lst))
	(labels ((f ()
			   (let ((pop (car node-lst)))
				 (setq node-lst (cdr node-lst))
				 (cond ((zerop (length node-lst))
						nil)
					   ((string= "(" pop)
						(let ((result (remove nil (loop
													 for x in node-lst
													 when (and (not (zerop (length (cdr node-lst))))
															   (not (string= (car node-lst) ")")))
													 collect (f)))))
						  (setq node-lst (cdr node-lst))
						  result)
						)
					   ((string= pop ")")
						;; (error "unexpected )")
						nil
						)
					   (t
						(type-convert pop))))))
	  (f))))
