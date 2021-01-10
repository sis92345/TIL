--회원 테이블 생성
CREATE TABLE Users
(
	userid          VARCHAR2(12),
	passwd       VARCHAR2(12)    CONSTRAINT users_passwd_nn  NOT NULL,
	name          VARCHAR2(20)    CONSTRAINT users_name_nn  NOT NULL,
	age             NUMBER(2)         CONSTRAINT users_age_nn  NOT NULL,
	gender        CHAR(1)              DEFAULT  '2'   CONSTRAINT users_gender_nn  NOT NULL,
	flag             NUMBER(1)         DEFAULT  1    CONSTRAINT users_flag_nn  NOT NULL,
	CONSTRAINT users_userid_pk PRIMARY KEY(userid),
	CONSTRAINT users_age_ck CHECK (age BETWEEN 10 AND 99),
	CONSTRAINT users_gender_pk CHECK (gender IN('1', '2')),
	CONSTRAINT users_flag_ck CHECK (flag IN(0, 1))
);

--회원가입
CREATE OR REPLACE PROCEDURE sp_users_insert
(
    v_userid     IN    users.userid%TYPE,
    v_passwd     IN    users.passwd%TYPE,
    v_name     IN    users.name%TYPE,
    v_age     IN    users.age%TYPE,
    v_gender     IN    users.gender%TYPE
)
IS
BEGIN
    INSERT INTO USERS(userid, passwd, name, age, gender, flag)
    VALUES(v_userid, v_passwd, v_name, v_age, v_gender, 1);
    COMMIT;
END;

--관리자 입력
INSERT INTO Users
VALUES('admin', '12345678', '관리자', 50, '1', 0);
COMMIT;

--회원명단 가져오기
CREATE OR REPLACE PROCEDURE sp_users_select_all
(
    users_record     OUT     SYS_REFCURSOR
)
AS
BEGIN
    OPEN users_record FOR
    SELECT userid, passwd, name, age, gender
    FROM Users
    WHERE flag > 0
    ORDER BY userid ASC;
END;

--멤버 로그인
CREATE OR REPLACE PROCEDURE sp_users_login
(
    v_userid     IN      users.userid%TYPE,
    v_passwd     IN      users.passwd%TYPE,
    v_result     OUT     NUMBER
)
IS
    t_passwd    users.passwd%TYPE;
BEGIN
    SELECT passwd INTO t_passwd 
    FROM Users
    WHERE userid = v_userid;
    
    --그런 아이디가 있다면
    IF v_passwd = t_passwd THEN   --패스워드가 일치한다면
        v_result := 1;
    ELSE                          --패스워드가 일치하지 않는다면
        v_result := 0;
    END IF;
    
    Exception 
        WHEN NO_DATA_FOUND THEN    --그런 아이디가 없다면
            v_result := -1;
END;

--한명의 회원 검색하기
CREATE OR REPLACE PROCEDURE sp_users_select_one
(
    v_userid         IN      Users.userid%TYPE,
    users_record     OUT     SYS_REFCURSOR
)
AS
BEGIN
    OPEN users_record FOR
    SELECT userid, passwd, name, age, gender, flag
    FROM Users
    WHERE userid = v_userid;
END;

--회원삭제
CREATE OR REPLACE PROCEDURE sp_users_delete
(
    v_userid         IN      Users.userid%TYPE
)
IS
BEGIN
    DELETE FROM Users
    WHERE userid = v_userid;
    COMMIT;
END;

-회원정보변경
CREATE OR REPLACE PROCEDURE sp_users_update
(
    v_age            IN      Users.age%TYPE,
    v_userid         IN      Users.userid%TYPE
)
IS
BEGIN
    UPDATE Users
    SET age = v_age
    WHERE userid = v_userid;
    COMMIT;
END;