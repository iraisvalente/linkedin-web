USE linkedin;

CREATE TABLE Users(
	Id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	First_Name varchar(255),
    Last_Name varchar(255),
    Email_Address varchar(255),
    Company varchar(255),
    Position varchar(255), 
    Password_user BLOB
);

CREATE TABLE Connections(
	First_Name varchar(255),
    Last_Name varchar(255),
    Email_Address varchar(255),
    Company varchar(255),
    Position varchar(255),
    Connection varchar(255)
);