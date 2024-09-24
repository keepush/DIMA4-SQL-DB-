-- 2024년 7월 23일(화)

/*
  SQL문의 종류
  1) DDL : create, drop, alter
  2) DML : insert, select, update, delete
  3) DCL : grant, revoke
  4) TCL : commit, rollback, savepoint
*/


-- 테이블 생성하기
/*
	CREATE TABLE 테이블명
	(
		컬럼명 데이터타입 제약조건명[제약조건],	-- pk, fk, nn, uq, ck(default)
		컬럼명 데이터타입 [제약조건],
		컬럼명 데이터타입,
		컬럼명 데이터타입,
		컬럼명 데이터타입,
		 제약조건 컬럼명
	);

* 제약조건은 모든 제약조건을 관리하는 테이블에서 관리하게 됨
  제약조건명은 어떤 테이블의 어떤 컬럼에 어떤 제약조건이 걸려 있는지 알기 쉽도록 넣는 것이 좋다.
  
  제약조건명의 예: 테이블명_컬럼명_제약조건

	
-- 데이터 타입(자료형)
1. 문자자료형
	char(10): 'kroea        '
	varchar(50) 'korea',
	longblob

2. 숫자자료형
	 
*/

-- [연습]
-- 데이터베이스 "dima4"
CREATE SCHEMA dima4 default character set UTF8mb4;
USE dima4;

-- 테이블 생성
-- 일련번호(int), 이름(15), 주소(100), 나이(decimal(3))
DROP TABLE sample;

CREATE TABLE sample
(
	seq int AUTO_INCREMENT PRIMARY KEY 
	, name varchar(15) NOT NULL
	, address varchar(100)
	, age decimal(3) DEFAULT 0
);

-- 데이터 넣기
INSERT INTO sample
(name, address, age)
VALUES
('홍길동', '서울시 강남구 삼성동', 25);

INSERT INTO sample
(name, age)
VALUES
('임꺽정', 30);

INSERT INTO sample
(name, address)
VALUES
('손오공', '제주시');

INSERT INTO sample
(name, address, age)
VALUES
('저팔계', '충청남도 무슨동네', 27);

SELECT * FROM sample;

COMMIT;



--[연습] fitness 회원정보를 저장할 수 있는 테이블을 생성하시오!
-- java의 fitness_03 프로젝트 참고

-- 제약조건명을 기재하는 경우에는 테이블레벨을 사용
-- 제약조건명을 기재하지 않는 경우는 컬럼레벨을 사용

DROP TABLE fitness;

CREATE TABLE fitness
(
	id int
	, name varchar(20) NOT NULL    -- NOT NULL은 반드시 컬럼레벨로만 사용
	, gender char(1) 
	, height decimal(5, 2)
	, weight decimal(5, 2)
	, StdWeight decimal(5, 2)
	, bmi decimal(4,2)
	, bmiResult varchar(30)
		, CONSTRAINT fitness_id_pk PRIMARY KEY(id)
		, CONSTRAINT fitness_gender_ck CHECK (gender IN ('남', '여'))
		, CONSTRAINT fitness_height_ck CHECK (height BETWEEN 150 AND 200)
);

DESC dima4.fitness;     -- nn, pk만 확인 가능

-- 제약조건 확인하기 (information_schema.table_constraints)
SELECT 
 TABLE_NAME 
 , CONSTRAINT_NAME 
 , CONSTRAINT_TYPE 
FROM information_schema.table_constraints
WHERE table_name = 'fitness';

-- 제약조건 확인하기 (information_schema.columns)
SELECT 
	TABLE_NAME 
	, COLUMN_NAME 
	, IS_NULLABLE 
	, COLUMN_KEY 
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'dima4'
AND TABLE_NAME = 'fitness';


-- 계산을 해서 데이터를 넣을 경우 소실되는 자릿수가 발생할 수 있다는 경고가 발생한다.

INSERT INTO fitness
(name, gender, height, weight, bmi)
VALUES
('홍길동2', '남', 175.04, 64, weight / (height * height * 0.0001));

INSERT INTO fitness
(name, gender, height, weight, bmi)
VALUES
('김남주', '여', 168.50, 50, weight / (height * height * 0.0001));

INSERT INTO fitness
(name, gender, height, weight, bmi)
VALUES
('강감찬', '남', 190.00, 85, weight / (height * height * 0.0001));


SELECT * FROM fitness;