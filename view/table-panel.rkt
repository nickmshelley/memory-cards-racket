#lang racket/gui

(provide table-panel%)

(define table-panel%
  (class panel%
    (init parent)
    (init width)
    (super-instantiate (parent))
    (define num-columns width)
    (define column-widths #f)
    (define row-heights #f)
    
    (define/override (container-size info)
      (define amount (length info))
      (if (> amount 0)
          (set!-values (column-widths row-heights)
                       (let loop ([current-item 0]
                                  [column-widths (make-immutable-hash)]
                                  [row-heights (make-immutable-hash)])
                         (define column (modulo current-item num-columns))
                         (define row (inexact->exact (truncate (/ current-item num-columns))))
                         (define this-width (first (list-ref info current-item)))
                         (define new-widths
                           (if (> this-width (hash-ref column-widths column 0))
                               (hash-set column-widths column this-width)
                               column-widths))
                         (define this-height (second (list-ref info current-item)))
                         (define new-heights
                           (if (> this-height (hash-ref row-heights row 0))
                               (hash-set row-heights row this-height)
                               row-heights))
                         (if (< current-item (sub1 amount))
                             (loop (add1 current-item) new-widths new-heights)
                             (values new-widths new-heights))))
          (set!-values (column-widths row-heights)
                       (values (make-immutable-hash '((0 . 0)))
                               (make-immutable-hash '((0 . 0))))))
      (values (apply + (hash-values column-widths))
              (apply + (hash-values row-heights))))
    
    
    (define/override (place-children info width height)
      (define amount (length info))
      (if (> amount 0)
          (let loop ([sizes empty]
                     [current-item 0]
                     [x 0]
                     [y 0])
            (define column (modulo current-item num-columns))
            (define row (inexact->exact (truncate (/ current-item num-columns))))
            (define current-width (hash-ref column-widths column))
            (define current-height (hash-ref row-heights row))
            (define new-sizes (cons (list x y current-width current-height) sizes))
            (define-values (next-x next-y)
              (if (= column (sub1 num-columns))
                  (values 0 (+ y current-height))
                  (values (+ x current-width) y)))
            (if (< current-item (sub1 amount))
                (loop new-sizes
                      (add1 current-item)
                      next-x
                      next-y)
                (reverse new-sizes)))
          empty))))



