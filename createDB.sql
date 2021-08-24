-- Create Tablespace
CREATE TABLESPACE PRODUCE
DATAFILE '/home/oracle/logs/produce001.dtf' SIZE 50M
AUTOEXTEND ON NEXT 10M MAXSIZE 3G
EXTENT MANAGEMENT LOCAL
UNIFORM SIZE 256K;

-- Create User
CREATE USER ADMIN IDENTIFIED BY 'ADMIN'
DEFAULT TABLESPACE PRODUCE
PROFILE DEFAULT
ACCOUNT UNLOCK;

--유저에게 세션을 시작할 권한 부여
GRANT CREATE SESSION TO ADMIN;

--유저에게 테이블을 생성할 권한 부여
GRANT CREATE TABLE TO ADMIN;

--유저에게 접속 권한 부여
GRANT CONNECT TO ADMIN;

--테이블 만들 권한 부여
GRANT RESOURCE TO ADMIN;

--재접속 해야 반영

DISCONNECT

CONN ADMIN/ADMIN

--전체 제품 데이터 테이블 생성
CREATE TABLE "ADMIN"."PROD"(
		"PROD_NO" NUMBER(12) NOT NULL CONSTRAINT PROD_NO_PK PRIMARY KEY, --PK
		"QUALITY" VARCHAR2(10) NOT NULL,
		"INP_TIME" VARCHAR2(100) NOT NULL,
		"OUT_TIME" VARCHAR2(100) NOT NULL, 
		"LR_LABEL" VARCHAR2(10) NOT NULL
) TABLESPACE PRODUCE;


--불량품 데이터 테이블 생성
CREATE TABLE "ADMIN"."DEFECTIVE"(
		"PROD_NO" NUMBER(12) NOT NULL, --FK
		"INP_TIME" VARCHAR2(100) NOT NULL,
		"OUT_TIME" VARCHAR2(100) NOT NULL, 
		"LR_LABEL" VARCHAR2(10) NOT NULL,
		FOREIGN KEY (PROD_NO) REFERENCES PROD(PROD_NO)
        ON DELETE CASCADE
) TABLESPACE PRODUCE;


--관리자 정보 테이블 생성
CREATE TABLE "ADMIN"."EMP"(
		"ID" VARCHAR2(20) NOT NULL CONSTRAINT EMP_ID_PK PRIMARY KEY,
		"PWD" VARCHAR2(20) NOT NULL,
		"EMAIL" VARCHAR2(50)
)	TABLESPACE PRODUCE;


--전체 제품 인덱스 생성
--CREATE INDEX IDX_PROD_PROD_NO ON PROD (PROD_NO);
--(PROD_ID_PK와 중복)//테이블 생성했을 때 PK 제약조건 넣어서 생김.

CREATE INDEX IDX_PROD_QUALITY ON PROD (QUALITY);


--불량품 인덱스 생성
CREATE INDEX IDX_DEF_PROD_NO ON DEFECTIVE (PROD_NO);

CREATE INDEX IDX_DEF_INP_TIME ON DEFECTIVE (INP_TIME);

--시퀀스 생성
CREATE SEQUENCE SEQ_PROD_PRODID
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 9999999999
NOCYCLE
CACHE 100;