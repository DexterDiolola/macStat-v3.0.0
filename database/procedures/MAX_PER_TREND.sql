DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `MAX_PER_TREND`(IN `trend` VARCHAR(180), IN `get` VARCHAR(180), IN `created` VARCHAR(180))
    NO SQL
BEGIN
    DROP TABLE IF EXISTS tempUtilizations, maxOfTotal;
    CREATE TEMPORARY TABLE tempUtilizations(
        id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
        mac VARCHAR(255) NOT NULL DEFAULT '',
        active INT(10) NOT NULL DEFAULT 0, 
        ccq INT(10) NOT NULL DEFAULT 0, 
        utiltx DECIMAL(20,2) NOT NULL DEFAULT 0,
        utilrx DECIMAL(20,2) NOT NULL DEFAULT 0, 
        usagetx DECIMAL(20,2) NOT NULL DEFAULT 0, 
        usagerx DECIMAL(20,2) NOT NULL DEFAULT 0,
        lease INT(10) NOT NULL DEFAULT 0,
        freeMem DECIMAL(20,2) NOT NULL DEFAULT 0,
        cpuFreq INT(10) NOT NULL DEFAULT 0,
        cpuLoad INT(10) NOT NULL DEFAULT 0,
        freeHdd INT(10) NOT NULL DEFAULT 0,
        badBlock INT(10) NOT NULL DEFAULT 0,
        dateCreated DATETIME NOT NULL DEFAULT 0);

    CREATE TEMPORARY TABLE maxOfTotal(
        id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
        active INT(10) NOT NULL DEFAULT 0,
        utiltx DECIMAL(20,2) NOT NULL DEFAULT 0,
        utilrx DECIMAL(20,2) NOT NULL DEFAULT 0, 
        usagetx DECIMAL(20,2) NOT NULL DEFAULT 0, 
        usagerx DECIMAL(20,2) NOT NULL DEFAULT 0,
        dateCreated DATETIME NOT NULL DEFAULT 0);
    
    IF trend="perDay" THEN
        INSERT INTO tempUtilizations(mac, active, ccq, utiltx, utilrx,
        usagetx, usagerx, lease, freeMem, cpuFreq, cpuLoad, freeHdd,
        badBlock, dateCreated)
            SELECT mac_fk, MAX(active), MAX(ccq), MAX(utiltx),
            MAX(utilrx), MAX(usagetx), MAX(usagerx), MAX(lease),        
            MAX(freeMemory), MAX(cpuFreq), MAX(cpuLoad), MAX(freeHdd),
            MAX(badBlock), dateCreated FROM utilizations 
            WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 2 DAY)
            GROUP BY DATE(dateCreated), HOUR(dateCreated), mac_fk;
        
        IF get="getEach" THEN
            SELECT tempUtilizations.mac, macs.label, active, ccq, utiltx, utilrx, 
            usagetx, usagerx, lease, 
            freeMem, cpuFreq, cpuLoad, freeHdd, 
            badBlock, DATE_FORMAT(tempUtilizations.dateCreated, '%Y-%m-%d %H:00') AS 
            dateCreated, DATE_FORMAT(tempUtilizations.dateCreated, '%H:00') AS 
            dateCreated2 FROM tempUtilizations
            LEFT OUTER JOIN macs ON tempUtilizations.mac = macs.mac 
            WHERE tempUtilizations.dateCreated > DATE_SUB(NOW(), INTERVAL 23 HOUR)
            AND HOUR(tempUtilizations.dateCreated)=created ORDER BY tempUtilizations.dateCreated DESC;
        ELSEIF get="" THEN
            SELECT SUM(active) AS active, MAX(ccq) AS ccq, 
            SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx, 
            SUM(usagetx) AS usagetx, SUM(usagerx) AS usagerx, 
            SUM(lease) AS lease, SUM(freeMem) AS freeMem, 
            SUM(cpuFreq) AS cpuFreq, SUM(cpuLoad) AS cpuLoad, 
            SUM(freeHdd) AS freeHdd, SUM(badBlock) AS badBlock, 
            DATE_FORMAT(dateCreated, '%Y-%m-%d %H:00') 
            AS dateCreated, DATE_FORMAT(dateCreated, '%H:00') AS 
            dateCreated2 FROM tempUtilizations 
            WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)
            GROUP BY DATE(dateCreated), HOUR(dateCreated) ORDER BY dateCreated DESC LIMIT 24;
        ELSEIF get="getSum" THEN
            INSERT INTO maxOfTotal(active, utiltx, utilrx, usagetx,
            usagerx)
                SELECT SUM(active), SUM(utiltx), SUM(utilrx),
                SUM(usagetx), SUM(usagerx) FROM tempUtilizations
                WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)
                GROUP BY DATE(dateCreated), HOUR(dateCreated) ORDER BY dateCreated DESC;

                SELECT MAX(active) AS active, MAX(utiltx) AS utiltx, 
                MAX(utilrx) AS utilrx, MAX(usagetx) AS usagetx,
                MAX(usagerx) AS usagerx FROM maxOfTotal;
        ELSEIF get="getSumDate" THEN
            INSERT INTO maxOfTotal(active, dateCreated)
                SELECT SUM(active), dateCreated FROM 
                tempUtilizations WHERE dateCreated > DATE_SUB(NOW(), 
                INTERVAL 1 DAY) GROUP BY DATE(dateCreated), HOUR(dateCreated) 
                ORDER BY dateCreated DESC;

                SELECT active, DATE_FORMAT(dateCreated, '%H:00') 
                AS dateCreated FROM maxOfTotal 
                ORDER BY active DESC LIMIT 1;
        END IF;

    ELSEIF trend="perWeek" THEN
        INSERT INTO tempUtilizations(mac, active, ccq, utiltx, utilrx,
        usagetx, usagerx, lease, freeMem, cpuFreq, cpuLoad, freeHdd,
        badBlock, dateCreated)
            SELECT mac_fk, MAX(active), MAX(ccq), MAX(utiltx),
            MAX(utilrx), MAX(usagetx), MAX(usagerx), MAX(lease),        
            MAX(freeMemory), MAX(cpuFreq), MAX(cpuLoad), MAX(freeHdd),
            MAX(badBlock), dateCreated FROM max_table 
            WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 2 WEEK)
            GROUP BY DATE(dateCreated), mac_fk;

        IF get="getEach" THEN
            SELECT tempUtilizations.mac, macs.label, active, ccq, utiltx, utilrx, 
            usagetx, usagerx, lease, 
            freeMem, cpuFreq, cpuLoad, freeHdd, 
            badBlock, DATE_FORMAT(tempUtilizations.dateCreated, '%Y-%m-%d') 
            AS dateCreated, DATE_FORMAT(tempUtilizations.dateCreated, '%Y-%m-%d') 
            AS dateCreated2 FROM tempUtilizations
            LEFT OUTER JOIN macs ON tempUtilizations.mac = macs.mac  
            WHERE tempUtilizations.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)
            AND DATE(tempUtilizations.dateCreated)=created ORDER BY tempUtilizations.dateCreated DESC;
        ELSEIF get="" THEN
            SELECT SUM(active) AS active, MAX(ccq) AS ccq, 
            SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx, 
            SUM(usagetx) AS usagetx, SUM(usagerx) AS usagerx, 
            SUM(lease) AS lease, SUM(freeMem) AS freeMem, 
            SUM(cpuFreq) AS cpuFreq, SUM(cpuLoad) AS cpuLoad, 
            SUM(freeHdd) AS freeHdd, SUM(badBlock) AS badBlock, 
            DATE_FORMAT(dateCreated, '%Y-%m-%d') 
            AS dateCreated, DATE_FORMAT(dateCreated, '%Y-%m-%d') AS 
            dateCreated2 FROM tempUtilizations 
            WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)
            GROUP BY DATE(dateCreated) ORDER BY dateCreated DESC 
            LIMIT 7;
        ELSEIF get="getSum" THEN
            INSERT INTO maxOfTotal(active, utiltx, utilrx, usagetx,
            usagerx)
                SELECT SUM(active), SUM(utiltx), SUM(utilrx),
                SUM(usagetx), SUM(usagerx) FROM tempUtilizations
                WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)
                GROUP BY DATE(dateCreated) ORDER BY dateCreated DESC;

                SELECT MAX(active) AS active, MAX(utiltx) AS utiltx, 
                MAX(utilrx) AS utilrx, MAX(usagetx) AS usagetx,
                MAX(usagerx) AS usagerx FROM maxOfTotal;
        ELSEIF get="getSumDate" THEN
            INSERT INTO maxOfTotal(active, dateCreated)
                SELECT SUM(active), dateCreated FROM 
                tempUtilizations WHERE dateCreated > DATE_SUB(NOW(), 
                INTERVAL 1 WEEK) GROUP BY DATE(dateCreated) 
                ORDER BY dateCreated DESC;

                SELECT active, DATE_FORMAT(dateCreated, '%Y-%m-%d') 
                AS dateCreated FROM maxOfTotal 
                ORDER BY active DESC LIMIT 1;   
        END IF;

    ELSEIF trend="perMonth" THEN
        INSERT INTO tempUtilizations(mac, active, ccq, utiltx, utilrx,
        usagetx, usagerx, lease, freeMem, cpuFreq, cpuLoad, freeHdd,
        badBlock, dateCreated)
            SELECT mac_fk, MAX(active), MAX(ccq), MAX(utiltx),
            MAX(utilrx), MAX(usagetx), MAX(usagerx), MAX(lease),        
            MAX(freeMemory), MAX(cpuFreq), MAX(cpuLoad), MAX(freeHdd),
            MAX(badBlock), dateCreated FROM max_table 
            WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 2 MONTH)
            GROUP BY DATE(dateCreated), mac_fk;
        
        IF get="getEach" THEN
            SELECT tempUtilizations.mac, macs.label, active, ccq, utiltx, utilrx, 
            usagetx, usagerx, lease, 
            freeMem, cpuFreq, cpuLoad, freeHdd, 
            badBlock, DATE_FORMAT(tempUtilizations.dateCreated, '%Y-%m-%d') AS 
            dateCreated, DATE_FORMAT(tempUtilizations.dateCreated, '%Y-%m-%d') AS 
            dateCreated2 FROM tempUtilizations 
            LEFT OUTER JOIN macs ON tempUtilizations.mac = macs.mac 
            WHERE tempUtilizations.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
            AND DATE(tempUtilizations.dateCreated)=created ORDER BY tempUtilizations.dateCreated DESC;
        ELSEIF get="" THEN
            SELECT SUM(active) AS active, MAX(ccq) AS ccq, 
            SUM(utiltx) AS utiltx, SUM(utilrx) AS utilrx, 
            SUM(usagetx) AS usagetx, SUM(usagerx) AS usagerx, 
            SUM(lease) AS lease, SUM(freeMem) AS freeMem, 
            SUM(cpuFreq) AS cpuFreq, SUM(cpuLoad) AS cpuLoad, 
            SUM(freeHdd) AS freeHdd, SUM(badBlock) AS badBlock, 
            DATE_FORMAT(dateCreated, '%Y-%m-%d') 
            AS dateCreated, DATE_FORMAT(dateCreated, '%Y-%m-%d') AS 
            dateCreated2 FROM tempUtilizations 
            WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
            GROUP BY DATE(dateCreated) ORDER BY dateCreated DESC LIMIT 30;
        ELSEIF get="getSum" THEN
            INSERT INTO maxOfTotal(active, utiltx, utilrx, usagetx,
            usagerx)
                SELECT SUM(active), SUM(utiltx), SUM(utilrx),
                SUM(usagetx), SUM(usagerx) FROM tempUtilizations
                WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY DATE(dateCreated) ORDER BY dateCreated DESC;
                
                SELECT MAX(active) AS active, MAX(utiltx) AS utiltx, 
                MAX(utilrx) AS utilrx, MAX(usagetx) AS usagetx,
                MAX(usagerx) AS usagerx FROM maxOfTotal;
        ELSEIF get="getSumDate" THEN
            INSERT INTO maxOfTotal(active, dateCreated)
                SELECT SUM(active), dateCreated FROM 
                tempUtilizations WHERE dateCreated > DATE_SUB(NOW(), 
                INTERVAL 1 MONTH) GROUP BY DATE(dateCreated) 
                ORDER BY dateCreated DESC;

                SELECT active, DATE_FORMAT(dateCreated, '%Y-%m-%d') 
                AS dateCreated FROM maxOfTotal 
                ORDER BY active DESC LIMIT 1;
        END IF;
    END IF;
END$$
DELIMITER ;
