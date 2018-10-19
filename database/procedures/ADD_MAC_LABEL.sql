DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ADD_MAC_LABEL`(IN `cond` VARCHAR(180), IN `mac` VARCHAR(180), IN `label` VARCHAR(180))
    NO SQL
BEGIN
	IF cond = 'edit-label' THEN
    	UPDATE macs SET macs.label = label, 
        macs.dateUpdated = NOW() WHERE macs.mac = mac;
    
    ELSEIF cond = 'recently-updated' THEN
    	SELECT macs.mac, macs.label, dateCreated, dateUpdated 
        FROM macs WHERE dateUpdated > DATE_SUB(NOW(), INTERVAL 3 DAY)
        ORDER BY dateUpdated DESC;
    
    END IF;

END$$
DELIMITER ;
