DO LANGUAGE plpgsql $$
  DECLARE
    emp_id  INTEGER       := 7369;
    new_sal NUMERIC(7, 2) := 99999.00;
  BEGIN
    UPDATE emp SET sal = new_sal WHERE empno = emp_id;
  END;
  $$;

--------------------------------------------------

DO LANGUAGE plpgsql $$
  DECLARE
    emp_id        INTEGER := 7900;
    employee      emp%ROWTYPE;
    curr_date     DATE    := '2000-12-20';
    years_between INTEGER;
  BEGIN
    SELECT * INTO employee FROM emp WHERE empno = emp_id;
    years_between = extract(years FROM age(curr_date, employee.hiredate));
    IF years_between < 10 THEN
      UPDATE emp SET sal = employee.sal * 1.05 WHERE empno = employee.empno;
    ELSEIF years_between < 15 THEN
      UPDATE emp SET sal = employee.sal * 1.10 WHERE empno = employee.empno;
    ELSE
      UPDATE emp SET sal = employee.sal * 1.15 WHERE empno = employee.empno;
    END IF;
  END;
  $$;

----------------------------------------------------

CREATE SEQUENCE dept_seq INCREMENT BY 10 START WITH 100;

DO LANGUAGE plpgsql $$
  DECLARE
    count    INTEGER     := 10;
    next_val BIGINT;
    city     VARCHAR(10) := 'MOSQVA';
    dep      VARCHAR(9)  := 'SALES';
  BEGIN
    FOR i IN 1..count
      LOOP
        SELECT INTO next_val nextval('dept_seq');
        INSERT INTO dept (deptno, dname, loc) VALUES (next_val, dep || i, city || i);
      END LOOP;
  END;
  $$

 
