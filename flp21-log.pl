/*
* Author: Petr Medek (xmedek07)
* Date: 2.5.2021
*/

/** Source: input2.pl */
/** Autor: Martin Hyrs, ihyrs@fit.vutbr.cz */
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

%---------------------------------------

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

print_rubik_cube([
    [E1,E2,E3],
    [A1,A2,A3],
    [B1,B2,B3],
    [C1,C2,C3],
    [D1,D2,D3],
    [F1,F2,F3]
]) :-
    write(E1), write('\n'), write(E2), write('\n'), write(E3), write('\n'),
    write(A1), write(B1), write(C1), write(D1), write('\n'),
    write(A3), write(B2), write(C2), write(D2), write('\n'),
    write(A2), write(B3), write(C3), write(D3), write('\n'),
    write(F1), write('\n'), write(F2), write('\n'), write(F3), write('\n').


solved_cube([
    [E1,E1,E1],
    [A1,A1,A1],
    [B1,B1,B1],
    [C1,C1,C1],
    [D1,D1,D1],
    [F1,F1,F1]
]).

%---------------------------------------
% SEARCH
%---------------------------------------

prolog_search(Goal,Goal,[Goal]):-
    writeln("here").
prolog_search(Cube,Goal,[Cube|Path]) :-
%    write("New cube: "), writeln(NewCube),
    prolog_search(NewCube,Goal,Path),
%    write("New cube: "), writeln(NewCube),
    rotate(Cube, NewCube).

%---------------------------------------
depth_bound(_,[[Goal|Path]|_],Goal,[Goal|Path]).
depth_bound(Depth,[Path|Queue],Goal,FinalPath) :-
    extend1(Depth,Path,NewPaths),
%    write("Path: "), writeln(Path),
    append(NewPaths,Queue,NewQueue),
    depth_bound(Depth,NewQueue,Goal,FinalPath).

extend1(Depth,[Node|Path],NewPaths) :-
    length(Path,Len),
    Len < Depth-1, !,
    findall([NewNode,Node|Path],rotate(Node,NewNode),NewPaths).
extend1(_,_,[]).
%---------------------------------------

%%Rotate Top clock wise
%rotate(
%    [
%        [[E_11, E_12, E_13],[E_21, E_22, E_23], [E_31, E_32, E_33]],
%        [[A_11, A_12, A_13],[A_21, A_22, A_23], [A_31, A_32, A_33]],
%        [[B_11, B_12, B_13],[B_21, B_22, B_23], [B_31, B_32, B_33]],
%        [[C_11, C_12, C_13],[C_21, C_22, C_23], [C_31, C_32, C_33]],
%        [[D_11, D_12, D_13],[D_21, D_22, D_23], [D_31, D_32, D_33]],
%        [[F_11, F_12, F_13],[F_21, F_22, F_23], [F_31, F_32, F_33]]
%    ],
%    [
%        [[E_31, E_21, E_11],[E_32, E_22, E_12], [E_33, E_23, E_13]],
%        [[D_11, D_12, D_13],[A_21, A_22, A_23], [A_31, A_32, A_33]],
%        [[A_11, A_12, A_13],[B_21, B_22, B_23], [B_31, B_32, B_33]],
%        [[B_11, B_12, B_13],[C_21, C_22, C_23], [C_31, C_32, C_33]],
%        [[C_11, C_12, C_13],[D_21, D_22, D_23], [D_31, D_32, D_33]],
%        [[F_11, F_12, F_13],[F_21, F_22, F_23], [F_31, F_32, F_33]]
%    ]
%).
%
%%Rotate Top counter clock wise
%rotate(
%    [
%        [[E_11, E_12, E_13],[E_21, E_22, E_23], [E_31, E_32, E_33]],
%        [[A_11, A_12, A_13],[A_21, A_22, A_23], [A_31, A_32, A_33]],
%        [[B_11, B_12, B_13],[B_21, B_22, B_23], [B_31, B_32, B_33]],
%        [[C_11, C_12, C_13],[C_21, C_22, C_23], [C_31, C_32, C_33]],
%        [[D_11, D_12, D_13],[D_21, D_22, D_23], [D_31, D_32, D_33]],
%        [[F_11, F_12, F_13],[F_21, F_22, F_23], [F_31, F_32, F_33]]
%    ],
%    [
%        [[E_13, E_23, E_33],[E_12, E_22, E_32], [E_11, E_21, E_31]],
%        [[B_11, B_12, B_13],[A_21, A_22, A_23], [A_31, A_32, A_33]],
%        [[C_11, C_12, C_13],[B_21, B_22, B_23], [B_31, B_32, B_33]],
%        [[D_11, D_12, D_13],[C_21, C_22, C_23], [C_31, C_32, C_33]],
%        [[A_11, A_12, A_13],[D_21, D_22, D_23], [D_31, D_32, D_33]],
%        [[F_11, F_12, F_13],[F_21, F_22, F_23], [F_31, F_32, F_33]]
%    ]
%).

%Rotate Left downwards
rotate(
    [
        [[E_11, E_12, E_13],[E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13],[A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13],[B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13],[C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13],[D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13],[F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[C_13, E_12, E_13],[C_23, E_22, E_23], [C_33, E_32, E_33]],
        [[E_31, A_12, A_13],[E_21, A_22, A_23], [E_11, A_32, A_33]],
        [[B_11, B_12, B_13],[B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, F_31],[C_21, C_22, F_21], [C_31, C_32, F_11]],
        [[D_31, D_21, D_11],[D_32, D_22, D_12], [D_33, D_23, D_13]],
        [[A_11, F_12, F_13],[A_21, F_22, F_23], [A_31, F_32, F_33]]
    ]
).

%Rotate Left upwards
rotate(
    [
        [[E_11, E_12, E_13],[E_21, E_22, E_23], [E_31, E_32, E_33]],
        [[A_11, A_12, A_13],[A_21, A_22, A_23], [A_31, A_32, A_33]],
        [[B_11, B_12, B_13],[B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, C_13],[C_21, C_22, C_23], [C_31, C_32, C_33]],
        [[D_11, D_12, D_13],[D_21, D_22, D_23], [D_31, D_32, D_33]],
        [[F_11, F_12, F_13],[F_21, F_22, F_23], [F_31, F_32, F_33]]
    ],
    [
        [[A_31, E_12, E_13],[A_21, E_22, E_23], [A_11, E_32, E_33]],
        [[F_11, A_12, A_13],[F_21, A_22, A_23], [F_31, A_32, A_33]],
        [[B_11, B_12, B_13],[B_21, B_22, B_23], [B_31, B_32, B_33]],
        [[C_11, C_12, E_11],[C_21, C_22, E_21], [C_31, C_32, E_31]],
        [[D_13, D_23, D_33],[D_12, D_22, D_32], [D_11, D_21, D_31]],
        [[C_33, F_12, F_13],[C_23, F_22, F_23], [C_13, F_32, F_33]]
    ]
).


main :-
    prompt(_, ''),
    read_lines(LL),
    split_lines(LL,S),
    load_rubik_cube(S,Cube),
%    print_rubik_cube(Cube),
    depth_bound(5, [[Cube]],
        [
            [[E_1, E_1, E_1],[E_1, E_1, E_1], [E_1, E_1, E_1]],
            [[A_1, A_1, A_1],[A_1, A_1, A_1], [A_1, A_1, A_1]],
            [[B_1, B_1, B_1],[B_1, B_1, B_1], [B_1, B_1, B_1]],
            [[C_1, C_1, C_1],[C_1, C_1, C_1], [C_1, C_1, C_1]],
            [[D_1, D_1, D_1],[D_1, D_1, D_1], [D_1, D_1, D_1]],
            [[F_1, F_1, F_1],[F_1, F_1, F_1], [F_1, F_1, F_1]]
        ], Path),
%    prolog_search(Cube,
%        [
%            [[E_1, E_1, E_1],[E_1, E_1, E_1], [E_1, E_1, E_1]],
%            [[A_1, A_1, A_1],[A_1, A_1, A_1], [A_1, A_1, A_1]],
%            [[B_1, B_1, B_1],[B_1, B_1, B_1], [B_1, B_1, B_1]],
%            [[C_1, C_1, C_1],[C_1, C_1, C_1], [C_1, C_1, C_1]],
%            [[D_1, D_1, D_1],[D_1, D_1, D_1], [D_1, D_1, D_1]],
%            [[F_1, F_1, F_1],[F_1, F_1, F_1], [F_1, F_1, F_1]]
%        ], Path),
    writeln(Path),
    halt.
