#lang racket

(require rackunit lang/posn
         2htdp/image 2htdp/universe)

; N-TrafficLight is one of:
; -- 0: the traffic light shows red
; -- 1: the traffic light shows green
; -- 2: the traffic light shows yellow

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

; graphical constants
(define BACKGROUND
    (empty-scene WORLD-WIDTH WORLD-HEIGHT))
(define LAMP-OFF
    (circle LAMP-RADIUS "solid" LAMP-OFF-COLOR))

(define LAMPS-OFF
    (list LAMP-OFF LAMP-OFF LAMP-OFF))


; N-TrafficLight -> N-TrafficLight
; get the next state of the traffic light
(define (tl-next-numeric ntl)
    (modulo (+ ntl 1) 3))

(check-equal? (tl-next-numeric 0) 1)
(check-equal? (tl-next-numeric 1) 2)
(check-equal? (tl-next-numeric 2) 0)

; N-TrafficLight -> Image
; draw the working bulb based on the traffic state
(define (draw-bulb ntl)
    (circle LAMP-RADIUS "solid"
        (cond
            [(equal? ntl 0) "red"]
            [(equal? ntl 2) "yellow"]
            [(equal? ntl 1) "green"])))

(check-equal? (draw-bulb 0)
    (circle LAMP-RADIUS "solid" "red"))
(check-equal? (draw-bulb 2)
    (circle LAMP-RADIUS "solid" "yellow"))
(check-equal? (draw-bulb 1)
    (circle LAMP-RADIUS "solid" "green"))

; N-TrafficLight -> List
; return list with the position of the working bulb
(define (list-bulb ntl)
    (list-set LAMPS-OFF
        (cond [(equal? ntl 0) 0]
              [(equal? ntl 1) 2]
              [(equal? ntl 2) 1])
        (draw-bulb ntl)))

(check-equal? (list-bulb 0)
    (list (draw-bulb 0) LAMP-OFF LAMP-OFF))
(check-equal? (list-bulb 1)
    (list LAMP-OFF LAMP-OFF (draw-bulb 1)))
(check-equal? (list-bulb 2)
    (list LAMP-OFF (draw-bulb 2) LAMP-OFF))

; TrafficLight -> Image
; render the traffic light based on the current
; N-TrafficLight state
(define (render ntl)
    (place-images
        (list-bulb ntl)
        (list (make-posn LAMP-RED-X LAMP-Y)
              (make-posn LAMP-YELLOW-X LAMP-Y)
              (make-posn LAMP-GREEN-X LAMP-Y))
        BACKGROUND))

(check-equal? (render 0)
    (place-images
        (list (circle LAMP-RADIUS "solid" "red")
              LAMP-OFF
              LAMP-OFF)
        (list (make-posn LAMP-RED-X LAMP-Y)
              (make-posn LAMP-YELLOW-X LAMP-Y)
              (make-posn LAMP-GREEN-X LAMP-Y))
        BACKGROUND))

(check-equal? (render 2)
    (place-images
        (list LAMP-OFF
              (circle LAMP-RADIUS "solid" "yellow")
              LAMP-OFF)
        (list (make-posn LAMP-RED-X LAMP-Y)
              (make-posn LAMP-YELLOW-X LAMP-Y)
              (make-posn LAMP-GREEN-X LAMP-Y))
        BACKGROUND))

(check-equal? (render 1)
    (place-images
        (list LAMP-OFF
              LAMP-OFF
              (circle LAMP-RADIUS "solid" "green"))
        (list (make-posn LAMP-RED-X LAMP-Y)
              (make-posn LAMP-YELLOW-X LAMP-Y)
              (make-posn LAMP-GREEN-X LAMP-Y))
        BACKGROUND))

(define (main ntl)
    (big-bang ntl
        [to-draw render]
        [on-tick tl-next-numeric 1]))

(main 2)