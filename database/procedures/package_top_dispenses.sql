DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `package_top_dispenses`(IN `trend` VARCHAR(180), IN `owner` VARCHAR(180))
    NO SQL
BEGIN
    IF trend = 'perDay' THEN
        SELECT computed_packages.mac, label, SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
        SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalDispense, 
        3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
        15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 
        50*SUM(ivDays) + 60*SUM(iWeek) AS totalValue,
        computed_packages.dateCreated FROM computed_packages 
        LEFT OUTER JOIN macs ON computed_packages.mac = macs.mac 
        WHERE computed_packages.dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY) 
        GROUP BY computed_packages.mac
        ORDER BY totalDispense DESC;

    ELSEIF trend = 'perWeek' THEN
        SELECT computed_packages.mac, label, SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
        SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalDispense,
        3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
        15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 
        50*SUM(ivDays) + 60*SUM(iWeek) AS totalValue, 
        computed_packages.dateCreated FROM computed_packages 
        LEFT OUTER JOIN macs ON computed_packages.mac = macs.mac 
        WHERE computed_packages.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK) 
        GROUP BY computed_packages.mac
        ORDER BY totalDispense DESC;

    ELSEIF trend = 'perMonth' THEN
        SELECT computed_packages.mac, label, SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
        SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalDispense,
        3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
        15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 
        50*SUM(ivDays) + 60*SUM(iWeek) AS totalValue, 
        computed_packages.dateCreated FROM computed_packages 
        LEFT OUTER JOIN macs ON computed_packages.mac = macs.mac 
        WHERE computed_packages.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH) 
        GROUP BY computed_packages.mac
        ORDER BY totalDispense DESC;

    ELSEIF trend = 'perDay-user' THEN
        SELECT computed_packages.mac, label, SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
        SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalDispense,
        3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
        15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 
        50*SUM(ivDays) + 60*SUM(iWeek) AS totalValue, 
        computed_packages.dateCreated FROM computed_packages 
        LEFT OUTER JOIN macs ON computed_packages.mac = macs.mac
        LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac 
        WHERE computed_packages.dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)
        AND macs_users.owner = owner
        GROUP BY computed_packages.mac
        ORDER BY totalDispense DESC;

    ELSEIF trend = 'perWeek-user' THEN
        SELECT computed_packages.mac, label, SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
        SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalDispense,
        3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
        15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 
        50*SUM(ivDays) + 60*SUM(iWeek) AS totalValue, 
        computed_packages.dateCreated FROM computed_packages 
        LEFT OUTER JOIN macs ON computed_packages.mac = macs.mac
        LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac 
        WHERE computed_packages.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)
        AND macs_users.owner = owner
        GROUP BY computed_packages.mac
        ORDER BY totalDispense DESC;

    ELSEIF trend = 'perMonth-user' THEN
        SELECT computed_packages.mac, label, SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + 
        SUM(iiiHours) + SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalDispense,
        3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 
        15*SUM(iiiHours) + 20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 
        50*SUM(ivDays) + 60*SUM(iWeek) AS totalValue, 
        computed_packages.dateCreated FROM computed_packages 
        LEFT OUTER JOIN macs ON computed_packages.mac = macs.mac
        LEFT OUTER JOIN macs_users ON computed_packages.mac = macs_users.mac 
        WHERE computed_packages.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
        AND macs_users.owner = owner
        GROUP BY computed_packages.mac
        ORDER BY totalDispense DESC;

    END IF;

END$$
DELIMITER ;
