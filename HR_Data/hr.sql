-- (1) 1단계 Database 및 테이블의 생성

-- 1. 현재 생성된 데이터베이스의 종류를 나열
-- SHOW DATABASES;

-- 2. 한글세트를 저장할 수 있는 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS `hr` DEFAULT CHARACTER SET UTF8MB3;

-- 3. 데이터베이스 삭제
-- DROP DATABASE `hr`;

-- 4. 데이터베이스 사용
USE `hr`;

-- [실습] hr DB에 샘플 테이블의 생성
-- 1. 대륙 테이블 (regions)
-- DROP TABLE regions;
CREATE TABLE regions
( 
  region_id   int,
  region_name varchar(25),
   CONSTRAINT reg_id_pk PRIMARY KEY(region_id) 
);

-- 2. 국가 테이블 (Countries)
-- DROP TABLE countries;
CREATE TABLE countries
(
	country_id 		 char(2) comment 'Primary key of countries table.'
	, country_name   varchar(40) comment 'Country name'
	, region_id 	 int
		, CONSTRAINT country_id_pk PRIMARY KEY(country_id)
		, CONSTRAINT country_reg_fk FOREIGN key(region_id) REFERENCES regions(region_id) ON DELETE CASCADE 
);

-- 3. 지역 테이블(Locations)
-- MySQL에서 NOT NULL 제약 조건에 이름을 부여하는 것은 직접적으로 지원되지 않는다.
-- DROP TABLE locations;
CREATE TABLE locations
(
	location_id 	 decimal(4)  comment 'Primary key of locations table'
	, street_address varchar(40) comment 'Street address of an office, warehouse, or production site of a company. Contains building number and street name'
	, postal_code 	 varchar(12) comment 'Postal code of the location of an office, warehouse, or production site of a company.'
	, city 			 varchar(30) NOT NULL comment 'A not null column that shows city where an office, warehouse, or production site of a company is located.'
	, state_province varchar(25) comment 'State or Province where an office, warehouse, or production site of a company is located.'
	, country_id 	 char(2)     comment 'Country where an office, warehouse, or production site of a company is located. Foreign key to country_id column of the countries table.'
		, CONSTRAINT loc_id_pk PRIMARY KEY(location_id)
		, CONSTRAINT loc_reg_fk FOREIGN KEY(country_id) REFERENCES countries(country_id) ON DELETE CASCADE
);

-- 4. 부서 테이블 (Departments)
-- DROP TABLE departments;
CREATE TABLE departments
(
	department_id 		decimal(4) comment 'Primary key column of departments table.'
	, department_name 	varchar(3) NOT NULL comment 'A not null column that shows name of a department. Administration, Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public Relations, Sales, Finance, and Accounting. '
	, manager_id 		decimal(6) comment 'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.'
	, location_id 		decimal(4) comment 'Location id where a department is located. Foreign key to location_id column of locations table.'
		, CONSTRAINT dept_id_pk PRIMARY KEY(department_id)
		, CONSTRAINT dept_loc_id_fk FOREIGN KEY(location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);

-- 5. 업무 테이블 (Jobs)
-- DROP TABLE jobs;
CREATE TABLE jobs
(
	job_id 		 varchar(10) comment 'Primary key of jobs table.'
	, job_title  varchar(35) NOT NULL comment 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT'
	, min_salary decimal(6) comment 'Minimum salary for a job title.'
	, max_salary decimal(6) comment 'Maximum salary for a job title'
		, CONSTRAINT job_id_pk PRIMARY KEY(job_id)
);

-- 6. 직원 테이블 (Employees)
-- DROP TABLE employees;
CREATE TABLE employees 
(
	employee_id 	 decimal(6) comment 'Primary key of employees table.'
	, first_name 	 varchar(20) NOT NULL comment 'First name of the employee. A not null column.'
	, last_name 	 varchar(25) NOT NULL comment 'Last name of the employee. A not null column.'
	, email  		 varchar(25) comment 'Email id of the employee'
	, phone_number 	 varchar(20) comment 'Phone number of the employee; includes country code and area code'
	, hire_date 	 date        NOT NULL comment 'Date when the employee started on this job. A not null column.'
	, job_id 		 varchar(10) NOT NULL comment 'Current job of the employee; foreign key to job_id column of the jobs table. A not null column.'
	, salary 		 decimal(8, 2) comment 'Monthly salary of the employee. Must be greater than zero (enforced by constraint emp_salary_min)'
	, commission_pct decimal(2, 2) comment 'Commission percentage of the employee; Only employees in sales department elgible for commission percentage'
	, manager_id 	 decimal(6) comment 'Manager id of the employee; has same domain as manager_id in departments table. Foreign key to employee_id column of employees table. (useful for reflexive joins and CONNECT BY query)'
	, department_id  decimal(4) comment 'Department id where employee works; foreign key to department_id column of the departments table'
		, CONSTRAINT emp_emp_id_pk PRIMARY KEY(employee_id)
		, CONSTRAINT emp_dept_fk   FOREIGN KEY(department_id) REFERENCES departments(department_id) ON DELETE CASCADE
		, CONSTRAINT emp_job_pk    FOREIGN KEY(job_id) REFERENCES jobs(job_id) ON DELETE CASCADE
		, CONSTRAINT emp_salary_min CHECK (salary > 0)
		, CONSTRAINT emp_email_uk   UNIQUE (email)
);

		
-- 7. 업무경력 테이블(job_history)
DROP TABLE job_history;
CREATE TABLE job_history
(
	employee_id 	decimal(6) 	NOT NULL comment 'A not null column in the complex primary key employee_id+start_date. Foreign key to employee_id column of the employee table'
	, start_date 	date 		NOT NULL comment 'A not null column in the complex primary key employee_id+start_date. Must be less than the end_date of the job_history table. (enforced by constraint jhist_date_interval)'
	, end_date 		date 		NOT NULL comment 'Last day of the employee in this job role. A not null column. Must be greater than the start_date of the job_history table. (enforced by constraint jhist_date_interval)' 
	, job_id 		varchar(10)	NOT NULL comment 'Job role in which the employee worked in the past; foreign key to job_id column in the jobs table. A not null column.'
	, department_id decimal(4) comment 'Department id in which the employee worked in the past; foreign key to deparment_id column in the departments table'
		, CONSTRAINT jhist_emp_id_st_date_pk PRIMARY KEY (employee_id, start_date)
		, CONSTRAINT jhist_emp_fk FOREIGN KEY(employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
		, CONSTRAINT jhist_emp_id_st_date_pk FOREIGN KEY(employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
		, CONSTRAINT jhist_date_interval CHECK (start_date < end_date)
		, CONSTRAINT jhist_job_fk FOREIGN KEY(job_id) REFERENCES jobs(job_id) ON DELETE CASCADE
		, CONSTRAINT jhist_dept_fk FOREIGN KEY(department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);


-- (2)단계 : CSV를 테이블에 저장 (아직 안됨)
DELIMITER // 

CREATE PROCEDURE LoadCSVToTable(IN csv_file_path VARCHAR(255))
BEGIN
    SET @sql = CONCAT(
        "LOAD DATA INFILE '", csv_file_path, "' ",
        "INTO TABLE example_table ",
        "FIELDS TERMINATED BY ',' ",
        "ENCLOSED BY '\"' ",
        "LINES TERMINATED BY '\n' ",
        "IGNORE 1 LINES "
        "(id, name, age, email)"
    );
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;


-- (3)단계: 테이블에 데이터를 모두 저장한 후 관계를 설정하는 아래의 쿼리문을 실행

-- 부서 테이블의 manager_id와 FK로 연결
ALTER TABLE departments ADD CONSTRAINT dept_mgr_fk FOREIGN KEY (manager_id) REFERENCES employees(employee_id) ON UPDATE CASCADE;

-- 직원 테이블의 manager_id를 employee_id와 연결
ALTER TABLE employees ADD CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id) REFERENCES employees(employee_id) ON UPDATE CASCADE;
