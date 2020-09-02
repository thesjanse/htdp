#lang racket

(require rackunit 2htdp/image 2htdp/universe)

; AnimationState is a Number.
; represents the number of clock ticks
; since the animation started

; Physical constants definition

; Car
(define RADIUS 5)
(define WHEEL-DISTANCE (* RADIUS 5))
(define CLEARANCE (* RADIUS 0.25))
(define BODY-WIDTH (* WHEEL-DISTANCE 2.4))
(define BODY-HEIGHT (* RADIUS 2))
(define CABIN-WIDTH (* WHEEL-DISTANCE 1.4))
(define CABIN-HEIGHT (* RADIUS 1.4))
(define SPEED 3)

; World
(define WORLD-WIDTH (* RADIUS 40))
(define WORLD-HEIGHT (* RADIUS 20))
(define CAR-Y (- WORLD-HEIGHT (* 2 RADIUS)))
(define START-AS 0)

; Graphical constants definition

; Car
(define COLOR "red")

(define WHEEL
    (circle RADIUS "solid" "black"))

(define SPACE-BETWEEN-WHEELS
    (rectangle WHEEL-DISTANCE CLEARANCE "solid" "white"))

(define CAR-BOTTOM
    (beside WHEEL SPACE-BETWEEN-WHEELS WHEEL))

(define CAR-BODY
    (rectangle BODY-WIDTH BODY-HEIGHT "solid" COLOR))

(define CAR-CABIN
    (rectangle CABIN-WIDTH CABIN-HEIGHT "solid" COLOR))

(define CAR
    (above CAR-CABIN
        (overlay/offset CAR-BOTTOM 0 (- RADIUS) CAR-BODY)))

; World
(define BACKGROUND
    (empty-scene WORLD-WIDTH WORLD-HEIGHT "white"))

; AnimationState -> AnimationState
; compute the following AnimationState from the given one
(define (tock as)
    (+ as 1))

(check-equal? (tock 5) 6)
(check-equal? (tock 0) 1)
(check-equal? (tock 1) 2)


; AnimationState -> Image
; create image on the X-coordinate from AnimationState (as)
(define (render as)
    (place-image CAR (* as SPEED) CAR-Y BACKGROUND))

(check-equal? (render 0)
    (place-image CAR 0 CAR-Y BACKGROUND))

(check-equal? (render 50)
    (place-image CAR 150 CAR-Y BACKGROUND))

(check-equal? (render 10)
    (place-image CAR 30 CAR-Y BACKGROUND))

(define (main as)
    (big-bang as
        [on-tick tock]
        [to-draw render]))

(main START-AS)