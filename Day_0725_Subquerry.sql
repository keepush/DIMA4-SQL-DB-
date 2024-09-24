-- -------------------------------------------------------------------
/*  서브 쿼리 (Sub query)
 * 	- 쿼리문 안에 다른 쿼리가 포함된 것
 *  - 서브쿼리 - 안쪽에 포함된 쿼리문
 *  - 메인쿼리 - 바깥쪽에 있는 쿼리문
 *  ※서브쿼리 안에서 ORDER BY절은 사용 불가 (일부 from 절에서는 제외)
 * 
 * 1) 메인쿼리
 * 	- 실행의 결과를 보여주는 쿼리문
 *  - 일반적으로 서브쿼리에 의해 실행된 결과를 메인에서 사용
 * 
 * 2) 서브쿼리
 * 	- 메인쿼리 안쪽에 위치한 쿼리문
 *  - 서브쿼리의 결과가 메인쿼리의 조건이나 결과로 사용됨
 *  - 서브쿼리의 위치
 * 		* where 절
 * 		* having 절
 * 		* from 절
 *		* select 절
 *		* insert 문의 into 절 (보류)
 *		* update 문의 set 절
 *
 * 3) 서브쿼리의 종류
 * 		1. 단일행 서브쿼리 : 서브쿼리가 뱉어내는 값이 1개
 * 		2. 다중행 서브쿼리 : 서브쿼리가 뱉어내는 행이 1개 이상. =로 비교 불가능
 * 							 여러 개를 비교할 수 있는 연산자를 사용해야 함.
 *                           in 연산자, any 연산자(비교연산자), all 연산자
 * 							   > any, < any, >= any, >= any
 * 		3. 다중 컬럼 서브 쿼리 : 서브쿼리가 뱉어내는 컬럼이 여러 개인 경우
 * 
 * 		4. Scalar 서브쿼리
 * 			: SELECT 절의 컬럼 위치에 사용되는 서브쿼리
 * 			: Scaler 서브쿼리는 성능문제로 이것보다는 join을 사용하는 것이 좋다.
 * 
 *      5. Inline View
 *        : 서브 쿼리가 From 절에 기술되는 것
 *        : 서브 쿼리로 조회되는 결과를 테이블로 사용함
 *        : 서브 쿼리에서 조회되는 컬럼에는 별칭을 사용해야 한다.
 * 
 * 		6. 상호연관 서브쿼리
 * 
 */
-- [연습] 사원번호가 162번인 사원의 급여와 같은 급여를 받는 직원의 이름, 급여, 부서번호
-- 1) 찾은 값 : 10

SELECT salary
FROM hr.employees e 
WHERE employee_id = 162;

-- 2) 찾은 값을 가지고 다시 조회
SELECT first_name, salary, department_id
FROM hr.employees e 
WHERE salary = 10500;

-- 3) 서브쿼리로 합치기
SELECT first_name, salary, department_id
FROM hr.employees e 
WHERE salary = ( SELECT salary
				 FROM hr.employees e
				 WHERE employee_id = 162;)
				 
				 
-- [문제] SELF JOIN을 사용하여 'Oliver' 사원의 부서명, 그 사원과 동일한 부서에서 근무하는 동료 사원의 이름을 조회.
-- 단, 각 열의 별칭은 부서명, 동료로 할 것.

-- SELECT first_name, department_id 
-- FROM HR.employees e
-- WHERE first_name = 'Oliver'   -- 80

--- 서브쿼리로 실행

SELECT  e.first_name, d.department_name
FROM hr.employees e 
   JOIN hr.departments d
   USING (department_id)
WHERE e.department_id = (SELECT e.department_id 
                                 FROM hr.employees e 
                                 WHERE e.first_name = 'Oliver');

	
-- 다중행 서브쿼리
                                
-- 1) IN 연산자의 사용          
                            
-- [연습] 30번 부서의 직급들과 동일한 직급이 다른팀에 있는지 
--    조사하는 서브쿼리를 작성하시오.

SELECT *
FROM hr.employees e
WHERE job_id IN (SELECT DISTINCT job_id
				FROM hr.employees e 
				WHERE department_id = 30);

                           
USE world;
SELECT * FROM world.city;
SELECT * FROM world.country;
SELECT * FROM world.countrylanguage c;

SELECT  name, Population 
FROM world.country c 
WHERE code IN (SELECT countrycode
                  FROM world.countrylanguage
                  WHERE 
                        Percentage = 100
                  AND 
                        `Language` = 'Spanish');
                  
                       
-- 2) ANY 연산자의 사용
-- [연습] hr데이터베이스에 존재하는 employees 테이블에 'ST_MAN'이라는 직군이 있다.
-- 		  'ST_MAN'이라는 직군이 받는 급여보다 적은 급여를 받는 직원의 정보를 조회하라.
                       
---

SELECT salary FROM hr.employees e
WHERE job_id = 'ST_MAN'
ORDER BY salary;

---  8200보다 덜 받음

SELECT first_name, salary FROM hr.employees e 
WHERE salary < ANY ( SELECT salary FROM hr.employees e
					 WHERE job_id = 'ST_MAN'
					 ORDER BY salary)
ORDER BY 2;


-- 다른 예 - 5800보다는 많이 받음

SELECT first_name, salary FROM hr.employees e 
WHERE salary > ANY ( SELECT salary FROM hr.employees e
					 WHERE job_id = 'ST_MAN'
					 ORDER BY salary)
ORDER BY 2;

-- [연습] job_title이 'Manager'인 직원과 동일한 급여를 받는 직원의 사번, 이름, 
--		  job_id, 급여의 정보를 급여순으로 조회하시오

SELECT first_name, salary, job_title
FROM hr.employees e 
INNER JOIN hr.jobs j
USING (job_id)
WHERE job_title LIKE '%manager%' ;

-- (답)
SELECT employee_id, first_name, job_id, salary FROM hr.employees e
WHERE salary = ANY ( SELECT salary
						FROM hr.employees e 
						INNER JOIN hr.jobs j
						USING (job_id)
						WHERE job_title LIKE '%manager%')
ORDER BY 4; -- ( 셀렉트의 네번째에 의해 순서를 매김)


-- 3) ALL 연산자의 사용
-- 
SELECT salary FROM hr.employees e
WHERE job_id = 'ST_MAN'
ORDER BY salary;

-- 
SELECT first_name, salary
FROM hr.employees e 
WHERE salary < ALL (SELECT salary FROM hr.employees e
                             WHERE job_id = 'ST_MAN'
                             ORDER BY salary
                             )
ORDER BY 2; -- 가장 적게 받는 사람보다 더 적은 사람

-- (답)
SELECT employee_id, first_name, job_id, salary FROM hr.employees e
WHERE salary < ALL ( SELECT salary
						FROM hr.employees e 
						INNER JOIN hr.jobs j
						USING (job_id)
						WHERE job_title LIKE '%manager%')
ORDER BY 4; 


-- ------------------------ 다중 컬럼 서브쿼리
-- [연습] 각 부서별 최고금액을 수령하는 직원의 정보(사원번호, 이름, 급여, 부서명, 직급명)을 조회하시오

-- max, min, avr, ... 
-- 컬럼이 2개 조회됨
SELECT department_id, max(salary), min(salary) 
FROM hr.employees e 
GROUP BY department_id; 

-- 서브쿼리 사용하기 
SELECT employee_id, first_name, salary, department_name, job_title
FROM  hr.employees e 
INNER JOIN hr.departments d
USING (department_id)
INNER JOIN hr.jobs j
USING (job_id)
WHERE (department_id, salary) IN (  SELECT department_id, max(salary)   -- WHERE 다음에 넣는 요소 순서 지키기!!
									FROM hr.employees e 
									GROUP BY department_id );
									
								
------------------------- 스칼라 서브쿼리
-- [연습]

SELECT 
      (SELECT last_name FROM hr.employees e2 WHERE first_name = 'Bruce') AS "Bruce 의 성",
      (SELECT last_name FROM hr.employees e2 WHERE first_name = 'Daniel') AS "Daniel 의 성"
;



---------------------- Inline View 서브 쿼리
-- 일반 조회
SELECT employee_id, first_name, salary , department_id 
FROM hr.employees e 
WHERE department_id = 80;

-- 앞에서 조회된 결과를 이용해서 일련번호를 부여한 후에 출력하려면?

SET @rownum := 0;   -- 일련번호를 넣기 위한 사용자 정의 변수 

SELECT @rownum := @rownum + 1 AS `no`, tbl.* FROM
   (SELECT employee_id, first_name, salary , department_id 
   FROM hr.employees e 
   WHERE department_id = 80) tbl;
   
  
---------------------- 상호연관 서브 쿼리

-- [연습] 각 부서별로 해당 부서의 급여 평균 미만의 급여를 수령하는 직원 명단 조회 
--	(부서번호, 사원번호, 이름, 급여, 부서별 평균 급여)

SELECT department_id , employee_id , first_name , salary
FROM hr.employees e 
WHERE salary < (SELECT avg(salary)
				FROM hr.employees
				WHERE department_id = e.department_id)
ORDER BY 1, 2;

-- 위 코드를 인라인 뷰로 수정하시오
-- 
SELECT department_id AS "부서번호" , avg(salary) AS "부서평균"
FROM hr.employees e 
GROUP BY department_id;

-- 인라인 뷰 안에 삽입
SELECT e.department_id , e.employee_id , e.first_name , e.salary 
FROM (SELECT department_id AS "부서번호" , avg(salary) AS "부서평균"
		FROM hr.employees 
		GROUP BY department_id) tbl, hr.employees e
WHERE tbl.부서번호 = e.department_id 
AND e.salary < tbl.부서평균
ORDER BY 1, 2;