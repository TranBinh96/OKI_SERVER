CREATE PROCEDURE Backup_t_IR_result_125_to_ServePreventive
    @day int
AS
BEGIN

    IF NOT EXISTS (
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = 'dbo'
        AND TABLE_NAME = 't_IR_result'
        AND COLUMN_NAME = 'job_no_backup'
    )
    BEGIN
        -- Add the column if it doesn't exist
        EXEC('ALTER TABLE dbo.t_IR_result ADD job_no_backup int;');
        EXEC('delete from  t_IR_result;');

        PRINT 'Column job_no_backup added successfully.';
    END
    ELSE
    BEGIN
        PRINT 'Column job_no_backup already exists in t_IR_result.';
    END

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

    INSERT INTO ##source (job_no, worker, kotei_filename, kotei_no, unit_no ,
          result, start_time, finish_time, st_no , errorcode, errorname, remarks, batname, tplog)
    SELECT job_no, worker, kotei_filename, kotei_no, unit_no ,
          result, start_time, finish_time, st_no , errorcode, errorname, remarks, batname, tplog
    FROM [SERVER125].[Wrapper_Backup].[dbo].[t_IR_result]
    WHERE  CONVERT(DATE, finish_time) >= CONVERT(DATE, DATEADD(DAY, -@day, CAST(GETDATE() AS DATE)))
    AND CONVERT(DATE, finish_time) <= CONVERT(DATE, getdate());

    MERGE INTO t_IR_result AS target
    USING  ##source AS source
    ON (target.unit_no = source.unit_no and source.kotei_no = target.kotei_no )

    WHEN NOT MATCHED BY target THEN
        INSERT (worker,kotei_filename,kotei_no,unit_no,result,start_time,
                finish_time,st_no,errorcode,errorname,remarks,batname,tplog,job_no_backup)
        VALUES (source.worker,source.kotei_filename,source.kotei_no,
                source.unit_no,source.result,source.start_time,source.finish_time,source.st_no,
                source.errorcode,source.errorname,source.remarks,source.batname,source.tplog,source.job_no);


    MERGE INTO t_IR_result AS target
    USING  ##source AS source
    ON (target.job_no_backup = source.job_no )
    WHEN MATCHED THEN
        UPDATE SET
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
            target.tplog = source.tplog;
    drop table  ##source;
END
go

