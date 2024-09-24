/* 함수 연습문제 */

USE hr;

-- 1.    모든 사원의 이름과, 전화번호 첫 3자리를 출력하시오.
SELECT left(first_name, 3), left(phone_number, 3)
FROM hr.employees e;

-- 2.    모든 사원의 이름과 성, 그리고 (이름과 성을 합한 글자수)를 출력하시오.
SELECT first_name, last_name, length(concat(first_name, last_name)) AS "글자 수"
FROM hr.employees e;

-- 3.    모든 사원의 이름과 성의 머리글자만 출력하시오. (예. A.A)
SELECT concat(left(first_name, 1), '.', left(last_name, 1)) AS "글자"
FROM hr.employees e;

-- 4.    모든 사원의 이름과 성을 대문자로 출력하시오.
SELECT upper(first_name), upper(last_name)
FROM hr.employees e ;

-- 5.    사원의 JOB_ID에 포함된 '_'문자의 위치를 구하고, JOB_ID 에서
--     그 위치 이전까지의 문자열을 사원번호와 함께 출력하시오. (INSTR, SUBSTR 함수 사용)
SELECT locate ('_', job_id)  -- 3
FROM hr.employees e ;

SELECT concat(substring(job_id, 1, 3), employee_id)
FROM hr.employees e;

SELECT INSERT(e.job_id,locate('_',e.job_id),30,e.employee_id) AS 사원번호
FROM employees e; 

-- 6.    사원 급여를 30으로 나눈 값을 소수점 둘째 자리에서 반올림하여 출력하시오.
SELECT round(salary / 30, 2)
FROM hr.employees e ;

-- 7.    사원 급여를 30으로 나눈 값을 소수점 아래를 버림 한 후 출력하시오.
SELECT truncate(salary / 30, 0)
FROM hr.employees e ;

-- 8.    2의 10승을 계산하여 출력하시오.
SELECT power(2, 10);

-- 9.    모든 사원의 입사일과, 입사일 이후 100일째 되는 날을 다음과 같은 형식으로 출력하시오.
SELECT employee_id , hire_date, adddate(hire_date, 100) 
FROM hr.employees e;
   
-- 10.    입사일 이후 오늘까지의 날짜수를 다음과 같이 출력하시오. 최근 입사한 사원순으로 정렬.
SELECT datediff(curdate(), hire_date)
FROM hr.employees e
ORDER BY hire_date DESC;

-- 11.    입사일 이후 오늘까지의 개월수를 다음과 같이 출력하시오. (x)
SELECT concat(datediff(sysdate(), hire_date), '개월')
FROM hr.employees e ;

SELECT CONCAT(TIMESTAMPDIFF(MONTH, hire_date, CURDATE()), '개월') AS 개월수
FROM hr.employees;

-- 12.    입사일을 다음과 같은 형식으로 출력하시오.
-- 2015년 05월 21일 
SELECT date_format(hire_date, '%Y년 %m일 %d일')
FROM hr.employees e ;

-- 참고 ; https://bramhyun.tistory.com/28

-- 13.    입사일이 3월인 모든 사원의 정보를 출력하시오. (LIKE 연산자 사용하면 안 됨)
SELECT * FROM hr.employees e 
WHERE month(hire_date) = 3;

-- 14.    입사한 달이 홀수인 모든 사원의 정보를 출력하시오.
SELECT * FROM hr.employees e 
WHERE mod(MONTH(hire_date), 2) = 1;    -- MOD = 나눠서 나오는 나머지를 구하는 것

-- 15.    현재 시간을 다음과 같은 형식으로 출력하시오.
SELECT date_format(SYSDATE(), '%H시 %i분 %s초') AS "지금";

-- 16.    급여를 다음과 같은 형식으로 출력하시오.
SELECT concat(format(salary,0), '달러') salary
FROM hr.employees e;

-- 17.    입사일 컬럼의 값이 NULL인 경우 오늘 날짜로 치환하여 출력하시오.
SELECT hire_date, ifnull(hire_date, sysdate())
FROM hr.employees e ;

