#lang racket

(require rackunit 2htdp/image 2htdp/universe)

; Design a program that launches a rocket
; when the user of your program presses
; the space bar. The program first displays
; the rocket sitting at the bottom of the canvas.
; Oncelaunched, it moves upward at three
; pixels per clock tick.

; LRCD - Launching Rocket is one of:
; -- "resting"
; -- a Number between -3 and -1
; -- NonnegativeNumber
; "resting" represents a grounded rocket
; a countdown mode for 3 seconds
; a number denotes the distance between the
; top of the canvas and the reference point (its height)

; physical constants
(define WIDTH 200)
(define HEIGHT 300)
(define SPEED 3)

(define ROCKET-X (/ WIDTH 2))
(define ROCKET-WIDTH 6)
(define ROCKET-HEIGHT 30)
(define ROCKET-COLOR "green")

; graphical constants
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define ROCKET
    (rectangle ROCKET-WIDTH
               ROCKET-HEIGHT
               "solid" ROCKET-COLOR))
(define ROCKET-CENTER
    (/ (image-height ROCKET) 2))

; LRCD -> Image
; render the rocket on the Y position against canvas
; position is the distance
; between the edge of canvas and rocket
(define (render lrcd)
    (place-image ROCKET ROCKET-X (- HEIGHT lrcd) BACKGROUND))

(check-equal? (render 0)
    (place-image ROCKET ROCKET-X (- HEIGHT 0) BACKGROUND))
(check-equal? (render 9)
    (place-image ROCKET ROCKET-X (- HEIGHT 9) BACKGROUND))

; LRCD -> LRCD
; add 1 to LRCD with each clock tick
(define (tick lrcd)
    (+ lrcd 1))

(check-equal? (tick -1) 0)
(check-equal? (tick 0) 1)
(check-equal? (tick 1) 2)

; LRCD -> Image
(define (main lrcd)
    (big-bang lrcd
        [to-draw render]
        [on-tick tick]))

(main -1)
