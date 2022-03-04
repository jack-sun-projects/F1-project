WITH qual_match AS
(SELECT
	d.forename || " " || d.surname AS driver,
	c.name,
	r.raceid
FROM qualifying_csv q
LEFT JOIN drivers_csv d ON q.driverId=d.driverId
LEFT JOIN races_csv r ON q.raceId=r.raceId
LEFT JOIN constructors_csv c ON q.constructorId=c.constructorId
WHERE r.year==2021
ORDER BY r.name, q.position)
SELECT 
	DISTINCT(q1.driver || " / " || q2.driver),
	q1.driver AS driver_1,
	q2.driver AS driver_2,
	q1.name
FROM qual_match q1
LEFT JOIN qual_match q2 ON q1.name=q2.name AND q1.raceid=q2.raceid
WHERE q1.driver!=q2.driver AND q1.driver<q2.driver