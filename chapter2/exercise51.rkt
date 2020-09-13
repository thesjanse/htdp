#lang racket

(require rackunit 2htdp/image 2htdp/universe)

; physical constants
(define LAMP-RADIUS 25)
(define INITIAL-STATE "red")

(define WIDTH (* LAMP-RADIUS 4))
(define HEIGHT (* LAMP-RADIUS 4))
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
    (place-image (circle LAMP-RADIUS "solid" color)
        LAMP-X LAMP-Y BACKGROUND))

(check-equal? (render "red")
    (place-image (circle LAMP-RADIUS "solid" "red")
        LAMP-X LAMP-Y BACKGROUND))

(define (main state rate duration)
    (big-bang state
        [on-tick traffic-light-next rate duration]
        [to-draw render]))

(main INITIAL-STATE 1 10)