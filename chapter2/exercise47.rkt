#lang racket

(require rackunit 2htdp/image 2htdp/universe)

; happiness gauge
; input: max level of happiness
; max -> 0.1 (never drops to 0; -0.1 per tick)
; down key -> happiness increase by 1/5
; up key -> happiness increase by 1/3
; scene: solid red rectangle with black frame
; 0 -> bar gone, 100 -> full bar

; physical constants
(define DETERIORATION-SPEED 0.1)

; graphical constants

; HappinessLevel is a Number
; current level of pet happiness

; Number -> HappinessLevel
; deteriorate HappinessLevel with each clock tick
; can't go below 0

(define (tick chl)
    (if (equal? chl DETERIORATION-SPEED)
        chl
        (- chl DETERIORATION-SPEED)))

(check-equal? (tick 100) (- 100 DETERIORATION-SPEED))
(check-equal? (tick 50) (- 50 DETERIORATION-SPEED))
(check-equal? (tick 0.1) 0.1)

;;; (define (gauge max-happiness)
;;;     (big-bang max-happiness
;;;         [on-tick ...]
;;;         [to-draw ...]
;;;         [on-key ...]))