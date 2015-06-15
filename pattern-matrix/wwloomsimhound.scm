;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; weavecoding raspberry pi installation

;(synth-init 10 22050)

(clear-colour (vector 1 1 1))

(define weave-scale (vector 0.4 -0.4 0.4))

(define yarn-a (vector 0.8 0.6 0.2))
(define yarn-b (vector 1 1 1))
(define yarn-c (vector 0.9 0.9 0.2))
(define yarn-d (vector 0 0 0.8))

(define warp-yarn-a (list yarn-b yarn-b yarn-b yarn-b yarn-a yarn-a yarn-a yarn-a))
(define weft-yarn-a (list yarn-b yarn-b yarn-b yarn-b yarn-a yarn-a yarn-a yarn-a))

(define warp-yarn-b (list yarn-a yarn-c))
(define weft-yarn-b (list yarn-a yarn-c))

(define warp-yarn-c (list yarn-a yarn-a))
(define weft-yarn-c (list yarn-b yarn-b))

(define warp-yarn-d (list yarn-b yarn-b yarn-b yarn-b yarn-b yarn-d yarn-d yarn-d yarn-d yarn-d))
(define weft-yarn-d (list yarn-d yarn-d))


(define speed 60)
(define jelly-primsize 4096)

(define (load-code fn)
  (let* ((f (open-input-file fn))
         (r (read f)))
    (close-input-port f) r))

(define addr-weft-seq 12)
(define addr-weft-draft-pos 13)
(define addr-weft-id 14)
(define addr-weft-draft 15)
(define addr-weft-draft-size 43)
(define addr-weft-selvedge-gap 46)

(define addr-warp-draft-t 11)
(define addr-warp-draft-pos 12)
(define addr-warp-draft-size 13)
(define addr-warp-draft 14)

(define weft-program (load-code "weft.jelly"))

(define (set-weft-yarn! loom yarn)
  (for-each
   (lambda (weft yarn)
     (with-primitive
      weft
      (pdata-map! (lambda (c) yarn) "c")))
   (loom-wefts loom)
   yarn))


(define (make-weft id yarn p-weft)
  (let ((p (build-jellyfish jelly-primsize)))
    (with-primitive
     p
     (program-jelly speed prim-triangles weft-program)
     (hint-unlit)
     (hint-wire)
     (texture (load-texture "thread.png"))
     (cond
      ((zero? id)
       (scale weave-scale)
       (translate (vector 0.6 0 0)))
      (else
       (identity)
       (parent p-weft)
       (translate (vector 0 (* id -1.5) 0))))

     (pdata-index-map! (lambda (i t)
                         (cond
                          ((eqv? (modulo i 6) 0) (vector 0 0 0))
                          ((eqv? (modulo i 6) 1) (vector 1 1 0))
                          ((eqv? (modulo i 6) 2) (vector 1 0 0))
                          ((eqv? (modulo i 6) 3) (vector 0 0 0))
                          ((eqv? (modulo i 6) 4) (vector 1 1 0))
                          ((eqv? (modulo i 6) 5) (vector 0 1 0))
                          )) "t")
     (pdata-map! (lambda (c) yarn) "c")
     (pdata-map! (lambda (n) (vector 0 0 0)) "n"))
    p))

(define (set-warp-yarn! loom yarn)
  (with-primitive
   (loom-warp loom)
   (pdata-index-map!
    (lambda (i c)
      (let ((i (modulo (quotient i 24) (length yarn))))
        (list-ref yarn i)))
    "c")))

(define (make-warp)
  (let ((r (build-jellyfish jelly-primsize)))
    (with-primitive
     r
     (program-jelly
      800 prim-triangles (load-code "warp.jelly"))
     (hint-unlit)
     (texture (load-texture "thread.png"))
     (scale weave-scale)
     (pdata-index-map! (lambda (i t)
                         (cond
                          ((eqv? (modulo i 6) 0) (vector 0 0 0))
                          ((eqv? (modulo i 6) 1) (vector 10 1 0))
                          ((eqv? (modulo i 6) 2) (vector 0 1 0))
                          ((eqv? (modulo i 6) 3) (vector 0 0 0))
                          ((eqv? (modulo i 6) 4) (vector 10 1 0))
                          ((eqv? (modulo i 6) 5) (vector 10 0 0))
                          )) "t")
     (pdata-map! (lambda (n) (vector 0 0 0)) "n")
     )
    r))



(define (addr-setv! prim addr v)
  (with-primitive prim (pdata-set! "x" addr v)))

(define (addr-set! prim addr v)
  (addr-setv! prim addr (vector v 0 0)))


(define (make-wefts yarn-list)
  (define root-weft (make-weft 0 (car yarn-list) #f))
  (define i 0)
  (cons
   root-weft
   (map
    (lambda (yarn)
      (set! i (+ i 1))
      (make-weft (- (length yarn-list) i) yarn root-weft))
    (cdr yarn-list))))


(define (make-loom warp wefts)
  (list warp wefts))


(define (loom-warp l) (list-ref l 0))
(define (loom-wefts l) (list-ref l 1))

(define (set-draft! start data)
  (when (not (null? data))
	(pdata-set! "x" start
		    (if (zero? (car data))
			(vector 0 0 0) (vector 1 0 0)))
	(set-draft! (+ start 1) (cdr data))))

(define (set-draft-all! loom data)
  (for-each
   (lambda (weft)
     (with-primitive weft (set-draft! addr-weft-draft data)))
   (loom-wefts loom))
  (with-primitive (loom-warp loom) (set-draft! addr-warp-draft data)))

(define old-data
  (list 0 0 0 0 0
        0 0 0 0 0
        0 0 0 0 0
        0 0 0 0 0))

(define (sound-from-changes data)
  (for-each
   (lambda (a b)
     (if (and #f (not (eqv? a b)))
         (if (zero? b)
             (play-now (mul (adsr 0 0.3 1 0.1)
                            (sine (mul (adsr 0.4 0 0 0) 800))) 0)
             (play-now (mul (adsr 0 0.3 1 0.1)
                            (sine (mul (adsr 0 0.8 0 0) 400))) 0)
             )))
   old-data data)
  (set! old-data data))

(define (loom-update! loom data)
  (sound-from-changes data)

  ;; if right/bottom border zero treat as 4X4 matrix
  (cond
   ((and (zero? (list-ref data 4))
         (zero? (list-ref data 9))
         (zero? (list-ref data 14))
         (zero? (list-ref data 19))
         (zero? (list-ref data 20))
         (zero? (list-ref data 21))
         (zero? (list-ref data 22))
         (zero? (list-ref data 23))
         (zero? (list-ref data 24)))

    ;; draft size
    (set! draft-size 4)
    (for-each
     (lambda (weft)
       (addr-set! weft addr-weft-draft-size 4))
     (loom-wefts loom))
    (addr-set! (loom-warp loom) addr-warp-draft-size 4)

    (msg "4x4")
    (set-draft-all!
     loom
     (list (list-ref data 0) (list-ref data 1) (list-ref data 2) (list-ref data 3)
           (list-ref data 5) (list-ref data 6) (list-ref data 7) (list-ref data 8)
           (list-ref data 10) (list-ref data 11) (list-ref data 12) (list-ref data 13)
           (list-ref data 15) (list-ref data 16) (list-ref data 17) (list-ref data 18))))
   (else
    (msg "5x5")
    ;; draft size 5x5
    (set! draft-size 5)
    (for-each
     (lambda (weft)
       (addr-set! weft addr-weft-draft-size 5))
     (loom-wefts loom))
    (addr-set! (loom-warp loom) addr-warp-draft-size 5)
    (set-draft-all! loom data))))

(define (loom-update-wefts loom)
  (define i 0)
  (for-each
   (lambda (weft)
     (addr-set! weft addr-weft-seq weft-seq)
     (addr-set! weft addr-weft-id i)
     (addr-set! weft addr-weft-draft-pos draft-pos)
     (addr-setv! weft addr-weft-selvedge-gap (vector 0 (* (length (loom-wefts loom)) 1.5) 0))
     (set! i (+ i 1)))
   (loom-wefts loom)))

(define (loom-update-warp loom)
  (set! draft-pos (modulo (+ draft-pos 1) draft-size))
  (addr-set! (loom-warp loom) addr-warp-draft-pos draft-pos)
  (addr-set! (loom-warp loom) addr-warp-draft-t 0))

(define count-down 50)

(define timer 101)
(define count 0)
(define weft-seq 0)
(define draft-pos 0)
(define draft-size 5)

(define loom
  (with-state
   (scale (vector 0.5 0.5 0.5))
   (rotate (vector 0 -35 0))
   (translate (vector 0 -2 0))
   (make-loom
    (make-warp)
    (make-wefts weft-yarn-a))))

(set-warp-yarn! loom warp-yarn-a)
(set-weft-yarn! loom weft-yarn-a)

(define start-pattern
  (list
   0 0 0 0 1
   0 0 0 1 0
   0 0 1 0 0
   0 1 0 0 0
   1 0 0 0 0))

(every-frame
 (set! count-down (- count-down 1))

 (when (zero? count-down)
;       (set-warp-yarn! loom warp-yarn-b)
;       (set-weft-yarn! loom weft-yarn-b)

       (loom-update! loom start-pattern))

 ;; little state machine
 ;; wefta warp weftb warp ...
 (set! timer (+ timer 1))
 (when (> timer 50)
       (set! timer 0)
       (set! count (+ count 1))
       (cond
        ((zero? (modulo count 2))
         ;; weft time
         (set! weft-seq (modulo (+ weft-seq 1) (length (loom-wefts loom))))
         ; update weft machines
         (loom-update-wefts loom))
        (else
         ;; warp time
         ;; clear the weft seq, needed for a single weft situation
         (when (< (length (loom-wefts loom)) 2)
               (set! weft-seq -1)
               (loom-update-wefts loom))
         (loom-update-warp loom))))
 (with-primitive
  (car (loom-wefts loom))
  (when
   (< (vy (vtransform  (pdata-ref "x" 11) (get-transform))) -1)
   (translate (vector 0 -0.03 0))))
 )
