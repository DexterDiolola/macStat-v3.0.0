DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Stats`(IN `cond` VARCHAR(180), IN `trend` VARCHAR(180), IN `userParam` VARCHAR(180), IN `nth` VARCHAR(180))
    NO SQL
BEGIN
    
    # This condition gets the number of active devices of operator
    IF cond = 'opr-get-active' THEN
        CREATE TEMPORARY TABLE actives(mac varchar(180) NOT NULL DEFAULT '', dateCreated varchar(180) NOT NULL DEFAULT '');
        INSERT INTO actives(mac, dateCreated)
            SELECT mac_fk AS active, utilizations.dateCreated from utilizations 
            LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk 
            WHERE macs_users.owner = userParam 
            GROUP BY DATE(utilizations.dateCreated), mac_fk;

        SELECT COUNT(mac) AS active, DATE_FORMAT(dateCreated, '%Y-%m-%d') AS dateCreated FROM actives
        GROUP BY date(dateCreated)
        ORDER BY dateCreated DESC;

    # This condition gets the number of active devices of partner
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




    # This condition gets the stats of operator
    ELSEIF cond = 'opr-get-stats' THEN
        DROP TABLE IF EXISTS tempStats;
        DROP TABLE IF EXISTS tempViews;
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
        CREATE TEMPORARY TABLE tempViews(
                view INT(10) NOT NULL DEFAULT 0, 
                dateCreated VARCHAR(180) NOT NULL DEFAULT ''
            );
        
        INSERT INTO tempStats(mac, active, cpuFreq, usagetx, usagerx, utiltx, utilrx, dateCreated)
            SELECT mac_fk, active, cpuFreq, usagetx, usagerx, utiltx, utilrx, 
            DATE_FORMAT(dateCreated, '%Y-%m-%d')as dateCreated FROM utilizations
            WHERE id IN(
                SELECT MAX(id) FROM utilizations
                WHERE DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY DATE(dateCreated), mac_fk
            );
         
        IF trend = 'perDay' THEN
            INSERT INTO tempViews(view, dateCreated)
                SELECT COUNT(*) AS viewCount, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated FROM views
                LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
                WHERE macs_users.owner = userParam
                AND views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY DATE(views.dateCreated);
            
            SELECT tempViews.view AS viewCount, SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            tempStats.dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN tempViews ON tempViews.dateCreated = tempStats.dateCreated
            WHERE macs_users.owner = userParam
            GROUP BY DATE(tempStats.dateCreated)
            ORDER BY tempStats.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN
            INSERT INTO tempViews(view, dateCreated)
                SELECT COUNT(*) AS viewCount, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated FROM views
                LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
                WHERE macs_users.owner = userParam
                AND views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY WEEK(views.dateCreated);
            
            SELECT tempViews.view AS viewCount, SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            tempStats.dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN tempViews ON tempViews.dateCreated = tempStats.dateCreated
            WHERE macs_users.owner = userParam
            GROUP BY WEEK(tempStats.dateCreated)
            ORDER BY tempStats.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            INSERT INTO tempViews(view, dateCreated)
                SELECT COUNT(*) AS viewCount, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated FROM views
                LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
                WHERE macs_users.owner = userParam
                AND views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY MONTH(views.dateCreated);
            
            SELECT tempViews.view AS viewCount, SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            tempStats.dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN tempViews ON tempViews.dateCreated = tempStats.dateCreated
            WHERE macs_users.owner = userParam
            GROUP BY MONTH(tempStats.dateCreated)
            ORDER BY tempStats.dateCreated DESC;
        END IF;

    # This condition gets the stats of partner 
    ELSEIF cond = 'par-get-stats' THEN
        DROP TABLE IF EXISTS tempStats;
        DROP TABLE IF EXISTS tempViews;
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
        CREATE TEMPORARY TABLE tempViews(
                view INT(10) NOT NULL DEFAULT 0, 
                dateCreated VARCHAR(180) NOT NULL DEFAULT ''
            );
        
        INSERT INTO tempStats(mac, active, cpuFreq, usagetx, usagerx, utiltx, utilrx, dateCreated)
            SELECT mac_fk, active, cpuFreq, usagetx, usagerx, utiltx, utilrx, 
            DATE_FORMAT(dateCreated, '%Y-%m-%d')as dateCreated FROM utilizations
            WHERE id IN(
                SELECT MAX(id) FROM utilizations
                WHERE DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY DATE(dateCreated), mac_fk
            );

        IF trend = 'perDay' THEN
            INSERT INTO tempViews(view, dateCreated)
                SELECT COUNT(*) AS viewCount, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated FROM views
                LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
                LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
                WHERE partners.partner = userParam
                AND views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY DATE(views.dateCreated);
            
            SELECT tempViews.view AS viewCount, SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            tempStats.dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN tempViews ON tempViews.dateCreated = tempStats.dateCreated
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY DATE(tempStats.dateCreated)
            ORDER BY tempStats.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN
            INSERT INTO tempViews(view, dateCreated)
                SELECT COUNT(*) AS viewCount, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated FROM views
                LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
                LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
                WHERE partners.partner = userParam
                AND views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY WEEK(views.dateCreated);
            
            SELECT tempViews.view AS viewCount, SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            tempStats.dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN tempViews ON tempViews.dateCreated = tempStats.dateCreated
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY WEEK(tempStats.dateCreated)
            ORDER BY tempStats.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            INSERT INTO tempViews(view, dateCreated)
                SELECT COUNT(*) AS viewCount, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated FROM views
                LEFT OUTER JOIN macs_users ON macs_users.mac = views.routerMac
                LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
                WHERE partners.partner = userParam
                AND views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY MONTH(views.dateCreated);
            
            SELECT tempViews.view AS viewCount, SUM(active) AS connected, SUM(cpuFreq) AS cpuFreq, SUM(usagetx) AS usagetx,
            SUM(usagerx) AS usagerx, SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx,
            tempStats.dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN tempViews ON tempViews.dateCreated = tempStats.dateCreated
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            GROUP BY MONTH(tempStats.dateCreated)
            ORDER BY tempStats.dateCreated DESC;
        END IF;






    # This condition gets the specific active devices of operator
    ELSEIF cond = 'opr-get-active-device' THEN
        CREATE TEMPORARY TABLE actives(mac varchar(180) NOT NULL DEFAULT '', dateCreated varchar(180) NOT NULL DEFAULT '');
        INSERT INTO actives(mac, dateCreated)
            SELECT mac_fk AS active, utilizations.dateCreated from utilizations 
            LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk 
            WHERE macs_users.owner = userParam 
            GROUP BY DATE(utilizations.dateCreated), mac_fk;

        SELECT mac, DATE_FORMAT(dateCreated, '%Y-%m-%d') AS dateCreated FROM actives
        WHERE DATE(dateCreated) = nth
        GROUP BY date(dateCreated), mac
        ORDER BY dateCreated DESC;

    # This condition gets the specific active devices of partners
    ELSEIF cond = 'par-get-active-device' THEN
        CREATE TEMPORARY TABLE actives(mac varchar(180) NOT NULL DEFAULT '', dateCreated varchar(180) NOT NULL DEFAULT '');
        INSERT INTO actives(mac, dateCreated)
            SELECT mac_fk AS active, utilizations.dateCreated from utilizations 
            LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner 
            WHERE partners.partner = userParam
            GROUP BY DATE(utilizations.dateCreated), mac_fk;

        SELECT mac, DATE_FORMAT(dateCreated, '%Y-%m-%d') AS dateCreated FROM actives
        WHERE DATE(dateCreated) = nth
        GROUP BY date(dateCreated), mac
        ORDER BY dateCreated DESC;




    # This condition gets the details of connected devices of operator
    # Note: I use DAYOFYEAR because DATE is just limited to its current month
    ELSEIF cond = 'opr-get-connected-device' THEN
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
            SELECT tempStats.mac, sum(tempStats.active) AS connected,
            DATE_FORMAT(tempStats.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            WHERE macs_users.owner = userParam
            AND DAYOFYEAR(tempStats.dateCreated) = DAYOFYEAR(NOW()) - nth
            GROUP BY DAYOFYEAR(tempStats.dateCreated), tempStats.mac
            ORDER BY tempStats.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT tempStats.mac, sum(tempStats.active) AS connected,
            DATE_FORMAT(tempStats.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            WHERE macs_users.owner = userParam
            AND WEEK(tempStats.dateCreated) = WEEK(NOW()) - nth
            GROUP BY WEEK(tempStats.dateCreated), tempStats.mac
            ORDER BY tempStats.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT tempStats.mac, sum(tempStats.active) AS connected,
            DATE_FORMAT(tempStats.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            WHERE macs_users.owner = userParam
            AND MONTH(tempStats.dateCreated) = MONTH(NOW()) - nth
            GROUP BY MONTH(tempStats.dateCreated), tempStats.mac
            ORDER BY tempStats.dateCreated DESC;
        END IF;


    # This condition gets the details of connected devices of partner
    ELSEIF cond = 'par-get-connected-device' THEN
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
            SELECT tempStats.mac, sum(tempStats.active) AS connected,
            DATE_FORMAT(tempStats.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND DAYOFYEAR(tempStats.dateCreated) = DAYOFYEAR(NOW()) - nth
            GROUP BY DAYOFYEAR(tempStats.dateCreated), tempStats.mac
            ORDER BY tempStats.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT tempStats.mac, sum(tempStats.active) AS connected,
            DATE_FORMAT(tempStats.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND WEEK(tempStats.dateCreated) = WEEK(NOW()) - nth
            GROUP BY WEEK(tempStats.dateCreated), tempStats.mac
            ORDER BY tempStats.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT tempStats.mac, sum(tempStats.active) AS connected,
            DATE_FORMAT(tempStats.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempStats
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempStats.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE partners.partner = userParam
            AND MONTH(tempStats.dateCreated) = MONTH(NOW()) - nth
            GROUP BY MONTH(tempStats.dateCreated), tempStats.mac
            ORDER BY tempStats.dateCreated DESC;
        END IF;


    END IF;
END$$
DELIMITER ;
