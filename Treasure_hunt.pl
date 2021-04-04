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
    write("  help - shoq instrunctions again."), nl,
	write("  quit - exit the game."),nl,
	write("  goTo(X) - where X is a place to go to."), nl,
%	write("  shoot(X). - where X is your shooting target."), nl,
%	write("  take(X). - where X is a thing to take."), nl,
%	write("  chase(X). - chasing ducks sends them to the pen."), nl,
	nl.

:- dynamic(loc/2).
:- dynamic(userName/1).

% ------------ перевірка поточного стану -------

loc(gold,cave).
loc(ducks,cave).
loc(you,cave).
loc(farmer,yard).
loc(fox,forest).

state :-
	write("My location: "),
	loc(you, L), 
    write(L), nl,
	state_can_go(L),
	state_see(L),
	state_have(you).

% ------------ перевірка куди я можу goTo(x) в залежності від поточного мого місця -------

state_can_go(L) :-
	write("Can go to: "),
	connection(L, CAN_GO_TO),
	write(" "), 
    write(CAN_GO_TO), nl,
	fail.
state_can_go(_).

beside(cave, yard).
beside(yard, house).
beside(house, pond).
beside(yard, pond).

connection(X,Y) :-
        beside(X,Y).
connection(X,Y) :-
        beside(Y,X).

% ------------ що ще є в поточному місці (що я можу бачити) -------

state_see(L) :-
	write("I see: "),
	loc(THING, L),
	THING \= you,
	write(" "), write(THING), nl,
	fail.
state_see(_).

% ------------ що має герой -------

state_have(X) :-
	write("Have: "),
	loc(THING, X),
	write(" "), write(THING), nl,
	fail.
state_have(_).

% ------------ сontrol commands   -------

do(state) :- !, state.
do(goTo(X)) :- !, goTo(X).
do(help) :- !, instructions.
do(quit) :- !.
do(X) :- write("unknown command"), write(X), nl, control_commands.

% ------------ хід гри   -------

go :- done.
go :-
	write(">> "),
	read(X),
	X \= quit,
	do(X),
%	demons,
	!, go.
go :- write("You have quit"), nl.

% ------------ реалізація goTo(X)   -------

goTo(X) :-
	loc(you, L),
	connection(L, X),
	move(you, X),
	write("You are in the "), write(X), nl.

goTo(_) :-
	write("You can't get there from here."), nl.

% http://www.cse.unsw.edu.au/

% assert - це мета-предикат, який додає свій єдиний аргумент, 
% який може бути фактом або правилом, до бази даних Prolog.

% dynamic - вказівник, що цей предикат динамічний і може змінюватись 
% під час виконання програми 	
