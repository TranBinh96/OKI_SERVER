
create  proc p_ip_address_not_use
as
    begin
        CREATE TABLE ##Computer (
        ip VARCHAR(200)
        );

        DECLARE @ip VARCHAR(200)
        DECLARE @counter INT
        SET @counter = 1

        WHILE @counter <= 254
        BEGIN
            SET @ip = '10.17.156.' + CAST(@counter AS VARCHAR(3))
            INSERT INTO ##Computer (ip) VALUES (@ip)
            SET @counter = @counter + 1
        END

        SET @counter = 1

        WHILE @counter <= 254
        BEGIN
            SET @ip = '10.17.154.' + CAST(@counter AS VARCHAR(3))
            INSERT INTO ##Computer (ip) VALUES (@ip)
            SET @counter = @counter + 1
        END

        select  * from ##Computer

        select  #C.ip,
               CASE
                WHEN CHARINDEX('156', #C.ip) > 0 THEN '156'
                WHEN CHARINDEX('154', #C.ip) > 0 THEN '154'
                ELSE NULL
            END AS [range]
        from  Computer right join
            ##Computer #C on Computer.ip = #C.ip
        where Computer.id IS NULL

        ORDER BY
            CAST(PARSENAME(#C.ip, 4) AS INT),
            CAST(PARSENAME(#C.ip, 3) AS INT),
            CAST(PARSENAME(#C.ip, 2) AS INT),
            CAST(PARSENAME(#C.ip, 1) AS INT);
        drop  table  ##Computer;
    end
