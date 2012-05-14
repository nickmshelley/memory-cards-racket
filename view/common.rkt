#lang racket/gui

(provide set-frame!
         show-ok-dialog
         show-ok-cancel-dialog
         show-text-entry-dialog
         show-double-text-entry-dialog)

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
  (define dialog (new dialog% [parent parent] [label title]
                      #;[x (send parent get-x)] 
                      #;[y (send parent get-y)]))
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

;on-ok is string string -> any
;where strings are the non-empty results
(define (show-double-text-entry-dialog title label1 label2 on-ok [parent frame])
  (define dialog (new dialog% [parent parent] [label title]))
  (define question-field (new text-field% [parent dialog] [label label1]))
  (define answer-field (new text-field% [parent dialog] [label label1] [style '(multiple)]))
  (define panel (new horizontal-panel% [parent dialog]
                     [alignment '(center center)]))
  (new button% [parent panel] [label "Cancel"]
       [callback (lambda (b e) (send dialog show #f))])
  (new button% [parent panel] [label "Ok"]
       [callback 
        (lambda (b e)
          (define question (send question-field get-value))
          (define answer (send answer-field get-value))
          (if (or (= (string-length question) 0)
                  (= (string-length answer) 0))
              (show-ok-dialog "Cannot be Empty"
                              "The fields cannot be left blank"
                              dialog)
              (begin (on-ok question answer)
                     (send dialog show #f))))])
  (when (system-position-ok-before-cancel?)
    (send panel change-children reverse))
  (send dialog show #t))
