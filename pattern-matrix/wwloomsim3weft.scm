;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; weavecoding raspberry pi installation

(synth-init 10 22050)

(clear-colour (vector 1 1 1))

;(rotate (vector 0 -45 0))
(define weft (build-jellyfish 4096))
(define weft2 (build-jellyfish 4096))
(define warp (build-jellyfish 4096))
(define weave-scale (vector 0.2 -0.2 0.2))

(define yarn-b (vector 1 1 1))
(define yarn-a (vector 0.8 0.6 0.2))

(define warp-yarn-a yarn-a)
(define warp-yarn-b yarn-b)
(define weft-yarn-a yarn-a)
(define weft-yarn-b yarn-b)

(define weft-program (load "weft.jelly"))

(with-primitive
 weft
 (program-jelly 30 prim-triangles weft-program)
 (hint-unlit)
 (hint-wire)
 (texture (load-texture "thread.png"))
 (scale weave-scale)
 (translate (vector 0.4 0 0))
 (pdata-index-map! (lambda (i t)
                     (cond
                      ((eqv? (modulo i 6) 0) (vector 0 0 0))
                      ((eqv? (modulo i 6) 1) (vector 1 1 0))
                      ((eqv? (modulo i 6) 2) (vector 1 0 0))
                      ((eqv? (modulo i 6) 3) (vector 0 0 0))
                      ((eqv? (modulo i 6) 4) (vector 1 1 0))
                      ((eqv? (modulo i 6) 5) (vector 0 1 0))
                      )) "t")
 (pdata-map! (lambda (c) weft-yarn-a) "c")
 (pdata-map! (lambda (n) (vector 0 0 0)) "n"))

 (with-primitive
  weft2
  (parent weft)
  (program-jelly 30 prim-triangles weft-program)
  (hint-unlit)
  (hint-wire)
  (texture (load-texture "thread.png"))
  (translate (vector 0 1.5 0))
  (pdata-index-map! (lambda (i t)
		      (cond
		       ((eqv? (modulo i 6) 0) (vector 0 0 0))
		       ((eqv? (modulo i 6) 1) (vector 1 1 0))
		       ((eqv? (modulo i 6) 2) (vector 1 0 0))
		       ((eqv? (modulo i 6) 3) (vector 0 0 0))
		       ((eqv? (modulo i 6) 4) (vector 1 1 0))
		       ((eqv? (modulo i 6) 5) (vector 0 1 0))
		       )) "t")
  (pdata-map! (lambda (c) weft-yarn-b) "c")
  (pdata-map! (lambda (n) (vector 0 0 0)) "n"))


; weave section
; top shed
; bottom shed
; back section

(with-primitive
 warp
  (program-jelly
   800 prim-triangles (load "warp.jelly"))

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
 (pdata-index-map! (lambda (i c) (if (< (modulo i 48) 24)
                                     warp-yarn-a warp-yarn-b)) "c")
 (pdata-map! (lambda (n) (vector 0 0 0)) "n")
 )

(define (jellyfish-dma sprim src dprim dst)
  (with-primitive
   dprim
   (pdata-set!
    "x" dst (with-primitive
             sprim
             (pdata-ref "x" src)))))


(define weft-draft-start 15)
(define warp-draft-start 14)

(define (set-draft! start data)
  (when (not (null? data))
	(pdata-set! "x" start
		    (if (zero? (car data))
			(vector 0 0 0) (vector 1 0 0)))
	(set-draft! (+ start 1) (cdr data))))

(define (set-draft-all! data)
  (with-primitive warp (set-draft! warp-draft-start data))
  (with-primitive weft (set-draft! weft-draft-start data))
  (with-primitive weft2 (set-draft! weft-draft-start data)))

(define old-data
  (list 0 0 0 0 0
        0 0 0 0 0
        0 0 0 0 0
        0 0 0 0 0))

(define (sound-from-changes data)
  (for-each
   (lambda (a b)
     (if (not (eqv? a b))
         (if (zero? b)
             (play-now (mul (adsr 0 0.3 1 0.1)
                            (sine (mul (adsr 0.4 0 0 0) 800))) 0)
             (play-now (mul (adsr 0 0.3 1 0.1)
                            (sine (mul (adsr 0 0.8 0 0) 400))) 0)
             )))
   old-data data)
  (set! old-data data))

(define (update! data)
  (sound-from-changes data)

  ;; draft pos offset
  (with-primitive weft2 (pdata-set! "x" 14 (vector 1 0 0)))

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
    (with-primitive weft (pdata-set! "x" 43 (vector 4 0 0)))
    (with-primitive weft2 (pdata-set! "x" 43 (vector 4 0 0)))
    (with-primitive warp (pdata-set! "x" 13 (vector 4 0 0)))
    (msg "4x4")
    (set-draft-all!
     (list (list-ref data 0) (list-ref data 1) (list-ref data 2) (list-ref data 3)
           (list-ref data 5) (list-ref data 6) (list-ref data 7) (list-ref data 8)
           (list-ref data 10) (list-ref data 11) (list-ref data 12) (list-ref data 13)
           (list-ref data 15) (list-ref data 16) (list-ref data 17) (list-ref data 18))))
   (else
    (msg "5x5")
    ;; draft size 5x5
    (with-primitive weft (pdata-set! "x" 43 (vector 5 0 0)))
    (with-primitive weft2 (pdata-set! "x" 43 (vector 5 0 0)))
    (with-primitive warp (pdata-set! "x" 13 (vector 5 0 0)))
    (set-draft-all! data))))

(define count-down 50)

(every-frame
 (jellyfish-dma weft 12 warp 11)
 (jellyfish-dma weft 13 warp 12)

 (set! count-down (- count-down 1))

 (when (zero? count-down)
       (update! (list
                 0 0 0 1 1
                 0 0 1 1 0
                 0 1 1 0 0
                 1 1 0 0 0
                 1 0 0 0 1)))

 (with-primitive
  weft
  (when
   (< (vy (vtransform  (pdata-ref "x" 11) (get-transform))) 0)
   (translate (vector 0 -0.1 0))
   ;; (with-primitive
   ;;  warp
   ;;  (pdata-map!
   ;;   (lambda (t) (vadd t (vector 0.03 0 0))) "t"))

   )))
