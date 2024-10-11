/* Write Prolog programs to complete the following questions:
1. A popular children's riddle is “Brothers and sisters have 
I none,  but that man's father is my father's son.” Use the 
rules of the family domain (Section 8.3.2 on page 301 in the 
Textbook) to find who that  man is using a Prolog program.
*/

/*
The first step in solving this riddle is the vocabulary definition.

So we can define the predicate

Relation(x,y,z), where x is a person in a relation y with a person z.

There are two people of importance for this riddle. That is the person asking the riddle, "the riddler", whom we are going to define as R, and "that man", whom we are going to define as  TM. Except for them, their fathers are also included in the riddle. We are going to define "the riddler's father" as a Skolem constant RF, and "that man's father" as TMF.

To solve the riddle assuming that "that man" is "the riddler's" son, we need to resolve the query

0.Relation(TM,x,y)

with the substitution

{x/Son,y/R}

Next, we are going to take out and rephrase the definitions from the kinship domain, which we will need, using the newly defined Relation predicate.

6.Relation(x,Father,y)⟺Male(x)∧Relation(x,Parent,y) 
7.Relation(x,Son,y)⟺Male(x)∧Relation(y,Parent,x) 
8.Relation(x,Sibling,y)⟺∃zRelation(z,Parent,x)∧Relation(z,Parent,y)∧¬(x=y) 
9.Relation(x,Father,y)∧Relation(z,Father,y)⟹x=z

Now, we need to remove 
⟺ symbols and quantifiers from sentences 1. to  9. as well as negate the query 0.
6.1.Relation(x,Father,y)⟹Male(x) 
6.2.Relation(x,Father,y)⟹Relation(x,Parent,y) 
6.3.Male(x)∧Relation(x,Parent,y)⟹Relation(x,Father,y)
7.1.Relation(x,Son,y)⟹Male(x) 
7.2.Relation(x,Son,y)⟹Relation(y,Parent,x) 
7.3.Male(x)∧Relation(y,Parent,x)⟹Relation(x,Son,y)
8.1.Relation(x,Sibling,y)⟹x
8.2.Relation(x,Sibling,y)⟹Relation(P(x,y),Parent,x) 
8.3.Relation(x,Sibling,y)⟹Relation(P(x,y),Parent,y) 
8.4.x!=y∧Relation(P(x,y),Parent,x)∧Relation(P(x,y),Parent,y)⟹Relation(x,Sibling,y)
0.1.Relation(TM,x,y)⟹false

Finally, all is set to begin with the inferences. We are going to use resolutions.

3. and 6.2. resolve 10. Relation(RF,Parent,R)
5. and 7.2. resolve 11. Relation(RF,Father,TMF)
10. and 8.4. resolve 12. Relation(RF,Father,x)∧R≠x ⟹ Relation(R,Sibling,x)
1. and 12. resolve 13.Relation(RF,Father,x)∧R≠x ⟹ false
11. and 13. resolve 14. R≠TMF ⟹ false
14. and N resolve 15. R=TMF
4. and 15. resolve 16. Relation(R,Father,TM)
6.2. and 16. resolve 17. Relation(R,Parent,TM)
2. and 7.3 and 17. resolve 18. Relation(TM,Son,R)
0.1. and 18. resolve 19. {x/Son,y/R} is false

*/

% relation(X, Y, Z) means X is in relation Y with Z.
% For example, relation(john, father, mary) means John is Mary’s father.

% Defining some constants for the riddle
riddler(riddler).
father_of(RF, R) :- R = riddler . % Riddler's father is RF.
father_of(TM, RF). % TM's father is RF.

% Define male and parent relationships
male(r). % Riddler is male.
male(TM). % We assume that TM is male.

relation(X, father, Y) :- male(X), relation(X, parent, Y).
relation(X, son, Y) :- male(X), relation(Y, parent, X).
relation(X, sibling, Y) :- 
    relation(Z, parent, X),
    relation(Z, parent, Y),
    X \= Y.

% Define the main query to find "that man"
find_that_man(TM) :-
    father_of(TM, TMF),       % TM's father is RF
    father_of(RF, R),         % Riddler's father is RF
    R = TMF,                  % Riddler's father's son is TM
    R = TM,                   % Therefore, TM is the Riddler's son
    !.

% Define the initial call
solve_riddle :-
    find_that_man(TM),
    format('That man is: ~w', [TM]).

% Query
% ?- solve_riddle.