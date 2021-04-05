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
    write("Supper Win - we killed the dragon and the dog was not eaten "), nl,nl,
    control_commands,
    nl.
    
    
control_commands :-
    write("Control commands:"),nl,nl,
    write("state - the state of the game."), nl,
    write("help - show instrunctions again."), nl,
    write("quit - exit the game."),nl,
    write("goTo(X) - move to a place X."), nl,
    write("fire(X). - where X is your shooting target."), nl,
    write("take(X). - where X is a thing to take."), nl,
    write("chase(X). - chasing dog sends them to the pen."), nl,
    nl.

:- dynamic(loc/2).
:- dynamic(userName/1).

% ------------ перевірка поточного стану -------

loc(gold,cave).
loc(dog,cave).
loc(you,cave).
loc(friend,yard).
loc(dragon,forest).

% ------------ call the predicate   -------

do(goTo(X)) :- !, goTo(X).
do(chase(X)) :- !, chase(X).
do(take(X)) :- !, take(X).
do(fire(X)) :- !, fire(X).
do(state) :- !, state.
do(help) :- !, instructions.
do(quit) :- !.
do(X) :- write("unknown command"), write(X), nl, control_commands.
do(listing) :- !, listing.
do(report) :- !, report.

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
    nl,
    write("Have: "),
    loc(THING, X),
    write(" "), write(THING), nl,
    fail.
state_have(_).

% ------------ хід гри   -------

go :- done.
go :-
    write(">> "),
    read(X),
    X \= quit,
    do(X),
    demons,
    !, go.
go :- write(" You have quit "), nl.

% ------------ реалізація goTo(X)   -------
% ------------ перезапис поточного розташування спричинений goTo()  -------

% retract - це вбудований мета-предикат, який використовується для видалення
% фактів або правил з бази даних Prolog під час виконання програми.

move(Item, Place) :-
    retract( loc(Item, _) ),
    assert( loc(Item,Place) ).

goTo(X) :-
    loc(you, L),
    connection(L, X),
    move(you, X),
    write("You are in the "), write(X), nl.

goTo(_) :-
    write("It is impossible to get there from"),
    write(" "),
    loc(you,L),
    write(L), nl.

% ------------ Win - умова коли золото принесли в будинок  -------

done :-
    loc(you, house),
    loc(gold, you),
    write("Woow great, you winn!!! You get the gold."), nl.

% ------------ Game Over - собака відправилась в рай -------

done :-
    loc(dog, paradise),
    write("GAME OVER"), nl.

% ------------ Supper Win - собака відправилась в рай -------

done :-
    loc(dragon, paradise),
    write("Woow bro, you killed the dragon. You don't need gold anymore!!!"),
    nl,nl.

% ------------ dog збігає в yard з печери на початку гри -------

dog :-
    loc(dog, cave),
    loc(you, cave),
    move(dog, yard),
    write("The dog have run into the yard."), nl.

% ------------ dog збігає в pond з yard, коли ми туди крокуємо -------

dog :-
    loc(dog, yard),
    loc(you, yard),
    move(dog, pond),
    write("The dog have run into the pond."), nl.
dog.

% ------------ dog збігає в pond з yard, коли ми туди крокуємо -------

dragon :-
    loc(dog, pond),
    loc(you, house),
    loc(friend,yard),
    write("The dragon has taken a duck."), nl.
dragon.

friend :-
    loc(you, yard),
    loc(friend, yard),
    loc(dog, X),
        loc(dragon, Y),
    X \= paradise,
        Y \= paradise,
    write("The friend says hello."), nl.
friend.

% ------------ забрати собаку в печеру -------

chase(dog) :-
    loc(dog, L),
    loc(you, L),
    move(dog, cave),
    write("The dog are back in their pen."), nl.

chase(_):-
    write("No dog here."), nl.


take(X) :-
    loc(you, L),
    loc(X, L),
    move(X, you),
    write("You now have the "), write(X), nl.
take(X) :-
    write("There is no "), write(X), write(" here."), nl.

report :-
        findall(X:Y, loc(X,Y), L),
        write(L), nl.

attempt :-
    random(X),
    X >= 0.5.

kill(X) :-
    move(X, paradise).

miss :-
    write("Oh-oh! Looks like you missed it. Better luck next time!"),
    nl.

fire(friend) :-
    loc(you, yard),
    attempt,
    kill(friend),
    write("Are you crazy!? You've shot the friend, you bastard! Now he is dead!"),
    nl.

fire(friend) :-
    loc(you, yard),
    miss.

fire(friend) :-
    write("Your friend is not here :("), nl.

fire(dog) :-
    loc(you, L),
    loc(dog, L),
    attempt,
    kill(dog),
    write("What are you doing!? You have killed your own dog!"), nl.

fire(dog) :-
    loc(you, L),
    loc(dog, L),
    miss.

fire(dog) :-
    write("The dog is not here."), nl.

fire(dragon) :-
    loc(you, yard),
    attempt,
    kill(dragon),
    write("Wow!!! Nice aim!!! You've just decimated that evil dragon!"),
    nl.

fire(dragon) :-
    loc(you, yard),
    miss.

fire(dragon) :-
    write("The dragon is not here."), nl.

fire(_) :-
    write("You can't shoot that."), nl.

demons :-
    dog,
    dragon,
    friend.

% http://www.cse.unsw.edu.au/

% assert - це мета-предикат, який додає свій єдиний аргумент,
% який може бути фактом або правилом, до бази даних Prolog.

% dynamic - вказівник, що цей предикат динамічний і може змінюватись
% під час виконання програми



