/* 7월 26일 : 사용자 생성과 권한 */

--------------------- 사용자
-- 1. 사용자 생성
-- 새로운 사용자를 생성하면서 비밀번호를 설정 

CREATE USER 'ogong'@'host' identified BY 'ogong';
CREATE USER 'newuser'@'localhost' identified BY 'newuser';

-- 2. 사용자 삭제
DROP USER 'ogong'@'host';
DROP USER 'newuser'@'localhost';


-- 3. 사용자 권한 부여
GRANT SELECT, INSERT ON dima4.customers TO 'newuser'@'localhost';

-- 모든 권한을 한꺼번에 부여
GRANT ALL PRIVILEGES ON dima4.* TO 'newuser'@'localhost';


-- 4. 권한 적용
flush PRIVILEGES;			-- 낮은 버전에서 사용하던 명령


-- 5. 권한 확인
SHOW grants FOR 'newuser'@'localhost';
SHOW grants FOR 'ogong'@'host';


-- 5. 권한 회수 
REVOKE SELECT, INSERT ON dima4.customers FROM 'newuser'@'localhost';


-- 6. 사용자 삭제
DELETE USER 'newuser'@'localhost';


-- 지금 현재 사용자 확인
SELECT user();

-- 생성된 모든 사용자 정보를 조회   - 비밀번호는 볼 수 없음
SELECT USER, host FROM mysql.USER;
DESC mysql.USER;


-- 자신의 이름이나 아이디를 만들어 비밀번호를 만든 후
-- dima4 데이터베이스에 관한 모든 권한을 부여
-- console 창에서 접속되는지 확인하시오
-- > mysql -u 아이디 -p (엔터)

CREATE USER 'nada'@'localhost' identified BY 'nunnaya';
GRANT ALL PRIVILEGES ON dima4.* TO 'nada'@'localhost';
SELECT USER, host FROM mysql.USER;


-- --------------------- 테이블 설계하기
/*
 * 아이돌 관련 정보를 저장할 DB를 설계하시오
 * 
 * 조건) 'idol' 이라는 이름의 데이터베이스를 생성한 후 작업을 하세요
 *  - 잘 세분화하여 테이블을 잘 쪼개는 것이 중요
 *  - 아이돌 그룹 - 데뷔일, 소속사, 멤버 수, 대표 앨범..  / 멤버 - 이름, 나이, 포지션 / 앨범 - 수록곡, 노래 번호 / 노래 - 작곡가, 작사가, 편곡
 */

DROP TABLE dima4.idol;
DROP TABLE dima4.members ;
DROP TABLE dima4.songs;
DROP TABLE dima4.album;


CREATE TABLE dima4.idol
(
    idol_num int AUTO_INCREMENT,
    group_name varchar(30) NOT NULL,
    owner varchar(30) NOT NULL,
    members int DEFAULT 1,
    CONSTRAINT idol_num_pk PRIMARY KEY (idol_num)
);

CREATE TABLE dima4.members
(
    idol_num int,
    member_id int AUTO_INCREMENT,
    name varchar(20) NOT NULL,
    age int NOT NULL,
    pose varchar(50) NOT NULL,
    CONSTRAINT member_id_pk PRIMARY KEY (member_id),
    CONSTRAINT fk_idol_num_members FOREIGN KEY (idol_num) REFERENCES dima4.idol(idol_num)
);

CREATE TABLE dima4.album
(
    album_id int AUTO_INCREMENT,
    idol_num int,
    album_name varchar(30) NOT NULL,
    CONSTRAINT album_id_pk PRIMARY KEY (album_id),
    CONSTRAINT fk_idol_num_album FOREIGN KEY (idol_num) REFERENCES dima4.idol(idol_num)
);

CREATE TABLE dima4.songs
(
    song_num int AUTO_INCREMENT,
    album_id int,
    song_name varchar(50) NOT NULL,
    composer varchar(20) NOT NULL,
    lyricist varchar(20) NOT NULL,
    arrangement varchar(20) DEFAULT 'None',
    CONSTRAINT songs_pk PRIMARY KEY (song_num, song_name),
    CONSTRAINT fk_album_id_songs FOREIGN KEY (album_id) REFERENCES dima4.album(album_id)
);





