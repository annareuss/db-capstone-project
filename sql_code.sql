create view OrdersView AS (select OrderID, Quantity, TotalPrice from orders where quantity>2) order by OrderID;
select * from OrdersView;



insert into bookings (BookingID, BookingDate, BookingTime, TableNr, CustomerID, StaffID) values
(0,'2022-10-10','18:00',5,1,2),
(0,'2022-11-12','19:00',3,3,2),
(0,'2022-10-11','12:00',2,2,1),
(0,'2022-10-13','17:00',2,1,3);

select BookingID, BookingDate, TableNr, CustomerID from bookings;


DELIMITER // 
CREATE Procedure CheckBooking(BookingDate_input DATE, TableNr_input INT) 
     BEGIN 
        DECLARE Booking_status VARCHAR(80); 
        DECLARE TableCheck INT; 
        select count(*) into TableCheck from Bookings where TableNr=TableNr_input and BookingDate=BookingDate_input;
        IF TableCheck=1 THEN SET Booking_status=concat('Table ',TableNr_input,' is already booked') ;
        ELSE SET Booking_status=concat('Table ',TableNr_input,' is free') ; 
        END IF;
    SELECT Booking_status;  END//
DELIMITER ; 
CALL CheckBooking("2022-11-12",3);
CALL CheckBooking("2022-11-12",4);



DELIMITER //

CREATE Procedure AddValidBooking(BookingDate_input DATE, TableNr_input INT) 
	BEGIN 
        DECLARE Booking_status VARCHAR(80); 
        DECLARE TableCheck INT; 
        select count(*) into TableCheck from Bookings where TableNr=TableNr_input and BookingDate=BookingDate_input;
		IF TableCheck=0 THEN SET Booking_status=concat('Table ',TableNr_input,' is successfully booked') ;
        	insert into bookings (BookingID, BookingDate, BookingTime, TableNr, CustomerID, StaffID) 
			values (0,BookingDate_input,'18:00',TableNr_input,1,2);
		COMMIT;
		ELSE SET Booking_status=concat('Table ',TableNr_input,' is already booked - booking cancelled') ;
        ROLLBACK;
		END IF;
        SELECT Booking_status;  
        END//

DELIMITER ; 

CALL AddValidBooking("2022-11-12",25);




create procedure GetMaxQuantity()
select max(Quantity) from orders;

call GetMaxQuantity();



PREPARE GetOrderDetail FROM 'SELECT OrderID, Quantity, TotalPrice FROM Orders WHERE CustomerID = ?';
set @id=1;
execute GetOrderDetail using @id;




CREATE TABLE Audit (
  Confirmation VARCHAR(100) NOT NULL,
  Date DATE NOT NULL);

CREATE TRIGGER AfterDeleteOrder AFTER DELETE ON Orders FOR EACH ROW 
INSERT INTO Audit VALUES (CONCAT('Order ',OLD.OrderID,' is cancelled'),CURRENT_DATE());

delimiter //
CREATE PROCEDURE CancelOrder(OrderIDinput INT)
begin 
delete from orders where OrderID=OrderIDinput;
select * from audit; end//

call CancelOrder(8);



DELIMITER //

CREATE Procedure AddBooking(BookingID_input INT, BookingDate_input DATE, TableNr_input INT, CustomerID_input INT)
	BEGIN 
        DECLARE Booking_status VARCHAR(80); 
        DECLARE TableCheck INT; 
        DECLARE BookingID_next INT;
        select max(BookingID)+1 into BookingID_next from Bookings;
        select count(*) into TableCheck from Bookings 
				where TableNr=TableNr_input and BookingDate=BookingDate_input and CustomerID=CustomerID_input;
		IF TableCheck=0 THEN SET Booking_status=concat('New booking with BookingID ',BookingID_next,' is added') ;
        	insert into bookings (BookingID, BookingDate, BookingTime, TableNr, CustomerID, StaffID) 
			values (0,BookingDate_input,"14:00",TableNr_input,CustomerID_input,2);
		COMMIT;
		ELSE SET Booking_status=concat('BookingID ',BookingID_next,' is already exist - booking cancelled') ;
        ROLLBACK;
		END IF;
        SELECT Booking_status;  
        END//

DELIMITER ; 

CALL AddBooking(0,"2022-12-31",19,2);
CALL AddBooking(0,'2023-01-16',10,2);



CREATE TABLE Bookings_Audit (
  Confirmation VARCHAR(100) NOT NULL,
  MessageDate DATE NOT NULL,
  MessageTime TIME NOT NULL);

CREATE TRIGGER AfterDeleteBooking AFTER DELETE ON Bookings FOR EACH ROW 
INSERT INTO Audit VALUES (CONCAT('BookingID ',OLD.BookingID,' is deleted'),CURRENT_DATE(),CURRENT_TIME());

CREATE TRIGGER AfterInsertBooking AFTER INSERT ON Bookings FOR EACH ROW 
INSERT INTO Audit VALUES (CONCAT('BookingID ',NEW.BookingID,' is created'),CURRENT_DATE(),CURRENT_TIME());

CREATE TRIGGER AfterUpdateBooking AFTER UPDATE ON Bookings FOR EACH ROW 
INSERT INTO Audit VALUES (CONCAT('BookingID ',NEW.BookingID,' is updated'),CURRENT_DATE(),CURRENT_TIME());



DELIMITER //

CREATE Procedure UpdateBooking(BookingID_input INT,BookingDate_input DATE)
	BEGIN 
        DECLARE Booking_status VARCHAR(80); 
        DECLARE TableCheck INT; 
        update Bookings set BookingDate=BookingDate_input where BookingID=BookingID_input;
        select count(*) into TableCheck from Bookings 
				where BookingDate=BookingDate_input and BookingID=BookingID_input;
		IF TableCheck=1 THEN SET Booking_status=concat('BookingID ',BookingID_input,' is updated') ;
		COMMIT;
		ELSE SET Booking_status=concat('BookingID ',BookingID_input,' update is failed') ;
        ROLLBACK;
		END IF;
        SELECT Booking_status;  
        END//

DELIMITER ; 

CALL UpdateBooking(16,"2023-01-22");
CALL UpdateBooking(17,"2023-01-22");



DELIMITER //

CREATE Procedure CancelBooking(BookingID_input INT)
	BEGIN 
        DECLARE Booking_status VARCHAR(80); 
        DECLARE TableCheck INT; 
        delete from Bookings where BookingID=BookingID_input;
        select count(*) into TableCheck from Bookings where BookingID=BookingID_input;
		IF TableCheck=0 THEN SET Booking_status=concat('BookingID ',BookingID_input,' cancelled') ;
		COMMIT;
		ELSE SET Booking_status=concat('BookingID ',BookingID_input,' cancellation failed') ;
        ROLLBACK;
		END IF;
        SELECT Booking_status;  
        END//

DELIMITER ; 

CALL CancelBooking(17);





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


insert into bookings (BookingID, BookingDate, BookingTime, TableNr, CustomerID, StaffID) values
(0,'2022-10-10','18:00',5,1,2),
(0,'2022-11-12','19:00',3,3,2),
(0,'2022-10-11','12:00',2,2,1),
(0,'2022-10-13','17:00',2,1,3);

