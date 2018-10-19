DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GET_ACTIVE_MACS`(IN `trend` VARCHAR(180), IN `get` VARCHAR(180), IN `created` VARCHAR(180))
    NO SQL
BEGIN
    DROP TABLE IF EXISTS actives;
    CREATE TEMPORARY TABLE actives(
        id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
        activeDevice VARCHAR(255) NOT NULL DEFAULT '',
        dateCreated DATETIME NOT NULL DEFAULT 0
    );

    IF trend = "macs" THEN
        SELECT macs.mac, macs.label, macs.coords, macs_users.owner, macs.dateCreated FROM macs
        LEFT OUTER JOIN macs_users ON macs.mac = macs_users.mac
        ORDER BY macs.id DESC;

    ELSEIF trend = "countActivePD" THEN        
        INSERT INTO actives(activeDevice)
            SELECT mac_fk FROM utilizations 
            WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)
            GROUP BY mac_fk;
        
        IF get = "getCount" THEN
            SELECT COUNT(*) as activeDevice FROM actives;
        ELSEIF get = "getMac" THEN
            SELECT activeDevice FROM actives;
        END IF;

    
    ELSEIF trend = "countActivePW" THEN        
        INSERT INTO actives(activeDevice)
            SELECT mac_fk FROM max_table 
            WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)
            GROUP BY mac_fk;

        IF get = "getCount" THEN
            SELECT COUNT(*) as activeDevice FROM actives;
        ELSEIF get = "getMac" THEN
            SELECT activeDevice FROM actives;
        END IF;

    ELSEIF trend = "countActivePM" THEN        
        INSERT INTO actives(activeDevice)
            SELECT mac_fk FROM max_table 
            WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
            GROUP BY mac_fk;     
        
        IF get = "getCount" THEN
            SELECT COUNT(*) as activeDevice FROM actives;
        ELSEIF get = "getMac" THEN
            SELECT activeDevice FROM actives;
        END IF;

    ELSEIF trend = "perDay" THEN
        INSERT INTO actives(activeDevice, dateCreated)
            SELECT mac_fk, dateCreated FROM utilizations
            WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 2 DAY)
            GROUP BY DATE(dateCreated), HOUR(dateCreated), mac_fk;

        IF get="getCount" THEN
            SELECT COUNT(activeDevice) AS totalActive, 
            DATE_FORMAT(dateCreated, '%Y-%m-%d %H:00') AS dateCreated, 
            DATE_FORMAT (dateCreated, '%H:00') AS dateCreated2 
            FROM actives  WHERE dateCreated > DATE_SUB(NOW(), 
            INTERVAL 1 DAY) GROUP BY DATE(dateCreated), HOUR(dateCreated) 
            ORDER BY dateCreated DESC LIMIT 24;
        ELSEIF get="getMac" THEN
            SELECT activeDevice, DATE_FORMAT(dateCreated, 
            "%Y-%m-%d %H-00") AS dateCreated FROM actives
            WHERE dateCreated>DATE_SUB(NOW(), INTERVAL 23 HOUR)
            AND HOUR(dateCreated) = created;
        END IF;
    
    ELSEIF trend="perWeek" THEN
        INSERT INTO actives(activeDevice, dateCreated)
            SELECT mac_fk, dateCreated FROM max_table
            WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 2 WEEK)
            GROUP BY DATE(dateCreated), mac_fk;

        IF get="getCount" THEN
            SELECT COUNT(activeDevice) AS totalActive, 
            DATE_FORMAT(dateCreated, '%Y-%m-%d') AS dateCreated, 
            DATE_FORMAT(dateCreated, '%Y-%m-%d') AS dateCreated2 
            FROM actives WHERE dateCreated > DATE_SUB(NOW(),
            INTERVAL 1 WEEK) GROUP BY DATE(dateCreated) 
            ORDER BY dateCreated DESC LIMIT 7;
        ELSEIF get="getMac" THEN
            SELECT activeDevice, DATE_FORMAT(dateCreated, 
            "%Y-%m-%d") AS dateCreated FROM actives
            WHERE DATE(dateCreated) = created;
        END IF;

    ELSEIF trend="perMonth" THEN
        INSERT INTO actives(activeDevice, dateCreated)
            SELECT mac_fk, dateCreated FROM max_table
            WHERE dateCreated > DATE_SUB(NOW(), INTERVAL 2 MONTH)
            GROUP BY DATE(dateCreated), mac_fk;

        IF get="getCount" THEN
            SELECT COUNT(activeDevice) AS totalActive, 
            DATE_FORMAT(dateCreated, '%Y-%m-%d') AS dateCreated, 
            DATE_FORMAT(dateCreated, '%Y-%m-%d') AS dateCreated2 
            FROM actives WHERE dateCreated > DATE_SUB(NOW(),
            INTERVAL 1 MONTH) GROUP BY DATE(dateCreated) 
            ORDER BY dateCreated DESC LIMIT 30;
        ELSEIF get="getMac" THEN
            SELECT activeDevice, DATE_FORMAT(dateCreated, 
            "%Y-%m-%d") AS dateCreated FROM actives
            WHERE DATE(dateCreated) = created;
        END IF;

    
    END IF;
    

END$$
DELIMITER ;
