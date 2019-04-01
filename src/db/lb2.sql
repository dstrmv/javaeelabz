-- 1
SELECT * FROM dept;
-- 2
SELECT ename||', '||job AS "Employee Details", sal*12 as "Salary" FROM emp;
-- 3
SELECT ename, sal FROM emp WHERE sal NOT BETWEEN 1500 AND 2850 ORDER BY ename;
-- 4
SELECT ename, job, empno FROM emp WHERE empno IN (1111, 2222, 3333);
-- 5
SELECT ename FROM emp WHERE ename LIKE '_A%';
-- 6
SELECT ename, '*'||sal as sal, empno FROM emp WHERE length(ename) < 6;
-- 7
SELECT ename, extract(YEAR FROM age(current_date, hiredate))*12 + extract(MONTH FROM age(current_date, hiredate)) as months FROM emp ORDER BY months DESC;
-- 8
SELECT ename, sal, comm, sal*12+coalesce(comm, 0) as year FROM emp;
-- 9
SELECT ename, coalesce(cast(comm AS varchar(10)), 'No Commissions') as com FROM emp;
-- 10
SELECT DISTINCT job FROM emp WHERE deptno = 30;
-- 11
SELECT ename, job, e.deptno FROM emp e INNER JOIN dept d on e.deptno = d.deptno WHERE d.loc = 'DALLAS';
-- 12
SELECT e.ename AS employee, e.empno AS employee_num, ee.ename AS manager, ee.empno AS manager_num FROM emp e INNER JOIN emp ee ON e.mgr = ee.empno;
-- 13
SELECT d.deptno, dname, loc, e.empno, e.ename FROM dept d LEFT OUTER JOIN emp e on d.deptno = e.deptno ORDER BY d.deptno;
-- 14
SELECT e.ename, d.dname, e.sal, s.grade FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal INNER JOIN dept d ON e.deptno = d.deptno;
-- 15
SELECT ename FROM emp WHERE ename LIKE '_\%%';
