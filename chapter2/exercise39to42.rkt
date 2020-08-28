#lang racket

(require rackunit 2htdp/universe 2htdp/image)

; Physical Constants Definition

; Car
(define RADIUS 5)
(define WHEEL-DISTANCE (* RADIUS 5))
(define CLEARANCE (* RADIUS 0.25))
(define BODY-WIDTH (* WHEEL-DISTANCE 2.4))
(define BODY-HEIGHT (* RADIUS 2))
(define CABIN-WIDTH (* WHEEL-DISTANCE 1.4))
(define CABIN-HEIGHT (* RADIUS 1.4))

; World
(define WORLD-WIDTH (* RADIUS 40))
(define WORLD-HEIGHT (* RADIUS 20))
(define CAR-Y (- WORLD-HEIGHT (* 2 RADIUS)))

; Tree
(define TREE-CRONE-SIZE (* RADIUS 2))
(define TREE-TRUNK-WIDTH (* RADIUS 0.4))
(define TREE-TRUNK-HEIGHT (* RADIUS 4))
(define TREE-UX (- (* RADIUS 2) TREE-TRUNK-WIDTH))
(define TREE-UY (* TREE-TRUNK-HEIGHT 0.75))

; Graphical Constants Definition

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

; Tree
(define TREE-CRONE
    (circle TREE-CRONE-SIZE "solid" "green"))

(define TREE-TRUNK
    (rectangle TREE-TRUNK-WIDTH
               TREE-TRUNK-HEIGHT "solid" "brown"))

(define TREE
    (underlay/xy TREE-CRONE
                 TREE-UX TREE-UY
                 TREE-TRUNK))

; World
(define BACKGROUND
    (empty-scene WORLD-WIDTH WORLD-HEIGHT "white"))

(define BACKGROUND-WITH-TREE
    (place-image TREE (/ WORLD-WIDTH 2) CAR-Y BACKGROUND))

; WorldState is a Number
; represents the current world state

; WorldState -> Image
; render image based on the current world state (cws)
(define (render cws)
    (place-image CAR cws CAR-Y
                 BACKGROUND-WITH-TREE))

(check-equal? (render 50)
    (place-image CAR 50 CAR-Y
                 BACKGROUND-WITH-TREE))

(check-equal? (render 0)
    (place-image CAR 0 CAR-Y
                 BACKGROUND-WITH-TREE))

(check-equal? (render 200)
    (place-image CAR 200 CAR-Y
                 BACKGROUND-WITH-TREE))

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
    (= cws WORLD-WIDTH))

(define (main cws)
    (big-bang cws
        [on-tick tick]
        [to-draw render]
        [stop-when end?]))

(main 0)