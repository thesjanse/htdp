#lang htdp/bsl

(require rackunit)
(require 2htdp/image)
(require 2htdp/universe)

; TrafficLight is a String, which consists of
; the following states:
; -- "yellow"
; -- "red"
; -- "green"
; interpretation: represents the active color
; of the traffic light

; physical constants
(define WORLD-WIDTH 300)
(define WORLD-HEIGHT 100)

(define LAMP-RADIUS 30)
(define LAMP-OFF-COLOR "grey")

(define OFFSET
    (/ (- WORLD-WIDTH
           (* 3 2 LAMP-RADIUS))
       4))

(define LAMP-RED-X
    (+ OFFSET LAMP-RADIUS))
(define LAMP-YELLOW-X
    (/ WORLD-WIDTH 2))
(define LAMP-GREEN-X
    (- WORLD-WIDTH OFFSET LAMP-RADIUS))

(define LAMP-Y
    (/ WORLD-HEIGHT 2))

; graphical contants
(define BACKGROUND
    (empty-scene WORLD-WIDTH WORLD-HEIGHT))
(define LAMP-OFF
    (circle LAMP-RADIUS "solid" LAMP-OFF-COLOR))


; TrafficLight -> TrafficLight
; yield the next state, given the current
; TrafficLight state
(define (tl-next tl)
    (cond
        [(equal? tl "yellow") "red"]
        [(equal? tl "red") "green"]
        [(equal? tl "green") "yellow"]))

(check-equal? (tl-next "yellow") "red")
(check-equal? (tl-next "red") "green")
(check-equal? (tl-next "green") "yellow")


; TrafficLight -> Image
; render the traffic light based on the current
; TrafficLight state
(define (render tl)
    (place-images
        (cond
            [(equal? tl "red")
                (list (circle LAMP-RADIUS "solid" "red")
                      LAMP-OFF
                      LAMP-OFF)]
            [(equal? tl "yellow")
                (list LAMP-OFF
                      (circle LAMP-RADIUS "solid" "yellow")
                      LAMP-OFF)]
            [(equal? tl "green")
                (list LAMP-OFF
                      LAMP-OFF
                      (circle LAMP-RADIUS "solid" "green"))])
        (list (make-posn LAMP-RED-X LAMP-Y)
              (make-posn LAMP-YELLOW-X LAMP-Y)
              (make-posn LAMP-GREEN-X LAMP-Y))
        BACKGROUND))


(check-equal? (render "red")
    (place-images
        (list (circle LAMP-RADIUS "solid" "red")
              LAMP-OFF
              LAMP-OFF)
        (list (make-posn LAMP-RED-X LAMP-Y)
              (make-posn LAMP-YELLOW-X LAMP-Y)
              (make-posn LAMP-GREEN-X LAMP-Y))
        BACKGROUND))

(check-equal? (render "yellow")
    (place-images
        (list LAMP-OFF
              (circle LAMP-RADIUS "solid" "yellow")
              LAMP-OFF)
        (list (make-posn LAMP-RED-X LAMP-Y)
              (make-posn LAMP-YELLOW-X LAMP-Y)
              (make-posn LAMP-GREEN-X LAMP-Y))
        BACKGROUND))

(check-equal? (render "green")
    (place-images
        (list LAMP-OFF
              LAMP-OFF
              (circle LAMP-RADIUS "solid" "green"))
        (list (make-posn LAMP-RED-X LAMP-Y)
              (make-posn LAMP-YELLOW-X LAMP-Y)
              (make-posn LAMP-GREEN-X LAMP-Y))
        BACKGROUND))

; TrafficLight -> Image
(define (traffic-light tl)
    (big-bang tl
        [on-tick tl-next 1]
        [to-draw render]))

(traffic-light "yellow")