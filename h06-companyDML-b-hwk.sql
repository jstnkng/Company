
-- File: companyDML-b-solution  
-- SQL/DML HOMEWORK (on the COMPANY database)
/*
Every query is worth 2 point. There is no partial credit for a
partially working query - think of this hwk as a large program and each query is a small part of the program.
--
IMPORTANT SPECIFICATIONS
--
(A)
-- Download the script file company.sql and use it to create your COMPANY database.
-- Dowlnoad the file companyDBinstance.pdf; it is provided for your convenience when checking the results of your queries.
(B)
Implement the queries below by ***editing this file*** to include
your name and your SQL code in the indicated places.   
--
(C)
IMPORTANT:
-- Don't use views
-- Don't use inline queries in the FROM clause - see our class notes.
--
(D)
After you have written the SQL code in the appropriate places:
** Run this file (from the command line in sqlplus).
** Print the resulting spooled file (companyDML-b.out) and submit the printout in class on the due date.
--
**** Note: you can use Apex to develop the individual queries. However, you ***MUST*** run this file from the command line as just explained above and then submit a printout of the spooled file. Submitting a printout of the webpage resulting from Apex will *NOT* be accepted.
--
*/
-- Please don't remove the SET ECHO command below.
SPOOL companyDML-b.out
SET ECHO ON
-- ------------------------------------------------------------
-- 
-- Name: < Justin King >
--
-- -------------------------------------------------------------
--
-- NULL AND SUBSTRINGS -------------------------------
--
/*(10B)
Find the ssn and last name of every employee whose ssn contains two consecutive 8's, and has a supervisor. Sort the results by ssn.
*/
SELECT Ssn, Lname From EMPLOYEE WHERE Ssn LIKE '%88%'  and Super_ssn is not NULL;
--
-- JOINING 3 TABLES ------------------------------
-- 
/*(11B)
For every employee who works for more than 20 hours on any project that is controlled by the research department: Find the ssn, project number,  and number of hours. Sort the results by ssn.
*/
SELECT Essn, Pno, Hours FROM WORKS_ON w, PROJECT p WHERE Hours > 20 and w.Pno = p.Pnumber and p.Dnum = 4 ORDER BY e.Ssn;
--
-- JOINING 3 TABLES ---------------------------
--
/*(12B)
Write a query that consists of one block only.
For every employee who works less than 10 hours on any project that is controlled by the department he works for: Find the employee's lname, his department number, project number, the number of the department controlling it, and the number of hours he works on that project. Sort the results by lname.
*/
SELECT e.Lname, e.Ssn, w.Pno, p.Dnum, w.Hours FROM EMPLOYEE e, WORKS_ON w, PROJECT p WHERE e.Ssn=w.Essn AND w.Pno=p.Pnumber AND w.Hours < 10 ORDER BY e.Lname; 
--
-- JOINING 4 TABLES -------------------------
--
/*(13B)
For every employee who works on any project that is located in Houston: Find the employees ssn and lname, and the names of his/her dependent(s) and their relationship(s) to the employee. Notice that there will be one row per qualyfing dependent. Sort the results by employee lname.
*/
SELECT DISTINCT e.Ssn, e.Lname, d.Dependent_name, d.Relationship FROM EMPLOYEE e, DEPENDENT d, PROJECT p, WORKS_ON w WHERE e.Ssn=w.Essn AND e.Ssn = d.Essn AND w.Pno = p.Pnumber AND p.Plocation = 'Houston' ORDER BY e.Lname;
--
-- SELF JOIN -------------------------------------------
-- 
/*(14B)
Write a query that consists of one block only.
For every employee who works for a department that is different from his supervisor's department: Find his ssn, lname, department number; and his supervisor's ssn, lname, and department number. Sort the results by ssn.  
*/
SELECT e.Ssn, e.Lname, e.Dno, s.Ssn, s.Lname, s.Dno  FROM EMPLOYEE e, EMPLOYEE s WHERE e.Dno <> s.Dno AND e.Super_ssn =  s.Ssn  ORDER BY e.Ssn;
--
-- USING MORE THAN ONE RANGE VARIABLE ON ONE TABLE -------------------
--
/*(15B)
Find pairs of employee lname's such that the two employees in the pair work on the same project for the same number of hours. List every pair once only. Sort the result by the lname in the left column in the result. 
*/
SELECT E1.Lname, E2.Lname FROM EMPLOYEE E1, EMPLOYEE E2, WORKS_ON W1, WORKS_ON W2 WHERE E1.Ssn = W1.Essn AND E2.Ssn = W2.Essn AND W1.Pno = W2.Pno AND W1.Hours = W2.Hours And E1.Ssn > E2.SSn ORDER BY E1.Ssn;
--
/*(16B)
For every employee who has more than one dependent: Find the ssn, lname, and number of dependents. Sort the result by lname
*/
SELECT e.Ssn, E.lname, COUNT(*) FROM EMPLOYEE e, DEPENDENT d WHERE e.Ssn = d.Essn GROUP BY e.Ssn, e.Lname HAVING COUNT(*) > 1 ORDER BY e.Lname;
-- 
/*(17B)
For every project that has more than 2 employees working on and the total hours worked on it is less than 40: Find the project number, project name, number of employees working on it, and the total number of hours worked by all employees on that project. Sort the results by project number.
*/
SELECT p.Pnumber, p.Pname, COUNT(*), SUM (w.Hours) FROM WORKS_ON w, PROJECT p WHERE w.Pno = p.Pnumber GROUP BY p.Pnumber, p.Pname HAVING COUNT(*) > 2 AND SUM(w.Hours) < 48 ORDER BY p.Pnumber;
--
-- CORRELATED SUBQUERY --------------------------------
--
/*(18B)
For every employee whose salary is above the average salary in his department: Find the dno, ssn, lname, and salary. Sort the results by department number.
*/
SELECT Dno, Ssn, Lname, Salary FROM EMPLOYEE e WHERE Salary > (SELECT AVG(Salary) FROM EMPLOYEE e2 WHERE e2.Dno = e.Dno);
--
-- CORRELATED SUBQUERY -------------------------------
--
/*(19B)
For every employee who works for the research department but does not work on any one project for more than 20 hours: Find the ssn and lname. Sort the results by lname
*/
SELECT e.Ssn, e.Lname FROM EMPLOYEE e, DEPARTMENT d WHERE e.Dno = d.Dnumber AND d.Dname = 'Research' AND E.Ssn NOT IN
	(SELECT w.Essn FROM WORKS_ON w WHERE e.Ssn = w.Essn AND w.Hours > 20) ORDER BY e.Lname;
--
-- DIVISION ---------------------------------------------
--
/*(20B) Hint: This is a DIVISION query
For every employee who works on every project that is controlled by department 4: Find the ssn and lname. Sort the results by lname
*/
SELECT e.Ssn, e.Lname FROM EMPLOYEE e WHERE NOT EXISTS(
	(SELECT p.Pnumber FROM PROJECT p WHERE p.Dnum = 4) MINUS (SELECT w.Pno FROM WORKS_ON w WHERE e.Ssn = w.Essn)) ORDER BY e.Lname;
--
SET ECHO OFF
SPOOL OFF


