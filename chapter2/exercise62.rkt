#lang racket

(require rackunit 2htdp/image 2htdp/universe)

; Design  a world program that simulates the
; working of a door with an automatic door closer.
; If this kind of door is locked, you can unlock
; it with a key. An unlocked door is closed, but
; someone pushing at the door opens it. Once
; the person has passed through the door and
; lets go, the automatic door takes over and
; closes the door again. When a door is closed,
; it can be locked again.

(define LOCKED "locked")
(define CLOSED "closed")
(define OPEN "open")

; DoorState is one of:
; -- LOCKED
; -- CLOSED
; -- OPEN

; physical constants
(define WIDTH 200)
(define HEIGHT (/ WIDTH 2))
(define STATUS-COLOR "black")
(define STATUS-FONT-SIZE 24)
(define STATUS-X (/ WIDTH 2))
(define STATUS-Y (/ HEIGHT 2))

; graphical constants
(define BACKGROUND
    (empty-scene WIDTH HEIGHT))

; DoorState -> DoorState
; closes the door after one tick
; if it's open
(define (door-closer ds)
    (cond
        [(equal? ds CLOSED) CLOSED]
        [(equal? ds LOCKED) LOCKED]
        [(equal? ds OPEN) CLOSED]))

(check-equal? (door-closer CLOSED) CLOSED)
(check-equal? (door-closer LOCKED) LOCKED)
(check-equal? (door-closer OPEN) CLOSED)

; DoorState Key -> DoorState
; Change state according to:
; -- "l" key: lock the door if it's closed.
; -- "u" key: unlock the door if it's locked.
; -- " " key: push the door if it's open
(define (door-action ds key)
    (cond
        [(and (equal? key "l")
              (equal? ds CLOSED)) LOCKED]
        [(and (equal? key "u")
              (equal? ds LOCKED)) CLOSED]
        [(and (equal? key " ")
              (equal? ds CLOSED)) OPEN]
        [else ds]))

(check-equal? (door-action CLOSED "l") LOCKED)
(check-equal? (door-action OPEN "l") OPEN)
(check-equal? (door-action LOCKED "l") LOCKED)
(check-equal? (door-action LOCKED "u") CLOSED)
(check-equal? (door-action CLOSED "u") CLOSED)
(check-equal? (door-action OPEN "u") OPEN)
(check-equal? (door-action CLOSED " ") OPEN)
(check-equal? (door-action LOCKED " ") LOCKED)
(check-equal? (door-action OPEN " ") OPEN)
(check-equal? (door-action OPEN "a") OPEN)
(check-equal? (door-action CLOSED "a") CLOSED)
(check-equal? (door-action LOCKED "a") LOCKED)

; DoorState -> Image
; render the door status image based on its DoorState
(define (door-render ds)
    (place-image
        (text ds STATUS-FONT-SIZE STATUS-COLOR)
        STATUS-X STATUS-Y BACKGROUND))

(check-equal? (door-render LOCKED)
    (place-image
        (text LOCKED STATUS-FONT-SIZE STATUS-COLOR)
        STATUS-X STATUS-Y BACKGROUND))
(check-equal? (door-render OPEN)
    (place-image
        (text OPEN STATUS-FONT-SIZE STATUS-COLOR)
        STATUS-X STATUS-Y BACKGROUND))
(check-equal? (door-render CLOSED)
    (place-image
        (text CLOSED STATUS-FONT-SIZE STATUS-COLOR)
        STATUS-X STATUS-Y BACKGROUND))

; DoorState -> Image
(define (main ds)
    (big-bang ds
        [on-tick door-closer 3]
        [to-draw door-render]
        [on-key door-action]))

(main LOCKED)