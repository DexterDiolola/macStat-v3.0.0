DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADD_MAC_ENTRY`(IN `mac` VARCHAR(180), IN `active` BIGINT(20), IN `utiltx` BIGINT(20), IN `utilrx` BIGINT(20), IN `usagetx` BIGINT(20), IN `usagerx` BIGINT(20), IN `ccq` BIGINT(20), IN `lease` BIGINT(20), IN `uptime` VARCHAR(180), IN `freeMemory` BIGINT(20), IN `cpuFreq` BIGINT(20), IN `cpuLoad` BIGINT(20), IN `freeHdd` BIGINT(20), IN `badBlock` BIGINT(20), IN `version` VARCHAR(180), IN `appVersion` VARCHAR(180), IN `gps` VARCHAR(255), IN `dispense` VARCHAR(255), IN `packages` VARCHAR(255), IN `vpnaddr` VARCHAR(180), IN `vendoVersion` VARCHAR(180), IN `wallet` VARCHAR(180), IN `cond` VARCHAR(180))
    NO SQL
BEGIN
    IF cond = "not_existing" THEN
        INSERT INTO macs SET macs.mac = mac, macs.coords = gps, dateCreated = NOW(),
        dateUpdated = NOW();
        
        INSERT INTO macs_users SET macs_users.mac = mac, dateCreated = NOW(),
        dateUpdated = NOW();
        
        INSERT INTO utilizations SET utilizations.mac_fk = mac,
        utilizations.active = active, utilizations.utiltx = utiltx/1000, utilizations.utilrx = utilrx/1000, 
        utilizations.usagetx = usagetx/1000000000, utilizations.usagerx = usagerx/1000000000,
        utilizations.ccq = ccq, utilizations.lease = lease, utilizations.uptime = uptime,
        utilizations.freeMemory = freeMemory/1000000, utilizations.cpuFreq = cpuFreq,
        utilizations.cpuLoad = cpuLoad, utilizations.freeHdd = freeHdd,
        utilizations.badBlock = badBlock, utilizations.version = version, utilizations.appVersion = appVersion,
        utilizations.gps = gps, utilizations.dispense = dispense, utilizations.packages = packages,
        utilizations.vpnaddr = vpnaddr, utilizations.vendoVersion = vendoVersion, utilizations.wallet = wallet, 
        utilizations.dateCreated=NOW(), utilizations.dateUpdated=NOW();

    
    ELSEIF cond = "existed" THEN
        INSERT INTO utilizations SET utilizations.mac_fk = mac,
        utilizations.active = active, utilizations.utiltx = utiltx/1000, utilizations.utilrx = utilrx/1000, 
        utilizations.usagetx = usagetx/1000000000, utilizations.usagerx = usagerx/1000000000,
        utilizations.ccq = ccq, utilizations.lease = lease, utilizations.uptime = uptime,
        utilizations.freeMemory = freeMemory/1000000, utilizations.cpuFreq = cpuFreq,
        utilizations.cpuLoad = cpuLoad, utilizations.freeHdd = freeHdd,
        utilizations.badBlock = badBlock, utilizations.version = version, utilizations.appVersion = appVersion,
        utilizations.gps = gps, utilizations.dispense = dispense, utilizations.packages = packages,
        utilizations.vpnaddr = vpnaddr, utilizations.vendoVersion = vendoVersion, utilizations.wallet = wallet,
        utilizations.dateCreated=NOW(), utilizations.dateUpdated=NOW();

        UPDATE macs SET macs.coords = gps WHERE macs.mac = mac;

        
    
    END IF;
END$$
DELIMITER ;
