 -- 1
SELECT min(sal), avg(sal)::numeric(6, 2), max(sal), sum(sal)
FROM emp;
-- 2
SELECT count(empno)
FROM emp
WHERE comm NOTNULL
  AND comm <> 0;
-- 3
SELECT deptno, min(sal)
FROM emp
GROUP BY deptno
HAVING min(sal) > 1000;
-- 4
SELECT min(minsal)
FROM (SELECT deptno, avg(sal + coalesce(comm, 0)) as minsal FROM emp GROUP BY deptno) sal;
-- 5
SELECT empno, ename
FROM emp
WHERE mgr = (SELECT mgr FROM emp WHERE empno = 7900);
-- 6
SELECT empno, ename, sal
FROM emp
WHERE sal > (SELECT avg(sal) FROM emp);
-- 7
SELECT e.empno, e.deptno, e.sal
FROM emp e
WHERE e.deptno IN (SELECT deptno FROM emp WHERE comm NOTNULL AND comm <> 0)
  AND e.sal IN (SELECT sal FROM emp WHERE comm NOTNULL AND comm <> 0);
-- 8
SELECT e.empno, e.deptno, e.sal
FROM emp e
WHERE e.deptno IN (SELECT deptno FROM emp WHERE comm NOTNULL AND comm <> 0)
   OR e.sal IN (SELECT sal FROM emp WHERE comm NOTNULL AND comm <> 0);
-- 9
SELECT empno, ename
FROM emp
WHERE sal > (SELECT min(sal) FROM emp WHERE job = 'CLERK');
-- 10
SELECT count(empno)
FROM emp
       FULL OUTER JOIN dept d on emp.deptno = d.deptno
WHERE d.loc = 'DALLAS';
-- 11
SELECT count(DISTINCT mgr)
FROM emp;
-- 12
WITH RECURSIVE r AS (
  SELECT ename,
         empno,
         mgr,
         1  AS level,
         '' AS managers
  FROM emp
  WHERE mgr ISNULL
  UNION
  SELECT emp.ename, emp.empno, emp.mgr, r.level + 1 AS level, r.ename || '/' || r.managers AS managers
  FROM emp
         JOIN r ON emp.mgr = r.empno)
SELECT ename, level, managers
FROM r;
-- 13
WITH RECURSIVE r AS (
  SELECT ename,
         d.deptno,
         d.dname,
         empno,
         mgr,
         1  AS level,
         '' AS managers
  FROM emp
         INNER JOIN dept d on emp.deptno = d.deptno
  WHERE mgr ISNULL
  UNION
  SELECT emp.ename,
         d2.deptno,
         d2.dname,
         emp.empno,
         emp.mgr,
         r.level + 1                  AS level,
         r.ename || '/' || r.managers AS managers
  FROM emp
         JOIN r ON emp.mgr = r.empno
         INNER JOIN dept d2 on emp.deptno = d2.deptno)
SELECT ename, deptno, dname, level, managers
FROM r;
-- 14
WITH RECURSIVE r AS (
  SELECT ename,
         d.deptno,
         d.dname,
         empno,
         mgr,
         1  AS level,
         '' AS managers
  FROM emp
         INNER JOIN dept d on emp.deptno = d.deptno
  WHERE mgr ISNULL
  UNION
  SELECT emp.ename,
         d2.deptno,
         d2.dname,
         emp.empno,
         emp.mgr,
         r.level + 1                  AS level,
         r.ename || '/' || r.managers AS managers
  FROM emp
         JOIN r ON emp.mgr = r.empno
         INNER JOIN dept d2 on emp.deptno = d2.deptno)
SELECT ename, deptno, dname, level, managers
FROM r
ORDER BY level, dname;
-- 15
-- ? like 12?
