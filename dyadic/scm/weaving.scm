(define cell-spacing 15)

; return warp or weft, dependant on the position
(define (warp-over x y)
  (eq? (modulo x 2)
       (modulo y 2)))

(define (draw-weave ctx xx yy weave)
  (index-for-each
   (lambda (y weft-yarn)
     (index-for-each
      (lambda (x cell)
        (ctx.drawImage (find-image (string-append "thr-" (list-ref cell 1) ".png"))
                       (+ xx (* x cell-spacing)) (+ yy (* y cell-spacing)))
        (ctx.drawImage (find-image (string-append "thr-" (list-ref cell 0) ".png"))
                       (+ xx (* x cell-spacing)) (+ yy (* y cell-spacing))))
      weft-yarn))
   weave))
