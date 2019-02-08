-- Instructions - Part 2
-- Using your gwsis database, develop a stored procedure that will drop an individual student's enrollment from a class.  Be sure to refer to the existing stored procedures, enroll_studentand terminate_all_class_enrollment in the gwsis database for reference.
-- The procedure should be called terminate_student_enrollment and should accept the course code, section, student ID, and effective date of the withdrawal as parameters.

Use gwsis;

 DELIMITER //
 CREATE PROCEDURE terminate_student_enrollment(
	CourseCode_in varchar(45),
	Section_in varchar(45),
	StudentID_in varchar(45),
	Effective_Withdrawl_Date_in date)
   BEGIN
   DECLARE ID_Student_out int;
   DECLARE ID_Class_out int;
   SET ID_Student_out = (SELECT ID_Student FROM Student WHERE StudentID = StudentID_in);
   SELECT
	ID_Class
   INTO
	ID_Class_out
   FROM
	Class c
	INNER JOIN COURSE co
	ON c.ID_Course = co.ID_Course
   WHERE
	CourseCode = CourseCode_in
	AND Section = Section_in;
   
   INSERT INTO ClassParticipant(ID_Student, ID_Class, EndDate)
   VALUES (ID_Student_out, ID_Class_out, Effective_Withdrawl_Date_in);

   END //
 DELIMITER ;

Call terminate_student_enrollment('BC-DATAVIZ', 'GWARL201811DATA3', '25007528', '2019-02-08');

