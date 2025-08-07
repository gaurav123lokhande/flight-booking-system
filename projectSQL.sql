create database project1
use project1 ;

-- show the airports table
SELECT * FROM airports;

-- show the airlines table
SELECT * FROM airlines;

-- show the aircraft table
SELECT * FROM aircrafts;

-- show the flights table
SELECT * FROM flights;

-- show the passengers table
SELECT * FROM passengers;

-- show the bookings table
SELECT * FROM bookings;

-- QUERY 30
-- Q1 no of total flights?
SELECT COUNT(*) AS TotalFlights FROM flights;

-- Q2 total no of passengers?
SELECT COUNT(*) AS TotalPassengers FROM passengers;

-- Q3 total no of bookings?
SELECT COUNT(*) AS TotalBookings FROM bookings;

-- Q4 Most used aircraft model
SELECT ac.model, COUNT(*) AS FlightCount
    FROM flights f
    JOIN aircrafts ac ON f.aircraftID = ac.aircraftID
    GROUP BY ac.model
    ORDER BY FlightCount DESC
    LIMIT 2;
    
-- Q5 Airline with most flights
SELECT al.name, COUNT(*) AS total_flights
FROM flights f
JOIN airlines al ON f.airlineID = al.airlineID
GROUP BY al.name
ORDER BY total_flights DESC
LIMIT 1;

-- Q6 Daily flights trend(daily flight deprature)
SELECT DATE(departureTime) AS flight_date, COUNT(*) AS flights
FROM flights
GROUP BY DATE(departureTime)
ORDER BY flight_date;

-- Q7 Top 10 passenger by bookings
SELECT FirstName, COUNT(*) AS booking_count
FROM bookings b
JOIN passengers p ON b.passengerID = p.passengerID
GROUP BY FirstName
ORDER BY booking_count DESC
LIMIT 10;

-- Q8 Bookings per airline
SELECT al.name AS airline, COUNT(*) AS total_bookings
FROM bookings b
JOIN flights f ON b.flightID = f.flightID
JOIN airlines al ON f.airlineID = al.airlineID
GROUP BY al.name;

-- Q9 Flights per aircraft model
SELECT ac.model, COUNT(*) AS flights
FROM flights f
JOIN aircrafts ac ON f.aircraftID = ac.aircraftID
GROUP BY ac.model;

-- Q10 Average bookings per flight
SELECT AVG(booking_count) AS avg_bookings
FROM (
  SELECT flightID, COUNT(*) AS booking_count
  FROM bookings
  GROUP BY flightID
) AS flight_bookings;

-- Q11 Flights with no bookings
SELECT f.flightID
FROM flights f
LEFT JOIN bookings b ON f.flightID = b.flightID
WHERE b.bookingID IS NULL;

-- Q12 Top 5 passengers by flight count
SELECT p.FirstName, COUNT(*) AS flights
FROM bookings b
JOIN passengers p ON b.passengerID = p.passengerID
GROUP BY p.FirstName
ORDER BY flights DESC
LIMIT 5;

-- Q13 Number of unique flight routes
SELECT COUNT(DISTINCT CONCAT(DepartureTime, '-', ArrivalTime)) AS route_count
FROM flights;

-- Q14 Flights per airline
SELECT al.name, COUNT(f.flightID) AS flight_count
FROM airlines al
LEFT JOIN flights f ON al.airlineID = f.airlineID
GROUP BY al.name;

-- Q15 Most frequent passenger-airline combo (most booking)
SELECT p.FirstName, al.name AS airline, COUNT(*) AS bookings
FROM bookings b
JOIN passengers p ON b.passengerID = p.passengerID
JOIN flights f ON b.flightID = f.flightID
JOIN airlines al ON f.airlineID = al.airlineID
GROUP BY p.FirstName, al.name
ORDER BY bookings DESC
LIMIT 1;

-- Q16Monthly flight count
SELECT DATE_FORMAT(departureTime, '%Y-%m') AS month, COUNT(*) AS flights
FROM flights
GROUP BY month;

-- Q17 Which airport-to-airport route has the most flights, and what are their names and total flights?"
SELECT 
    dep.Name AS DepartureAirport,
    arr.Name AS ArrivalAirport,
    COUNT(*) AS TotalFlights
FROM flights f
JOIN airports dep ON f.SourceID = dep.AirportID
JOIN airports arr ON f.DestinationID = arr.AirportID
GROUP BY dep.Name, arr.Name
ORDER BY TotalFlights DESC
LIMIT 5;

-- Q18 Most frequently used aircraft
SELECT ac.model, COUNT(*) AS usage_count
FROM flights f
JOIN aircrafts ac ON f.aircraftID = ac.aircraftID
GROUP BY ac.model
ORDER BY usage_count DESC
LIMIT 10;

-- Q19 Passengers with more than 5 flights
SELECT p.FirstName, COUNT(*) AS total_flights
FROM bookings b
JOIN passengers p ON b.passengerID = p.passengerID
GROUP BY p.FirstName
HAVING total_flights > 5;

-- Q20 Flights between New York and london
SELECT f.*, a1.City AS DepartureCity, a2.City AS ArrivalCity
FROM flights f
JOIN airports a1 ON f.SourceID = a1.AirportID
JOIN airports a2 ON f.DestinationID = a2.AirportID
WHERE a1.City = 'New York' AND a2.City = 'London';

-- Q21 Top 3 aircraft models by capacity
SELECT model, capacity
FROM aircrafts
ORDER BY capacity DESC
LIMIT 3;

-- Q22 Flights per airline per month
SELECT al.name AS airline, DATE_FORMAT(f.departureTime, '%Y-%m') AS month, COUNT(*) AS flights
FROM flights f
JOIN airlines al ON f.airlineID = al.airlineID
GROUP BY al.name, month;

-- Q23  Average aircraft capacity per airline
SELECT al.name, AVG(ac.capacity) AS avg_capacity
FROM airlines al
JOIN aircrafts ac ON al.airlineID = ac.airlineID
GROUP BY al.name;

-- Q24 Bookings by per day in week
SELECT DAYNAME(f.departureTime) AS weekday, COUNT(*) AS bookings
FROM bookings b
JOIN flights f ON b.flightID = f.flightID
GROUP BY weekday;

-- Q25 Which 5 cities have the most number of departing flights
SELECT a.City, COUNT(*) AS Departures
FROM flights f
JOIN airports a ON f.SourceID = a.AirportID
GROUP BY a.City
ORDER BY Departures DESC
LIMIT 5;

-- Q26 Invalid bookings (flights not found)
SELECT b.*
FROM bookings b
LEFT JOIN flights f ON b.FlightID = f.FlightID
WHERE f.FlightID IS NULL;
-- all bokkings are valit booking table 

-- Q27 Show Valid Bookings ( match with FlightID )
SELECT b.BookingID, b.FlightID, f.FlightNumber, f.Status AS FlightStatus
FROM bookings b
JOIN flights f ON b.FlightID = f.FlightID;

-- Q28 How many flights have the same source and destination airport
SELECT COUNT(*) AS same_airport_flights
FROM flights
WHERE SourceID = DestinationID;

-- Q29 List of Passengers Who Booked More Than 5 Flights
SELECT 
    p.passengerID,
    p.FirstName,
    p.LastName,
    COUNT(b.bookingID) AS bookings
FROM bookings b
JOIN passengers p ON b.passengerID = p.passengerID
GROUP BY p.passengerID, p.FirstName, p.LastName
HAVING COUNT(b.bookingID) > 5
ORDER BY bookings DESC;
-- no any passengers book more than 5 flight

-- Q30 Passenger Booking History with Flight Details
SELECT 
    p.passengerID,
    p.FirstName,
    p.LastName,
    f.flightID,
    f.departureTime,
    f.arrivalTime
FROM bookings b
JOIN passengers p ON b.passengerID = p.passengerID
JOIN flights f ON b.flightID = f.flightID
ORDER BY p.passengerID, f.departureTime;



desc aircrafts;
desc airlines;
desc airports;
desc bookings;
select * from bookings;
desc flights;
select * from flights;
desc passengers;

alter table aircrafts modify aircraftID int primary key;
alter table airlines modify airLineID int primary key;
alter table airports modify airportID int primary key;
alter table bookings modify BookingID int primary key;
alter table bookings add foreign key (passengerID) references passengers(passengerID);
alter table passengers modify passengerID int primary key;
alter table bookings add foreign key (passengerID) references passengers(passengerID);
alter table flights modify flightID int primary key;
alter table flights add foreign key (airlineID) references airlines(airlineId);	
alter table flights add foreign key (aircraftID) references aircrafts(aircraftId);	