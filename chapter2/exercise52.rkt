#lang racket

(require rackunit 2htdp/image 2htdp/universe)

; WorldState is a Number
; number of pixels between the top margin and UFO image

; physical constants

(define WIDTH 300)
(define HEIGHT 100)
(define CLOSE (/ HEIGHT 3))

(define UFO-X
    (/ WIDTH 2))
(define UFO-COLOR "green")

; graphical constants

(define MTSCN (empty-scene WIDTH HEIGHT))
(define UFO
    (overlay (circle 10 "solid" UFO-COLOR)
             (ellipse 40 10 "solid" UFO-COLOR)))


; WorldState -> WorldState
; calculate next y position for ufo per tick
(define (tick y)
    (+ y 3))

(check-equal? (tick 10) 13)
(check-equal? (tick 0) 3)
(check-equal? (tick 4) 7)

; WorldState -> Image
; place UFO at y-pos on the scene
(define (render y)
    (place-image UFO UFO-X y MTSCN))

(check-equal? (render 12)
    (place-image UFO UFO-X 12 MTSCN))

; WorldState -> WorldState
(define (main y)
    (big-bang y
        [on-tick tick]
        [to-draw render]))

(main 0)