exec Backup_t_worker_235_to_125

CREATE PROCEDURE Backup_t_worker_235_to_125
AS
BEGIN
    MERGE INTO t_worker AS target
    USING [SERVER235].[Wrapper].[dbo].[t_worker] AS source
    ON (target.作業者ID COLLATE SQL_Latin1_General_CP1_CI_AS = source.作業者ID COLLATE SQL_Latin1_General_CP1_CI_AS)
    WHEN MATCHED THEN
        UPDATE SET
            target.作業者名 = source.作業者名,
            target.属性 = source.属性,
            target.生産性 = source.生産性
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (作業者ID, 作業者名, 属性, 生産性)
        VALUES (source.作業者ID, source.作業者名, source.属性, source.生産性);
END
go