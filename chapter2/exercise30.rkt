#lang racket

(require rackunit)

(define DEFAULT-PRICE 5.0)
(define DEFAULT-ATTENDANCE 120)
(define FIXED-COST 0)
(define VARIABLE-COST 1.5)
(define CHANGE-IN-PEOPLE 15)
(define CHANGE-IN-PRICE 0.1)

(define PRICE-SENSITIVITY (/ CHANGE-IN-PEOPLE CHANGE-IN-PRICE))

(define (avg-attendance ticket-price)
    (- DEFAULT-ATTENDANCE (* (- ticket-price DEFAULT-PRICE) PRICE-SENSITIVITY)))

(define (revenue ticket-price)
    (* ticket-price (avg-attendance ticket-price)))

(define (cost ticket-price)
    (+ FIXED-COST (* VARIABLE-COST
                     (avg-attendance ticket-price))))

(define (profit ticket-price)
    (- (revenue ticket-price)
       (cost ticket-price)))