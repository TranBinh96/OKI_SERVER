
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

    /*--------------------------------*/
    create  proc  p_computer
    as
    SELECT L.id as ip_line, U.id as ip_unit, C.pc_name, C.ip, C.status_use, C.[range], C.computer_type, C.note
    FROM Computer C
    INNER JOIN Unit U ON U.Id = C.unit_id
    INNER JOIN Line L ON L.Id = U.line_id
    ORDER BY
        CAST(PARSENAME(C.ip, 4) AS INT),
        CAST(PARSENAME(C.ip, 3) AS INT),
        CAST(PARSENAME(C.ip, 2) AS INT),
        CAST(PARSENAME(C.ip, 1) AS INT);



create  proc  p_new_pcname
    as
    begin

        DECLARE @current_pc_name NVARCHAR(50);
        SELECT TOP 1 @current_pc_name = pc_name
        FROM Oki_product.dbo.Computer
        WHERE LEFT(pc_name, 4) = 'PAS0' AND LEN(pc_name) >= 7
        ORDER BY pc_name DESC;

        -- Kiểm tra nếu có giá trị mới
        IF @current_pc_name IS NOT NULL
        BEGIN
            -- Tạo giá trị mới
            DECLARE @new_pc_name NVARCHAR(50);
            SET @new_pc_name = 'PAS' + RIGHT('000' + CAST(CAST(RIGHT(@current_pc_name, LEN(@current_pc_name) - 3) AS INT) + 1 AS NVARCHAR(10)), 3);

            -- Hiển thị giá trị mới
            SELECT @new_pc_name AS new_pc_name;
        END
    end
