--Consulta 1:
--Ordenar as atividades de um pais por numero de contratacoes exibindo preco e nome do prestador
SELECT S.NOME AS SERVICO, A.VALORATIVIDADE AS PRECO, P.NOME AS PRESTADOR, COUNT(*) AS CONTRATACOES
    FROM SERVICO S
         JOIN ATIVIDADE A ON (S.NOME = A.NOMESERVICO AND S.PRESTADOR = A.PRESTADOR)
         JOIN PRESTADORSERVICO P ON P.EMAIL = S.PRESTADOR
    WHERE S.PAIS = 'FRANCA'
    GROUP BY S.NOME, A.VALORATIVIDADE, P.NOME
    ORDER BY CONTRATACOES DESC;
	
--Consulta 2:
--Ordenar os prestadores por media de avaliacao dos contratos de servico exibindo o numero de contratos firmados
SELECT P.NOME AS PRESTADOR, P.EMAIL, AVG(C.NOTA) AS AVALIACAO, COUNT(*) AS CONTRATACOES
    FROM PRESTADORSERVICO P
         JOIN CONTRATOSERVICO C ON (P.EMAIL = C.PRESTADOR)
    GROUP BY P.EMAIL, P.NOME
    ORDER BY AVALIACAO DESC NULLS LAST, CONTRATACOES DESC;
    
--Consulta 3:
--Selecionar servicos que nao possuem restricao exibindo os precos e nome do prestador
SELECT S.NOME AS NOMESERVICO, A.VALORATIVIDADE AS PRECOATIVIDADE, L.VALOREQUIP AS PRECOEQUIPAMENTO, S.PAIS, P.NOME AS NOMEPRESTADOR
    FROM SERVICO S
         LEFT JOIN RESTRICOES R ON (S.PRESTADOR = R.PRESTADOR AND S.NOME = R.NOMESERVICO)
         JOIN PRESTADORSERVICO P ON S.PRESTADOR = P.EMAIL
         LEFT JOIN ATIVIDADE A ON (S.PRESTADOR = A.PRESTADOR AND S.NOME = A.NOMESERVICO)
         LEFT JOIN LOCACAOEQUIP L ON (S.PRESTADOR = L.PRESTADOR AND S.NOME = L.NOMESERVICO)
    WHERE R.RESTRICAO IS NULL;

--Consulta 4:
--Retornar o historico dos servicos utilizados por um turista
SELECT C.NOMESERVICO, C.DATAINICIO, C.DATAFIM
    FROM CONTRATOSERVICO C
        JOIN GRUPO G ON (C.ADMINGRUPO = G.ADMINISTRADOR AND C.NOMEGRUPO = G.NOME)
        JOIN MEMBROGRUPO M ON (G.NOME = M.NOMEGRUPO AND G.ADMINISTRADOR = M.ADMINGRUPO)
    WHERE M.MEMBRO = 'mateus@email.com'
    ORDER BY C.DATAINICIO DESC;
   
--Consulta 5:
--Retorna o numero de grupos que utilizou todos os servicos de um prestador (divisao)
SELECT G.NOME, G.ADMINISTRADOR FROM GRUPO G WHERE
    NOT EXISTS(
       (SELECT S.NOME, S.PRESTADOR FROM SERVICO S
           WHERE S.PRESTADOR = 'daniel@email.com')
       MINUS
       (SELECT C.NOMESERVICO, C.PRESTADOR FROM CONTRATOSERVICO C
           WHERE G.ADMINISTRADOR = C.ADMINGRUPO AND G.NOME = C.NOMEGRUPO)
    );

   