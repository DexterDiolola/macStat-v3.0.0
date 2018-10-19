DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Devices`(IN `cond` VARCHAR(180), IN `trend` VARCHAR(180), IN `userParam` VARCHAR(180))
    NO SQL
BEGIN
        IF cond = 'opr-get-devices' THEN
        SELECT macs.mac, macs_users.owner AS operator, macs.label AS site, macs.dateCreated FROM macs
        LEFT OUTER JOIN macs_users ON macs_users.mac = macs.mac
        WHERE macs_users.owner = userParam
        ORDER BY macs.dateCreated DESC;
        

        ELSEIF cond = 'par-get-devices' THEN
        SELECT macs.mac, macs_users.owner AS operator, macs.label AS site, macs.dateCreated FROM macs
        LEFT OUTER JOIN macs_users ON macs_users.mac = macs.mac
        LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
        WHERE partners.partner = userParam
        ORDER BY macs_users.owner, macs.dateCreated DESC;



        ELSEIF cond = 'opr-get-tp' THEN
        IF trend = 'perDay' THEN
            SELECT computed_packages.mac, macs.label AS site, macs_users.owner AS operator, SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
            SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs ON macs.mac = computed_packages.mac
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            AND DATE(computed_packages.dateCreated) = DATE(NOW())
            GROUP BY computed_packages.mac
            ORDER BY totalPackage DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT computed_packages.mac, macs.label AS site, macs_users.owner AS operator, SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
            SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs ON macs.mac = computed_packages.mac
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            AND WEEK(computed_packages.dateCreated) = WEEK(NOW())
            GROUP BY computed_packages.mac
            ORDER BY totalPackage DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT computed_packages.mac, macs.label AS site, macs_users.owner AS operator, SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
            SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs ON macs.mac = computed_packages.mac
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            AND MONTH(computed_packages.dateCreated) = MONTH(NOW())
            GROUP BY computed_packages.mac
            ORDER BY totalPackage DESC;
        END IF;


        ELSEIF cond = 'par-get-tp' THEN
        IF trend = 'perDay' THEN
            SELECT computed_packages.mac, macs.label AS site, macs_users.owner AS operator, SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
            SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs ON macs.mac = computed_packages.mac
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND DATE(computed_packages.dateCreated) = DATE(NOW())
            GROUP BY computed_packages.mac
            ORDER BY totalPackage DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT computed_packages.mac, macs.label AS site, macs_users.owner AS operator, SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
            SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs ON macs.mac = computed_packages.mac
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND WEEK(computed_packages.dateCreated) = WEEK(NOW())
            GROUP BY computed_packages.mac
            ORDER BY totalPackage DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT computed_packages.mac, macs.label AS site, macs_users.owner AS operator, SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
            SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs ON macs.mac = computed_packages.mac
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND MONTH(computed_packages.dateCreated) = MONTH(NOW())
            GROUP BY computed_packages.mac
            ORDER BY totalPackage DESC;
        END IF;





        ELSEIF cond = 'opr-get-td' THEN
        IF trend = 'perDay' THEN
            SELECT computed_packages.mac, macs.label AS site, macs_users.owner AS operator, 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
            15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs ON macs.mac = computed_packages.mac
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            AND DATE(computed_packages.dateCreated) = DATE(NOW())
            GROUP BY computed_packages.mac
            ORDER BY totalDispense DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT computed_packages.mac, macs.label AS site, macs_users.owner AS operator, 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
            15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs ON macs.mac = computed_packages.mac
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            AND WEEK(computed_packages.dateCreated) = WEEK(NOW())
            GROUP BY computed_packages.mac
            ORDER BY totalDispense DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT computed_packages.mac, macs.label AS site, macs_users.owner AS operator, 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
            15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs ON macs.mac = computed_packages.mac
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            AND MONTH(computed_packages.dateCreated) = MONTH(NOW())
            GROUP BY computed_packages.mac
            ORDER BY totalDispense DESC;
        END IF;


        ELSEIF cond = 'par-get-td' THEN
        IF trend = 'perDay' THEN
            SELECT computed_packages.mac, macs.label AS site, macs_users.owner AS operator, 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
            15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs ON macs.mac = computed_packages.mac
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND DATE(computed_packages.dateCreated) = DATE(NOW())
            GROUP BY computed_packages.mac
            ORDER BY totalDispense DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT computed_packages.mac, macs.label AS site, macs_users.owner AS operator, 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
            15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs ON macs.mac = computed_packages.mac
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND WEEK(computed_packages.dateCreated) = WEEK(NOW())
            GROUP BY computed_packages.mac
            ORDER BY totalDispense DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT computed_packages.mac, macs.label AS site, macs_users.owner AS operator, 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
            15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs ON macs.mac = computed_packages.mac
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND MONTH(computed_packages.dateCreated) = MONTH(NOW())
            GROUP BY computed_packages.mac
            ORDER BY totalDispense DESC;
        END IF;


    END IF;
END$$
DELIMITER ;
