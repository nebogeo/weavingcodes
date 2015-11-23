;; -*- mode: scheme; -*-
;; Coding Weaves Copyright (C) 2015 Dave Griffiths
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

;; thinking more like a loom

(define (dbg a)
  (console.log a)(newline) a)

(define (error msg) (console.log msg))

;; add a repetition to the end of a list
;; (repeat (list 1 2 3) 2) => (1 2 3 1 2 3 1 2 3)
(define (repeat seq rep)
  (cond
    ((zero? rep) seq)
    (else (append seq (repeat seq (- rep 1))))))

(define (max-repeat seq max-rep)
  (define (_ r)
    (cond
     ((> (length r) max-rep) r)
     (else (_ (append r seq)))))
  (_ ()))

;; a loom consists of heddles, a lift plan and a warp sequence
(define (loom heddles lifts warp) (list heddles lifts warp))
(define (loom-heddles l) (list-ref l 0))
(define (loom-lifts l) (list-ref l 1))
(define (loom-warp l) (list-ref l 2))


; given a lift plan for the current weft, return the heddles raised
(define (loom-lifts-to-heddles l lift c)
  (cond
   ((null? lift) ())
   ((zero? (car lift))
    (loom-lifts-to-heddles l (cdr lift) (+ c 1)))
   (else
    (cons (list-ref (loom-heddles l) c)
          (loom-lifts-to-heddles l (cdr lift) (+ c 1))))))

;; given a lift counter (position in the lift plan)
;; return a list of the heddles raised
(define (loom-heddles-raised l lift-counter)
  (let ((lift (list-ref (loom-lifts l) lift-counter)))
    (loom-lifts-to-heddles l lift 0)))

;; 'or's two lists together:
;; (list-or (list 0 1 1 0) (list 0 0 1 1)) => (list 0 1 1 1)
(define (list-or a b)
  (map2
   (lambda (a b)
     (if (or (not (zero? a)) (not (zero? b))) 1 0))
   a b))

;; calculate the shed, given a lift plan position counter
;; shed is 0/1 for each warp thread: up/down
(define (loom-shed l lift-counter)
  (foldl
   (lambda (a b)
     (list-or a b))
   (build-list (length (car (loom-heddles l))) (lambda (a) 0))
   (loom-heddles-raised l lift-counter)))

;; return a weave description for one weft
;; provides a list of warp/weft yarn ordered for drawing
(define (loom-weave-yarn l weft-yarn lift-counter)
  (map2
   (lambda (lift warp-yarn)
     (if (eq? lift 1)
         (list (string-append "warp-" warp-yarn)
               (string-append "weft-" weft-yarn))
         (list (string-append "weft-" weft-yarn)
               (string-append "warp-" warp-yarn))))
   (loom-shed l lift-counter)
   (loom-warp l)))

;; calculate an entire weaving from a weft sequence
(define (loom-weave l weft lift-counter)
  (cond
    ((null? weft) ())
    (else
     (cons (loom-weave-yarn
            l (car weft)
            (modulo lift-counter (length (loom-lifts l))))
           (loom-weave
            l (cdr weft)
            (+ lift-counter 1))))))

(define (unit-test)
  (console.log "testing loom")

  ;; test loom setup - plain weave on 4 shafts
  (let ((l (loom
            (list ;; 4 heddles
             (list 1 0 0 0)
             (list 0 1 0 0)
             (list 0 0 1 0)
             (list 0 0 0 1))
            (list ;; lift plan
             (list 1 0 1 0)
             (list 0 1 0 1))
            (repeat (list "O" ":") 1) ;; warp thread codes
            )))

    ;; test the basics
    (when (not (list-equal? (loom-lifts l)
                            (list
                             (list 1 0 1 0)
                      (list 0 1 0 1))))
          (error "loom-lifts test failed"))

    (when (not (list-equal? (loom-heddles l)
                            (list (list 1 0 0 0)
                                  (list 0 1 0 0)
                                  (list 0 0 1 0)
                                  (list 0 0 0 1))))
          (error "loom-heddles test failed"))

    ;; test some internals
    (when (not (list-equal? (loom-lifts-to-heddles l (list 1 1 0 0) 0)
                            (list (list 1 0 0 0) (list 0 1 0 0))))
          (error "loom-lifts-to-heddles test failed"))

    (when (not (list-equal? (loom-heddles-raised l 0)
                            (list (list 1 0 0 0) (list 0 0 1 0))))
          (error "loom-heddles-raised test failed"))

    (when (not (list-equal? (loom-shed l 0) (list 1 0 1 0)))
          (error "loom-shed test1 failed"))

    (when (not (list-equal? (loom-shed l 1) (list 0 1 0 1)))
          (error "loom-shed test2 failed"))

    ;; test the weave for a single weft
    (when (not (list-equal? (loom-weave-yarn l "A" 0) (list "O" "A" "O" "A")))
          (error "loom-weave-yarn test failed"))

    ))

(unit-test)
