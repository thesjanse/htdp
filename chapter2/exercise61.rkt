#lang racket

(require rackunit lang/posn
         2htdp/image 2htdp/universe)

; S-TrafficLight is one of:
; -- RED
; -- YELLOW
; -- GREEN

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

(define RED "red")
(define YELLOW "yellow")
(define GREEN "green")

; graphical constants
(define BACKGROUND
    (empty-scene WORLD-WIDTH WORLD-HEIGHT))
(define LAMP-OFF
    (circle LAMP-RADIUS "solid" LAMP-OFF-COLOR))

(define LAMPS-OFF
    (list LAMP-OFF LAMP-OFF LAMP-OFF))


; S-TrafficLight -> S-TrafficLight
; get the next state of the traffic light
(define (tl-next-symbolic stl)
    (cond [(equal? stl RED) GREEN]
          [(equal? stl GREEN) YELLOW]
          [(equal? stl YELLOW) RED]))

(check-equal? (tl-next-symbolic RED) GREEN)
(check-equal? (tl-next-symbolic GREEN) YELLOW)
(check-equal? (tl-next-symbolic YELLOW) RED)

; S-TrafficLight -> Image
; draw the working bulb based on the traffic state
(define (draw-bulb stl)
    (circle LAMP-RADIUS "solid" stl))

(check-equal? (draw-bulb RED)
    (circle LAMP-RADIUS "solid" RED))
(check-equal? (draw-bulb YELLOW)
    (circle LAMP-RADIUS "solid" YELLOW))
(check-equal? (draw-bulb GREEN)
    (circle LAMP-RADIUS "solid" GREEN))

; S-TrafficLight -> List
; return list with the position of the working bulb
(define (list-bulb stl)
    (list-set LAMPS-OFF
        (cond [(equal? stl RED) 0]
              [(equal? stl YELLOW) 1]
              [(equal? stl GREEN) 2])
        (draw-bulb stl)))

(check-equal? (list-bulb RED)
    (list (draw-bulb RED) LAMP-OFF LAMP-OFF))
(check-equal? (list-bulb GREEN)
    (list LAMP-OFF LAMP-OFF (draw-bulb GREEN)))
(check-equal? (list-bulb YELLOW)
    (list LAMP-OFF (draw-bulb YELLOW) LAMP-OFF))

; S-TrafficLight -> Image
; render the traffic light based on the current
; S-TrafficLight state
(define (render stl)
    (place-images
        (list-bulb stl)
        (list (make-posn LAMP-RED-X LAMP-Y)
              (make-posn LAMP-YELLOW-X LAMP-Y)
              (make-posn LAMP-GREEN-X LAMP-Y))
        BACKGROUND))

(check-equal? (render RED)
    (place-images
        (list (circle LAMP-RADIUS "solid" RED)
              LAMP-OFF
              LAMP-OFF)
        (list (make-posn LAMP-RED-X LAMP-Y)
              (make-posn LAMP-YELLOW-X LAMP-Y)
              (make-posn LAMP-GREEN-X LAMP-Y))
        BACKGROUND))

(check-equal? (render YELLOW)
    (place-images
        (list LAMP-OFF
              (circle LAMP-RADIUS "solid" YELLOW)
              LAMP-OFF)
        (list (make-posn LAMP-RED-X LAMP-Y)
              (make-posn LAMP-YELLOW-X LAMP-Y)
              (make-posn LAMP-GREEN-X LAMP-Y))
        BACKGROUND))

(check-equal? (render GREEN)
    (place-images
        (list LAMP-OFF
              LAMP-OFF
              (circle LAMP-RADIUS "solid" GREEN))
        (list (make-posn LAMP-RED-X LAMP-Y)
              (make-posn LAMP-YELLOW-X LAMP-Y)
              (make-posn LAMP-GREEN-X LAMP-Y))
        BACKGROUND))

; S-TrafficLight -> Image
(define (main stl)
    (big-bang stl
        [to-draw render]
        [on-tick tl-next-symbolic 1]))

(main YELLOW)