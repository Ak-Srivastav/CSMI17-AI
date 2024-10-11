/* Write Prolog programs to complete the following questions:
2. A man, a woman and two children had to go to the opposite 
bank of a river using a boat. The man and the woman weighed 
80 kg each and the children weighed 30 kg each. Given that the 
boat can carry upto 100 kg and that everyone can drive a boat, 
write a Prolog program to find how all four can cross the river
with the boat. You may refer to 
https://gist.github.com/blrB/b6620479bd1b46f46b102bf91a0eefb7 
for solution to a similar problem.
*/


/* Define the initial state */
initial_state(state(e, e, e, e)).

/* Define the goal state */
goal_state(state(w, w, w, w)).

/* Define the boat capacity */
boat_capacity(100).

/* Define the weights of the man, woman, and children */
weight(man, 80).
weight(woman, 80).
weight(child, 30).

/* Define the safe state */
safe(state(X, Y, Z, W)) :-
    TotalWeight is Y + Z + W,
    boat_capacity(Max),
    TotalWeight =< Max.

/* Define the move function */
move(state(X, X, G, C), state(Y, Y, G, C)) :-
    opposite(X, Y),
    not(unsafe(state(Y, Y, G, C))),
    write('Try man and woman cross the river '), nl.

move(state(X, W, X, C), state(Y, W, Y, C)) :-
    opposite(X, Y),
    not(unsafe(state(Y, W, Y, C))),
    write('Try one child cross the river '), nl.

move(state(X, W, G, X), state(Y, W, G, Y)) :-
    opposite(X, Y),
    not(unsafe(state(Y, W, G, Y))),
    write('Try the other child cross the river '), nl.

move(state(X, W, G, C), state(Y, W, G, C)) :-
    opposite(X, Y),
    not(unsafe(state(Y, W, G, C))),
    write('Try one person cross the river '), nl.

/* Define the opposite function */
opposite(e, w).
opposite(w, e).

/* Define the unsafe state */
unsafe(state(X, X, _, _)) :-
    X = e,
    write('Unsafe state: man and woman on the same side '), nl, fail.

unsafe(state(_, _, X, X)) :-
    X = w,
    write('Unsafe state: children on the same side '), nl, fail.

/* Define the path function */
path(Goal, Goal, List) :-
    write('Solution Path is: '), nl,
    reverse_writenllist(List).

path(State, Goal, List) :-
    move(State, NextState),
    not(member(NextState, List)),
    path(NextState, Goal, [NextState|List]),
    !.

/* Define the reverse write list function */
reverse_writenllist(List) :-
    reverse(List, ReversedList),
    writelnllist(ReversedList).

writelnllist([]).
writelnllist([H|T]) :-
    write(H), nl,
    writelnllist(T).

/* Run the program */
solve :-  
    initial_state(InitialState),
    goal_state(GoalState),
    path(InitialState, GoalState, [InitialState]).

% Query 
% ?- solve.