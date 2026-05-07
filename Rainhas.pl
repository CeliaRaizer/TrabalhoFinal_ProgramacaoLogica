% ============================================================
% Problema das Oito Rainhas - Completo (Resolver + Jogar)
% ============================================================

% ------------------------------------------------------------
% DOMÍNIO
% ------------------------------------------------------------
coluna(1). coluna(2). coluna(3). coluna(4).
coluna(5). coluna(6). coluna(7). coluna(8).

% ------------------------------------------------------------
% SOLUÇÃO PRINCIPAL
% ------------------------------------------------------------
solucao(Rainhas) :-
    permutacao([1,2,3,4,5,6,7,8], Rainhas),
    seguras(Rainhas).

% ------------------------------------------------------------
% GERAÇÃO DE PERMUTAÇÕES (backtracking)
% ------------------------------------------------------------
permutacao([], []).

permutacao(Lista, [H|T]) :-
    selecionar(H, Lista, Resto),
    permutacao(Resto, T).

selecionar(X, [X|T], T).

selecionar(X, [H|T], [H|R]) :-
    selecionar(X, T, R).

% ------------------------------------------------------------
% VERIFICAÇÃO DE SEGURANÇA
% ------------------------------------------------------------
seguras([]).

seguras([R|Rs]) :-
    nao_ataca(R, Rs, 1),
    seguras(Rs).

nao_ataca(_, [], _).

nao_ataca(Col, [C|Cs], Dist) :-
    abs(Col - C) =\= Dist,
    Dist1 is Dist + 1,
    nao_ataca(Col, Cs, Dist1).

% ------------------------------------------------------------
% VISUALIZAÇÃO COMPLETA DO TABULEIRO
% ------------------------------------------------------------
mostrar_tabuleiro(Rainhas) :-
    writeln('Tabuleiro 8x8 (Q = Rainha):'),
    forall(between(1,8,Linha),
        (
            forall(between(1,8,Coluna),
                (
                    nth1(Linha, Rainhas, ColRainha),
                    (
                        Coluna =:= ColRainha ->
                        write(' ♛ ')
                    ;
                        write(' . ')
                    )
                )
            ),
            nl
        )
    ).

% ------------------------------------------------------------
% VISUALIZAÇÃO PARCIAL DO TABULEIRO
% ------------------------------------------------------------
mostrar_tabuleiro_parcial(Rainhas, TotalLinhas) :-
    writeln('Tabuleiro atual:'),

    % Linhas preenchidas
    forall(between(1, TotalLinhas, Linha),
        (
            forall(between(1,8,Coluna),
                (
                    nth1(Linha, Rainhas, ColRainha),
                    (
                        Coluna =:= ColRainha ->
                        write(' ♛ ')
                    ;
                        write(' . ')
                    )
                )
            ),
            nl
        )
    ),

    % Linhas vazias
    LinhasRestantes is 8 - TotalLinhas,

    forall(between(1, LinhasRestantes, _),
        (
            forall(between(1,8,_),
                write(' _ ')
            ),
            nl
        )
    ).

% ------------------------------------------------------------
% CONSULTAS ÚTEIS
% ------------------------------------------------------------
total_solucoes(N) :-
    findall(S, solucao(S), Todas),
    length(Todas, N).
	% ?- total_solucoes(N).
valida(Rainhas) :-
    length(Rainhas, 8),
    permutacao([1,2,3,4,5,6,7,8], Rainhas),
    seguras(Rainhas).

% ------------------------------------------------------------
% DEMONSTRAÇÃO AUTOMÁTICA
% ------------------------------------------------------------
demonstrar :-
    solucao(S),
    write('Solução encontrada: '),
    writeln(S),
    nl,
    mostrar_tabuleiro(S).
% ?- demonstrar.

% ============================================================
% MODO INTERATIVO (JOGAR)
% ============================================================

% ------------------------------------------------------------
% VERIFICA SE A JOGADA É VÁLIDA
% ------------------------------------------------------------
jogada_valida(NovaCol, ColsAnteriores) :-

    integer(NovaCol),
    NovaCol >= 1, 
    NovaCol =< 8,

    \+ member(NovaCol, ColsAnteriores), %verifica se o elemento está na lista.

    append(ColsAnteriores, [NovaCol], Todas),
    seguras(Todas).

% ------------------------------------------------------------
% LOOP PRINCIPAL DO JOGO
% ------------------------------------------------------------
jogar :-
    writeln('====================================='),
    writeln('      JOGO DAS OITO RAINHAS'),
    writeln('====================================='),
    writeln('Posicione uma rainha por linha.'),
    writeln('Digite a coluna de 1 a 8.'),
    nl,
    jogar_loop([], 1).

% ------------------------------------------------------------
% CONDIÇÃO DE VITÓRIA
% ------------------------------------------------------------
jogar_loop(Rainhas, 9) :-
    !,
    nl,
    writeln('╔══════════════════════════════╗'),
    writeln('║  Parabéns! Você venceu! ♛   ║'),
    writeln('╚══════════════════════════════╝'),
    nl,
    mostrar_tabuleiro(Rainhas).

% ------------------------------------------------------------
% CONTINUA O JOGO
% ------------------------------------------------------------
jogar_loop(ColsAnteriores, Linha) :-
    nl,

    length(ColsAnteriores, N),
    mostrar_tabuleiro_parcial(ColsAnteriores, N),

    nl,
    format('Linha ~w -> Digite a coluna (1-8): ', [Linha]),
    read(Col),

    processar_jogada(Col, ColsAnteriores, Linha). %aceita ou rejeita

% ------------------------------------------------------------
% PROCESSA A JOGADA
% ------------------------------------------------------------
processar_jogada(Col, ColsAnteriores, Linha) :-

    (
        jogada_valida(Col, ColsAnteriores)
    ->

        append(ColsAnteriores, [Col], NovasRainhas), %Adiciona a nova rainha.

        ProximaLinha is Linha + 1, %avança

        jogar_loop(NovasRainhas, ProximaLinha) %continua

    ;

        writeln('❌ Jogada inválida!'),
        writeln('A rainha seria atacada ou a coluna já foi usada.'),
        writeln('Tente novamente.'),

        jogar_loop(ColsAnteriores, Linha)
    ).



% ============================================================
% CONSULTAS EXEMPLO
% ============================================================

% Resolver automaticamente:
% ?- solucao(S).

% Mostrar solução:
% ?- demonstrar.

% Validar configuração:
% ?- valida([1,5,8,6,3,7,2,4]).

% Total de soluções:
% ?- total_solucoes(N).

% Jogar manualmente:
% ?- jogar.
