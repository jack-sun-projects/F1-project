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

WITH qual_match AS
(SELECT
	d.forename || " " || d.surname AS driver,
	c.name,
	r.raceid,
	r.name AS track_name,
	q.q1,
	q.q2,
	q.q3
FROM qualifying_csv q
LEFT JOIN drivers_csv d ON q.driverId=d.driverId
LEFT JOIN races_csv r ON q.raceId=r.raceId
LEFT JOIN constructors_csv c ON q.constructorId=c.constructorId
WHERE r.year==2021
ORDER BY r.name, q.position)
SELECT 
	(q1.driver || " / " || q2.driver) AS driver_match,
	q1.driver AS driver_1,
	q2.driver AS driver_2,
	q1.name,
	q1.track_name,
	q1.raceid,
	substr(q1.q1,1,1)*60+substr(q1.q1,3,2)+substr(q1.q1,6,3)*0.001 AS driver_1_q1,
	substr(q1.q2,1,1)*60+substr(q1.q2,3,2)+substr(q1.q2,6,3)*0.001 AS driver_1_q2,
	substr(q1.q3,1,1)*60+substr(q1.q3,3,2)+substr(q1.q3,6,3)*0.001 AS driver_1_q3,
	substr(q2.q1,1,1)*60+substr(q2.q1,3,2)+substr(q2.q1,6,3)*0.001 AS driver_2_q1,
	substr(q2.q2,1,1)*60+substr(q2.q2,3,2)+substr(q2.q2,6,3)*0.001 AS driver_2_q2,
	substr(q2.q3,1,1)*60+substr(q2.q3,3,2)+substr(q2.q3,6,3)*0.001 AS driver_2_q3,
	CASE
		WHEN ((substr(q2.q3,1,1)*60+substr(q2.q3,3,2)+substr(q2.q3,6,3)*0.001) AND (substr(q1.q3,1,1)*60+substr(q1.q3,3,2)+substr(q1.q3,6,3)*0.001))!=0 THEN (substr(q2.q3,1,1)*60+substr(q2.q3,3,2)+substr(q2.q3,6,3)*0.001)-(substr(q1.q3,1,1)*60+substr(q1.q3,3,2)+substr(q1.q3,6,3)*0.001)
		WHEN ((substr(q2.q2,1,1)*60+substr(q2.q2,3,2)+substr(q2.q2,6,3)*0.001) AND (substr(q1.q2,1,1)*60+substr(q1.q2,3,2)+substr(q1.q2,6,3)*0.001))!=0 THEN (substr(q1.q2,1,1)*60+substr(q1.q2,3,2)+substr(q1.q2,6,3)*0.001)-(substr(q2.q2,1,1)*60+substr(q2.q2,3,2)+substr(q2.q2,6,3)*0.001)
		WHEN ((substr(q2.q1,1,1)*60+substr(q2.q1,3,2)+substr(q2.q1,6,3)*0.001) AND (substr(q1.q1,1,1)*60+substr(q1.q1,3,2)+substr(q1.q1,6,3)*0.001))!=0 THEN (substr(q2.q1,1,1)*60+substr(q2.q1,3,2)+substr(q2.q1,6,3)*0.001)-(substr(q1.q1,1,1)*60+substr(q1.q1,3,2)+substr(q1.q1,6,3)*0.001)
		ELSE 0
		END AS qual_gap
FROM qual_match q1
LEFT JOIN qual_match q2 ON q1.name=q2.name AND q1.raceid=q2.raceid
WHERE q1.driver!=q2.driver AND q1.driver<q2.driver