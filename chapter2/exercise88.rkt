#lang racket

; define a structure type that keeps track
; of the cat's x-coordinate and its happiness.
; formulate data definition for cats dubbed VCat,
; including its interpretation.

(define-struct VCat [x h])
; VCat is a structure:
; (make-VCat Number Number),
; where x represents the x-coordinate of the cat
; and h stores the happiness level of the cat

; Happiness is a Number [0, 100]
; interpretation: represents the happiness level