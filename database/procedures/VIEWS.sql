DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `VIEWS`(IN `cond` VARCHAR(50), IN `routerMac` VARCHAR(50), IN `userMac` VARCHAR(255), IN `loginType` VARCHAR(50), IN `loginValue` VARCHAR(50))
    NO SQL
BEGIN
    DROP TABLE IF EXISTS tempViews;
    CREATE TEMPORARY TABLE tempViews(
        id INT(10) AUTO_INCREMENT PRIMARY KEY,
        routerMac VARCHAR(50) NOT NULL DEFAULT '',
        dateCreated DATETIME NOT NULL DEFAULT 0,
        viewCount INT(10) NOT NULL DEFAULT 0

    );

    IF cond = 'insert' THEN
        INSERT INTO views SET views.routerMac = routerMac, views.userMac = userMac,
        views.loginType = loginType, views.loginValue = loginValue, 
        views.dateCreated = NOW();





    /*Views Summary*/
    ELSEIF cond = 'perDay' THEN
        SELECT views.routerMac, label, owner, DATE_FORMAT(views.dateCreated, '%Y-%m-%d %H:00') AS dateCreated, COUNT(*) as viewCount FROM views 
        LEFT OUTER JOIN macs ON views.routerMac = macs.mac
        LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
        WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)   
        GROUP BY views.routerMac, DATE(views.dateCreated), HOUR(views.dateCreated)
        ORDER BY views.dateCreated DESC;

    ELSEIF cond = 'perWeek' THEN
        SELECT views.routerMac, label, owner, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated, COUNT(*) as viewCount FROM views 
        LEFT OUTER JOIN macs ON views.routerMac = macs.mac
        LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
        WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)   
        GROUP BY views.routerMac, DATE(views.dateCreated)
        ORDER BY views.dateCreated DESC;

    ELSEIF cond = 'perMonth' THEN
        SELECT views.routerMac, label, owner, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated, COUNT(*) as viewCount FROM views 
        LEFT OUTER JOIN macs ON views.routerMac = macs.mac
        LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
        WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)   
        GROUP BY views.routerMac, DATE(views.dateCreated)
        ORDER BY views.dateCreated DESC;





    
    
    /*Views Summary user*/
    /*Use userMac parameter as owner of mac*/
    ELSEIF cond = 'perDay-user' THEN
        SELECT views.routerMac, label, owner, DATE_FORMAT(views.dateCreated, '%Y-%m-%d %H:00') AS dateCreated, COUNT(*) as viewCount FROM views 
        LEFT OUTER JOIN macs ON views.routerMac = macs.mac
        LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
        WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)
        AND macs_users.owner = userMac   
        GROUP BY views.routerMac, DATE(views.dateCreated), HOUR(views.dateCreated)
        ORDER BY views.dateCreated DESC;

    ELSEIF cond = 'perWeek-user' THEN
        SELECT views.routerMac, label, owner, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated, COUNT(*) as viewCount FROM views 
        LEFT OUTER JOIN macs ON views.routerMac = macs.mac
        LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
        WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)
        AND macs_users.owner = userMac   
        GROUP BY views.routerMac, DATE(views.dateCreated)
        ORDER BY views.dateCreated DESC;

    ELSEIF cond = 'perMonth-user' THEN
        SELECT views.routerMac, label, owner, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated, COUNT(*) as viewCount FROM views 
        LEFT OUTER JOIN macs ON views.routerMac = macs.mac
        LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
        WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
        AND macs_users.owner = userMac   
        GROUP BY views.routerMac, DATE(views.dateCreated)
        ORDER BY views.dateCreated DESC;                





    /*Views Summary Permac*/
    ELSEIF cond = 'permac-perDay' THEN
        SELECT views.routerMac, label, owner, DATE_FORMAT(views.dateCreated, '%Y-%m-%d %H:00') AS dateCreated, COUNT(*) as viewCount FROM views 
        LEFT OUTER JOIN macs ON views.routerMac = macs.mac
        LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
        WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)  
        AND views.routerMac = routerMac 
        GROUP BY views.routerMac, DATE(views.dateCreated), HOUR(views.dateCreated)
        ORDER BY views.dateCreated DESC;

    ELSEIF cond = 'permac-perWeek' THEN
        SELECT views.routerMac, label, owner, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated, COUNT(*) as viewCount FROM views 
        LEFT OUTER JOIN macs ON views.routerMac = macs.mac
        LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
        WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)
        AND views.routerMac = routerMac   
        GROUP BY views.routerMac, DATE(views.dateCreated)
        ORDER BY views.dateCreated DESC;

    ELSEIF cond = 'permac-perMonth' THEN
        SELECT views.routerMac, label, owner, DATE_FORMAT(views.dateCreated, '%Y-%m-%d') AS dateCreated, COUNT(*) as viewCount FROM views 
        LEFT OUTER JOIN macs ON views.routerMac = macs.mac
        LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
        WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
        AND views.routerMac = routerMac   
        GROUP BY views.routerMac, DATE(views.dateCreated)
        ORDER BY views.dateCreated DESC;





    /*Max of ViewCounts*/
    ELSEIF cond = 'max-perDay' THEn
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views
            WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)   
            GROUP BY views.routerMac, DATE(views.dateCreated), HOUR(views.dateCreated);

        SELECT SUM(tempViews.viewCount) AS totalViews FROM tempViews;

    ELSEIF cond = 'max-perWeek' THEn
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views
            WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)   
            GROUP BY views.routerMac, DATE(views.dateCreated);

        SELECT SUM(tempViews.viewCount) AS totalViews FROM tempViews;

    ELSEIF cond = 'max-perMonth' THEn
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views
            WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)   
            GROUP BY views.routerMac, DATE(views.dateCreated);

        SELECT SUM(tempViews.viewCount) AS totalViews FROM tempViews;

    ELSEIF cond = 'max-overall' THEn
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views;

        SELECT SUM(tempViews.viewCount) AS totalViews FROM tempViews;





    /*Max of ViewCounts user*/
    ELSEIF cond = 'max-perDay-user' THEn
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views
            LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
            WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)
            AND macs_users.owner = userMac   
            GROUP BY views.routerMac, DATE(views.dateCreated), HOUR(views.dateCreated);

        SELECT SUM(tempViews.viewCount) AS totalViews FROM tempViews;

    ELSEIF cond = 'max-perWeek-user' THEn
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views
            LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
            WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK) 
            AND macs_users.owner = userMac  
            GROUP BY views.routerMac, DATE(views.dateCreated);

        SELECT SUM(tempViews.viewCount) AS totalViews FROM tempViews;

    ELSEIF cond = 'max-perMonth-user' THEn
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views
            LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
            WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
            AND macs_users.owner = userMac   
            GROUP BY views.routerMac, DATE(views.dateCreated);

        SELECT SUM(tempViews.viewCount) AS totalViews FROM tempViews;

    ELSEIF cond = 'max-overall-user' THEn
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views
            LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
            WHERE  macs_users.owner = userMac; 

        SELECT SUM(tempViews.viewCount) AS totalViews FROM tempViews;







    /*Graph for viewCount*/
    ELSEIF cond = 'graph-perDay' THEN       
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views
            WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)   
            GROUP BY views.routerMac, DATE(views.dateCreated), HOUR(views.dateCreated);

        SELECT SUM(tempViews.viewCount) AS totalViewCount, DATE_FORMAT(tempViews.dateCreated, '%Y-%m-%d %H:00') AS dateCreated FROM tempViews
        GROUP BY DATE(tempViews.dateCreated), HOUR(tempViews.dateCreated)
        ORDER BY tempViews.dateCreated DESC;

    ELSEIF cond = 'graph-perWeek' THEN       
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views
            WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK)   
            GROUP BY views.routerMac, DATE(views.dateCreated);

        SELECT SUM(tempViews.viewCount) AS totalViewCount, DATE_FORMAT(tempViews.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempViews
        GROUP BY DATE(tempViews.dateCreated)
        ORDER BY tempViews.dateCreated DESC;

    ELSEIF cond = 'graph-perMonth' THEN
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views
            WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)   
            GROUP BY views.routerMac, DATE(views.dateCreated);

        SELECT SUM(tempViews.viewCount) AS totalViewCount, DATE_FORMAT(tempViews.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempViews
        GROUP BY DATE(tempViews.dateCreated)
        ORDER BY tempViews.dateCreated DESC;






    /*Graph for viewCount User*/
    ELSEIF cond = 'graph-perDay-user' THEn
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views
            LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
            WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 DAY)
            AND macs_users.owner = userMac   
            GROUP BY views.routerMac, DATE(views.dateCreated), HOUR(views.dateCreated);

        SELECT SUM(tempViews.viewCount) AS totalViewCount, DATE_FORMAT(tempViews.dateCreated, '%Y-%m-%d %H:00') AS dateCreated FROM tempViews
        GROUP BY DATE(tempViews.dateCreated), HOUR(tempViews.dateCreated)
        ORDER BY tempViews.dateCreated DESC;

    ELSEIF cond = 'graph-perWeek-user' THEn
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views
            LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
            WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 WEEK) 
            AND macs_users.owner = userMac  
            GROUP BY views.routerMac, DATE(views.dateCreated);

        SELECT SUM(tempViews.viewCount) AS totalViewCount, DATE_FORMAT(tempViews.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempViews
        GROUP BY DATE(tempViews.dateCreated)
        ORDER BY tempViews.dateCreated DESC;

    ELSEIF cond = 'graph-perMonth-user' THEn
        INSERT INTO tempViews(routerMac, dateCreated, viewCount)
            SELECT views.routerMac, views.dateCreated, COUNT(*) FROM views
            LEFT OUTER JOIN macs_users ON views.routerMac = macs_users.mac
            WHERE views.dateCreated > DATE_SUB(NOW(), INTERVAL 1 MONTH)
            AND macs_users.owner = userMac   
            GROUP BY views.routerMac, DATE(views.dateCreated);

        SELECT SUM(tempViews.viewCount) AS totalViewCount, DATE_FORMAT(tempViews.dateCreated, '%Y-%m-%d') AS dateCreated FROM tempViews
        GROUP BY DATE(tempViews.dateCreated)
        ORDER BY tempViews.dateCreated DESC;



    END IF;
END$$
DELIMITER ;
