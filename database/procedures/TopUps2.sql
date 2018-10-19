DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `TopUps2`(IN `cond` VARCHAR(180), IN `operator` VARCHAR(180), IN `mac` VARCHAR(180), IN `wallet` VARCHAR(10), IN `topup` VARCHAR(10), IN `notif` VARCHAR(180), IN `dateCreated` VARCHAR(180))
    NO SQL
BEGIN
    IF cond = 'truncate' THEN
        TRUNCATE TABLE top_ups;
    
    ELSEIF cond = 'fill-topups-table' THEN
        INSERT INTO top_ups SET top_ups.operator = operator, top_ups.mac = mac,
        top_ups.wallet = wallet, top_ups.topup = topup, top_ups.notif = notif,
        top_ups.dateCreated = dateCreated;


    ELSEIF cond = 'get-bal-his' THEN
        SELECT top_ups.operator, top_ups.mac, top_ups.wallet, top_ups.topup, 
        top_ups.notif, top_ups.dateCreated FROM top_ups
        ORDER BY top_ups.dateCreated DESC;
    ELSEIF cond = 'get-topup-notif' THEN
        SELECT top_ups.operator, top_ups.mac, top_ups.notif, top_ups.dateCreated FROM top_ups
        WHERE top_ups.notif != ''
        ORDER BY top_ups.dateCreated DESC;







    END IF;
END$$
DELIMITER ;
