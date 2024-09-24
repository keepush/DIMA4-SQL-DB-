/* 7월 26일 ALTER 명령 */

USE dima4;

-- 테이블 삭제 명령 
DROP TABLE dima4.contract;
DROP TABLE dima4.products;
DROP TABLE dima4.customer;

-- 1) 고객의 정보를 저장하는 테이블
CREATE TABLE dima4.customer
(
	customer_id char(3) PRIMARY KEY
	, customer_name varchar(50) NOT NULL 
	, phone_number varchar(30) NOT NULL
	, address varchar(100)
);

-- 2) 판매 제품의 정보를 저장하는 테이블
CREATE TABLE dima4.products
(
	product_id char(5) PRIMARY KEY
	, product_name varchar(100) NOT NULL
	, manufact_date datetime DEFAULT current_timestamp
	, unit_price int DEFAULT 0
);

-- 3) 계약 정보를 저장하는 테이블
CREATE TABLE dima4.contract
(
	customer_id char(3) REFERENCES customer(customer_id)
	, product_id char(3) REFERENCES products(product_id)
	, contract_date datetime DEFAULT current_timestamp
	, cnt int 
		, CONSTRAINT contract_pk PRIMARY KEY (customer_id, product_id)  -- 복합키
);

-- 테이블의 이름을 변경 
ALTER TABLE customer RENAME TO customers;

--  컬럼을 맨 뒤에 추가 (add)
ALTER TABLE dima4.customers ADD email char(20);

-- 컬럼을 이미 존재하는 컬럼의 뒤에추가
ALTER TABLE dima4.products ADD product_grade char(1) CHECK (product_grade IN ('A', 'B', 'C'))  -- 해당 컬럼에 A, B, C만을 허용하겠다
AFTER manufact_date;

-- 컬럼 삭제
ALTER TABLE contract DROP cnt;

-- 컬럼의 타입을 수정 (modify)
ALTER TABLE dima4.customers MODIFY address varchar(80);

-- 컬럼을 수정 (change)
ALTER TABLE dima4.products CHANGE unit_price price decimal(10, 2);

-- 수정 여부를 확인하기
DESC dima4.customers;
DESC dima4.products;
DESC dima4.contract;

COMMIT;

