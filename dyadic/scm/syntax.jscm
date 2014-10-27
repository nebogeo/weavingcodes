;; Planet Fluxus Copyright (C) 2013 Dave Griffiths
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.
;;
;; You should have received a copy of the GNU Affero General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; todo make data-driven and make define-syntax!
(define ret (lambda (code)
  (cond
   ((not (list? code)) code)
   ((null? code) ())

   ;; with-state
   ((eq? (car code) "with_state")
    (append
     (list "begin" (list "push"))
      (list (list "let"
                  (list (list "r" (append (list "begin") (do-syntax (cdr code)))))
                  (list "pop") "r"))))

   ;; with-primitive
   ((eq? (car code) "with_primitive")
    (append
     (list "begin" (list "grab" (cadr code)))
     (list (list "let"
                 (list (list "r" (append (list "begin") (do-syntax (cdr code)))))
                 (list "ungrab") "r"))))

   ((eq? (car code) "every_frame")
    (append
     (list "every_frame_impl")
     (list
      (list "lambda" (list)
            (do-syntax (cdr code))))))


   ;; define a function
   ((and
     (eq? (car code) "define")
     (list? (cadr code)))
    (let ((name (car (cadr code)))
          (args (cdr (cadr code)))
          (body (do-syntax (cdr (cdr code)))))
      (list "define" name (append (list "lambda" args) body))))

   (else (cons (do-syntax (car code))
               (do-syntax (cdr code)))))))

ret
