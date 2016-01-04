;Fabio Gottlicher, A01647928, CS4700 Sp2015, programming assignment 2 - Jousting with Scheme

(load "knights.scm") ; You may need full paths to your files here
(load "game.scm")
(load "tournament.scm")

(display "----Playing a game----\n")
(jousting-game black-knight king-arthur)
(display "----Playing a tournament----\n")
(display (tournament (list black-knight sir-robin king-arthur joan-of-arc)))
(display "----Playing a season----\n")
(season 50 (list black-knight sir-robin king-arthur joan-of-arc))