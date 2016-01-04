;Fabio Gottlicher, A01647928, CS4700 Sp2015, programming assignment 2 - Jousting with Scheme


;jousting game between two knights.
;parameters: two knights
;returns: 1 is knight1 wins, 2 if knight2 wins
;if there are more than 10 rounds that are draws, winner is picked randomly
(define (jousting-game knight1 knight2)
	(display (string-append "Now jousting between: " (caddr (knight1)) " and: " (caddr (knight2))))
	(newline)
	(jousting-game-helper knight1 knight2 1)	;call helper function which keeps track of attempts to prevent deadlock
)

;helper function for jousting-game
(define (jousting-game-helper knight1 knight2 counter)
	(display "Round: ")(display counter)(display ", result of this round: ")
	(if (= counter 10) 
		(begin
			(display "Deadlock, picking winner randomly")
			(if (>= (random 10) 5) 1 2)	;if 10 unsuccessful rounds, pick random winner
		)

		(let(
			(results-this-round (joust knight1 knight2))
			)
			;(display results-this-round)
			(if (equal? (car results-this-round ) (cadr results-this-round ))
				(jousting-game-helper knight1 knight2 (+ counter 1))
				(if (equal? (car results-this-round) #t) 1 2)	;return 1 if first player #t (wins)
			)
		)
	)
)

;Joust between two knights
;A knight unhorses their opponent if:
;1. Their lance is high and their opponent’s shield is low
;2. Their lance is low and their opponent’s shield is high
;3. Their lance is low and their opponent’s shield is duck
;parameters: two knights
;returns: players statuses (on or off horse) as a list of two bools. 
;cadr player -> lance, car player -> shield
(define (joust player1 player2)
	(let*(
		(player1-status (cond
			( (and (equal? (cadr (player2)) 'high ) (equal? (car (player1)) 'low)) #f);pl1 off horse 
			( (and (equal? (cadr (player2)) 'low ) (equal? (car (player1)) 'high)) #f);pl1 off horse 
			( (and (equal? (cadr (player2)) 'low ) (equal? (car (player1)) 'duck)) #f);pl1 off horse 
			(else #t)

		))
		(player2-status (cond
			( (and (equal? (cadr (player1)) 'high ) (equal? (car (player2)) 'low)) #f);pl2 off horse 
			( (and (equal? (cadr (player1)) 'low ) (equal? (car (player2)) 'high)) #f);pl2 off horse 
			( (and (equal? (cadr (player1)) 'low ) (equal? (car (player2)) 'duck)) #f);pl2 off horse 
			(else #t)
		))
		)
		;(display player1-status)(display player2-status)
		(cond
			((equal? player1-status player2-status) (display "Tie"))
			((equal? player1-status #t) (display (string-append (caddr (player1)) " wins")))
			(else (display (string-append (caddr (player2)) " wins")))
		)
		(newline)
		(list player1-status player2-status)
	)
)
