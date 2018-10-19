DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `fill_computed_packages`(IN `mac` VARCHAR(180), IN `wallet` VARCHAR(180), IN `xxxMinutes` INT(10), IN `iHour` INT(10), IN `iiHours` INT(10), IN `iiiHours` INT(10), IN `vHours` INT(10), IN `iDay` INT(10), IN `iiDays` INT(10), IN `ivDays` INT(10), IN `iWeek` INT(10), IN `dateCreated` VARCHAR(180))
    NO SQL
BEGIN
    INSERT INTO computed_packages SET computed_packages.mac = mac,
    computed_packages.wallet = wallet,
    computed_packages.xxxMinutes = xxxMinutes, 
    computed_packages.iHour = iHour,
    computed_packages.iiHours = iiHours,
    computed_packages.iiiHours = iiiHours,
    computed_packages.vHours = vHours,
    computed_packages.iDay = iDay,
    computed_packages.iiDays = iiDays,
    computed_packages.ivDays = ivDays,
    computed_packages.iWeek = iWeek,
    computed_packages.dateCreated = dateCreated;
END$$
DELIMITER ;
