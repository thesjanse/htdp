#lang racket

(require rackunit 2htdp/image)

; Area is a Number
; interpretation: represents pixels squared

; Image -> Number
; compute are of a given image
(define (image-area img)
    (* (image-width img) (image-height img)))

(check-equal? (image-area (rectangle 2 4 "solid" "red")) 8)
(check-equal? (image-area (square 8 "outline" "blue")) 64)
(check-equal? (image-area (empty-scene 100 100)) 10000)