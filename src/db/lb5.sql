-- task 1.1

CREATE OR REPLACE FUNCTION set_salary(new_sal NUMERIC(7, 2), emp_id INTEGER) RETURNS INTERVAL AS
$$
DECLARE
  start_time TIMESTAMP;
BEGIN
  start_time := clock_timestamp();
  IF (SELECT empno FROM emp WHERE empno = emp_id) IS NULL THEN
    RAISE EXCEPTION 'there is no employee with id %', emp_id;
  END IF;
  UPDATE emp SET sal = new_sal WHERE empno = emp_id;
  RETURN age(clock_timestamp(), start_time);
END;

$$ LANGUAGE plpgsql;

SELECT set_salary(12345.00, 7900);

--DROP FUNCTION set_salary(new_sal NUMERIC, emp_id INTEGER);

-- task 1.2

CREATE OR REPLACE FUNCTION raise_salary(emp_id INTEGER, curr_date DATE) RETURNS INTERVAL AS
$$
DECLARE
  start_time    TIMESTAMP := clock_timestamp();
  employee      emp%ROWTYPE;
  years_between INTEGER;
BEGIN
  SELECT * INTO employee FROM emp WHERE empno = emp_id;
  IF employee ISNULL THEN
    RAISE EXCEPTION 'there is no employee with id %', emp_id;
  END IF;
  years_between = extract(years FROM age(curr_date, employee.hiredate));
  IF years_between < 10 THEN
    UPDATE emp SET sal = employee.sal * 1.05 WHERE empno = employee.empno;
  ELSEIF years_between < 15 THEN
    UPDATE emp SET sal = employee.sal * 1.10 WHERE empno = employee.empno;
  ELSE
    UPDATE emp SET sal = employee.sal * 1.15 WHERE empno = employee.empno;
  END IF;
  RETURN age(clock_timestamp(), start_time);
END;
$$ LANGUAGE plpgsql;

SELECT raise_salary(7900, '2000-10-10');

-- task 1.3

CREATE OR REPLACE FUNCTION create_deps(count INTEGER, city VARCHAR(13), dep VARCHAR(14)) RETURNS INTERVAL AS
$$
DECLARE
  start_time TIMESTAMP := clock_timestamp();
  next_val   BIGINT;
BEGIN
  FOR i IN 1..count
    LOOP
      SELECT INTO next_val nextval('dept_seq');
      INSERT INTO dept (deptno, dname, loc) VALUES (next_val, dep || i, city || i);
    END LOOP;
  RETURN age(clock_timestamp(), start_time);
END;
$$ LANGUAGE plpgsql;

SELECT create_deps(10, 'city', 'dep');

-- task 2

SELECT 'IM ALREADY USE ROWTYPE IN FUNCTION' AS MSG;

-- task 3

CREATE OR REPLACE FUNCTION raise_salary_5k() RETURNS INTEGER AS
$$
DECLARE
  count INTEGER := 0;
  curs CURSOR FOR SELECT *
                  FROM emp
                  WHERE extract(YEARS FROM age(clock_timestamp(), emp.hiredate)) >= 10;
BEGIN
  FOR employee IN curs
    LOOP
      count := count + 1;
      UPDATE emp SET sal = (employee.sal + 5000) WHERE CURRENT OF curs;
    END LOOP;
  RETURN count;
END;
$$ LANGUAGE plpgsql;

SELECT raise_salary_5k();

-- task 4

SELECT 'THERE IS NO PACKAGES IN POSGTRESQL' AS MSG;

-- task 5

CREATE OR REPLACE FUNCTION trigger_audit() RETURNS TRIGGER AS
$trigger_audit$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO emp_change(change_name, change_data, change_salary) VALUES (tg_op, now(), old.sal);
  ELSE
    INSERT INTO emp_change(change_name, change_data, change_salary) VALUES (tg_op, now(), new.sal);
  END IF;
  RETURN new;
END;
$trigger_audit$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_audit
  AFTER INSERT OR UPDATE OR DELETE
  ON emp
  FOR EACH ROW
EXECUTE PROCEDURE trigger_audit();

DO LANGUAGE plpgsql $$
  BEGIN

    INSERT INTO emp VALUES (9999, 'testname', 'testjob', '1111', '2001-10-10', 1.00, 10.00, 10);
    INSERT INTO emp VALUES (9998, 'testname2', 'testjob2', '2222', '2002-10-10', 2.00, 20.00, 20);
    INSERT INTO emp VALUES (9997, 'testname3', 'testjob3', '3333', '2003-10-10', 3.00, 30.00, 40);

    UPDATE emp SET sal = 555 WHERE empno = 9999;

    DELETE FROM emp WHERE empno = 9997;
    DELETE FROM emp WHERE empno = 9998;
    DELETE FROM emp WHERE empno = 9999;

  END;
  $$;


--DROP TRIGGER trigger_audit on emp;
--DROP FUNCTION trigger_audit();


 
