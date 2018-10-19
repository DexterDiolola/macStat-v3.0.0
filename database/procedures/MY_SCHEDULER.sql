DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `MY_SCHEDULER`()
    NO SQL
BEGIN



INSERT INTO max_table(mac_fk, active, ccq, utiltx, utilrx,
        usagetx, usagerx, lease, uptime, freeMemory, cpuFreq, cpuLoad, freeHdd,
        badBlock, version, appVersion, gps, dispense, packages, vpnaddr, vendoVersion, wallet, dateCreated)
            SELECT mac_fk, MAX(active), MAX(ccq), MAX(utiltx),
            MAX(utilrx), MAX(usagetx), MAX(usagerx), MAX(lease), uptime,       
            MAX(freeMemory), MAX(cpuFreq), MAX(cpuLoad), MAX(freeHdd),
            MAX(badBlock), version, appVersion, gps, dispense, packages, vpnaddr, vendoVersion, wallet, dateCreated FROM utilizations 
            WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)
            GROUP BY DATE(dateCreated), mac_fk;


INSERT INTO min_table(mac_fk, active, ccq, utiltx, utilrx,
    usagetx, usagerx, lease, uptime, freeMemory, cpuFreq, cpuLoad, freeHdd,
    badBlock, dateCreated)
        SELECT mac_fk, MIN(active), MIN(ccq), MIN(utiltx),
        MIN(utilrx), MIN(usagetx), MIN(usagerx), MIN(lease), uptime,       
        MIN(freeMemory), MIN(cpuFreq), MIN(cpuLoad), MIN(freeHdd),
        MIN(badBlock), dateCreated FROM utilizations 
        WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)
        GROUP BY DATE(dateCreated), mac_fk;

DELETE FROM utilizations WHERE dateCreated < DATE_SUB(NOW(), INTERVAL 1 MONTH);

END$$
DELIMITER ;
