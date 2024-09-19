# 1) Create a table named teachers and insert 8 rows

CREATE TABLE teachers (
id INT PRIMARY KEY, 
name VARCHAR(50), 
subject VARCHAR(50), 
experience INT,
salary DECIMAL(10,2)
);

CREATE TABLE teachers (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    subject VARCHAR(50),
    experience INT,
    salary DECIMAL(10,2)
);

INSERT INTO teachers (id, name, subject, experience, salary) VALUES
(1, 'John Doe', 'Math', 5, 40000),
(2, 'Jane Smith', 'English', 8, 42000),
(3, 'Mark Lee', 'Science', 10, 45000),
(4, 'Emily Davis', 'History', 2, 35000),
(5, 'Paul Brown', 'Math', 12, 50000),
(6, 'Anna Johnson', 'English', 4, 37000),
(7, 'Michael King', 'Science', 6, 41000),
(8, 'Lucy White', 'History', 15, 52000);

SELECT * FROM teachers;

# 2) Create a before insert trigger named before_insert_teacher that will raise an error “salary cannot be negative” if the salary inserted to the table is less than zero. 

DELIMITER $$

CREATE TRIGGER before_insert_teacher
BEFORE INSERT ON teachers
FOR EACH ROW
BEGIN
	IF NEW.salary < 0 THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'salary cannot be negative';
	END IF;
END $$

DELIMITER ;


# INSERT INTO teachers (id, name, subject, experience, salary) VALUES(9, 'Sibin Francis', 'Physics', 7, -1000);  
#  SALARY CANNOT BE NEGATIVE

# 3) Create an after insert trigger named after_insert_teacher that inserts a row with teacher_id,action, 
	#timestamp to a table called teacher_log when a new entry gets inserted to the teacher table. 
	#tecaher_id -> column of teacher table, action -> the trigger action, timestamp -> time at which the new row has got inserted. 

CREATE TABLE teacher_log (
log_id INT AUTO_INCREMENT PRIMARY KEY,
teacher_id INT,
action VARCHAR(50),
timestamp DATETIME
);

DELIMITER $$

CREATE TRIGGER after_insert_teacher
AFTER INSERT ON teachers
FOR EACH ROW
BEGIN
	INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (NEW.id, 'INSERT', NOW());
END $$

DELIMITER ;


INSERT INTO teachers (id, name, subject, experience, salary)  VALUES (9, 'Sibin Francis', 'Physics', 7, 85000);

SELECT * FROM teacher_log;

# 4)  Create a before delete trigger that will raise an error when you try to delete a row that has experience greater than 10 years. 

DELIMITER $$

CREATE TRIGGER before_delete_teacher
BEFORE DELETE ON teachers
FOR EACH ROW
BEGIN
    IF OLD.experience > 10 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cannot delete teacher with more than 10 years of experience';
    END IF;
END $$

DELIMITER ;


DELETE FROM teachers WHERE id = 5;

# 5) Create an after delete trigger that will insert a row to teacher_log table when that row is deleted from teacher table.

DELIMITER $$

CREATE TRIGGER after_delete_teacher
AFTER DELETE ON teachers
FOR EACH ROW
BEGIN
    INSERT INTO teacher_log (teacher_id, action, timestamp)
    VALUES (OLD.id, 'DELETE', NOW());
END$$

DELIMITER ;


DELETE FROM teachers WHERE id = 7;

SELECT * FROM teacher_log;
