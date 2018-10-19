DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `MACS_PER_TREND`(IN `trend` VARCHAR(255))
    NO SQL
BEGIN
    DROP TABLE IF EXISTS tempUtilizations;
    CREATE TEMPORARY TABLE tempUtilizations(
        id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
        mac VARCHAR(255) NOT NULL DEFAULT 0,
        active INT(10) NOT NULL DEFAULT 0,
        utiltx DECIMAL(20,2) NOT NULL DEFAULT 0,
        utilrx DECIMAL(20,2) NOT NULL DEFAULT 0,
        usagetx DECIMAL(20,2) NOT NULL DEFAULT 0,
        usagerx DECIMAL(20,2) NOT NULL DEFAULT 0,
        ccq INT(10) NOT NULL DEFAULT 0,
        lease INT(10) NOT NULL DEFAULT 0,
        uptime VARCHAR(255) NOT NULL DEFAULT 0,
        freeMem DECIMAL(20,2) NOT NULL DEFAULT 0,
        cpuFreq INT(10) NOT NULL DEFAULT 0,
        cpuLoad INT(10) NOT NULL DEFAULT 0,
        freeHdd INT(10) NOT NULL DEFAULT 0,
        badBlock INT(10) NOT NULL DEFAULT 0,
        version VARCHAR(255) NOT NULL DEFAULT '',
        appVersion VARCHAR(255) NOT NULL DEFAULT '',
        gps VARCHAR(255) NOT NULL DEFAULT '',
        dispense VARCHAR(255) NOT NULL DEFAULT '',
        packages VARCHAR(255) NOT NULL DEFAULT '',
        vpnaddr VARCHAR(255) NOT NULL DEFAULT '',
        vendoVersion VARCHAR(255) NOT NULL DEFAULT '',
        dateCreated DATETIME NOT NULL DEFAULT 0,
        dateUpdated DATETIME NOT NULL DEFAULT 0
    );
    
    
    IF trend = "perDay" THEN
        INSERT INTO tempUtilizations(mac, active, utiltx,
        utilrx, usagetx, usagerx, ccq, lease, uptime, 
        freeMem, cpuFreq, cpuLoad, freeHdd, badBlock, version, appVersion,
        gps, dispense, packages, vpnaddr, vendoVersion, dateCreated, dateUpdated)
            SELECT mac_fk, MAX(active), MAX(utiltx), MAX(utilrx), 
            MAX(usagetx), MAX(usagerx), MAX(ccq), MAX(lease), 
            uptime, MAX(freeMemory), MAX(cpuFreq), MAX(cpuLoad), 
            MAX(freeHdd), MAX(badBlock), version, appVersion, gps, dispense,
            packages, vpnaddr, vendoVersion, dateCreated, dateUpdated FROM utilizations
            WHERE  dateCreated > DATE_SUB(NOW(), INTERVAL 2 DAY)
            GROUP BY DATE(dateCreated), HOUR(dateCreated), mac_fk; 

        SELECT tempUtilizations.mac, label, owner,  active, utiltx, utilrx, usagetx, usagerx, ccq, lease, 
        freeMem, cpuFreq, cpuLoad, freeHdd, badBlock, uptime, version, appVersion, gps, dispense, packages, 
        vpnaddr, vendoVersion, DATE_FORMAT(tempUtilizations.dateCreated, '%Y-%m-%d %H:00') 
        AS dateCreated FROM tempUtilizations 
        LEFT OUTER JOIN macs ON tempUtilizations.mac = macs.mac 
        LEFT OUTER JOIN macs_users ON tempUtilizations.mac = macs_users.mac  
        WHERE tempUtilizations.dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY) 
        ORDER BY tempUtilizations.dateCreated DESC;

    ELSEIF trend = "perWeek" THEN
        INSERT INTO tempUtilizations(mac, active, utiltx,
        utilrx, usagetx, usagerx, ccq, lease, uptime, 
        freeMem, cpuFreq, cpuLoad, freeHdd, badBlock, version, appVersion,
        gps, dispense, packages, vpnaddr, vendoVersion, dateCreated, dateUpdated)
            SELECT mac_fk, MAX(active), MAX(utiltx), MAX(utilrx), 
            MAX(usagetx), MAX(usagerx), MAX(ccq), MAX(lease), 
            uptime, MAX(freeMemory), MAX(cpuFreq), MAX(cpuLoad), 
            MAX(freeHdd), MAX(badBlock), version, appVersion, gps, dispense, 
            packages, vpnaddr, vendoVersion, dateCreated, dateUpdated FROM max_table
            WHERE  dateCreated > DATE_SUB(NOW(), INTERVAL 2 WEEK)
            GROUP BY DATE(dateCreated), mac_fk;
        
        SELECT tempUtilizations.mac, label, owner, active, utiltx, utilrx, 
        usagetx, usagerx, ccq, lease, freeMem, cpuFreq, cpuLoad, 
        freeHdd, badBlock, uptime, version, appVersion, gps, dispense, packages, 
        vpnaddr, vendoVersion, DATE_FORMAT(tempUtilizations.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempUtilizations 
        LEFT OUTER JOIN macs ON tempUtilizations.mac = macs.mac 
        LEFT OUTER JOIN macs_users ON tempUtilizations.mac = macs_users.mac
        WHERE tempUtilizations.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK) 
        ORDER BY tempUtilizations.dateCreated DESC;

    ELSEIF trend = "perMonth" THEN
        INSERT INTO tempUtilizations(mac, active, utiltx,
        utilrx, usagetx, usagerx, ccq, lease, uptime, 
        freeMem, cpuFreq, cpuLoad, freeHdd, badBlock, version, appVersion,
        gps, dispense, packages, vpnaddr, vendoVersion, dateCreated, dateUpdated)
            SELECT mac_fk, MAX(active), MAX(utiltx), MAX(utilrx), 
            MAX(usagetx), MAX(usagerx), MAX(ccq), MAX(lease), 
            uptime, MAX(freeMemory), MAX(cpuFreq), MAX(cpuLoad), 
            MAX(freeHdd), MAX(badBlock), version, appVersion, gps, dispense, 
            packages, vpnaddr, vendoVersion, dateCreated, dateUpdated FROM max_table
            WHERE  dateCreated > DATE_SUB(NOW(), INTERVAL 2 MONTH)
            GROUP BY DATE(dateCreated), mac_fk;
        
        SELECT tempUtilizations.mac, label, owner, active, utiltx, utilrx, 
        usagetx, usagerx, ccq, lease, freeMem, cpuFreq, cpuLoad, 
        freeHdd, badBlock, uptime, version, appVersion, gps, dispense, packages, 
        vpnaddr, vendoVersion, DATE_FORMAT(tempUtilizations.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempUtilizations 
        LEFT OUTER JOIN macs ON tempUtilizations.mac = macs.mac 
        LEFT OUTER JOIN macs_users ON tempUtilizations.mac = macs_users.mac
        WHERE tempUtilizations.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH) 
        ORDER BY tempUtilizations.dateCreated DESC;

    ELSEIF trend = "alert" THEN
        INSERT INTO tempUtilizations(mac, active, utiltx,
        utilrx, usagetx, usagerx, ccq, lease, uptime, 
        freeMem, cpuFreq, cpuLoad, freeHdd, badBlock, version, appVersion,
        gps, dispense, packages, vpnaddr, vendoVersion, dateCreated, dateUpdated)
            SELECT mac_fk, MAX(active), MAX(utiltx), MAX(utilrx), 
            MAX(usagetx), MAX(usagerx), MAX(ccq), MAX(lease), 
            uptime, MAX(freeMemory), MAX(cpuFreq), MAX(cpuLoad), 
            MAX(freeHdd), MAX(badBlock), version, appVersion, gps, dispense, 
            packages, vpnaddr, vendoVersion, dateCreated, dateUpdated FROM utilizations
            WHERE  dateCreated > DATE_SUB(NOW(), INTERVAL 4 DAY)
            GROUP BY DATE(dateCreated), mac_fk;
        
        SELECT tempUtilizations.mac, label, owner, active, utiltx, utilrx, 
        usagetx, usagerx, ccq, lease, freeMem, cpuFreq, cpuLoad, 
        freeHdd, badBlock, uptime, version, appVersion, gps, dispense, packages, 
        vpnaddr, vendoVersion, DATE_FORMAT(tempUtilizations.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempUtilizations 
        LEFT OUTER JOIN macs ON tempUtilizations.mac = macs.mac 
        LEFT OUTER JOIN macs_users ON tempUtilizations.mac = macs_users.mac
        ORDER BY tempUtilizations.dateCreated DESC;

    
    END IF;
    
END$$
DELIMITER ;
