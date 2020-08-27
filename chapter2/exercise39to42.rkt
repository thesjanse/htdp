#lang racket

(require rackunit 2htdp/universe 2htdp/image)

; Physical Constants Definition
(define RADIUS 5)
(define WHEEL-DISTANCE (* RADIUS 5))
(define CLEARANCE (* RADIUS 0.25))
(define BODY-WIDTH (* WHEEL-DISTANCE 2.4))
(define BODY-HEIGHT (* RADIUS 2))
(define CABIN-WIDTH (* WHEEL-DISTANCE 1.4))
(define CABIN-HEIGHT (* RADIUS 1.4))


; Graphical Constants Definition
(define COLOR "green")

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

; WorldState is a Number
; represents the current world state

; WorldState -> Image
; render image based on the current world state (cws)
(define (render cws)
    cws)

; WorldState -> WorldState
; get the next WorldState by adding 3
; to the current world state (cws)
(define (tick cws)
    (+ 3 cws))

(check-equal? (tick 0) 3)
(check-equal? (tick 10) 13)
(check-equal? (tick -3) 0)

; WorldState -> Boolean
; evaluate the end? after each event
(define (end? cws)
    cws)

CAR