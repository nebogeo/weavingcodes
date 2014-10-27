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

(define state
  (lambda (gl)
    (list
     (mat4.identity (mat4.create))
     (build-shader
      gl
      vertex-shader
      fragment-shader
      )
     (vector 1 1 1)
     "")))

(define state-tx (lambda (s) (list-ref s 0)))
(define state-shader (lambda (s) (list-ref s 1)))
(define state-modify-shader (lambda (s v) (list-replace s 1 v)))
(define state-colour (lambda (s) (list-ref s 2)))
(define state-modify-colour (lambda (s v) (list-replace s 2 v)))
(define state-texture (lambda (s) (list-ref s 3)))
(define state-modify-texture (lambda (s v) (list-replace s 3 v)))

(define state-clone
  (lambda (s)
    (list
     (mat4.create (state-tx s))
     (state-shader s) ;; todo: shader clone
     (vector-clone (state-colour s))
     (state-texture s))))
