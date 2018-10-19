DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `packages_to_decode`(IN `mac` VARCHAR(180))
    NO SQL
BEGIN
    DROP TABLE IF EXISTS decoded_packages;
    CREATE TEMPORARY TABLE decoded_packages(
        id INT(10) AUTO_INCREMENT PRIMARY KEY,
        mac VARCHAR(180) NOT NULL DEFAULT '',
        wallet VARCHAR(180) NOT NULL DEFAULT 0,
        packages VARCHAR(255) NOT NULL DEFAULT '',
        dateCreated DATETIME NOT NULL DEFAULT 0

    );

    INSERT INTO decoded_packages(id, mac, wallet, packages, dateCreated)
        SELECT id, mac_fk, wallet, packages, dateCreated FROM utilizations 
        WHERE id IN(
            SELECT MAX(id) FROM utilizations
            WHERE DATE_SUB(NOW(), INTERVAL 1 MONTH)
            GROUP BY DATE(dateCreated), mac_fk
        );

    SELECT * FROM decoded_packages
    WHERE decoded_packages.mac=mac;

END$$
DELIMITER ;
