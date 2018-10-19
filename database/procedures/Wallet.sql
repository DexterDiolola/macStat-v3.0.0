DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Wallet`(IN `cond` VARCHAR(180), IN `trend` VARCHAR(180), IN `userParam` VARCHAR(180))
    NO SQL
BEGIN
        IF cond = 'opr-get-wallet' THEN
        DROP TABLE IF EXISTS wallet;
        CREATE TEMPORARY TABLE wallets(wallet VARCHAR(10) not null default 0, dateCreated VARCHAR(180) NOT  NULL DEFAULT '');
        INSERT INTO wallets(wallet, dateCreated)
            SELECT computed_packages.wallet, computed_packages.dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            GROUP BY DATE(computed_packages.dateCreated), computed_packages.mac;
        SELECT SUM(wallet) AS wallet, DATE_FORMAT(dateCreated, '%Y-%m-%d') AS dateCreated FROM wallets
        GROUP BY DATE(dateCreated)
        ORDER BY dateCreated DESC;

        ELSEIF cond = 'par-get-wallet' THEN
        DROP TABLE IF EXISTS wallet;
        CREATE TEMPORARY TABLE wallets(wallet VARCHAR(10) not null default 0, dateCreated VARCHAR(180) NOT  NULL DEFAULT '');
        INSERT INTO wallets(wallet, dateCreated)
            SELECT computed_packages.wallet, computed_packages.dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY DATE(computed_packages.dateCreated), computed_packages.mac;
        SELECT SUM(wallet) AS wallet, DATE_FORMAT(dateCreated, '%Y-%m-%d') AS dateCreated FROM wallets
        GROUP BY DATE(dateCreated)
        ORDER BY dateCreated DESC;





         ELSEIF cond = 'opr-get-tp' THEN
        IF trend = 'perDay' THEN
            SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) + SUM(vHours) + 
            SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            GROUP BY DATE(computed_packages.dateCreated)
            ORDER BY computed_packages.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN 
            SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) + SUM(vHours) + 
            SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            GROUP BY WEEK(computed_packages.dateCreated)
            ORDER BY computed_packages.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) + SUM(vHours) + 
            SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            GROUP BY MONTH(computed_packages.dateCreated)
            ORDER BY computed_packages.dateCreated DESC;
        END IF;

        ELSEIF cond = 'par-get-tp' THEN
        IF trend = 'perDay' THEN
            SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) + SUM(vHours) + 
            SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY DATE(computed_packages.dateCreated)
            ORDER BY computed_packages.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) + SUM(vHours) + 
            SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY WEEK(computed_packages.dateCreated)
            ORDER BY computed_packages.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) + SUM(vHours) + 
            SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY MONTH(computed_packages.dateCreated)
            ORDER BY computed_packages.dateCreated DESC;
        END IF;





        ELSEIF cond = 'opr-get-td' THEN
        IF trend = 'perDay' THEN
            SELECT 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) + 20*SUM(vHours) + 
            30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            GROUP BY DATE(computed_packages.dateCreated)
            ORDER BY computed_packages.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) + 20*SUM(vHours) + 
            30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            GROUP BY WEEK(computed_packages.dateCreated)
            ORDER BY computed_packages.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) + 20*SUM(vHours) + 
            30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            GROUP BY MONTH(computed_packages.dateCreated)
            ORDER BY computed_packages.dateCreated DESC;
        END IF;

        ELSEIF cond = 'par-get-td' THEN
        IF trend = 'perDay' THEN
            SELECT 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) + 20*SUM(vHours) + 
            30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY DATE(computed_packages.dateCreated)
            ORDER BY computed_packages.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) + 20*SUM(vHours) + 
            30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY WEEK(computed_packages.dateCreated)
            ORDER BY computed_packages.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) + 20*SUM(vHours) + 
            30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense, 
            DATE_FORMAT(computed_packages.dateCreated, '%Y-%m-%d') AS dateCreated FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY MONTH(computed_packages.dateCreated)
            ORDER BY computed_packages.dateCreated DESC;
        END IF;




    END IF;
END$$
DELIMITER ;
