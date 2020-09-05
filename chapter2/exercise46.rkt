#lang racket

(require 2htdp/image 2htdp/universe rackunit)

; physical constants

; "pet"
(define SQUARE-SIDE 10)
(define COLOR "blue")
(define SPEED 3)
(define TAIL-X SQUARE-SIDE)
(define TAIL-Y (* SQUARE-SIDE 2))

; world
(define WORLD-WIDTH (* SQUARE-SIDE 80))
(define WORLD-HEIGHT (* SQUARE-SIDE 40))

; graphical constants

; "pet"
(define TAIL (right-triangle TAIL-X TAIL-Y "solid" COLOR))
(define SQUARE (square SQUARE-SIDE "solid" COLOR))
(define PET-EVEN
    (above TAIL SQUARE))
(define PET-ODD
    (flip-horizontal PET-EVEN))

; World
(define WORLD (empty-scene WORLD-WIDTH WORLD-HEIGHT))

; WorldState is a Number.
; represent state of the world based on the clock ticks.

; WorldState -> WorldState
; generate next WorldState for the following clock tick
(define (tock cws)
    (if (>= (* cws SPEED) (+ WORLD-WIDTH SQUARE-SIDE))
        0
        (+ 1 cws)))

(check-equal? (tock 0) 1)
(check-equal? (tock 20) 21)
(check-equal? (tock 55) 56)

(check-equal?
    (tock
        (- (/ (+ WORLD-WIDTH SQUARE-SIDE)
              SPEED)
         1))
    (/ (+ WORLD-WIDTH SQUARE-SIDE) SPEED))

(check-equal?
    (tock
        (/ (+ WORLD-WIDTH SQUARE-SIDE)
           SPEED))
    0)

(check-equal?
    (tock
        (+ (/ (+ WORLD-WIDTH SQUARE-SIDE)
              SPEED)
           1))
    0)

; WorldState -> Image
; render the image based on it's current WorldState (cws)
(define (render cws)
    (if (odd? cws)
        (place-image PET-ODD (* cws SPEED) (- WORLD-HEIGHT SQUARE-SIDE) WORLD)
        (place-image PET-EVEN (* cws SPEED) (- WORLD-HEIGHT SQUARE-SIDE) WORLD)))

(check-equal? (render 50)
    (place-image PET-EVEN 150 (- WORLD-HEIGHT SQUARE-SIDE) WORLD))

(check-equal? (render 1)
    (place-image PET-ODD 3 (- WORLD-HEIGHT SQUARE-SIDE) WORLD))

(check-equal? (render 0)
    (place-image PET-EVEN 0 (- WORLD-HEIGHT SQUARE-SIDE) WORLD))

(define (main cws)
    (big-bang cws
        [on-tick tock]
        [to-draw render]))

(main 0)