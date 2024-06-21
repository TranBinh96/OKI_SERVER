exec Backup_IR_Search_result_235_to_125;
CREATE PROCEDURE Backup_IR_Search_result_235_to_125
AS
BEGIN
MERGE INTO t_IR_Search_result AS target
USING [SERVER235].[Oki_product].[dbo].[t_IR_Search_result] AS source
ON (target.job_no = source.job_no )
WHEN MATCHED THEN
    UPDATE SET
        target.job_no= source.job_no,
        target.kotei_filename= source.kotei_filename,
        target.unit_no= source.unit_no,
        target.st_no= source.st_no,
        target.start_time= source.start_time,
        target.finish_time= source.finish_time,
        target.remarks= source.remarks,
        target.time_access= source.time_access,
        target.pcline= source.pcline
WHEN NOT MATCHED BY target THEN
    INSERT (job_no,kotei_filename,unit_no,st_no,start_time,finish_time,remarks,time_access,pcline)
    VALUES (source.job_no,source.kotei_filename,source.unit_no,
            source.st_no,source.start_time,source.finish_time,source.remarks,source.time_access,source.pcline);
END
go

