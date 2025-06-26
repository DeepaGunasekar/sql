CREATE SCHEMA `hr`;
create database `model`;
use model;

create  table car(
make varchar(100),
model varchar(100),
year int,
value decimal(10,2)
);

DESC car;

INSERT INTO car VALUES
('Porsche', '911 GT3', 2020, 169700),
('Porsche', 'Cayman GT4', 2018, 118000),
('Porsche', 'Panamera', 2022, 113200),
('Porsche', 'Macan', 2019, 27400),
('Porsche', '718 Boxster', 2017, 48880),
('Ferrari', '488 GTB', 2015, 254750),
('Ferrari', 'F8 Tributo', 2019, 375000),
('Ferrari', 'SF90 Stradale', 2020, 627000),
('Ferrari', '812 Superfast', 2017, 335300),
('Ferrari', 'GTC4Lusso', 2016, 268000);

select * from car;


/*  stored proc can act as like an inbulit fuction to execute the quary and reform into make an anonynmous values  */



select * from car
order by make,value desc;

-- delimiter
delimiter //
create procedure get_all_car()
begin 
     select * from car
     order by make ,value desc;
end //
delimiter ;

call get_all_car ;

-- create a procedure using input paramater

DELIMITER //
CREATE PROCEDURE get_car_year(
         in  year_filter  int 
)
begin 
    select * from car
    where year=year_filter
    order by make, value desc ;
end //
delimiter ;

call get_car_year(2020);


-- extract car starts by year with  full details :
  delimiter //
  create procedure get_car_starts(
                   in year_filter int,
                   out car_number int,
                   out min_value decimal(10,2),
                   out max_value decimal(10,2),
                   out avg_value decimal(10,2)
)
begin 
select count(*) ,min(value),max(value),avg(value)
into car_number,min_value,max_value,avg_value
from car
where year= year_filter
order by make, value desc;
end //
delimiter ;

call get_car_starts(2020,@car_number,@min_value,@max_value,@avg_value);

select @car_number,@min_value,@max_value,@avg_value;


-- update to column
create temporary table car_update(
           model varchar(30),
           fuel_type varchar (30),
           mileage decimal(10,2)
);
 CREATE TEMPORARY TABLE car_updates(
	model VARCHAR(30),
    fuel_type VARCHAR(30),
    mileage DECIMAL(10,2)
    );

INSERT INTO car_updates VALUES
('911 GT3', 'petrol', 18.5),
('Cayman GT4','petrol',22.4),
( 'Panamera', 'Diesel', 25.0),
( 'Macan', 'petrol', 20.0),
('718 Boxster', 'Diesel',16.0 ),
('488 GTB', 'petrol', 18.5),
( 'F8 Tributo', 'Diesel',17.9),
( 'SF90 Stradale','Diesel', 18.5 ),
( '812 Superfast', 'Diesel',17.4 ),
( 'GTC4Lusso', 'Diesel',16.89);

ALTER TABLE car
ADD COLUMN fuel_type VARCHAR(30),
ADD COLUMN mileage DECIMAL(10,2);


UPDATE car a
        JOIN
    car_updates b ON a.model = b.model 
SET 
    a.fuel_type = b.fuel_type,
    a.mileage = b.mileage;

SELECT * FROM car;


-- problem on stored procedure:
-- get cars by total type

delimiter // 
create procedure get_car_fuel(
     in add_fuel_type varchar(30)
)
begin 
    select * from car
    where fuel_type=add_fuel_type;
end //
delimiter ;

call get_car_fuel('diesel');
-- -------------------------------------------------------------------------------------------------------

-- get average mileage by make
delimiter //
create procedure avg_mileage(
     in makes_  varchar(30),
     out average decimal(10,2)
     
)
begin 
     select avg(mileage)
     into average
     from car
     where make= makes_ ;
end //
delimiter ;
     
call avg_mileage('ferrari', @average);
select @average; 


-- group fuel type stats (count and average values)

delimiter //
create  procedure fuel_type_stats(
  in fuel_type_ varchar(30) ,
  out total_car int,
  out avg_value decimal(10,2)
)
begin
select count(*), avg(value)
into total_car , avg_value
from car
where fuel_type= fuel_type_;
end  //
delimiter ;

call fuel_type_stats('petrol',@total_car, @avg_value);
select @total_car, @avg_value;


  

-- get top 3 most fuel efficient cars (highesr mileage cars)