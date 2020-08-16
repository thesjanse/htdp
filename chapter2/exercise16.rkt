#lang racket

(require rackunit 2htdp/image)

; calculate area of the given image
; Image -> Number
(define (image-area img)
    (* (image-width img)
       (image-height img)))

(check-equal? (image-area (square 0 "solid" "black")) 0)
(check-equal? (image-area (square 2 "solid" "black")) 4)
(check-equal? (image-area (rectangle 4 2 "solid" "red")) 8)
(check-equal? (image-area (rectangle 0 4 "solid" "blue")) 0)
(check-equal? (image-area (rectangle 4 0 "solid" "green")) 0)