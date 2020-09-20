#lang racket

(require rackunit 2htdp/image 2htdp/universe)

; Design a program that launches a rocket
; when the user of your program presses
; the space bar. The program first displays
; the rocket sitting at the bottom of the canvas.
; Oncelaunched, it moves upward at three
; pixels per clock tick.

; LRCD - Launching Rocket is one of:
; -- "resting"
; -- a Number between -3 and -1
; -- NonnegativeNumber
; "resting" represents a grounded rocket
; a countdown mode for 3 seconds
; a number denotes the distance between the
; top of the canvas and the reference point (its height)

; physical constants
(define WIDTH 200)
(define HEIGHT 300)
(define SPEED 3)

(define ROCKET-X (/ WIDTH 2))
(define ROCKET-WIDTH 6)
(define ROCKET-HEIGHT 30)
(define ROCKET-COLOR "green")

(define STATUS-FONT 12)
(define STATUS-COLOR "black")

; graphical constants
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define ROCKET
    (rectangle ROCKET-WIDTH
               ROCKET-HEIGHT
               "solid" ROCKET-COLOR))
(define ROCKET-CENTER
    (/ (image-height ROCKET) 2))

; LRCD -> Number
; calculate ROCKET y position offset based on the LRCD
; and SPEED
(define (fly lrcd)
    (cond
        [(or (and (string? lrcd)
                  (string=? lrcd "resting"))
             (< lrcd 0)) 0]
        [else (* lrcd SPEED)]))

(check-equal? (fly "resting") 0)
(check-equal? (fly -3) 0)
(check-equal? (fly -1) 0)
(check-equal? (fly 0) (* 0 SPEED))
(check-equal? (fly 1) (* 1 SPEED))
(check-equal? (fly 2) (* 2 SPEED))

; LRCD -> Number
; calculate y position as distance between
; canvas start and the rocket
(define (get-y-pos lrcd)
    (- HEIGHT (fly lrcd)))

(check-equal? (get-y-pos "resting") HEIGHT)
(check-equal? (get-y-pos -3) (- HEIGHT (fly -3)))
(check-equal? (get-y-pos -1) (- HEIGHT (fly -1)))
(check-equal? (get-y-pos 0) (- HEIGHT (fly 0)))
(check-equal? (get-y-pos 1) (- HEIGHT (fly 1)))
(check-equal? (get-y-pos 2) (- HEIGHT (fly 2)))

; LRCD -> Image
; render the rocket on the Y position against canvas
; position is the distance
; between the edge of canvas and rocket
(define (render lrcd)
    (place-image ROCKET ROCKET-X (get-y-pos lrcd) BACKGROUND))

(check-equal? (render -3)
    (place-image ROCKET ROCKET-X (get-y-pos -3) BACKGROUND))
(check-equal? (render 0)
    (place-image ROCKET ROCKET-X (get-y-pos 0) BACKGROUND))
(check-equal? (render 9)
    (place-image ROCKET ROCKET-X (get-y-pos 9) BACKGROUND))

; LRCD -> LRCD
; add 1 to LRCD with each clock tick
(define (tick lrcd)
    (cond
        [(and (string? lrcd) (string=? lrcd "resting")) "resting"]
        [else (+ lrcd 1)]))

(check-equal? (tick "resting") "resting")
(check-equal? (tick -1) 0)
(check-equal? (tick 0) 1)
(check-equal? (tick 1) 2)

; LRCD -> Image
; display status of the rocket at top left corner
; of canvas
(define (status/render lrcd)
    (place-image (text (cond [(and (string? lrcd)
                                   (string=? lrcd "resting")
                              "resting")]
                             [else (number->string (get-y-pos lrcd))])
                  STATUS-FONT STATUS-COLOR)
                 20 10 (render lrcd)))

(check-equal? (status/render "resting")
    (place-image (text "resting"
                  STATUS-FONT STATUS-COLOR)
                 20 10 (render -3)))
(check-equal? (status/render -3)
    (place-image (text (number->string (get-y-pos -3))
                  STATUS-FONT STATUS-COLOR)
                 20 10 (render -3)))
(check-equal? (status/render -1)
    (place-image (text (number->string (get-y-pos -1))
                  STATUS-FONT STATUS-COLOR)
                 20 10 (render -1)))
(check-equal? (status/render 0)
    (place-image (text (number->string (get-y-pos 0))
                  STATUS-FONT STATUS-COLOR)
                 20 10 (render 0)))
(check-equal? (status/render 1)
    (place-image (text (number->string (get-y-pos 1))
                  STATUS-FONT STATUS-COLOR)
                 20 10 (render 1)))
(check-equal? (status/render 3)
    (place-image (text (number->string (get-y-pos 3))
                  STATUS-FONT STATUS-COLOR)
                 20 10 (render 3)))

; LRCD Key -> lrcd
; initialize rocket launch sequence
; by pressing "up"
(define (launch-keh lrcd key)
    (cond
        [(and (string=? key "up")
              (string? lrcd)
              (string=? lrcd "resting")) -3]
        [else lrcd]))

(check-equal? (launch-keh "resting" "up") -3)
(check-equal? (launch-keh "resting" "down") "resting")
(check-equal? (launch-keh -3 "up") -3)
(check-equal? (launch-keh -10 "up") -10)

; LRCD -> Image
(define (main lrcd)
    (big-bang lrcd
        [to-draw status/render]
        [on-tick tick]
        [on-key launch-keh]))

(main "resting")
