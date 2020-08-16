#lang racket

(require rackunit)
(require 2htdp/image)

; Categorize image based on its width & height
; into 3 categories: tall, wide, square
; Image -> String
(define (classify-image i)
    (cond ((= (image-width i)
              (image-height i))
            "square")
           ((> (image-width i)
               (image-height i))
            "wide")
           ((< (image-width i)
               (image-height i))
            "tall")))


(check-equal? (classify-image (square 40 "solid" "black")) "square")
(check-equal? (classify-image (rectangle 200 50 "solid" "red")) "wide")
(check-equal? (classify-image (rectangle 50 200 "solid" "blue")) "tall")