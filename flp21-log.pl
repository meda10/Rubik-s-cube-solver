/*
* Author: Petr Medek (xmedek07)
* Date: 2.5.2021
*/

%---------------------------------------
% INPUT
% Source: input2.pl
% Autor: Martin Hyrs, ihyrs@fit.vutbr.cz
%---------------------------------------
/** cte radky ze standardniho vstupu, konci na LF nebo EOF */
read_line(L,C) :-
	get_char(C),
	(isEOFEOL(C), L = [], !;
		read_line(LL,_),% atom_codes(C,[Cd]),
		[C|LL] = L).


/** testuje znak na EOF nebo LF */
isEOFEOL(C) :-
	C == end_of_file;
	(char_code(C,Code), Code==10).


read_lines(Ls) :-
	read_line(L,C),
	( C == end_of_file, Ls = [] ;
	  read_lines(LLs), Ls = [L|LLs]
	).


/** rozdeli radek na podseznamy */
split_line([],[[]]) :- !.
split_line([' '|T], [[]|S1]) :- !, split_line(T,S1).
split_line([32|T], [[]|S1]) :- !, split_line(T,S1).    % aby to fungovalo i s retezcem na miste seznamu
split_line([H|T], [[H|G]|S1]) :- split_line(T,[G|S1]). % G je prvni seznam ze seznamu seznamu G|S1


/** vstupem je seznam radku (kazdy radek je seznam znaku) */
split_lines([],[]).
split_lines([L|Ls],[H|T]) :- split_lines(Ls,T), split_line(L,H).

/** Loads rubik's cube to internal representation */
load_rubik_cube([
	[E3],
	[E2],
	[E1],
	[A1, B1, C1, D1],
	[A2, B2, C2, D2],
	[A3, B3, C3, D3],
	[F1],
	[F2],
	[F3]
], [
	[E1,E2,E3],
	[A1,A2,A3],
	[B1,B2,B3],
	[C1,C2,C3],
	[D1,D2,D3],
	[F1,F2,F3]
]
).

%---------------------------------------
% OUTPUT
%---------------------------------------

/** Reverses list */
reverse_list([],[]).
reverse_list([H|T],R) :- reverse_list(T,Rev_T), append(Rev_T,[H],R).

/** Prints new line between cubes */
print_new_line([]).
print_new_line(_) :- writeln("").

/** Prnts rubik's cubes steps to solved cube*/
print_path([]).
print_path([Cube|Path]) :-
    print_rubik_cube(Cube),
    print_new_line(Path),
    print_path(Path).

/** Prints one rubik's cube*/
print_rubik_cube([
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
]) :-
    writef("%w%w%w\n%w%w%w\n%w%w%w\n", [E_31, E_32, E_33, E_21, E_22, E_23, E_11, E_12, E_13]),
    writef("%w%w%w %w%w%w %w%w%w %w%w%w\n", [A_11, A_12, A_13, B_11, B_12, B_13, C_11, C_12, C_13, D_11, D_12, D_13]),
    writef("%w%w%w %w%w%w %w%w%w %w%w%w\n", [A_21, A_22, A_23, B_21, B_22, B_23, C_21, C_22, C_23, D_21, D_22, D_23]),
    writef("%w%w%w %w%w%w %w%w%w %w%w%w\n", [A_31, A_32, A_33, B_31, B_32, B_33, C_31, C_32, C_33, D_31, D_32, D_33]),
    writef("%w%w%w\n%w%w%w\n%w%w%w\n", [F_11, F_12, F_13, F_21, F_22, F_23, F_31, F_32, F_33]).

%---------------------------------------
% SEARCH
%---------------------------------------

%search(Solved,Solved,[Solved]).
%search(Cube,Solved,[Cube|Path]) :-
%    rotate(Cube, NewCube).
%    prolog_search(NewCube,Solved,Path),

% Depth first search
% https://github.com/christian-vigh/prolog-experiments
depth_first_search(_,[[Solved|Path]|_],Solved,[Solved|Path]).
depth_first_search(Depth,[Path|Queue],Solved,FinalPath) :-
    extend(Depth,Path,NewPaths),
    append(NewPaths,Queue,NewQueue),
    depth_first_search(Depth,NewQueue,Solved,FinalPath).

extend(Depth,[Node|Path],NewPaths) :-
    length(Path,Len),
    Len < Depth - 1, !,
    findall([NewNode,Node|Path], rotate(Node,NewNode),NewPaths).
extend(_,_,[]).


%---------------------------------------
% CUBE ROTATIONS
%---------------------------------------

%Rotate Top clock wise
rotate(
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[E_31, E_21, E_11], [E_32, E_22, E_12], [E_33, E_23, E_13]],
        [[D_11, D_12, D_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[A_11, A_12, A_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[B_11, B_12, B_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[C_11, C_12, C_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ]
).

%Rotate Top counter clock wise
rotate(
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[E_13, E_23, E_33], [E_12, E_22, E_32], [E_11, E_21, E_31]],
        [[B_11, B_12, B_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[C_11, C_12, C_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[D_11, D_12, D_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[A_11, A_12, A_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ]
).

%Rotate Bottom clock wise
rotate(
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [D_31, D_32, D_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [A_31, A_32, A_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [B_31, B_32, B_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [C_31, C_32, C_33]],
        [[F_31, F_21, F_11], [F_32, F_22, F_12], [F_33, F_23, F_13]]
    ]
).

%Rotate Bottom counter clock wise
rotate(
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [B_31, B_32, B_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [C_31, C_32, C_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [D_31, D_32, D_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [A_31, A_32, A_33]],
        [[F_13, F_23, F_33], [F_12, F_22, F_32], [F_11, F_21, F_31]]
    ]
).

%Rotate Left downwards
rotate(
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[C_13, E_12, E_13], [C_23, E_22, E_23], [C_33, E_32, E_33]],
        [[E_31, A_12, A_13], [E_21, A_22, A_23], [E_11, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, F_31], [C_21, C_22, F_21], [C_31, C_32, F_11]],
        [[D_31, D_21, D_11], [D_32, D_22, D_12], [D_33, D_23, D_13]],
        [[A_11, F_12, F_13], [A_21, F_22, F_23], [A_31, F_32, F_33]]
    ]
).

%Rotate Left upwards
rotate(
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[A_31, E_12, E_13], [A_21, E_22, E_23], [A_11, E_32, E_33]],
        [[F_11, A_12, A_13], [F_21, A_22, A_23], [F_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, E_11], [C_21, C_22, E_21], [C_31, C_32, E_31]],
        [[D_13, D_23, D_33], [D_12, D_22, D_32], [D_11, D_21, D_31]],
        [[C_33, F_12, F_13], [C_23, F_22, F_23], [C_13, F_32, F_33]]
    ]
).

%Rotate Right downwards
rotate(
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[E_11, E_12, C_11], [E_21, E_22, C_21], [E_31, E_32, C_31]],
        [[A_11, A_12, E_33], [A_21, A_22, E_23], [A_31, A_32, E_13]],
        [[B_13, B_23, B_33], [B_12, B_22, B_32], [B_11, B_21, B_31]],
        [[F_33, C_12, C_13], [F_23, C_22, C_23], [F_13, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, A_13], [F_21, F_22, A_23], [F_31, F_32, A_33]]
    ]
).

%Rotate Right upwards
rotate(
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[E_11, E_12, A_33], [E_21, E_22, A_23], [E_31, E_32, A_13]],
        [[A_11, A_12, F_13], [A_21, A_22, F_23], [A_31, A_32, F_33]],
        [[B_31, B_21, B_11], [B_32, B_22, B_12], [B_33, B_23, B_13]],
        [[E_13, C_12, C_13], [E_23, C_22, C_23], [E_33, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, C_31], [F_21, F_22, C_21], [F_31, F_32, C_11]]
    ]
).

%Rotate Front right
rotate(
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[D_33, D_23, D_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_31, A_21, A_11], [A_32, A_22, A_12], [A_33, A_23, A_13]],
        [[E_11, B_12, B_13], [E_12, B_22, B_23], [E_13, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, F_11], [D_21, D_22, F_12], [D_31, D_32, F_13]],
        [[B_31, B_21, B_11], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ]
).

%Rotate Front left
rotate(
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[D_33, D_23, D_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_31, A_21, A_11], [A_32, A_22, A_12], [A_33, A_23, A_13]],
        [[E_11, B_12, B_13], [E_12, B_22, B_23], [E_13, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, F_11], [D_21, D_22, F_12], [D_31, D_32, F_13]],
        [[B_31, B_21, B_11], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ]
).

%Rotate Back right
rotate(
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [B_13, B_23, B_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, F_33], [B_21, B_22, F_32], [B_31, B_32, F_31]],
        [[C_31, C_21, C_11], [C_32, C_22, C_12], [C_33, C_23, C_13]],
        [[E_33, D_12, D_13], [E_32, D_22, D_23], [E_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [D_11, D_21, D_31]]
    ]
).

%Rotate Back left
rotate(
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13], [B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13], [C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13], [D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[E_11, E_12, E_13], [E_21, E_22, E_23], [D_31, D_21, D_11]],
        [[A_11, A_12, A_13], [A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, E_31], [B_21, B_22, E_32], [B_31, B_32, E_33]],
        [[C_13, C_23, C_33], [C_12, C_22, C_32], [C_11, C_21, C_31]],
        [[F_31, D_12, D_13], [F_32, D_22, D_23], [F_33, D_32, D_33]],
        [[F_11, F_12, F_13], [F_21, F_22, F_23], [B_33, B_23, B_13]]
    ]
).

% Main -> read input -> load cube -> DFS -> print output
main :-
    prompt(_, ''),
    read_lines(LL),
    split_lines(LL,S),
    load_rubik_cube(S,Cube),
    depth_first_search(7, [[Cube]],
        [
            [[E_1, E_1, E_1], [E_1, E_1, E_1], [E_1, E_1, E_1]],
            [[A_1, A_1, A_1], [A_1, A_1, A_1], [A_1, A_1, A_1]],
            [[B_1, B_1, B_1], [B_1, B_1, B_1], [B_1, B_1, B_1]],
            [[C_1, C_1, C_1], [C_1, C_1, C_1], [C_1, C_1, C_1]],
            [[D_1, D_1, D_1], [D_1, D_1, D_1], [D_1, D_1, D_1]],
            [[F_1, F_1, F_1], [F_1, F_1, F_1], [F_1, F_1, F_1]]
        ], Path), % Maximum depth 7
    reverse_list(Path, Reversed),
    print_path(Reversed),
    halt.