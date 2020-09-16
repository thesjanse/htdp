#lang racket

(require rackunit 2htdp/image 2htdp/universe)

; WorldState is a Number
; number of pixels between the top margin and UFO image

; physical constants

(define WIDTH 300)
(define HEIGHT 100)

(define UFO-X
    (/ WIDTH 2))
(define UFO-HEIGHT 10)
(define UFO-COLOR "green")

(define TEXT-COLOR "black")
(define TEXT-SIZE 20)

(define CLOSE (/ HEIGHT 3))
(define LANDED (- HEIGHT (* 2 UFO-HEIGHT)))

; graphical constants

(define MTSCN (empty-scene WIDTH HEIGHT))
(define UFO
    (overlay (circle UFO-HEIGHT "solid" UFO-COLOR)
             (ellipse 40 UFO-HEIGHT "solid" UFO-COLOR)))


; WorldState -> WorldState
; calculate next y position for ufo per tick
(define (tick y)
    (+ y 3))

(check-equal? (tick 10) 13)
(check-equal? (tick 0) 3)
(check-equal? (tick 4) 7)

; WorldState -> String
(define (status y)
    (cond
        [(<= y CLOSE) "Descending"]
        [(and (> y CLOSE) (< y LANDED)) "Closing In"]
        [(>= y LANDED) "Landed"]))

(check-equal? (status (- CLOSE 1)) "Descending")
(check-equal? (status CLOSE) "Descending")
(check-equal? (status (+ 1 CLOSE)) "Closing In")
(check-equal? (status (- LANDED 1)) "Closing In")
(check-equal? (status LANDED) "Landed")

; WorldState -> Image
; place UFO at y-pos on the scene
(define (render y)
    (place-image (text (status y) TEXT-SIZE TEXT-COLOR)
                 (* TEXT-SIZE 2.6)
                 TEXT-SIZE
                 (place-image UFO UFO-X y MTSCN)))

(check-equal? (render 12)
    (place-image (text (status 12) TEXT-SIZE TEXT-COLOR)
                 (* TEXT-SIZE 2.6) TEXT-SIZE
                 (place-image UFO UFO-X 12 MTSCN)))

; WorldState -> WorldState
(define (main y)
    (big-bang y
        [on-tick tick]
        [to-draw render]))

(main 0)