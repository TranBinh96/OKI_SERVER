create  database  Wrapper_Backup;
use  Wrapper_Backup;


-- auto-generated definition
create table dbo.t_worker
(
    作業者ID nvarchar(50),
    作業者名 nvarchar(50),
    属性     int,
    生産性   nvarchar(3)
)
go
-- auto-generated definition
create table dbo.t_IR_SN
(
    No      int identity
        constraint PK_t_IR_SN
            primary key,
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
go
-- auto-generated definition
create table dbo.t_IR_out
(
    job_no         int identity,
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
    batname        nvarchar(max),
    tplog          nvarchar(max)
)
go
-- auto-generated definition
create table dbo.t_IR_kotei
(
    No               int identity,
    ID               nvarchar(200),
    工程ファイル     nvarchar(50),
    構成ファイルパス nvarchar(200),
    指示書テーブル   nvarchar(200),
    備考             nvarchar(50),
    バーコード       nvarchar(1000)
)
go
drop table t_IR_result;

-- auto-generated definition
create table dbo.t_IR_result
(
    id             int identity,
    job_no         int,
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
go
create clustered index [ClusteredIndex-20230225-194000]
    on dbo.t_IR_result (unit_no)
go
