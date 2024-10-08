
--  1 .Devuelve todas las películas


SELECT MOVIES.MOVIE_NAME FROM MOVIES

-- 2. Devuelve todos los géneros existentes

SELECT "GENRE_NAME"  FROM GENRES

-- 3. Devuelve la lista de todos los estudios de grabación que estén activos

SELECT "STUDIO_NAME" FROM PUBLIC.STUDIOS WHERE STUDIOS.STUDIO_ACTIVE = 1

-- 4. Devuelve una lista de los 20 últimos miembros en anotarse al videoclub

SELECT MEMBER_NAME, MEMBER_DISCHARGE_DATE  FROM PUBLIC.PUBLIC.MEMBERS ORDER BY MEMBER_DISCHARGE_DATE DESC LIMIT 20

-- 5. Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor.

SELECT MOVIE_DURATION,COUNT(*) AS FREQUENCY FROM PUBLIC.PUBLIC.MOVIES GROUP BY MOVIE_DURATION ORDER BY FREQUENCY DESC

-- 6. Devuelve las películas del año 2000 en adelante que empiecen por la letra A.

SELECT MOVIE_NAME,MOVIE_LAUNCH_DATE FROM PUBLIC.PUBLIC.MOVIES WHERE YEAR(MOVIE_LAUNCH_DATE) >= 2000 AND MOVIE_NAME LIKE 'A%'

-- 7. Devuelve los actores nacidos un mes de Junio

SELECT a.ACTOR_NAME,a.ACTOR_BIRTH_DATE FROM PUBLIC.PUBLIC.ACTORS a WHERE MONTH(a.ACTOR_BIRTH_DATE) = 6

-- 8. Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos.

SELECT  a.ACTOR_NAME,a.ACTOR_BIRTH_DATE FROM PUBLIC.PUBLIC.ACTORS a WHERE MONTH(a.ACTOR_BIRTH_DATE) != 6 AND a.ACTOR_DEAD_DATE IS NULL 

-- 9. Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos

SELECT DIRECTOR_NAME, 
       (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM DIRECTOR_BIRTH_DATE)) AS AGE
FROM PUBLIC.PUBLIC.DIRECTORS
WHERE DIRECTOR_DEAD_DATE IS NULL
  AND (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM DIRECTOR_BIRTH_DATE)) <= 50;

-- 10. Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido

SELECT a.ACTOR_NAME, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM a.ACTOR_BIRTH_DATE) AS edad FROM PUBLIC.PUBLIC.ACTORS a 
WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM a.ACTOR_BIRTH_DATE) < 50 AND a.ACTOR_DEAD_DATE IS NOT NULL 

-- 11. Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos

SELECT DIRECTOR_NAME AS Nombre, EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM D.DIRECTOR_BIRTH_DATE) AS edad FROM PUBLIC.PUBLIC.DIRECTORS d 
 WHERE EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM D.DIRECTOR_BIRTH_DATE) <= 40 AND d.DIRECTOR_DEAD_DATE IS NULL
 
 -- 12. Indica la edad media de los directores vivos

SELECT AVG(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM d.DIRECTOR_BIRTH_DATE)) AS EdadMedia FROM PUBLIC.PUBLIC.DIRECTORS d 
WHERE d.DIRECTOR_DEAD_DATE IS NULL

-- 13. Indica la edad media de los actores que han fallecido

SELECT AVG(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM a.ACTOR_BIRTH_DATE)) AS EdadMedia FROM PUBLIC.PUBLIC.ACTORS a 
WHERE a.ACTOR_DEAD_DATE IS NOT NULL

-- 14. Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado

SELECT m.MOVIE_NAME AS Nombre, S.STUDIO_NAME AS Estudio FROM PUBLIC.PUBLIC.MOVIES m LEFT JOIN PUBLIC.PUBLIC.STUDIOS s ON m.STUDIO_ID = s.STUDIO_ID 

-- 15. Devuelve los miembros que alquilaron al menos una película entre el año 2010 y el 2015

SELECT  DISTINCT M.MEMBER_NAME AS Miembros
FROM PUBLIC.PUBLIC.MEMBERS m 
inner JOIN PUBLIC.PUBLIC.MEMBERS_MOVIE_RENTAL mmr ON m.MEMBER_ID = MMR.MEMBER_ID 
WHERE EXTRACT (YEAR FROM mmr.MEMBER_RENTAL_DATE) BETWEEN 2010 AND 2015 
GROUP BY M.MEMBER_NAME,EXTRACT(YEAR FROM MMR.MEMBER_RENTAL_DATE) 
HAVING COUNT(*) >= 1

-- 16. Devuelve cuantas películas hay de cada país

SELECT count(*) AS NumFilm, n.NATIONALITY_NAME FROM PUBLIC.PUBLIC.MOVIES m
LEFT JOIN PUBLIC.PUBLIC.NATIONALITIES n 
ON m.NATIONALITY_ID = n.NATIONALITY_ID 
GROUP BY n.NATIONALITY_NAME 

-- 17. Devuelve todas las películas que hay de género documental

SELECT m.MOVIE_NAME AS Peliculas FROM public.PUBLIC.MOVIES m 
LEFT JOIN PUBLIC.PUBLIC.GENRES g 
ON m.GENRE_ID = g.GENRE_ID 
WHERE g.GENRE_NAME like 'Documentary'
GROUP BY m.MOVIE_NAME 

-- 18. Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos

SELECT M.MOVIE_NAME FROM PUBLIC.PUBLIC.MOVIES m 
INNER JOIN PUBLIC.PUBLIC.DIRECTORS d 
ON m.DIRECTOR_ID = d.DIRECTOR_ID 
WHERE YEAR(d.DIRECTOR_BIRTH_DATE) >= 1980

-- 19. Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros del videoclub y los directores.
-- (No encuentra coincidencias tiene que estar mal)
SELECT m.MEMBER_NAME, d.DIRECTOR_NAME,m.MEMBER_TOWN AS CiudadCoincidencia FROM PUBLIC.PUBLIC.MEMBERS m 
LEFT JOIN PUBLIC.PUBLIC.DIRECTORS d 
ON LOWER(m.MEMBER_TOWN) = LOWER(d.DIRECTOR_BIRTH_PLACE) 
WHERE d.DIRECTOR_NAME IS NOT NULL 

-- 20. Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo

SELECT m.MOVIE_NAME,YEAR(m.MOVIE_LAUNCH_DATE) FROM PUBLIC.PUBLIC.MOVIES m 
LEFT JOIN PUBLIC.PUBLIC.STUDIOS s 
ON m.STUDIO_ID = s.STUDIO_ID 
WHERE s.STUDIO_ACTIVE  = 0

-- 21. Devuelve una lista de las últimas 10 películas que se han alquilado

SELECT m.MOVIE_NAME, mmr.MEMBER_RENTAL_DATE FROM PUBLIC.PUBLIC.MOVIES m 
LEFT JOIN PUBLIC.PUBLIC.MEMBERS_MOVIE_RENTAL mmr 
ON m.MOVIE_ID = mmr.MOVIE_ID 
WHERE mmr.MEMBER_RENTAL_DATE IS NOT NULL 
ORDER BY mmr.MEMBER_RENTAL_DATE DESC 
LIMIT 10

-- 22. Indica cuántas películas ha realizado cada director antes de cumplir 41 años

SELECT d.DIRECTOR_NAME,COUNT(*) AS NumPeliculas FROM PUBLIC.PUBLIC.MOVIES m 
LEFT JOIN PUBLIC.PUBLIC.DIRECTORS d 
ON M.DIRECTOR_ID = d.DIRECTOR_ID 
WHERE EXTRACT(YEAR FROM m.MOVIE_LAUNCH_DATE) - EXTRACT(YEAR FROM d.DIRECTOR_BIRTH_DATE) < 41
GROUP BY d.DIRECTOR_NAME 


-- 23. Indica cuál es la media de duración de las películas de cada director

SELECT d.DIRECTOR_NAME, AVG(m.MOVIE_DURATION) AS DuracionMedia FROM PUBLIC.PUBLIC.MOVIES m 
LEFT JOIN PUBLIC.PUBLIC.DIRECTORS d 
ON m.MOVIE_ID = d.DIRECTOR_ID 
WHERE d.DIRECTOR_NAME IS NOT NULL 
GROUP BY d.DIRECTOR_NAME

-- 24. Indica cuál es el nombre y la duración mínima de la película que ha sido alquilada en los últimos 2 años por los miembros del videoclub (La "fecha de ejecución" en este script es el 25-01-2019)

SELECT m.MOVIE_NAME, m.MOVIE_DURATION AS duracionMinima FROM PUBLIC.PUBLIC.MOVIES m 
LEFT JOIN PUBLIC.PUBLIC.MEMBERS_MOVIE_RENTAL mmr 
ON mmr.MOVIE_ID = m.MOVIE_ID 
WHERE mmr.MEMBER_RENTAL_DATE BETWEEN '2017-01-25' AND '2019-01-25' 
ORDER BY m.MOVIE_DURATION ASC
LIMIT 1

-- 25. Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra "The" en cualquier parte del título

SELECT COUNT(*) AS NumeroPeliculas ,d.DIRECTOR_NAME FROM PUBLIC.PUBLIC.MOVIES m 
RIGHT JOIN PUBLIC.PUBLIC.DIRECTORS d 
ON m.DIRECTOR_ID = d.DIRECTOR_ID  
WHERE m.MOVIE_NAME LIKE '%The%' AND m.MOVIE_LAUNCH_DATE BETWEEN '1960-01-01' AND '1980-01-01' 
GROUP BY d.DIRECTOR_NAME 

-- 26. Lista nombre, nacionalidad y director de todas las películas

SELECT m.MOVIE_NAME,n.NATIONALITY_NAME,DIRECTOR_NAME FROM PUBLIC.PUBLIC.MOVIES m
LEFT JOIN PUBLIC.PUBLIC.DIRECTORS d 
ON m.DIRECTOR_ID = d.DIRECTOR_ID 
LEFT JOIN PUBLIC.PUBLIC.NATIONALITIES n
ON m.NATIONALITY_ID = n.NATIONALITY_ID 

-- 27. Muestra las películas con los actores que han participado en cada una de ellas

SELECT m.MOVIE_NAME,a.ACTOR_NAME FROM PUBLIC.PUBLIC.MOVIES m 
LEFT JOIN PUBLIC.PUBLIC.ACTORS a 
ON a.ACTOR_ID = m.MOVIE_ID 
ORDER BY m.MOVIE_NAME ASC 

-- 28. Indica cual es el nombre del director del que más películas se han alquilado

SELECT d.DIRECTOR_NAME,count(*) AS numeroPelis FROM PUBLIC.PUBLIC.MOVIES m 
LEFT JOIN PUBLIC.PUBLIC.DIRECTORS d 
ON m.DIRECTOR_ID = d.DIRECTOR_ID 
INNER JOIN PUBLIC.PUBLIC.MEMBERS_MOVIE_RENTAL mmr 
ON mmr.MOVIE_ID = m.MOVIE_ID 
GROUP BY d.DIRECTOR_NAME
ORDER BY numeroPelis DESC

-- 29. Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado

SELECT s.STUDIO_NAME, count(*) AS NumPremios FROM PUBLIC.PUBLIC.AWARDS a 
LEFT JOIN PUBLIC.PUBLIC.MOVIES m 
ON a.MOVIE_ID = m.MOVIE_ID 
INNER JOIN PUBLIC.PUBLIC.STUDIOS s 
ON s.STUDIO_ID = m.STUDIO_ID 
GROUP BY s.STUDIO_NAME 
ORDER BY numPremios desc

-- 30. Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido 
--(Si una película está nominada a un premio, su actor también lo está) ****(puede que este mal)***


SELECT a2.ACTOR_NAME, COUNT(a.AWARD_NOMINATION) AS NumeroNominaciones
FROM PUBLIC.PUBLIC.AWARDS a
LEFT JOIN PUBLIC.PUBLIC.MOVIES m 
ON a.MOVIE_ID = m.MOVIE_ID 
LEFT JOIN PUBLIC.PUBLIC.MOVIES_ACTORS ma 
ON a.MOVIE_ID = ma.MOVIE_ID 
LEFT JOIN PUBLIC.PUBLIC.ACTORS a2 
ON ma.ACTOR_ID = a2.ACTOR_ID
WHERE a.AWARD_WIN = 0
GROUP BY a2.ACTOR_NAME;

-- 31. Indica cuantos actores y directores hicieron películas para los estudios no activos

SELECT count(DISTINCT a.ACTOR_NAME, ' ') AS Actores, count(DISTINCT d.DIRECTOR_NAME,' ') AS Directores FROM PUBLIC.PUBLIC.MOVIES m 
LEFT JOIN PUBLIC.PUBLIC.STUDIOS s 
ON m.STUDIO_ID = s.STUDIO_ID 
LEFT JOIN PUBLIC.PUBLIC.DIRECTORS d 
ON d.DIRECTOR_ID = m.DIRECTOR_ID 
LEFT JOIN PUBLIC.PUBLIC.MOVIES_ACTORS ma 
ON ma.MOVIE_ID = m.MOVIE_ID 
LEFT JOIN PUBLIC.PUBLIC.ACTORS a 
ON a.ACTOR_ID = ma.ACTOR_ID 
WHERE s.STUDIO_ACTIVE = 0


-- 32. Indica el nombre, ciudad, y teléfono de todos los miembros del videoclub que hayan alquilado películas que hayan sido nominadas a más de 150 premios y ganaran menos de 50

	SELECT m2.MEMBER_NAME,m2.MEMBER_TOWN,m2.MEMBER_PHONE FROM PUBLIC.PUBLIC.MOVIES m 
	LEFT JOIN PUBLIC.PUBLIC.AWARDS a 
	ON a.MOVIE_ID = m.MOVIE_ID 
	LEFT JOIN PUBLIC.PUBLIC.MEMBERS_MOVIE_RENTAL mmr 
	ON mmr.MOVIE_ID = m.MOVIE_ID 
	LEFT JOIN PUBLIC.PUBLIC.MEMBERS m2 
	ON mmr.MEMBER_ID = m2.MEMBER_ID 
	WHERE a.AWARD_NOMINATION > 150 AND a.AWARD_WIN < 50
	

-- 33. Comprueba si hay errores en la BD entre las películas y directores (un director fallecido en el 76 no puede dirigir una película en el 88)
	
	SELECT d.DIRECTOR_NAME,d.DIRECTOR_DEAD_DATE,m.MOVIE_LAUNCH_DATE FROM PUBLIC.PUBLIC.DIRECTORS d 
	LEFT JOIN PUBLIC.PUBLIC.MOVIES m 
	ON d.DIRECTOR_ID = m.DIRECTOR_ID 
	WHERE DIRECTOR_DEAD_DATE < m.MOVIE_LAUNCH_DATE 
	

-- 34. Utilizando la información de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL)

	UPDATE PUBLIC.PUBLIC.DIRECTORS d
	SET d.DIRECTOR_DEAD_DATE = (SELECT MAX(m.MOVIE_LAUNCH_DATE) + INTERVAL '1' YEAR FROM PUBLIC.PUBLIC.MOVIES m WHERE m.DIRECTOR_ID = d.DIRECTOR_ID)
	WHERE d.DIRECTOR_ID IN (SELECT m.DIRECTOR_ID FROM PUBLIC.PUBLIC.MOVIES m WHERE m.MOVIE_LAUNCH_DATE > d.DIRECTOR_DEAD_DATE);
	
-- 35. Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película

SELECT DISTINCT d.DIRECTOR_NAME, g.GENRE_NAME,max(count(*)) AS Generos FROM PUBLIC.PUBLIC.MOVIES m 
LEFT JOIN PUBLIC.PUBLIC.DIRECTORS d 
ON m.DIRECTOR_ID  = d.DIRECTOR_ID 
LEFT JOIN PUBLIC.PUBLIC.GENRES g 
ON g.GENRE_ID = m.GENRE_ID 
GROUP BY d.DIRECTOR_NAME,g.GENRE_NAME 

ORDER BY Generos desc

-- 36. Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas

-- 37. Indica cuál fue la primera película que alquilaron los miembros del videoclub cuyos teléfonos tengan como último dígito el ID de alguna nacionalidad














