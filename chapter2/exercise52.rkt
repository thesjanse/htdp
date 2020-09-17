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
(define TEXT-SIZE 10)

(define CLOSE (/ HEIGHT 3))

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



; WorldState -> Image
; place UFO at y-pos on the scene
(define (render y)
    (place-image UFO UFO-X y MTSCN))

(check-equal? (render 12)
    (place-image UFO UFO-X 12 MTSCN))

; WorldState -> Image
; place status text on top of the UFO image render
(define (status/render y)
    (cond
        [(<= 0 y CLOSE)
            (place-image (text "descending" TEXT-SIZE "green")
                         20 20 (render y))]
        [(and (> y CLOSE) (<= y HEIGHT))
            (place-image (text "closing in" TEXT-SIZE "orange")
                         20 20 (render y))]
        [(> y HEIGHT)
            (place-image (text "landed" TEXT-SIZE "red")
                         20 20 (render y))]))

(check-equal? (status/render (- CLOSE 1))
    (place-image (text "descending" TEXT-SIZE "green")
                 20 20 (render (- CLOSE 1))))
(check-equal? (status/render CLOSE)
    (place-image (text "descending" TEXT-SIZE "green")
                 20 20 (render CLOSE)))
(check-equal? (status/render (+ 1 CLOSE))
    (place-image (text "closing in" TEXT-SIZE "orange")
                 20 20 (render (+ 1 CLOSE))))
(check-equal? (status/render (- HEIGHT 1))
    (place-image (text "closing in" TEXT-SIZE "orange")
                 20 20 (render (- HEIGHT 1))))
(check-equal? (status/render HEIGHT)
    (place-image (text "closing in" TEXT-SIZE "orange")
                 20 20 (render HEIGHT)))
(check-equal? (status/render (+ HEIGHT 1))
    (place-image (text "landed" TEXT-SIZE "red")
                 20 20 (render (+ HEIGHT 1))))

; WorldState -> WorldState
(define (main y)
    (big-bang y
        [on-tick tick]
        [to-draw status/render]))

(main 0)