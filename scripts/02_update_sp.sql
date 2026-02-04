USE appdb;

DROP PROCEDURE IF EXISTS get_user;

DELIMITER //
CREATE PROCEDURE get_user()
BEGIN
    SELECT 'Version 2' AS version;
END;
//
DELIMITER ;
