DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Dashboard2`(IN `cond` VARCHAR(180), IN `trend` VARCHAR(180), IN `userParam` VARCHAR(180))
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



        ELSEIF cond = 'opr-get-active' THEN
        CREATE TEMPORARY TABLE actives(mac varchar(180) NOT NULL DEFAULT '', dateCreated varchar(180) NOT NULL DEFAULT '');
        INSERT INTO actives(mac, dateCreated)
            SELECT mac_fk AS active, utilizations.dateCreated from utilizations 
            LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk 
            WHERE macs_users.owner = userParam 
            GROUP BY DATE(utilizations.dateCreated), mac_fk;

        SELECT COUNT(mac) AS active, DATE_FORMAT(dateCreated, '%Y-%m-%d') AS dateCreated FROM actives
        GROUP BY date(dateCreated)
        ORDER BY dateCreated DESC;

        ELSEIF cond = 'par-get-active' THEN
        CREATE TEMPORARY TABLE actives(mac varchar(180) NOT NULL DEFAULT '', dateCreated varchar(180) NOT NULL DEFAULT '');
        INSERT INTO actives(mac, dateCreated)
            SELECT mac_fk AS active, utilizations.dateCreated from utilizations 
            LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner 
            WHERE partners.partner = userParam 
            GROUP BY DATE(utilizations.dateCreated), mac_fk;

        SELECT COUNT(mac) AS active, DATE_FORMAT(dateCreated, '%Y-%m-%d') AS dateCreated FROM actives
        GROUP BY date(dateCreated)
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
            DATE_FORMAT(tempStats.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            WHERE macs_users.owner = userParam
            GROUP BY DATE(tempStats.dateCreated)
            ORDER BY tempStats.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            DATE_FORMAT(tempStats.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            WHERE macs_users.owner = userParam
            GROUP BY WEEK(tempStats.dateCreated)
            ORDER BY tempStats.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            DATE_FORMAT(tempStats.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            WHERE macs_users.owner = userParam
            GROUP BY MONTH(tempStats.dateCreated)
            ORDER BY tempStats.dateCreated DESC;
        END IF;

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
            DATE_FORMAT(tempStats.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY DATE(tempStats.dateCreated)
            ORDER BY tempStats.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            DATE_FORMAT(tempStats.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY WEEK(tempStats.dateCreated)
            ORDER BY tempStats.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            DATE_FORMAT(tempStats.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY MONTH(tempStats.dateCreated)
            ORDER BY tempStats.dateCreated DESC;
        END IF;



        ELSEIF cond = 'opr-get-views' THEN
        IF trend = 'perDay' THEN
            SELECT COUNT(*) AS viewCount, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated FROM views
            LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
            WHERE macs_users.owner = userParam
            AND views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
            GROUP BY DATE(views.dateCreated)
            ORDER BY views.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT COUNT(*) AS viewCount, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated FROM views
            LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
            WHERE macs_users.owner = userParam
            AND views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
            GROUP BY WEEK(views.dateCreated)
            ORDER BY views.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT COUNT(*) AS viewCount, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated FROM views
            LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
            WHERE macs_users.owner = userParam
            AND views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
            GROUP BY MONTH(views.dateCreated)
            ORDER BY views.dateCreated DESC;
        END IF;

        ELSEIF cond = 'par-get-views' THEN
        IF trend = 'perDay' THEN
            SELECT COUNT(*) AS viewCount, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated FROM views
            LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
            GROUP BY DATE(views.dateCreated)
            ORDER BY views.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT COUNT(*) AS viewCount, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated FROM views
            LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
            GROUP BY WEEK(views.dateCreated)
            ORDER BY views.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT COUNT(*) AS viewCount, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated FROM views
            LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
            GROUP BY MONTH(views.dateCreated)
            ORDER BY views.dateCreated DESC;
        END IF;





    END IF;
END$$
DELIMITER ;
