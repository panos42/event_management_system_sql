CREATE TABLE Physical_Address (
	City 		VARCHAR(20),
	Address		VARCHAR(20),
	Postcode 	INTEGER NOT NULL,
	PRIMARY KEY (Postcode) 
);

CREATE TABLE Event (
	Description	CHAR(30),
	Date 		DATE,
	Time 		TIME,
	Attendees 	INTEGER,
	Name 		CHAR(30) NOT NULL,
	Postcode 	INTEGER,
	PRIMARY KEY (Name),
	FOREIGN KEY (Postcode)
		REFERENCES Physical_Address(Postcode)
		ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Host (
	Phone_number 	CHAR(10),
	First_name		CHAR(20),
	Last_name		CHAR(20),
	Company_Name 	CHAR(20),
	Email 			CHAR(30) NOT NULL,
	Event_name 		CHAR(30),
	Postcode 		INTEGER,
	PRIMARY KEY (Email),
	FOREIGN KEY (Event_name)
		REFERENCES Event(Name)
		ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (Postcode)
		REFERENCES Physical_Address(Postcode) 
		ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Payment_List (
	Phone_number 	CHAR(10),
	Email			CHAR(30),
	Payment_Info	CHAR(50) NOT NULL,
	Event_name 		CHAR(30),
	PRIMARY KEY (Payment_Info),
	FOREIGN KEY (Event_name)
		REFERENCES Event(Name)
		ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Attendee (
	First_name	CHAR(20),
	Last_name	CHAR(20),
	City		CHAR(30),
	Age			INTEGER,
	Attendee_ID	INTEGER	NOT NULL,
	Payment_Info CHAR(50),
	PRIMARY KEY (Attendee_ID, Payment_Info),
	FOREIGN KEY (Payment_Info)
		REFERENCES Payment_List(Payment_Info)
		ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Permissions (
	Licenses	CHAR(30),
	Event_Name	CHAR(30),
	PRIMARY KEY (Event_Name, Licenses),
	FOREIGN KEY (Event_Name)
		REFERENCES Event(Name)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Building (
	Building_ID INTEGER NOT NULL,
	Event_Name		CHAR(30),
	PRIMARY KEY (Building_ID, Event_Name),
	FOREIGN KEY (Event_Name)
		REFERENCES Event(Name)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Room (
	Availability	BOOLEAN,
	Capacity		INTEGER,
	Name			CHAR(20),
	Room_ID			INTEGER	NOT NULL,
	Building_ID 	INTEGER ,
	Event_Name		CHAR(30),
	PRIMARY KEY (Room_ID, Building_ID, Event_Name),
	FOREIGN KEY (Building_ID)
		REFERENCES Building(Building_ID)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Event_Name)
		REFERENCES Building(Event_Name)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Jobs (
	Job			CHAR(20) NOT NULL,
	Fee			INTEGER,
	Event_name	CHAR(30),
	PRIMARY KEY (Job, Event_name),
	FOREIGN KEY (Event_name)
		REFERENCES Event(Name)
		ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Employees (
	First_name	CHAR(20),
	Last_name	CHAR(20),
	Employee_ID INTEGER NOT NULL,
	Job 		CHAR(20),
	Event_Name	CHAR(30),
	PRIMARY KEY (Employee_ID, Event_Name),
	FOREIGN KEY (Event_Name)
		REFERENCES Event(Name)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Job, Event_Name)
		REFERENCES Jobs(Job, Event_Name)
		ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Sponsorships (
	Sponsor_Name	VARCHAR(50) NOT NULL,
	Donation_Amount	INTEGER,
	Event_name		CHAR(30),
	PRIMARY KEY (Sponsor_Name, Event_name),
	FOREIGN KEY (Event_name)
		REFERENCES Event(Name)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Exchange (
	Type			CHAR(30) NOT NULL,
	Amount			INTEGER,
	Event_name 		CHAR(20),
	PRIMARY KEY (Type, Event_name),
	FOREIGN KEY (Event_name)
		REFERENCES Event(Name)
		ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Schedule_Dates (
	Schedule_Date 	DATE NOT NULL,
	Event_name		CHAR(30),
	PRIMARY KEY (Schedule_Date, Event_name),
	FOREIGN KEY (Event_name)
		REFERENCES Event(Name)
		ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Activity (
	Type 		CHAR(20),
	Type_ID 	INTEGER NOT NULL,
	Event_name	CHAR(30),
	PRIMARY KEY (Type_ID, Event_name),
	FOREIGN KEY (Event_name)
		REFERENCES Event(Name)
		ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Schedule_Program (
	Time_start		TIME NOT NULL,
	Time_end		TIME,
	Capacity		INTEGER,
	Program_Date 	DATE,
	Room_ID 		INTEGER NOT NULL,
	Building_ID 	INTEGER NOT NULL,
	Program_host 	INTEGER,
	Type_ID 		INTEGER,
	Event_name		CHAR(30),
	PRIMARY KEY (Room_ID, Building_ID, Event_name, Time_start),
	FOREIGN KEY (Program_Date, Event_name)
		REFERENCES Schedule_Dates(Schedule_Date, Event_name)
		ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Room_ID, Building_ID, Event_Name)
		REFERENCES Room(Room_ID, Building_ID, Event_Name)
		ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (Program_host, Event_name)
		REFERENCES Employees(Employee_ID, Event_name)
		ON DELETE SET NULL ON UPDATE CASCADE,
	FOREIGN KEY (Type_ID, Event_name)
		REFERENCES Activity(Type_ID, Event_name)
		ON DELETE SET NULL ON UPDATE CASCADE
);