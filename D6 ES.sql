--visualizzare per ogni studente la matricola, il nome, il voto massimo, medio e minimo, conseguito negli esami
--visualizzare per ogni studente con media voti >25 e che ha sostenuto esami in almeno 10 date 
-- la matricola, il nome, il voto massimo, minimo e medio conseguito negli esami ordinare per voto

select
	s.Matricola
	,s.Nome
	,Max (e.voto)
	,Min (e.voto)
	,Avg (e.Voto)
From Studente s
Inner join esame e
On s.Matricola=e.MatricolaStudente
Group by s.Nome


--media voto studentente >25
select
	,s.Nome
From Studente s
Inner join esame e
On s.Matricola=e.MatricolaStudente
group by s.Nome
having Count (e.Voto)>25

--studenti che hanno sostenuto piu di 10 esami in 10 date
select
	,s.Nome
From Studente s
Inner join esame e
On s.Matricola=e.MatricolaStudente
group by e.Data, s.Nome
having Count (s.Nome)>10


SELECT S.Nome, S.Matricola,MAX(S.Voto),MIN(S.Voto),AVG(S.Voto)FROM Studente as SJOIN Esame as EON S.Matricola = E.MatricolaStudenteWHERE S.Nome IN ( SELECT S.Nome                  FROM Studente as S                  JOIN Esame as E                   ON S.Matricola = E.MatricolaStudente                   GROUP BY S.Nome                  HAVING AVG(E.Voto) > 25 )AND S.Nome IN ( SELECT S.Nome                FROM Studente as S                JOIN Esame as E                ON S.Matricola = E.MatricolaStudente                GROUP BY Date, S.Nome                HAVING Count(S.Nome) > 10 )GROUP BY S.Nome, S.MatricolaORDER BY S.Voto DESC