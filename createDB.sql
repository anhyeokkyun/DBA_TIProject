-- Create tablespace
CREATE TABLESPACE PRODUCE
DATAFILE '/home/oracle/logs/produce001.dtf' SIZE 50M
AUTOEXTEND ON NEXT 10M MAXSIZE 3G
EXTENT MANAGEMENT LOCAL
UNIFORM SIZE 256K;

-- Create user
CREATE USER ADMIN IDENTIFIED BY 'ADMIN'
DEFAULT TABLESPACE PRODUCE
PROFILE DEFAULT
ACCOUNT UNLOCK;

-- Grant user permission to start a session
GRANT CREATE SESSION TO ADMIN;

-- Grant user permission to create tables
GRANT CREATE TABLE TO ADMIN;

--Grant access to user
GRANT CONNECT TO ADMIN;

-- Grant user resource privileges to user
GRANT RESOURCE TO ADMIN;

-- Reconnect to reflect changes
DISCONNECT

CONN ADMIN/ADMIN

-- Create all product table
CREATE TABLE "ADMIN"."PROD"("PROD_NO"	NUMBER(12)	NOT NULL	CONSTRAINT PROD_NO_PK	PRIMARY KEY,
			    "QUALITY"	VARCHAR2(10)	NOT NULL,
			    "INP_TIME"	VARCHAR2(100)	NOT NULL,
			    "OUT_TIME"	VARCHAR2(100)	NOT NULL, 
			    "LR_LABEL"	VARCHAR2(10)	NOT NULL)
TABLESPACE PRODUCE;

-- Create defectives table
CREATE TABLE "ADMIN"."DEFECTIVE"("PROD_NO"	NUMBER(12)	NOT NULL,
				 "INP_TIME"	VARCHAR2(100)	NOT NULL,
				 "OUT_TIME"	VARCHAR2(100)	NOT NULL, 
				 "LR_LABEL"	VARCHAR2(10)	NOT NULL,
				 FOREIGN KEY(PROD_NO) REFERENCES PROD(PROD_NO)	ON DELETE CASCADE)
TABLESPACE PRODUCE;

-- Create employee information table
CREATE TABLE "ADMIN"."EMP"("ID"		VARCHAR2(20)	NOT NULL	CONSTRAINT EMP_ID_PK PRIMARY KEY,
			   "PWD"	VARCHAR2(20)	NOT NULL,
			   "EMAIL"	VARCHAR2(50))
TABLESPACE PRODUCE;

-- Create dashboard information table
CREATE TABLE "ADMIN"."DASHBOARD"("PROCESS_NO"		NUMBER(10)	CONSTRAINT DASH_NO_PK PRIMARY KEY, 
				 "PROCESS_COUNT"	NUMBER(20), 
				 "START_TIME"		VARCHAR2(100), 
				 "END_TIME"		VARCHAR2(100), 
				 "ERROR_RATE"		VARCHAR2(20), 
				 "YIELD"		VARCHAR2(20))
TABLESPACE PRODUCE;

-- Create quality index of all product table
CREATE INDEX IDX_PROD_QUALITY ON PROD (QUALITY);


-- Create products number index of DEFECTIVE table
CREATE INDEX IDX_DEF_PROD_NO ON DEFECTIVE (PROD_NO);

-- Create input time index of defective table
CREATE INDEX IDX_DEF_INP_TIME ON DEFECTIVE (INP_TIME);

-- Create identification number sequence of all products
CREATE SEQUENCE SEQ_PROD_PRODID
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 9999999999
NOCYCLE
NOCACHE;

-- Create process number sequence of DASHBOARD table
CREATE SEQUENCE SEQ_DASH_PROCESSNO
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 9999999999
NOCYCLE
NOCACHE;
