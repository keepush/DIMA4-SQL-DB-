/* 7월 25일 : Function(함수)의 사용 */

/* 문자열 관련 함수 */

SELECT ascii('A'), char(97);     -- 65, a

SELECT bit_length('abc'), char_length('abc'), LENGTH('abc') ;        -- 24, 3, 3

-- 한글은 한 글자당 3byte(24비트)가 필요
SELECT bit_length('가나다'), char_length('가나다'), LENGTH('가나다') ;      -- 72, 3, 9

SELECT concat('Databse', ' ', 'So Good~~');

-- Steven King 입니다.
SELECT concat(first_name,' ', last_name, ' ', '입니다.')
FROM hr.employees e;

-- 반복
SELECT REPEAT('hello', 3);

-- 뒤집기
SELECT reverse('I have a dream!');

-- 위치 찾기 (인덱스가 1부터 시작하므로 찾지 못할 경우에는 0이 반환)
SELECT locate('hate', 'I hate to turn up out of the blue, uninvited');
SELECT locate('love', 'I hate to turn up out of the blue, uninvited');

-- 3번째 전달값은 찾을 시작위치값
SELECT locate('you', 'Everybody loves the things you do From the way you talk', 5);

-- 데이터를 삽입
SELECT INSERT ('I love you!', 3, 4, 'miss');

SELECT locate ('you', 'I love you!');         -- 8
SELECT INSERT ('I love you!', 8, 3, 'me');

-- 위 문장을 하나로 바꾸어 보시오
SELECT INSERT ('I love you!', locate('you', 'I love you!'), 3, 'me');

-- 데이터 추출 : left(문자열, 개수), right(문자열, 개수)
-- 왼쪽이나 오른쪽에서 단어에서 추출
SELECT left('Everybody loves the things you do From the way you talk', 9), 
		right('Everybody loves the things you do From the way you talk', 4);

-- substring(문자열, 위치, 개수)
SELECT substring('Everybody loves the things you do From the way you talk', 11, 5);

-- 대소문자 변환
SELECT upper('Everybody loves the things you do From the way you talk'),
 lower('Everybody loves the things you do From the way you talk');

-- 치환 : replace(문자열, 찾을 문자열, 바꿀 문자열)
SELECT replace('MSSQL', 'MS', 'My');

-- 길이를 구하기 : length
SELECT length('     I have a dream!!!     ');

-- 문자열 앞뒤의 공백자르기 : trim(문자열)
SELECT length('     I have a dream!!!     '),
 length(trim('     I have a dream!!!     ')),
 length(ltrim('     I have a dream!!!     ')),
 length(rtrim('     I have a dream!!!     '));
 
-- 문자열 앞뒤의 특수문자 자르기 : trim()
SELECT trim(LEADING '~' FROM '~~~~~I have a dream!!!!~~~~'),
		trim(TRAILING '~' FROM '~~~~~I have a dream!!!!~~~~'),
		trim(BOTH '~' FROM '~~~~~I have a dream!!!!~~~~');
		
-- [연습] employees와 departments 테이블을 이용하여 아래와 같이 조회하시오
/*
Steve의 부서는 Administration입니다.
XXX부서는 XXX입니다.
XXX부서는 XXX입니다.
*/
SELECT concat(first_name, '의', ' ', '부서는', department_name, '입니다.')
FROM hr.employees e JOIN hr.departments d USING (department_id);


/* 수학 관련 함수 */
SELECT abs(-45.34), abs(45.23);		-- 절대값
SELECT floor(-45.653), floor(45.653);	-- 음의 방향에서 만나는 첫 번째 정수값
SELECT ceil(-45.653), ceil(45.653);		-- 양의 방향에서 만나는 첫 번째 정수값

-- 지정된 소수점 자릿수에서 버림
SELECT truncate(-45.653, 1), truncate(45.653, 1);

-- 지정된 소수점 자리 반올림
SELECT round(-45.653, 1), round(45.653, 1);

-- 전달된 숫자들 중에서 최댓값, 최솟값
SELECT greatest(5, 1, 8, 7, 50) AS "최댓값", least(5, 1, 8, 7, 50) AS "최솟값";

-- 원주율
SELECT pi();

-- 제곱근
SELECT sqrt(81), pow(2.5, 3), power(2, 3.5);


/* 날짜 관련 함수 */
-- 현재 시스템 날짜와 시간을 조회
SELECT now(), sysdate(); 

-- 현재 날짜, 현재 시간을 조회
SELECT curdate(), curtime();

-- 날짜 데이터를 연도, 월, 일로 분리해서 조회
SELECT year(sysdate()), MONTH(sysdate()), DAY(sysdate());

-- date(), time() -- curdate(), curtime()
SELECT date(sysdate()), time(sysdate());

-- 시, 분, 초
SELECT hour(curtime()), minute(curtime()), second(curtime());

-- 경과일: datediff(미래 시간, 과거 시간)
SELECT datediff('1950-6-25', '1945-8-15');

-- [연습] 오늘부터 수료일까지 며칠이 남았나요?
SELECT datediff('2024-11-01', curdate());

-- [연습] 센터에 온 지 6시간 35분이 지났습니다.
SELECT concat('센터에 온 지', ' ', HOUR(timediff(curtime(),'10:00:00')), '시간 ', MINUTE(timediff(curtime(),'10:00:00')), '분이 지났습니다.');


-- 요일 추출
SELECT dayofweek(sysdate());		-- 5요일(일요일이 1)

-- 월 이름
SELECT monthname(sysdate());

-- 
SELECT dayofyear(sysdate()); 


/* 기타 함수 */
-- employees 테이블에서 제공하는 salary를 이용하여 회사 급여 평균을 찾아 변수에 저장한다.
SET @salavg := (SELECT avg(salary) FROM hr.employees e);  -- 6,461
SELECT @salavg;

-- 직원의 월급이 평균보다 많은지 아닌지 출력하는 코드를 작성
SELECT salary, @salavg AS "평균", IF(salary > @salavg, "많다", "적다")
FROM hr.employees e;

-- ifnull()을 이용
-- manager_id가 null인 사람은 "팀장이 없음"이라고 출력되도록
SELECT first_name, ifnull(manager_id, "팀장이 없음")
FROM hr.employees e;

-- [연습] hr.departments 테이블에서 매니저 이름을 출력하시오
/*
Sales  David
IT 	   매니저 없음
*/
SELECT d.department_id, department_name, ifnull(first_name, "매니저 없음") AS "Manager Name"
FROM hr.departments d LEFT OUTER JOIN hr.employees e ON d.manager_id = e.employee_id;



/*
 * Grouping 함수의 사용
 */
USE hr;
-- count(컬럼명) : null 데이터는 count에서 제외
SELECT count(*), count(manager_id) FROM hr.employees e ;

-- 부서별로 집계
-- sum() : 합계, avg() : 평균, min(최솟값), max (최댓값)
SELECT department_id ,sum(salary), round(avg(salary),2), min(salary), max(salary)
FROM hr.employees e
GROUP BY department_id ;
