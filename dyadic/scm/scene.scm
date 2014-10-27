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

(define scene-node
  (lambda (id prim state children)
    (list id prim state children)))

(define scene-node-id (lambda (n) (list-ref n 0)))
(define scene-node-prim (lambda (n) (list-ref n 1)))
(define scene-node-state (lambda (n) (list-ref n 2)))
(define scene-node-children (lambda (n) (list-ref n 3)))
(define scene-node-modify-children (lambda (n v) (list-replace n 3 v)))

(define scene-node-add-child
  (lambda (n c)
    (scene-node-modify-children
     n (cons c (scene-node-children n)))))

(define scene-node-remove-child
  (lambda (n id)
    (scene-node-modify-children
     n (filter
        (lambda (c)
          (not (eq? (scene-node-id c) id)))
        (scene-node-children n)))))
