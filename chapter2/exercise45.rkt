#lang racket

(require 2htdp/image 2htdp/universe rackunit)

; physical constants

; "pet"
(define SQUARE-SIDE 10)
(define COLOR "blue")
(define SPEED 3)

; world
(define WORLD-WIDTH (* SQUARE-SIDE 80))
(define WORLD-HEIGHT (* SQUARE-SIDE 40))

; graphical constants

; "pet"
(define SQUARE (square SQUARE-SIDE "solid" COLOR))

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
    (place-image SQUARE (* cws SPEED) (- WORLD-HEIGHT SQUARE-SIDE) WORLD))

(check-equal? (render 50)
    (place-image SQUARE 150 (- WORLD-HEIGHT SQUARE-SIDE) WORLD))

(check-equal? (render 0)
    (place-image SQUARE 0 (- WORLD-HEIGHT SQUARE-SIDE) WORLD))

(define (main cws)
    (big-bang cws
        [on-tick tock]
        [to-draw render]))

(main 0)