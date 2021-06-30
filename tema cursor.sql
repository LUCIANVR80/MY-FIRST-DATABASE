USE company;

DELIMITER $
CREATE PROCEDURE loc_angajat5(IN var_angajat INT,OUT rezultat VARCHAR(100))
BEGIN

DECLARE var_final INT DEFAULT 0;
DECLARE var_salariu DOUBLE;
DECLARE var_departament VARCHAR(30);
DECLARE var_pozitie INT DEFAULT 1;
DECLARE mesaj_eroare VARCHAR(30);
SELECT DEPARTMENT_NAME INTO var_departament FROM departments;


BEGIN 

DECLARE  Cursor1 CURSOR FOR
SELECT a.EMPLOYEE_ID,a.SALARY,b.DEPARTMENT_NAME FROM employees a
                 JOIN departments b
                 ON a.DEPARTMENT_ID=b.DEPARTMENT_ID;
                 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final=1;

OPEN Cursor1;
                          

IF ( EXISTS ( SELECT * FROM EMPLOYEES where EMPLOYEE_ID=var_angajat ) )  THEN

              FETCH Cursor1 INTO var_angajat,var_salariu,var_departament;


ELSE SET mesaj_eroare='Angajat inexistent';
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT=mesaj_eroare;


END IF;

 loop1: LOOP

 IF var_final=1 THEN
         LEAVE loop1;
END IF;

IF var_departament=DEPARTMENT_NAME THEN
       LEAVE loop1;
ELSE
       SET var_pozitie:=var_pozitie+1;

END IF;
END LOOP loop1;

CLOSE Cursor1;

SET rezultat:=CONCAT('Angajatul ',var_angajat,'se afla pe locul',var_pozitie,' in topul salariilor din departamentul ',var_departament);

END;
END $

DROP PROCEDURE loc_angajat2;

CALL loc_angajat5(100,@var1);
DROP PROCEDURE loc_angajat3;