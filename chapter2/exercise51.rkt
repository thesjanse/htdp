#lang racket

(require rackunit 2htdp/image 2htdp/universe)

; physical constants
(define LAMP-RADIUS 5)
(define INITIAL-STATE "yellow")

(define WIDTH (* LAMP-RADIUS 20))
(define HEIGHT (* LAMP-RADIUS 20))
(define LAMP-X (/ WIDTH 2))
(define LAMP-Y (/ HEIGHT 2))

; graphical constants
(define BACKGROUND
    (empty-scene WIDTH HEIGHT))


; TrafficLight is one of the three strings:
; - "green"
; - "yellow"
; - "red"
; represents the traffic light color

; WorldState is a Number
; represents the number of clock ticks remaining

; TrafficLight -> TrafficLight
; change the TrafficLight to the next stage
(define (traffic-light-next color)
    (cond
        [(string=? "red" color) "green"]
        [(string=? "green" color) "yellow"]
        [(string=? "yellow" color) "red"]))

(check-equal? (traffic-light-next "red") "green")
(check-equal? (traffic-light-next "green") "yellow")
(check-equal? (traffic-light-next "yellow") "red")

; TrafficLight -> Image
; render lamp image based on the current traffic light state
(define (render color)
    (place-image (circle LAMP-RADIUS "solid"
            (traffic-light-next color))
        LAMP-X LAMP-Y BACKGROUND))

(check-equal? (render "yellow")
    (place-image (circle LAMP-RADIUS "solid" "red")
        LAMP-X LAMP-Y BACKGROUND))

; WorldState -> WorldState
; decrease WorldState by 1 tick

(define (tick ws)
    (- ws 1))

(check-equal? (tick 40) 39)
(check-equal? (tick 1) 0)
(check-equal? (tick 10) 9)

; WorldState -> Boolean
; decide if there is 0 seconds left
; for traffic light to work

(define (main time state)
    (big-bang state
        [on-tick tick]
        [to-draw render]
        [stop-when zero?]))

(main 20 INITIAL-STATE)