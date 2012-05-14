#lang racket
(require db)

(provide add-card
         get-cards)

(define (add-card conn category question answer)
  (query-exec conn
              "INSERT INTO card VALUES(NULL, ?, ?, ?, 0, NULL, 'ready')"
              category question answer))

(define (get-cards conn category)
  (query-list conn 
              (string-append "SELECT name FROM card "
                             "WHERE category=?")
              category))