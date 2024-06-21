exec Backup_IR_Search_result_235_to_125


CREATE PROCEDURE Backup_t_IR_result_235_to_125
AS
BEGIN

CREATE TABLE ##source
(
    job_no         int ,
    worker         nvarchar(100),
    kotei_filename text,
    kotei_no       int,
    unit_no        varchar(50),
    result         int,
    start_time     datetime,
    finish_time    datetime,
    st_no          nvarchar(100),
    errorcode      nvarchar(100),
    errorname      nvarchar(100),
    remarks        nvarchar(max),
    batname        nvarchar(300),
    tplog          nvarchar(max)
)
DECLARE @StartDate DATETIME = DATEADD(DAY, -7, CAST(GETDATE() AS DATE)); -- Lấy ngày bắt đầu từ 7 ngày trước
    print  @StartDate;
-- Lấy ngày trước đó (không bao gồm ngày hiện tại)
DECLARE @EndDate DATETIME = CONVERT(DATE, GETDATE())-- Lấy ngày hiện tại
print @EndDate;

INSERT INTO ##source (job_no, worker, kotei_filename, kotei_no, unit_no ,
      result, start_time, finish_time, st_no , errorcode, errorname, remarks, batname, tplog)
SELECT job_no, worker, kotei_filename, kotei_no, unit_no ,
      result, start_time, finish_time, st_no , errorcode, errorname, remarks, batname, tplog
FROM [SERVER235].[Wrapper].[dbo].[t_IR_result]
WHERE finish_time >= @StartDate AND finish_time < CAST(@EndDate AS DATETIME);


MERGE INTO t_IR_result AS target
USING  ##source AS source
ON (target.job_no = source.job_no )
WHEN MATCHED THEN
    UPDATE SET
        target.job_no = source.job_no,
        target.worker = source.worker,
        target.kotei_filename = source.kotei_filename,
        target.kotei_no = source.kotei_no,
        target.unit_no = source.unit_no,
        target.result = source.result,
        target.start_time = source.start_time,
        target.finish_time = source.finish_time,
        target.st_no = source.st_no,
        target.errorcode = source.errorcode,
        target.errorname = source.errorname,
        target.remarks = source.remarks,
        target.batname = source.batname,
        target.tplog = source.tplog
WHEN NOT MATCHED BY target THEN
    INSERT (job_no,worker,kotei_filename,kotei_no,unit_no,result,start_time,
            finish_time,st_no,errorcode,errorname,remarks,batname,tplog)
    VALUES (source.job_no,source.worker,source.kotei_filename,source.kotei_no,
            source.unit_no,source.result,source.start_time,source.finish_time,source.st_no,source.errorcode,source.errorname,source.remarks,source.batname,source.tplog);

select  * from ##source;
drop table  ##source;
END
go

