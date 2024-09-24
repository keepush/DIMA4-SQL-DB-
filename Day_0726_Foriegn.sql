/* 7월 26일 관계를 형성하여 테이블 생성 */

-- 부모 테이블부터 생성(PK, UQ)  -->  자식 테이블을 참조하여 생성
-- drop은 자식 테이블  -->  부모 테이블을 나중에 드랍
USE dima4;
DROP TABLE dima4.parent;
CREATE TABLE dima4.parent
(
	id int AUTO_INCREMENT
	, name varchar(30) NOT NULL
	, phone varchar(20) NOT NULL
	, age decimal(3) DEFAULT 20
		, CONSTRAINT parent_id_pk PRIMARY KEY (id)             -- PRIMARY KEY가 id라는 것을 알려 줘야 함
);
-- not null = column level,  다른 제약조건은 table level 주기 가능 (constraint - )

DROP TABLE dima4.child

CREATE TABLE dima4.child
(
	cid int AUTO_INCREMENT
	, id int                      -- 부모의 PK가 전이된 컬럼
	, major varchar(30)
	, grade decimal(2)
	 	, CONSTRAINT child_cid_pk PRIMARY KEY (cid)
	 	, CONSTRAINT child_id_fk FOREIGN KEY (id) REFERENCES parent(id)
	 		ON DELETE CASCADE  ON UPDATE CASCADE 
);

-- 부모의 레코드를 삭제하려고 하면 에러 남 (전제 조건 - 부모의 pk값을 자식이 참조하고 있다면)
-- 부모의 레코드를 삭제하면 자동으로 자식의 레코드도 삭제하도록 하거나
-- 부모의 pk값을 수정하면 자동으로 자식의 fk값도 수정되도록 하면 된다.


-- parent 테이블에 데이터 입력
INSERT INTO parent (name, phone, age) VALUES ('홍길동', '1', 20);
INSERT INTO parent (name, phone, age) VALUES ('손오공', '2', 21);
INSERT INTO parent (name, phone, age) VALUES ('사오정', '3', 22);
INSERT INTO parent (name, phone, age) VALUES ('저팔계', '4', 23);

SELECT * FROM parent;

-- child 테이블에 데이터 입력
INSERT INTO child (id, major, grade) VALUES (1, '컴퓨터공학', 4);
INSERT INTO child (id, major, grade) VALUES (2, '한국학', 3);
INSERT INTO child (id, major, grade) VALUES (3, '영어영문학', 1);
INSERT INTO child (id, major, grade) VALUES (4, '응용미술', 3);

SELECT * FROM dima4.child;

-- join으로 조회하기
SELECT p.id, p.name, p.phone , c.major , c.grade
FROM dima4.parent p, dima4.child c 
WHERE p.id = c.id;

-- on delete cascade가 되는지 확인
-- 부모의 레코드를 삭제하면 자식의 레코드도 같이 삭제되는 것
DELETE FROM dima4.parent WHERE id = 1;
SELECT * FROM dima4.child;

-- on update cascade가 되는지 확인
-- 부모 레코드의 PK가 수정되면 자식의 레코드의 FK도 같이 수정되는 것
UPDATE parent
SET
   id = 99
WHERE id = 2;

SELECT * FROM dima4.parent p ;
SELECT * FROM dima4.child c ;

-- [연습] 영화 정보 데이터 저장
CREATE TABLE dima4.movie
(
	movie_num int AUTO_INCREMENT
	, genre varchar(50) NOT NULL
	, movie_name varchar(50) NOT NULL
	, movie_summary varchar(2000) NOT NULL
	, movie_date datetime DEFAULT current_timestamp
	, enabled decimal(1) DEFAULT 1
	, rolename varchar(20) DEFAULT 'ROLE_USER'
		, CONSTRAINT movie_num_pk PRIMARY KEY (movie_num)
);

CREATE TABLE dima4.review
(
	review_num int AUTO_INCREMENT
	, reviewer_name varchar(50) NOT NULL
	, movie_num int NOT NULL
	, review_text varchar(2000) NOT NULL
	, score decimal(1) DEFAULT 0
	, review_date datetime DEFAULT current_timestamp
		, CONSTRAINT review_num_pk PRIMARY KEY (review_num)
		, CONSTRAINT review_movie_num_fk FOREIGN KEY (movie_num) REFERENCES dima4.movie(movie_num)
			ON DELETE CASCADE ON UPDATE CASCADE
);

COMMIT;