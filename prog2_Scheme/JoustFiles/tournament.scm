;Fabio Gottlicher, A01647928, CS4700 Sp2015, programming assignment 2 - Jousting with Scheme

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;  'PUBLIC' INTERFACES	;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;interface function for tournament. takes in knight list.
; returns: a 1-based index of the winner
(define (tournament knightList)
	(listitemindex knightList (tournRound knightList '()))
)

;interface function for season. takes in knight list. 
; returns: a list parallel to knightslist which has number of wins 
(define (season numTournaments knightsList)
	(let(
			(scores (make-vector (length knightsList) 0))
		)
		(season-helper numTournaments knightsList scores)
	)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;  'PRIVATE' FUNCTIONS	;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;helper recurs. function for season. Passes down a scores vector to keep track.
(define (season-helper numTournaments knightsList scores)
	(if (= numTournaments 0)
		(begin	;base case, return list of wins for each
		(display "Finished season, scores for each knight:")(display scores)(newline)
		(vector->list scores)	
		)
		
		(begin 		 	;normal case
			(let*(
				(this-tourn-winner (- (tournament knightsList) 1))
				)
					(display "winner of this round of the season: ")(display (+ 1 this-tourn-winner))(newline)
					;(display "vector: ")(display scores)(newline)
					(vector-set! scores this-tourn-winner (+ (vector-ref scores this-tourn-winner) 1))
					(season-helper (- numTournaments 1) knightsList scores)
 			)
		)
	)
)

;helper function for tournament. plays whole tournament.
(define (tournRound winners losers)
	;(display "winners: ")(display winners)(display " length:")(display (length winners)) (display "cadr winners: ")(display (null? (cadr winners))) (display "  losers: ")(display losers)(newline)
	(if (and (equal? (length winners ) 2) (null? (cadr winners)))
		;final round
		(begin    ; Added begin here
			(display "Starting final round");(display losers)(newline)
			(let(
				(other-finalist (if (equal? (jousting-game (car losers) (caadr losers)) 1) (car losers) (caadr losers)))	;there will be still 2 
				)
				(display "finalists: ")(display (car winners))(display " and: ")(display other-finalist)(newline)
				(display "First final round: ")(newline)(jousting-game (car winners) other-finalist) (newline)
				(display "Second final round, the overall winner is: ")(newline)
				(if (equal? (jousting-game (car winners) other-finalist) 1) (car winners) other-finalist)	;return winner of second final round
			)
		)
		;normal round
		(begin    ; Added another begin here
			(display "Starting normal round")(newline)
			(let*(
					(winners-of-winners (round winners))
					(losers-of-winners (diff-li winners winners-of-winners))
					(winners-of-losers (round losers))
				)
				(display "Winners of winners:")(display winners-of-winners)(newline)
				(display "Losers of winners:")(display losers-of-winners)(newline)
				(display "Winners of losers:")(display winners-of-losers)(newline)
				(tournRound winners-of-winners (mix-up-losers losers-of-winners winners-of-losers))
			)
		)
	)
)

;a single round of the tournament. plays games between knights in the list.
	(cond
		((null? knightsList) '())	;base case
		((eqv? (list? knightsList) #f) knightsList)
		(else 
			(list
				(if (equal? (jousting-game (car knightsList) (cadr knightsList)) 1) (car knightsList) (cadr knightsList))
				(if (= (length knightsList) 2) '() (round (caddr knightsList)) )
			)
		)
	)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;  'LIBRARY' FUNCTIONS	;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; (define (diff-li base-li exclude-li)
; 	(if (null? exclude-li) 
; 		base-li 
; 		(diff-li (delete-from-li (car exclude-li) base-li) (cdr exclude-li)))
; )

(define (diff-li base-li exclude-li)
	;(display "diffing, big(base): ")(display base-li)(display ", excluding: ")(display exclude-li)(newline)
	(if (null? exclude-li)
		base-li
		(diff-li (delete-from-li (car exclude-li) base-li) (cdr exclude-li))
	)
)

(define (delete-from-li item li)
	;(display "deleting from list: ")(display li)(display "item: ")(display item)(newline)
	(if (null? li)
		'()
		(if (eqv? item (car li))
			(delete-from-li item (cdr li))
			(cons (car li) (delete-from-li item (cdr li)))
		)
	)
)

(define (mix-up-losers odds evens)
	(mix-up-losers-helper odds evens 1)
)

(define (mix-up-losers-helper odds evens counter)
	(cond
		((null? odds) evens)
		((null? evens) odds)
		(else	(if (= (modulo counter 2) 0)
				(list (car evens) (mix-up-losers-helper odds (cdr evens) (+ counter 1)));even
				(list (car odds) (mix-up-losers-helper (cdr odds) evens (+ counter 1)))	;odd
				)
		)
	)
)

(define (listitemindexhelper li item currIndex) ;helper function
	;(display currIndex)(newline)
	;(display li)(newline)
	(cond
		((null? li) 1)
		((equal? item (car li)) currIndex) ;return currIndex if at front of list
		(else (listitemindexhelper (cdr li) item (+ currIndex 1)))
	)
)

(define (listitemindex li item) ;interface function, call this
	(listitemindexhelper li item 1)
)
