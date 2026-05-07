% ============================================================
% Problema das Oito Rainhas - Programação Lógica
% ============================================================

% --- DOMÍNIO ---
coluna(1). coluna(2). coluna(3). coluna(4).
coluna(5). coluna(6). coluna(7). coluna(8).

% --- SOLUÇÃO PRINCIPAL ---
solucao(Rainhas) :-
    permutacao([1,2,3,4,5,6,7,8], Rainhas),
    seguras(Rainhas).

% --- GERAÇÃO DE PERMUTAÇÕES (backtracking) ---
permutacao([], []).
permutacao(Lista, [H|T]) :-
    selecionar(H, Lista, Resto),
    permutacao(Resto, T).

selecionar(X, [X|T], T).
selecionar(X, [H|T], [H|R]) :-
    selecionar(X, T, R).

% --- VERIFICAÇÃO DE SEGURANÇA (sem ataques em diagonal) ---
seguras([]).
seguras([R|Rs]) :-
    nao_ataca(R, Rs, 1),
    seguras(Rs).

nao_ataca(_, [], _).
nao_ataca(Col, [C|Cs], Dist) :-
    Col =\= C + Dist,      % diagonal principal
    Col =\= C - Dist,      % diagonal secundária
    Dist1 is Dist + 1,
    nao_ataca(Col, Cs, Dist1).

% --- VISUALIZAÇÃO DO TABULEIRO ---
mostrar_tabuleiro(Rainhas) :-
  writeln('Tabuleiro 8x8 (Q = Rainha):'),
  forall(between(1,8,Linha),
         (forall(between(1,8,Col),
                (nth1(Linha, Rainhas, Col) -> write(' ♛ ') ; write(' . '))),
          nl)).

% --- CONSULTAS ÚTEIS ---
total_solucoes(N) :-
    findall(S, solucao(S), Todas),
    length(Todas, N).

valida(Rainhas) :-
  length(Rainhas, 8),
  permutacao([1,2,3,4,5,6,7,8], Rainhas),
  seguras(Rainhas).

% Consulta principal (recomendada para demonstração)
demonstrar :-
    solucao(S),
    write('Solução encontrada: '), writeln(S), nl,
    mostrar_tabuleiro(S).

%	solucao(S).
%	demonstrar.
%	valida([1,5,8,6,3,7,2,4]).
%   total_solucoes(N).
