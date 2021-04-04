% Serhii Vakulenko - "Logic programming : Prolog" 
% KN-3 - 2021
% Game: "Treasure hunt"

game :-
	write("----------- Treasure hunt -----------"),nl,
	write("Enter you name:"), nl,
	read(X),
	assert(userName(X)),
    write("Hi, "),
    userName(X),nl,
    write("Welcome to the world of gold and fear!!!"),nl,
	instructions,    
	go.

instructions :-
    
	nl,
    write("--- Game instructions ---"), nl,
    nl,
	write("Mission:"), nl,
	write("Find the treasure in the cave and"), nl,
	write("and return home with it without losing friends."), nl,
	nl,
    write("Terms of win:"), nl,
	write("Win - the dog was not eaten by the dragon "),
	write("and we returned the treasure home"), nl,
    write("Supper Win - we killed the dragon, the dog was not eaten "),
	write("and we returned the treasure home"), nl,nl,
    control_commands,
    nl.
    
    
control_commands :-    
    write("Control commands:"),nl,
    write("  state - the state of the game."), nl,
	write("  goto(X). - where X is a place to go to."), nl,
	nl.

:- dynamic(loc/2).
:- dynamic(userName/1).

% ------------ перевірка поточного стану -------

loc(egg,cave).
loc(ducks,cave).
loc(you,cave).
loc(farmer,yard).
loc(fox,forest).

state :-
	write("My location: "),
	loc(you, L), 
    write(L), nl,
	state_can_go(L),
	look_here(L),
	look_have(you).

% ------------ перевірка куди я можу goto(x) в залежності від поточного мого місця -------

state_can_go(L) :-
	write("Can go to: "),
	connect(L, CAN_GO_TO),
	write(" "), 
    write(CAN_GO_TO), nl,
	fail.
state_can_go(_).

beside(cave, yard).
beside(yard, house).
beside(house, pond).
beside(yard, pond).

connect(X,Y) :-
        beside(X,Y).
connect(X,Y) :-
        beside(Y,X).
