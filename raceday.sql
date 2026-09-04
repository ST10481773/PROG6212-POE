CREATE DATABASE raceday
USE [raceday]

CREATE TABLE Roles (
    id INT IDENTITY(1,1) CONSTRAINT PK_Roles PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL CONSTRAINT UQ_Roles_Name UNIQUE
);

CREATE TABLE Users (
    id INT IDENTITY(1,1) CONSTRAINT PK_Users PRIMARY KEY,
    username VARCHAR(100) NOT NULL CONSTRAINT UQ_Users_Username UNIQUE,
    email VARCHAR(255) NOT NULL CONSTRAINT UQ_Users_Email UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    profile_picture_url VARCHAR(2048) NULL,
    created_at DATETIME NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (role_id) REFERENCES Roles(id) 
);

CREATE TABLE EventTypes (
    id INT IDENTITY(1,1) CONSTRAINT PK_EventTypes PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL CONSTRAINT UQ_EventTypes_Name UNIQUE
);

CREATE TABLE Events (
    id INT IDENTITY(1,1) CONSTRAINT PK_Events PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description NVARCHAR(MAX) NULL,
    date DATETIME NOT NULL,
    location VARCHAR(255) NOT NULL,
    distance DECIMAL(5,2) NOT NULL,
    event_type_id INT NOT NULL,
    banner_image_url VARCHAR(2048) NULL,
    organiser_id INT NOT NULL,
    created_at DATETIME NOT NULL CONSTRAINT DF_Events_CreatedAt DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Events_EventTypes FOREIGN KEY (event_type_id) REFERENCES EventTypes(id) ,
    CONSTRAINT FK_Events_Users FOREIGN KEY (organiser_id) REFERENCES Users(id) 
);

CREATE TABLE Categories (
    id INT IDENTITY(1,1) CONSTRAINT PK_Categories PRIMARY KEY,
    event_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    CONSTRAINT FK_Categories_Events FOREIGN KEY (event_id) REFERENCES Events(id) 
);

CREATE TABLE Enrolments (
    id INT IDENTITY(1,1) CONSTRAINT PK_Enrolments PRIMARY KEY,
    participant_id INT NOT NULL,
    event_id INT NOT NULL,
    category_id INT NOT NULL,
    enrolment_date DATETIME NOT NULL CONSTRAINT DF_Enrolments_Date DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL CONSTRAINT DF_Enrolments_Status DEFAULT 'Pending',
    CONSTRAINT FK_Enrolments_Users FOREIGN KEY (participant_id) REFERENCES Users(id) ,
    CONSTRAINT FK_Enrolments_Events FOREIGN KEY (event_id) REFERENCES Events(id) ,
    CONSTRAINT FK_Enrolments_Categories FOREIGN KEY (category_id) REFERENCES Categories(id) ,
    CONSTRAINT UQ_Enrolment_Participant_Event UNIQUE (participant_id, event_id)
);

CREATE TABLE Results (
    id INT IDENTITY(1,1) CONSTRAINT PK_Results PRIMARY KEY,
    enrolment_id INT NOT NULL CONSTRAINT UQ_Results_Enrolment UNIQUE,
    finish_time TIME NOT NULL,
    finishing_position INT NOT NULL,
    captured_at DATETIME NOT NULL CONSTRAINT DF_Results_CapturedAt DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (enrolment_id) REFERENCES Enrolments(id) 
);

INSERT INTO Roles (role_name) VALUES ('Organiser'), ('Participant');
INSERT INTO EventTypes (type_name) VALUES ('Run'), ('Walk'), ('Cycle');

INSERT INTO Users (username, email, password_hash, role_id, first_name, last_name, profile_picture_url)
VALUES 
('sipho_events', 'sipho.dube@raceday.co.za', 'AQAAAAIAAYagAAAAEJx...', 1, 'Sipho', 'Dube', 'https://racedaystorage.blob.core.windows.net/profiles/sipho.jpg'),
('sarah_runs', 'sarah.smith@raceday.co.za', 'AQAAAAIAAYagAAAAENm...', 1, 'Sarah', 'Smith', 'https://racedaystorage.blob.core.windows.net/profiles/sarah.jpg');

INSERT INTO Users (username, email, password_hash, role_id, first_name, last_name, profile_picture_url)
VALUES 
('piet_runner', 'piet.marais@gmail.com', 'AQAAAAIAAYagAAAAEPh...', 2, 'Piet', 'Marais', 'https://racedaystorage.blob.core.windows.net/profiles/piet.jpg'),
('lerato_cycles', 'lerato.mofokeng@yahoo.com', 'AQAAAAIAAYagAAAAERk...', 2, 'Lerato', 'Mofokeng', 'https://racedaystorage.blob.core.windows.net/profiles/lerato.jpg'),
('jabu_walks', 'jabu.nkosi@webmail.co.za', 'AQAAAAIAAYagAAAAETy...', 2, 'Jabu', 'Nkosi', NULL),
('charlotte_v', 'charlotte.vanwyk@outlook.com', 'AQAAAAIAAYagAAAAEYu...', 2, 'Charlotte', 'Van Wyk', NULL);


INSERT INTO Events (name, description, date, location, distance, event_type_id, banner_image_url, organiser_id)
VALUES 
('Soweto Half Marathon', 'A road running event through the historical streets of Soweto, celebrating community spirit.', '2026-11-01 06:00:00', 'Soweto, Johannesburg', 21.10, 1, 'https://racedaystorage.blob.core.windows.net/banners/soweto-half.jpg', 1);

INSERT INTO Events (name, description, date, location, distance, event_type_id, banner_image_url, organiser_id)
VALUES 
('West Coast Cycling Classic', 'A scenic road cycling race starting in Melkbosstrand and heading along the West Coast road.', '2026-10-18 07:00:00', 'Melkbosstrand, Cape Town', 109.00, 3, 'https://racedaystorage.blob.core.windows.net/banners/west-coast-classic.jpg', 2);

INSERT INTO Events (name, description, date, location, distance, event_type_id, banner_image_url, organiser_id)
VALUES 
('Durban Beachfront Charity Walk', 'A family walk along the Durban Golden Mile beachfront promenade to raise funds for local animal shelters.', '2026-09-27 08:30:00', 'Durban Beachfront', 5.00, 2, 'https://racedaystorage.blob.core.windows.net/banners/durban-beachfront-walk.jpg', 1);

INSERT INTO Categories (event_id, name, description)
VALUES 
(1, 'Open Male', 'Male runners of any age group'),
(1, 'Open Female', 'Female runners of any age group'),
(1, 'Veterans 40+', 'Runners aged 40 years and older');

INSERT INTO Categories (event_id, name, description)
VALUES 
(2, 'Elite Men', 'Professional and licensed elite male cyclists'),
(2, 'Elite Women', 'Professional and licensed elite female cyclists'),
(2, 'Sub-Veterans 30-39', 'Cyclists aged 30 to 39 years');

INSERT INTO Categories (event_id, name, description)
VALUES 
(3, 'Adult Walkers', 'Participants aged 13 and older'),
(3, 'Kids & Seniors', 'Participants under 12 or over 65');

-- Soweto Half Marathon Enrolments
INSERT INTO Enrolments (participant_id, event_id, category_id, enrolment_date, status)
VALUES 
(3, 1, 1, '2026-09-01 10:14:22', 'Confirmed'), -- Piet
(6, 1, 2, '2026-09-02 14:45:10', 'Confirmed'); -- Charlotte

-- West Coast Cycling Classic Enrolment
INSERT INTO Enrolments (participant_id, event_id, category_id, enrolment_date, status)
VALUES 
(4, 2, 5, '2026-09-03 09:30:00', 'Confirmed'); -- Lerato

-- Durban Beachfront Charity Walk Enrolment
INSERT INTO Enrolments (participant_id, event_id, category_id, enrolment_date, status)
VALUES 
(5, 3, 7, '2026-09-04 11:20:00', 'Pending'); -- Jabu

-- Soweto Half Marathon Results
INSERT INTO Results (enrolment_id, finish_time, finishing_position)
VALUES 
(1, '01:24:45', 12), -- Piet
(2, '01:42:15', 38); -- Charlotte

-- West Coast Cycling Classic Results
INSERT INTO Results (enrolment_id, finish_time, finishing_position)
VALUES 
(3, '02:58:30', 3); -- Lerato

