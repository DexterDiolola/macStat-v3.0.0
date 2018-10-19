DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `package_dispense_results_each`(IN `trend` VARCHAR(180), IN `mac` VARCHAR(180))
    NO SQL
BEGIN 
    
    # This query is for 'g' graph purpose
    IF trend = 'g-perDay' THEN
        SELECT CAST(3*SUM(xxxMinutes) AS SIGNED) AS xxxMinutes, 
        CAST(5*SUM(iHour) AS SIGNED) AS iHour, CAST(10*SUM(iiHours) AS SIGNED) AS iiHours, 
        CAST(15*SUM(iiiHours) AS SIGNED) AS iiiHours, CAST(20*SUM(vHours) AS SIGNED) AS vHours, 
        CAST(30*SUM(iDay) AS SIGNED) AS iDay, CAST(40*SUM(iiDays) AS SIGNED) AS iiDays,
        CAST(50*SUM(ivDays) AS SIGNED) AS ivDays, CAST(60*SUM(iWeek) AS SIGNED) AS iWeek,

        CAST(3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) +
        20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek)
        AS SIGNED) AS totalDispense, 

        CAST(SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) +
        SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek)
        AS SIGNED) AS totalPackage,

        dateCreated FROM computed_packages
        WHERE computed_packages.mac = mac
        GROUP BY DATE(dateCreated)
        ORDER BY dateCreated DESC;

    ELSEIF trend = 'g-perWeek' THEN
        SELECT CAST(3*SUM(xxxMinutes) AS SIGNED) AS xxxMinutes, 
        CAST(5*SUM(iHour) AS SIGNED) AS iHour, CAST(10*SUM(iiHours) AS SIGNED) AS iiHours, 
        CAST(15*SUM(iiiHours) AS SIGNED) AS iiiHours, CAST(20*SUM(vHours) AS SIGNED) AS vHours, 
        CAST(30*SUM(iDay) AS SIGNED) AS iDay, CAST(40*SUM(iiDays) AS SIGNED) AS iiDays,
        CAST(50*SUM(ivDays) AS SIGNED) AS ivDays, CAST(60*SUM(iWeek) AS SIGNED) AS iWeek,

        CAST(3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) +
        20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek)
        AS SIGNED) AS totalDispense, 

        CAST(SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) +
        SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek)
        AS SIGNED) AS totalPackage,

        dateCreated FROM computed_packages
        WHERE computed_packages.mac = mac
        GROUP BY WEEK(dateCreated)
        ORDER BY dateCreated DESC;

    ELSEIF trend = 'g-perMonth' THEN
        SELECT CAST(3*SUM(xxxMinutes) AS SIGNED) AS xxxMinutes, 
        CAST(5*SUM(iHour) AS SIGNED) AS iHour, CAST(10*SUM(iiHours) AS SIGNED) AS iiHours, 
        CAST(15*SUM(iiiHours) AS SIGNED) AS iiiHours, CAST(20*SUM(vHours) AS SIGNED) AS vHours, 
        CAST(30*SUM(iDay) AS SIGNED) AS iDay, CAST(40*SUM(iiDays) AS SIGNED) AS iiDays,
        CAST(50*SUM(ivDays) AS SIGNED) AS ivDays, CAST(60*SUM(iWeek) AS SIGNED) AS iWeek,

        CAST(3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) +
        20*SUM(vHours) + 30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek)
        AS SIGNED) AS totalDispense, 

        CAST(SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) +
        SUM(vHours) + SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek)
        AS SIGNED) AS totalPackage,
         
        dateCreated FROM computed_packages
        WHERE computed_packages.mac = mac
        GROUP BY MONTH(dateCreated)
        ORDER BY dateCreated DESC;




    # This query is for 's' solo purpose
    # Note: Im not using the dateCreated > DATE_SUB here because it must return the exact value
        # each day, week and month not the real time interval basis

    ELSEIF trend = 's-perDay' THEN
        SELECT 3*SUM(xxxMinutes) AS xxxMinutes, 5*SUM(iHour) AS iHour, 
        10*SUM(iiHours) AS iiHours, 15*SUM(iiiHours) AS iiiHours, 
        20*SUM(vHours) AS vHours, 30*SUM(iDay) AS iDay, 40*SUM(iiDays) AS iiDays, 
        50*SUM(ivDays) AS ivDays, 60*SUM(iWeek) AS iWeek, dateCreated FROM computed_packages 
        WHERE computed_packages.mac = mac 
        AND DATE(dateCreated) = DATE(NOW());

    ELSEIF trend = 's-perWeek' THEN
        SELECT 3*SUM(xxxMinutes) AS xxxMinutes, 5*SUM(iHour) AS iHour, 
        10*SUM(iiHours) AS iiHours, 15*SUM(iiiHours) AS iiiHours, 
        20*SUM(vHours) AS vHours, 30*SUM(iDay) AS iDay, 40*SUM(iiDays) AS iiDays, 
        50*SUM(ivDays) AS ivDays, 60*SUM(iWeek) AS iWeek, dateCreated FROM computed_packages 
        WHERE computed_packages.mac = mac 
        AND WEEK(dateCreated) = WEEK(NOW());

    ELSEIF trend = 's-perMonth' THEN
        SELECT 3*SUM(xxxMinutes) AS xxxMinutes, 5*SUM(iHour) AS iHour, 
        10*SUM(iiHours) AS iiHours, 15*SUM(iiiHours) AS iiiHours, 
        20*SUM(vHours) AS vHours, 30*SUM(iDay) AS iDay, 40*SUM(iiDays) AS iiDays, 
        50*SUM(ivDays) AS ivDays, 60*SUM(iWeek) AS iWeek, dateCreated FROM computed_packages 
        WHERE computed_packages.mac = mac 
        AND MONTH(dateCreated) = MONTH(NOW());

    END IF;

END$$
DELIMITER ;
