CREATE DATABASE QuanLyBanHang;
USE QuanLyBanHang;

CREATE TABLE KhachHang
(
    MaKH INT IDENTITY(1,1) PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200),
    DienThoai VARCHAR(15)
);


CREATE TABLE SanPham
(
    MaSP INT IDENTITY(1,1) PRIMARY KEY,
    TenSP NVARCHAR(100) NOT NULL,
    DonGia DECIMAL(10,2) NOT NULL,
    SoLuong INT NOT NULL
);

CREATE TABLE HoaDon
(
    MaHD INT IDENTITY(1,1) PRIMARY KEY,
    MaKH INT NOT NULL,
    NgayLap DATE NOT NULL,
    CONSTRAINT FK_HoaDon_KhachHang
        FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

CREATE TABLE HoaDonChiTiet
(
    MaHD INT NOT NULL,
    MaSP INT NOT NULL,
    SoLuong INT NOT NULL,
    DonGia DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_HoaDonChiTiet PRIMARY KEY (MaHD, MaSP),

    CONSTRAINT FK_HDCT_HoaDon
        FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD),

    CONSTRAINT FK_HDCT_SanPham
        FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

INSERT INTO KhachHang
    (TenKH, DiaChi, DienThoai)
VALUES
    (N'Nguyễn Văn An', N'Hà Nội', '0901111111'),
    (N'Trần Thị Bình', N'Hồ Chí Minh', '0902222222'),
    (N'Lê Văn Cường', N'Đà Nẵng', '0903333333'),
    (N'Phạm Thị Dung', N'Hải Phòng', '0904444444'),
    (N'Hoàng Văn Em', N'Cần Thơ', '0905555555');

INSERT INTO SanPham
    (TenSP, DonGia, SoLuong)
VALUES
    (N'Bút bi', 5000, 100),
    (N'Vở học sinh', 12000, 200),
    (N'Sách giáo khoa', 25000, 150),
    (N'Cặp sách', 180000, 50),
    (N'Balo', 250000, 40);

INSERT INTO HoaDon
    (MaKH, NgayLap)
VALUES
    (1, '2025-01-01'),
    (2, '2025-01-02'),
    (3, '2025-01-03'),
    (4, '2025-01-04'),
    (5, '2025-01-05');

INSERT INTO HoaDonChiTiet
    (MaHD, MaSP, SoLuong, DonGia)
VALUES
    (1, 1, 10, 5000),
    (1, 2, 5, 12000),
    (2, 3, 3, 25000),
    (3, 4, 1, 180000),
    (4, 5, 2, 250000);

SELECT *
FROM KhachHang;
SELECT *
FROM SanPham;
SELECT *
FROM HoaDon;
SELECT *
FROM HoaDonChiTiet;
