create database ChauChiCuong_4
go
use ChauChiCuong_4
go

-----------
create table KhachHang
(
	ID int primary key,
	HoTen Nvarchar(255),
	NgaySinh date not null,
	GioiTinh Nvarchar(255)check (GioiTinh=N'Nam' or GioiTinh=N'Nữ')
);
------------
create table LoaiSanPham
(
	ID int primary key,
	TenLoai Nvarchar(255)
);
-------------
create table SanPham
(
	IDSP int,
	ID int primary key,
	TenSP Nvarchar(255),
	Gia int,
	SLTK int
	foreign key (IDSP) references LoaiSanPham(ID)
);
---------------
create table HoaDon
(
	ID int primary key,
	NgayTao date,
	KhachHang int,
	foreign key (KhachHang) references KhachHang(ID)
);
----------------
create table ChiTietHoaDon
(
	IDHD int,
	IDSP int,
	SoLuong int,
	Primary key (IDHD, IDSP),
	foreign key (IDHD) references HoaDon(ID),
	foreign key (IDSP) references SanPham(ID)
);
----------------
insert into KhachHang values (1 , N'Hoàng Văn Dung' , '10/10/1988', N'Nữ');
insert into KhachHang values (2 , N'Quách Văn Tĩnh' , '5/5/1999' , N'Nam' );
insert into KhachHang values (3 , N'Dương Văn Qúa' , '2/9/2002' , N'Nam' );
insert into KhachHang values (4 , N' Đoàn Văn Dự' ,'8/11/2003' ,  N'Nam');
insert into KhachHang values (5 , N'Hồng Thất Công' , '12/02/1888', N'Nam');
insert into KhachHang values (6 , N' Doãn Chí Bình' , '12/12/2002' , N'Nam');
-----------------
 insert into SanPham values (1 , 1 , N' Bia Hà Nội' , 20 , 20);
 insert into SanPham values (1 , 2 , N' Bia Sài Gòn' , 20 , 20);
 insert into SanPham values (2 , 3 , N'Dưa Hấu' , 10 , 80);
 insert into SanPham values (2 , 4 , N' Xoài ' , 8 , 150);
 insert into SanPham values (3 , 5 , N'Bánh Pía' , 40 , 20);
 insert into SanPham values (3 , 6 , N'Bánh Trung Thu' , 40 , 30);
 insert into SanPham values (4 , 7 , N'Coca' , 10 , 10);
 insert into SanPham values (4 , 8 , N'Pesi' , 10 , 10);
 ----------------
insert into HoaDon values (1,'2023/10/8',1);
insert into HoaDon values ( 2 ,'2023/10/8',2);
insert into HoaDon values (3,'2023/10/12', 3);
insert into HoaDon values (4,'2023/10/20', 4);
------------------
insert into ChiTietHoaDon values (1,1,5);
insert into ChiTietHoaDon values (1,4,2);
insert into ChiTietHoaDon values (2,2,6);
insert into ChiTietHoaDon values (2,3,2);
insert into ChiTietHoaDon values (3,7,5);
insert into ChiTietHoaDon values (3,8,6);
insert into ChiTietHoaDon values (3,5,3);
insert into ChiTietHoaDon values (4,1,2);
insert into ChiTietHoaDon values (4,3,3);
-----------------
insert into LoaiSanPham values (1,N'Bia');
insert into LoaiSanPham values (2,N'TraiCay');
insert into LoaiSanPham values (3,N'BanhKeo');
insert into LoaiSanPham values (4,N'NuocNgot');
------------------
--1. ĐƯA RA THÔNG TIN CỦA KHÁCH HÀNG HỒNG THẤT CÔNG
select *
from KhachHang kh
where kh.HoTen = N'Hồng Thất Công'

--2. Cho biết thông tin của sản phẩm có ID là 6
select *
from SanPham sp
where sp.ID=6

--3. Cho biết các sản phẩm thuộc Hóa Đơn được mua vào ngày 20/10/2023
select*
from SanPham sp, ChiTietHoaDon c, HoaDon h
where sp.ID = c.IDSP AND c.IDHD = h.ID and h.NgayTao = '2023/10/20'

--4. Cho biết khách hàng Dương Văn Quá đã mua những sản phẩm nào
select*
from KhachHang kh, HoaDon hd, ChiTietHoaDon c, SanPham sp
where kh.ID = hd.KhachHang and hd.ID = c.IDHD and c.IDSP = sp.ID and kh.HoTen =N'Dương Văn Qúa'

--5. Cho biết sản phẩm nào đang có số lượng tồn kho ÍT nhất
select*
from SanPham sp
where sp.SLTK=(
select min(sp.SLTK)
from SanPham sp)

--6. Cho biết sản phẩm nào đang có Giá trị tồn kho ( = SLTK * Giá mỗi sản phẩm) lớn nhất
select*
from SanPham sp
where sp.SLTK*sp.Gia=(
select max(sp.SLTK*sp.Gia)
from SanPham sp)

--7. Cho biết tên sản phẩm nào đang được bán ra nhiều nhất
with ctsp
as
(select c.IDSP, sum(c.SoLuong) as SL
from ChiTietHoaDon c
group by c.IDSP)

select *
from SanPham sp, ctsp
where sp.ID = ctsp.IDSP and ctsp.SL = (select max (SL) from ctsp)

--8. Cho biết Tên sản phẩm nào đang có doanh thu cao nhất
with ctsp
as
(select c.IDSP, sum(c.SoLuong) as SL
from ChiTietHoaDon c
group by c.IDSP)

select *
from SanPham sp, ctsp
where sp.ID = ctsp.IDSP and ctsp.SL*sp.Gia = (select max (sp.Gia*ctsp.SL) 
	from ctsp, SanPham sp
	where ctsp.IDSP=sp.ID)

--9. Đưa ra Loại Sản phẩm đang có số lượng bán ra lớn nhất
with ctsp
as
(select c.IDSP, sum(c.SoLuong) as SL
from ChiTietHoaDon c
group by c.IDSP)

select TenLoai
from SanPham sp, ctsp, LoaiSanPham lsp
where sp.ID = ctsp.IDSP and ctsp.SL = (select max (SL) from ctsp) and lsp.ID = sp.IDSP