#lang racket
(require "../model/db.rkt"
         "common.rkt"
         (prefix-in card: "../model/card.rkt"))

(provide add-card)

(define (add-card category)
  (show-double-text-entry-dialog
   "Create New Card"
   "Question:"
   "Answer:"
   (lambda (question answer)
     (card:add-card db-connection category question answer))))

(define (today-minus num-days)
  (define seconds-in-day
    (* 60 60 24))
  (seconds->date
   (- (current-seconds)
      (* num-days seconds-in-day))))