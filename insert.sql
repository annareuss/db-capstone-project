-- ==============================================================================
-- insert statements
-- populate the tables with data
-- ==============================================================================
insert into staff (StaffID, FullName, PhoneNr, Role, Salary) values 
(0,'Bill Gates','01234567','waiter',1200),
(0,'Diana Ross','15644409','singer',5000),
(0,'George Hamilton','91562368','accountant',2500);
select * from staff;


insert into menuitems (MenuitemID, Starter, Course, Desert) values 
(0,'Pumpkin soup','Rucola salad','Fruit yogurt'),
(0,'Bacon and egg','Steak','Apple pie'),
(0,'Cucumber','Rice','Icecream'),
(0,'Musaka','Feta cheese','Vanile pudding'),
(0,'Italian soup','Italian pizza','Italian Cake');
select * from menuitems;

INSERT INTO menu (MenuName, Cuisine, MenuitemID, Price) VALUES 
('French menu', 'French', '1', '12.0'),
('Energy menu', 'American', '2', '20.0'),
('Slim menu', 'International', '3', '15.0'),
('Greek menu', 'Greek', '4', '11.0'),
('Pizza menu', 'Italian', '5', '18.0');
select * from menu;

select * from customers;
insert into customers values (0,'Tina Turner','221245671','tinaturner@gmail.com');
insert into customers values (0,'Michio Kaku','88644409','mkaku@gmail.com');
insert into customers values (0,'Kevin Mitnick','99562368','kmitnick@gmail.com');
select * from customers;

-- another way to insert into the customers table
insert into customers (CustomerID, FullName, PhoneNr, Email) values 
(0,'Tina Turner','221245671','tinaturner@gmail.com'),
(0,'Michio Kaku',88644409,'mkaku@gmail.com'),
(0,'Kevin Mitnick',99562368,'kmitnick@gmail.com');
select * from customers;

insert into orders (OrderID, OrderDate, MenuID, Quantity, TotalPrice, StaffID, CustomerID) values 
(0,'2023-09-01',1,2,24.0,1,1),
(0,'2023-09-02',2,1,20.0,2,2),
(0,'2023-09-03',3,5,45.0,3,1),
(0,'2023-09-05',4,2,22.0,1,2),
(0,'2023-09-08',5,1,18.0,2,3),
(0,'2023-09-19',2,10,200.0,1,2),
(0,'2023-09-19',4,9,198.0,2,3);
select * from orders;

-- insert one more row into the Orders table, to have a big TotalPrice amount
insert into orders (OrderID, OrderDate, MenuID, Quantity, TotalPrice, StaffID, CustomerID) values 
(0,'2023-09-20',1,30,2400.0,2,2);

insert into delivery(DeliveryID, DeliveryDate, DeliveryStatus, OrderID) values 
(0,'2023-09-02','delivered',1),
(0,'2023-09-02','in_progress',2),
(0,'2023-09-03','delivered',3),
(0,'2023-09-05','in_progress',4),
(0,'2023-09-08','delivered',5);
select * from delivery;


insert into bookings (BookingID, BookingDate, BookingTime, TableNr, CustomerID, StaffID) values
(0,'2023-09-05','18:00',3,1,2),
(0,'2023-09-05','19:00',5,2,2),
(0,'2023-09-06','12:00',3,3,1),
(0,'2023-09-08','17:00',9,1,3),
(0,'2023-09-15','16:00',3,2,2);
select * from bookings;

select * from bookings order by BookingID;

-- ===============================================
-- insert Bookings table rows for Capstone task
-- for a Capstone project task, the rows have to be replaced by a given set of rows
-- delete the rows from the table, then add the following rows
-- ===============================================
-- delete from bookings;
-- insert into bookings (BookingID, BookingDate, BookingTime, TableNr, CustomerID, StaffID) values
-- (0,'2022-10-10','18:00',5,1,2),
-- (0,'2022-11-12','19:00',3,3,2),
-- (0,'2022-10-11','12:00',2,2,1),
-- (0,'2022-10-13','17:00',2,1,3);


-- ==============================================================================
-- drop tables 
-- run in case the ER diagram or the tables have to be re-created
-- ==============================================================================
-- use littlelemon;
-- drop table bookings;
-- drop table delivery;
-- drop table orders;
-- drop table menu;
-- drop table menuitems;
-- drop table staff;
-- drop table customers;
