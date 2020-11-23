Create Table Books
AS (Select *
    From WSProjectData
    WHERE Location = 'New York, NY');
    
Select *
From Books;

Alter Table Books Drop Column Location;
Alter Table Books Drop Column Current_Stock;
Alter Table Books Drop Column Number_Sold;
Alter Table Books ADD Primary Key(BookID);

Create Table Stores As
Select Location, BookID, Current_Stock,Number_Sold
From WSProjectData;

Alter Table Stores ADD Primary Key(Location,BookID);
Alter Table Stores ADD Foreign Key(BookID) References Books(BookID);


Select Author, Count (*)
From Books
Group by Author
Order by 2 Desc;

Select Genre, Count (*)
From Books
Group By Genre
Order by 2 Desc;

Select Avg(Price)
from Books;

Select Author, Sum (Number_Sold) AS Total_Number_Of_Books_Sold
from Books
Natural Join Stores
Group By Author
Order By 2 Desc;

Select Location, Sum(Revenue_Per_Book) AS Total_Revenue_Per_Store
From
(Select Location, Price,Number_Sold, (Number_Sold*Price)AS Revenue_Per_Book
from Books
Natural Join Stores)
Group By Location
Order By 2 Desc;





Create or Replace Function Book_Revenue (storeLocation VarChar2, book VarChar2)
Return Number
IS book_rev Number := 0;  
Begin
    Select Location, Title, Price, Number_Sold,(Number_Sold*Price) Into book_rev
    From Books Natural Join Stores
    Where Location = storeLocation and Title = book;
    Return book_rev;
End;
/


Create or Replace PROCEDURE ReStock (storeLocation VarChar2, book Number)
Begin
Select Location, BookID, Current_Stock
    From Books Natural Join Stores
    Where Location = storeLocation and BookID = book;
    IF (Current_Stock = 0)
    dbms_output.put_line('Need to Restock this book');
    End IF;
End;

Create Or Replace Trigger highPrice Before Update On Books For Each Row when (NEW.Price > 20)
Begin
dbms_output.put_line('Old Price: '  || :OLD.Price);        
dbms_output.put_line('New Price: ' || :NEW.Price );
dbms_output.put_line('This is a considerably more expensive book');
End;
/





