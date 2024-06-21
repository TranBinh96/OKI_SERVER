create  database OKIPEVN;

use OKIPEVN;



CREATE TABLE Line (
    line_id INT PRIMARY KEY identity (1,1) ,
    line_name VARCHAR(255) NOT NULL,
    note TEXT,
    created_at DATETIME,
    updated_at DATETIME
);

CREATE TABLE Unit (
    unit_id INT PRIMARY KEY,
    unit_name VARCHAR(255) NOT NULL,
    line_id INT,
    note TEXT,
    created_at DATETIME,
    updated_at DATETIME,
   FOREIGN KEY (line_id) REFERENCES Line(line_id),
);

CREATE TABLE  NetworkRange(
    range_id INT PRIMARY KEY,
    range_name VARCHAR(255) NOT NULL,
    ip_address VARCHAR(15) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME,
    updated_at DATETIME
);

CREATE TABLE Computer (
    computer_id INT PRIMARY KEY identity (1,1),
    computer_name VARCHAR(255) NOT NULL,
    configuration TEXT,
    entry_date DATE,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME,
    updated_at DATETIME
);


CREATE TABLE  Monitor(
    monitor_id INT PRIMARY KEY identity (1,1),
    monitor_name VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME,
    updated_at DATETIME
);


CREATE TABLE LocationManagement (
    location_management_id INT PRIMARY KEY identity (1,1),
    unit_id INT,
	unit_name VARCHAR(255) NOT NULL,
    range_id INT,
    computer_id INT,
    monitor_id INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (unit_id) REFERENCES Unit(unit_id),
    FOREIGN KEY (range_id) REFERENCES NetworkRange(range_id),
    FOREIGN KEY (computer_id) REFERENCES Computer(computer_id),
    FOREIGN KEY (monitor_id) REFERENCES Monitor(monitor_id)

);

CREATE TABLE Warehouse (
    warehouse_id INT PRIMARY KEY identity (1,1),
    warehouse_name VARCHAR(255) NOT NULL,
    address TEXT,
    created_at DATETIME,
    updated_at DATETIME
);

CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY identity (1,1),
    item_name VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    entry_date DATE,
    exit_date DATE,
    status VARCHAR(20) NOT NULL,
    warehouse_id INT,
    created_at DATETIME,
    updated_at DATETIME,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)

);
CREATE TABLE Role (
    id INT PRIMARY KEY IDENTITY,
    name NVARCHAR(100) NOT NULL
);


CREATE TABLE Users (
    id INT PRIMARY KEY IDENTITY(1,1),
    fullname NVARCHAR(100),
    worker_code NVARCHAR(10) NOT NULL,
    address NVARCHAR(200),
    password NVARCHAR(200) NOT NULL,
    is_active BIT,
    role_id INT FOREIGN KEY REFERENCES Role(id)
);


