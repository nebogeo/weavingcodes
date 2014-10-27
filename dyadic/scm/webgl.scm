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

(define init-gl
  (lambda (canvas)
    (let ((gl (canvas.getContext "experimental-webgl")))
      (set! gl.viewportWidth canvas.width)
      (set! gl.viewportHeight canvas.height)
      gl)))

;; vertex buffer primitives

(define build-buffer
  (lambda (gl vertices item-size)
    (let ((vb (gl.createBuffer)))
      (gl.bindBuffer gl.ARRAY_BUFFER vb)
      (gl.bufferData gl.ARRAY_BUFFER (js "new Float32Array(vertices)") gl.STATIC_DRAW)
      (set! vb.itemSize item-size)
      (set! vb.numItems (/ (length vertices) item-size))
      vb)))

(define build-empty-buffer
  (lambda (gl size item-size)
    (let ((vb (gl.createBuffer)))
      (gl.bindBuffer gl.ARRAY_BUFFER vb)
      (gl.bufferData gl.ARRAY_BUFFER (js "new Float32Array(size)") gl.STATIC_DRAW)
      (set! vb.itemSize item-size)
      (set! vb.numItems (/ size item-size))
      vb)))

(define update-buffer!
  (lambda (gl vb vertices)
    (gl.bindBuffer gl.ARRAY_BUFFER vb)
    (gl.bufferData gl.ARRAY_BUFFER (js "new Float32Array(vertices)") gl.STATIC_DRAW)))

;; shaders

(define compile-shader
  (lambda (gl type code)
    (let ((shader (gl.createShader type)))
      (gl.shaderSource shader code)
      (gl.compileShader shader)
      (if (not (gl.getShaderParameter shader gl.COMPILE_STATUS))
          (begin
            (alert (gl.getShaderInfoLog shader))
            #f)
          shader))))

(define build-shader
  (lambda (gl vert frag)
    (let ((fragment-shader (compile-shader gl gl.FRAGMENT_SHADER frag))
          (vertex-shader (compile-shader gl gl.VERTEX_SHADER vert)))
      (let ((shader-program (gl.createProgram)))
        (gl.attachShader shader-program vertex-shader)
        (gl.attachShader shader-program fragment-shader)
        (gl.linkProgram shader-program)
        (when (not (gl.getProgramParameter shader-program gl.LINK_STATUS))
            (alert (gl.getShaderInfoLog shader)))
        (gl.useProgram shader-program)

        (when (not (eq? (gl.getAttribLocation shader-program "p") -1))
              (set! shader-program.vertexPositionAttribute
                    (gl.getAttribLocation shader-program "p"))
              (gl.enableVertexAttribArray shader-program.vertexPositionAttribute))

        (when (not (eq? (gl.getAttribLocation shader-program "n") -1))
              (set! shader-program.vertexNormalAttribute
                    (gl.getAttribLocation shader-program "n"))
              (gl.enableVertexAttribArray shader-program.vertexNormalAttribute))

        (when (not (eq? (gl.getAttribLocation shader-program "t") -1))
              (set! shader-program.vertexTextureAttribute
                    (gl.getAttribLocation shader-program "t"))
              (gl.enableVertexAttribArray shader-program.vertexTextureAttribute))

        (when (gl.getUniformLocation shader-program "ViewMatrix")
              (set! shader-program.ViewMatrixUniform
                    (gl.getUniformLocation shader-program "ViewMatrix")))

        (when (gl.getUniformLocation shader-program "CameraMatrix")
              (set! shader-program.CameraMatrixUniform
                    (gl.getUniformLocation shader-program "CameraMatrix")))

        (when (gl.getUniformLocation shader-program "LocalMatrix")
              (set! shader-program.LocalMatrixUniform
                    (gl.getUniformLocation shader-program "LocalMatrix")))

        (when (gl.getUniformLocation shader-program "NormalMatrix")
              (set! shader-program.NormalMatrixUniform
                    (gl.getUniformLocation shader-program "NormalMatrix")))

        (when (gl.getUniformLocation shader-program "AmbientColour")
              (set! shader-program.AmbientColour
                    (gl.getUniformLocation shader-program "AmbientColour")))
        (when (gl.getUniformLocation shader-program "DiffuseColour")
              (set! shader-program.DiffuseColour
                    (gl.getUniformLocation shader-program "DiffuseColour")))
        (when (gl.getUniformLocation shader-program "SpecularColour")
              (set! shader-program.SpecularColour
                    (gl.getUniformLocation shader-program "SpecularColour")))
        (when (gl.getUniformLocation shader-program "AmbientIntensity")
              (set! shader-program.AmbientIntensity
                    (gl.getUniformLocation shader-program "AmbientIntensity")))
        (when (gl.getUniformLocation shader-program "DiffuseIntensity")
              (set! shader-program.DiffuseIntensity
                    (gl.getUniformLocation shader-program "DiffuseIntensity")))
        (when (gl.getUniformLocation shader-program "SpecularIntensity")
              (set! shader-program.SpecularIntensity
                    (gl.getUniformLocation shader-program "SpecularIntensity")))
        (when (gl.getUniformLocation shader-program "Roughness")
              (set! shader-program.Roughness
                    (gl.getUniformLocation shader-program "Roughness")))
        (when (gl.getUniformLocation shader-program "LightPos")
              (set! shader-program.LightPos
                    (gl.getUniformLocation shader-program "LightPos")))

        shader-program))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define buffer
  (lambda (gl name data item-size)
    (list name data
          ;; build empty buffers for testing
          (build-empty-buffer gl (length data) item-size))))

(define buffer-name (lambda (b) (list-ref b 0)))
(define buffer-data (lambda (b) (list-ref b 1)))
(define buffer-modify-data (lambda (b v) (list-replace b 1 v)))
(define buffer-vb (lambda (b) (list-ref b 2)))

(define buffer-update!
  (lambda (gl b)
    (update-buffer! gl (buffer-vb b) (buffer-data b))))
