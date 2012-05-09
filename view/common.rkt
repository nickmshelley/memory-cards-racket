#lang racket/gui

(provide set-frame!
         show-ok-dialog
         show-text-entry-dialog)

(define frame #f)

(define (set-frame! f)
  (set! frame f))

(define (show-ok-dialog title text [parent frame])
  (define dialog (new dialog% [parent parent] [label title]))
  (new message% [parent dialog] [label text])
  (define panel (new horizontal-panel% [parent dialog]
                     [alignment '(center center)]))
  (new button% [parent panel] [label "Ok"]
       [callback (lambda (b e) (send dialog show #f))])
  (send dialog show #t))

(define (show-ok-cancel-dialog title text on-ok [parent frame])
  (define dialog (new dialog% [parent parent] [label title]))
  (new message% [parent dialog] [label text])
  (define panel (new horizontal-panel% [parent dialog]
                     [alignment '(center center)]))
  (new button% [parent panel] [label "Cancel"]
       [callback (lambda (b e) (send dialog show #f))])
  (new button% [parent panel] [label "Ok"]
       [callback (lambda (b e) 
                   (on-ok)
                   (send dialog show #f))])
  (send dialog show #t))

;on-ok is string -> any
;where string is the non-empty result
(define (show-text-entry-dialog title label on-ok [parent frame])
  (define dialog (new dialog% [parent parent] [label title]))
  (define text-field (new text-field% [parent dialog] [label label]))
  (define panel (new horizontal-panel% [parent dialog]
                     [alignment '(center center)]))
  (new button% [parent panel] [label "Cancel"]
       [callback (lambda (b e) (send dialog show #f))])
  (new button% [parent panel] [label "Ok"]
       [callback 
        (lambda (b e)
          (define name (send text-field get-value))
          (if (= (string-length name) 0)
              (show-ok-dialog "Cannot be Empty"
                              "The field cannot be left blank"
                              dialog)
              (begin (on-ok name)
                     (send dialog show #f))))])
  (when (system-position-ok-before-cancel?)
    (send panel change-children reverse))
  (send dialog show #t))
