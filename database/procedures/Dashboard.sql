DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Dashboard`(IN `cond` VARCHAR(180), IN `trend` VARCHAR(180), IN `userParam` VARCHAR(180))
    NO SQL
BEGIN
    # This condition gets the wallet value of operator
    IF cond = 'opr-get-wallet' THEN
        DROP TABLE IF EXISTS wallet;
        CREATE TEMPORARY TABLE wallets(wallet int(10) not null default 0);
        INSERT INTO wallets(wallet)
            SELECT computed_packages.wallet FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            GROUP BY computed_packages.mac;
        SELECT sum(wallet) AS wallet FROM wallets;

    # This condition gets the wallet value of partner
    # Note: To chack its mutual column, just add the specified columns in select computed.packages.wallet line
    # Joining macs table will also work too to check its sites.
    ELSEIF cond = 'par-get-wallet' THEN
        DROP TABLE IF EXISTS wallet;
        CREATE TEMPORARY TABLE wallets(wallet int(10) not null default 0);
        INSERT INTO wallets(wallet)
            SELECT computed_packages.wallet FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY computed_packages.mac;
        SELECT sum(wallet) AS wallet FROM wallets;



    # This condition gets the number of active devices of operator
    ELSEIF cond = 'opr-get-active' THEN
        DROP TABLE IF EXISTS actives;
        CREATE TEMPORARY TABLE actives(active VARCHAR(180) not null default 0);
        IF trend = 'perDay' THEN
            INSERT INTO actives(active)
                SELECT mac_fk AS active from utilizations
                LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
                WHERE utilizations.dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)
                AND macs_users.owner = userParam
                GROUP BY mac_fk;
            SELECT COUNT(active) AS active FROM actives;
        ELSEIF trend = 'perWeek' THEN
            INSERT INTO actives(active)
                SELECT mac_fk AS active from utilizations
                LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
                WHERE utilizations.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)
                AND macs_users.owner = userParam
                GROUP BY mac_fk;
            SELECT COUNT(active) AS active FROM actives;
        ELSEIF trend = 'perMonth' THEN
            INSERT INTO actives(active)
                SELECT mac_fk AS active from utilizations
                LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
                WHERE utilizations.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
                AND macs_users.owner = userParam
                GROUP BY mac_fk;
            SELECT COUNT(active) AS active FROM actives;
        END IF;

    # This condition gets the number of active devices of partner
    ELSEIF cond = 'par-get-active' THEN
        DROP TABLE IF EXISTS actives;
        CREATE TEMPORARY TABLE actives(active VARCHAR(180) not null default 0);
        IF trend = 'perDay' THEN
            INSERT INTO actives(active)
                SELECT mac_fk AS active from utilizations
                LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
                LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
                WHERE utilizations.dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)
                AND partners.partner = userParam
                GROUP BY mac_fk;
            SELECT COUNT(active) AS active FROM actives;
        ELSEIF trend = 'perWeek' THEN
            INSERT INTO actives(active)
                SELECT mac_fk AS active from utilizations
                LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
                LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
                WHERE utilizations.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)
                AND partners.partner = userParam
                GROUP BY mac_fk;
            SELECT COUNT(active) AS active FROM actives;
        ELSEIF trend = 'perMonth' THEN
            INSERT INTO actives(active)
                SELECT mac_fk AS active from utilizations
                LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
                LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
                WHERE utilizations.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
                AND partners.partner = userParam
                GROUP BY mac_fk;
            SELECT COUNT(active) AS active FROM actives;
        END IF;



    # This condition gets the total package of operator
    ELSEIF cond = 'opr-get-tp' THEN
        IF trend = 'perDay' THEN
            SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) + SUM(vHours) + 
            SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            AND DATE(computed_packages.dateCreated) = DATE(NOW());
        ELSEIF trend = 'perWeek' THEN
            SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) + SUM(vHours) + 
            SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            AND WEEK(computed_packages.dateCreated) = WEEK(NOW());
        ELSEIF trend = 'perMonth' THEN
            SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) + SUM(vHours) + 
            SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            AND MONTH(computed_packages.dateCreated) = MONTH(NOW());
        END IF;

    # This condition gets the total package of partner
    ELSEIF cond = 'par-get-tp' THEN
        IF trend = 'perDay' THEN
            SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) + SUM(vHours) + 
            SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND DATE(computed_packages.dateCreated) = DATE(NOW());
        ELSEIF trend = 'perWeek' THEN
            SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) + SUM(vHours) + 
            SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND WEEK(computed_packages.dateCreated) = WEEK(NOW());
        ELSEIF trend = 'perMonth' THEN
            SELECT SUM(xxxMinutes) + SUM(iHour) + SUM(iiHours) + SUM(iiiHours) + SUM(vHours) + 
            SUM(iDay) + SUM(iiDays) + SUM(ivDays) + SUM(iWeek) AS totalPackage FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND MONTH(computed_packages.dateCreated) = MONTH(NOW());
        END IF;



    # This condition gets the total dispense of operator
    ELSEIF cond = 'opr-get-td' THEN
        IF trend = 'perDay' THEN
            SELECT 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) + 20*SUM(vHours) + 
            30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            AND DATE(computed_packages.dateCreated) = DATE(NOW());
        ELSEIF trend = 'perWeek' THEN
            SELECT 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) + 20*SUM(vHours) + 
            30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            AND WEEK(computed_packages.dateCreated) = WEEK(NOW());
        ELSEIF trend = 'perMonth' THEN
            SELECT 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) + 20*SUM(vHours) + 
            30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            WHERE macs_users.owner = userParam
            AND MONTH(computed_packages.dateCreated) = MONTH(NOW());
        END IF;

    # This condition gets the total dispense of partner
    ELSEIF cond = 'par-get-td' THEN
        IF trend = 'perDay' THEN
            SELECT 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) + 20*SUM(vHours) + 
            30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND DATE(computed_packages.dateCreated) = DATE(NOW());
        ELSEIF trend = 'perWeek' THEN
            SELECT 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) + 20*SUM(vHours) + 
            30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND WEEK(computed_packages.dateCreated) = WEEK(NOW());
        ELSEIF trend = 'perMonth' THEN
            SELECT 3*SUM(xxxMinutes) + 5*SUM(iHour) + 10*SUM(iiHours) + 15*SUM(iiiHours) + 20*SUM(vHours) + 
            30*SUM(iDay) + 40*SUM(iiDays) + 50*SUM(ivDays) + 60*SUM(iWeek) AS totalDispense FROM computed_packages
            LEFT OUTER JOIN macs_users ON macs_users.mac = computed_packages.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND MONTH(computed_packages.dateCreated) = MONTH(NOW());
        END IF;



    # This condition gets the stats of operator 
    ELSEIF cond = 'opr-get-stats' THEN
        DROP TABLE IF EXISTS tempStats;
        CREATE TEMPORARY TABLE tempStats(
                id int(10) AUTO_INCREMENT PRIMARY KEY,
                mac VARCHAR(180) NOT NULL DEFAULT '',
                active int(10) NOT NULL DEFAULT 0,
                cpuFreq INT(10) NOT NULL DEFAULT 0,
                usagetx DECIMAL(10, 2) NOT NULL DEFAULT 0,
                usagerx DECIMAL(10, 2) NOT NULL DEFAULT 0,
                utiltx DECIMAL(10, 2) NOT NULL DEFAULT 0,
                utilrx DECIMAL(10, 2) NOT NULL DEFAULT 0,
                dateCreated VARCHAR(180) NOT NULL DEFAULT '' 
            );
        INSERT INTO tempStats(mac, active, cpuFreq, usagetx, usagerx, utiltx, utilrx, dateCreated)
            SELECT mac_fk, active, cpuFreq, usagetx, usagerx, utiltx, utilrx, dateCreated FROM utilizations
            WHERE id IN(
                SELECT MAX(id) FROM utilizations
                WHERE DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY DATE(dateCreated), mac_fk
            );
        IF trend = 'perDay' THEN
            SELECT SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            tempStats.dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            WHERE macs_users.owner = userParam
            AND DATE(tempStats.dateCreated) = DATE(NOW()); # Use GROUP BY for graph purposes
        ELSEIF trend = 'perWeek' THEN
            SELECT SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            tempStats.dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            WHERE macs_users.owner = userParam
            AND WEEK(tempStats.dateCreated) = WEEK(NOW());
        ELSEIF trend = 'perMonth' THEN
            SELECT SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            tempStats.dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            WHERE macs_users.owner = userParam
            AND MONTH(tempStats.dateCreated) = MONTH(NOW());
        END IF;

    # This condition gets the stats of partner 
    ELSEIF cond = 'par-get-stats' THEN
        DROP TABLE IF EXISTS tempStats;
        CREATE TEMPORARY TABLE tempStats(
                id int(10) AUTO_INCREMENT PRIMARY KEY,
                mac VARCHAR(180) NOT NULL DEFAULT '',
                active int(10) NOT NULL DEFAULT 0,
                cpuFreq INT(10) NOT NULL DEFAULT 0,
                usagetx DECIMAL(10, 2) NOT NULL DEFAULT 0,
                usagerx DECIMAL(10, 2) NOT NULL DEFAULT 0,
                utiltx DECIMAL(10, 2) NOT NULL DEFAULT 0,
                utilrx DECIMAL(10, 2) NOT NULL DEFAULT 0,
                dateCreated VARCHAR(180) NOT NULL DEFAULT '' 
            );
        INSERT INTO tempStats(mac, active, cpuFreq, usagetx, usagerx, utiltx, utilrx, dateCreated)
            SELECT mac_fk, active, cpuFreq, usagetx, usagerx, utiltx, utilrx, dateCreated FROM utilizations
            WHERE id IN(
                SELECT MAX(id) FROM utilizations
                WHERE DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY DATE(dateCreated), mac_fk
            );
        IF trend = 'perDay' THEN
            SELECT SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            tempStats.dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND DATE(tempStats.dateCreated) = DATE(NOW()); # Use GROUP BY for graph purposes
        ELSEIF trend = 'perWeek' THEN
            SELECT SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            tempStats.dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND WEEK(tempStats.dateCreated) = WEEK(NOW());
        ELSEIF trend = 'perMonth' THEN
            SELECT SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            tempStats.dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND MONTH(tempStats.dateCreated) = MONTH(NOW());
        END IF;




    # This condition gets the number of views of operator
    ELSEIF cond = 'opr-get-views' THEN
        IF trend = 'perDay' THEN
            SELECT COUNT(*) AS viewCount FROM views
            LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
            WHERE macs_users.owner = userParam
            AND DATE(views.dateCreated) = DATE(NOW());
        ELSEIF trend = 'perWeek' THEN
            SELECT COUNT(*) AS viewCount FROM views
            LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
            WHERE macs_users.owner = userParam
            AND WEEK(views.dateCreated) = WEEK(NOW());
        ELSEIF trend = 'perMonth' THEN
            SELECT COUNT(*) AS viewCount FROM views
            LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
            WHERE macs_users.owner = userParam
            AND MONTH(views.dateCreated) = MONTH(NOW());
        END IF;

    # This condition gets the number of views of partner
    ELSEIF cond = 'par-get-views' THEN
        IF trend = 'perDay' THEN
            SELECT COUNT(*) AS viewCount FROM views
            LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND DATE(views.dateCreated) = DATE(NOW());
        ELSEIF trend = 'perWeek' THEN
            SELECT COUNT(*) AS viewCount FROM views
            LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND WEEK(views.dateCreated) = WEEK(NOW());
        ELSEIF trend = 'perMonth' THEN
            SELECT COUNT(*) AS viewCount FROM views
            LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND MONTH(views.dateCreated) = MONTH(NOW());
        END IF;




    # This condition gets the latest stats of devices of operator
    ELSEIF cond = 'opr-get-devices' THEN
        SELECT macs.mac, macs_users.owner AS operator, macs.label AS site, DATE_FORMAT(macs.dateCreated, '%Y-%m-%d') AS dateCreated FROM macs
        LEFT OUTER JOIN macs_users ON macs_users.mac = macs.mac
        WHERE macs_users.owner = userParam
        ORDER BY macs.dateCreated DESC;
        

    # This condition gets the latest stats of devices of partner
    ELSEIF cond = 'par-get-devices' THEN
        SELECT macs.mac, macs_users.owner AS operator, macs.label AS site, DATE_FORMAT(macs.dateCreated, '%Y-%m-%d') AS dateCreated FROM macs
        LEFT OUTER JOIN macs_users ON macs_users.mac = macs.mac
        LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
        WHERE partners.partner = userParam
        ORDER BY macs_users.owner, macs.dateCreated DESC;

    END IF;
END$$
DELIMITER ;
