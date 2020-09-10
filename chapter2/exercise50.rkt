#lang racket

(require rackunit)

; TrafficLight
; is one of the three strings:
; - "green"
; - "yellow"
; - "red"
; represents the traffic light color

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