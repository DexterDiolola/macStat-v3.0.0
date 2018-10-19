DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mac_administration`(IN `cond` VARCHAR(180), IN `operator` VARCHAR(180), IN `partner` VARCHAR(180), IN `mac` VARCHAR(180))
    NO SQL
BEGIN
    
    # This condition uses parameter 'operaor' as username to select from users table
    # Used to check what userType has logged in WebReport
    IF cond = 'get-user-type' THEN
        SELECT userType FROM users WHERE username = operator;

    # This condition adds new operator to partners table whenever there is a new user created
    # The function 'register' in LoginController.php  must use this
    ELSEIF cond = 'add-new-operator' THEN
        INSERT INTO partners SET partners.operator = operator,
        dateCreated = NOW(), dateUpdated = NOW();


    # /----------------- OPERATOR -------------------/

    # This condition shows the available devices that has not been yet assigned to operators
    ELSEIF cond = 'available-devices' THEN
        SELECT macs_users.mac, macs.label, macs_users.owner, macs_users.dateCreated
        FROM macs_users
        LEFT OUTER JOIN macs ON macs_users.mac = macs.mac
        WHERE macs_users.owner = ''
        ORDER BY macs_users.dateCreated DESC;

    # This condition shows the assigned device to specific operator
    ELSEIF cond = 'operator-devices' THEN
        SELECT macs_users.mac, macs_users.owner AS operator, macs.label, macs_users.dateCreated
        FROM macs_users
        LEFT OUTER JOIN macs ON macs_users.mac = macs.mac
        WHERE macs_users.owner = operator
        ORDER BY macs_users.dateCreated DESC;

    # This condion shows all the operators
    ELSEIF cond = 'operators-list' THEN
        SELECT users.username AS operator FROM users WHERE users.userType = 'Operator';

    # This condition shows the specific operator with his no. of devices owned
    ELSEIF cond = 'operator-info' THEN
        SELECT macs_users.owner AS operator, COUNT(macs_users.owner) AS ownedDevice, macs_users.dateCreated
        FROM macs_users
        WHERE macs_users.owner = operator
        GROUP BY macs_users.owner;

    ELSEIF cond = 'assign-device' THEN
        UPDATE macs_users SET macs_users.owner = operator, macs_users.dateCreated = NOW(), 
        macs_users.dateUpdated = NOW()
        WHERE macs_users.mac = mac;

    ELSEIF cond = 'unassign-device' THEN
        UPDATE macs_users SET macs_users.owner = '', macs_users.dateCreated = NOW(), 
        macs_users.dateUpdated = NOW()
        WHERE macs_users.mac = mac;


    # /----------------- PARTNER -------------------/

    # This condition shows the available operators that has not been yet assigned to partners
    ELSEIF cond = 'available-operators' THEN
        SELECT partners.partner, macs_users.owner AS operator, COUNT(macs_users.owner) AS ownedDevice
        FROM macs_users
        LEFT OUTER JOIN partners ON macs_users.owner = partners.operator
        WHERE macs_users.owner != '' AND partners.partner = ''
        GROUP BY macs_users.owner
        ORDER BY ownedDevice DESC;

    # This condition shows the assigned operators to specific partner
    ELSEIF cond = 'partner-operators' THEN
        SELECT partners.partner, macs_users.owner AS operator, COUNT(macs_users.owner) AS ownedDevice
        FROM macs_users
        LEFT OUTER JOIN partners ON macs_users.owner = partners.operator
        WHERE macs_users.owner != '' AND partners.partner = partner
        GROUP BY macs_users.owner
        ORDER BY ownedDevice DESC;

    # This condition shows all the partner
    ELSEIF cond = 'partners-list' THEN
        SELECT users.username AS partner FROM users WHERE users.userType = 'Partner';

    # This condition shows the specific partner with his no. of operators owned
    ELSEIF cond = 'partner-info' THEN
        SELECT partners.partner, COUNT(partners.partner) AS ownedOpr, partners.dateCreated
        FROM partners
        WHERE partners.partner = partner
        GROUP BY partners.partner;

    ELSEIF cond = 'assign-operator' THEN
        UPDATE partners SET partners.partner = partner, partners.dateCreated = NOW(),
        partners.dateUpdated = NOW()
        WHERE partners.operator = operator;

    ELSEIF cond = 'unassign-operator' THEN
        UPDATE partners SET partners.partner = '', partners.dateCreated = NOW(),
        partners.dateUpdated = NOW()
        WHERE partners.operator = operator;

    END IF;
END$$
DELIMITER ;
