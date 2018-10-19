DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `MacStats`(IN `cond` VARCHAR(180), IN `trend` VARCHAR(180), IN `userParam` VARCHAR(180), IN `macParam` VARCHAR(180))
    NO SQL
BEGIN

     IF cond = 'opr-get-mac' THEN
        IF trend = 'perDay' THEN
            SELECT utilizations.mac_fk AS mac, SUM(utilizations.active) AS connected, 
            SUM(utilizations.cpuFreq) AS cpuFreq, SUM(utilizations.usagetx) AS usagetx, 
            SUM(utilizations.usagerx) AS usagerx, SUM(utilizations.utiltx) AS utiltx, 
            SUM(utilizations.utilrx) AS utilrx, macs.label AS site, macs_users.owner AS operator, 
            DATE_FORMAT(utilizations.dateCreated, '%Y-%m-%d') AS dateCreated FROM utilizations
            LEFT OUTER JOIN macs ON macs.mac = utilizations.mac_fk
            LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
            WHERE utilizations.id IN(
                SELECT MAX(utilizations.id) FROM utilizations
                WHERE DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY DATE(utilizations.dateCreated), utilizations.mac_fk
            )
            AND macs_users.owner = userParam
            AND macs_users.mac = macParam
            GROUP BY DATE(utilizations.dateCreated), utilizations.mac_fk
            ORDER BY utilizations.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT utilizations.mac_fk AS mac, SUM(utilizations.active) AS connected, 
            SUM(utilizations.cpuFreq) AS cpuFreq, SUM(utilizations.usagetx) AS usagetx, 
            SUM(utilizations.usagerx) AS usagerx, SUM(utilizations.utiltx) AS utiltx, 
            SUM(utilizations.utilrx) AS utilrx, macs.label AS site, macs_users.owner AS operator, 
            DATE_FORMAT(utilizations.dateCreated, '%Y-%m-%d') AS dateCreated FROM utilizations
            LEFT OUTER JOIN macs ON macs.mac = utilizations.mac_fk
            LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
            WHERE utilizations.id IN(
                SELECT MAX(utilizations.id) FROM utilizations
                WHERE DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY DATE(utilizations.dateCreated), utilizations.mac_fk
            )
            AND macs_users.owner = userParam
            AND macs_users.mac = macParam
            GROUP BY WEEK(utilizations.dateCreated), utilizations.mac_fk
            ORDER BY utilizations.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT utilizations.mac_fk AS mac, SUM(utilizations.active) AS connected, 
            SUM(utilizations.cpuFreq) AS cpuFreq, SUM(utilizations.usagetx) AS usagetx, 
            SUM(utilizations.usagerx) AS usagerx, SUM(utilizations.utiltx) AS utiltx, 
            SUM(utilizations.utilrx) AS utilrx, macs.label AS site, macs_users.owner AS operator, 
            DATE_FORMAT(utilizations.dateCreated, '%Y-%m-%d') AS dateCreated FROM utilizations
            LEFT OUTER JOIN macs ON macs.mac = utilizations.mac_fk
            LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
            WHERE utilizations.id IN(
                SELECT MAX(utilizations.id) FROM utilizations
                WHERE DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY DATE(utilizations.dateCreated), utilizations.mac_fk
            )
            AND macs_users.owner = userParam
            AND macs_users.mac = macParam
            GROUP BY MONTH(utilizations.dateCreated), utilizations.mac_fk
            ORDER BY utilizations.dateCreated DESC;
        END IF;


        ELSEIF cond = 'par-get-mac' THEN
        IF trend = 'perDay' THEN
            SELECT utilizations.mac_fk AS mac, SUM(utilizations.active) AS connected, 
            SUM(utilizations.cpuFreq) AS cpuFreq, SUM(utilizations.usagetx) AS usagetx, 
            SUM(utilizations.usagerx) AS usagerx, SUM(utilizations.utiltx) AS utiltx, 
            SUM(utilizations.utilrx) AS utilrx, macs.label AS site, macs_users.owner AS operator, 
            DATE_FORMAT(utilizations.dateCreated, '%Y-%m-%d') AS dateCreated FROM utilizations
            LEFT OUTER JOIN macs ON macs.mac = utilizations.mac_fk
            LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE utilizations.id IN(
                SELECT MAX(utilizations.id) FROM utilizations
                WHERE DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY DATE(utilizations.dateCreated), utilizations.mac_fk
            )
            AND partners.partner = userParam
            AND macs_users.mac = macParam
            GROUP BY DATE(utilizations.dateCreated), utilizations.mac_fk
            ORDER BY utilizations.dateCreated DESC;
        ELSEIF trend = 'perWeek' THEN
            SELECT utilizations.mac_fk AS mac, SUM(utilizations.active) AS connected, 
            SUM(utilizations.cpuFreq) AS cpuFreq, SUM(utilizations.usagetx) AS usagetx, 
            SUM(utilizations.usagerx) AS usagerx, SUM(utilizations.utiltx) AS utiltx, 
            SUM(utilizations.utilrx) AS utilrx, macs.label AS site, macs_users.owner AS operator, 
            DATE_FORMAT(utilizations.dateCreated, '%Y-%m-%d') AS dateCreated FROM utilizations
            LEFT OUTER JOIN macs ON macs.mac = utilizations.mac_fk
            LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE utilizations.id IN(
                SELECT MAX(utilizations.id) FROM utilizations
                WHERE DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY DATE(utilizations.dateCreated), utilizations.mac_fk
            )
            AND partners.partner = userParam
            AND macs_users.mac = macParam
            GROUP BY WEEK(utilizations.dateCreated), utilizations.mac_fk
            ORDER BY utilizations.dateCreated DESC;
        ELSEIF trend = 'perMonth' THEN
            SELECT utilizations.mac_fk AS mac, SUM(utilizations.active) AS connected, 
            SUM(utilizations.cpuFreq) AS cpuFreq, SUM(utilizations.usagetx) AS usagetx, 
            SUM(utilizations.usagerx) AS usagerx, SUM(utilizations.utiltx) AS utiltx, 
            SUM(utilizations.utilrx) AS utilrx, macs.label AS site, macs_users.owner AS operator, 
            DATE_FORMAT(utilizations.dateCreated, '%Y-%m-%d') AS dateCreated FROM utilizations
            LEFT OUTER JOIN macs ON macs.mac = utilizations.mac_fk
            LEFT OUTER JOIN macs_users ON macs_users.mac = utilizations.mac_fk
            LEFT OUTER JOIN partners ON partners.operator = macs_users.owner
            WHERE utilizations.id IN(
                SELECT MAX(utilizations.id) FROM utilizations
                WHERE DATE_SUB(NOW(), INTERVAL 1 MONTH)
                GROUP BY DATE(utilizations.dateCreated), utilizations.mac_fk
            )
            AND partners.partner = userParam
            AND macs_users.mac = macParam
            GROUP BY MONTH(utilizations.dateCreated), utilizations.mac_fk
            ORDER BY utilizations.dateCreated DESC;
        END IF;



    END IF;
END$$
DELIMITER ;
