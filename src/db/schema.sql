--
-- PostgreSQL database dump
--

-- Dumped from database version 10.6 (Ubuntu 10.6-0ubuntu0.18.10.1)
-- Dumped by pg_dump version 10.6 (Ubuntu 10.6-0ubuntu0.18.10.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: dblabs; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA dblabs;


ALTER SCHEMA dblabs OWNER TO postgres;

--
-- Name: create_deps(integer, character varying, character varying); Type: FUNCTION; Schema: dblabs; Owner: postgres
--

CREATE FUNCTION dblabs.create_deps(count integer, city character varying, dep character varying) RETURNS interval
    LANGUAGE plpgsql
    AS $$
DECLARE
  start_time    TIMESTAMP := clock_timestamp();
  next_val BIGINT;
BEGIN
  FOR i IN 1..count
    LOOP
      SELECT INTO next_val nextval('dept_seq');
      INSERT INTO dept (deptno, dname, loc) VALUES (next_val, dep || i, city || i);
    END LOOP;
    RETURN age(clock_timestamp(), start_time);
END;
$$;


ALTER FUNCTION dblabs.create_deps(count integer, city character varying, dep character varying) OWNER TO postgres;

--
-- Name: raise_salary(integer, date); Type: FUNCTION; Schema: dblabs; Owner: postgres
--

CREATE FUNCTION dblabs.raise_salary(emp_id integer, curr_date date) RETURNS interval
    LANGUAGE plpgsql
    AS $$
  DECLARE
    start_time TIMESTAMP := clock_timestamp();
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
$$;


ALTER FUNCTION dblabs.raise_salary(emp_id integer, curr_date date) OWNER TO postgres;

--
-- Name: raise_salary_5k(); Type: FUNCTION; Schema: dblabs; Owner: postgres
--

CREATE FUNCTION dblabs.raise_salary_5k() RETURNS integer
    LANGUAGE plpgsql
    AS $$
  DECLARE
    count INTEGER := 0;
    curs CURSOR FOR SELECT * FROM emp WHERE extract(YEARS FROM age(clock_timestamp(), emp.hiredate)) >= 10;
  BEGIN
    FOR employee IN curs LOOP
      count := count + 1;
      UPDATE emp SET sal = (employee.sal + 5000) WHERE CURRENT OF curs;
    END LOOP;
    RETURN count;
  END;
  $$;


ALTER FUNCTION dblabs.raise_salary_5k() OWNER TO postgres;

--
-- Name: set_salary(numeric, integer); Type: FUNCTION; Schema: dblabs; Owner: postgres
--

CREATE FUNCTION dblabs.set_salary(new_sal numeric, emp_id integer) RETURNS interval
    LANGUAGE plpgsql
    AS $$
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

$$;


ALTER FUNCTION dblabs.set_salary(new_sal numeric, emp_id integer) OWNER TO postgres;

--
-- Name: trigger_audit(); Type: FUNCTION; Schema: dblabs; Owner: postgres
--

CREATE FUNCTION dblabs.trigger_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO emp_change(change_name, change_data, change_salary) VALUES (tg_op, now(), old.sal);
  ELSE
    INSERT INTO emp_change(change_name, change_data, change_salary) VALUES (tg_op, now(), new.sal);
  END IF;
  RETURN new;
END;
$$;


ALTER FUNCTION dblabs.trigger_audit() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: dept; Type: TABLE; Schema: dblabs; Owner: postgres
--

CREATE TABLE dblabs.dept (
    deptno integer NOT NULL,
    dname character varying(14),
    loc character varying(13)
);


ALTER TABLE dblabs.dept OWNER TO postgres;

--
-- Name: dept_deptno_seq; Type: SEQUENCE; Schema: dblabs; Owner: postgres
--

CREATE SEQUENCE dblabs.dept_deptno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dblabs.dept_deptno_seq OWNER TO postgres;

--
-- Name: dept_deptno_seq; Type: SEQUENCE OWNED BY; Schema: dblabs; Owner: postgres
--

ALTER SEQUENCE dblabs.dept_deptno_seq OWNED BY dblabs.dept.deptno;


--
-- Name: dept_seq; Type: SEQUENCE; Schema: dblabs; Owner: postgres
--

CREATE SEQUENCE dblabs.dept_seq
    START WITH 100
    INCREMENT BY 10
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dblabs.dept_seq OWNER TO postgres;

--
-- Name: emp; Type: TABLE; Schema: dblabs; Owner: postgres
--

CREATE TABLE dblabs.emp (
    empno integer NOT NULL,
    ename character varying(10),
    job character varying(9),
    mgr integer,
    hiredate date,
    sal numeric(7,2),
    comm numeric(7,2),
    deptno integer
);


ALTER TABLE dblabs.emp OWNER TO postgres;

--
-- Name: emp_change; Type: TABLE; Schema: dblabs; Owner: postgres
--

CREATE TABLE dblabs.emp_change (
    id integer NOT NULL,
    change_name character varying(255),
    change_data timestamp without time zone,
    change_salary numeric
);


ALTER TABLE dblabs.emp_change OWNER TO postgres;

--
-- Name: emp_change_id_seq; Type: SEQUENCE; Schema: dblabs; Owner: postgres
--

CREATE SEQUENCE dblabs.emp_change_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dblabs.emp_change_id_seq OWNER TO postgres;

--
-- Name: emp_change_id_seq; Type: SEQUENCE OWNED BY; Schema: dblabs; Owner: postgres
--

ALTER SEQUENCE dblabs.emp_change_id_seq OWNED BY dblabs.emp_change.id;


--
-- Name: emp_empno_seq; Type: SEQUENCE; Schema: dblabs; Owner: postgres
--

CREATE SEQUENCE dblabs.emp_empno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dblabs.emp_empno_seq OWNER TO postgres;

--
-- Name: emp_empno_seq; Type: SEQUENCE OWNED BY; Schema: dblabs; Owner: postgres
--

ALTER SEQUENCE dblabs.emp_empno_seq OWNED BY dblabs.emp.empno;


--
-- Name: salgrade; Type: TABLE; Schema: dblabs; Owner: postgres
--

CREATE TABLE dblabs.salgrade (
    grade integer NOT NULL,
    losal numeric,
    hisal numeric
);


ALTER TABLE dblabs.salgrade OWNER TO postgres;

--
-- Name: salgrade_grade_seq; Type: SEQUENCE; Schema: dblabs; Owner: postgres
--

CREATE SEQUENCE dblabs.salgrade_grade_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dblabs.salgrade_grade_seq OWNER TO postgres;

--
-- Name: salgrade_grade_seq; Type: SEQUENCE OWNED BY; Schema: dblabs; Owner: postgres
--

ALTER SEQUENCE dblabs.salgrade_grade_seq OWNED BY dblabs.salgrade.grade;


--
-- Name: dept deptno; Type: DEFAULT; Schema: dblabs; Owner: postgres
--

ALTER TABLE ONLY dblabs.dept ALTER COLUMN deptno SET DEFAULT nextval('dblabs.dept_deptno_seq'::regclass);


--
-- Name: emp empno; Type: DEFAULT; Schema: dblabs; Owner: postgres
--

ALTER TABLE ONLY dblabs.emp ALTER COLUMN empno SET DEFAULT nextval('dblabs.emp_empno_seq'::regclass);


--
-- Name: emp_change id; Type: DEFAULT; Schema: dblabs; Owner: postgres
--

ALTER TABLE ONLY dblabs.emp_change ALTER COLUMN id SET DEFAULT nextval('dblabs.emp_change_id_seq'::regclass);


--
-- Name: salgrade grade; Type: DEFAULT; Schema: dblabs; Owner: postgres
--

ALTER TABLE ONLY dblabs.salgrade ALTER COLUMN grade SET DEFAULT nextval('dblabs.salgrade_grade_seq'::regclass);


--
-- Data for Name: dept; Type: TABLE DATA; Schema: dblabs; Owner: postgres
--

INSERT INTO dblabs.dept VALUES (10, 'ACCOUNTING', 'NEWYORK');
INSERT INTO dblabs.dept VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO dblabs.dept VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO dblabs.dept VALUES (40, 'OPERATIONS', 'BOSTON');
INSERT INTO dblabs.dept VALUES (100, 'SALES1', 'MOSQVA1');
INSERT INTO dblabs.dept VALUES (110, 'SALES2', 'MOSQVA2');
INSERT INTO dblabs.dept VALUES (120, 'SALES3', 'MOSQVA3');
INSERT INTO dblabs.dept VALUES (130, 'SALES4', 'MOSQVA4');
INSERT INTO dblabs.dept VALUES (140, 'SALES5', 'MOSQVA5');
INSERT INTO dblabs.dept VALUES (150, 'SALES6', 'MOSQVA6');
INSERT INTO dblabs.dept VALUES (160, 'SALES7', 'MOSQVA7');
INSERT INTO dblabs.dept VALUES (170, 'SALES8', 'MOSQVA8');
INSERT INTO dblabs.dept VALUES (180, 'SALES9', 'MOSQVA9');
INSERT INTO dblabs.dept VALUES (190, 'SALES10', 'MOSQVA10');
INSERT INTO dblabs.dept VALUES (200, 'dep1', 'city1');
INSERT INTO dblabs.dept VALUES (210, 'dep2', 'city2');
INSERT INTO dblabs.dept VALUES (220, 'dep3', 'city3');
INSERT INTO dblabs.dept VALUES (230, 'dep4', 'city4');
INSERT INTO dblabs.dept VALUES (240, 'dep5', 'city5');
INSERT INTO dblabs.dept VALUES (250, 'dep6', 'city6');
INSERT INTO dblabs.dept VALUES (260, 'dep7', 'city7');
INSERT INTO dblabs.dept VALUES (270, 'dep8', 'city8');
INSERT INTO dblabs.dept VALUES (280, 'dep9', 'city9');
INSERT INTO dblabs.dept VALUES (290, 'dep10', 'city10');


--
-- Data for Name: emp; Type: TABLE DATA; Schema: dblabs; Owner: postgres
--

INSERT INTO dblabs.emp VALUES (7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 11600.00, 300.00, 30);
INSERT INTO dblabs.emp VALUES (7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 22850.00, NULL, 30);
INSERT INTO dblabs.emp VALUES (7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 26300.00, NULL, 10);
INSERT INTO dblabs.emp VALUES (7369, 'SMITH', 'CLERK', 7902, '1980-12-17', 34999.00, NULL, 20);
INSERT INTO dblabs.emp VALUES (7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 31250.00, 1400.00, 30);
INSERT INTO dblabs.emp VALUES (7876, 'ADAMS', 'CLERK', 7788, '1983-01-12', 31100.00, NULL, 20);
INSERT INTO dblabs.emp VALUES (7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 54196.75, NULL, 30);
INSERT INTO dblabs.emp VALUES (7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 31250.00, 500.00, 30);
INSERT INTO dblabs.emp VALUES (7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 42450.00, NULL, 10);
INSERT INTO dblabs.emp VALUES (7788, 'SCOTT', 'ANALYST', 7566, '1982-12-09', 33000.00, NULL, 20);
INSERT INTO dblabs.emp VALUES (7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 33000.00, NULL, 20);
INSERT INTO dblabs.emp VALUES (7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 31500.00, 0.00, 30);
INSERT INTO dblabs.emp VALUES (7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 42975.00, NULL, 20);
INSERT INTO dblabs.emp VALUES (7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 45000.00, NULL, 10);


--
-- Data for Name: emp_change; Type: TABLE DATA; Schema: dblabs; Owner: postgres
--

INSERT INTO dblabs.emp_change VALUES (6, 'INSERT', '2019-03-14 09:49:48.317417', 1.00);
INSERT INTO dblabs.emp_change VALUES (7, 'INSERT', '2019-03-14 09:49:48.317417', 2.00);
INSERT INTO dblabs.emp_change VALUES (8, 'INSERT', '2019-03-14 09:49:48.317417', 3.00);
INSERT INTO dblabs.emp_change VALUES (9, 'UPDATE', '2019-03-14 09:49:48.317417', 555.00);
INSERT INTO dblabs.emp_change VALUES (10, 'DELETE', '2019-03-14 09:49:48.317417', 3.00);
INSERT INTO dblabs.emp_change VALUES (11, 'DELETE', '2019-03-14 09:50:27.514217', 2.00);
INSERT INTO dblabs.emp_change VALUES (12, 'DELETE', '2019-03-14 09:50:28.91188', 555.00);


--
-- Data for Name: salgrade; Type: TABLE DATA; Schema: dblabs; Owner: postgres
--

INSERT INTO dblabs.salgrade VALUES (1, 700, 1200);
INSERT INTO dblabs.salgrade VALUES (2, 1201, 1400);
INSERT INTO dblabs.salgrade VALUES (3, 1401, 2000);
INSERT INTO dblabs.salgrade VALUES (4, 2001, 3000);
INSERT INTO dblabs.salgrade VALUES (5, 3001, 9999);


--
-- Name: dept_deptno_seq; Type: SEQUENCE SET; Schema: dblabs; Owner: postgres
--

SELECT pg_catalog.setval('dblabs.dept_deptno_seq', 1, false);


--
-- Name: dept_seq; Type: SEQUENCE SET; Schema: dblabs; Owner: postgres
--

SELECT pg_catalog.setval('dblabs.dept_seq', 290, true);


--
-- Name: emp_change_id_seq; Type: SEQUENCE SET; Schema: dblabs; Owner: postgres
--

SELECT pg_catalog.setval('dblabs.emp_change_id_seq', 12, true);


--
-- Name: emp_empno_seq; Type: SEQUENCE SET; Schema: dblabs; Owner: postgres
--

SELECT pg_catalog.setval('dblabs.emp_empno_seq', 1, false);


--
-- Name: salgrade_grade_seq; Type: SEQUENCE SET; Schema: dblabs; Owner: postgres
--

SELECT pg_catalog.setval('dblabs.salgrade_grade_seq', 1, false);


--
-- Name: dept dept_pk; Type: CONSTRAINT; Schema: dblabs; Owner: postgres
--

ALTER TABLE ONLY dblabs.dept
    ADD CONSTRAINT dept_pk PRIMARY KEY (deptno);


--
-- Name: emp_change emp_change_pk; Type: CONSTRAINT; Schema: dblabs; Owner: postgres
--

ALTER TABLE ONLY dblabs.emp_change
    ADD CONSTRAINT emp_change_pk PRIMARY KEY (id);


--
-- Name: emp emp_pk; Type: CONSTRAINT; Schema: dblabs; Owner: postgres
--

ALTER TABLE ONLY dblabs.emp
    ADD CONSTRAINT emp_pk PRIMARY KEY (empno);


--
-- Name: salgrade salgrade_pk; Type: CONSTRAINT; Schema: dblabs; Owner: postgres
--

ALTER TABLE ONLY dblabs.salgrade
    ADD CONSTRAINT salgrade_pk PRIMARY KEY (grade);


--
-- Name: emp trigger_audit; Type: TRIGGER; Schema: dblabs; Owner: postgres
--

CREATE TRIGGER trigger_audit AFTER INSERT OR DELETE OR UPDATE ON dblabs.emp FOR EACH ROW EXECUTE PROCEDURE dblabs.trigger_audit();


--
-- Name: emp emp_dept_deptno_fk; Type: FK CONSTRAINT; Schema: dblabs; Owner: postgres
--

ALTER TABLE ONLY dblabs.emp
    ADD CONSTRAINT emp_dept_deptno_fk FOREIGN KEY (deptno) REFERENCES dblabs.dept(deptno);


--
-- PostgreSQL database dump complete
--

