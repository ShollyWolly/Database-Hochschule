#Erstellen der Datenbank
Drop Database if exists Hochschule; 									#stellt sicher, dass die Datebank nicht bereits existiert.

CREATE DATABASE Hochschule;												#erstellt die Folgende Datenbank

Use Hochschule;															#gibt an, das die Datenbank "Hochschule" für die folgenden befehle genutzt wird.

Select "Bitte etwas geduld";											#einfach nur eine Ausgabe auf der Konsole

#Tabellen werden glelöscht sollten Sie bereits exestieren, um Felermeldungen zu vermeiden.
DROP TABLE IF EXISTS Fach;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Veranstaltung;
DROP TABLE IF EXISTS Dozenten;
DROP TABLE IF EXISTS Assistenten;
DROP TABLE IF EXISTS Prüfung;
DROP TABLE IF EXISTS Seminare;
DROP TABLE IF EXISTS Firmenwagen;
DROP TABLE IF EXISTS Model;
DROP TABLE IF EXISTS Tutorium;

#Anlegen der Tabllen

CREATE Table Fach (
	Fach_ID						integer primary key not null, 			#Primary key's sollten nicht null werden
	Fach_Bezichnung				Char(30) 								#Bezeichnung des Studiengangs
) ENGINE = InnoDB;

CREATE TABLE Student (
	MatrikelNr      			integer primary key not null, 			#Primary key's sollten nicht null werden
	Name          				char(30) not null, 						#einer MatrikelNr sollte immer ein Name zugewiesen sein.
	Fach_ID     				integer,
    Straße         				char(30),
    Hausnummer      			integer,
    Stadt						CHAR(30),
    Land						Char(30),
    PlZ							INTEGER,
    Constraint FK_Student_Fach FOREIGN KEY (Fach_ID) REFERENCES Fach(Fach_ID)
								ON DELETE NO ACTION ON UPDATE CASCADE	#sollte der Studiengang aus unerklärlichen Gründen gelöscht werden, sollte dies jedoch
) ENGINE = InnoDB;														#nicht solfort zur absoluten löschung führen. Sollte sich jedoch die bezeichnung des 
																		#studiengangs ändern sollte sich dies updaten.
CREATE TABLE Dozenten (
	Dozent_ID					integer primary key not null, 			#Primary key's sollten nicht null werden
    Name						Char(30),
    Lohn						integer,
	Straße         				char(30),
    Hausnummer      			integer,
    Stadt						CHAR(30),
    Land						Char(30),
    PlZ							INTEGER
) ENGINE = InnoDB;

CREATE TABLE Veranstaltung (
	Veranstaltung_ID			integer primary key not null, 			#Primary key's sollten nicht null werden
    Dozent_ID					integer,
    Veranstaltungsbezeichnung	Char(30),
    Constraint FK_Veranstaltung_Dozent FOREIGN KEY (Dozent_ID) REFERENCES Dozenten(Dozent_ID)
								ON DELETE set null ON UPDATE CASCADE	#sollte der Dozent die hochschule verlassen, muss das fach nicht unbedingt aufhören zu exestieren.
) ENGINE = InnoDB;


CREATE TABLE Assistenten (
	PersNr						integer primary key not null, 			#Primary key's sollten nicht null werden
    Name						Char(30),
    Dozent_ID					integer,
    Constraint FK_Assisten_Dozent FOREIGN KEY (Dozent_ID) REFERENCES Dozenten(Dozent_ID)
								ON DELETE CASCADE ON UPDATE CASCADE		#sollte der Dozent die Hochschule verlassen, wird auch sein Assisten nicht mehr von nöten sein.
) ENGINE = InnoDB;

CREATE TABLE Seminare (
	Seminar_ID					integer primary key not null, 			#Primary key's sollten nicht null werden
    Dozent_ID					integer,
    Bezeichnung					Char(30),
	Constraint FK_Seminar_Dozenten FOREIGN KEY (Dozent_ID) REFERENCES Dozenten(Dozent_ID)
								ON DELETE CASCADE ON UPDATE CASCADE		#sollte der Dozent die hochschule verlassen, muss das Seminar nicht unbedingt aufhören zu exestieren.
) ENGINE = InnoDB;

CREATE TABLE Prüfung (
	Prüfung_ID					integer primary key not null, 			#Primary key's sollten nicht null werden
    MatrikelNr					integer,
    Seminar_ID					integer,
    Dozent_ID					integer,
    Veranstaltung_ID			integer,
	Constraint FK_Prüfung_Dozenten FOREIGN KEY (Dozent_ID) REFERENCES Dozenten(Dozent_ID)
								ON DELETE NO ACTION ON UPDATE CASCADE,	#sollte der Dozent ausfallen, sollte die Prüfung nicht verschwinden.
	Constraint FK_Prüfung_Veranstaltung FOREIGN KEY (Veranstaltung_ID) REFERENCES Veranstaltung(Veranstaltung_ID)
								ON DELETE NO ACTION ON UPDATE CASCADE,	#sollte die Veranstaltung am Ende des Semesters nicht mehr existieren, sollte die Prüfung nicht verschwinden.
	Constraint FK_Prüfung_Student foreign key (MatrikelNr) references Student(MatrikelNr)
								on delete cascade on update cascade,	#ohne Student benötigt man auch keinen Prüfungseintrag
	Constraint FK_Prüfung_Seminare foreign key (Seminar_ID) references Seminare(Seminar_ID)
								on delete no action on update cascade	#sollte das Seminar am Ende des Semesters nicht mehr existieren, sollte die Prüfung nicht verschwinden.
) ENGINE = InnoDB;


CREATE TABLE Firmenwagen (
	Fahrzeug_ID					integer primary key not null, 			#Primary key's sollten nicht null werden
    Dozent_ID					integer,
	Constraint FK_Firmenwagen_Dozenten FOREIGN KEY (Dozent_ID) REFERENCES Dozenten(Dozent_ID)
								ON DELETE set null ON UPDATE CASCADE	#Wenn der Dozent die Hochschule verlässt, verschwindet das Fahrzeug nicht.
) ENGINE = InnoDB;

CREATE TABLE Model (
	Fahrzeug_ID				integer primary key not null, 				#Primary key's sollten nicht null werden
    Marke					Char(30),
    Model					Char(30),
    constraint FK_Model_Firmenwagen foreign key (Fahrzeug_ID) references Firmenwagen(Fahrzeug_ID)
								ON DELETE CASCADE ON UPDATE CASCADE		#sollte der Wagen nicht mehr existieren, so benötigt er auch keinen eintrag mehr in der Datenbank.
) ENGINE = InnoDB;

CReATE TABLE Tutorium (
	Bezeichnung				Char(30) primary key not null, 				#Primary key's sollten nicht null werden
    PersNr					integer,
    constraint FK_Tutorium_Assistenten FOREIGN KEY (PersNr) references Assistenten(PersNr)
								ON DELETE set null ON UPDATE CASCADE	#sollte der Assitent aufhören, so hört das Tutorium nicht unbedingt auf zu existieren.
) ENGINE = InnoDB;

#Füllung der Tabellen mit Inhalten

Insert into Fach
Values (1, "BWL");
Insert into Fach
Values (2, "Wirschaftsinformatik");
Insert into Fach
Values (3, "IB");

Insert Into Student
Values (111111, "Alexander Hilberer", 2, "Goesthestaße", 14, "Losheim am See", "Deutschland", 66679);
Insert Into Student
Values (111112, "Albert Einstein", 3, "Schlossberg", 33, "Trier", "Deutschland", 54295);
Insert Into Student
Values (111113, "I am bad at naming", 1, "Rosenstraße", 33, "Losheim am See", "Deutschland", 66679);

Insert Into Dozenten
Values (1, "Michael Schuhmacher", 666, "Moselstraße", 12, "Trier", "Deutschland", 54295);
Insert Into Dozenten
Values (2, "Niel Armstrong", 1000000, "Moselstraße", 15, "Trier", "Deutschland", 54295);
Insert Into Dozenten
Values (3, "Tim Raue", 666666, "Moselstraße", 22, "Trier", "Deutschland", 54295);

Insert Into Veranstaltung
Values (1, 2, "Raumfahrtkunde");
Insert Into Veranstaltung
Values (2, 3, "Kochen");
Insert Into Veranstaltung
Values (3, 1, "Fahrzeugkunde");

Insert Into Assistenten
Values (1, "Aki Akerman", 1);
Insert Into Assistenten
Values (2, "Oromis Glaeder", 1);
Insert Into Assistenten
Values (3, "Hannah Sundervar", 3);

Insert into Firmenwagen
Values (1, 3);
Insert into Firmenwagen
Values (2, 2);

Insert into Model
Values (1, "BMW", "X3");
Insert into Model
Values (2, "Audi", "A8");

Insert into Tutorium
Values ("Statistik", 1);
Insert into Tutorium
Values ("Mathematik", 2);

Insert into Seminare
Values (1, 1, "Datenbanken");
Insert into Seminare
Values (2, 2, "Raketenwissenschaften");
Insert into Seminare
Values (3, 3, "Kaffeekunde");

Insert into Prüfung
Values (1, 111111, null, 1, 2);
Insert into Prüfung
Values (2, 111111, 1, 3, null); 

# Sichten werden erstellt.
Create view Dozenten_Übersicht AS
select Dozenten.Name, Dozenten.Straße, Dozenten.Hausnummer, Dozenten.Stadt, Dozenten.Land, Dozenten.PlZ, Model.Model, Model.Marke
from Dozenten, Model, Firmenwagen
where Dozenten.Dozent_ID = Firmenwagen.Dozent_ID AND Firmenwagen.Fahrzeug_ID = Model.Fahrzeug_ID;
#Zeigt die Informationen über die Dozenten aus ohne Ihr gehalt zu zeigen und zeigt den jeweiligen Firmenwagen welchen sie fahren auf.


Create view Studentenübersicht AS
select Student.Name, Student.Land, Student.PlZ
from Student;
#Zeigt die Informationen über die Studierenden aus, ohne Ihre MatrikelNr zu veröffentlichen.

Commit;

Select "Fertig";


