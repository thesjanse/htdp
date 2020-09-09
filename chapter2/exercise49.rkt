#lang racket

(require 2htdp/image)

; physical constants

; world
(define WIDTH 100)
(define HEIGHT 60)

; rocket
(define SIDE 7)
(define COLOR "red")

; graphical constants

; world
(define BACKGROUND
    (empty-scene WIDTH HEIGHT))

; rocket
(define ROCKET
    (triangle SIDE "solid" COLOR))

(define ROCKET-CENTER-TO-TOP
    (- HEIGHT (/ (image-height ROCKET) 2)))

(define (create-rocket-scene h)
    (place-image ROCKET 50
        (cond [(<= h ROCKET-CENTER-TO-TOP) h]
              [else ROCKET-CENTER-TO-TOP])
    BACKGROUND))