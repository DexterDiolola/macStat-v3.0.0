DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `package_dispense_results`(IN `trend` VARCHAR(180), IN `owner` VARCHAR(180))
    NO SQL
BEGIN
    DROP TABLE IF EXISTS temp_package_results;
        CREATE TEMPORARY TABLE temp_package_results(
            id INT(10) AUTO_INCREMENT PRIMARY KEY,
            xxxMinutes INT(10) NOT NULL DEFAULT 0,
            iHour INT(10) NOT NULL DEFAULT 0,
            iiHours INT(10) NOT NULL DEFAULT 0,
            iiiHours INT(10) NOT NULL DEFAULT 0,
            vHours INT(10) NOT NULL DEFAULT 0,
            iDay INT(10) NOT NULL DEFAULT 0,
            iiDays INT(10) NOT NULL DEFAULT 0,
            ivDays INT(10) NOT NULL DEFAULT 0,
            iWeek INT(10) NOT NULL DEFAULT 0,
            dateCreated DATETIME NOT NULL DEFAULT 0
        );
        

    # FOR DASHBOARD total Dispense and total Value PURPOSE
    # total dispense & total value - needed in dashboard->dispense

    IF trend = 'overall-perDay' THEN
        INSERT INTO temp_package_results(xxxMinutes, iHour, iiHours, iiiHours, vHours,
                        iDay, iiDays, ivDays, iWeek, dateCreated)

        SELECT SUM(xxxMinutes), SUM(iHour), SUM(iiHours), 
        SUM(iiiHours), SUM(vHours), SUM(iDay), SUM(iiDays), 
        SUM(ivDays), SUM(iWeek), dateCreated FROM computed_packages 
        GROUP BY DATE(dateCreated);

        SELECT MAX(xxxMinutes) + MAX(iHour) + MAX(iiHours) +
        MAX(iiiHours) + MAX(vHours) + MAX(iDay) + MAX(iiDays) + 
        MAX(ivDays) + MAX(iWeek) AS totalDispense,
        3*MAX(xxxMinutes) + 5*MAX(iHour) + 10*MAX(iiHours) +
        15*MAX(iiiHours) + 20*MAX(vHours) + 30*MAX(iDay) + 40*MAX(iiDays) + 
        50*MAX(ivDays) + 60*MAX(iWeek) AS totalValue 
        FROM temp_package_results;
        
    ELSEIF trend = 'overall-perWeek' THEN
        INSERT INTO temp_package_results(xxxMinutes, iHour, iiHours, iiiHours, vHours,
                        iDay, iiDays, ivDays, iWeek, dateCreated)

        SELECT SUM(xxxMinutes), SUM(iHour), SUM(iiHours), 
        SUM(iiiHours), SUM(vHours), SUM(iDay), SUM(iiDays), 
        SUM(ivDays), SUM(iWeek), dateCreated FROM computed_packages 
        GROUP BY WEEK(dateCreated);
        
        SELECT MAX(xxxMinutes) + MAX(iHour) + MAX(iiHours) +
        MAX(iiiHours) + MAX(vHours) + MAX(iDay) + MAX(iiDays) + 
        MAX(ivDays) + MAX(iWeek) AS totalDispense,
        3*MAX(xxxMinutes) + 5*MAX(iHour) + 10*MAX(iiHours) +
        15*MAX(iiiHours) + 20*MAX(vHours) + 30*MAX(iDay) + 40*MAX(iiDays) + 
        50*MAX(ivDays) + 60*MAX(iWeek) AS totalValue 
        FROM temp_package_results;

    ELSEIF trend = 'overall-perMonth' THEN
        INSERT INTO temp_package_results(xxxMinutes, iHour, iiHours, iiiHours, vHours,
                        iDay, iiDays, ivDays, iWeek, dateCreated)

        SELECT SUM(xxxMinutes), SUM(iHour), SUM(iiHours), 
        SUM(iiiHours), SUM(vHours), SUM(iDay), SUM(iiDays), 
        SUM(ivDays), SUM(iWeek), dateCreated FROM computed_packages 
        GROUP BY MONTH(dateCreated);
        
        SELECT MAX(xxxMinutes) + MAX(iHour) + MAX(iiHours) +
        MAX(iiiHours) + MAX(vHours) + MAX(iDay) + MAX(iiDays) + 
        MAX(ivDays) + MAX(iWeek) AS totalDispense,
        3*MAX(xxxMinutes) + 5*MAX(iHour) + 10*MAX(iiHours) +
        15*MAX(iiiHours) + 20*MAX(vHours) + 30*MAX(iDay) + 40*MAX(iiDays) + 
        50*MAX(ivDays) + 60*MAX(iWeek) AS totalValue 
        FROM temp_package_results;

    ELSEIF trend = 'overall-perDay-user' THEN
        INSERT INTO temp_package_results(xxxMinutes, iHour, iiHours, iiiHours, vHours,
                        iDay, iiDays, ivDays, iWeek, dateCreated)

        SELECT SUM(xxxMinutes), SUM(iHour), SUM(iiHours), 
        SUM(iiiHours), SUM(vHours), SUM(iDay), SUM(iiDays), 
        SUM(ivDays), SUM(iWeek), computed_packages.dateCreated FROM computed_packages
        LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac 
        WHERE macs_users.owner = owner 
        GROUP BY DATE(computed_packages.dateCreated);
        
        SELECT MAX(xxxMinutes) + MAX(iHour) + MAX(iiHours) +
        MAX(iiiHours) + MAX(vHours) + MAX(iDay) + MAX(iiDays) + 
        MAX(ivDays) + MAX(iWeek) AS totalDispense,
        3*MAX(xxxMinutes) + 5*MAX(iHour) + 10*MAX(iiHours) +
        15*MAX(iiiHours) + 20*MAX(vHours) + 30*MAX(iDay) + 40*MAX(iiDays) + 
        50*MAX(ivDays) + 60*MAX(iWeek) AS totalValue 
        FROM temp_package_results;

    ELSEIF trend = 'overall-perWeek-user' THEN
        INSERT INTO temp_package_results(xxxMinutes, iHour, iiHours, iiiHours, vHours,
                        iDay, iiDays, ivDays, iWeek, dateCreated)

        SELECT SUM(xxxMinutes), SUM(iHour), SUM(iiHours), 
        SUM(iiiHours), SUM(vHours), SUM(iDay), SUM(iiDays), 
        SUM(ivDays), SUM(iWeek), computed_packages.dateCreated FROM computed_packages
        LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac 
        WHERE macs_users.owner = owner 
        GROUP BY WEEK(computed_packages.dateCreated);
        
        SELECT MAX(xxxMinutes) + MAX(iHour) + MAX(iiHours) +
        MAX(iiiHours) + MAX(vHours) + MAX(iDay) + MAX(iiDays) + 
        MAX(ivDays) + MAX(iWeek) AS totalDispense,
        3*MAX(xxxMinutes) + 5*MAX(iHour) + 10*MAX(iiHours) +
        15*MAX(iiiHours) + 20*MAX(vHours) + 30*MAX(iDay) + 40*MAX(iiDays) + 
        50*MAX(ivDays) + 60*MAX(iWeek) AS totalValue 
        FROM temp_package_results;

    ELSEIF trend = 'overall-perMonth-user' THEN
        INSERT INTO temp_package_results(xxxMinutes, iHour, iiHours, iiiHours, vHours,
                        iDay, iiDays, ivDays, iWeek, dateCreated)

        SELECT SUM(xxxMinutes), SUM(iHour), SUM(iiHours), 
        SUM(iiiHours), SUM(vHours), SUM(iDay), SUM(iiDays), 
        SUM(ivDays), SUM(iWeek), computed_packages.dateCreated FROM computed_packages
        LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac 
        WHERE macs_users.owner = owner 
        GROUP BY MONTH(computed_packages.dateCreated);
        
        SELECT MAX(xxxMinutes) + MAX(iHour) + MAX(iiHours) +
        MAX(iiiHours) + MAX(vHours) + MAX(iDay) + MAX(iiDays) + 
        MAX(ivDays) + MAX(iWeek) AS totalDispense,
        3*MAX(xxxMinutes) + 5*MAX(iHour) + 10*MAX(iiHours) +
        15*MAX(iiiHours) + 20*MAX(vHours) + 30*MAX(iDay) + 40*MAX(iiDays) + 
        50*MAX(ivDays) + 60*MAX(iWeek) AS totalValue 
        FROM temp_package_results;






    # Needed to display 30Mins, 1Hr, 2Hrs, 5Hrs, 1Day, 2Days in Dashboard->Dispense section
     ELSEIF trend='overall2-perDay' THEN
        INSERT INTO temp_package_results(xxxMinutes, iHour, iiHours, iiiHours, vHours,
                    iDay, iiDays, ivDays, iWeek, dateCreated)

            SELECT SUM(xxxMinutes), SUM(iHour), SUM(iiHours), 
            SUM(iiiHours), SUM(vHours), SUM(iDay), SUM(iiDays), 
            SUM(ivDays), SUM(iWeek), dateCreated FROM computed_packages 
            GROUP BY DATE(dateCreated);

        SELECT MAX(xxxMinutes) AS xxxMinutes, MAX(iHour) AS iHour, MAX(iiHours) AS iiHours, 
        MAX(iiiHours) AS iiiHours, MAX(vHours) AS vHours, MAX(iDay) AS iDay, MAX(iiDays) AS iiDays, 
        MAX(ivDays) AS ivDays, MAX(iWeek) AS iWeek FROM temp_package_results;

    ELSEIF trend='overall2-perWeek' THEN
        INSERT INTO temp_package_results(xxxMinutes, iHour, iiHours, iiiHours, vHours,
                    iDay, iiDays, ivDays, iWeek, dateCreated)

            SELECT SUM(xxxMinutes), SUM(iHour), SUM(iiHours), 
            SUM(iiiHours), SUM(vHours), SUM(iDay), SUM(iiDays), 
            SUM(ivDays), SUM(iWeek), dateCreated FROM computed_packages 
            GROUP BY WEEK(dateCreated);

        SELECT MAX(xxxMinutes) AS xxxMinutes, MAX(iHour) AS iHour, MAX(iiHours) AS iiHours, 
        MAX(iiiHours) AS iiiHours, MAX(vHours) AS vHours, MAX(iDay) AS iDay, MAX(iiDays) AS iiDays, 
        MAX(ivDays) AS ivDays, MAX(iWeek) AS iWeek FROM temp_package_results;

    ELSEIF trend='overall2-perMonth' THEN
        INSERT INTO temp_package_results(xxxMinutes, iHour, iiHours, iiiHours, vHours,
                    iDay, iiDays, ivDays, iWeek, dateCreated)

            SELECT SUM(xxxMinutes), SUM(iHour), SUM(iiHours), 
            SUM(iiiHours), SUM(vHours), SUM(iDay), SUM(iiDays), 
            SUM(ivDays), SUM(iWeek), dateCreated FROM computed_packages 
            GROUP BY MONTH(dateCreated);

        SELECT MAX(xxxMinutes) AS xxxMinutes, MAX(iHour) AS iHour, MAX(iiHours) AS iiHours, 
        MAX(iiiHours) AS iiiHours, MAX(vHours) AS vHours, MAX(iDay) AS iDay, MAX(iiDays) AS iiDays, 
        MAX(ivDays) AS ivDays, MAX(iWeek) AS iWeek FROM temp_package_results;

    # For Users (uses the 'mac' parameter to input name of a user)
    ELSEIF trend='overall2-perDay-user' THEN
        INSERT INTO temp_package_results(xxxMinutes, iHour, iiHours, iiiHours, vHours,
                    iDay, iiDays, ivDays, iWeek, dateCreated)

            SELECT SUM(xxxMinutes), SUM(iHour), SUM(iiHours), 
            SUM(iiiHours), SUM(vHours), SUM(iDay), SUM(iiDays), 
            SUM(ivDays), SUM(iWeek), computed_packages.dateCreated FROM computed_packages 
            LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac 
            WHERE macs_users.owner = owner 
            GROUP BY DATE(computed_packages.dateCreated);

        SELECT MAX(xxxMinutes) AS xxxMinutes, MAX(iHour) AS iHour, MAX(iiHours) AS iiHours, 
        MAX(iiiHours) AS iiiHours, MAX(vHours) AS vHours, MAX(iDay) AS iDay, MAX(iiDays) AS iiDays, 
        MAX(ivDays) AS ivDays, MAX(iWeek) AS iWeek FROM temp_package_results;

    ELSEIF trend='overall2-perWeek-user' THEN
        INSERT INTO temp_package_results(xxxMinutes, iHour, iiHours, iiiHours, vHours,
                    iDay, iiDays, ivDays, iWeek, dateCreated)

            SELECT SUM(xxxMinutes), SUM(iHour), SUM(iiHours), 
            SUM(iiiHours), SUM(vHours), SUM(iDay), SUM(iiDays), 
            SUM(ivDays), SUM(iWeek), computed_packages.dateCreated FROM computed_packages 
            LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac 
            WHERE macs_users.owner = owner 
            GROUP BY WEEK(computed_packages.dateCreated);

        SELECT MAX(xxxMinutes) AS xxxMinutes, MAX(iHour) AS iHour, MAX(iiHours) AS iiHours, 
        MAX(iiiHours) AS iiiHours, MAX(vHours) AS vHours, MAX(iDay) AS iDay, MAX(iiDays) AS iiDays, 
        MAX(ivDays) AS ivDays, MAX(iWeek) AS iWeek FROM temp_package_results;

    ELSEIF trend='overall2-perMonth-user' THEN
        INSERT INTO temp_package_results(xxxMinutes, iHour, iiHours, iiiHours, vHours,
                    iDay, iiDays, ivDays, iWeek, dateCreated)

            SELECT SUM(xxxMinutes), SUM(iHour), SUM(iiHours), 
            SUM(iiiHours), SUM(vHours), SUM(iDay), SUM(iiDays), 
            SUM(ivDays), SUM(iWeek), computed_packages.dateCreated FROM computed_packages 
            LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac 
            WHERE macs_users.owner = owner 
            GROUP BY MONTH(computed_packages.dateCreated);

        SELECT MAX(xxxMinutes) AS xxxMinutes, MAX(iHour) AS iHour, MAX(iiHours) AS iiHours, 
        MAX(iiiHours) AS iiiHours, MAX(vHours) AS vHours, MAX(iDay) AS iDay, MAX(iiDays) AS iiDays, 
        MAX(ivDays) AS ivDays, MAX(iWeek) AS iWeek FROM temp_package_results;






    # FOR GRAPH PURPOSE
    # td = total dispense, tv = total value

    ELSEIF trend = 'td-perDay' THEN
        SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
        SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + 
        SUM(ivDays) + SUM(iWeek) AS totalDispense,
        3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
        15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 
        50*SUM(ivDays) + 60*SUM(iWeek) AS totalValue, dateCreated 
        FROM computed_packages 
        GROUP BY DATE(dateCreated);

    ELSEIF trend = 'td-perWeek' THEN
        SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
        SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + 
        SUM(ivDays) + SUM(iWeek) AS totalDispense,
        3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
        15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 
        50*SUM(ivDays) + 60*SUM(iWeek) AS totalValue, dateCreated 
        FROM computed_packages 
        GROUP BY WEEK(dateCreated);

    ELSEIF trend = 'td-perMonth' THEN
        SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
        SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + 
        SUM(ivDays) + SUM(iWeek) AS totalDispense,
        3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
        15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 
        50*SUM(ivDays) + 60*SUM(iWeek) AS totalValue, dateCreated 
        FROM computed_packages 
        GROUP BY MONTH(dateCreated);

    ELSEIF trend = 'td-perDay-user' THEN
        SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
        SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + 
        SUM(ivDays) + SUM(iWeek) AS totalDispense,
        3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
        15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 
        50*SUM(ivDays) + 60*SUM(iWeek) AS totalValue, computed_packages.dateCreated 
        FROM computed_packages
        LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac 
        WHERE macs_users.owner = owner 
        GROUP BY DATE(computed_packages.dateCreated);

    ELSEIF trend = 'td-perWeek-user' THEN
        SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
        SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + 
        SUM(ivDays) + SUM(iWeek) AS totalDispense,
        3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
        15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 
        50*SUM(ivDays) + 60*SUM(iWeek) AS totalValue, computed_packages.dateCreated 
        FROM computed_packages
        LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac 
        WHERE macs_users.owner = owner 
        GROUP BY WEEK(computed_packages.dateCreated);

    ELSEIF trend = 'td-perMonth-user' THEN
        SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
        SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + 
        SUM(ivDays) + SUM(iWeek) AS totalDispense,
        3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
        15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 
        50*SUM(ivDays) + 60*SUM(iWeek) AS totalValue, computed_packages.dateCreated 
        FROM computed_packages
        LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac 
        WHERE macs_users.owner = owner 
        GROUP BY MONTH(computed_packages.dateCreated);

    


    ELSEIF trend = 'expl-perDay' THEN
        SELECT 3*SUM(xxxMinutes) AS xxxMinutes, 5*SUM(iHour) AS iHour, 10*SUM(iiHours) AS iiHours, 
        15*SUM(iiiHours) AS iiiHours, 20*SUM(vHours) AS vHours, 30*SUM(iDay) AS iDay, 40*SUM(iiDays) AS iiDays, 
        50*SUM(ivDays) AS ivDays, 60*SUM(iWeek) AS iWeek, dateCreated FROM computed_packages 
        GROUP BY DATE(dateCreated);

    ELSEIF trend = 'expl-perWeek' THEN
        SELECT 3*SUM(xxxMinutes) AS xxxMinutes, 5*SUM(iHour) AS iHour, 10*SUM(iiHours) AS iiHours, 
        15*SUM(iiiHours) AS iiiHours, 20*SUM(vHours) AS vHours, 30*SUM(iDay) AS iDay, 40*SUM(iiDays) AS iiDays, 
        50*SUM(ivDays) AS ivDays, 60*SUM(iWeek) AS iWeek, dateCreated FROM computed_packages 
        GROUP BY WEEK(dateCreated);

    ELSEIF trend = 'expl-perMonth' THEN
        SELECT 3*SUM(xxxMinutes) AS xxxMinutes, 5*SUM(iHour) AS iHour, 10*SUM(iiHours) AS iiHours, 
        15*SUM(iiiHours) AS iiiHours, 20*SUM(vHours) AS vHours, 30*SUM(iDay) AS iDay, 40*SUM(iiDays) AS iiDays, 
        50*SUM(ivDays) AS ivDays, 60*SUM(iWeek) AS iWeek, dateCreated FROM computed_packages 
        GROUP BY MONTH(dateCreated);

    ELSEIF trend = 'expl-perDay-user' THEN
       SELECT 3*SUM(xxxMinutes) AS xxxMinutes, 5*SUM(iHour) AS iHour, 10*SUM(iiHours) AS iiHours, 
        15*SUM(iiiHours) AS iiiHours, 20*SUM(vHours) AS vHours, 30*SUM(iDay) AS iDay, 40*SUM(iiDays) AS iiDays, 
        50*SUM(ivDays) AS ivDays, 60*SUM(iWeek) AS iWeek, computed_packages.dateCreated FROM computed_packages
        LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac
        WHERE macs_users.owner = owner 
        GROUP BY DATE(computed_packages.dateCreated);

    ELSEIF trend = 'expl-perWeek-user' THEN
        SELECT 3*SUM(xxxMinutes) AS xxxMinutes, 5*SUM(iHour) AS iHour, 10*SUM(iiHours) AS iiHours, 
        15*SUM(iiiHours) AS iiiHours, 20*SUM(vHours) AS vHours, 30*SUM(iDay) AS iDay, 40*SUM(iiDays) AS iiDays, 
        50*SUM(ivDays) AS ivDays, 60*SUM(iWeek) AS iWeek, computed_packages.dateCreated FROM computed_packages
        LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac
        WHERE macs_users.owner = owner 
        GROUP BY WEEK(computed_packages.dateCreated);

    ELSEIF trend = 'expl-perMonth-user' THEN
        SELECT 3*SUM(xxxMinutes) AS xxxMinutes, 5*SUM(iHour) AS iHour, 10*SUM(iiHours) AS iiHours, 
        15*SUM(iiiHours) AS iiiHours, 20*SUM(vHours) AS vHours, 30*SUM(iDay) AS iDay, 40*SUM(iiDays) AS iiDays, 
        50*SUM(ivDays) AS ivDays, 60*SUM(iWeek) AS iWeek, computed_packages.dateCreated FROM computed_packages
        LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac
        WHERE macs_users.owner = owner 
        GROUP BY MONTH(computed_packages.dateCreated);

    END IF;

END$$
DELIMITER ;
