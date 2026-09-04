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
