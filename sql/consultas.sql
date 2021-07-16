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
--