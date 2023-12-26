select *from [namma yatri project].dbo.assembly$
select *from [namma yatri project].dbo.trips$
select *from [namma yatri project].dbo.trip_details$
select *from [namma yatri project].dbo.payment$
select *from [namma yatri project].dbo.duration$


--total trips

select count(distinct tripid) as total_trips from [namma yatri project].dbo.trip_details$

--total drivers
select count(distinct driverid) as total_drivers from [namma yatri project].dbo.trips$

--total earnings
select sum(fare)as total_earnings from [namma yatri project].dbo.trips$

--total ride completed

select sum(end_ride) as total_ride_complete from [namma yatri project].dbo.trip_details$;

--total searches
select sum(searches) as searches from [namma yatri project].dbo.trip_details$

--total searches which got estimate
select sum(searches_got_estimate) as searches_estimate from [namma yatri project].dbo.trip_details$

--total driver canceled
select count(*)-sum(driver_not_cancelled) as driver_cancel from [namma yatri project].dbo.trip_details$

-- total otp entered
select sum(otp_entered) as total_otp from [namma yatri project].dbo.trip_details$

--total end ride
select sum(end_ride) as total_otp from [namma yatri project].dbo.trip_details$

--average distance per trip
select avg(distance) as average_distance from [namma yatri project].dbo.trips$

--average fare per trip
select avg(fare) as avg_fare from [namma yatri project].dbo.trips$

--distance travelled
select sum(distance) as distance_travel from [namma yatri project].dbo.trips$

--most payment used
select a.method from [namma yatri project].dbo.payment$ a inner join

(select top 1 faremethod,count(distinct tripid)as count from [namma yatri project].dbo.trips$
group by faremethod
order by count(distinct tripid) desc) b

on a.id=b.faremethod

--the highest payment was made through which instrument
select a.method from [namma yatri project].dbo.payment$ a inner join

(select top 1 * from [namma yatri project].dbo.trips$
order by fare desc) b
on a.id=b.faremethod;

-- which two locations had the most trips
select * from(
select *,DENSE_RANK() over(order by trip desc) rnk
from
(select loc_from,loc_to,count(distinct tripid) trip from [namma yatri project].dbo.trips$
group by loc_from,loc_to)a)b
where rnk =1;

--top 5 earning drivers
select* from(
select *, DENSE_RANK() over(order by fare desc) rnk
from
(select driverid,sum(fare) fare from [namma yatri project].dbo.trips$
group by driverid)b)c
where rnk < 6 ;

-- which duration had more trips
select * from (
select* , DENSE_RANK() over(order by cnt desc) rnk
from
(select duration,count(distinct tripid) cnt from [namma yatri project].dbo.trips$
group by duration)a)b
where rnk =1;

-- which driver , customer pair had more orders
select*from(
select*,DENSE_RANK() over(order by cnt desc)rnk
from
(select custid,driverid,count(distinct tripid) cnt from [namma yatri project].dbo.trips$
group by custid,driverid)a)b
where rnk=1;

-- which area got highest trips in which duration

select* from 
(select*,rank() over(partition by duration order by cnt desc)rnk
from
( select duration,loc_from, count(distinct tripid) cnt from [namma yatri project].dbo.trips$
 group by duration,loc_from)a)b
 where rnk=1;

 --which area got the highest fares, cancellations,trips,
 select*from
 (select*,rank() over (order by cnt desc)rnk
 from
 (select sum(fare) cnt,loc_from from [namma yatri project].dbo.trips$
 group by fare,loc_from)a)b
 where rnk=1;

 select* from
 (select*,rank() over (order by d_canc desc)rnk
 from
 (select sum(loc_from)-sum(driver_not_cancelled) canc from [namma yatri project].dbo.trip_details$
 group by loc_from)a)b
 where rnk=1;

 select* from
 (select*,rank() over (order by d_canc desc)rnk
 from
 (select sum(loc_from)-sum(customer_not_cancelled) d_canc from [namma yatri project].dbo.trip_details$
 group by loc_from)a)b
 where rnk=1

 -- which duration got the highest trips and fares

 select*from
 (select*,rank() over (order by fare desc)rnk
 from
 (select sum(fare) fare,duration from [namma yatri project].dbo.trips$
 group by duration)a)b
 where rnk=1;

 select*from
 (select*,rank() over (order by fare desc)rnk
 from
 (select count(distinct tripid) fare,duration from [namma yatri project].dbo.trips$
 group by duration)a)b
 where rnk=1;