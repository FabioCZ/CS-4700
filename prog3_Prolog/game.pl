%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% game.pl  
% Escape the Gulag by Fabio Gottlicher
% CS4700
%
% Use this as the starting point for your game.  This starter code includes
% the following:
%  - Some example areas
%  - An example of how you might connect those areas 
%  - Handling of the actions 'go _______.', 'help.', and 'quit.'
%  - Basic game loop
%  - Input processing which strips case and punctuation and puts the words into a list 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Facts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%inventory
:- dynamic inventory/1.
% Dynamic fact used to store the player's current location
:- dynamic currentArea/1.	
% Assert this dynamic fact to stop the game once the player has won (or lost!) 
:- dynamic gameNotLost/0.
:- dynamic gameNotWon/0.
%time of the dai
:- dynamic currentTime/1.


% Here is one way you might create your areas
area(building1, 'Buidling 1', 'You find yourself in your living quarters. An old wooden shack, with several bunk beds and mice. You are in your bunk. You should probably go out to the courtyard', 'You find yourself in your living quarters. An old wooden shack, with several bunk beds and mice. You are in your bunk. You should probably go out to the courtyard').
area(courtyard, 'Courtyard', 'You see the whole of your prison camp. You see these buildings: "building1", "building2", "warehouse", "latrine", "mine", "guardshouse, "gate". You also notice that there is small hole in the fence ("fence").', 'You see the whole of your prison camp. You see these buildings: "building1", "building2", "warehouse", "latrine", "mine", "guardshouse, "gate". You also notice that there is small hole in the fence ("fence").').
area(building2, 'Building 2', 'You find yourself at the other living quarters building. Although it looks exactly the same. Only the mice here seem meaner. Everyone is gone except for tough guy Alexei. He looks like he could use a smoke.', 'You find yourself at the other living quarters building. Although it looks exactly the same. Only the mice here seem meaner. Bunch of sleeping guys, including Alexei. He looks like he could use a smoke.').
area(warehouse, 'Warehouse', 'The warehouse where equipment is stored. Through the glass on the safe, you can see the cutters.', 'The warehouse where equipment is stored. Through the glass on the safe, you can see the cutters.').
area(latrine, 'Latrine', 'You find yourself well......in a latrine. Wooden board with a hole going to the ground. Toilet paper? You wish.', 'You find yourself well......in a latrine. Wooden board with a hole going to the ground. Toilet paper? You wish.').
area(mine, 'Mine', '*sigh*. This is your daily hell. 16 hour shifts mining some delicious uranium. ', '*sigh*. This is your daily hell. 16 hour shifts mining some delicious uranium. ').
area(guardshouse, 'Guardshouse', 'The guardshouse. Probably should not mess with things here during the day.', 'All of the guards are asleep. If you\'re careful, you can probably steal something here.' ).
area(fence, 'Fence', 'This part of the fance looks to be in a pretty bad shape. If you want to cut it, I would try not to attract much attention.', 'This part of the fance looks to be in a pretty bad shape. Not getting a lot of attention now.').
area(outside, 'Outside', 'N/A', 'You have made it outside. Good job.').

% Items
item(cutters, 'Pair of cutters. Can probably cut through a fence.').
item(cigarettes, 'Pack of Zvezda cigarettes.').
item(cigarette, 'A single cigarette.').
item(alexei, 'N/A').
item(sickle, 'A sickle. Probably good for cutting grass. A symbol of communism.').
item(hammer, 'A hammer. Probably can provide a bunch of force. A symbol of communism.').
item(bread, 'Hard, dark bread. Possibly edible, probably not.').
item(uranium, 'A piece of uranium ore. Probaly not good for you to be around. But you\'ve been around it for months, can\'t hurt anymore').
item(safe, 'A safe, containing some goodies that they probably don\'t want you to have.').
item(mud, 'A bunch of half frozen mud. Probably useless.').
item(keys, 'Keys to the warehouse.').

%locations
:- dynamic itemLocation/2.

% Door safe lock
:- dynamic locked/0.

%Fence cut
:- dynamic fenceNotCut/0.
:- dynamic keysDontHave/0.

% You might connect your areas like this:
connected(courtyard, building1).
connected(courtyard, building2).
connected(courtyard, warehouse).
connected(courtyard, latrine).
connected(courtyard, mine).
connected(courtyard, guardshouse).
connected(courtyard, fence).
connected(fence, outside).

connected(building1, courtyard).
connected(building2, courtyard).
connected(warehouse, courtyard).
connected(latrine, courtyard).
connected(mine, courtyard).
connected(guardshouse, courtyard).
connected(fence, courtyard).
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input Processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Handling of the action 'go _______.', and a good example of how you might implement others

processInput([go, to, B]) :-
	processInput([go, B]).

processInput([go, to, _]) :-
	processInput([go, _]).

processInput([go, outside]) :-
	print('Should not do this during the day.'), nl.
processInput([go, warehouse]) :-
	keysDontHave,
	print('warehouse is locked'), nl.

processInput([go, NewRoom]) :-
    currentArea(Current),
    connected(Current, NewRoom),
    currentTime(day),
    changeArea(NewRoom).


processInput([go, warehouse]) :-
	currentArea(Current),
    connected(Current, warehouse),
    currentTime(day),
    changeArea(warehouse).

processInput([go, _]) :-
	currentTime(night), print('It is night. You need to sneak, or you\'ll get caught. Be careful next time'), nl.

processInput([go, _]) :-
    print('Are you trying to go somwhere that doesn\'t exist, or are you trying to go from building to buidling without going outside first, or are you trying to go where you already are ?'), nl, nl.


%sneak process
processInput([sneak, outside]) :-
	fenceNotCut,
	print('No can do. You need to cut the fence first.'), nl.

processInput([sneak, outside]) :-
	currentArea(Current),
	connected(Current, outside),
	changeArea(outside),
	retractall(gameNotWon).


processInput([sneak, warehouse]) :-
	keysDontHave,
	print('warehouse is locked').

processInput([sneak, to, A]) :-
	processInput([sneak, A]).

processInput([sneak, to, _]) :-
	processInput([sneak, _]).

processInput([sneak, NewRoom]) :-
    currentArea(Current),
    connected(Current, NewRoom),
    currentTime(night),
    changeArea(NewRoom).

processInput([sneak, warehouse]) :-
	currentArea(Current),
    connected(Current, warehouse),
    currentTime(day),
    changeArea(warehouse).

processInput([sneak, _]) :-
	currentTime(day), print('It is day. If you go around sneaking, you will be suspicious'), nl.

processInput([sneak, _]) :-
    print('Are you trying to sneak somwhere that doesn\'t exist, or are you trying to sneak from building to buidling without going outside first, or are you trying to sneak where you already are ?'), nl, nl.

%Inventory
processInput([inventory]) :-
  print('Your are carrying:'), nl,
  findall(I, inventory(I), Inventory),
  print(Inventory), nl.

%pick up process

processInput([pick, up, alexei]) :-
  currentArea(Current),
  itemLocation(alexei, Current),
  print('not a good idea. Alexei is a tough guy. You get a punch in the face and pass out. Game Over. Better luck next time.'), nl,
  retractall(gameNotLost).

processInput([pick, up, safe]) :-
	currentArea(warehouse),
	print('You can\'t pick that up. Way too heavy.'), nl.

processInput([pick, up, cutters]) :-
	currentArea(Current),
	itemLocation(cutters, Current),
	locked,
	print('You wish you could pick those up, but they are locked in a safe. Too bad.'), nl.

processInput([pick, up, CigItem]) :-
  currentArea(guardshouse),
  currentTime(day),
  print('You try to pick up the '), print(CigItem), print(' . The guards get you and you get sent to solitary. Better luck next time.'), nl,
  retractall(gameNotLost).

processInput([pick, up, Item]) :-
  currentArea(Current),
  itemLocation(Item, Current),
  assertz(inventory(Item)),
  retract(itemLocation(Item, Current)),
  item(Item, DescriptionItem),
  print('You picked up '), write(Item), write(', description: '), write(DescriptionItem), nl.


processInput([pick, up, _]) :-
print('stuff'), nl.

%drop
processInput([drop, Item]) :-
  inventory(Item),
  currentArea(Current),
  retract(inventory(Item)),
  assertz(itemLocation(Item, Current)),
  print('You dropped '),print(Item),print('.'), nl.
processInput([drop, _]) :-
  print('You can\' drop something you don\'t have'),  nl.
%give process
processInput([give, _, to, alexei]) :-
	currentTime(night),
	currentArea(Current),
	itemLocation(alexei, Current),
	inventory(cigarettes),
	print('Alexei is asleep. Not a good time now.'), nl.

processInput([give, cigarette, to, alexei]) :-
	currentArea(Current),
	itemLocation(alexei, Current),
	inventory(cigarette),
	retract(inventory(cigarette)),
	print('It\'s going to take more than that to keep me happy. Try to do better. I will take this one for wasting my time anyway.'), nl.

processInput([give, cigarettes, to, alexei]) :-
	currentTime(day),
	currentArea(Current),
	itemLocation(alexei, Current),
	inventory(cigarettes),
	retract(inventory(cigarettes)),
	retract(keysDontHave),
	assertz(inventory(keys)),
	print('That\'s good. Tell you what, if you really want to get out of here, there are some cutters hidden in the safe in the warehouse. Here are the keys for the warehouse. Don\'t ask how I got them. I don\'t have safe keys, good luck with that.'), nl.


%whack safe
processInput([whack, safe, with, hammer]) :-
	inventory(hammer),
	currentArea(warehouse),
	retractall(locked),
	print('You managed to open the safe with your hammer. Good job. Should probably get those cutters and GTFO.'), nl.

%cut fence
processInput([cut, fence]) :-
	inventory(cutters),
	currentTime(night),
	retractall(fenceNotCut),
	print('You cut the fence. Sneak outside and you\'re free.'), nl.

processInput([cut, fence]) :-
	inventory(cutters),
	currentTime(day),
	print('You should probably do this during the night so you don\'t get caught.'), nl.
%dig
processInput([dig, through, latrine]) :-
	currentArea(latrine),
	assertz(inventory(cutters)),
	print('After hours of digging through the smelliest stuff ever, you managed to find a pair of cutters. Funny how they got there, eh?'), nl.

processInput([dig, through, latrine]) :-
	inventory(cutters),
	print('nope'), nl.
%wait until day/night
processInput([wait, until, Time]) :-
	processInput([wait, Time]).

processInput([wait, until, _]) :-
	processInput([wait, _]).

processInput([wait, Time]) :-
	currentArea(building1),
	changeTime(Time),
	print('It is now '), print(Time), nl.

%wait until day/night bad input
processInput([wait, until, _]) :-
	print('You can only wait the other time of the day when you are in your building. Otherwise you\'ll get caught.'), nl.

% Add some help output here to explain how to play your game
processInput([help]) :- 
	print('Help:'), nl,
	print('go _, go to _ - use this to move between areas (during the day).'), nl,
	print('sneak _, sneak to _ - use this to move between areas (during the night).'), nl,
	print('wait _, wait until _ - use this to wait for day/night'), nl,
	print('pick up _ - pick up objects in current area.'), nl,
	print('drop _ - drop this object here'), nl,
	print('dig through _ - dig through something'), nl,
	print('give _ to _ - use this to give items to others'), nl,
	print('inventory – display inventory'), nl,
	print('whack _ with _ - use this to whack objects with other objects.'), nl,
	print('cut _ - use this to cut through some things.'), nl,
	print('help – show help.'), nl,
	print('exit – quits the game and prolog.'), nl.

processInput([exit]) :-
    halt(0).

% Catch-all for unknown inputs - make sure all of your processInput rules are above this one!
processInput([_]) :-
    print('I don\'t know how to do that...try something else'), nl, nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Basic Gameplay %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This rule starts everything off
play :-
	print('Welcome to Escape The Gulag by Fabio Gottlicher'), nl, nl,
	print('You are a Soviet politcal dissident. No surprise you ended up in gulag, in the middle of Siberia. Your past year has been with uranium mining, poor nutrition and countless frostbites. '), nl,
    retractall(gameOver),
    asserta(gameOver('no')),
	retractall(currentArea(_)),
    assertz(currentArea('building1')),
    retractall(currentTime(_)),
    assertz(currentTime(day)),
    retractall(current_area(_)),

	retractall(inventory(_)),

	retractall(itemLocation(cutters, _)),
	retractall(itemLocation(cigarettes, _)),
	retractall(itemLocation(cigarette, _)),
	retractall(itemLocation(alexei, _)),
	retractall(itemLocation(sickle, _)),
	retractall(itemLocation(hammer, _)),
	retractall(itemLocation(bread, _)),
	retractall(itemLocation(uranium, _)),
	retractall(itemLocation(safe, _)),
	retractall(itemLocation(mud, _)),

	asserta(itemLocation(cutters, warehouse)),
	asserta(itemLocation(cigarettes, guardshouse)),
	asserta(itemLocation(cigarette, guardshouse)),
	asserta(itemLocation(alexei, building2)),
	asserta(itemLocation(sickle, mine)),
	asserta(itemLocation(hammer, mine)),
	asserta(itemLocation(bread, building1)),
	asserta(itemLocation(uranium, mine)),
	asserta(itemLocation(safe, warehouse)),
	asserta(itemLocation(mud, courtyard)),
	asserta(locked),
	asserta(fenceNotCut),
	asserta(gameNotLost),
	asserta(gameNotWon),
	asserta(keysDontHave),
	printLocation,
	dispPrompt,
    getInput.
	
% Prints out the players current location description for DAY
printLocation :-
    currentArea(Current),
    currentTime(day),
    currentTime(Time),
    area(Current, AreaName, DescriptionDay, _), write('You are in: '), write(AreaName), write(', '), write(DescriptionDay), write(' The time of the day is: '), write(Time), nl,
    print('items here are: '), findall(Item, itemLocation(Item, Current), ListItems), print(ListItems), nl,nl. 
% Print out the players current location description for NIGHT
printLocation :-
    currentArea(Current),
    currentTime(night),
    currentTime(Time),
    area(Current, AreaName, _, DescriptionN), write('You are in: '), write(AreaName), write(', '), write(DescriptionN), write(' The time of the day is: '), write(Time), nl,
    print('items here are: '), findall(Item, itemLocation(Item, Current), ListItems), print(ListItems), nl,nl. 
 
% Changes the players current location, validity of change is checked in processInput
changeArea(NewArea) :-
    currentArea(Current),
    retract(currentArea(Current)),
    assertz(currentArea(NewArea)).

%Change time of the day
changeTime(NewTime) :-
	currentTime(OldTime),
	retract(currentTime(OldTime)),
	assertz(currentTime(NewTime)).
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Input Handling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
:- use_module(library(readln)).

% Displays the player prompt so they can enter actions
dispPrompt :- prompt(_, '> ').

% Get input from the user
getInput :- readSentence(Input), getInput(Input).
getInput([quit]).
getInput(Input) :-
    processInput(Input), 
	printLocation,
    readSentence(Input1), 
	getInput(Input1),
	findOutStatus.

%Game Over situation
findOutStatus :-
	gameNotWon, 	
	print('game over, starting again.'),
	play.

%Game win situation
findOutStatus :-
	gameNotLost,
	print('Congratulations, you win the game. Starting over in case you want to play again.'),
	play.
% Reads a sentence from the prompt (unless game has ended)

readSentence(Input) :-
	gameNotWon,
	gameNotLost,
    readln(Input1, _, ".!?", "_0123456789", lowercase),
    stripPunctuation(Input1, Input).

readSentence(_) :-
	gameNotWon, nl,nl,	
	print('GAME OVER, starting again.'), nl, nl, nl,
	play.
readSentence(_) :-
	gameNotLost,
	print('Congratulations, you win the game. Starting over in case you want to play again.'), nl, nl,
	play.

% Strips punctuation out of the user input
stripPunctuation([], []).
stripPunctuation([Word|Tail], [Word|Result]) :-
    \+(member(Word, ['.', ',', '?', '!'])),
    stripPunctuation(Tail, Result).
stripPunctuation([_|Tail], Result) :-
    stripPunctuation(Tail, Result).