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

(js "var sin=Math.sin")
(js "var cos=Math.cos")

(define (sqrt a) (Math.sqrt a))
(define (square x) (* x x))

(define vector
  (lambda (x y z)
    (list x y z)))

(define vx (lambda (v) (list-ref v 0)))
(define vy (lambda (v) (list-ref v 1)))
(define vz (lambda (v) (list-ref v 2)))

(define vector-clone
  (lambda (v)
    (vector (vx v) (vy v) (vz v))))

(define (vadd a b)
  (vector (+ (vx a) (vx b))
          (+ (vy a) (vy b))
          (+ (vz a) (vz b))))

(define (vmag v)
  (sqrt (+ (square (vx v))
           (square (vy v))
           (square (vz v)))))

(define (vsub a b)
  (vector (- (vx a) (vx b))
          (- (vy a) (vy b))
          (- (vz a) (vz b))))

(define (vneg a)
  (vector (- 0 (vx a))
          (- 0 (vy a))
          (- 0 (vz a))))

(define (vmul v a)
  (vector (* (vx v) a) (* (vy v) a) (* (vz v) a)))

(define (vdiv v a)
  (vector (/ (vx v) a) (/ (vy v) a) (/ (vz v) a)))

(define (vdist a b)
  (vmag (vsub a b)))

(define (vlerp v1 v2 t)
	(vadd v1 (vmul (vsub v2 v1) t)))

(define (vnormalise v)
  (vdiv v (vmag v)))

(define (rndvec) (vector (rndf) (rndf) (rndf)))
(define (crndvec) (vsub (rndvec) (vector 0.5 0.5 0.5)))

(define (hcrndvec s)
  (let ((a (* (rndf) 360)))
    (vector (* s (sin a)) (* s (cos a)) 0)))
