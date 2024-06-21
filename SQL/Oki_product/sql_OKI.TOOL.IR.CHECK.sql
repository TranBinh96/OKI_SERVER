create database  Oki_product;
use  Oki_product;

create  table t_IR_Search_result(
    no int NOT NULL  IDENTITY,
    job_no int,
    kotei_filename varchar(255),
    unit_no varchar(50),
    st_no varchar(100),
    start_time datetime,
    finish_time datetime,
    remarks varchar(max),
    time_access datetime,
    pcline varchar(100),
);
-------------------------------
create  table quantity(
    no int NOT NULL  IDENTITY,
    day int,
    month int,
    year int,
    time_update datetime
);
-------------------------------------
CREATE PROCEDURE Get_Infrared_Radiation
    @seri_number VARCHAR(150)
AS
BEGIN
    DECLARE @remarks VARCHAR(25)
    DECLARE @ValueRemarks VARCHAR(25) = 'FINISH'
    DECLARE @sqlcreateTable NVARCHAR(MAX)

    DECLARE @tableName NVARCHAR(100) = @seri_number

    -- Tạo bảng tạm ##@tableName
    SET @sqlcreateTable = 'CREATE TABLE ##' + @tableName + ' (' +
        ' no int NOT NULL  IDENTITY,
        job_no INT,
        kotei_filename VARCHAR(255),
        unit_no VARCHAR(50),
        st_no VARCHAR(100),
        start_time DATETIME,
        finish_time DATETIME,
        remarks VARCHAR(MAX),
        time_access DATETIME
    );'
    EXEC sp_executesql @sqlcreateTable

    -- In câu lệnh tạo bảng để kiểm tra
    PRINT @sqlcreateTable

    -- Chèn dữ liệu vào bảng tạm ##@tableName
    DECLARE @sqlInsert NVARCHAR(MAX)
    SET @sqlInsert =
        'INSERT INTO ##' + @tableName + ' (job_no, kotei_filename, unit_no, st_no, start_time, finish_time, remarks, time_access) ' +
        'SELECT TOP 20 job_no, kotei_filename, unit_no, st_no, start_time, finish_time, remarks, GETDATE() AS time_access ' +
        'FROM [SERVER235].[Wrapper].[dbo].[t_IR_result] ' +
        'WHERE unit_no = @seri_number ' +
        'ORDER BY finish_time DESC;'
    EXEC sp_executesql @sqlInsert, N'@seri_number VARCHAR(25)', @seri_number

    -- Kiểm tra và thực thi các lệnh khác
    BEGIN
        DECLARE @sqlResult NVARCHAR(100) = 'SELECT TOP 1 ' + @remarks + ' remarks FROM ##' + @tableName + ' WHERE remarks = ' + @ValueRemarks;
        DECLARE @sqlOK NVARCHAR(100) = 'SELECT TOP 1 * FROM ##' + @tableName + ' WHERE remarks = ' + @ValueRemarks;
        DECLARE @sqlNG NVARCHAR(100) =  'SELECT TOP 1 * FROM ##' + @tableName ;
        DECLARE @dropsql NVARCHAR(100) =  'DROP TABLE ##' + @tableName;
        EXEC sp_executesql @sqlResult;
        IF @remarks = @ValueRemarks
            EXEC sp_executesql @sqlOK;
        ELSE
            EXEC sp_executesql @sqlNG;
        -- Xóa bảng tạm khi đã sử dụng xong
        EXEC sp_executesql @dropsql;
    END;
END;
go
-------------------------------------
CREATE PROCEDURE Get_Infrared_Radiations
   @seri_number varchar(50)
AS
BEGIN
    insert  into t_IR_Search_result (job_no,kotei_filename,unit_no,st_no,start_time,finish_time,remarks,time_access)
    select
    job_no,
    kotei_filename,
    unit_no,
    st_no,
    start_time,
    finish_time,
    remarks,
    getdate() as 'time_access'
    from [SERVER235].[Wrapper].[dbo].[t_IR_result] where unit_no like '%'+@seri_number+'%' and remarks LIKE '%F%'
    select  * from  t_IR_Search_result order by time_access desc ;
END;
go
----------------------------------------
CREATE PROCEDURE Insert_Infrared_Radiations
   @job_no  varchar(50),
   @kotei_filename varchar(50),
   @unit_no varchar(50),
   @st_no varchar(50),
   @start_time varchar(50),
   @finish_time varchar(50),
   @remarks varchar(50),
   @pcline varchar(50)
AS
BEGIN
    INSERT INTO  t_IR_Search_result values (@job_no,@kotei_filename,@unit_no,@st_no,CAST(@start_time AS DATETIME),CAST(@finish_time AS DATETIME),@remarks,getdate(),@pcline);
END;
go

-----------------------------------------------
create  procedure  P_GET_SUM_DAY
     @pcline varchar(50)
as
SELECT
        COUNT(*) AS sum_unit,
        SUM(CASE WHEN remarks = 'FINISH' THEN 1 ELSE 0 END) AS ok,
        SUM(CASE WHEN remarks = 'NG' THEN 1 ELSE 0 END) AS ng
    FROM
        t_IR_Search_result
    WHERE
        CONVERT(DATE, time_access) = CONVERT(DATE, GETDATE())
    and  pcline = @pcline
go

---------------------------------------------
create  procedure  P_GET_SUM_MONTH
 @pcline varchar(50)
as
begin
    SELECT
        DATEPART(MONTH, time_access) AS month,
        SUM(CASE WHEN remarks = 'FINISH' THEN 1 ELSE 0 END) AS Total_OK
    FROM
        t_IR_Search_result
    WHERE
        remarks = 'FINISH'
        AND DATEPART(MONTH, time_access) = MONTH(GETDATE()) -- Lọc theo tháng hiện tại
    and  pcline = @pcline
    GROUP BY
        DATEPART(MONTH, time_access)
end
go

-----------------------------------
SELECT
        COUNT(*) AS sum_unit,
        SUM(CASE WHEN remarks = 'FINISH' THEN 1 ELSE 0 END) AS ok,
        SUM(CASE WHEN remarks = 'NG' THEN 1 ELSE 0 END) AS ng
    FROM
        t_IR_Search_result
    WHERE
        CONVERT(DATE, time_access) = CONVERT(DATE, GETDATE())
-------------------------------------
SELECT
        DATEPART(MONTH, time_access) AS month,
        SUM(CASE WHEN remarks = 'FINISH' THEN 1 ELSE 0 END) AS Total_OK
    FROM
        t_IR_Search_result
    WHERE
        remarks = 'FINISH'
        AND DATEPART(MONTH, time_access) = MONTH(GETDATE()) -- Lọc theo tháng hiện tại
    GROUP BY
        DATEPART(MONTH, time_access)
-------------------------------------

