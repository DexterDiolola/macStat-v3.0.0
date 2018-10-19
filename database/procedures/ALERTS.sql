DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ALERTS`(IN `cond` VARCHAR(50), IN `mac` VARCHAR(50), IN `label` VARCHAR(50), IN `owner` VARCHAR(50), IN `alertType` VARCHAR(50), IN `alertMsg` VARCHAR(255), IN `dateCreated` VARCHAR(50))
    NO SQL
BEGIN

    IF cond = 'truncate' THEN
        TRUNCATE TABLE alerts;

    ELSEIF cond = 'getMax' THEN
        SELECT * FROM alert_setting_values;

    ELSEIF cond = 'sendAlert' THEN
        INSERT INTO alerts SET alerts.mac = mac, alerts.label = label, alerts.owner = owner, alerts.alertType = alertType,
        alerts.alertMsg = alertMsg, alerts.dateCreated = dateCreated;

    ELSEIF cond = 'getAlert' THEN
        SELECT alerts.mac, alerts.label, alerts.owner, alerts.alertType, alerts.alertMsg, DATE_FORMAT(alerts.dateCreated, '%Y-%m-%d') AS dateCreated
        FROM alerts;

    END IF;


END$$
DELIMITER ;
