-- ==============================================================================
-- SHOW DATABASES
-- ==============================================================================
SHOW DATABASES;

-- ==============================================================================
-- ANY
-- ==============================================================================
select MenuName from menu where MenuID = ANY (select MenuID from orders where Quantity > 2) order by MenuName;

-- ==============================================================================
-- JOIN
-- ==============================================================================
select Customers.CustomerID, FullName, OrderID, TotalPrice, MenuName, Starter, Course from Customers 
join Orders on Customers.CustomerID=Orders.CustomerID
join menu on menu.MenuID=orders.MenuID
join menuitems on menuitems.MenuitemID=menu.MenuitemID;


-- ==============================================================================
-- OrdersView
-- ==============================================================================
create view OrdersView AS (select OrderID, Quantity, TotalPrice from orders where quantity>2) order by OrderID;
select * from OrdersView;


-- ==============================================================================
-- CheckBooking
-- ==============================================================================
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



-- ==============================================================================
-- AddValidBooking
-- ==============================================================================
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



-- ==============================================================================
-- GetMaxQuantity
-- ==============================================================================
create procedure GetMaxQuantity()
select max(Quantity) from orders;

call GetMaxQuantity();



-- ==============================================================================
-- GetOrderDetail
-- ==============================================================================
PREPARE GetOrderDetail FROM 'SELECT OrderID, Quantity, TotalPrice FROM Orders WHERE CustomerID = ?';
set @id=2;
execute GetOrderDetail using @id;

-- ==============================================================================
-- GetBookingDetails
-- ==============================================================================
PREPARE GetBookingDetails FROM 'SELECT BookingID, BookingDate, BookingTime, TableNr, CustomerID, StaffID FROM Bookings WHERE BookingID = ?';
set @id=40;
execute GetBookingDetails using @id;



-- ==============================================================================
-- create Audit table and a DELETE trigger, which will log the deletions into the Audit table
-- ==============================================================================
CREATE TABLE Audit (
  Confirmation VARCHAR(100) NOT NULL,
  Date DATE NOT NULL);

CREATE TRIGGER AfterDeleteOrder AFTER DELETE ON Orders FOR EACH ROW 
INSERT INTO Audit VALUES (CONCAT('Order ',OLD.OrderID,' is cancelled'),CURRENT_DATE());

select * from audit;
select * from orders;

-- ==============================================================================
-- CancelOrder
-- ==============================================================================
DELIMITER //

CREATE PROCEDURE CancelOrder(OrderIDinput INT)
begin 
delete from orders where OrderID=OrderIDinput;
select * from audit; 
end//

DELIMITER ;

call CancelOrder(3);

-- drop procedure CancelOrder;

-- ==============================================================================
-- AddBooking
-- ==============================================================================
DELIMITER //

CREATE Procedure AddBooking(BookingID_input INT, BookingDate_input DATE, TableNr_input INT, CustomerID_input INT)
	BEGIN 
        DECLARE Booking_status VARCHAR(80); 
        DECLARE TableCheck INT; 
-- variable to store the new BookingID, this will be used for successful booking
-- this is needed because the BookingID is defined as auto-increment
        DECLARE BookingID_next INT;
-- variable to store the existing BookingID, this will be used for unsuccessful booking
        DECLARE BookingID_existing INT;
        select BookingID into BookingID_existing from Bookings 
			where TableNr=TableNr_input 
			  and BookingDate=BookingDate_input 
              and CustomerID=CustomerID_input;
        select max(BookingID)+1 into BookingID_next from Bookings;
-- check if there is an existing booking with the provided parameters, 
-- save the record count into TableCheck variable
        select count(*) into TableCheck from Bookings 
				where TableNr=TableNr_input 
                  and BookingDate=BookingDate_input 
                  and CustomerID=CustomerID_input;
-- 	    SELECT "New booking added" AS "Confirmation";
-- the message is based on the value of the TableCheck variable:
-- if TableCheck variable = 0
-- it means we do not have this row in the table
-- in this case the new row will be inserted, and a success message will be shown
		IF TableCheck=0 THEN SET Booking_status=concat('New booking with BookingID ',BookingID_next,' is added') ;
        	insert into bookings (BookingID, BookingDate, BookingTime, TableNr, CustomerID, StaffID) 
			values (0,BookingDate_input,"15:00",TableNr_input,CustomerID_input,2);
		COMMIT;
-- else: TableCheck parameter is > 0 
-- it means that the provided parameters identify an existing Booking 
-- the BookingID is stored in BookingID_existing variable
-- in this case there is no insertion but we show a cancellation message
-- including BookingID and some identifiers from the existing row
-- so that we can see if it works correctly
		ELSE SET Booking_status=concat('Booking already exists for ',BookingDate_input,' ',TableNr_input,' ',CustomerID_input,' with BookingID ',BookingID_existing,', booking cancelled') ;
        ROLLBACK;
		END IF;
        SELECT Booking_status;  
        END//

DELIMITER ; 

CALL AddBooking(0,'2022-12-12',15,2);
CALL AddBooking(0,'2023-01-16',17,2);
CALL AddBooking(0,'2023-01-11',17,2);

-- drop procedure AddBooking;

-- ==============================================================================
-- create Bookings_Audit table --- for logging the output of the triggers
-- ==============================================================================
CREATE TABLE Bookings_Audit (
  Confirmation VARCHAR(100) NOT NULL,
  MessageDate DATE NOT NULL,
  MessageTime TIME NOT NULL);

select * from Bookings_Audit;

-- ==============================================================================
-- create triggers which will log into the Bookings_Audit table
-- ==============================================================================
CREATE TRIGGER AfterDeleteBooking AFTER DELETE ON Bookings FOR EACH ROW 
INSERT INTO Bookings_Audit VALUES (CONCAT('BookingID ',OLD.BookingID,' is deleted'),CURRENT_DATE(),CURRENT_TIME());

CREATE TRIGGER AfterInsertBooking AFTER INSERT ON Bookings FOR EACH ROW 
INSERT INTO Bookings_Audit VALUES (CONCAT('BookingID ',NEW.BookingID,' is created'),CURRENT_DATE(),CURRENT_TIME());

CREATE TRIGGER AfterUpdateBooking AFTER UPDATE ON Bookings FOR EACH ROW 
INSERT INTO Bookings_Audit VALUES (CONCAT('BookingID ',NEW.BookingID,' is updated'),CURRENT_DATE(),CURRENT_TIME());

-- drop trigger AfterDeleteBooking;
-- drop trigger AfterInsertBooking;
-- drop trigger AfterUpdateBooking;


-- ==============================================================================
-- UpdateBooking
-- ==============================================================================
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

CALL UpdateBooking(16,"2023-01-28");
CALL UpdateBooking(17,"2023-01-22");
CALL UpdateBooking(15,"2023-01-01");
CALL UpdateBooking(40,"2023-02-02");

-- drop procedure UpdateBooking;

-- test
select * from Bookings order by BookingID;

-- Bookings table: find possible parameters for the UpdateBooking and CancelBooking procedures
select BookingID, BookingDate, TableNr, CustomerID from bookings order by BookingID;

-- check the Max BookingID 
select max(BookingID) from bookings;



-- ==============================================================================
-- CancelBooking
-- ==============================================================================
DELIMITER //

CREATE Procedure CancelBooking(BookingID_input INT)
	BEGIN 
        DECLARE Booking_status VARCHAR(80); 
        DECLARE TableCheck INT; 
        select count(*) into TableCheck from Bookings where BookingID=BookingID_input;
        delete from Bookings where BookingID=BookingID_input;
        IF TableCheck=1 THEN SET Booking_status=concat('BookingID ',BookingID_input,' cancelled') ;
		COMMIT;
		ELSE SET Booking_status=concat('BookingID ',BookingID_input,' not found, cancellation failed') ;
        ROLLBACK;
		END IF;
        SELECT Booking_status;  
        END//

DELIMITER ; 

CALL CancelBooking(15);

-- drop procedure CancelBooking;





-- ==============================================================================
-- comment out/in a line in MySQL Workbench: Ctrl +/
-- ==============================================================================
