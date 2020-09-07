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

; HappinessLevel -> HappinessLevel
; deteriorate HappinessLevel with each clock tick
; can't go below 0

(define (tick chl)
    (if (equal? chl DETERIORATION-SPEED)
        chl
        (- chl DETERIORATION-SPEED)))

(check-equal? (tick 100) (- 100 DETERIORATION-SPEED))
(check-equal? (tick 50) (- 50 DETERIORATION-SPEED))
(check-equal? (tick 0.1) 0.1)

; HappinessLevel -> HappinessLevel
; increase HappinessLevel by 1/3 of the current HappinessLevel
; by pressing up arrow
; increase HappinessLevel by 1/5 of the current HappinessLevel
; by pressing down arrow

(define (key-handler key hl)
    (cond
        [(key=? key "up") (+ hl (* hl 0.34))]
        [(key=? key "down") (+ hl (* hl 0.2))]))

(check-equal? (key-handler "up" 0) 0)
(check-equal? (key-handler "up" 0.1) (+ 0.1 (* 0.1 0.34)))
(check-equal? (key-handler "up" 10) (+ 10 (* 10 0.34)))
(check-equal? (key-handler "down" 0) 0)
(check-equal? (key-handler "down" 0.1) (+ 0.1 (* 0.1 0.2)))
(check-equal? (key-handler "down" 10) (+ 10 (* 10 0.2)))

;;; (define (gauge max-happiness)
;;;     (big-bang max-happiness
;;;         [on-tick ...]
;;;         [to-draw ...]
;;;         [on-key ...]))