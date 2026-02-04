-- Stored Procedure Example
DELIMITER //
DROP PROCEDURE IF EXISTS GetEmployeeCount//
CREATE PROCEDURE GetEmployeeCount(IN dept_id INT, OUT count_out INT)
BEGIN
  SELECT COUNT(*) INTO count_out FROM employees WHERE department_id = dept_id;
END//
DELIMITER ;

-- View Example
DROP VIEW IF EXISTS EmployeeView//
CREATE VIEW EmployeeView AS
SELECT e.name, d.dept_name 
FROM employees e 
JOIN departments d ON e.department_id = d.id;

-- Function Example
DROP FUNCTION IF EXISTS CalculateBonus//
CREATE FUNCTION CalculateBonus(salary DECIMAL(10,2), performance INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE bonus DECIMAL(10,2);
  SET bonus = salary * (performance / 100);
  RETURN bonus;
END;
