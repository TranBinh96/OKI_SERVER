CREATE PROCEDURE Backup_t_IR_SN_235_to_125
AS
BEGIN

CREATE TABLE ##source
(
    unit_no varchar(50) not null,
    SN01    varchar(50),
    SN02    varchar(50),
    SN03    varchar(50),
    SN04    varchar(50),
    SN05    varchar(50),
    SN06    varchar(50),
    SN07    varchar(50),
    SN08    varchar(50),
    SN09    varchar(50),
    SN10    varchar(50),
    SN11    varchar(50),
    SN12    varchar(50),
    SN13    varchar(50),
    SN14    varchar(50)
)

INSERT INTO ##source (unit_no,SN01,SN02,SN03,SN04,SN05,SN06,SN07,SN08,SN09,SN10,SN11,SN12,SN13,SN14)
SELECT unit_no,SN01,SN02,SN03,SN04,SN05,SN06,SN07,SN08,SN09,SN10,SN11,SN12,SN13,SN14
FROM [SERVER235].[Wrapper].[dbo].[t_IR_SN]

MERGE INTO t_IR_SN AS target
USING  ##source AS source
ON (target.unit_no = source.unit_no )
WHEN MATCHED THEN
    UPDATE SET
        target.unit_no = source.unit_no,target.SN01   = source.SN01,
        target.SN02   = source.SN02,target.SN03   = source.SN03,
        target.SN04   = source.SN04,target.SN05   = source.SN05,
        target.SN06   = source.SN06, target.SN07   = source.SN07,
        target.SN08   = source.SN08, target.SN09   = source.SN09,
        target.SN10   = source.SN10,target.SN11   = source.SN11,
        target.SN12   = source.SN12,target.SN13   = source.SN13
WHEN NOT MATCHED BY target THEN
    INSERT (unit_no,SN01,SN02,SN03,SN04,SN05,SN06,SN07,SN08,SN09,SN10,SN11,SN12,SN13,SN14)
    VALUES (source.unit_no,source.SN01,source.SN02,source.SN03,source.SN04,source.SN05,
            source.SN06,source.SN07,source.SN08,source.SN09,source.SN10,source.SN11,source.SN12,source.SN13,source.SN14);
drop table  ##source;
END
go

