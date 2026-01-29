-- Create a new database
CREATE DATABASE QLY_NHANSU;
GO

-- Use the database
USE QLY_NHANSU;
GO

-- Create PHONG_BAN (Department) table
CREATE TABLE PHONG_BAN
(
    MA_PB CHAR(5) NOT NULL,
    -- Department ID
    TEN_PB NVARCHAR(50) NOT NULL,
    -- Department name
    MA_TRUONGPHONG CHAR(5)
    -- Manager ID
);

-- Create NHAN_VIEN (Employee) table
CREATE TABLE NHAN_VIEN
(
    ID_NHANVIEN CHAR(5) NOT NULL,
    -- Employee ID
    HO_NV NVARCHAR(30),
    -- Last name
    TEN_NV NVARCHAR(30) NOT NULL,
    -- First name
    NAM_SINH SMALLINT,
    -- Birth year
    DIA_CHI NVARCHAR(100),
    -- Address
    GIOI_TINH CHAR(1) NOT NULL,
    -- Gender
    LUONG DECIMAL(12,2),
    -- Salary
    PHG CHAR(5) NOT NULL,
    -- Department ID
    EMAIL VARCHAR(100),
    -- Email
    DIENTHOAI VARCHAR(15)
    -- Phone
);

-- Create DU_AN (Project) table
CREATE TABLE DU_AN
(
    MA_DUAN CHAR(5) NOT NULL,
    -- Project ID
    TEN_DUAN NVARCHAR(50) NOT NULL,
    -- Project name
    NGAY_BAT_DAU DATE NOT NULL,
    -- Start date
    NGAY_KET_THUC DATE NOT NULL,
    -- End date
    THONG_TIN_KHACH_HANG NVARCHAR(MAX)
    -- Customer info
);

-- Create QUANLY_DUAN (Project Assignment) table
CREATE TABLE QUANLY_DUAN
(
    MA_DUAN CHAR(5) NOT NULL,
    -- Project ID
    MA_NHANVIEN CHAR(5) NOT NULL,
    -- Employee ID
    NGAY_THAM_GIA DATE NOT NULL,
    -- Join date
    NGAY_KET_THUC DATE NOT NULL,
    -- Leave date
    SO_GIO INT,
    -- Working hours
    CHUC_VU NVARCHAR(30) NOT NULL
    -- Role
);

-- Add Primary Key to PHONG_BAN
ALTER TABLE PHONG_BAN
ADD CONSTRAINT PK_PHONG_BAN
PRIMARY KEY (MA_PB);

-- Add Primary Key to NHAN_VIEN
ALTER TABLE NHAN_VIEN
ADD CONSTRAINT PK_NHAN_VIEN
PRIMARY KEY (ID_NHANVIEN);

-- Add Primary Key to DU_AN
ALTER TABLE DU_AN
ADD CONSTRAINT PK_DU_AN
PRIMARY KEY (MA_DUAN);

-- Add Composite Primary Key to QUANLY_DUAN
ALTER TABLE QUANLY_DUAN
ADD CONSTRAINT PK_QUANLY_DUAN
PRIMARY KEY (MA_DUAN, MA_NHANVIEN);
-- Employee belongs to a department
ALTER TABLE NHAN_VIEN
ADD CONSTRAINT FK_NV_PB
FOREIGN KEY (PHG) REFERENCES PHONG_BAN(MA_PB);

-- Assignment references employee
ALTER TABLE QUANLY_DUAN
ADD CONSTRAINT FK_QLDA_NV
FOREIGN KEY (MA_NHANVIEN) REFERENCES NHAN_VIEN(ID_NHANVIEN);

-- Assignment references project
ALTER TABLE QUANLY_DUAN
ADD CONSTRAINT FK_QLDA_DA
FOREIGN KEY (MA_DUAN) REFERENCES DU_AN(MA_DUAN);

-- Gender validation
ALTER TABLE NHAN_VIEN
ADD CONSTRAINT CHK_GIOI_TINH
CHECK (GIOI_TINH IN ('M','F'));

-- Working hours must be positive
ALTER TABLE QUANLY_DUAN
ADD CONSTRAINT CHK_SO_GIO
CHECK (SO_GIO >= 0);

-- Email must be unique
ALTER TABLE NHAN_VIEN
ADD CONSTRAINT UQ_NV_EMAIL
UNIQUE (EMAIL);

-- Insert departments
INSERT INTO PHONG_BAN
VALUES
    ('PB001', N'CNTT', 'NV001'),
    ('PB002', N'Kế toán', 'NV002'),
    ('PB003', N'Nhân sự', 'NV003');

-- Insert employees
INSERT INTO NHAN_VIEN
VALUES
    ('NV001', 'Nguyen', 'An', 1995, N'Hà Nội', 'M', 15000000, 'PB001', 'an@gmail.com', '0901'),
    ('NV002', 'Tran', 'Binh', 1990, N'HCM', 'M', 18000000, 'PB002', 'binh@gmail.com', '0902'),
    ('NV003', 'Le', 'Hoa', 1998, N'Đà Nẵng', 'F', 14000000, 'PB003', 'hoa@gmail.com', '0903'),
    ('NV004', 'Pham', 'Minh', 1997, N'Hà Nội', 'M', 16000000, 'PB001', 'minh@gmail.com', '0904');

-- Insert projects
INSERT INTO DU_AN
VALUES
    ('DA001', N'QLNS', '2024-01-01', '2024-06-30', NULL),
    ('DA002', N'Website', '2024-02-01', '2024-08-31', NULL);

-- Insert project assignments
INSERT INTO QUANLY_DUAN
VALUES
    ('DA001', 'NV001', '2024-01-01', '2024-06-30', 300, N'Lập trình'),
    ('DA001', 'NV003', '2024-02-01', '2024-06-30', 200, N'Kiểm thử'),
    ('DA002', 'NV002', '2024-02-01', '2024-08-31', 350, N'Quản lý');

-- Salary sum per department
SELECT PHG, SUM(LUONG) AS TONG_LUONG
FROM NHAN_VIEN
GROUP BY PHG;

-- Count employees per project
SELECT MA_DUAN, COUNT(MA_NHANVIEN) AS SO_NHANVIEN
FROM QUANLY_DUAN
GROUP BY MA_DUAN;

-- Project with most working hours
SELECT TOP 1
    MA_DUAN, SUM(SO_GIO) AS TONG_GIO
FROM QUANLY_DUAN
GROUP BY MA_DUAN
ORDER BY SUM(SO_GIO) DESC;

-- Employee with max salary
SELECT *
FROM NHAN_VIEN
WHERE LUONG = (SELECT MAX(LUONG)
FROM NHAN_VIEN);

-- Employee with min salary
SELECT *
FROM NHAN_VIEN
WHERE LUONG = (SELECT MIN(LUONG)
FROM NHAN_VIEN);

-- Highest paid employee in each department
SELECT *
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY PHG ORDER BY LUONG DESC) AS RN
    FROM NHAN_VIEN
) T
WHERE RN = 1;

-- Increase salary by 10% for IT department
UPDATE NHAN_VIEN
SET LUONG = LUONG * 1.10
WHERE PHG = 'PB001';

-- Delete employees without valid department
DELETE FROM NHAN_VIEN
WHERE PHG NOT IN (SELECT MA_PB
FROM PHONG_BAN);

-- Enable cascade delete on employee-project relationship
ALTER TABLE QUANLY_DUAN
DROP CONSTRAINT FK_QLDA_NV;

ALTER TABLE QUANLY_DUAN
ADD CONSTRAINT FK_QLDA_NV
FOREIGN KEY (MA_NHANVIEN)
REFERENCES NHAN_VIEN(ID_NHANVIEN)
ON DELETE CASCADE;

-- Deleting employee deletes assignments automatically
DELETE FROM NHAN_VIEN
WHERE ID_NHANVIEN = 'NV001';

-- Clustered index
CREATE CLUSTERED INDEX IDX_NV_ID
ON NHAN_VIEN(ID_NHANVIEN);

-- Non-clustered index
CREATE NONCLUSTERED INDEX IDX_NV_TEN
ON NHAN_VIEN(TEN_NV);

-- Covering index
CREATE NONCLUSTERED INDEX IDX_QLDA_INCLUDE
ON QUANLY_DUAN(MA_DUAN, MA_NHANVIEN)
INCLUDE (SO_GIO);
GO

-- Create a simple view
CREATE VIEW VW_NHANVIEN
AS
    SELECT ID_NHANVIEN, HO_NV, TEN_NV, LUONG, PHG
    FROM NHAN_VIEN;
GO

-- Query the view
SELECT *
FROM VW_NHANVIEN;

-- TABLE ALIAS allows shorter names for tables
-- Syntax: table_name AS alias_name
-- "AS" keyword is optional in SQL Server
SELECT NV.ID_NHANVIEN, NV.TEN_NV, NV.LUONG
FROM NHAN_VIEN AS NV;

-- JOIN 2 TABLES: Employee + Department
-- Show employee name and department name
SELECT
    NV.ID_NHANVIEN,
    NV.HO_NV + ' ' + NV.TEN_NV AS HO_TEN,
    PB.TEN_PB
FROM NHAN_VIEN AS NV
    JOIN PHONG_BAN AS PB
    ON NV.PHG = PB.MA_PB;

-- JOIN 3 TABLES: Employee + Assignment + Project
-- Show which employee works on which project
SELECT
    NV.ID_NHANVIEN,
    NV.HO_NV + ' ' + NV.TEN_NV AS HO_TEN,
    DA.TEN_DUAN,
    QL.SO_GIO
FROM NHAN_VIEN AS NV
    JOIN QUANLY_DUAN AS QL
    ON NV.ID_NHANVIEN = QL.MA_NHANVIEN
    JOIN DU_AN AS DA
    ON QL.MA_DUAN = DA.MA_DUAN;

-- JOIN 4 TABLES: Employee + Department + Assignment + Project
-- Full overview of employees, departments, projects, and working hours
SELECT
    NV.ID_NHANVIEN,
    NV.HO_NV + ' ' + NV.TEN_NV AS HO_TEN,
    PB.TEN_PB AS TEN_PHONG_BAN,
    DA.TEN_DUAN,
    QL.SO_GIO,
    QL.CHUC_VU
FROM NHAN_VIEN AS NV
    JOIN PHONG_BAN AS PB
    ON NV.PHG = PB.MA_PB
    JOIN QUANLY_DUAN AS QL
    ON NV.ID_NHANVIEN = QL.MA_NHANVIEN
    JOIN DU_AN AS DA
    ON QL.MA_DUAN = DA.MA_DUAN;

-- LEFT JOIN: Show all employees, even if they have no project
SELECT
    NV.ID_NHANVIEN,
    NV.TEN_NV,
    DA.TEN_DUAN
FROM NHAN_VIEN AS NV
    LEFT JOIN QUANLY_DUAN AS QL
    ON NV.ID_NHANVIEN = QL.MA_NHANVIEN
    LEFT JOIN DU_AN AS DA
    ON QL.MA_DUAN = DA.MA_DUAN;

-- FULL JOIN: All employees and all project assignments
-- Includes unmatched rows on both sides
SELECT
    NV.ID_NHANVIEN,
    NV.TEN_NV,
    QL.MA_DUAN
FROM NHAN_VIEN AS NV
    FULL JOIN QUANLY_DUAN AS QL
    ON NV.ID_NHANVIEN = QL.MA_NHANVIEN;

-- Drop view
DROP VIEW VW_NHANVIEN;

-- Drop table
DROP TABLE QUANLY_DUAN;

-- Drop database (use carefully)
DROP DATABASE QLY_NHANSU;