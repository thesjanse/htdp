#lang racket

(require rackunit)

; Sample Problem
; The state of Tax Land has created a three-stage
; sales tax to cope with its budget deficit.
; Inexpensive items,those costing less than $1,000,
; are not taxed. Luxury items, with a price of
; more than $10,000, are taxed at the rate of
; eight per-cent (8.00%).
; Everything in between comes with a five percent(5.00%) markup.

; Price is a Number, which consists of three intervals:
; -- 0 <= Price < 1000;
; -- 1000 <= Price < 10000;
; -- 10000 <= Price.
; interpretation: the price of an item.

(define LOW-PRICE 1000)
(define LUXURY-PRICE 10000)

; Price -> Number
; Compute tax size from a given item price
(define (sales-tax price)
    (cond
        [(and (<= 0 price) (< price LOW-PRICE)) (* price 0)]
        [(and (<= LOW-PRICE price) (< price LUXURY-PRICE)) (* price 0.05)]
        [(<= LUXURY-PRICE price) (* price 0.08)]))

(check-equal? (sales-tax 0) 0)
(check-equal? (sales-tax 500) 0)
(check-equal? (sales-tax 999) 0)
(check-equal? (sales-tax 1000) (* 1000 0.05))
(check-equal? (sales-tax 2000) (* 2000 0.05))
(check-equal? (sales-tax 9999) (* 9999 0.05))
(check-equal? (sales-tax 10000) (* 10000 0.08))
(check-equal? (sales-tax 20000) (* 20000 0.08))