CREATE TABLE Master.NewDeliveries(
NewDeliveryID INT PRIMARY KEY IDENTITY (1,1),
ProductID INT NOT NULL, 
Price MONEY NOT NULL, 
NewDeliveryDate DATE NOT NULL 
);