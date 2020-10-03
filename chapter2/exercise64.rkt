#lang racket

(require rackunit lang/posn)


; The Manhattan distance of a point to the origin
; considers a path that follows the rectangular
; grid of streets found in Manhattan.
; Design the function manhattan-distance,
; which measures the Manhattan distance of
; the given posn to the origin.

; constants
(define ORIGIN (make-posn 0 0))

; Direction is on of the following:
; -- X-DIRECTION
; -- Y-DIRECTION
(define X-DIRECTION 0)
(define Y-DIRECTION 1)

; Number -> Number
; get the square of a given number
(define (square a)
    (* a a))

(check-equal? (square 0) 0)
(check-equal? (square 2) 4)
(check-equal? (square -1) 1)

; posn -> Number
; calculate distance to the point
(define (get-distance point)
    (sqrt (+ (square (posn-x point))
             (square (posn-y point)))))

(check-equal? (get-distance (make-posn 4 0))
    (sqrt (+ (square 4) (square 0))))
(check-equal? (get-distance (make-posn 0 4))
    (sqrt (+ (square 0) (square 4))))
(check-equal? (get-distance (make-posn 4 3))
    (sqrt (+ (square 4) (square 3))))

; Number -> Number
; generate random integer between 0
; and given number
(define (randomize num)
    (random (+ num 1)))

(random-seed 1)
(check-equal? (randomize 9) 5)
(check-equal? (randomize 9) 8)
(check-equal? (randomize 9) 1)

; Direction -> Direction
; change direction (x, y) based on the current one
(define (change-direction dir)
    (modulo (+ dir 1) 2))

(check-equal?
    (change-direction X-DIRECTION) Y-DIRECTION)
(check-equal?
    (change-direction Y-DIRECTION) X-DIRECTION)

; posn, direction -> posn
; get next posn based on the current posn
(define (get-next-posn point dir)
    (make-posn
        (cond
            [(equal? dir X-DIRECTION) (randomize (posn-x point))]
            [else (posn-x point)])
        (cond
            [(equal? dir Y-DIRECTION) (randomize (posn-y point))]
            [else (posn-y point)])))

(random-seed 1)
(check-equal? (get-next-posn (make-posn 2 3) X-DIRECTION) (make-posn 1 3))
(random-seed 1)
(check-equal? (get-next-posn (make-posn 10 10) Y-DIRECTION) (make-posn 10 5))

; posn -> posn
; get difference between posns for
; distance calculation
(define (get-posn-difference a b)
    (make-posn (- (posn-x a) (posn-x b))
               (- (posn-y a) (posn-y b))))

(check-equal? (get-posn-difference
    (make-posn 5 2) (make-posn 3 0)) (make-posn 2 2))
(check-equal? (get-posn-difference
    (make-posn 5 2) (make-posn 0 1)) (make-posn 5 1))
(check-equal? (get-posn-difference
    (make-posn 2 0) (make-posn 2 0)) (make-posn 0 0))

; posn -> Number
; calculate Manhattan distance from
; point to the origin (random-walk)
(define (manhattan-distance point dir)
    (define next-point (get-next-posn point dir))
    (define next-dir (change-direction dir))
    (cond
        [(equal? point ORIGIN) 0]
        [else (+ (get-distance (get-posn-difference
                                point next-point))
                 (manhattan-distance next-point next-dir))]))

(check-equal? (manhattan-distance ORIGIN 0) 0)
(check-equal? (manhattan-distance (make-posn 5 0) 0) 5)
(check-equal? (manhattan-distance (make-posn 0 10) 0) 10)
(check-equal? (manhattan-distance (make-posn 3 4) 0) 7)
(check-equal? (manhattan-distance (make-posn 10 5) 0) 15)