--QUERY-1:
--Top 5% of passengers who booked the maximum number of rides for a month
--5%passengers => 5%of50 = 3

select PID, FIRSTNAME, LASTNAME, COUNT(BID) NO_OF_BOOKINGS
FROM 
    Fall22_S003_12_PASSENGER PA 
INNER JOIN 
    FALL22_S003_12_BOOKING BK 
ON PA.PID = BK.PSGID 
WHERE BDATE BETWEEN TO_DATE('2023-05-01','YYYY-MM-DD') AND TO_DATE('2023-05-31','YYYY-MM-DD')
GROUP BY 
  PSGID,  FIRSTNAME, LASTNAME, PID
ORDER BY COUNT(BID) DESC
FETCH FIRST 3 ROWS ONLY;



--QUERY-2:
--Top 5% of passengers who booked the minimum number of rides for a month.

select PID, FIRSTNAME, LASTNAME, COUNT(BID) NO_OF_BOOKINGS
FROM 
    Fall22_S003_12_PASSENGER PA 
INNER JOIN 
    FALL22_S003_12_BOOKING BK 
ON PA.PID = BK.PSGID 
WHERE BDATE BETWEEN TO_DATE('2023-05-01','YYYY-MM-DD') AND TO_DATE('2023-05-31','YYYY-MM-DD')
GROUP BY 
  PSGID,  FIRSTNAME, LASTNAME, PID
ORDER BY COUNT(BID) ASC
FETCH FIRST 3 ROWS ONLY;


--QUERY-3:
--Top 5% of passengers who spent the maximum amount on the fare in a month.

select PID, FIRSTNAME, LASTNAME, SUM(FAREAMOUNT) AS TOTAL_AMOUNT, RANK() OVER (ORDER BY SUM(FAREAMOUNT) DESC) AS RANK_AMOUNT
FROM 
    Fall22_S003_12_PASSENGER PA INNER JOIN FALL22_S003_12_BOOKING BK ON PA.PID = BK.PSGID 
    WHERE BDATE BETWEEN TO_DATE('2023-05-01','YYYY-MM-DD') AND TO_DATE('2023-05-31','YYYY-MM-DD')
GROUP BY 
  PSGID,  FIRSTNAME, LASTNAME, PID
ORDER BY SUM(FAREAMOUNT) DESC
FETCH FIRST 3 ROWS ONLY;



--QUERY-4:
--Top 50% of cities where maximum ride bookings are made. 50%of10 => 5 cities
--Pickcity
SELECT PICKCITY, COUNT(BID) AS PICKCITY_BOOKING_COUNT FROM FALL22_S003_12_BOOKING 
GROUP BY PICKCITY HAVING COUNT(BID) >= ANY (
  SELECT AVG(COUNT(BID)) FROM FALL22_S003_12_BOOKING
  GROUP BY PICKCITY) 
ORDER BY COUNT(BID) DESC;

--Dropcity  
SELECT DROPCITY, COUNT(BID) AS DROPCITY_BOOKING_COUNT FROM FALL22_S003_12_BOOKING 
GROUP BY DROPCITY HAVING COUNT(BID) >= ANY (
  SELECT AVG(COUNT(BID)) FROM FALL22_S003_12_BOOKING
  GROUP BY DROPCITY) 
  ORDER BY COUNT(BID) DESC;

--Cube
SELECT DROPCITY, PICKCITY, COUNT(BID) BOOKING_COUNT
FROM FALL22_S003_12_BOOKING 
GROUP BY CUBE(DROPCITY,PICKCITY) 
HAVING COUNT(BID) >= (
  SELECT AVG(COUNT(BID)) 
  FROM FALL22_S003_12_BOOKING 
  GROUP BY DROPCITY)
ORDER BY COUNT(BID) DESC;  



--QUERY-5:
--Top 50% of cities where minimum ride bookings are made.
--Pickcity
SELECT PICKCITY, COUNT(BID) AS PICKCITY_BOOKING_COUNT FROM FALL22_S003_12_BOOKING 
GROUP BY PICKCITY HAVING COUNT(BID) < ANY (
  SELECT AVG(COUNT(BID)) FROM FALL22_S003_12_BOOKING
  GROUP BY PICKCITY) 
ORDER BY COUNT(BID);

--Dropcity  
SELECT DROPCITY, COUNT(BID) AS DROPCITY_BOOKING_COUNT FROM FALL22_S003_12_BOOKING 
GROUP BY DROPCITY HAVING COUNT(BID) < ANY (
  SELECT AVG(COUNT(BID)) FROM FALL22_S003_12_BOOKING
  GROUP BY DROPCITY) 
ORDER BY COUNT(BID);

--Cube
SELECT DROPCITY, PICKCITY, COUNT(BID) BOOKING_COUNT
FROM FALL22_S003_12_BOOKING 
GROUP BY CUBE(DROPCITY,PICKCITY) 
HAVING COUNT(BID) <   
(SELECT AVG(COUNT(BID)) 
  FROM FALL22_S003_12_BOOKING 
  GROUP BY DROPCITY)
 ORDER BY COUNT(BID);



--QUERY-6:
--Which month of the year experiences maximum ride bookings.
select TO_CHAR(to_date(trunc(b.bdate), 'YYYY-MM-DD'), 'MONTH') MONTH , COUNT(b.BDATE) BOOKING_COUNT
FROM dual, FALL22_S003_12_BOOKING b
GROUP BY TO_CHAR(to_date(trunc(b.bdate), 'YYYY-MM-DD'), 'MONTH') 
HAVING COUNT(b.BDATE) >= ALL
( select COUNT(bd.BDATE) 
  FROM dual, FALL22_S003_12_BOOKING bd 
  GROUP BY TO_CHAR(to_date(trunc(bd.bdate), 'YYYY-MM-DD'), 'MONTH'));


--QUERY-7:
--Which day of the week experiences maximum ride bookings.
select TO_CHAR(to_date(trunc(b.bdate), 'YYYY-MM-DD'), 'DAY') DAY , COUNT(b.BDATE) BOOKING_COUNT
FROM dual, FALL22_S003_12_BOOKING b
GROUP BY TO_CHAR(to_date(trunc(b.bdate), 'YYYY-MM-DD'), 'DAY') 
HAVING COUNT(b.BDATE) >= ALL
(select COUNT(bd.BDATE)
  FROM dual, FALL22_S003_12_BOOKING bd 
  GROUP BY TO_CHAR(to_date(trunc(bd.bdate), 'YYYY-MM-DD'), 'DAY'));



--QUERY-8:
--Which hours of the day experience maximum ride bookings.
select EXTRACT( HOUR FROM rs.starttime ) Time_Hour, COUNT(rs.BID) BOOKING_COUNT
  FROM dual, Fall22_S003_12_RIDESCHEDULE rs 
  GROUP BY EXTRACT( HOUR FROM rs.starttime )
HAVING COUNT(rs.BID) >= ALL
(select COUNT(rs.BID)--, EXTRACT( HOUR FROM rs.starttime ) Hour
  FROM dual, Fall22_S003_12_RIDESCHEDULE rs 
  GROUP BY EXTRACT( HOUR FROM rs.starttime ));
  

