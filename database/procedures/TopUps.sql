DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `TopUps`(IN `cond` VARCHAR(180), IN `trend` VARCHAR(180), IN `userParam` VARCHAR(180), IN `macParam` VARCHAR(180))
    NO SQL
BEGIN
    DROP TABLE IF EXISTS tempWallets;
    CREATE TEMPORARY TABLE tempWallets(
        id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
        mac VARCHAR(180) NOT NULL DEFAULT '',
        wallet INT(10) NOT NULL DEFAULT 0,
        topup INT(10) NOT NULL DEFAULT 0,
        notif VARCHAR(180) NOT NULL DEFAULT '',
        dateCreated VARCHAR(180) NOT NULL DEFAULT ''
    );
    INSERT INTO tempWallets(mac, wallet, dateCreated)
        SELECT mac_fk, wallet, DATE_FORMAT(dateCreated, '%Y-%m-%d %H:00') AS dateCreated FROM utilizations
            WHERE id IN(
                SELECT MAX(id) FROM utilizations
                WHERE dateCreated >  DATE_SUB(NOW(), INTERVAL 1 DAY)
                GROUP BY DATE(dateCreated), HOUR(dateCreated), mac_fk
            );

    DROP TABLE IF EXISTS tempWallets2;
    CREATE TEMPORARY TABLE tempWallets2(
        id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
        mac VARCHAR(180) NOT NULL DEFAULT '',
        wallet INT(10) NOT NULL DEFAULT 0,
        topup INT(10) NOT NULL DEFAULT 0,
        notif VARCHAR(180) NOT NULL DEFAULT '',
        dateCreated VARCHAR(180) NOT NULL DEFAULT ''
    );
    INSERT INTO tempWallets2(mac, wallet, dateCreated)
        SELECT mac_fk, wallet, DATE_FORMAT(dateCreated, '%Y-%m-%d') AS dateCreated FROM utilizations
            WHERE id IN(
                SELECT MAX(id) FROM utilizations
                WHERE dateCreated >  DATE_SUB(NOW(), INTERVAL 30 DAY)
                GROUP BY DATE(dateCreated), mac_fk
            );

    # This condition gets the active macs of operator within the month
    IF cond = 'opr-get-macs' THEN
        SELECT mac_fk AS mac, macs_users.owner FROM utilizations
        LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
        WHERE macs_users.owner = userParam
        GROUP BY mac_fk;

    # This condition gets the active macs of partner within the month
    ELSEIF cond = 'par-get-macs' THEN
        SELECT mac_fk AS mac, macs_users.owner FROM utilizations
        LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
        LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
        WHERE partners.partner = userParam
        GROUP BY mac_fk;





    # This condition gets the wallet results of operator
    ELSEIF cond = 'opr-get-wallet' THEN
        IF trend = 'perDay' THEN
            SELECT macs_users.owner AS operator, tempWallets.mac, tempWallets.wallet, 
            tempWallets.topup, tempWallets.notif, 
            DATE_FORMAT(tempWallets.dateCreated, '%Y-%m-%d %H:00') AS dateCreated FROM tempWallets
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempWallets.mac
            WHERE macs_users.mac = macParam
            ORDER BY tempWallets.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN   
            SELECT macs_users.owner AS operator, tempWallets2.mac, tempWallets2.wallet, 
            tempWallets2.topup, tempWallets2.notif, 
            DATE_FORMAT(tempWallets2.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempWallets2
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempWallets2.mac
            WHERE macs_users.mac = macParam
            AND tempWallets2.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)
            ORDER BY tempWallets2.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT macs_users.owner AS operator, tempWallets2.mac, tempWallets2.wallet, 
            tempWallets2.topup, tempWallets2.notif, 
            DATE_FORMAT(tempWallets2.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempWallets2
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempWallets2.mac
            WHERE macs_users.mac = macParam
            ORDER BY tempWallets2.dateCreated DESC;
        END IF;

    # This condition gets the wallet results of partner
    ELSEIF cond = 'par-get-wallet' THEN
        IF trend = 'perDay' THEN
            SELECT macs_users.owner AS operator, tempWallets.mac, tempWallets.wallet, 
            tempWallets.topup, tempWallets.notif, 
            DATE_FORMAT(tempWallets.dateCreated, '%Y-%m-%d %H:00') AS dateCreated FROM tempWallets
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempWallets.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE macs_users.mac = macParam
            ORDER BY tempWallets.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN   
            SELECT macs_users.owner AS operator, tempWallets2.mac, tempWallets2.wallet, 
            tempWallets2.topup, tempWallets2.notif, 
            DATE_FORMAT(tempWallets2.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempWallets2
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempWallets2.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE macs_users.mac = macParam
            AND tempWallets2.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)
            ORDER BY tempWallets2.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT macs_users.owner AS operator, tempWallets2.mac, tempWallets2.wallet, 
            tempWallets2.topup, tempWallets2.notif, 
            DATE_FORMAT(tempWallets2.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempWallets2
            LEFT OUTER JOIN macs_users ON macs_users.mac = tempWallets2.mac
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE macs_users.mac = macParam
            ORDER BY tempWallets2.dateCreated DESC;
        END IF;


    END IF;
END$$
DELIMITER ;
