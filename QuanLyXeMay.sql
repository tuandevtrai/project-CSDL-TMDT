use master
IF exists(select * from sysdatabases where name='QuanLyXeMay')
	drop database QuanLyXeMay
go
create database QuanLyXeMay
go
use QuanLyXeMay

go
-- bảng chi nhánh
CREATE TABLE ChiNhanh(
	MaChiNhanh int primary key ,
	TenChiNhanh nvarchar(100) ,
	DiaChi nvarchar(100) 
)


-- Bảng nhân viên
go
create table NhanVien(	
	MaNhanVien int primary key  ,	
	TenNhanVien nvarchar(100)  ,
	NamSinh nvarchar(5)  ,
	GioiTinh nvarchar(10)  ,
	DiaChi nvarchar(100)  ,
	DienThoai nvarchar(15)  ,
	MaChiNhanh int null,

	constraint fk_NhanVien_ChiNhanh foreign key (MaChiNhanh) references ChiNhanh(MaChiNhanh)
)


GO
-- Bảng nhà cung cấp
create table NhaCungCap(
	MaNhaCungCap int primary key  ,
	TenNhaCungCap nvarchar(100)  ,
	DiaChi nvarchar(150)  ,
	DienThoai nvarchar(13)   ,
	Email nvarchar(100)  
)


GO
-- Bảng phiếu nhập
create table PhieuNhap
(
	MaPhieuNhap int primary key  ,	
	MaNhanVien int  ,
	MaNhaCungCap int null,
	MaChiNhanh int null, 
	NgayNhap date  ,
	TongSoXeNhap int,
	ThanhTienNhap float, 
	

	constraint fk_PhieuNhap_NhaCungCap foreign key (MaNhaCungCap) references NhaCungCap(MaNhaCungCap),
	constraint fk_PhieuNhap_NhanVien foreign key (MaNhanVien) references NhanVien(MaNhanVien),
	constraint fk_PhieuNhap_ChiNhanh foreign key (MaChiNhanh) references ChiNhanh(MaChiNhanh)
)

 
go
-- bảng khách hàng
CREATE TABLE KhachHang (
	MaKhachHang int primary key  ,
	TenKhachHang nvarchar(100)  ,	
	DienThoai nvarchar(20)  ,	
) 
GO 

-- Bảng Đầu Xe (Xe số, xe tay ga, tay côn)
create table LoaiXe(
	MaLoaiXe int primary key  ,
	TenLoaiXe nvarchar(100)  ,
	SoLuongHienCo int  ,
)

GO
-- Bảng Dòng Xe (Wave, future)
create table DongXe(
	MaDongXe int primary key  ,
	MaLoaiXe int  ,
	TenDongXe nvarchar(100)  ,
	SoLuongHienCo int  ,

	constraint fk_DongXe_LoaiXe foreign key (MaLoaiXe) references LoaiXe(MaLoaiXe)
)

GO

-- Bảng mặt hàng (từng chiếc xe)
create table Xe(
	MaXe int primary key  ,
	MauXe nvarchar(100)   , -- kiểm tra sự trùng lặp	
	MaDongXe int  ,
	MaChiNhanh int null,
	TenXe nvarchar(100)  ,
	GiaXe int  ,
	TrongLuong int  ,
	NamSanXuat int  ,
	ThongTinBaoHanh nvarchar(100)  ,	
	SoLuongHienCo int  ,		
	HinhAnh image null,			
	
	constraint fk_Xe_Dongxe foreign key (MaDongXe) references DongXe(MaDongXe),
	constraint fk_Xe_ChiNhanh foreign key (MaChiNhanh) references ChiNhanh(MaChiNhanh)
)

go
-- Bảng chi tiết phiếu nhập
create table ChiTietPhieuNhap(	
	MaXe int  ,
	MauXe nvarchar(100),
	MaPhieuNhap int  ,
	SoLuongNhap int  ,
	DonGiaNhap float  ,
	
	constraint fk_ChiTietPhieuNhap_Xe foreign key (MaXe) references Xe(MaXe),
	constraint fk_ChiTietPhieuNhap_PhieuNhap foreign key (MaPhieuNhap) references PhieuNhap(MaPhieuNhap),
	constraint pk_ChiTietPhieuNhap primary key (MaXe, MaPhieuNhap),
)


go
-- Bang Admin
create table Admin(
	MaAdmin int primary key  ,
	TenAdmin nvarchar(100)  ,
	TenDangNhap nvarchar(100)  ,
	MatKhau nvarchar(100)  
)


go
-- Bảng phiếu xuất
create table PhieuXuat(
	MaPhieuXuat int primary key  ,		
	MaNhanVien int  ,
	MaKhachHang int  ,
	MaChiNhanh int null,
	MaXe int  ,		
	MauXe nvarchar(100),
	NgayXuat date  ,	
	ThanhTienXuat int  ,
	GhiChu nvarchar(30) ,
	
	constraint fk_PhieuXuat_NhanVien foreign key(MaNhanVien) references NhanVien(MaNhanVien),
	constraint fk_PhieuXuat_KhachHang foreign key(MaKhachHang) references KhachHang(MaKhachHang),
	constraint fk_PhieuXuat_ChiNhanh foreign key(MaChiNhanh) references ChiNhanh(MaChiNhanh),
	constraint fk_PhieuXuat_Xe foreign key(MaXe) references Xe(MaXe),	
)

GO
-- Bảng bảo hành 
create table PhieuBaoHanh(
	MaPhieuBaoHanh int primary key  ,
	MaPhieuXuat int unique  ,	
	NgayBatDau date  ,
	ThoiGianBaoHanh int  , -- tinh theo thang
	SoKhung nvarchar(100) ,
	SoSuon nvarchar(100) ,

	constraint fk_PhieuBaoHanh_PhieuXuat foreign key(MaPhieuXuat) references PhieuXuat(MaPhieuXuat)
)

go
-- Bảng chi tiết phiếu bảo hành
create table ChiTietPhieuBaoHanh(
	MaChiTietPhieuBaoHanh int primary key,
	MaPhieuBaoHanh int,
	NgayBaoHanh date,
	GhiChu nvarchar(max),

	constraint fk_ChiTietPhieuBaoHanh_PhieuBaoHanh foreign key(MaPhieuBaoHanh) references PhieuBaoHanh(MaPhieuBaoHanh)
)

go
-- Bảng phiếu đặt xe
create table PhieuDatXe(
	MaPhieuDatXe int primary key  ,
	MaXe int, 
	MauXe nvarchar(100),
	TenNguoiDat nvarchar(100)  ,
	SDT nvarchar(100) not null,	
	TinhTrang nvarchar(300) not null, -- có 3 tình trạng chính là: Chờ xác nhận, xác nhận đang còn xe, xác nhân hết xe.
	NgayDat date not null,
	
	constraint fk_PhieuDatXe_Xe foreign key(MaXe) references Xe(MaXe),
	
)
GO


-- thêm giá trị cho Admin
insert into Admin  values(1,'Thanh Luyen','123','123')
-- thêm giá trị cho chi nhánh
go
insert into ChiNhanh values(1,N'Chi nhánh HCM',N'123 lý thường kiệt')
insert into ChiNhanh values(2,N'Chi nhánh Hà Nội',N'123 Hai Bà Trưng')
insert into ChiNhanh values(3,N'Chi nhánh Lâm Đồng',N'123 Phạm Ngọc Thạch')
insert into ChiNhanh values(4,N'Chi nhánh Đak Nông',N'123 Lê Duẩn')
insert into ChiNhanh values(5,N'Chi nhánh Đak Lak',N'123 Điển Biển Phủ')


GO
-- thêm giá trị cho nhà cung cấp
insert into NhaCungCap(MaNhaCungcap, TenNhaCungCap,DiaChi, DienThoai,Email) values (1, 'TuanNCC','SuVanHanh', '56789', '14 Eastwood Lane');
insert into NhaCungCap(MaNhaCungcap, TenNhaCungCap,DiaChi, DienThoai,Email) values (2, 'DienNCC','SuVanHanh', '56789', '14 Eastwood Lane');
insert into NhaCungCap(MaNhaCungcap, TenNhaCungCap,DiaChi, DienThoai,Email) values (3, 'LuyenNCC','SuVanHanh', '56789', '14 Eastwood Lane');
GO
-- thêm khách hàng 
insert into KhachHang (MaKhachHang, TenKhachHang, DienThoai) values (1, 'Averell','959-635-4206');
insert into KhachHang (MaKhachHang, TenKhachHang, DienThoai) values (2, 'Malina', '857-859-9239');
insert into KhachHang (MaKhachHang, TenKhachHang, DienThoai) values (3, 'Shela', '999-399-6304');
insert into KhachHang (MaKhachHang, TenKhachHang, DienThoai) values (4, 'Catriona', '528-197-0459');
insert into KhachHang (MaKhachHang, TenKhachHang, DienThoai) values (5, 'Ashia', '472-452-7085');
insert into KhachHang (MaKhachHang, TenKhachHang, DienThoai) values (6, 'Robinetta', '476-567-6009');
insert into KhachHang (MaKhachHang, TenKhachHang, DienThoai) values (7, 'Ethelbert','757-843-0874');
insert into KhachHang (MaKhachHang, TenKhachHang, DienThoai) values (8, 'Gaylene', '913-589-1816');
insert into KhachHang (MaKhachHang, TenKhachHang, DienThoai) values (9, 'Jobi', '255-544-6771');
insert into KhachHang (MaKhachHang, TenKhachHang, DienThoai) values (10, 'Oran', '786-394-5276');
insert into KhachHang (MaKhachHang, TenKhachHang, DienThoai) values (11, 'Tuan', '1567809');
insert into KhachHang (MaKhachHang, TenKhachHang, DienThoai) values (12, 'Dien', '097654321');

-- thêm thông tin loại xe
insert into LoaiXe(MaLoaiXe, TenLoaiXe,SoLuongHienCo) values (1,N'Xe số',5);
insert into LoaiXe(MaLoaiXe, TenLoaiXe,SoLuongHienCo) values (2,'Xe tay ga',9);
insert into LoaiXe(MaLoaiXe, TenLoaiXe,SoLuongHienCo) values (3,'Xe tay côn',6);

-- thêm thông tin dòng xe
insert into DongXe(MaDongXe, MaLoaiXe,TenDongXe, SoLuongHienCo) values (1,1,N'Wave RSX',1);
insert into DongXe(MaDongXe,MaLoaiXe,TenDongXe, SoLuongHienCo) values (2,1,N'Wave Alpha',1);
insert into DongXe(MaDongXe,MaLoaiXe,TenDongXe, SoLuongHienCo) values (3,1,N'Wave',1);
insert into DongXe(MaDongXe,MaLoaiXe,TenDongXe, SoLuongHienCo) values (4,1,N'Future',1);
insert into DongXe(MaDongXe,MaLoaiXe,TenDongXe, SoLuongHienCo) values (5,1,N'Super Cup',1);
insert into DongXe(MaDongXe,MaLoaiXe,TenDongXe, SoLuongHienCo) values (6,1,N'blade',1);

insert into DongXe(MaDongXe, MaLoaiXe, TenDongXe, SoLuongHienCo) values (7,2,N'SH',3);
insert into DongXe(MaDongXe, MaLoaiXe, TenDongXe, SoLuongHienCo) values (8,2,N'SH Mode',1);
insert into DongXe(MaDongXe, MaLoaiXe, TenDongXe, SoLuongHienCo) values (9,2,N'Air Blade',2);
insert into DongXe(MaDongXe, MaLoaiXe, TenDongXe, SoLuongHienCo) values (10,2,N'LEAD',1);
insert into DongXe(MaDongXe, MaLoaiXe, TenDongXe, SoLuongHienCo) values (11,2,N'VISION - cá tính',1);
insert into DongXe(MaDongXe, MaLoaiXe, TenDongXe, SoLuongHienCo) values (12,2,N'VISION',1);

insert into DongXe(MaDongXe, MaLoaiXe, TenDongXe, SoLuongHienCo) values (13,3,N'CB150R',1);
insert into DongXe(MaDongXe, MaLoaiXe, TenDongXe, SoLuongHienCo) values (14,3,N'CB300R',1);
insert into DongXe(MaDongXe, MaLoaiXe, TenDongXe, SoLuongHienCo) values (15,3,N'CBR150R',1);
insert into DongXe(MaDongXe, MaLoaiXe, TenDongXe, SoLuongHienCo) values (16,3,N'MONKEY',1);
insert into DongXe(MaDongXe, MaLoaiXe, TenDongXe, SoLuongHienCo) values (17,3,N'MSX 125cc',1);
insert into DongXe(MaDongXe, MaLoaiXe, TenDongXe, SoLuongHienCo) values (18,3,N'REBEL 300',1);


select * from Xe
insert into Xe(MaXe,MaDongXe,MaChiNhanh,TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (1,1,1,'WAVE RSX 110cc', 'Do',11111,222,2003,N'1 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (2,5,2,'SUPER CUB 125cc', 'Do',11111,222,2003,N'1 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong,NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (3,4,3,'FUTURE 125cc', 'Do',11111,222,2003,N'1 năm',20)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong,NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (4,6,4,'BLADE 110cc', 'Do',11111,222,2003,N'1 năm',20)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (5,2,5,'WAVE ALPHA 110cc', 'Do',11111,222,2003,N'1 năm',10)

insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (6,9,1,'Air Blade 125cc','Do',11111,222,2005,N'1 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (7,9,2,'Air Blade 160cc', 'Do',11111,222,2005,N'1 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (8,10,3,'LEAD 125cc', 'Do',11111,222,2005,N'1 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (9,7,4,'SH 125cc', 'Do',11111,222,2005,N'1 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (10,7,5,'SH 150cc','Do',11111,222,2005,N'1 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (11,7,1,'SH 350cc', 'Do',11111,222,2005,N'1 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (12,8,2,'SH Mode 125cc','Do',11111,222,2005,N'1 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (13,12,3,'VISION 110cc','Do',11111,222,2005,N'1 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (14,11,1,N'VISION 110cc cá tính','Do',11111,222,2005,N'1 năm',10)

insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (15,13,4,N'CB150R','Do',11111,222,2001,N'3 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (16,14,5,N'CB300R','Do',11111,222,2001,N'3 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (17,15,1,N'CBR150R','Do',11111,222,2001,N'3 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (18,16,2,N'MONKEY','Do',11111,222,2001,N'3 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (19,17,3,N'MSX 125cc', 'Do',11111,222,2001,N'3 năm',10)
insert into Xe(MaXe,MaDongXe, MaChiNhanh, TenXe, MauXe, GiaXe, TrongLuong, NamSanXuat,ThongTinBaoHanh,SoLuongHienCo)
values (20,18,4,N'REBEL 300','Do',11111,222,2001,N'3 năm',10)

-- thêm thông tin nhân viên
insert into NhanVien (MaNhanVien, TenNhanVien, NamSinh, GioiTinh, DiaChi, DienThoai,MaChiNhanh) values (6, 'TuanNV', 1992, 'Male', '49 Tennyson Park', '805-340-4921',1);
insert into NhanVien (MaNhanVien, TenNhanVien, NamSinh, GioiTinh, DiaChi, DienThoai,MaChiNhanh) values (1, 'Cassondra', 1992, 'Female', '48 Tennyson Park', '804-340-4921',2);
insert into NhanVien (MaNhanVien, TenNhanVien, NamSinh, GioiTinh, DiaChi, DienThoai,MaChiNhanh) values (2, 'Christye', 2001, 'Female', '0486 Oxford Plaza', '640-740-5324',3);
insert into NhanVien (MaNhanVien, TenNhanVien, NamSinh, GioiTinh, DiaChi, DienThoai,MaChiNhanh) values (3, 'Ozzie', 2004, 'Male', '5 East Center', '596-576-3451',1);
insert into NhanVien (MaNhanVien, TenNhanVien, NamSinh, GioiTinh, DiaChi, DienThoai,MaChiNhanh) values (4, 'Hunfredo', 2008, 'Male', '28 Springs Pass', '194-805-7386',2);
insert into NhanVien (MaNhanVien, TenNhanVien, NamSinh, GioiTinh, DiaChi, DienThoai,MaChiNhanh) values (5, 'Forrest', 2010, 'Male', '14 Eastwood Lane', '402-678-9288',3);

-- thêm thông tin chi tiết xe
-----------------------------------------------------------------------------------------
-----------------------------------PHẦN RÀNG BUỘC HỆ THỐNG-------------------------------
-----------------------------------------------------------------------------------------
-- Tên đăng nhập không được trùng
go
create trigger user_name
on Admin 
instead of insert, update
as
begin 
	declare @user_name nvarchar(100) ,@id int
	select @user_name = TenDangNhap, @id = MaAdmin from inserted
	if exists (select * from Admin where TenDangNhap = @user_name and MaAdmin != @id)
		raiserror (N'Tên đăng nhập không được trùng',16,1)
end


-- Mật khẩu không được để trống
go
create trigger password 
on Admin
for insert, update 
as
begin	
	declare @password nvarchar(100) 
	select @password = MatKhau from inserted
	if (@password is null or @password = '')
		raiserror (N'Mật khẩu không được bỏ trống',16,1)
end


-- Giới tính chỉ có thể là nam hoặc nữ 
go

--drop trigger GioiTinh
--on NhanVien
--instead of insert, update 
--as
--begin 
--	declare @GioiTinh nvarchar(10) 
--	select @GioiTinh = GioiTinh from inserted
--	if(@GioiTinh != N'Nam' or @GioiTinh != N'Nữ')
--	begin
--		raiserror (N'Giới tính chỉ có thể là nam hoặc nữ',16,1)
--		rollback tran
--	end
--end
-----------------------------------------------------------------------------------------
--------------------------KẾT THÚC PHẦN RÀNG BUỘC HỆ THỐNG-------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-----------------------------------------PHẦN ADMIN--------------------------------------
-----------------------------------------------------------------------------------------
go
--kiểm tra thông tin đăng nhập của admin 
create proc sp_CheckLogin @TenDangNhap nvarchar(20), @MatKhau nvarchar(20)
as
begin 
	 select * from Admin where TenDangNhap = @TenDangNhap and MatKhau = @MatKhau
end

select * from Admin


--Tạo một admin mới
go
create proc sp_TaoAdminMoi @TenAdmin nvarchar(100), @TenDangNhap nvarchar(100), @MatKhau nvarchar(100)
as
begin 
	if(@TenAdmin is null or @TenDangNhap is null or @MatKhau is null)
	begin 
		raiserror('Yêu cầu nhập thông tin đầy đủ',16,1)
		return 
	end
	if exists (select * from Admin where @TenDangNhap = TenDangNhap )
	begin 
		raiserror('Thông tin Admin này đã trùng, yêu cầu kiểm tra lại thông tin',16,1)
		return 
	end
	SET XACT_ABORT ON
	begin tran
	begin try 
		declare @temps int
			set @temps = 1
			while exists (select * from Admin where MaAdmin = @temps)
				set @temps = @temps + 1
		insert into Admin(MaAdmin,TenAdmin,TenDangNhap,MatKhau)
		values(@temps,@TenAdmin,@TenDangNhap,@MatKhau)
		commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end 
select * from Admin
exec sp_TaoAdminMoi 'ThaiTuan','tuan','123'

		insert into Admin(MaAdmin,TenAdmin,TenDangNhap,MatKhau)
		values(2,'Thai tuan','tuan','123')

-- cập nhật thông tin Admin
go
create proc sp_CapNhatThongTinAdmin @MaAdmin int, @TenAdmin nvarchar(100), @TenDangNhap nvarchar(100), @MatKhau nvarchar(100)
as
begin
	if(@MaAdmin is null or @TenAdmin is null or @TenDangNhap is null or @MatKhau is null)
	begin 
		raiserror('Yêu cầu nhập thông tin đầy đủ',16,1)
		return 
	end

	if exists (select * from Admin where TenDangNhap = @TenDangNhap and MaAdmin != @MaAdmin)
	begin 
		raiserror('Thông tin khách hàng này đã trùng, yêu cầu kiểm tra lại thông tin',16,1)
		return 
	end
	begin transaction
	begin try
		update Admin set TenAdmin = @TenAdmin, TenDangNhap = @TenDangNhap, MatKhau = @MatKhau where MaAdmin = @MaAdmin
		commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch	
end


go
-- Xóa thông tin Admin
create proc sp_XoaThongTinAdmin @MaAdmin int
as
begin 
	if not exists( select * from Admin where MaAdmin = @MaAdmin)
	begin 
		raiserror('Admin này không tồn tại',16,1)
		return 
	end
	
	begin transaction 
	begin try 
		delete Admin where MaAdmin = @MaAdmin
		commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end	


-----------------------------------------------------------------------------------------
-------------------------------------KẾT THÚC ADMIN--------------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-------------------------------------PHẦN CHI NHÁNH--------------------------------------
-----------------------------------------------------------------------------------------
GO
-- TẠO MỘT CHI NHÁNH MỚI 
create proc sp_TaoChiNhanh @TenChiNhanh nvarchar(100), @DiaChi nvarchar(100)
as
begin 
	if(@TenChiNhanh is null or @DiaChi is null)
	begin 
		Raiserror(N'Vui lòng nhập thông tin đầy đủ và chính xác',16,1)		 
		return
	end 
	if exists(select * from ChiNhanh where TenChiNhanh = @TenChiNhanh or DiaChi =  @DiaChi)
	begin 
		Raiserror(N'Vui lòng nhập thông tin đầy đủ và chính xác',16,1)		 
		return
	end 
	SET XACT_ABORT ON
	begin transaction 
	begin try
		declare @temps int
		set @temps = 1
		while exists (select * from ChiNhanh where MaChiNhanh = @temps)
			set @temps = @temps + 1
		insert into ChiNhanh(MaChiNhanh, TenChiNhanh, DiaChi)
		values (@temps,@TenChiNhanh,@DiaChi)	
		commit
	end try	
	begin catch 	
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch	
end


-- Cap nhat thong tin chi nhanh
go
create proc sp_CapNhatThongTinChiNhanh @MaChiNhanh int, @TenChiNhanh nvarchar(100), @DiaChi nvarchar(100)
as
begin
	if not exists (select * from ChiNhanh where MaChiNhanh = @MaChiNhanh)
	begin
		raiserror ('Chi nhanh nay khong ton tai',16,1)		
		return
	end
	if exists ( select * from ChiNhanh where TenChiNhanh = @TenChiNhanh and DiaChi = @DiaChi and MaChiNhanh != @MaChiNhanh )
	begin 
		raiserror ('Yeu cau dat ten chi nhanh va dia chi khac',16,1)		
		return
	end
	SET XACT_ABORT ON
	begin transaction 
	begin try
		update ChiNhanh set TenChiNhanh = @TenChiNhanh, DiaChi = @DiaChi where MaChiNhanh = @MaChiNhanh
		commit
	end try	
	begin catch 	
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch	
end

-- Xoa chi nhanh 
go 
create proc sp_XoaChiNhanh @MaChiNhanh int
as
begin 
	if not exists (select * from ChiNhanh where MaChiNhanh = @MaChiNhanh)
	begin
		raiserror ('Chi nhanh nay khong ton tai',16,1)		
		return
	end
	SET XACT_ABORT ON
	begin transaction
	begin try
	select * from PhieuXuat
		delete PhieuNhap  where MaChiNhanh = @MaChiNhanh
		delete PhieuXuat where MaChiNhanh = @MaChiNhanh
		delete Xe where MaChiNhanh = @MaChiNhanh
		delete NhanVien where MaChiNhanh = @MaChiNhanh
		delete ChiNhanh where MaChiNhanh = @MaChiNhanh
	commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch	
end

-----------------------------------------------------------------------------------------
------------------------------PHẦN CHI NHÁNH--------------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
------------------------------PHẦN NHÀ CUNG CẤP--------------------------------------
-----------------------------------------------------------------------------------------
-- THÊM THÔNG TIN NHÀ CUNG CẤP
GO
create proc sp_TaoNhaCungCap @TenNhaCungCap nvarchar(100), @DiaChi nvarchar(100), @DienThoai nvarchar(100), @Email nvarchar(100)
as
begin 
	if(@TenNhaCungCap is null or @DiaChi is null or @DienThoai is null or @Email is null)
	begin 		
		Raiserror(N'Vui lòng nhập thông tin đầy đủ và chính xác',16,1)		
		return
	end 
	if exists (select * from NhaCungCap where TenNhaCungCap = @TenNhaCungCap and @DiaChi = DiaChi )
	begin 		
		Raiserror(N'Vui lòng xem lại thông tin',16,1)		
		return
	end 
	SET XACT_ABORT ON
	begin transaction
	begin try
		declare @temps int
		set @temps = 1
		while exists (select * from NhaCungCap where MaNhaCungCap = @temps)
			set @temps = @temps + 1
		insert into NhaCungCap(MaNhaCungCap, TenNhaCungCap, DiaChi,DienThoai , Email)
		values (@temps,@TenNhaCungCap,@DiaChi, @DienThoai, @Email)
		commit
	end try
	begin catch 
		declare @ErrMsg varchar(max)
		rollback
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMsg,16,1)
	end catch
end	


-- Chỉnh sửa thông tin nhà cung cấp
go
create proc sp_ChinhSuaThongTinNhaCungCap @MaNhaCungCap int, @TenNhaCungCap nvarchar(100), @DiaChi nvarchar(100), @DienThoai nvarchar(100), @Email nvarchar(100)
as
begin	
	if(@TenNhaCungCap is null or @DiaChi is null or @DienThoai is null or @Email is null or @MaNhaCungCap is null)
	begin 		
		Raiserror(N'Vui lòng nhập thông tin đầy đủ và chính xác',16,1)		
		return
	end 
	if not exists(select * from NhaCungCap where MaNhaCungCap = @MaNhaCungCap) 
	begin 
		raiserror (N'Thông tin nhà cung cấp này không hợp lệ',16,1)		
		return 
	end
	
	if exists (select * from NhaCungCap where TenNhaCungCap = @TenNhaCungCap and @DiaChi = DiaChi and MaNhaCungCap != @MaNhaCungCap )
	begin 		
		Raiserror(N'Vui lòng xem lại thông tin',16,1)		
		return
	end 
	SET XACT_ABORT ON
	begin transaction 
	begin try
		update NhaCungCap set TenNhaCungCap = @TenNhaCungCap, DiaChi = @DiaChi, DienThoai = @DienThoai, Email = @Email
		where MaNhaCungCap = @MaNhaCungCap
	commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end


-- Xóa thông tin nhà cung cấp
go
create proc sp_XoaNhaCungCap @MaNhaCungCap int
as
begin
	if not exists(select * from NhaCungCap where MaNhaCungCap = @MaNhaCungCap) 
	begin 
		raiserror (N'Thông tin nhà cung cấp này không hợp lệ',16,1)		
		return 
	end
	SET XACT_ABORT ON
	begin transaction 
	begin try
		update PhieuNhap set MaNhaCungCap = null where MaNhaCungCap = @MaNhaCungCap
		delete NhaCungCap where MaNhaCungCap = @MaNhaCungCap
	commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end

-----------------------------------------------------------------------------------------
------------------------------KẾT THÚC PHẦN NHÀ CUNG CẤP---------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
------------------------------PHẦN NHÂN VIÊN---------------------------------
-----------------------------------------------------------------------------------------
GO
-- TẠO MỘT NHÂN VIÊN MỚI
create PROC sp_ThemNhanVien @TenNhanVien nvarchar(100), @NamSinh nvarchar(5), @GioiTinh nvarchar(10), 
							@DiaChi nvarchar(100), @DienThoai nvarchar(15), @MaChiNhanh int
as
begin 
	if(@TenNhanVien is null or @DiaChi is null or @MaChiNhanh is null or @GioiTinh is null or @DienThoai is null)
	begin 		
		Raiserror(N'Vui lòng nhập thông tin đầy đủ và chính xác',16,1)
		return 
	end 
	--if(@GioiTinh not like N'Nam' or @GioiTinh not like N'Nữ')
	--begin 		
	--	Raiserror(N'Giới tính chỉ có thể là Nam hoặc Nữ',16,1)
	--	return 
	--end 
	SET XACT_ABORT ON
	begin transaction
	begin try
		declare @temps int
		set @temps = 1
		while exists (select * from NhanVien where MaNhanVien = @temps)
			set @temps = @temps + 1
		insert into NhanVien(MaNhanVien,TenNhanVien, NamSinh, GioiTinh,DiaChi , DienThoai, MaChiNhanh)
		values (@temps, @TenNhanVien,@NamSinh,@GioiTinh,@DiaChi,@DienThoai,@MaChiNhanh)
		commit 
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end



-- Chỉnh sửa thông tin nhân viên
go
create proc sp_ChinhSuaThongTinNhanVien @MaNhanVien int,  @TenNhanVien nvarchar(100), @NamSinh nvarchar(5), @GioiTinh nvarchar(10), @DiaChi nvarchar(100), @DienThoai nvarchar(15), @MaChiNhanh int
as
begin	
	if not exists(select * from NhanVien where MaNhanVien = @MaNhanVien) 
	begin 
		raiserror (N'Không tìm thấy nhân viên này',16,1)		
		return 
	end
	if(@TenNhanVien is null or @DiaChi is null or @MaChiNhanh is null or @GioiTinh is null or @DienThoai is null)
	begin 		
		Raiserror(N'Vui lòng nhập thông tin đầy đủ và chính xác',16,1)
		return 
	end	
	SET XACT_ABORT ON
	begin transaction 
	begin try
		update NhanVien set TenNhanVien = @TenNhanVien, DiaChi = @DiaChi, DienThoai = @DienThoai, 
							NamSinh = @NamSinh, GioiTinh = @GioiTinh, MaChiNhanh = @MaChiNhanh
		where MaNhanVien = @MaNhanVien
	commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end


-- Xóa thông tin nhân viên
go
create proc sp_XoaNhanVien @MaNhanVien int
as
begin
	if not exists(select * from NhanVien where MaNhanVien = @MaNhanVien) 
	begin 
		raiserror (N'Thông tin nhân viên này không hợp lệ',16,1)		
		return 
	end
	SET XACT_ABORT ON
	begin transaction 
	begin try
		update PhieuXuat set MaNhanVien = null where MaNhanVien = @MaNhanVien
		delete NhanVien where MaNhanVien = @MaNhanVien
	commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end

-----------------------------------------------------------------------------------------
------------------------------KẾT THÚC PHẦN NHÂN VIÊN---------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-------------------------------------PHẦN DÒNG XE ---------------------------------------
-----------------------------------------------------------------------------------------
-- trigger tự đông gia tăng số lương dòng xe 
go
create trigger tg_CapNhanSoLuongDongXe
on Xe
for insert, update, delete
as
begin 	
	declare @MaDongXeCu int
	select @MaDongXeCu = MaDongXe from deleted

	declare @MaDongXeMoi int	
	select @MaDongXeMoi = MaDongXe from inserted 

	if (@MaDongXeCu is not null)
	begin
		update DongXe set SoLuongHienCo = (select sum(SoLuongHienCo) from Xe where MaDongXe = @MaDongXeCu) where MaDongXe = @MaDongXeCu
	end
	if(@MaDongXeMoi is not null)
	begin 
		update DongXe set SoLuongHienCo = (select sum(SoLuongHienCo) from Xe where MaDongXe = @MaDongXeMoi) where MaDongXe = @MaDongXeMoi
	end
end


-- Thêm dòng xe mới
go
create proc sp_ThemDongXeMoi @MaLoaiXe int, @TenDongXe nvarchar(100)
as
begin 
	if(@MaLoaiXe is null or @TenDongXe is null) 
	begin
		raiserror(N'Yêu cầu nhập thông tin đầy đủ',16,1)
		return
	end
	SET XACT_ABORT ON
	begin transaction
	begin try
		declare @temps int
			set @temps = 1
			while exists (select * from DongXe where MaDongXe = @temps)
				set @temps = @temps + 1
		insert into DongXe(MaDongXe, MaLoaiXe, TenDongXe,SoLuongHienCo)
		values(@temps, @MaLoaiXe,@TenDongXe,0)		
	commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch 
end


-- Cập nhật thông tin dòng xe
go
create proc sp_CapNhatThongTinDongXe @MaDongXe int, @MaLoaiXe int, @TenDongXe nvarchar(100)
as
begin 
	if(@MaLoaiXe is null or @MaDongXe is null or @TenDongXe is null)
	begin 
		raiserror (N'Yêu cầu nhập thông tin đầu đủ',16,1)
		return 
	end
	if(@TenDongXe in( select TenDongXe from DongXe where MaDongXe != @MaDongXe))
	begin 
		raiserror (N'Yêu cầu nhập tên xe khác',16,1)
		return 
	end
	SET XACT_ABORT ON
	begin transaction 
	begin try
		update DongXe set TenDongXe = @TenDongXe, MaLoaiXe = @MaLoaiXe where MaDongXe = @MaDongXe
		commit 
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end


-- Xoa dong xe
go 
create proc sp_XoaDongXe @MaDongXe int
as
begin
	if(@MaDongXe is null) 
	begin
		raiserror(N'Yêu cầu nhập thông tin đầy đủ',16,1)
		return
	end
	if not exists( select * from DongXe where MaDongXe = @MaDongXe)
	begin
		raiserror(N'Thông tin không hợp lệ',16,1)
		return
	end
	if exists( select * from Xe where MaDongXe = @MaDongXe) 
	begin
		raiserror(N'Hiện tại không thể xóa dòng xe này vì còn xe phụ thuộc vào nó',16,1)
		return
	end
	SET XACT_ABORT ON
	begin transaction 
	begin try
		delete DongXe where MaDongXe = @MaDongXe
	commit 
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end 
-----------------------------------------------------------------------------------------
-----------------------------------KẾT THÚC PHẦN DÒNG XE --------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
--------------------------------------PHẦN LOẠI XE --------------------------------------
-----------------------------------------------------------------------------------------
-- trigger tự đông gia tăng số lương loại xe 
go
create trigger tg_CapNhanSoLuongLoaiXe
on DongXe
for insert, update, delete
as
begin 	
	declare @MaLoaiXeCu int
	select @MaLoaiXeCu = MaLoaiXe from deleted

	declare @MaLoaiXeMoi int	
	select @MaLoaiXeMoi = MaLoaiXe from inserted 
	
	if(@MaLoaiXeCu is not null)
	begin 
		update LoaiXe set SoLuongHienCo = (select sum(SoLuongHienCo) from DongXe where MaLoaiXe = @MaLoaiXeCu) where MaLoaiXe = @MaLoaiXeCu
	end
	if(@MaLoaiXeMoi is not null)
	begin
		update LoaiXe set SoLuongHienCo = (select sum(SoLuongHienCo) from DongXe where MaLoaiXe = @MaLoaiXeMoi) where MaLoaiXe = @MaLoaiXeMoi	
	end
end


-- Thêm loai xe mới
go
create proc sp_ThemLoaiXeMoi @TenLoaiXe nvarchar(100)
as
begin 
	if(@TenLoaiXe is null) 
	begin
		raiserror(N'Yêu cầu nhập thông tin đầy đủ',16,1)
		return
	end
	SET XACT_ABORT ON
	begin transaction
	begin try
		declare @temps int
			set @temps = 1
			while exists (select * from LoaiXe where MaLoaiXe = @temps)
				set @temps = @temps + 1
		insert into LoaiXe(MaLoaiXe, TenLoaiXe,SoLuongHienCo)
		values(@temps, @TenLoaiXe,0)
	commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch 
end


-- Cập nhật thông tin dòng xe
go
create proc sp_CapNhatThongTinLoaiXe @MaLoaiXe int, @TenLoaiXe nvarchar(100)
as
begin 
	if(@MaLoaiXe is null or @TenLoaiXe is null)
	begin 
		raiserror (N'Yêu cầu nhập thông tin đầu đủ',16,1)
		return 
	end
	if(@TenLoaiXe in( select TenLoaiXe from LoaiXe where MaLoaiXe != @MaLoaiXe))
	begin 
		raiserror (N'Yêu cầu nhập tên loại xe khác',16,1)
		return 
	end
	SET XACT_ABORT ON
	begin transaction 
	begin try
		update LoaiXe set TenLoaiXe = @TenLoaiXe where MaLoaiXe = @MaLoaiXe
		commit 
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end


-- Xoa dong xe
go 
create proc sp_XoaLoaiXe @MaLoaiXe int
as
begin
	if(@MaLoaiXe is null) 
	begin
		raiserror(N'Yêu cầu nhập thông tin đầy đủ',16,1)
		return
	end
	if not exists( select * from LoaiXe where MaLoaiXe = @MaLoaiXe)
	begin
		raiserror(N'Thông tin không hợp lệ',16,1)
		return
	end
	if exists( select * from DongXe where MaLoaiXe = @MaLoaiXe) 
	begin
		raiserror(N'Hiện tại không thể xóa loại xe này vì còn dòng xe phụ thuộc vào nó',16,1)
		return
	end
	SET XACT_ABORT ON
	begin transaction 
	begin try
		delete LoaiXe where MaLoaiXe = @MaLoaiXe
	commit 
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Loi' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end 
-----------------------------------------------------------------------------------------
-----------------------------------KẾT THÚC PHẦN LOẠI XE --------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
------------------------------------PHẦN PHIẾU NHẬP--------------------------------------
-----------------------------------------------------------------------------------------
GO
-- TẠO PHIẾU NHẬP MỚI
create proc sp_ThemPhieuNhap @MaNhanVien int, @MaNhaCungCap int, @MaChiNhanh int
as
begin 
	if(@MaNhanVien is null or @MaNhaCungCap is null or @MaChiNhanh is null)
	begin 
		raiserror (N'Vui lòng nhập đầy đủ thông tin',16,1)
		return
	end
	SET XACT_ABORT ON
	begin transaction 
	begin try
		declare @temps int
			set @temps = 1
			while exists (select * from PhieuNhap where MaPhieuNhap = @temps)
				set @temps = @temps + 1
		insert into PhieuNhap(MaPhieuNhap, MaNhanVien,MaNhaCungCap, MaChiNhanh, NgayNhap, TongSoXeNhap, ThanhTienNhap)
		values(@temps,@MaNhanVien, @MaNhaCungCap, @MaChiNhanh, GETDATE(), 0,0)
		commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end


-- chỉnh sửa thông tin phiếu nhập
go
create proc sp_ChinhSuaThongTinPhieuNhap @MaPhieuNhap int, @MaNhanVien int, @MaNhaCungCap int, @MaChiNhanh int
as
begin
	if(@MaPhieuNhap is null or @MaNhanVien is null or @MaNhaCungCap is null or @MaChiNhanh is null)
	begin 
		raiserror (N'Vui lòng nhập đầy đủ thông tin',16,1)
		return
	end
	if not exists (select * from PhieuNhap where MaPhieuNhap = @MaPhieuNhap)
	begin 
		raiserror (N'Vui lòng kiểm tra lại thông tin',16,1)
		return
	end
	SET XACT_ABORT ON
	begin transaction
	begin try
		update PhieuNhap 
			set MaNhanVien = @MaNhanVien, MaNhaCungCap = @MaNhaCungCap, MaChiNhanh = @MaChiNhanh 
			where MaPhieuNhap = @MaPhieuNhap
	commit 
	end try
	begin catch		
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end


--Xóa thông tin phiếu nhập
go
create proc sp_XoaThongTinPhieuNhap @MaPhieuNhap int
as
begin 
	if not exists (Select * from PhieuNhap where MaPhieuNhap = @MaPhieuNhap)
	begin
		raiserror (N'Vui lòng kiểm tra lại thông tin',16,1)
		return
	end
	SET XACT_ABORT ON
	begin transaction
	begin try
		delete ChiTietPhieuNhap where MaPhieuNhap = @MaPhieuNhap
		delete PhieuNhap where MaPhieuNhap = @MaPhieuNhap
	commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end

-----------------------------------------------------------------------------------------
---------------------------KẾT THÚC PHẦN PHIẾU NHẬP--------------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
--------------------------- PHẦN CHI TIẾT PHIẾU NHẬP-------------------------------------
-----------------------------------------------------------------------------------------
-- cập nhât thông tin số lương và tổng tiền cho phiếu nhập
go
create trigger tg_CapNhatSoLuongVaThanhTienChoPhieuNhap 
on ChiTietPhieuNhap
after insert, update, delete
as
begin 
	declare @MaPhieuNhapCu int
	select @MaPhieuNhapCu = MaPhieuNhap from deleted

	declare @MaPhieuNhapMoi int
	select @MaPhieuNhapMoi = MaPhieuNhap from inserted

	if(@MaPhieuNhapCu is not null)
	begin			
		update PhieuNhap set TongSoXeNhap = (select sum(SoLuongNhap) from ChiTietPhieuNhap where MaPhieuNhap = @MaPhieuNhapCu),
							ThanhTienNhap = (select sum(DonGiaNhap) from ChiTietPhieuNhap where MaPhieuNhap = @MaPhieuNhapCu)
		where MaPhieuNhap = @MaPhieuNhapCu 

	end	
	if(@MaPhieuNhapMoi is not null)
	begin
		update PhieuNhap set TongSoXeNhap = (select sum(SoLuongNhap) from ChiTietPhieuNhap where MaPhieuNhap = @MaPhieuNhapMoi),
							ThanhTienNhap = (select sum(DonGiaNhap) from ChiTietPhieuNhap where MaPhieuNhap = @MaPhieuNhapMoi)
			where MaPhieuNhap = @MaPhieuNhapMoi	
	end
end 


-- tạo chi tiết phiếu nhập mới
go
create proc sp_ThemChiTietPhieuNhap @MaXe int, @MaPhieuNhap int, @SoLuongNhap int, @DonGiaNhap float
as 
begin 
	if(@MaXe is null or @MaPhieuNhap is null or @MaPhieuNhap is null or @SoLuongNhap is null or @DonGiaNhap is null)
	begin 		 
		Raiserror(N'Vui lòng nhập thông tin đầy đủ và chính xác',16,1)
		return
	end 
	if ( select count(*) from ChiTietPhieuNhap where MaXe = @MaXe and MaPhieuNhap = @MaPhieuNhap) >= 2
	begin 
		rollback 
		Raiserror(N'Vui lòng nhập kiểm tra lại thông tin xe và phiếu nhập đã bị trùng',16,1)
	end
	SET XACT_ABORT ON
	begin transaction 
	begin try 
		insert into ChiTietPhieuNhap(MaPhieuNhap,MaXe,SoLuongNhap, DonGiaNhap)
		values (@MaPhieuNhap, @MaXe, @SoLuongNhap, @DonGiaNhap)
		commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
	
end


-- cập nhật thông tin chi tiết phiếu nhập
go
create proc sp_CapNhatThongTinChiTietPhieuNhap @MaXe int, @MaPhieuNhap int, @SoLuongNhap int, @DonGiaNhap float
as
begin
	if(@MaXe is null or @MaPhieuNhap is null or @MaPhieuNhap is null or @SoLuongNhap is null or @DonGiaNhap is null)
	begin 		 
		Raiserror(N'Vui lòng nhập thông tin đầy đủ và chính xác',16,1)
		return
	end 
	SET XACT_ABORT ON
	begin transaction
	begin try
		update ChiTietPhieuNhap set MaPhieuNhap = MaPhieuNhap, MaXe = @MaXe, SoLuongNhap = @SoLuongNhap, DonGiaNhap = @DonGiaNhap
			where MaPhieuNhap = @MaPhieuNhap and MaXe = @MaXe
		if ( select count(*) from ChiTietPhieuNhap where MaXe = @MaXe and MaPhieuNhap = @MaPhieuNhap) >= 2
		begin 
			rollback 
			Raiserror(N'Vui lòng nhập kiểm tra lại thông tin xe và phiếu nhập đã bị trùng',16,1)
		end
		commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end


-- Xóa thông tin chi tiết phiếu nhập
go
create proc sp_XoaThongTinChiTietPhieuNhap @MaPhieuNhap int, @MaXe int
as
begin 
if(@MaXe is null or @MaPhieuNhap is null or @MaPhieuNhap is null)
	begin 		 
		Raiserror(N'Vui lòng nhập thông tin đầy đủ và chính xác',16,1)
		return
	end 	
	SET XACT_ABORT ON
	begin transaction 
	begin try
		delete ChiTietPhieuNhap where MaPhieuNhap = @MaPhieuNhap and MaXe = @MaXe
		commit 
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end

-----------------------------------------------------------------------------------------
---------------------------KẾT THÚC PHẦN CHI TIẾT PHIẾU NHẬP-----------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-----------------------------------PHẦN KHÁCH HÀNG---------------------------------------
-----------------------------------------------------------------------------------------
GO
-- xuat thong tin tat ca cac khach hang
create proc sp_XuatTatCaKhachHang
as 
begin 
	select * from KhachHang 
end


go
--Tìm kiếm khách hàng theo theo tên và số điện thoại
create proc sp_TimKiemKhachHang @dienthoai nvarchar(20), @TenKH nvarchar(200)
as
begin
	if(@dienThoai is not null and @TenKH is null)
	begin
		select * from KhachHang where DienThoai = @dienthoai
		return;
	end
	else
	begin
		if(@dienThoai is null and @tenKh is not null)
		begin
			select * from KhachHang where TenKhachHang = @TenKH
			return;
		end
	end	
	select * from khachhang where DienThoai = '%'+@dienthoai+'%' or TenKhachHang = '%'+@TenKH+'%'	
end

exec sp_TimKiemKhachHang null,'Tuan'

go
-- Thêm khách hàng mới
create proc sp_ThemKhachHang @TenKhachHang nvarchar(100), @DienThoai nvarchar(100)
as
begin 
	if(@TenKhachHang is null or @DienThoai is null )
	begin 
		raiserror('Yêu cầu nhập thông tin đầy đủ',16,1)
		return 
	end

	if exists (select * from KhachHang where DienThoai = @DienThoai)
	begin 
		raiserror('Thông tin khách hàng này đã trùng, yêu cầu kiểm tra lại thông tin',16,1)
		return 
	end
	SET XACT_ABORT ON
	begin tran
	begin try 
		declare @temps int
			set @temps = 1
			while exists (select * from KhachHang where MaKhachHang = @temps)
				set @temps = @temps + 1
		insert into KhachHang(MaKhachHang,TenKhachHang,DienThoai)
		values(@temps,@TenKhachHang,@DienThoai)
		commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end 


-- cập nhật thông tin khách hàng
go
CREATE proc sp_CapNhatThongTinKhachHang @MaKhachHang int, @TenKhachHang nvarchar(100), @DienThoai nvarchar(100)
as
begin
	if(@TenKhachHang is null or @DienThoai is null )
	begin 
		raiserror('Yêu cầu nhập thông tin đầy đủ',16,1)
		return 
	end
	SET XACT_ABORT ON
	begin transaction
	begin try
		update KhachHang set TenKhachHang = @TenKhachHang, DienThoai = @DienThoai where MaKhachHang = @MaKhachHang
		if exists (select * from KhachHang where DienThoai = @DienThoai AND MaKhachHang != @MaKhachHang )
		begin 
			raiserror('Thông tin khách hàng này đã trùng, yêu cầu kiểm tra lại thông tin',16,1)
			return 
		end
		commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback  
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch	
end


go
-- Xóa thông tin khách hàng
create proc sp_XoaThongTinKhachHang @MaKhachHang int
as
begin 
	if not exists( select * from KhachHang where MaKhachHang = @MaKhachHang)
	begin 
		raiserror('Khách hàng này không tồn tại',16,1)
		return 
	end
	if exists (select * from PhieuXuat where MaKhachHang = @MaKhachHang)
	begin 
		raiserror('Khách hàng này hiện tại chưa được xóa vì còn thông tin cần xử lý',16,1)
		return 
	end
	SET XACT_ABORT ON
	begin transaction 
	begin try 
		delete KhachHang where MaKhachHang = @MaKhachHang
		commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end	


-----------------------------------------------------------------------------------------
---------------------------KẾT THÚC PHẦN KHÁCH HÀNG--------------------------------------
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
----------------------------------PHIẾU BẢO HÀNH-----------------------------------------
-----------------------------------------------------------------------------------------

-- Tạo thông tin phiếu bảo hành
go
create proc sp_TaoPhieuBaoHanh @MaPhieuXuat int, @NgayBatDau date, @ThoiGianBaoHanh int, @SoKhung nvarchar(100), @SoSuon nvarchar(100)
as
begin 
	if(@MaPhieuXuat is null or @NgayBatDau is null or @ThoiGianBaoHanh is null or @SoKhung is null or @SoSuon is null)
	begin
		Raiserror(N'Yêu cầu nhập thông tin đầy đủ',16,1)
		return
	end
	if not exists (select * from PhieuXuat where MaPhieuXuat = @MaPhieuXuat)
	begin
		Raiserror(N'Không tìn thầy thông tin phiếu xuất để bảo hành',16,1)
		return
	end
	SET XACT_ABORT ON
	begin tran 
	begin try 
	declare @temps int
			set @temps = 1
			while exists (select * from PhieuBaoHanh where MaPhieuBaoHanh = @temps)
				set @temps = @temps + 1
		insert into PhieuBaoHanh(MaPhieuBaoHanh, MaPhieuXuat,NgayBatDau,ThoiGianBaoHanh,SoKhung,SoSuon)
		values (@temps,@MaPhieuXuat,@NgayBatDau,@ThoiGianBaoHanh,@SoKhung,@SoSuon)
		commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end


-- Cập nhật thông tin phiếu bảo hàng
go
create proc sp_CapNhatThongTinPhieuBaoHanh @MaPhieuBaoHanh int, @MaPhieuXuat int, @NgayBatDau date, @ThoiGianBaoHanh int, @SoKhung nvarchar(100), @SoSuon nvarchar(100)
as
begin 
	if(@MaPhieuBaoHanh is null or @MaPhieuXuat is null or @NgayBatDau is null or @ThoiGianBaoHanh is null or @SoKhung is null or @SoSuon is null)
	begin
		Raiserror(N'Yêu cầu nhập thông tin đầy đủ',16,1)
		return
	end
	if not exists (select * from PhieuBaoHanh where MaPhieuBaoHanh = @MaPhieuBaoHanh)
	begin
		Raiserror(N'Không tìm thấy thông tin phiếu bảo hành này',16,1)
		return
	end
	SET XACT_ABORT ON
	begin tran 
	begin try
		update PhieuBaoHanh set MaPhieuXuat = @MaPhieuXuat, NgayBatDau = @NgayBatDau, ThoiGianBaoHanh = @ThoiGianBaoHanh, SoKhung = @SoKhung, SoSuon = @SoSuon
		where MaPhieuBaoHanh = @MaPhieuBaoHanh
	commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end 


-- xóa phiếu bảo hành
go
create proc sp_XoaPhieuBaoHanh @MaPhieuBaoHanh int
as
begin 
	if not exists (select * from PhieuBaoHanh where MaPhieuBaoHanh = @MaPhieuBaoHanh)
	begin
		Raiserror(N'Không tìm thấy thông tin phiếu bảo hành này',16,1)
		return
	end
	SET XACT_ABORT ON
	begin tran 
	begin try
		delete ChiTietPhieuBaoHanh where MaPhieuBaoHanh = @MaPhieuBaoHanh
		delete PhieuBaoHanh where MaPhieuBaoHanh = @MaPhieuBaoHanh
		commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end		
-----------------------------------------------------------------------------------------
----------------------------KẾT THÚC PHẦN PHIẾU BẢO HÀNH---------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-----------------------------CHI TIẾT PHIẾU BẢO HÀNH-------------------------------------
-----------------------------------------------------------------------------------------
--Tạo chi tiết phiếu bảo hành
go
create proc sp_TaoChiTietPhieuBaoHanh @MaPhieuBaoHanh int, @NgayBaoHanh date, @GhiChu nvarchar(max)
as
begin 
	if(@MaPhieuBaoHanh is null or @NgayBaoHanh is null or @GhiChu is null)
	begin
		Raiserror(N'Yêu cầu nhập thông tin đầy đủ',16,1)
		return
	end
	SET XACT_ABORT ON
	begin tran 
	begin try 
	declare @temps int
			set @temps = 1
			while exists (select * from ChiTietPhieuBaoHanh where MaChiTietPhieuBaoHanh = @temps)
				set @temps = @temps + 1	
		insert into ChiTietPhieuBaoHanh(MaChiTietPhieuBaoHanh, MaPhieuBaoHanh,NgayBaoHanh, GhiChu)
		values (@temps,@MaPhieuBaoHanh,@NgayBaoHanh,@GhiChu)
		commit
	end try 
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch 
end 

go
-- Cập nhât thông tin phiếu bảo hành
create proc sp_CapNhatThongTinChiTietPhieuBaoHanh @MaChiTietPhieuBaoHanh int, @MaPhieuBaoHanh int, @NgayBaoHanh date, @GhiChu nvarchar(max)
as
begin
	if(@MaPhieuBaoHanh is null or @NgayBaoHanh is null or @GhiChu is null or @MaChiTietPhieuBaoHanh is null)
	begin
		Raiserror(N'Yêu cầu nhập thông tin đầy đủ',16,1)
		return
	end
	if not exists (select * from ChiTietPhieuBaoHanh where MaChiTietPhieuBaoHanh = @MaChiTietPhieuBaoHanh)
	begin
		Raiserror(N'Không tìm thấy thông tin chi tiết phiếu bảo hành này',16,1)
		return
	end
	SET XACT_ABORT ON
	begin tran 
	begin try 
		update ChiTietPhieuBaoHanh set MaPhieuBaoHanh = @MaPhieuBaoHanh, NgayBaoHanh = @NgayBaoHanh, GhiChu = @GhiChu
		where @MaChiTietPhieuBaoHanh = MaChiTietPhieuBaoHanh
		commit
	end try 
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch 
end


-- Xóa thông tin chi tiết phiếu bảo hành
go
create proc sp_XoaChiTietPhieuBaoHanh @MaChiTietPhieuBaoHanh int
as
begin 
	if(@MaChiTietPhieuBaoHanh is null)
	begin
		Raiserror(N'Yêu cầu nhập thông tin đầy đủ',16,1)
		return
	end
	if not exists (select * from ChiTietPhieuBaoHanh where MaChiTietPhieuBaoHanh = @MaChiTietPhieuBaoHanh)
	begin
		Raiserror(N'Không tìm thấy thông tin chi tiết phiếu bảo hành này',16,1)
		return
	end
	SET XACT_ABORT ON
	begin tran 
	begin try
		delete ChiTietPhieuBaoHanh where MaChiTietPhieuBaoHanh = @MaChiTietPhieuBaoHanh
		commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch 
end 

-----------------------------------------------------------------------------------------
---------------------------KẾT THÚC CHI TIẾT PHIẾU BẢO HÀNH------------------------------
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
--------------------------------------PHẦN PHIẾU XUẤT------------------------------------
-----------------------------------------------------------------------------------------
-- TẠO THÊM PHIẾU XUẤT MỚI
GO
create proc sp_TaoPhieuXuat @MaNhanVien int, @MaKhachHanh int,  @MaChiNhanh int, @MaXe int, @MauXe nvarchar(100), @ThanhTienXuat int, @GhiChu nvarchar(max)
as 
begin
	if(@MaXe is null or @MaKhachHanh is null or @MaNhanVien is null or @MaChiNhanh is null or @MauXe is null)
	begin 		
		Raiserror(N'Vui lòng nhập thông tin đầy đủ và chính xác',16,1)
		return
	end 
	SET XACT_ABORT ON
	begin transaction 
	begin try	
		declare @temps int
		set @temps = 1
		while exists (select * from PhieuXuat where MaPhieuXuat = @temps)
			set @temps = @temps + 1
		insert into PhieuXuat(MaPhieuXuat,MaNhanVien, MaKhachHang, MaChiNhanh,MaXe,MauXe,NgayXuat,ThanhTienXuat,GhiChu)
		values (@temps, @MaNhanVien, @MaKhachHanh, @MaChiNhanh, @MaXe,@MauXe,GETDATE(),@ThanhTienXuat,@GhiChu)	
		commit		
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end


-- Cập nhật thông tin phiếu xuất
go
create proc sp_CapNhatThongTinPhieuXuat @MaPhieuXuat int, @MaNhanVien int, @MaKhachHanh int,  @MaChiNhanh int, @MaXe int, @MauXe nvarchar(100),@NgayXuat date, @ThanhTienXuat int, @GhiChu nvarchar(max)
as
begin 
	if not exists(select * from PhieuXuat where MaPhieuXuat = @MaPhieuXuat)
	begin 		
		Raiserror(N'Không tìn thầy thông tin phiếu xuất này',16,1)
		return
	end 
	if(@MaXe is null or @MaKhachHanh is null or @MaNhanVien is null or @MaChiNhanh is null or @MauXe is null)
	begin 		
		Raiserror(N'Vui lòng nhập thông tin đầy đủ và chính xác',16,1)
		return
	end 
	SET XACT_ABORT ON
	begin transaction 
	begin try
		update PhieuXuat set MaNhanVien = @MaNhanVien, MaKhachHang = @MaKhachHanh, MaChiNhanh = @MaChiNhanh, MaXe = @MaXe,
							MauXe = @MauXe, ThanhTienXuat = @ThanhTienXuat, GhiChu = @GhiChu, NgayXuat = @NgayXuat
							where MaPhieuXuat = @MaPhieuXuat
		if (select count(*) from PhieuXuat where MaKhachHang = @MaKhachHanh and MaXe = @MaXe and MauXe = @MauXe and NgayXuat = @NgayXuat and MaChiNhanh = @MaChiNhanh) >= 2
		begin 
			Raiserror (N'Xem lại thông tin',16,1)
			rollback
		end 
		commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end 


-- Xóa thông tin phiếu xuất
go
create proc sp_XoaThongTinPhieuXuat @MaPhieuXuat int
as
begin 
	if not exists (select * from PhieuXuat where MaPhieuXuat = @MaPhieuXuat)
	begin
		Raiserror(N'Không tìn thầy thông tin phiếu xuất này',16,1)
		return
	end
	if exists (select * from PhieuBaoHanh where MaPhieuXuat = @MaPhieuXuat)
	begin
		Raiserror(N'Hiện tại phiếu xuất này chưa thể xóa được',16,1)
		return
	end
	SET XACT_ABORT ON
	begin tran
	begin try
		delete PhieuXuat where MaPhieuXuat = @MaPhieuXuat
		commit
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end 


-- TRGGER giảm số lương xe khi tạo phiếu xuất --
go
create trigger tg_GiamSoLuongXeKhiMuaXe
on PhieuXuat
after insert
as
begin 
	SET XACT_ABORT ON
	BEGIN TRAN
	BEGIN TRY
	declare @maxe int
	select @maxe = MaXe from inserted 
	update Xe set SoLuongHienCo = SoLuongHienCo -1 
	where MaXe = @maxe
	COMMIT 
	end try 
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end
-----------------------------------------------------------------------------------------
--------------------------------KẾT THÚC PHẦN PHIẾU XUẤT---------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
------------------------------------PHIẾU ĐẶT XE-----------------------------------------
-----------------------------------------------------------------------------------------
go
create proc sp_TaoPhieuDatXe @MaXe int,@MauXe nvarchar(100), @TenNguoiDat nvarchar(100), @SDT nvarchar(20)
as
begin

	if(@TenNguoiDat is null or @SDT is null )
	begin
		raiserror (N'Vui lòng nhập đầy đủ thông tin',16,1)
		return
	end
	SET XACT_ABORT ON
	begin tran
	begin try
		declare @temp int
		set @temp=1
		while exists(select * from PhieuDatXe where MaPhieuDatXe=@temp)
		set @temp=@temp+1
		insert into PhieuDatXe (MaPhieuDatXe,MaXe,MauXe,TenNguoiDat,SDT,TinhTrang,NgayDat)
		values (@temp, @MaXe,@MauXe, @TenNguoiDat, @SDT, N'Đang chờ xác nhận',GETDATE())
		commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end


-- Cập nhật thông tin phiếu đặt xe
go
create proc sp_CapNhatThongTinPhieuDatXe @MaPhieuDatXe int, @MaXe int,@MauXe nvarchar(100), @TenNguoiDat nvarchar(100), @SDT nvarchar(20), 
											@TinhTrang nvarchar(100), @NgayDat date
as
begin
	if(@TenNguoiDat is null or @SDT is null or @MaPhieuDatXe is null or @MaXe is null or @MauXe is null)
	begin
		raiserror (N'Vui lòng nhập đầy đủ thông tin',16,1)
		return
	end
	if not exists( select * from PhieuDatXe where MaPhieuDatXe = @MaPhieuDatXe)
	begin
		raiserror (N'Không tìm thấy thông tin phiếu đặt xe này',16,1)
		return
	end
	
	SET XACT_ABORT ON
	begin tran
	begin try
		update PhieuDatXe 
			set MaXe = @maxe, MauXe = @MauXe, TenNguoiDat = @TenNguoiDat, SDT = @SDT, TinhTrang = @TinhTrang, NgayDat = @NgayDat
			where MaPhieuDatXe = @MaPhieuDatXe
			if not exists (select * from Xe where MauXe = @MauXe and MaXe = @MaXe ) 
			begin
				raiserror ('Thông tin xe không phù hợp',16,1)
				rollback
			end
		commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end



-- Xóa thông tin phiếu đặt xe
go 
create proc sp_XoaPhieuDatXe @MaPhieuDatXe int
as
begin 
	if not exists (select * from PhieuDatXe where MaPhieuDatXe = @MaPhieuDatXe)
	begin
		raiserror (N'Không tìm thấy thông tin phiếu đặt xe này',16,1)
		return
	end
	SET XACT_ABORT ON
	begin tran
	begin try
		delete PhieuDatXe where MaPhieuDatXe = @MaPhieuDatXe
		commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end


-- Tìm kiếm phiếu đặt xe theo số điện thoại khách hàng
go
create proc sp_TimKiemPhieuDatXe @SoDienThoai nvarchar(100)
as
begin 	
	select * from PhieuDatXe where SDT = @SoDienThoai
end



-- Xóa phiếu đặt xe ở bên khách hàng
go
create proc sp_XoaPhieuDatXeKhachHang @MaPhieuDatXe int
as
begin 
	if(@MaPhieuDatXe is null)
	begin
		raiserror (N'Vui lòng nhập mã phiếu đặt xe',16,1)
		return
	end
	SET XACT_ABORT ON
	begin tran
	begin try
		delete PhieuDatXe where MaPhieuDatXe = @MaPhieuDatXe
		commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end 
-----------------------------------------------------------------------------------------
--------------------------------KẾT THÚC PHẦN PHIẾU ĐẶT XE-------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-----------------------------------------PHẦN XE-----------------------------------------
-----------------------------------------------------------------------------------------
-- Thêm thông tin một chiếc xe mới 
GO
create proc sp_ThemXe @madongxe int, @tenxe nvarchar(100),@MauXe nvarchar(100), @machinhanh int, @SoLuongHienCo int, @TrongLuong int,
						@thongtinbaohanh nvarchar(100), @dongiaxe float,@namsanxuat int, @HinhAnh varbinary(max)
as
begin
	if(@madongxe is null or @tenxe is null or @MauXe is null or @machinhanh is null)
	begin
		raiserror (N'Vui lòng nhập đầy đủ thông tin',16,1)
		return
	end
	if not exists (select * from DongXe where MaDongXe = @madongxe) 
	begin
		raiserror (N'Vui lòng kiểm tra lại thông tin',16,1)
		return
	end
	if exists (select * from Xe where Tenxe=@tenxe and MauXe = @MauXe and NamSanXuat = @namsanxuat)
	begin 
		raiserror (N'Thông tin chiếc xe này đã tồn tại',16,1)
		return
	end
	if exists (select * from Xe where MaDongXe=@madongxe and Tenxe=@tenxe and MauXe = @MauXe and MaChiNhanh = @machinhanh
								and ThongTinBaoHanh = @thongtinbaohanh and GiaXe = @dongiaxe)
	begin
		raiserror (N'Đã có thông tin chiếc xe này',16,1)
		return
	end
	SET XACT_ABORT ON
	begin tran
	begin try
		declare @temp int
		set @temp =1
		while exists (select * from Xe where MaXe=@temp)
		set @temp+=1
		insert into Xe(MaXe,MauXe,MaDongXe,MaChiNhanh,TenXe,GiaXe,TrongLuong,NamSanXuat,ThongTinBaoHanh,SoLuongHienCo,HinhAnh)
		values(@temp,@MauXe,@madongxe,@machinhanh,@tenxe,@dongiaxe,@TrongLuong,@namsanxuat,@thongtinbaohanh,@SoLuongHienCo,@HinhAnh)	
		commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch	
end
select * from Xe


-- tự đông cập nhật số lượng dòng xe 
go
create trigger tg_CapNhatSoLuongDongXe 
on Xe
after insert, update , delete
as
begin
SET XACT_ABORT ON
	begin tran
	begin try
		declare @MaDongXe int
		declare @SoLuongHienCo int
		select @MaDongXe = MaDongXe, @SoLuongHienCo = SoLuongHienCo from deleted
		if(@MaDongXe is not null and @SoLuongHienCo is not null)
		begin
			update DongXe set SoLuongHienCo = SoLuongHienCo - @SoLuongHienCo where MaDongXe = @MaDongXe
		end
		declare @MaDongXe1 int
		declare @SoLuongHienCo1 int
		select @MaDongXe1 = MaDongXe, @SoLuongHienCo1 = SoLuongHienCo from inserted
		if(@MaDongXe is not null and @SoLuongHienCo is not null)
		begin
			update DongXe set SoLuongHienCo = SoLuongHienCo + @SoLuongHienCo1 where MaDongXe = @MaDongXe1
		end
	commit 
	end try
	begin catch 
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end


-- Xoa Xe
go
create proc sp_XoaXe @maxe int
as
begin
	if not exists (select * from Xe where MaXe=@maxe ) 
	begin
		raiserror (N'Không tìm thấy thông tin chiếc xe này',16,1)
		return
	end	
	if exists (select * from PhieuXuat where MauXe = MaXe)
	begin
		raiserror (N'Không thể xóa thông tin xe này vì còn phiếu xuất phụ thuộc vào chiếc xe này',16,1)
		return
	end	
	SET XACT_ABORT ON
	begin tran
	begin try
		delete ChiTietPhieuNhap where MaXe = @maxe 
		delete PhieuDatXe where MaXe = @maxe 
		delete xe where MaXe = @maxe 
		commit
	end try
	begin catch
		declare @ErrMsg varchar(max) 
		rollback 
		select @ErrMsg = 'Lỗi ' + ERROR_MESSAGE()
		raiserror (@ErrMSG, 16,1)
	end catch
end


go
create proc sp_TimKiemXe @value nvarchar(20), @ma int
as
begin
	if(@value is null and @ma is null )
	begin
		raiserror (N'Yêu cầu nhập đầy đủ thông tin để tìm kiếm',16,1)
		return
	end
	if(@ma is not null and @value = '')
	begin 
		select * from Xe where MaXe = @ma
	end
	else if(@ma = null and @value is not null)
	begin
		select * from Xe where TenXe = @value
	end
	select * from Xe where TenXe = @value OR MaXe = @ma
end

-----------------------------------------------------------------------------------------
--------------------------------KẾT THÚC PHẦN XE-----------------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
--------------------------------PHẦN TRANG CHỦ HOME--------------------------------------
-----------------------------------------------------------------------------------------
-- lẤY RA 8 SẢN PHẨM BÁN CHẠY NHẤT TRONG MỘT THÁNG
go
CREATE proc sp_8SanPhamBanChayTrongMotThang
as
begin 
	declare @XeBanNhieuNhat table (Maxe int, mauxe nvarchar(100), soLuongXe int)
	
	declare xecursor cursor for select MaXe, MauXe from PhieuXuat 

	open xecursor 
		declare @maxe int
		declare @mauxe nvarchar(100)
		fetch next from xecursor into @maxe, @mauxe

		while @@FETCH_STATUS = 0
		begin 
			if not exists (select * from @XeBanNhieuNhat where Maxe = @maxe and mauxe = @mauxe)
			begin
				insert into @XeBanNhieuNhat 
				values (@maxe, @mauxe,1)
			end
			else
			begin	
				update @XeBanNhieuNhat set soLuongXe = soLuongXe +1 where Maxe = @maxe and mauxe = @mauxe
			end 
			fetch next from xecursor into @maxe, @mauxe
		end 
	close xecursor
	deallocate xecursor	
	select * from Xe where MaXe in (select top(8)MaXe from @XeBanNhieuNhat order by soLuongXe desc)	
end


-- Lấy 8 chiếc xe mới nhất
go
create proc sp_8ChiecXeMoiNhat
as
begin 
	select top(8)* from Xe order by NamSanXuat desc
end 

-----------------------------------------------------------------------------------------
-------------------------------KẾT THÚC PHẦN TRANG CHỦ-----------------------------------
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
----------------------------------BACK UP DỮ LIỆU----------------------------------------
-----------------------------------------------------------------------------------------
go
-- full back up 
BACKUP DATABASE QuanLyXeMay
TO DISK = 'D:\Backup\QuanLyXeMay_FullBackUp.bak'

go
-- diffirent back up 
BACKUP DATABASE QuanLyXeMay
TO DISK = 'D:\Backup\QuanLyXeMay_DiffirentBackUp.bak'
WITH DIFFERENTIAL

go
--log back up
BACKUP LOG QuanLyXeMay
TO DISK= 'D:\Backup\QuanLyXeMay_LogBackUp.bak'
WITH NO_TRUNCATE

-----------------------------------------------------------------------------------------
----------------------------------BACK UP DỮ LIỆU----------------------------------------
-----------------------------------------------------------------------------------------


declare @hinhanh varbinary(max)
select @hinhanh = HinhAnh from Xe where MaXe = 1
update xe set HinhAnh = @hinhanh  where MaXe not like 1
select * from Xe

select * from NhanVien

select * from DongXe
select * from PhieuBaoHanh
select * from ChiTietPhieuBaoHanh





update xe set HinhAnh = 0x89504E470D0A1A0A0000000D49484452000002E000000298080600000032AF4DA5000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000097048597300001A9300001A9301F9E44EB60000FFA549444154785EECFD579F5E47B6E6890590DE3B64C21B922040EF8B2CC3B2A7BBE7B4519BE99FCCB45ADF65BE8246D245F7E87E7421E966A4399A9EEE9E3E55A73C8B9EF03613E9BDB700F4FC9FB5E3CD379300C93A458224184F22B0DFEDC29B27D65EB1E2C07D2115141414141414141414143C121CAC8E05050505050505050505058F008580171414141414141414143C4214025E505050505050505050F008510878414141414141414141C1234421E0050505050505050505058F108580171414141414141414143C4214025E505050505050505050F008510878414141414141414141C1234421E0050505050505050505058F108580171414141414141414143C4214025E505050505050505050F008510878414141414141414141C1234421E0050505050505050505058F108580171414141414141414143C4214025E505050505050505050F008510878414141414141414141C1234421E0050505050505050505058F108580171414141414141414143C4214025E505050505050505050F008510878414141414141414141C1234421E0050505050505050505058F108580171414141414141414143C4214025E505050505050505050F008510878414141414141414141C1234421E0050505050505050505058F108580171414141414141414143C4214025E505050505050505050F008510878414141414141414141C1234421E0050505050505050505058F108580171414141414141414143C4214025E505050505050505050F008510878414141414141414141C1234421E0050505050505050505058F108580171414141414141414143C4214025E505050505050505050F008510878414141414141414141C1234421E0050505050505050505058F108580171414141414141414143C421CB82F54BF0B0A0A0A0A0A6AB8A7E1E1FEBDFBE9EEBD7B69677B27EDDCBD9B0E1E4872FA0FE8D8D0D8981A1A1A7C8DCB07F4DFE70D2B3C53505050F05D4621E005050505059F4226DF5B22DE9B1B5B696575356D6C6CA6A6C603A9B1213E9E1E387830B5B675A696D6D6D4DC7450D721D69F4FC00124BC10F1828282EF2A0A012F28282828D80386858DCDCDB4B6B691C6C727D2C4E4549A9B9B4FCBCBCB22E007535353636A6E6E11F96E4B3D3D7DA9B3AB2BB5E85A5353433A28528E6B6C6C1421D7B9C83AE74D9C3736A48686265DE3B9037BA4E639DC8C42CE0B0A0A1E6714025E50505050B00777EFDE4B0B8B4B697C6232FDF18FEFA4F7DF7F5F447C3CCDCDCF9B58B7B4B4A4DEBEBED4D7D79F0E1F3E9CFAF5BBB1B15904BCC98EFBDD5D1DA95D04BD41A4BBB9B92975B6B7A58E8EF6D482C4BCA5D55274F1F2D420225ECFB5199220ECA090F0828282C71585801714141414ECC1D6D656BA71F376BA7CE55AFAF5AF7F9DDE79E79D34351D52704BB745B27B7A7A526F6F9F08F8501AE81F482DAD22D722DE0D0D8DA959F7DBDB5B539B0838BF5B5A45C83B3B52676767EAECEA4E6DED1D26E5CD4D90798E4DF2B741241EF20E91477A7E700F310F70E17E21E6050505DF7A14025E50505050500343C2DADA7AFAFDEFFF907EF7873FA677DF7D2F7D72E1425A5C5C482BCBCBE9DEFD7B7E0E15140876FFC0214BC2BBBB7B74DE9EEEDDBB273FEE0551AFA4E5ADADADA95DF73A45C27B7B7B74ECF2B58E8E0EBDD7953A756C6E6E4B1D22E87D7D3DA94BCFA16B8E74BC1E106FB87721E0050505DF7614025E50505050B0072B2B2BE9BFFCEDAFD2DFFDDDAFD3858B97D2E5AB57D3F2D2525A5B5D4977EFDE35C9860423ED6E177946AADDD7D767128E0A0AD721E148ACB19002116F6E6E16E96E49EDED6D26EE4D4D3A6F69D5BB9DA9A3BDC3FAE4DDF8D3DF977ABABB75AD25B53437D5DECDD274F4CC0F40CCAB91AB10F28282826F230A012F28282828D8839595D5F4B77FFBCBF477BFF96DBA7EFD66BA79EB765AA824E026E026E138D4419086375B128E3B74E850EA1281C6820A247C67279E858C07598E30E2FC40E88C57041B093824BE5BEFF7F6F68A9077A58E8EB6D4DBD3637F517B696B4545A5C1FE677594F037FC2B282828F836A0E1BF15AADF050505050505697B7B3BDD12E91E19B9E3C5984B4BCBD60BDFD17520AA6B1384F05D643848C4F5C3EA29A89E4084392209CF0419B21CEA297184C8E3767676E4EF96FCDF4E9B0A636D6D35AD6A02C024607149612F2EDAFACAEAEA9A25F3CB2B4B9A08ACA4359DF34E90FB3A02CED1570A0A0A0ABEB92812F082828282821A181256579180FF2A24E03742020E1186005BFA5D1B36EEA7BB22D05CBBAF3FD44550476171E6E0D0908F981F84186FF3DCBDFB564961C125660803A1532ECAEEE7EEDFBFEB23E60AD9E4A7B9B9D1FAE348C7BB2C21C775A73EF9DDDFD79B7A7BBA528F1CD790C4DFC7278838BF7C2C282828F8E6A148C00B0A0A0A0A6A80B422EDBE757B388D0CDFB1E9C17939A4D33B7210741CCFD513DCBD52EDED9074DFBDE7EB19070E04C9CEEF851DF05DC9750DBC2B77F7EE8E093EF1D9D8D8486B6B48C1433A6E29B9260ACBCB715C595DB1DDF2F58D4D4BC521FAB81CD7828282826F128A04BCA0A0A0A0600F20B8FFE56F7F997EFDEBDFA6ABD7AFA71B376FE9DA725A13D1BDBB23922D528DA207BC9621045DEFD00BD751E7A89FB0C092059AFD0303A9A7B7CF2608B19C92D550908043C81B6C6E30887926CDBC0FEAC9731EAAF2732CC8446FBCBDBDDDD6547ABA3B537F7F9F75C58F1C399C8E1F3D6CAB2B857C1714147C135124E005050505057B80C4F9DAF51B22DE37D3ECDCBC75B1B9866E386A24106E686D76FC17477E1C485065A4D09660FB186A2B70E84CA4E318D2F438DA0723487396B267D594789FF043DABEE3F820F15EDB58B7DACCEADA9A8EEB697D7D43F75079B9E7459EECC099FD2884BCA0A0E09B8010331414141414145480A86E6E6E8AD0AEA71D115D935693E7EA018313D44B7022B6D5A2CBA6E6E6D4DCD2ECF3EDADEDB4303F9F2627C6D2D4E484C8FC4CDA1059B6A4DC243AD456588809A1F682CC9D6D91E758F0C935937D858FD43BB6C06FB2AE379BF6E846DAD2B358679999994D2323A3E9D2E5CBE9FD0F3E4A7F78E7FD74F1F275ABA898E217F25D5050F00D4221E005050505059F824932045847886E0DB0F060B426B5385F134C944DC44395E440C341FB0399C78EF8FCDC6C9A935B5898B7B5138836043CFC09529E49F88EAE07410F921E12F42C150FE730236047098938D6526667E7D2F0C8881790DEB8753B8D4F4C8BF86F465C0B0A0A0ABE012804BCA0A0A0A0E053084A0BE1DD25B9BBD825B2705AF3DAEA12C4D826081B1B5343931C92EAFB07D2FADA5A5A10F99E9E9C48D35393362DB8B9B925B29D09F8AE7942AEE523AA24F91CDD739EC9CF035B4AC196784B8BA5EF0745FC519799999949C3B787D3858B57BCADFEDAFA46A4A87AAFA0A0A0E0EB4421E005050505057B00896E14A96D15A9B52DEFEAFA831164983F10043C24E08D7A97E3C106869AB06AB2B1B9E1059D48C117E6E7FC1BB514883652F05D221E643CABA6600D85DF712D167C1A15A1268E848D049E233AE8CB2B2B697474348D8E8DA799D979EB87E36F21E10505055F370A012F28282828D803086C4B734B6AEFE8F422C6CF025CD684560EA97926C18D26E010F15049C14678838839C419C28D3ACAF4F4A489380B285147C9D26D505BC4F91012CEB3FB1D4002DED8D4E8F0506541123E2E023E35359D1617976C8FBCA0A0A0E0EB4621E005050505057B000946073BAC9E881457D76B806F73F08DB82BDEEDFF3842C27135551439A4E25834E1712C9940A6373736D2D2D2629A9B9B3311472D656B0B3BDE10F1F01FB26DF25D27FDDE4FC0514DC9D77809FBE2583E01E89F63CBFCF6C89D343631E973401A8B24BCA0A0E0EB4221E005050505057B003185A8AE54DBBD9BA6EE27AB750416D2CD7F07BCBB252E4838A43B24E141C0F580497810F48326CECB8B4B69667A4A6EDA241C138290E90C13EC3AE2BDC7D5916F9C77E4BC1F9270ABBE283EBCBFB8B49CAEDFB8958645C2D7D7D76BF12E24BCA0A0E0EB4221E005050505057B0041468583C58DDE28A7BA1E647597B09A7867F8242E64628BC32FC8B09DFCC43CA1E8B7AFE767C37AC9AA08F8429A9F471ABE505949891D35E3B90790714BC643F29DC343C71BF595B8166941BD655EE47E7C7C3C0D0F8FA4C9C9C9B421A21FA84F44414141C1A34121E005050505057B0069C5AA486747BB75C0335986D10621AEACA3E4EB75C844380830D2E85045C97AD979974B00118798E30F7AE18B22DE3333D3697676BAA68E42584C023806010F121EE60A21E148BEB3CA0A043C5B510952CE0250DE5B5D5949931313E9CAE5CBE9F6EDE1B46649B8A351505050F0C851087841414141C1A70029862CE320CA01586E10DD4C5E4DC2E5E299906CD713F3B81D44DB0B311BB18A823A4ADD33D57B10F6D00B0F9BE1F373584959B13A0C7AE33C99C97DB8503909621E52F1885B9E00B03034C2E1371B0B8D4D4CA5B1F1C93437BF98D6D86848449E7B050505058F12858017141414147C06CCA0E32888DE5684359356D3E738FAD120D326EED57B711ED6499A1AD91ABED1CFE28FFDD2493659B8B3BD6369F5EC2C5652A62C15476F1BB21DFEF14E26E0BB443C2CA5A07AF26932CD5B2CCCDCDCDA4A933373696C72C65BEC2FAFAE26B6CAAFC5A3A0A0A0E011A110F082828282823D808B86F43BCC08425ECD7DF760EF05EEF3DCC10395D4BCB6E032DF0F228E04DC9270EC8BEBB9DA031075FDA132C2624E08F5FAFA9A75C23125383F8FB9C2154BB9B35FBCBA4BC6834443C6BD8B661D4107C4E9BE9E6147CCF9F985343C329A2627A7D3D6E696E300FD7E9C48386921AF5844CB8647A4DB6E73D31B15ED3AB6FC8FAF057C0DA87F8E2F0FE8E1E34F4141C1978B42C00B0A0A0A0AF600626B02DE802511087510DEB8B74B7EEBC129D7E25E90705CDC0970CFA4DE045C47DDF75D91BF20BF10F4466F02C4B3104408F8D4D48475C31797166DC73BFBCFF310EF20D9E147E885EF582F9CEDEBB9C7F5783EF91EF6C06FDD1AF1063D10CD1CFEE346C283506FF80B023AEF766BE120E538F4EC99EC906ECEEB9F8388732DABF61414147C792804BCA0A0A0A0E053806F65326D4935D7FC7F5CE73E1AD6719E9F95CB647D97771B99C04184918043B271907C3F5F07CE6B045EAF6D6F6D7B51263AE17333333657C8A2CDD0010F7F21DA10C52CF5E61E660977CFEFD95FC246AA3B3B372B023E9186EF8CA7A999794B82BFADD8957487F41A538E106874DED9FD33DC5A45BE37D28ACE979757ED969656352159D1E466457EEC28BF551672F72B77F72EC41C22BFA57CD3C446F98D23DF0B292F28F8FBA310F0828282828287C2A45A245CFFD5087800A256FDE43724BA7ACECEF83441835423E5C6BA4A5373B355526C9AB0F68E7DD373613F9C67217AE885CFCDCEA4C9C99086AFADAE5AC21BC185BDEF20E441BAC35A0AD7823066358AA6A6663D93443A17D3D8F844BA7E63248D4D4C5BDAEE1BDF4220F5B7A45BE41BE935F6DBD9867F79652DADACE937E7CBFABD82741B02BE96161697ED20DEF30B8B696E7E216D6C6E29DF3529C21D6894CFEC5CCA97881D937608F87DE52D8E3C2D2828F8FBA310F082828282823D8010B7B7B7A5DE9E9ED4D2D2BA4B8E45BA2CF9F45FD0EB7A1A16641D1724DAFFFB245F0F69BAA5E01070B96691709B3AF4263E823CB4F542A0772C09470FBDDA546743047349E47956647C6E6ED6F6C321CF591ACB217E475C4DCC2B4978D60BD755476D5DE4747474348D8D8D591ABCB9B91DD25DFBF4CD05130BD28C447B695944DB6E55041B1792EEF575544BEE59D79E3C6E6D6BB56949FF6E6D4D1D1D1DA9B3335C5B5B5B6A696EF58487E202BB65B9FB35624B041C4938F9B4BD4D9E7ED373AAA0E09B8B42C00B0A0A0A0AF6808594DD5D5D69606020B5B5B6988465621CD4D6F4D6CF66D413363F5FB9DAB58AC4B15013DDEFA6C62086CD4D41C0B9675401D87FBC10F1465FBCA9091BE2074402B74436972D0567F74CB6B2DFDCDC10D9BEE7FBFB91A5E1569D1011DFD989CD7D0813BFC6C747D3C4F8B8F5C2B192F26DD07746671BDDECD8BC68312D28EE1071D44920E0A89C40C0C9C2564DA0DADBDA45B43B5387C8767B7BBBCB96C9555F5F5FEAEFEFF3EF2EDD87A0530E141DE0C8225C9B90143947D2BEBAB621122E02BEB56B6BFD9B9E5F0505DF4414025E50505050B00FF7D3FAC6866D70C7A247C818FFF99F11C73AE2A5FB7BC9762CE0B44E789D33099733A9CE245C0EDD6C93F01C80BCDE43EC2A7F1BE42F8F60AE90DD3217E6E7AD1B8EEDF0B5B5359353DECB8B33B31FBE2697F5C401841CD58D99D9D974E3D6B0ED83436CF5707DCABE76106774BB21D9B3B34AEF7C906E74BC1D5FE54863E3EE170524DA1D22DA48BA73FEB6B4C44407339048C5C9FF282F08779489CB18DFAA72CCC8E7BC43B9121EF90B21CF9270F237BB828282CF4721E005050505057B00E1837CCF8AD8B2B0CF648C7F48982163D573F5E01ACF05C166B31D1DAD3AB2D76549B8A5AA10C28A2036358B18B2490F6101781C12F74CE82ABF1B9A76F5C221A59827441A0E09474F1C52089088E3C22339C861A5825223E0BAC682CCB9B98574F5EAF5343C7CA7466879FE9B822DC5910911D2EE89C9A9343D339B1617975546EBD6CF8640A3528243C28DB4BBB7B7D724BC5979DC42FE42D0956F8D90E8BA3CC65ACC7E44397E9A8433F9C13FA4E2E4FFD6D65DE517F6D7C9D398F414125E50F0C550087841414141C11E4092DB5ADB52575797C93184B446C62057F02B1DB992291AF7B38E7710386C8887141C9596B8AFEBD5319E391852DB9696D42A8794F6A04878CDE3EC39A8E774BA6E89BA8E906AF4A1575696454A17ECF8CDB52CEDDEEF3211C77B24EF10DCE999192FCAC4B12011C9FFD7B5D0103BE6984744B77B6676CEC41B1519261C58253978902F07CAB3D6564BBBEB25DD76CAD346E563CE7F51E2CA67E55B2DFFE33C13E6DD32C9F777CFB3B33A0AFEDA6F26527B25E1E8886FE99855530A0A0A1E8E42C00B0A0A0A0AF600C2DCD9D5910606FA4DF020627BB18F5CD593B54A9D211C0410575D17E5AD277710760830125A167BE2383FD0A07B7A87112AA4EE04A2304DEAE4B825FFAD46A1FBD8F666931ECC13B2853D7AE161DF1A32984978A8A084A436483871686A6AB114786E7E2E8D4F8CA7913B63963067B3845F079144BD065382F30B4BDE2C6866664E047CD1049C7443B2631165A71D6504E9CE8E1D47BDA1512E3625C192EE2A292E8FFAFB150E2ADFEBAFE7F33D4EEF9ADC37C6A48AFC817CB330736B1373889AB85492F082828287A310F082828282823D40BAC9C2BDDE9E5E4B574D74616522569060932B8E10D94CB474BFA65E521DBD33A67F579270B91AF9AEC8386A0DA8A2B4B6B6A556AC71B4B4582A0ED1330FC4FB2A8838E87A3E773CE23AA41A7592D5B5555B4961039FA56516566EA69DBB3B41C44542D97A1E096D26E656539187C40D5BD9B76E0F7B831E16326276EF518074D4BB95D5D53439C502D3254B97C9BF9696B6D0ED46CDA4CA2788B875BB99B4E47C95235DBC17138E90F6E7F402AE47583EADC1C4D9E4B9BA5095514C5AE222E720CA33C8380E726E09B9AEA3920229270E84535050F06914025E50505050B00790AC7611BD9E9E1E913E08B888B3AED7489B5C268B76F192FE05C9B6EA83CF917C67122E3F2AC7B338DFD3B32C206CA957A7686AF6F3817A0217E48FA38922AEBA0220993653B8B46813858BDEB06723C8281BF378739E20A335A76B00D28F9EF56D11F03B77C61226FDB26E337854449270087B6C6C421388659F43B4BBBABAED90783351B1B4BB391C44B81EA42B6F310FEE699281ABA541877B771F901EAE57E9AD07F98C547EFF3BA8A2343685C34A4D938E0D0D6CDE835A10939E08F351E55D41C1B70985801714141414EC01C419096B7B7B87C85D8388286A05485421742253F03D3D0399F6D6F172B64E02A1D6B54CC2B3CBD7F2D6F64849BD0D3DAE0A8FEB26E22DAD369DC76FD456E06E21A9266619BB71D80FC81E0494C5A32C2445120E11673B7624E4B159CFAE54D8DBD65792617EB391CDECDC7CBA3D3C9AA6A6A6AD1F0E88E3970DC2B5D47E75CDBADEA3A3E3E9E6CD5B3E67F2D3D3D36B3DFC907A2B5F5A917A37792125F121AD4C2ED019B78D739D9BEC923DD5FD4C7E7DAE3FD21CF9B99718E7F3FAEB91477C21401D85895310F4FAF7F6C39330266C2A4F9ECD9398CF7AA7A0E0BB8842C00B0A0A0A0AF6E180881E04BCDD840A550C489E554E6077BA1FD26C748121E022CB902E91BCECF693703BAED9ED92720039E31D9E215CA4E158EDB0B45CC1218175B03C5BC5C06CF00130D1947FDB6C54B32A023E3B6B12BEBEB6AA746C890C0601E50819F5E482B4E91DAEEF8810CFCF2FA49BB787D3F8C49409F257851C3E8B2DA7A767D3F0C89D74F9CA356FA4333438940E0D0CD89A499737CB61D16545C01B3105C8FB489AB74DC2F1AB46726B59A33479D2A4C15EE508F648C23F0F64BBF29E3C6592A517FD05E161AF7319675514398837AA2845125E50F06914025E50505050B007A834B4B636A7EEAE8E3478A83F1D3D3CE40D7976EE06190D4B188D361D68AB1B2DD8F186843798646509EB03897845BE4DAE618A7A0664028EE4BDA60F2E326EF5973AAE2D7AEF67B916C7DDDFFE51817324C2DB3BDBDEF1727E61DE8B34918A231DB764B77A0E647D76D2BEBE1E3B648E8E8DA6B9D9B9C4863710DC2F0BE40FC41EEB26B787476CEE91490EE91E14F146F7BEADCEB2095F21E0AE4C1488774DE24D9C4D79231D99E446DEFB72408F700DF839FDE532FA4CC88FAC8BCF5703DEF579E577A8F33CD89F7836266545125E50F06914025E50505050B00790A61691EBEEEE8E74E4F0603A7EEC4810F09D1DD3BD8322DBBB5BC923958D859348B7B95F4FEE8280B3F14B38483A92739B2CAC278902CF4238D105878042C621EC668275E08C38F27EB8F8B1F7A9007159DF58B7141CBDF06516666E6EF8FA5E9218EA35905DEE8F8F8FA5F1B1B1343B3B9BD656D9E0E7CB5B504858E425C4FBD6ADDBB67282DFDDDD3DE9E4C953DE8134936F4BBB153F2F6C44DD44EF658977966E93FCC0AEC4BB1E26DC7F0F49B8C9B61CB0FE37D95C9DF32E84FA2EFAF5D564663F781F9DF022092F28F8341AFE5BA1FA5D50505050506098D45680086E6E6C58720C71860462BB1B7DED5089A8D44578C7C4AC92CE66A2C575FF83347FDA418233118EA3DED1ABBC4F58A1B7ED0BF6ABBA6D3FABFFAA9F71AFE6B77E7B31A88E267E104688ABC9370F864A0CA41297178E120CCF30A9004C1A5800D9D4D4ECF778E6CF4126DC192CAE9C9C9A496C1B8F5D6FB686EFE9EDF5024B74BDF9BAE07855E14072B14BEE34D839A942954E3B3FFA50D4C7D97929E4771F04AEF3147721D0BE5657367C5DF0352EE8DF6E9C04FD260CDFE359BD9FFD00B9AC0B0ABECB2804BCA0A0A0A0E0814025A4BBBB3B0D1E1AF02246B67A473F190289BA04926A48AA6D77F38248176433935C1CAC0CB2F520574FBC77AF55245C0EF686AA86497826CEBAAAC78C5D4A1717E25EE5977ECB17FBC50B1042486CB68AC23348D7D98913C97C63C3AE4E7AE080553D9656564CBC0F0F1DB6543E5462AA087C41901F59979C305870796B78D469F2AE957D7DA9AFB7CF16679A9BC38637CF1167882B0B41D958C8A8D2C76401E409C667219E8F0D7932F906CEA7CA9FFDC8D7EB1E8F898A2EE38775C32DE13E680978AD6C748DDF08DCF183D7B3AA4A462EE38282EF320A012F2828282878204CDC44944C5045B221E3904924E19030766BE4BEC914A44CEF989CE92F93BB4CE4B8E97B62669686EA373081D4FB39AC6C331C493BC04C20040E124ED8F68E77F8D333718CB8E6B0F26F9F57D7CC0E89194451D70837DB1F47DA6CD258C5097F8907D8DADC32F1EE1251C6F41F76B7F322C8CF0371666B7B262E2BAB6B5667C1C6F8DADA8688764BEA517EE62DE351B7C15FA24BFE58CDA4927C9BDCEA865DF50722B691DECF42EDF92A7D20FBB59BE6CFF183E73301AFA4D9515E5CD0FD8A54DB1B9EADF74EBF5D47F8A9DF8D8D559D2928F80EA310F082828282828702E28594FBF0E1C3E9D8B1A3696D7D2D2D2D2E7967C6F9B9F9509768102185C8C999D0896441C8320B0BE21DE437886EBD3454A4CDC40DD216C42C3BAEF11E241CD21F6A1CE1AF9F8580FB94F3080BF0DB046FF7929F05840F63240EA40B137F3CCB2248886FE82D63D3BAD90B1D5990C9E423B67D873477F9BC3EBC8701A9355F0E20DF6C257F67742C5DBB7E3D353634A593274EA4BEBEBED4D3D36DF29DD34BA421DFB66E5249CE737AF687090DC6F9ADCF898F525CFDAAF247F9C135F257B9F7B9EF73BF46C02963AEF99CB8ED8D1F077E43D479D412FD869086F344B692E2B0AB770A0ABE6B2804BCA0A0A0A0E03311242B483136A83BBBBAAC3E0129DE1651C44A487ECE4E840CF215BADBDC0922C67F99BCC57D11724BC4512FF103BE97C3B384DB042D74C121E241EAB244B82ECC3889DF0F20949C131E527408213AEC9D9D5DB6B50D11CF9279C7498E7806394562DBE0F720CA9066ABAD3C801067F03EF15DD0246572622A2D2E2D8B886F28EF1A536F6F5F3A727848FEF4D68837205BD8EC868940BD65911CC6A7C2AA3FF5BDFC5C958BC4FD21F1237F94BA5A18F578E83BBACE3B0E49BFF373D907CEF9528197353FFC5CFCE47A26E4844B5E873F71BFF64E41C17704858017141414147C21D424E1478FA6B5B5D5B430BF90666667D3F4F4B4172AA2D261A22EE20C61458502D20632F132CD32010B329C554B20675C3729931F61B630545FB8C6736C29BFB3B36522CE3524AF41E2E46B7584CEEA97CFEBC13DC267B31DFC6E6B6FF7C24A544008C3E6FD740F8933926F934D79D1D8D46862B9BCB262BBE8834387BD15BC75B5F7859191FD999E9E49B78787D3D2F2AA554906FA07D2934F3E990606FABDD8D2E4DBF10A3D69DE61EB7C16387A02C29FEE3B7DF57870B0D5B391CF39AF3FF5EE4310E4FA016155C8D789AB25DF72146D26D2E0AE4D0DEEEA8273997B31D9DA752C3CCDFED87E3CCF3F24DC8282C715858017141414147C61409470907174C2BD15BA08F7D6F6665A5A5C3491B4850C3D63938356FD805CE99AFEF9A76033782263666272DCE27F4B4771969E0709E6258EFC0CB21E6A24BE5349C94DE0E261237E552FF97DFD7038F72DD126FE90EBACEB0D09CF8E7720EA107EA7A792D0A3AED2D9D19E9A5B9AACB78D1A05B0DF429E50A06E323131919645BC8913BB59F6F7F7A73E6FAAD3693BEABC03D1F7444561E49D2C81556B22E2017ED6BB7AC42BB57BB553F96F579D3F08DCCD71DF8FCFBA4E18F577F9EDA8EB874935933013F0EA29E2C17B2ECF503FA15AB8AC294BDDF35A80FC7C41C1770085801714141414FC59C892F013274E984CEDEC6CDB66F69DD13B26AA102A882CCF058258F397495656F30071AF22645925A5928A23ADCE7E414C2DA116C9B5BA83FE2C29AE4838E1D65338FFE69AC30CE208420719097658F0200CA4DBB110B2D171DBD888ADEBD1C7264DF8816D7424DF1DED6DA9B7B72735DB2C21FE47DC21DF1B1B9BDEC2FED6ED11EB7023653F3470C85654B07892C93708A97B10F09C1FE15F5D2AEA7E7E0A3941A0FE15BDFF45ACA3907E5C3D5C46FCD5C7A10EF93A4597C976562D419A6D72BDEF5D4EF3358E3C0341DFDEDAB16D737FEDD0390FEE7DB3A0E0F14521E005050505057F36205238D44E2099904B542C0E1D1A48AD22B25B5B9BDEFEDD44CDC46A97D499704336A15B5C9333F9AE48685EAC6975051D9112731ED2E220C4F95931C85DBF2BFF7711F77CACEE392EFAE9F0451E21F6D9967990F9781629B9493A0453CFA2420220D5AD2DADA10BAE77218FC46963632BCDCF2FA6C9A929EBC4F31EFADE48BEBBBA3BF54EB3C92E5126EE7B77B30CE25B4575D765D4FFE6E17C5E7F1D54E739AD84E5A3FF8F6BD5AD1A1CAE90DFD98F875D0751567A06229EC3F4FFF19E2749BAB01B9F28774019F293B3B8CD7F0F988014143CA62804BCA0A0A0A0E0EF05A4C5870606D2F163C7D2A1C143697070D0B6AC77B6B7D3DCECAC1D6A28584A094B274166EB615D61FD9958CBED92EF4A471CA22AB71F961C435EE16A720F256EBEB77B3F9E0969356123F5C6E20969E11EC49949459686135DC2DAD8DC485BDB5B696D7D3D75B477A4C34343D6056F6969B2147775753D4D4D4FA791911193CB20DF3121214F90FA92F64CBE71F584F47311D1DE454E6A3E6654E7D9DB3DAF38FDD5491DFE3E927010E909CB3148BF2D0997CBEF649DF0AC5EE2B4EA5FD601C711469071F95349C6C167855B50F038A010F08282828282BF089025ACA3A023DDD7CFA632BD26D3A870405C5757964DACE3E1205D41F0388FDFFCF305C85A753DEE09FACFAA2926E33BA19F2D574F60EB1744DA1BFEEC45F8937F3311801412372606A17AD22A128EEAC97D2F82C4F6F7B6C8B6D55D20CAFA0B558B7B69736333B534C776F9D8046717CB99B9B974F9EAF5343737AF27EFA59E9E1E4F463A3B3B12BB889A6CCAEF9834D449EF0187DDA8EF3D7FD831E3F3EE83EA5A26D8E4C383401A739C22EFAA07AB683E8C10D7F2D5BF237FEBAF71B2F75A58A301F5849BB0999450C6E435AEE0EB41AD6EFE3D505F4FF0A7FEBC602F0A012F28282828F88B801A062A28487B8F210D3F74C83B4E2E2D2FA5E9A929EB4433105B473893ABDA20BF6F80E614A256390671089B5D45D03281CD2E23FB145E546A117512553B85CDFB985044C2DDD1D16902CE6F74D9D93487B863C33B4BDE59A8D9D4D8E4FBCB4A53D67586600F0D0DA6B1F1C9F4DEFB1FF9DD0EE5033B871E3D7224B5B6B6F87DA278EF6EA8D3B0B0B316E37A9E4334F79FD71F331E76BEFF7A86AE3BDDD50364C9E7214BC43329F7DB0F7831E7694626DAFECD3D24E3BE5617B65CB6038F9A8F25E70AC39B0E79C2837D76F4FEBFD86647055F0E723BAA6F4F7F2E28E7FDEFD7D78F82BD38A0CCFAFBE77641414141414105861348EBF2F272BA71E366BA71F386DCCD74EBD6ED74FBF6709A9898F4A6346C3283051224D026C9FB0669085F8DB8C97137ABAA1006D2EF6D11641F45DAF23096BD31F9E38FA3FDA8AE412CE52F24784B049CCD755015E9E8ECB2441B6935BAE010CF90B687839CB37325BFD16DEFEA42DFBD3F9D3BF7747AF1C517D3CACA5A1A1EBEE330DADBDB74FDA9F4D2F3CFD9D63892EFB07252E9AE57E4B386BA119874303980943ADEF5E0B9FA4B7FE639F94C36E16DDC8A9BFB8301BEB7EF3AD76AF9F900F83AFFAAFBF16C1CB3651C262D802F01A4354BE54973CEA3463DD3D6DE929A553F1E1656C15F86DC5E28B03CC9A24C70AC5F58551B05D10EEABED6D48176E4893450311D3C181B72F1758885CAD8BC6712E54996DA2E7EEC865A1DABF28DFAB87BFE5D4121E005050505055F0920C7B37373E9DAB5EBE96FFEE6FF977EF7BBDFA591913BDE98A6ADA323358B009B807B18DA1D7CB9E4C158048D63ED5CE05188307AE67622E11038909FCD88F37099D0E382F0DD4D2CA26C6FEF10E1EBB02A0A8B49511F615864074B6C9DAFACAC985840D033E170F80AF7E4C993E999679EF576F6906BAE21257FE985E7D20FBEFF86176B12B5D0F9DE510A83F07C0AD5A51CAF90B0D74980EB5FA94B5F0D7F8FFBC425F223CE1F0408B2F34B9306F2249F837CCCD87F0E6222A1F46F07E1868C3191826C3331C9C83AE00092DEDCDC909A44E21C3F5F2DF8B211A63EC9F398F46D6DEDA8CE6FA689A9A9343333EB672813D7E9ED58809C413BF004BAAAA3362DD908F16E49DD9DEDA9A3BDD56B285A5B9BBD46A249E54E78B98C2957DA3D47AEC59793286B9FEBF77701858017141414147C25804CAE6F6C7831E6E5CB57D2871F7D947EF7DBDFA74B57AEA40D76D1D4C0EE8157A42C2C8E60A2AF8ECC7950E642DD3501A95C906F48B808380451D76310D75FEDF53CD00711E4BFEC0FA4C31271113ED450D8900769388E6BF80F094722483A182AC3624A734558B66AF6BD0F1D1A4C030383F2F5BEAF0FF4B3DBE5A0B7EE3F7EEC786AD67B59F505BF484F4D7A08AA51983078264F16782E5FCF8B1BEBAFEF41FD485E7F7FFF08EFD777F3A13A3C103CC7BF7AE477F3FB19395E5CCDAC827C44FA69292AE7FA0DF61370DECD69073CA7A271D9B1853DEA3F597A5EF09721F2F97E9A9B5FD0E4783ECDEBC88EADAB9A6832D95C5D5BF7AEAD2E0397311356EA1E6F47F971CF75B4AAC33C9737CDB2A94E91F3BCB099B51521051769D7915D6431DFD9A6C9378B933B3ADA3DB9C54A10A43E42208CC7BFBC0B012F28282828F84A9109EBCD9B37D3FFF3FFF5FF4EBFFCE5AFD2F8F88407FE206698030CAB23563589D17E173AAFBFC662C890CCED12F018B9F51C7F7E3E88414D6A5B9DFB29DF0FCB2B9B8A175BD263D77C60E050EAEBEB37C96668444F1CBDEEF5F5351F91F041BA233D9B8E037E9C3A753A3DFBEC738E3FFAE3D93DFFDCB3E9FB6FBD917ABABB454C5A6CCA90AF02848D3DF01A3E6B14569421B08483C4B1464C22297B51EF0FF71F729EC9550CFF394F7C78206A9270A51B093EE7FB0912F7B3C41B824D58F97C3FF2FD0C9EE3029272EE85C41D328ED4FCA0D57A98C414FCE5804C530FAF5DBF95AE5FBF996E0F8FA4913BA369616E262D2E2DA8FD3109C604A708B35C434393CA276CD7E31E04AEF37CAE13AE0BFACD843A88391B5F899C8B6477B477BABDF5F474A7FEBEDE3434489BEB55BBEA10116F89F7AAB01E16DEE382B208B3A0A0A0A0E02B470CD20DA9B3A3339D79E24C7AE5E597D3D367CF9A886EAC6FA4D5D595B4BCB464DDEE9AF51111C4DA400C61AB1C24C25255EB5587743578A49EE560C4AFFD4378F6CF26112B22DF24E28C3E388B313902AE03487548E67907B59AB8CE2776083964BD85771409880A6A2C3CCFFBF817A4E480FDC58F4C66910067D50E62CDB50CAE0539DE9B22FCAA7FAEEE56E44D46BEFED023AA3082FECBFED57BFB2040BCF903BCB3271E02E7BE4FBCE3B1DAB9D3E277E27ABC1B0FEDA635CA3A9338C03975264B50F78759F0E781C90D52EFD1B1F174E1E2A5F4C92717D3C4E4645A5C5CF0D79EAD9D584F912D16B98494E50FCAF5BD65C13BF1050347DB252CAB5EC94F26DFACB960732B24EC4BCBCB697E612ECDCCCC382E7746C7BC3E647E6151FE42D66383ABFCC5E4712DF722012F28282828F85A70F3E6ADF43FFC0FFF8FF41FFFE37F4A57AE5C49D3D333FE44DD04B99583E4E220618C5479B88220DC13C145AFDADBC5735D83B487697E9A35044964EC8E63BD0B691DE60C5191696B6D4B7D03D8EC3E6475124837E60E59900971664280041C7514F4C2F9648EAA0ACF1904221C3F7E223DF5D4D336BD383B3BE3CFEC48BF9F387346D79F4C1D6DAD26FB9094ED8AEC0024C0D6A78D5313189ED923F1CE20A8EA39E341E75F14D57B4174F6BE5825E981F82C5DF08CFAEBA49373A4A47CE1C8D72CEDC629AD5CF71710DD4612CE248B3FA4B0E8112309FF545E147C6150D5907C5FBF712B5DBD7623BDFFFE07E9E34F2EB81C5C16B4294D08291D1C926BEA1FFADBB5099027A251F6D9E5F7F962C131835F3EADEEABD1FAA862F5F5781E973C896563ABD3A7CFA437DF78233DFDF4939AA8332166F7DB08E77144918017141414147C2D605C6D6B6F4B478E1C4E8343835603191A1AB22A08BFBB3A3AD266A5CE91077E466C0FE410063B4679FBB6F77F7E70A80670BF8BAB60AF74B43A868E90ECA6E6A6D4D3D39BD0F546828DFF9061DE65620021092F0EEC91D243CAE7E7E74DD09126324140371CA2BAB2C26EA099E48888622D426492CFED90F190EC8A74EB1DFBAC939A73DC76E35CFB591DE5ABE3E8A72262BBCF90B8BA571F785E43DDFB15F69D1A7BC211723C1F045FE79FD2E00952752D137090F305C73DF2C2FAC5FA0D19645B7FCA21748A8B5594BF04D415263C906F24DFECD8BAB4B414F9CDC4268ACB7536EA6445B4F547F179112593229757F671179CEDA95219F623CADEBFED7C434754CF82E8E7F6861E387142271C339E85801714141414147CC940BA8C2591279F7CD2A49B9D23BB7B7A4C8221E248C66667674D146AD2E04A7266B37E26030CFBBB0374FC62B0D73F4EF200CED1F776C175247D48BB518141DA3EA87021E0106C1CC480B0B1EF9D25DE5CCB8B33F16345EFCECE4EA70591F0A9E929EF94499A30EB363D3D6D3DF32DF9451C9A9A5B4CBE3B3BDA6C139DF79944E01708F2A3B8564495DF8EB85C26AA7183AC100117A902CE1BC0ED7A26F405CE77494E902B87CFE93E989CC99984E9AF3E476BF1AAC0795E8499899BD356A50B44D955D0E55ADAE5989030B121AF5B552E10353FF6A088157C2E682B9B5BDBE9A38F3E4EEFBEF7BE268A4BAEDFE4796D81AB8A23CE43E52A8352B2DA97FCF09709977F554FAAA3AFD515E71EE017CF6652CFB980AA166D8E30E3EBD29AFDE1AB476FAFFA81AECEDD76FF18A210F08282828282AF0579200758466031D6D16347D3934F9C49E79E3EEB8D6E866FDF4E1313132264B103660CF4BB2460FF98EFA1BD1AE07749849E8A7F0F402CC6848CA05AD2D3DD6352CEF57B22F948DF090B920A1160D2806A0AA405A2CE3576003D7CE488ED9A3359B06ACBFA5A5A1581C452047AED0B0BF3BA87EE2BC7A5B4BAB266620E2981888784372CA544AC82D4D424DCF5E79018FD6510875A5A39E45B9F77CCD0BBCE1BFD97FDC9DEED07B91E39BF0BC767DF0B9CE7E72CC9D7799E30ED86B1FB0EBFFDC75197398634F640C26E3CE5439EEF2787059F8DA833F7D3E8D844BA7CE57ABA70F1721A1E1EAE4D1EEB9FA17423FFF796CFA7F33B4A3616CA06F6D408F9F7207015FBFABC475D67612D1B7841C46766A6FCF588B6C0A2DBC34383A94F249C492F65FE38A210F08282828282AF050CEC8CD52CC444571AA9F7C913C7D31322E038C6FDF7DF7FDFD653B03A7277070B22756453C8240F1261E81EF7F903DCAFF1817C14F8C9133C0B1961A1188B26210461422DD45090C2721F22185650BA2D99CF0B33B987E594D3A79FF06E8E9393E3697945447B6ED66419AB2910F1494D2220E1B3BACE6644EB1B9B7EBF5DA4BFA9057BE46D4E43CD34A39C89D1DD8A70CBE15F8D80576E0FF906F967DD25E341E7F95A952F4C32F2C57A2F3F0BE46FCE6BB0272ED95FC591FC633750A4E1793293D360D49591EF8B6C373737F9FEF2F28A27425892C9AA287BC2297828C827269217AF5C4BEFBEFF51BAA5092D5F656847DE748A3AA63A15FAD87972F4E0BAC5FD7AA7FF74B5BA9F9FCBF71E00AE475861131EE937ED834267A23DA37831C962A3AB13C78FA5818181AA2D566B2D1E3314025E50505050F095E16183314027756393058E9BD6959E9F5B481313E369747434DD199D48D7AEDD4C57AE5E13715D3019868C6609287AD6D9EB7B22BE1BEB6B697B73330678486ADC12201541EA32B9A8FED5401CB9C7408F978D0A0353699092159169483640E2DDDADA6E3289079B1BEB96DAD9728B260710F493274F7922811A0A719E999AF2FBA8D640683637D66C1182DD060997C90761E33747EC28E3392A18DCAF27AAFBDDA7B02751720F78A4FE3A7E9874577EF956F5FBC1DEEF0D9773ABA4F8CD78777FBC38F77DFE55F9ECC59875CFB98E8417BE4EFE72E4116E01F28167285F7EEF2787050F06926D54A1AE888063F924D62AACB9AEE3C84FEAA7CBC0C879FFE9B2CCD87DB622E3FEA9FF291FCEF9593D92FDC8249F532651B42F26BCEB6A43535313E9D68DEB9A682D7911346D882F60C78E1EF164F77195803F9E8A350505050505DF08980068804785C0E6C82AB7B9B9650B244BCB2B696676218D8D4FA79BB747D24591042C34BCF3CEBBE9D295EB22A249E4B5D72A2AA2041EF091E8D9828606F54CCA76E4270EEB288CFE5657109133C1ACC800E06710848A3CC841E618E821226C1AC456FA9040FC202CA4EFA89460171C7D71FC801458775CCFA2FF3D3A3AE205642FBDFC4A7AFE8597D2C953A74C3E6EDFBE65C937EA2D48FDB69466A4E32323C3697864C426D8A6A767AD938BC936C889A5C50A57C9B5243893188EF5E7063FB3CBC8E9AD4BB7B1EFBA5FABF74B709E7EEAC580C3E70B441518E7F9FD6C5231BB0C9FAB0E84BFF10E77F73FB71F788BCF4C86F84A80EACFD6F64E5A5BDFB4358FCF7BBF20403BA1AD61737F7272D2BAD6E45B2E3B7EBBAED5B09BAFF95815B1C1B57807E25E991C5479F82897ADDA848B67F3F338E6AE4C36D97D164B47A8638D8FD10626D3F2D2829FF1663D724C103CF17A4C51CC1016141414147C6960D0CD033692B7E59555EB3EA37AB1AC63D806DE310947AD607E7E51E4331C44755E6416021C646BC3BF599CC5F3BC1783790CE81EDCF507B9651167477B9B49738B06EF8ECE8EB422720FC9C5EE700C7599490431B72455CF67692AEA1F906CCC09BEF0E24B22143B697C7CCCD7210DA89FB063E6E6E686A5F22CDC5C57DCB09EC296F6870E0DA523478EA40176C6EC1F48636377D2D5AB57EC2740327EECE831C5B75DE4039BE32CC86CB3AE7B6747BB3726410F9E458736BF584929516D3179A9E21979509DC368EA513FA2D7DF7AC0751FEAD9950059CE7E7AF25207136FFDCBB4219FE7DF9405C74CEE1E045FD7BF484B5C83C8112EE03E65C80E98118CD27AF7BE17B1928F84CD0E8AB1C539FAC1458EF820B86DC84D4C4EA90E4FA65FFEEAD7E9B7BFFF83F237EA7B7C493AE8C9E5F6366B117299ED2DBFFADFD94F5C06F772BD0CF5B0B8863F817896FA4A59B15E82BA0D980CDCBA7533DDD16474666AC2A4FBB537DE4A3FF8C10FD2CF7FFAE3F4FC73E7D5AEDADDF61E4714025E50505050F017230F2526530CD2FABDB9B19926A767444427D2F51BD7751499DDDAF636F46BEBEB26E4488F913ACF8BD02E8A802FB32988482D564E209FED1D9D1A843B538B886A1006117191310674246E488D87447A5F7DF5F574F4C86191C67B3661D6DDDDED4D46FEF08777D2D8F8788DBC67DCBF87141B3222226269778337235958584A274E9C4CAFBDFE9A9F670128D27BA4D7A89840FEF88C3F3E36EA3860D5A45D843A130BA477CF3FF7427AFD8D3735A99837C1B87EFD6ABA76F55A7AFEF917D20F7FF876EA1F18F0F6F7DE7C6879C9449F49C5C0405F3A843DF2817E3BFC623241DC492B7185ECE4B41367261035D48FE699FF80875DAF90D57376ADCA04F2F5CF83A5E27E3FCA3E9FD7E341E726CFBA1C5253EA4CBC0BF9CECFE72393B96C9610B51D4C13B6B63657A61CF7FA5D10ED91BCBA78E9B2175E62F9E4C38F3EB1CE35752F26B1F175275B43A17DED07F95F5F76F5F523639780EF3E1F7EC5979CFC0E04BBAFBFDF8B2F1716E6D2E4C4B826A857AD76765793006CEBBFF4CAEBE97B6F7E2FFDECC73F4ACF3D7BCEAA2A4C541F4714025E50505050F01783A104D580E565CC896D58271AC9F7F5EB37D2150DB2972E7C9286876F9B14409A79760B3594F5354BC2B734004304D0E7C62F067176968CADAC45B26A96492079A1CE4018E87E3FF9D4D9F4CFFED9BF4C2FBCF042EAEB810CB779C1DED4F4B4CDAE4D4E4D8A6860B73B76B15C5C5C36B19E9B9BB7EE39FE101ECF40C287860EA773E7CF3B5CA4742629C49B386A02B0BAB2E24FE7103F3EA30F0C0CA6C3478E5A7F958563F8453A9904F4F50FA429853F7CEB36D117496F16B91E4C43870F9BD0A372C262388E48FA20FA7DBDBD96B4F7F576A7DE9E1E5F6F6E6E949FB17327D8253AB01E5F0A30A2EF3FCFF88CE720DBB081983A05F03BAEC7D5FD12F10CC5A2E617BF1D2721D38B5A3CEBC079965E43AE21846224E18DEE41EAC2C57BDC27EDEBEBF1F5813AC076E67C3D681311A7AC0A76E1F6B8BD937EFD9BDFA55FFFF6F769E4CE9D343A3A6642CB6491B6467EC697A55D025E5F4ED10EF9F5E9F2AB472EDF7071CE3B80F68ADF4C4E718DAACBAC8118515FC0D7A585F9394F44090BF3A3CF3EF77C7AEDB5D7D22F7EF693F4C2F3CF3CD604BC2CC22C28282828D88318785129A8E01F71ED41E07924B258F6989A9A49E393D3DED59241FFA38F3F49EFBFF76EFAD31FFF2032FC411ABE7DD3FACF131A7C597C853EF4CAF292D53A18AC1B9B9AAD9EC1F6EE1054C2B4AEA948028481B018E5915A235D8380A3F6F1939FFC3CBDF9E69BE9C5179E4BE7CF3D9D4E9C38E19D2DFBFA7BD3B163C7D2E9D3A7D2934F3C919E7AEAA9D42F724B58F807F987DC215D96E74AE57D85DF5C7DF60EFD70D4662C1D9F9F4FD393E3696971D11B04E107EF20553C3438E8709E78E2493FF7C107EFC98F664F0E504F817C70FDE2C50B967AF3D99FB4904624832C4883E8336961228043C28D04DC2A2E6D6D559C918423251659AA488E917FD61751AD0085CFBAAE73B2D5C8CFE93C4BC0B9E53AA1E3C3EA00D82FF9766EFABDF0A71E9C87AA8B9EB134D6A1EC91C20729F44FFD8EAF1410466CAD934F3CC633584B610253B00BDA0C24FB830F3F4EEFFCE97D4F34A93FD4C3BCDE81FACF91EBBBC55395B9CB20CAC165947FD6E1C175212672F14EBC44B9A14A42B8A811CDA9CDDFBA79D3BADFC4C1F5D95FBB3A527F5F7F3A7C78486DF5B44D11D23E1ED7C95521E00505050505353068C6B809F1DA1D75F3600B59BA8B3939AE79B045D2B6ED8584D76FDC4CBFFFFD1FD36F7FF7DBF4C9279FA44B972FA73B7746BD99CEE2C28225DE0CB648B563AB79916C115DD408C2B63676B5C32A480CE4C46557E2AD4B3552C81135952D117708EEE0E0E1D4D3D39506FA7B4C5683BC6155A4C59B7A0C8A8CA383CD0E9B834387D289E3C74DD28F1D3F969E7AF2C9F4CC33E753BFC8BA258372485A2126ADAD6D5E3839373B63F518CC12DEBB1BA401F813BBE3B1AE7460D7B8CB69EB1F3864123F35890ACB96A57B2CD2F456FB22E6A14E01090A351A8808F165B12147880A647315751C9124F29A209106729FF738E2C8971AA26002F5D7C1FEEBFB8E10E29A9FF6873A10C8F9FE20386E22DFD48AFA3F9049F9FE77398F67744FE1EE92FD780F429ECBBD5E32EB3AA1CB487727A6A6FC85A2BB0B35A576EE7E2A9CEF22C8A3D9B9395B12FAE0C38FD2A54B977D3D4BA0DD7654A7B2E3F97AC4E967E725F71E763FEE05F16E517D65328D7D6F26D963A3A369F4CE88D5B8D0EB6772497BE01D269B7CD5807833593E22225E087841414141C177028CBDE8F2428090A2414219A0196A1954217E2C90841C6E6E054964A1E4ADE13BE9E38F2FA6BFFDE52FD3DFFDFAEFD2E5CB97D2AD9BB7D2E2D2A2C9E486065F9813FE786046CAEDC1B521358A901FC01DC8E43B484010F070200FECF91936F5C06F24A0EC54D9D3D3934E9E3866158E908C36DBA6705F5F9F55430E1D0A87C41C8938B68621E4D81C3F77EE69935FA4DB6BEB6B5EF8C9FBBC87F41D028EA41E893B660E4903B98505886DE5C3EACAB2C944476777EA51F89852831C5EBE74D1165C8E2B2CC83C9305483E0404D597AC0A0091273CEC90738DF0B112B3BCB2E234135E6C5CD2619D695462C8CC3C1130EA795464D1EE31E333AE43CC70F5DE00AE7DFA8500B732C97659D5BD5D2F11CFC73DA81E250D48B87DAAFF827C67C7FD5DB2071967B2C617895BB7872DD91D1A1C70BEF04C0EE581E17D0790F3EDCEE878BA76FDA675C06F68620CF9F6A637CA17F299AF3A59FACDF319F5BFF7A33E4BF9FDA03CCEEF730B1523EA3CF59A3A8EDAD6EDDB37D3E8E81D7F79222EF4037991255F31BA34811D1A1C4C4F3DF5A409382A5B858017141414143C7660BCCCA489C1735B041BB365F30B2B6966663ECDCD2FA48585C5D4D0183BD72D2DAFDAB2C2871F7D947EF7BBDFA7F7DEFF20FDE94FEFA677DF7B377DAC6B172F7C92C6EE8C98906E6CACD748BC07EC830D9616739EC38BF0758F3F3D640AC59117FC0C0481E3EEF3BC0F79D8D9416F7CCB033866CD18B09F7BF6993434346852F73012E670E4B032D2268200611FE8EF4FDDA8921C3A64E91B12F1975F7A29BDFACA4B969CB3510E81B3B012F5904C34AC9B2EBF8813127E546A201A1B22883CC382CB56910CC83BA419221413101D2BA9604E4FB6C2C279108FD009C7263844334BC57996344370F0236222E4E4EE4FF683AEF3D2A7CEF7926FF228133697CB03A0DB067528D7239ECD12719FEBA1CF2A0B9EE3AEC3ABC87843FE12C27DCA1D6D9F78C5CFD86FFDA34EDE156127EFB0A1BE5F15E561E13ECE20BFAE5EBB913EFAE4621A1B1B579D5D3011A6CEF9BE1C1347BEBCE4C94E4664F9A7F38C6BF5D7F3398E7A98EF319164AD05849B8924BF992CCDCC4C7B2DC4FCDC9CD5B7A8B7AEDF2A2F2655D4798876BB2609039A243F611594C39E143FAEEA458580171414147C0761522307B963B0DC11814122CB024A93EC8999343A3EA94173DA03388410559199D9F9343C7C27FDF6B7BF4DBFFCD5AFD2071F7C98DE97BB72F952BA71E3BAF5BB21A1906F0660067886E66CDB774703B2CDEA296C0FFE8ECDEE609E9D4901CF54F10CDA10F10E093D4EFE88E043A4516B3972F8707AE59597D3B1A347FD6C2605FBC175481C84A4BBBBCB2A2AB8FE81FE74ECD8510DFE4FA4A7CF9E3509479FBCBFBF4F24BACDE4776676C6127048018B44D96A3E13E8656C1A8F8F7A91268B4A91CA9F3A7DDA64677C62CCA4B4ABBBD7E1728FEB2B7A16920281643241BE911616CA41BE21EBA8C3CC6B2244F838C28598908690C4D7E1C149DE7B7D976FC5F57CBEEF08F9CE7948BEF333CE2993F85DDDDE839A44DCCF51FEBB0F65FF3276FDD76FA5C7EA283AE2ECB9AE7B12A7FC05F8EDAF262A73BE7C80D9395483D66DCA1135061071DB8DFF7705D445543B3EFAF88226C51FD8FE37F5CA44B6CA9B5023DB5D5311ED2BE3C165F5E9BC8CDF713DEA47D63B27BCA8ABF185878D7F20DF90F08DB535C791F2B33A0C652E0F68D3D46BCC72D20ECF3E152A28581DCA12F2C70D8580171414143CC6D83BB8C639A4D6D2560D9010BB4991EC3B63E3E9C6CD617FB6BE7CF9AA2D975CBF7EDD66F4464646D2FCC2529A9C9C4957AFDFF0F54B972EE9DE2D2FA49C9663C748B65C474503328A5A09C498619A01964FCD48BCC2A635C439067E932D4670067222C86F817BDEED32CEEC070E691B033712BDD6B6760DD0ED2616E86D23BD7EEDD5D7AC0FCE3B20BFF745C0534C325AB1CD2D02CCE24A3EDB435E20E8A8ABB088F385E75F48CF3DFF9CAF4F4F4E2ACD1B7A33E2082126E4F5D5D5B426E2814A0BEA373CDBD8C80404F38107ADB38CEE2B848377288F1C4DF28F4FF41024FC442F3E136EA4E848C257E43F45DB56598880BCFED9C8D9529F3D7B7E87F49BFF721EEE3FCF71DE0FC837C89270FE7827BF9711D7F45C83FED32B90C35C67BD48D3CF23518F7771A192924CE29838CECDCFF9AB0393194C5CA227CF8431637F988F331616D54EA766BCF89205D0B435267CD435A4CE31F18D493713BFD0B38FFC06915591BF39DF72BE67C77DEA281274A4DBD99CA6DD92FA019D43C0B3149C1D63979616BD7E82908807F595FA4C19B2A098C9389B2E75A85D0CA91D3FFDF4539E48D33E0A012F28282828F856C2A45B83AE4DFF6940DCD8DCB2C4109381E3135369E4CE68BA757B44C4FAA609F63513EF5B26DE77EE8CD87E7710F599747B3876701C1E194E531390EF49EB476F54A6FA18F0218CE83D33B842A201BACF581781809B846B0067F0B7044C0EC4781F833EF1050CF8102E9EC3FE33C49E458E106F8832249C37903EF7F7F5A5D75E7BC33ADEF8C57BF62FBC34824004C897FA738830527A067D24D0B836115F4838BAE3274F9E48E7CF9F4FE7CE9F4B4F3EF1A46D9AB3D32544830598C48D490666D650556103A005E51B71C7FE31E403C282E4163F09A7ABAB47F14826DCC4076283E4D06445E7BC6B151B3DCB3DC8371B142D8AE8A07EC175D280CA4626B97B90B915977779D69E3C313EE33C935FE24918BB64B87AE021807CE7703F8B80678B2E90B00C7EF17E9461FC8EF2D23BCA939C2F7CB5999D9915099F4F533A9277D8538F45990261FAB037DCC70DE40DCE6D7464347DF2C9052F8266112313494F0C79C6139CF862136639C9E9DD7C07B96C739EC531CA9F3232F986586B62C93A07D680040167D3AC55DBFFCFF1C16C275F75B8CF9A11EA2971A1FCA24DA382122A5C107324DE836A6BDE8AFE5821E00505050505DF7030D805763FFD07E986B46DA7B985C534353D63CB08906D4BBAAF5C4BD7AE5D4F376EDE4AA3A3A3B68D8D8EE692064BA4BA48AFB2850E4BB11617AC8E92EDF642B02184DC6F6D6DB719B19EEE5E5BFCC0946083C828FA9D0CA0104DC800CF6F6F6D8884C7663A6253B5811E1E60899C8E0745B621ECED6D1D26D948F1B0A680AEB73FA5EB15A7D983FCA6E384AAC8B9F3CF5A12CE400E61DFB53482E43DF288FF79976315F26E1C1E00EEE1200C905EACAC748AD4F4F5F6A53367CEC83D91868E60D73B5B37D9A9261E9096D0555F5B5D8E0D86203E2E932D3F0F3147628BE40FB2998938202F2094F81764293633211EC4876B907CF2913CE63DC831240769A21E0ABF6A89AC8EE0E1C9B5E4197F2216915FF5C8F9F1451139FDE0F738CFF5358347228D711E7189FA8C041764BFF8A31EA2FE40FD265F735D8B05BEE892EFFAF5B82226675B5E987AE5EAB534AC8932EA5210581C709D579D221FA93BE4D96EBE939F555BACE56DBC137E6F885CAFF92BC3F2D2A2BF3830E965AD07934A24DE3CC7E408693B7D015FBDFCDEFA9AFB126A4258DA11F956B964224ED84CC8B94E9BEFEF1F48E7CF9D4BC74F1C2F04BCA0A0A0A0E0DB0188E6F6764851517D585BC592C65A1A9F984CC32363E9F670906F4C065EBB7E23DDD6808DA9C0E9E9295BE6408A05510CF25D2DA6D2E0BABCBC9816B0D98D7EB3CE518960074876B464F121832D52E9EEEE9ED42172CA001E644984500409C21A0475DD8BB018AC2102352215A3BDDF61E847CD240877BBC26AB36499811DB366E848E7B84110B09FBD26024ED84F3CF99449AD174DCA9F15A57D756D5D6952B84C16142E69E31DF22A7859F5BF23F169701DA2001160228074B5A7BBDB12BA679F7D2E1D3D7AD43ADD11DE2A3CC33EE2D079472D875D3ED18DE5EB004489E75A154736EF817C63C10542C4970940BA481FA487BCE2374433ABA2E0D0ADC5DC1CF9CBF6F580EB481291C89B7011997AE488EDF2AEDDDF40E759C2BDE73A69AAF2278EF13BA3BAF599C8EF7F0A845385C533FEE2D110C42C2EC601B3934CA238B5136143179FF2E0EBCB1D4D22A98F2D2D1DAE6BED6DA85EA067CCDBBC1152F8C711D42988F0554DA83FB97031CDCCCCD884250496B6E9BA60C977AC9DA0EE53AF806E39CFC9CF5A51F07C45D469EFD44326B9A89A2D5BDD6CC5FD04049BB6845FBC47BEB76AF20B01A76CE82FF2843DAB145104F59323EE59C75F37282F2C0F3DF3CCB97442049CAF5C4C7A1F4714025E505050F02D0483563D38E5CAECFC621A1D9FB224ECF2D56B26DB5775BC72E55ABA71E38649CAE4E4645AC0A6F5EAAA076D88695E30951D832E041E4938C76D0DF0901C749559F8183ADDB15324EF33807A21614D2F142B286B1AC4EF9A20B2FD3524DA045C03762CAABB6F696D2645502BC81FD2319E454206200C10014F06446221F00CFCDB96A6EB5CBF91D477F774A7A3C74EE8DDE6B4B8B8E8B45EBA7C452E74DAC913CCB3DDE60B802620A82D2070877C30F0E7CFF45F9CA4854E3AA4BCAFBFCFA60659B879F2E4494BE3212194097E864E774829F992806D742488E82F23DF65E1192A2F870E61FB988D52423F372619D54259A591B4425A20E2E43BA60A2128070E36FAF7FAFAA6E39F1728929F19FCF2392E579FFAA456BFF7D6ACEA3DC85385C89F38CFF955174C0D717DEF7BFCF10E7FFBEF1B3AB59A045F2BF8C7B37E3EDE6F703C423A1FA4311CCF84CACA419B6EDC541D6C6BC3E63A0B6563B16CCE8B4F85F91800A23BBFB090AE5D4385ECA675E141B6B11D93B8DD76C4E4973C0B90C791D7A896A042852AC98A26E348BA719C33D1F6A499099EC8356A66B4EDD8AD96DD5A59D4DCEDB68E5FD47908BBBFEAE82F97554D0D45BFB96E89BCDA38F7984862B3FFD9679FB19950BE3615097841414141C1370A2626720CAE965289748C8C8CA7ABD76F5B12661BC0376FD90E30BADBA36348BAA72DE9867CA32E61222B521BAEB26000C935B11531D7E0C9D1F7218122EA1062D4429052636ECFF7795EFEED12F735AB8630A8420282808B2456CF9B608A64419878A6A258FE6D09AFA5631087BC604C04A222078ED796E2CDA441A4006B2210B7EEAE6E11D9A104779B9B9B4BC32377FC399E45A3E40192FE89C9695F47FABFBAB26AE92952C28E0EA547F10384FB450001E41DF4B9315578FAF46913F0C1C1414BEE5095615201F121BF5930C88486C9C1FCFCACB7549F9D99B19EF961BD8FFACE91A34715FE419705C404D24DDA23CD21E58490106F880DA41B337CE8F5AFAEAEBB0E20596CC6749BD211698AF47872A3BCDD255E75D89F643D92F381F7A28C02FC8E7B7125CEFD730F20C47EAE7A514F391CD75BFDEDFAB317A41B10CDFAFBA1B2101633B897EB8ECB41F7C847F2FACEE81D7F11E9EC68B509482F401449CCE13D28CC6F3BA853B3B3739E585EBF714B79182A622026B0E1A22DC5A40EE43E244BC7A963AE679678AFDA51E7C857CA8C7609F16692888BFC0C93824C44F90A457B62A28DE41B7FE84F287B24E0BBE43BBE7010AE09B8C2C62FACD80C0E1EB2395124E04505A5A0A0A0A0E01B833C6832C84280511BB97EE376FAE0E30B3609F8E1871FA69B37AE7B01253B5022BD82AC85647BD3BFAD9E2292BC2E97A5D259FA1DD2D69D748F6325318300663F204048C0917E41BC19D0918EED68A00D895898E6837831D85A27548491EB840789B6FF2204362968C7E3FCA7FF3D2007598074477C6272901D61F20CE48230DB45F0FBFA07BCE90E03F9B2C835A404E95D26119612CECFA5314D44B0EE02D1E8E9ED11F1EDF2024E08C45F4ACE781FC2807EF8A95327D373CF3D67BF911A5A7D447125EEEBEB22E44A133B79A2473BAE3861D9043203E93871E264621321D46FF0D35244E50D7941BA37F43E47F29649D58DEBD744E8E72C718494634E1292832EBCA9AFC84F9610CB9BC8EB2AA9FB75BE092F4B8B01D77DA61FF9393FABFF727ED53DFE2938AC7AE8D94CCEF3FB7B11D7B18C02B926BE20FC896BA4C31EF959DDD32DEE52A6B407E7932A15F58AF50994899E745A79EDC1E17E7B01F99E9C8A2F5FA899D12EC891DCE6A9735CA35D9257F41D41BAA39D916FF1652A24E3A84A614986FAC7026A6CE4776982DBA976C6E4D25F8BE417750D82CD731DACCF503E1306D67FF8C243FF0172FDE3BDF8EAC5D5E8C3F0872F65940944FED0C080DACDB3FE9254087841414141C137020C8E80C595DB5B3B96A24E4F4DA70F3FB9907EFFC73FA50B172E7A17CA8989715B27816433B89A3843DC90209B84AF9B9466C92AEA2379300E721BAA26F9B749BBDEB1B45971804C2201F3802E6749B8FC8564438E088BB832E0B2D9468D482A3E846952AD4197D4E0321F8A8985087965A7187F8857C42726034122F29B29352A1E9D9003394834D27BACB620E9E7333A923824D0E8AECE2FCCA799E9A93439316129F1D1A347D2D0E1216F7F4D9AFE1262C6BBA417551224E2672A89383AB1E45BB3FC67B74C88101311262C486AE76667D3C8EDDB4E2752F3DEBEDE74FAF4138E0F0484F4F2B582349B2C89B443B491EA92AF90F79B37AEC5240852BF85DBB18942E2C27B413E430D03221B392728B959C29D91CF9DC515F80DF1F5759FC7824FCEF5AF7A863B7192AF3D08997CD7A3FE9C9F9CDB3A8A8E75B175918719BBB09AE2AF287A8677A877D6B9575DA52E6229069DFFCE4ED61FB07680F4471EF0FCFE387C9B81CE378BA821E0C322E039C7FC454BED01B26DC2EDB6A5BEC3C43CFA05D7294F6CB75D4FA8C3D6E5AEEA1F750812CE7A0C2C102159A73E93C7D463BE8C85C9CE2E8578DFED9B350F4C7841AE37E43B7ED726818E1393A420E1848D6E383AE02F3CFF9C27B04507BCA0A0A0A0E01B0388C7E2D26A9A9A9EF7E7E60B97AEA477DF7B2FBDF7EE7B1A88A74C3821730C7A0CB80C900C98BB036D90ED204C010F84BAE6856E1C79C7E45B83B6C83EA40F9512C823FE7668B065D1A50992DE8DCFCDAB966663E1C4845FCF3258E3907A11662CDC8A455BA240264690E6589015BAAA107FDDD2799079DEB5893F1166D45E20A9A816580FBDA945E722570A431111A9D8B4251736C499D22464663ACC242E8A8CDF559CD02965C1E3D12387D333E7CF59D7F4D4C913DEFE3AA4C55F3E48FFC0C0216FEEF3E28B2F9A9CB7B575984C22A527BD9010CA676E6EC6F167D312F27570E8B0258FBC03D9A6C4B8CE24837A008922EDF87F4869E8EDE9F58250A4979054EE7BA225524A99501F20425947DCFEC9998A56D5A13A7C0AF5D733F906C4C7F7F45FBE561D1E884CA8F39177F27B199CFBBEFCAE11FF78DCE744987001CF713F4BC65B541FB8C7048C4989D54F741DE9AAEB6223F5EAD3617E9BC1625CD4AE20E0376FDDD695C88B98ACDE731E90761653B2FE6356F58BB6810A1A7582BCC0063E79477BC4D136F9C282BE37F949BF11AA259AC8CECDA685F939B75724D43DDD3D26EC4C0CB194443BA73EE3AFA5DF8A0B52754F9E5C96AAF3C48DC8CB6F26525CA72E1F1A3C945E78E179B74B2600858017141414143C5230E8ED2709960E6BB09A989CB5BD5F749C3FB970295DBC70C1BB514284917AF11AD22624822C8C844CDB0208445CBF337961F0F3C1FE221D0BB2CEC01A9BE6C4676A4C0722B1CD049C2DA36D835B832BEFE6C5560CFCDC477AC9C019E6E0D085C6420B8B288304F20C963A20F13C833FC4C5045C83330BE7905866E250731070916E088289B7EE636E90708937123988C1D4E4449A9D9D36F15E595AF4EE94BC73E4C8D174FAF449EFB4771E7BDE4F9E49470E1F497D7DBD26125F05D0113F7EFCB8C27AD2127174D51B456C90108EDE198D0992D28D2ACAD4E4B8892304A9ADBD4D138563A9ABBB3B1D561CD1BF05E44F9EC4AC8B1021791C3A7CD8474B2935414192C8E40915013648222CF2878A0139C7820D45EF7AE0A3BD36B13574BEBFEE710ED9AD27DF80576BF549E0DEBE571F8A4C9EF78765D84B08DC5E49387585A7EBC304D4F7586FD0EE892493180827F55E2F85FA84D2CEC24C9378E181E17E0BC19730D4ADD8A516CB4648FAA31098C0C44496FC5A545B60820781661D027D09135D1E65A2CB73FE52E0B657E96BEB1AED16F28D3A9B170FEB7D2C233119667D07759CB6888AD782EA2FEB1D08CF6525CFEDAF5CE43793FDE86FA8785912CE3DDA3804FCA5175EB004BC10F0828282828247824C2AF280C4B1FE1AAA056BEB9BE9F215A4DEEF5BCF1BA201F164B08324AF686034ADD0C0CAAB416EED41CD2F93ED4CB421E43AAF7DA29633116690E4BEC84CA880E81C3FF43E649541355444821012DFDEBE7E93C193274FA763C74F7A7046AA6549BA9E65C0E673764F6FAF176C616A30E21D8B0DF3263ED803E673B7A570104A0DEE070FC6C242C26130E777C5C9FC934443D6982430E920BD26000CFCFAC3AEF09B6FBD95BEF7BD37D21BAFBF66FDEC13274ED802099271D2F3280051412F7C5144064B2D48696D31C665134409620D9941977F7965C984083DFAD3A7CE844A800834FEC4E4EAAE2740B650A3B2A36C90E67384408D8F8DA56BD7AFF93EE40AB2D4D7CB0640A1EE139585BC13512223C963676648BAF79FBB2AF9055FAD1D29175C75E9A1A87F0EEC3FAF07D75DE314574BAD2923FD26EE99441BFA99A5DA7E47F7F5CBF56E7A464453C7A1C181D4D5D961496FBD04FC61617F9B90D5476666E7BC31D15DB565261F4C3A99E432019DE54B106B4256974D74DBDB3BDDAE505B5A511D9B9F9BF1E41572CE8E96A86D79C2ACFAE505996B2B696961512ED69590C7ACBBE8555D6672CD240F720E51274F694F79B206C907F8C5C49E491165E3F51F559F431952670787064DC04F8A80D32E89EBE35046FB510878414141C123800941DD20A2D3870292CB8084E581AC3602C1450F18D23637B7903EF8F0A3F4CE3BEF58E504A916FEA3928114755183A8A55A104F48958EDCC75FDD88303C10667D6A0D7E466C889107C990522105CFBF21E89CDFAB49632132D97F36DF4155E2E8B1E3E99408F8E123471D07FCC3FC1E69413A8B94167D6DCCF499E0E95DFC050CC026DCFEF41DBF919467AB289970E77410AE1D03B8C03390F370B12D3CF7791C2B256F7DFFFBE9F5D75F4FAFBCF2723A73E674EAD54400EB198F8A7C0324B4870F0FA599E99974E3D66D936DD477144DE52D9FFAB1BBBC6229FEB56B579DDFADADCD562F397DFA8C2628618B1CC2C2C40802CF4E83392F502F411D80B2E1FCDAB56BE9E2C58BBA1666E206FAFB6D698272C16F437E65B2E43CD3DF679E93A7BCC6B57CB4E3B72E7C066A3AE0F288B7C38780AFEF0701F2545546E411A0CCA8DFC4C5E70E3CEA24130DEADAFAFA862D00F165E7F8D1A3A9A7A7DB049CFB84C5B38F05940510D50508F2F2B2C8F0AA261E335629610DC2CCEC749A9C18F7A269A5DC9B15612F9FF6CEE49D459326DE9ABCB36D3C6B3A3636D75D3F70A831E19616D82B00B5A9984C0F1C3A64BFF8F28614DEAA279AE8997CBBBCA24CC86BCAE9EE4E4CC4712E37B94CC2992C3239670BFA175F0C0938F5987E003CB06E7C8B510878414141C12346C5171E080625FE5656D7D2FCFC629A9862F7CA719BD043BFF3D295ABDE68034B2757AF5EB53EE7F2CA8A06B0500D41EA853940063F06359326FF0E12ED915AFF1840B986AA82F53C7584B422F1B23504BD1B6A29BC27773FC89A495B763A47BAC6022CAC90F46B40877CA32ED1DBDBA3C11FBBDF2C88DBD2F341F639A2A78D0D6FE2897FE8E6221147D5823438EC2A93E21338769C217EA8A884D49EF07D54FC9848A0EB7CF79E067EBDDFD5D9994E9E382E92DF69291E56572001EC9079EAD419C5EFB075C0F9BCFD750CEAA48D70272626D39CCA182A8B23DD1071954E3C5881890B524D2498E313137AFF9E263AA172327868C8E547A1721D492579423986E597D574FBD6CD34363EAAB49FB21E3AE4BF5FE513E5C9E2B720AFE478AE9AB573FD47BE1BD53550FF7CCEC3A8BB9F4F94B27F3C87E39CBF7CFE20D49EABEA053079D63FD7711D6D3B3CFFF663D11EE6E7E62D09668B73263FAD6CD063A9AABD311E16EEB705E44B6EF39056EAC9A54B973C79475A1DAA4D73CA83416F56453B1DD464997663F524DA127E900FFA0729B6D94FB555BECEE47523AB2B4B364DCA04BAB7B74F61B5B99F80C0E34F9816A50C98E0E4C8ED1E73DB26BF79CE9328DDC26FD6751C3F762C9D3F773EBD8804FCC409DB0587807FDBCBE7412804BCA0A0A0E04B82C901030503CE9EC12788432CB4BB6B09119F60AD93ED412E4BB8310DB8EE9D1BA744BCC7C626D3ED913BB6E57DF396DC0DB68FBF6A77F3E64D5B3A617065811D014256219B414C63004572CCF54CB889227109959220BF2CB23289513C91C6120F0652C7B97A2F5453F45BE7980CC37FC00E972CC8B4A93211680665541CE0460CDED90C202492778913249C419B419501BCBBA7C7F6AF79774BF743BF3916717A21A69E23DEBC87040F351BFCCB649CACC6641D8335A6FB8E69107FFEF9E76C92102B2831A1B8ABF3FE74E6CC93563B61D31C76A0FCBA0676F26F6A5AA45AE410F2DDD0189BEF407628892CE5A5EEA03E80850B360E9A9C9A4C6DCAB323478E5815858D7B42E2CBB6FB3B964442C4C9FBE5E5D5B4B8B09846C7EE582FF7DCB97356BB3934D09F7A7ABA141E5F343449830491C784A68C0E425B9DFB7FFF0827ECB9AFE79D83FBCFF3FF9F91BDCE7BEE57FED6E381E5A2E7C81B8357F58C1FE3B7FEC833FE820052270EBA6D9127E40FF583239262C05717A7B74AFFB719C4DF696BC024677BBA72E54A7AEFFDF7D5376812A63680D49A45D4A7CF3C95CE9D7FCE0B91F96246BD60E12F5FBC72D9A9D5FB1CF21E76F737DC77E981B4A1090DF986AA198E7768AF367FA9BE2BD7457CE11E8EF75C483ADA1FDD8BB28B3CCF449CAF13CF3DF77C7AE9C517D2B9A79FD64471D05F31C2BFC70F8580171414147C09F060C351240022B0EB445C752388F7DDB424523433CB67E2550D8A6B26616322572C9EBA71F376BA72ED7ABA74E972BA7851EEF2E574E1C205B94FD2B5AB57AD8E303636664928C41632CA60E67F0A3FEB51D724D91A3859A0C800960743EE67F29AE34C1C21F17C8A5E5B8DEDA5B90EA9E109081D7EA32BCA98D920D21E66C93ABD2832937D16FCF1197A7262CC66F16E5CBF92EE0CDFAEE9A84382512781A063B5E3C8D163E9E4E93322054FA6279E78D2BAA47CC2469206E9F460AFF8860A0E6610B15BCE84635DE9C39A4B3888F4934F3EE1058E2FBCF0427AE38DD7D30F7FF8C374EAE4497F2687EC132F3EB9A37E72EEDCD9AF55024E9A902832917AFF838F14878396687775778984F459677E733DEC7EF3ACC90B65A17240350069E3B0F215D293F42EDBEE633319951EABF5A8BC791F15965B9AA891772C987DE1F9E7D3B3CF3CA389484FEAD473541CD44128E34CF83DD9F19D00E7117E059FC633203F0FE2569C53777CADEED5FD88DA17EFC47BF197CF1F84B807690B5D7087543D4A7E112C84CED721837ACEEB0CF437393D6D373B3B9FE6179654978258A2A611A43CC2FE3622E759583CBAAB3EE4A24938ED696971DE6B31860E1F755B3BACC9DBD4D4946DC7DF19194E33FACDA496FC0B82BC5B367C7DC2B98DBBFD63CFBE2D757475BB6DD1AE63E1F7B69FB78D6FF25FFEB83CEC4F940B591B92F1C863AB9E681268D3836A9BE79F3997FEC15FFD426DF7FB9E20777676A8EF0A7DFDC711858017141414FC996060D93F503340992C6E618923A4D9EB6B580D584F2B0C82CB2BD6DF9E9C9A49A36393B1584A44804578582DC07418BB335E9763174BB68DBF758B5D2CAF7BD398513D373E366EFD4C244D990C33C64130EF43ACE52026488D6CE77B6D35CCF789F4824CE8B2B4CB43A307D6302F56B3D15DF90339CBFA99844760583FE9E9ED93EB1761ECB17A0B2A20BCC3BB4C0C98204C8E8FD9DE3683336609F98C6C69373AC822DF908063C78FCB9D08B595A12326426145612E2D8A34F0AE3702D2E09E2571A8AE2822F2ABC5C41B12CD8E79AFBEF24A7A45EE7991CC975F7EC9E72C0645D5002B20376FDEB24ACAABAFBE2AB2FF84D5519088EE2FC74781500FD9F016F9EFBDFFA175E291CA636EB0ABBB57D91C1322805A0DEC85891DE504A162F74CD44AB0A3CEE40AD59D13C74FAADCB1FBDDE93265A3A57195C1EDDB373DE9C1B6F833E79F49679F3E6BFBE0104E4B8C5D2750378A3A5D23E0BA1EE4DBC193E59F42EDBEB0A74DE837E0BCEE9187C2EF3D248CFDE5E338A2BFADDF90C51C4FC7B9F2C0DEF19C1CF50EEB27A841B103EAF8E49426846C58C4E44EE44FED036B33368389249697BF85707AD516297B72827E051DF09D6DB6955F498383B4B79361D6B2B34B7DCA8D7459241D4B41ABCB9AC809105DE7E3FD2A0F743878A0B2307417EB453B9ACCB46992D765E93961D24663416626EBBCAB132674553D08C4753FA7F79864D24F31791C18E8B735A2575F7939FDE2173F4FAFA8FDF27587BAFDB8926F704095B73E870A0A0A0A0A1E0288A8071206E97D5D278B0C9100CF2F2CA7B9F9050D6A4B697D7531AD8A68ADADC73D1651AE8A40D5AB6420EDC5A17A02B1869C718FA3A5D8954A8889A88833031203939D063C881AC4940111AB215C67609CB6FDEB69EB097768C0442ACA00C900EDC982C85B4862151E92E4AD4D13E503D5731013FC419501F24D58E8799F7DFA5C3A7EF2949F417AC5025024B1791318E78D103BDB2591EA66EBDF6271A1ADBDC3D26F48383ADFB13D3DD65414A648153B185EBB7A395DBF7635DDBA71D5A6CE2CE994479958302960AB77B6AA46EADB29C2CA919DF3D85407C9AEFDEFE975DCF962F0BFFCC7FF98FEEFFFFEBFB7E4FE9FFD6FFE797AFBEDB735D8BF24123EE0343E6AC42E9D4BE97FFD2FBF4A7FF33FFF2F26DEC78E1D8DF251BDC26E395F0D904E8E8CDC4E988D435520833A801BD4A405774EC4FAE973CF88C43C95CE3CF1A409D18A267CEFFCF1F7E9BDF7FEE4343261F9C52FFE4A69FF89558E700DAE4BB1F366488129FB58E848F5CE84D63441FFF087ECE22A1265DF773BD8BD6E54CF82EAF0B9B0DFB42D21875B5BAC59877A7F2D69251EAA1BBE2E475C6BAA4B4A0B97B93F3E31992E5EBEE27514A3A3E34E331B251D55BE1F1E1A4A03FDBDA9BFBF5B93B2E62A16DF4ED077A07673E3C6CD74E3E68DF4C1071FA68F3EFA24DD8748CBA11F4E1F71E1E30FD395CB17A3FDAB6F890977CE3F4A005D6DFA8A2863FA0FD61A74ABBDD10FF8394FBAA3DD3BAFA93BCA6BDE739DA903A7F43B7CB1A2EEF1C507AB444F6A327CFAF4292FB8E4F7D3E79EB64DFEEF028A04BCA0A0E03B8FFD83453D62E0B86F736F5B9BB14011A26CC9B688B49D08D5DCDC7C9A9A9A4DC35E2C39926E6BF0BB2912795D03E1956BD77D44AA8DEAC09D3B77D2D8E8A888C0889C7E8B244E4D4FA5D9D9594BB8B3540962CD800A20189978F31B09268E0D72880F831AA6FBB887C3AC188E41133BBA7E5E470FB4F2C3E9128186E0A3D69189B6C9B79E8585C81B6700D24124DE478F9D482FBDFC6A7AF1A5573C80F6F50D78404792951D2A10106BA4E4E827B3E0115593C37243878FA4438343A96F6020F56820E75DE72D138D4A8F14F50A9C25733AA76442AD271699363634A523470EA7D75F7B2DBDF6FAEB8ACFEBE995575FB3DEE8190DE4ECA207C9270D483F5920CA4E93EFBDF7BE26415BA9B7BF3FF5F7292D478F5ACA96F3EB51626969254DCFCC8920DDF4970F886FD84BC77C2012C6CED43F7048658D5A442CCE64A2455E587548E7F7EEED78C23239C95711BE3ACC5A920E7961311BFAF448C1517541E2CDAE9FC74F9C94BF83CAE735C761DDF72BD501EA84FE724E84E41172AB50E3A7095ACE2FDF57DDA01EF19B6B2E2B5DD87D0E9FBE385C0EBC834780D3877A22FF217DFA6549B88E2690FAF3E456F1F64445D7C8DF2096B148757272D26B0DC20426EA154130DB75CEB311E49F1FFF6F0268DFD47B26A9679F7A4AE9695652B8D6ECAF00F42BD8981F53DF333335E93CA6ADD4CA0F4F72FE0B5EEFA1BCC31F26F9B46F26FA7C91423040DEF16EFD6427041519E11965451D63613636F7CF9E7D2ABDF8E2F3E9CD37BF97DE7AF34DB5E397D2534F3DE9B68B5FDF0514025E5050F09D4426DD1C1F3EC857EA0298FF5B5CB6DAC8E8D8B8A54B90EA0B17D1D1BE983EFEF893F4F12717EC30F7867592EB37511D11D91E1D4B131AF0D9A50EA20461478F374BBCB74490901811874CAE81A54F22C820742AE35A6D8033A1B8AF0115BDED95180091A0F2A7EBE850A3CFCDC08B493F1C043924E10C7090A720E0A89EF01B3FF9F362499118F2A6BF7F209D38752A3DFFC24BE9D5575FF722BE3367CE88C40E88CC0D88640F8A641F953BA2417FC892670838C4179D66DEC761AE8C7B48C31584F261C5BB4032D9406287049C74412A9716172C0546BF14128A8324303900ECF478E4E8F13474E4B848E5692FE0ECEEEA54FA9A1CE7FAF2E4F7D4D4B4372C5A224F347182A01C3D22028E4D68FDCE26E91E152626A73521BB9D8647B0E13EE372613242DCA96F9405758109150B4951DD21DFF86AB1AC095A20C737D48AA803D80B9F181FAF4DC878EFA448373B645206D86C269D1027263C86CE5914ECC9DE361B2D296CE533B6D8F1DBD9A2FF825443784352BA278F21E01CB9AE232D0BF7E7E629750FD81FFBA9BF87F8C1F568C310ED4CFE94178A3F6B2DAC56E3FBE1070410551C0011E59CF6E3899DC2E26B802712BADFA47AC4DA893F2FF6DF3C907EBEB4B06F0047ACEEB02EE08EEA1D2607A927F407D4B53D50B6B9FF515E927756D369EB906B775ED32F7931B5FCE7BC96FF3A87B0E30159CF39131DFA2C168632E9FDDEF7BE977EFEF39FA5B77FF4A3F4C6F7DE48E7CF9DF3D71FFA0BEA78F8F56DCFF92F8642C00B0A0A1E6B30103020D477EA0C0C0C2E1017D43A20801B96E8C8A132B2B661A2CC661458A99866A1E4F8441AB9336AF27D4DE41B920DA9F3EF6B48BA6FA45BB745AA8647AC7BCB60372972353FBF60DD6F74779148F2C99641090912E19A4C1337FD83D8700E01266EB616724071D79FAF57CEF7FC1C66EB5898B8662FF0837B901008195253742D21E6791B7710E4855F480B217C772DDD6280B56B6FB7DE2CE4EFC927CFA6F3CF3E6FA9F78B2FBE6C5DE54303871276A85B5BDB45B6719D9626F31E833584B9A5B525B5B6B4850A8C0833B68891F0423051B9999E9AB4AE3824003D73A4B624027BD68B0BF315015FF7C4212611610B9C34636FBCBB7720F5C80D2051EFED4DED6DA14261B2E5CCC838E009100B1EC755865813211C2F7AC47A4B476CF491A5B88F024CCA2E5FB9E6AF1ECBCA0B7FA5686E7199923FC40352445950061074A4B51064262C1061C823E59792DED9DAF4D782054D686CA650FE50DEA8B61CAF74CBF922813FF84F992319C71FF2877A485DA1EE40BC6C3B5AE1519F40CE17B717BD07B925AE26B8DC8ACAE4E7F0D344BAEEDA9F8BF067EF7B0FF547D78338871514C7D1E988092A6072E73A2982873F3CC362456F1AE389078B97235D7CED415DC793E1AA4EE0D743C3FF8682F2211F1697565467D6D57F8DA97FBA95C64747D3D89D11F7196CD643BE903F3538CB6262423DE21ED26FEA2275D0931C7F6108E100F7C9A7100C202D8F89BC0AC679888E37EB0F8E1F3F9ACE9F3F9F7EF2E3B7D38FDF7EDB126F2C9D20A947EA6DE1C077887C8342C00B0A0A1E4B30066492E0F1005AE0DFE1903CAF8A68CF2F2CDAE4DFF8C4541A1D9F4CC323A3E9E6ADE174E9F295F4E1871F7BC31B1CBF2F5CBCE84D4D86878745E6C6D3F4CC746C012DD2881A0AD26888BC3F812B0C06130674246F1ED03DB844F80C7431D6549301BDB3B5053117491719CA5647209CD9EC1F7E720D5D6DC2E019164F5A7F5B040229A6172BEA7DA4DA3B3B5B04A3F734981212EFEB39FC222E487F21CEFDFD87AC9E70E689A7D2D9A7CFA7E79E7B31BDFADA1BE9CDB79052BD65B593A79EC22CD8110FC4F01A36FB8040630A9109C7FC0212FE654F0850D761A0E68F011989EBECDCAC9F1DBD73C77ACDC3B76E5A4FDDA447F9C3208CE4757171C10B31511B211D4C0CACE682744C64616747C4427E6FAAFC56D6B024B36462DADD8DAE3B13805D3D66D209E164D2F4EBDFFC4EC7EB89DDFE2060643EE967474A2FC2AB48F8570997BBC002B96BD7AFC7C44C69CC5BF6477D08C2471C297BD240DC301B877A0A261B7906C20DF986F4702E2AA4F792F302DBE7D87D66A2C3624F262F8706064C7208A746BAF49AC994CA48C1F85DEA1744953C474A9CADA43051A57CE755DFF97A11D2D3902A43DA8933E49BAF09F65889F9A2648AE7EA9F25BC7CE46FFFFD7A703D971B71701E73ACCE798D7A65A97D25A945BA8FCAD534165134499E9EC6AAD0B2BF0A701F951DECE2479DF87692C2CDCD6D0B12C6C6A7D29DB1F17445FDD995CB97ACDA8555148A28EA41D52F45B6C9ED1269F28F7E8BF689EA1779112582AA0BF91EEDCCE49B098CDEA31FA2CE728FC9232A26BFF8F9CF747C33BDFEC66BE985179EF70E97DDDF4189F77E14025E5050F0AD8507DB8700C2B026F281AE2B9BD5ACAEC60E6D48B9913AB25012E2CD822C16668D88788F8C8ED952C22D11702C915CBC74D992D3AB22DDD8E11E1919B1047546E410A2E8C593228190912CDD46EAC40044DC18F4196018C418E1B88E33B9D260C5C0C5EFBB8A178B93B6B6374DA063412412B9788EC10DC28DF5124B2FB78228D989609A84293CAB2E8834601ECC36B1456AB190816DECEE9E5EAB80E40590FDFDE8680FA4A3478FA7E3274FDB3EF61322E04F3C79363DF9D4B974EEFCB376274F9DB6B41872CB40890A07BBED4D4E224D1EB35D6A8838EA2EB17B5E4C0238922FA8C2CC2FCCFB797F19901B1F1BD5715465B3981A440E21F56C4B0F21402D85490D2A3BF883D40DF2DD24E2C8223208F896F2222CCB2C5B25837861171BDD52542F908403F21A020ED9FDED6F7F67DBE9D84326CFF80AC167F1D3A74E59820E390DF2F8D5813A419C504DBA72F5AAE2B2AAC9CADD4A029E371B0902EEFA519120F200E21D56647A4D72F85203A8377E47FF335123BDCBCBD4ED094F7C7048B429770872A8DC04B9E44B0BEF872A86F21502AEF7290FBE707837513D0B99E38B107AE6332A6B16126FA8AE43CEA9DFD45345D3CF4276834E3DBC6DEE87175B3A0D0F7E877C791849E3BD7C8FBCB2ABFBED3BBC5F3D876A09F908D99E509D9C1209E76B15759AC9907222352B1DE453AB263CD4C9CF0AFF9B06D20CDCF72DAFB96FA3FE5F16F9C694E9F2D28226B66B26DEFEAA44DA2A121C5F4462D202F0CA3BD136B5F8CB16CFDA771D73DFC643514F515D3A907A554FD94A9E9D56312DFAB39FFD34FDF4A73F49CF3EABFEE4ECD974FCF8F1C4EEB3DF4589F77E142B28050505DF587C91EEA9F6297E5F47BEB0B064737FA884600D008283EE329DFEECEC9CEECF5B3D647E9EE3BCA5CF0C06103388239F68393250732F4B7676E354D185EA94EBD515FDF621067FAECB99689B50571226FCAA8E779116DBEFF09F238401C4B3D57BD96381C192678833024093A68EB63470E8B0DC60E8608B782359C63248734B9B6D41433E906E3689A336361CD000DB960E368ADC12FBBAB400B2942F05903AA4EB48B759C4C6C4830908127F0652D41DC857CA2236FD58F2424A5B47D164021507D2CE8481DF48F991D023593B76020B086744FACF9AF4616E7178F856BA71EDAACD1166E937164CF8E8BD2DE287FA04131D261B9822C4FCE0BFF817FF327DFFAD3745A88FA5BE9E2EC79F3089FB7FFE5FFF4BFABFFC5FFF6FE9BD77DFF31703C81584FFED1FFF38FD9BFFE6BFF1B6D76C4ED3D282DEF35787B094B3997EFD9BDFA7FFA438917FE419049BCD7576C908E5CA216A013AC9E4739688F385001DDEAB572EA72B572EA95C9804A286B44B8A284FC87AB7C8CE8913A7D3094DA4CE6386F0EC39DB5BEFEAEC16A95EB6AA129355137E39262F274492B0938E1A12246D726ACAF6EA17300DB9B21A933C5D27CE4CCC7ABABBAC83CF8486891F841A581D4188B601D1CEE9FB3448693C45B2E3B95C0F4953F6733FFC2C8FC7A3CE1FDEE3481DF1ED8AE86549397E8D4F8CA70B172FF9EBD67B1F7CE4891F0B5549F713EA2758D4FBBD375E17911CF0178AAFFAEBC897819C5F606676416E3EFDED2F7F957EF9CB5FA64B172FA8BE5C723F4639A3960609A7AE903794E7C1832CFA8D3AC6C48C097FABDA17A607DDDFC8D137B91FD2BFC8117E479F05B1FED9CF7E925E7EF965D70D36D6C1E427D689907653874DE8557F0A947F2AB0DD122B282828F88620774D1CFD9381B43AF7E0AAC101F505DCF60E12E1206599E432F8DCBC3962B5910FDE7F4F24AE393DFFFC0B1A689A2DC9B39B9BF1823F4CB6E1AF498EDE85845B02ADDF9C438E8D8A1854238FC79E8C88AFE256C5CFE772F17956F1D2D171AB4814562CE2B36DFDF30A476144301108CF843434F20132CA6086DE35A4BB4DE40D921A36A4BBD2E123C7BC28129285250C881104FC209F916DC98081B0491E6FC96DA7FB0795E6FB0D9E6C20DD86C8410C21CF38D42450B141928DDA035F12507158D373A4079BDEA847E4BCC3742012F199E9699BCEDBDC0CD38A99C09016DE438D86C90096554E9E7EC2C4107D71AC7A607E0F53840BF2CB03B617C5359B48910F7CC980C822ADE5FCE9A7CFA5BFFE27FF2CFDF8ED1FA6D75E79211D3B32646936F708FB57BFFABBF4EFFEFD7F9FDE7DF75D4F1E280BD4103047F86FFFEDBFB5CDF0C1A101E7E55705E2822DF8F9F9A5F4DBDFFD419382BF757DA52C28BF6C571964C9609439163A42D26C02D3C422D6A82F9F7CF251BA2037333D996667A6225FE55CE7E400A4896DC3B162F3DAEB6FD8620C139E63C74E7A4244FE6CF3E5C55F55765CEB86860EA5C38383969AA3B2C2DA07D418D03F6722669D7CD527CA94381DEAEF4B6CEED3D3DBE3AF2E102CA4E1A821C5A411A7B8902EFFFA6C64B24D1A017991F3E68B82709D17F58D5440AACF5712EAF5E8E8587AF7FD0FD27FF9E5DFA5DBC3B76D3AB4A3BDC35F7CDE78FDB5F4F39FFD343DF9C4699B28B485A1CA8F6F22725DE18B0A653A72674C13D93BE93FFEA7FF94FED7FFFC9FFDD56952930E26582E1F116E2657A882E03C29E72B93FDBAE73E803E01752FFAD8DCF6C853FA33C0D70E265F4CC2686F434343E95FFFEBFF3AFDE4273FF6579750650AE25DF06914025E5050F08D4426A510D4AABF57271F66D8D64502D9AE7D797533164B22715D5A9443171BFDD4D8F80629F888C8DCD5CB174D084E8A7820F964E0E13D749091E832602930931540B8B8903CC7EF0CFFE61E92200D4CF95906ADB89EDFE75E26DD312980F859D26D3FF3BBF287F708CB09DDDB254374904E590F532414B37E43478EA427CE603FF774EAC7AC9E1CA488E720E89026F4A56D5F5B0327C88B3FD1F3856CB139C7BADCF6F6DDB4B915440C493F040BB505C81679838A0D165B901C5BB75C6E53E497E74813C41FFDEBC8D76611F019DBAD463504A21EFAC5E443A546C3A4834985D20AE96477BE1327CF88449FD704A227CD88488EDE194E572E5DB0B9B44611D4BC48D1A44FE4813A810A0452BA1DC5194B2C2FBCF472FAD10F7F90FEFA1FFD553AFFF453A9BDADD50491FCFFF0A38FD3FFF83FFE7F457C7F2BD2FAB1276F4C52DE7EFB47E95FFFAB7F659BE2038790800701F92A4059B390F7F6ED1191BE0F351978DF256D09BFD2461A892F443313F04C3A7DD43FD4214225C2A7B549D2F5AB97BD4B2A0B57D171F703D57B505EF28CBA3134785813B4A3562D3A7BEE9974E2C4C974F4E831E71165835F9433526CF4CD91683249F257A28505D58F30554939100FD24450905A88D6D0D0A0BF2440C2F123D7645B99214DD5F91781D35FBD4138B491B8162D846BF5C82A115CA56EF9A8BAF720E007ED810D9A2E5FB9927EF7FB3FA4CB972FAB6C6EFB3A6582E4F6E5975E4AAFBDFA4AFADE1BAF282F7A6AF1CFE5F24D41CE0B8E739AE04DCF2CA4F7DE7F2FBDF7DE7BE97D1D3FFEF003AB87D16EE96FE8125069EA3F7428FD506DE6F5D75E1589EEB0D41A3031444081B946DA0E2A2CCD9AF82131CF758073EAC71BAFBF6A1BFCB41D54B9302FC8065B792D46D4D9077FBDF8AEA3E8801714147CEDA81F4CF9C539647159249A4D4B1616D94532541B62E1DF64BA333A9E46ACBF3D62DD5E7691BC7AF5BA756B71D857465F1BC9CFD8D888093A926E0658F45F592C8984765D842308E2DDC4663290439089631066487275AC9ECD7ADB4861F3311C4413FD6CDDE7C8359F8743F21B2414521EC43CFC86802369C2245A83C929DBBD432ED92DF2B8DCA953A7D233CF3EA701EF85F4AA88C1EBAFBF969ED5EF679F7DC1839E77B963715333642EEC1B43AA598CC5E404D50524D34899B13D8E940C950FEC9287E596315F474F1BAB092C9A9CB67D72ACB9CCDB3A8937DE91CBB6CAB73677370A4287181514066906606C06231DEF1649478A0D09CB648F324695C19BF328CEBDBD4C229A6C99C2F11411473D22B84E101E24A3D6336E6C480718D475D3E523BF284FDE3F3C386402D8DCC2C2B1D0DFCD2A2BE88CDFBA79C375A0B7AFDF26FAD804A4BF1FD3891DAE175F25B9C242096B0BB0823233139B0C211DCC132513CC7A072197DB657E555B91A39D20A146F79DB6824E389322BE54F839DD27BFF097AF28A85291B79467AC57D8F45700BEA4E478B82EAA1E321963D285A590B01DCD825ECA0C324DDD6CB18413C9BCD58E34D162E2EB683AFF22C29435A74C6CF3E4E2CF417E1EF29DFB0852CE6F3BA73223083AA849DD755ECBCBCA31F96502062C99A59D3B7F3662032D4DEE99C0933FA48B2F14D89627CD59B2FF4D00E9777AAAB46E6C30A1584BB78747D3E5AB37D21FFFF087F43B4D38D93115539780F4A22E8645A293F425E7CFA7BFFAAB5FA4BFFEAFFE517AFEB9E7ACA7FDF4D34F07893E76D4E62BBD685BFD1226048FAAAE0DF4F7A54111F763C78EA5B34F3D997EFAD39FA61FFFF8EDF4EC33CFF85DEF30AB090C6D89BCCA5FBE0A3E8D22012F2828F8DA50DFFDE45F9080EDAD1D4BDCD8A86472723AADACB19D72D8BB5E5D5DB61E2A830D161E200A0C969B5BB1083224B8611504EFD7F50E52D96D11510684C1C1C35E68C8200D118580133844794B7E6898F6E7D91C974CC0F34007E1305181846B2037519723303FC1518E6107C73DAC03F87DB92039E11FFE66205D227E1041746F21D383878F78338DB3679FAE76EAEB4D2DADED22B3A89E34A53691CCBBF71BE40E5AE77A7169C1BAACFC46AA1DBAD7B110314BB69D4F9504DBE7E49D1DD775CDD2EED8A0A5A68AA3BC6420CEBFB3E50C124C9C196CF9448F29414C11A27BCCF6F2E8A2234925DDECECC827F0E1DBB7D2F4D494C93A84193382A8A160EE10091C165290808F6BD2C484CBA60545500F288D48D8D1136FD600DFA0DFE4237AE9C4897820B5FCE10F7F94DE7CE37BE995975F4CC74522DADA5B5C7798B4FD87FFF01FD2BFFBF7FFCE1B22413C31ADF8F39FFF9575C75F7FED65930B00B1F93291EBC43BEFBE9F7EF977BFF384677272CAA48EC987C9CA41BE58401283AC66420E7CE49FAF55D244F987FE3B66DE6E2A3DB1C9D3CD34327CDBED842F1CE409D2695559D75BFC40526CB3843DBD56FD397DE64911B167D35367CF5ADA0DE18CC9D59A838938E47884349B857694C38EEAD6FA3AD644A65456CB2AEB56C7095594DEEE1E85435D6E0FC2AEFA417CFEDCBCA53D3A6001E92D30C1D63FDFAA8B5B1CB9924FE2500F26054CC8A83B8049246A531F7DFC49FADB5FFD9D26F3B7BC3E84FC278D904A5494D826FDE5979EF7D71EBCFD73D3F16523D7A98C3B63139A4C4FA677DF7B2FFDE9DD77AB1D65AFB8AD33090FD593262F541E383490DE529D7FEBADB7D233CF9C57FF72D61366CA07E02F0B52F98245BBC182515E8C9AFB2F9E85681F1331672B79EA709EC09277059F8F2201FF0682CA4F25CEC78282C709F5F51B52C0200E714682890E32366BB15C8284FBBDF73EF0C08819B9EBD76FF8333B926EA4DB2CAE1C1BBD93A6BCC90D5649B2545644BD22E5906E881E4419D208C1B47D641108C247C5021506EE617904AB1B48A81960B886D4AF26D946822DBF20A6F13B5FAFC8293ADD22DAF93D7E43B02D2D3701D7800F793721E73370EC66C9200649659314D422502B39AB41FFD9E79E4F2FBCF0527AFDF5D7D31BAFBF91CE9D0BC954774F9FC86ED8845E5A9A4F93ECBE69D38990B06BFE1A407EB1C326D2ED906C8F5BBACD261C599A9D1749665513A4DB0B0B6C793EE7DFA1CA139B0641CEC91B24DBE413E90FB51AC84C2CAA642120CFA197CEA63BA79F605BF4A7D2B12347AC1B1AFAC4CD09DBEA48E3C927E803E48CEB4817913C124FE218C49AADF7437581DF482F39874840F421FC1007EE13073F733F169421796732D321828A6E37640A09F4EF7FF77BE70BF145ED83FC1C54FC4E9F3A11BAF25F0179C8A4EFDAF55BE9E30B1795CF4C90B6BCB88FF4DB72888975F4F7595A9CFB7FFFD635FD886BAABBFAAFF6999FBA4F790174E6291FD2E767F18B3F7E1F08D2C602D8254DD6F2D7068226FFF94AC1C424B7D198BCC51721E214A42B540DC8DFFC45C3AA4A72B4B730C3992799F98B4EF5E5C26E379D5F144C1A7843B1F7B9FF77D24897B3A506E29D25FFFEADA3CF2B07AC0A56F9451BECECECF064736101151CD571FD66F24ABA2C095F61C1708325E1B9AE7EDD6A154C42E83FE933D167BF74F95A7AEF838FD31FFFF807B9DF7BA7CBF9F959B51995ADEA1926018F1CD5845E7DC8F3CF3F6FF5AB1FFCE0FB966AE79D639D5755597972A8EB7C61618BF833674E7BEB7E16A8E6F313278ED7D67FE4F75DCF0ABE100A01FF0680CEAE1EEE5AB9A68A5C2A73C1E384FABACE4F06776C71CFCECD89784DD96A09C41B5D5974337FF3DBDFA40F3FFCD01243A4A648D9D0510D09AD88B506527F9ECEC3B3FCB48446A4201C125B4899EE8A2C62179BC10549AA0759117F06DA900487D4D7D25E1DC3558B3BED5033A9CEF15BFEED4ABFC3913E4BC6E507E1397E3C2707198FDF4182203A10D52347D0813E6569ECF77FF0A3F4D39FFC24FDC37FF80B11EF57AD9B7C58E4B05983DBD2CA6A1A9D6047C7EBE9934F3E499F5CBC903EFAE8134D503E4E1F7EF441BA7AF5B2C9376A37732255A8D760A98423C41ABD6CC89677C81439231F21D5A4873CB2258DEAF33B042DC75929AAF12548227D528DD8885CB94C7102BAC12CFC648B7A26145DA8751CBC9FDA9A1BBD6B261BDFCCCD4E3B1E99D0935F1B1B6B5E70E909C2CCB4E3473EA19A41794598E8F7DEF70489B0BBBA7A52A7483D0B3799C4F08C49809E87A0436E21DE619AB0C9E5CBA649EFBCF34E9A525DA29EF4F5F53BEF21164F3E79C6AA2B5F459F8B49B8054D3C6E6BD288894B482A9FF5ADB72FD21BC4A53E6FE358733EAF089FF21AF2877A0D79C4E4756C6CD4132ED6023CF5D4594F9A286FC0E48F028C3F8834E5489E3644B9ABACB1A8C2FB4C56C973E285849C7C63C122449A7A8214344BED5191A23D222D86A8D28ED4FA144645DE95BF59F5073F508B327995DFD4994F3962A9F71E04EEC613819C2F99F0D5BB4CB2F99D8FB18835F2155FDC662BA08E421E22C957EED42615713DEA286D8673163832591A18E873B9811CCEA342CEAF9D1DD4F4EEA59BB747D4477E927EFD9BDFA65FFEF26FD395CB17551FEE280D2C34661D4490EA975E7AD1AA22B89FFEE4C796EC23B9F604506DA6E0D1A310F047041A0C0D9523E0779EC1D250E8DCF2C09CEFEF6FD88FBAA117147C59C88306A4270F78D8409E9D5DD0C03F9EAE5CB99AAE5F4737763C8D4F4C5A423B22D2FDD1C71F796114FADB48B6AD536D325C49607195BF0C9A26BFF2DF7AD822D026E9BAA6C04D4476B6376318D7209D25D910414808CF42344CE0F52CEF59726EE9367E57041AA24D5BCD7F7ADECE04BC7ABFFA0D098F7BF745FAB3D9B60EAB009C39F3447AE699E7D2D3E7B0B97DDED6295E7FFD7BE985179E4BCF3E73DE122B24BC569F989C14711BB194EBD2A54BE9E2A50BE9BAC824BB6FDEBC75537974CB5F02D85404B50DD473B052120BAF6272813E6B1089B01B1E2A2522154A372403559DD0E98EC98DB3A9FA8FA37A24F5417121F74FFC5557ACCF8D0A0336C6B1398EDE37D6115A9B1B527B6B736AD784634779814E2A527924DC965A2B2EC48F782391A53CC8C34CBE1D44E5C853EA00F7D02F277F207741C4449F20EB7A94F7207B48368F1C3E6CD508EA1D1270BEA02081DF52BE447CFBD23124834F3D69FDF94C7EBF0CE4FE7C7171D9DBCF43C047EF8CBAFEEBAEEB049306485F4873775D8D8457E49B67E4A1CB8EB4F1D584BAC164061BEBD8E7669D00049C490C5F12A8BBE871CB873ABF959526A922C9BA874D68ECB4CF4C4FE1BD61DDFC362C5B842434481C791A0B82C937A4DA58C7818443BE5D66F84D7CF5875F6E93D47DF9D3A449183AE7CD3AF22C7993D3578F487B94E7E7C1CF9237F8B3CF65F8DC79C809B92EF09F1C7120EE7C31DBDADAF1EC84F118E2CDA41C7537DA10ED89C93A0BBFC99390FA2A2F34D1A39C407D985F26723EE5DFF155E2AE26D98BAA5333E9FD0F3EF422D277FFF44
