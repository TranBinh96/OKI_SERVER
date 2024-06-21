CREATE  Proc  Create_LinkServer_125
as
DECLARE @servername sysname = 'SERVER125';  -- Tên của linked server mới
DECLARE @isLinkedServerExists bit;

-- Kiểm tra xem linked server đã tồn tại chưa
SET @isLinkedServerExists = (
    SELECT CASE WHEN EXISTS (
        SELECT 1
        FROM sys.servers
        WHERE name = @servername
    ) THEN 1 ELSE 0 END
);

IF @isLinkedServerExists = 0
BEGIN
    -- Tạo Linked Server mới
    EXEC sp_addlinkedserver
       @server = @servername,
       @srvproduct = '',  -- Không cần điền
       @provider = 'SQLNCLI',  -- Tên của provider, ở đây là SQL Native Client
       @datasrc = '10.17.154.125';  -- Địa chỉ IP của server SQL Server muốn kết nối

    -- Tạo quyền truy cập cho Linked Server
    EXEC sp_addlinkedsrvlogin
       @rmtsrvname = @servername,  -- Tên của linked server
       @useself = 'false',  -- Sử dụng quyền đăng nhập cụ thể
       @rmtuser = 'okipe',  -- Tên đăng nhập trên server đích
       @rmtpassword = 'oki2024$';  -- Mật khẩu của đăng nhập trên server đích

    PRINT 'Linked Server created successfully.';
END
ELSE
BEGIN
    PRINT 'Linked Server already exists.';
END
go

