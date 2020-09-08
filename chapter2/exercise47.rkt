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
(define MAX-HAPPINESS 100)
(define DETERIORATION-SPEED 0.1)
(define GAUGE-WIDTH 200)
(define GAUGE-HEIGHT (/ GAUGE-WIDTH 4))
(define COLOR "red")

; graphical constants
(define BACKGROUND
    (rectangle GAUGE-WIDTH GAUGE-HEIGHT "outline" "black"))

; HappinessLevel is a Number
; current level of pet happiness

; HappinessLevel -> Number
; calculate the width of the bar in proportion
; to the current HappinessLevel
(define (get-gauge-x chl)
    (/ (* chl GAUGE-WIDTH) MAX-HAPPINESS))

(check-equal? (get-gauge-x 100) GAUGE-WIDTH)
(check-equal? (get-gauge-x 50) (/ GAUGE-WIDTH 2))
(check-equal? (get-gauge-x 26) (/ (* 26 GAUGE-WIDTH) MAX-HAPPINESS))

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

; HappinessLevel -> Image
; render the image depending on the current HappinessLevel
(define (render chl)
    (overlay/align "left" "middle" BACKGROUND
        (rectangle (get-gauge-x chl)
                    GAUGE-HEIGHT
                    "solid" COLOR)))

(check-equal? (render 100)
    (overlay BACKGROUND
        (rectangle (get-gauge-x 100)
                    GAUGE-HEIGHT
                    "solid" COLOR)))

(check-equal? (render 50)
    (overlay BACKGROUND
        (rectangle (get-gauge-x 50)
                    GAUGE-HEIGHT
                    "solid" COLOR)))

(check-equal? (render 26)
    (overlay BACKGROUND
        (rectangle (get-gauge-x 26)
                    GAUGE-HEIGHT
                    "solid" "red")))


; HappinessLevel -> HappinessLevel
; increase HappinessLevel by 1/3 of the current HappinessLevel
; by pressing up arrow
; increase HappinessLevel by 1/5 of the current HappinessLevel
; by pressing down arrow

(define (key-handler hl key)
    (cond
        [(key=? key "up") (+ hl (* hl 0.34))]
        [(key=? key "down") (+ hl (* hl 0.2))]))

(check-equal? (key-handler 0 "up") 0)
(check-equal? (key-handler 0.1 "up") (+ 0.1 (* 0.1 0.34)))
(check-equal? (key-handler 10 "up") (+ 10 (* 10 0.34)))
(check-equal? (key-handler 0 "down") 0)
(check-equal? (key-handler 0.1 "down") (+ 0.1 (* 0.1 0.2)))
(check-equal? (key-handler 10 "down") (+ 10 (* 10 0.2)))

(define (gauge max-happiness)
    (big-bang max-happiness
        [on-tick tick]
        [to-draw render]
        [on-key key-handler]))

(gauge MAX-HAPPINESS)