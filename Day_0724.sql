/* 7월 24일 수요일 */

-- DML : insert, select, update, delete
/*
 * update 테이블명
 * set first_name = '오공'
 * where emloyee_id = 100        * where 조건절 반드시 써야 함
 */

-- 1: 오토커밋 활성화,  0: 오토커밋 비활성화
SET autocommit = 1;

USE hr;
SELECT database();



-- 1) insert into select문
SELECT *
FROM hr.employees e; 

INSERT INTO hr.employees 
(employee_id, first_name, last_name, hire_date, job_id)
VALUES
(999, '길동', '홍', '2024-07-24', 'IT_PROG');  -- 복제본에 저장

-- employee를 복사하여 새로운 테이블 emp2 만들기
CREATE TABLE hr.emp2
SELECT *
FROM hr.employees e;

SELECT *
FROM emp2;

-- 사원번호 100번인 사람의 이름 수정
UPDATE hr.emp2
SET first_name = '오공'
WHERE employee_id = 100;

SELECT*FROM hr.emp2 e;

ROLLBACK;     -- 되돌림. 단, auto-COMMIT = FALSE인 경우에만 가능

UPDATE hr.emp2
SET salary = salary * 1.1;

-- SH_CLERK인 직급을 전부 SA_REP로 수정하시오
UPDATE hr.emp2
SET JOB_ID = 'SA_REP'
where JOB_ID = 'SH_CLERK';

SELECT * FROM hr.emp2 e
where JOB_ID = 'SH_CLERK';

UPDATE hr.emp2
SET 
	first_name = 'Steven';



-- delete 문 : 레코드를 삭제
/*
 * DELETE from 테이블명
 * WHERE 조건절;
 */

SELECT *
FROM hr.emp2;

-- 커미션이 없는 직원을 삭제하시오
DELETE FROM hr.emp2 
WHERE commission_pct IS NULL;

SELECT *
FROM hr.emp2;

ROLLBACK;


-- [문제] 80번 부서의 직원들만 새로운 테이블(emp_80)로 옮기고
CREATE TABLE hr.emp_80
SELECT *
FROM hr.employees e
WHERE department_id = 80;

SELECT *
FROM hr.emp_80 e;

-- [문제] emp_80 테이블의 모든 직원의 급여를 25% 올리시오.
UPDATE hr.emp_80
SET salary = salary * 1.25;

-- insert문의 auto_increment의 사용 복습
DROP TABLE dima4.mytbl;
CREATE TABLE dima4.mytbl
(
	userid int auto_increment PRIMARY KEY
	, name varchar(30) NOT NULL
	, age int DEFAULT 0
	, joint_date datetime DEFAULT current_timestamp
	, today date DEFAULT (current_date)
	, now datetime DEFAULT (current_time)
);
DESC dima4.mytbl;

INSERT INTO dima4.mytbl
(name, age)
VALUES
('이몽룡', 20);

INSERT INTO dima4.mytbl 
(userid, name, age)
VALUES
(NULL,'김방자', 22);

SELECT*
FROM dima4.mytbl;

SELECT last_insert_id();   -- auto_increment를 사용한 마지막 값 

-- 날짜 관련 데이터 타입 테스트하기
USE dima4;

CREATE TABLE timetest
(
	col1 date
	, col2 datetime
	, col3 timestamp
	, col4 time
	, col5 year
);

DESC timetest;

INSERT INTO dima4.timetest
VALUES
(
	current_timestamp
	, current_timestamp
	, current_timestamp
	, current_timestamp
	, current_timestamp
);

SELECT * FROM dima4.timetest;


/*
 * JOIN
 * 	- 두 개의 테이블(관계가 형성되어 있는 테이블)로부터 데이터를 조회
 *	- 두 테이블은 PK, FK가 있어야 한다.
 *
 * 조인의 종류
 * 1) CROSS JOIN (= 카르테시안 조인)
 * 		A x B
 * 2) INNER JOIN (= JOIIN ON)
 * 	   : 서로 관계를 맺고 있는 둘 이상의 테이블로부터 데이터를 조회
 *     : FK값이 NULL인 경우에는 조회 대상에서 제외된다
 * 
 * ※ USING 절을 이용한 조인
 * 	  : ON 절을 USING으로 바꿈
 */

USE hr;

SELECT * FROM hr.employees e ;
SELECT * FROM hr.departments d ;

-- 1) 크로스 조인
SELECT*
FROM hr.employees e CROSS JOIN hr.departments d;    -- CROSS JOIN 생략 가능

SELECT*
FROM hr.employees e, hr.departments d; 

-- 2) Inner join : 조건절이 포함되어 PK와 FK가 같은 데이터를 조회
--    두 테이블의 조인 조건을 on절에 기재
--    조인 컬럼에 NULL을 가진 레코드는 조회대상에서 제외

SELECT *
FROM hr.employees e INNER JOIN hr.departments d 
ON e.department_id = d.department_id ;

-- [연습] 사원번호, 이름, 급여, 부서명
SELECT e.employee_id , e.first_name , e.salary , d.department_name
FROM hr.employees e INNER JOIN hr.departments d 
ON e.department_id = d.department_id ;

-- [연습] 사원번호, 이름, 급여, 부서명  =>  USING절로 수정
SELECT e.employee_id , e.first_name , e.salary , d.department_name
FROM hr.employees e INNER JOIN hr.departments d 
USING (department_id);



-- [연습] 사원번호, 이름, 급여, 부서명
-- 		사원번호로 오름차순
SELECT e.employee_id , e.first_name , e.salary , d.department_name
FROM hr.employees e INNER JOIN hr.departments d 
ON e.department_id = d.department_id
ORDER BY e.employee_id ;

-- [연습] 사원번호, 이름, 급여, 부서명    =>  USING절로 수정
-- 		사원번호로 오름차순
SELECT e.employee_id , e.first_name , e.salary , d.department_name
FROM hr.employees e INNER JOIN hr.departments d 
USING (department_id)
ORDER BY e.employee_id ;



-- [연습] 급여가 5000을 초과하는 직원의 이름과 급여, 부서명을 조회하시오
SELECT e.employee_id , e.first_name , e.salary , d.department_name
FROM hr.employees e INNER JOIN hr.departments d
ON e.department_id = d.department_id
WHERE e.salary > 5000
ORDER BY e.employee_id ;

-- [연습] 급여가 5000을 초과하는 직원의 이름과 급여, 부서명을 조회하시오  =>  USING절로
SELECT e.employee_id , e.first_name , e.salary , d.department_name
FROM hr.employees e INNER JOIN hr.departments d
USING (department_id)
WHERE e.salary > 5000
ORDER BY e.employee_id ;



-- [연습] 급여가 5000을 초과하는 직원의 이름과 급여, 부서명, 근무하는 도시를 조회하시오
-- employees(FK-depertment_id), departements(PK-department_id, FK-location_id), locations
SELECT * FROM hr.locations;
SELECT * FROM hr.departments d ;

SELECT e.first_name , e.salary , d.department_name
FROM 
	hr.employees e INNER JOIN hr.departments d
	ON e.department_id = d.department_id 
	INNER JOIN hr.locations l
	ON d.location_id = l.location_id
WHERE e.salary > 5000
ORDER BY salary DESC;

-- [연습] 급여가 5000을 초과하는 직원의 이름과 급여, 부서명, 근무하는 도시를 조회하시오   =>  USING절로
-- employees(FK-depertment_id), departements(PK-department_id, FK-location_id), locations
SELECT * FROM hr.locations;
SELECT * FROM hr.departments d ;

SELECT e.first_name , e.salary , d.department_name
FROM 
	hr.employees e INNER JOIN hr.departments d
	USING (department_id)
	INNER JOIN hr.locations l
	USING (location_id)
WHERE e.salary > 5000
ORDER BY salary DESC;



-- [문제] 부서명과 부서가 속한 도시와 해당 도시가 있는 나라를 조회하시오.
-- 		필요한 테이블 : departements, locations, countries
SELECT d.department_name, l.city, c.country_name
FROM 
	hr.departments d INNER JOIN hr.locations l
	ON d.location_id = l.location_id 
	INNER JOIN hr.countries c 
	ON l.country_id  = c.country_id;
	
-- [문제] 부서명과 부서가 속한 도시와 해당 도시가 있는 나라를 조회하시오.
-- 		필요한 테이블 : departements, locations, countries
SELECT d.department_name, l.city, c.country_name
FROM 
	hr.departments d INNER JOIN hr.locations l
	USING (location_id)
	INNER JOIN hr.countries c 
	USING (country_id);



/* Outer Join
 * 	- inner join은 FK가 null이면 조회에서 제외
 * 	- outer join은 모든 데이터를 다 조회
 * 	- Left Outer Join(자식 - NULL을 가진 테이블을 왼쪽에 배치) / Right Outer Join
 * 	- Outer는 생략 가능
 */

-- [문제] 전체 직원의 이름, 급여, 부서명을 조회하시오
SELECT e.first_name, e.salary, d.department_name 
FROM hr.employees e
LEFT OUTER JOIN hr.departments d
ON e.department_id = d.department_id;

-- [문제] 전체 직원의 이름, 급여, 부서명을 조회하시오  --> USING
SELECT e.first_name, e.salary, d.department_name 
FROM hr.employees e
LEFT OUTER JOIN hr.departments d
USING (department_id);


-- [문제] 부서명과 부서가 위치한 도시와 해당 도시가 있는 나라를 조회하시오
SELECT d.department_name, l.city, c.country_name
FROM hr.countries c 
RIGHT JOIN hr.locations l
USING (country_id)
RIGHT JOIN hr.departments d
USING (location_id);



/* self join
 * 	- 하나의 테이블에 PK와 FK를 같이 가지고 있는 경우
 */

-- [문제] 사원번호와 이름, 상관의 사원번호와 상관의 이름을 조회하시오.
-- 	부모의 PK가 자식의 FK로 전이된다.

SELECT e1.employee_id, e1.first_name AS "직원명", e2.employee_id, e2.first_name AS "매니저명"
FROM hr.employees e1 /*자식을 왼쪽에 (FK)*/ 
INNER JOIN hr.employees e2  /*부모를 오른쪽에 (PK)*/
ON e1.manager_id = e2.employee_id;   -- 자식의 FK와 부모의 PK

-- [문제] Steven도 출력되도록 하시오
SELECT e1.employee_id, e1.first_name AS "직원명", e2.employee_id, e2.first_name AS "매니저명"
FROM hr.employees e1 /*자식을 왼쪽에 (FK)*/ 
INNER JOIN hr.employees e2  /*부모를 오른쪽에 (PK)*/
ON e1.manager_id = e2.employee_id;   -- 자식의 FK와 부모의 PK



-------------------------------------------------------
/*	서브 쿼리 (Subquery)
 * 	- 쿼리문 안에 다른 쿼리가 포함된 것
 * 	- 서브 쿼리 - 안쪽에 포함된 쿼리문
 *  - 메인 쿼리 - 바깥쪽에 있는 쿼리문
 * 
 * 1) 메인 쿼리
 * 	- 실행의 결과를 보여 주는 쿼리문
 * 	- 일반적으로 서브 쿼리에 의해 실행된 결과를 메인에서 사용
 * 
 * 2) 서브 쿼리
 * 	- 메인 쿼리 안쪽에 위치한 쿼리문
 * 	- 서브 쿼리의 결과가 메인 쿼리의 조건이나 결과로 사용됨
 * 	- 서브 쿼리의 위치
 * 	  * where절
 * 	  * having절
 * 	  * from 절
 * 	  * select 절
 * 	  * insert 문의 into절 (보류)
 * 	  * update 문의 set절
 * 
 * 3) 서브 쿼리의 종류
 * 	  1. 단일행 서브 쿼리 : 서브 쿼리가 뱉어내는 값이 1개
 * 	  2. 다중행 서브 쿼리 : 서브 쿼리가 뱉어내는 값이 1개 이상, = 로 비교 불가능
 * 						여러 개를 비교할 수 있는 연산자를 사용해야 함.
 * 						in 연산자, any 연산자(비교연산자), all 연산자
 * 						> any, < any, >= any, ...
 * 
 * 
 */

-- [연습] 사원번호가 162번인 사원의 급여와 같은 급여를 받는 직원의 이름, 급여, 부서번호
-- 1) 찾은 값: 10,500
SELECT salary
FROM hr.employees e 
WHERE employee_id = 162;

-- 2) 찾은 값을 가지고 다시 조회
SELECT first_name, salary, department_id 
FROM hr.employees e
WHERE salary = 10500;

-- 3) 단일행 서브 쿼리로 합치기
SELECT first_name, salary, department_id 
FROM hr.employees e
WHERE salary = (SELECT salary
				FROM hr.employees e 
				WHERE employee_id = 162);
				
			
-- 9. SELF JOIN을 사용하여 'Oliver' 사원의 부서명, 그 사원과 동일한 부서에서
-- 근무하는 동료 사원의 이름을 조회. 단, 각 열의 별칭은 부서명, 동료로 할 것. (서브쿼리로!)
SELECT department_id
FROM hr.employees e
WHERE first_name = 'Oliver';   --80

SELECT first_name AS "동료", department_name AS "부서명"
FROM hr.employees e 
	JOIN hr.departments d 
	USING (department_id)
WHERE department_id = (SELECT e.department_id
						FROM hr.employees e
						WHERE e.first_name = 'Oliver');
						

-- 다중행 서브 쿼리
-- [연습] 30번 부서의 직급들과 동일한 직급이 다른 팀에도 있는지 조사하는 서브 쿼리를 작성하시오
SELECT * FROM hr.employees e
WHERE job_id IN (SELECT DISTINCT job_id
				FROM hr.employees e
				WHERE e.department_id = 30);

	
USE world;
SELECT * FROM world.city;
SELECT * FROM world.country;
SELECT * FROM world.countrylanguage;

-- [문제] MySQL에서 제공하는 world database 내의 테이블을 확인한 후
-- 전체 인구 Percentage 100%가 공식 언어로 'Spanish'를 사용하는 나라의 이름과 인구
-- 조회하는 코드를 서브 쿼리를 이용해 작성하시오
SELECT name,Population
FROM world.country c 
WHERE code IN (SELECT CountryCode
				FROM  world.countrylanguage
				WHERE Percentage = 100
				AND `Language` = 'Spanish');
