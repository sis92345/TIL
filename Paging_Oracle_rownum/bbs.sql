CREATE SEQUENCE seq_board_bno
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 9999999999
    NOCYCLE;

CREATE TABLE Board
(
    bno         NUMBER(10),
    title       VARCHAR2(200)   CONSTRAINT board_title_nn NOT NULL,
    content     VARCHAR2(2000)   CONSTRAINT board_content_nn NOT NULL,
    email       VARCHAR2(100),
    regdate     DATE   DEFAULT   SYSDATE   CONSTRAINT board_regdate_nn NOT NULL,
    readnum     NUMBER(6)   DEFAULT 0   CONSTRAINT board_readnum_nn NOT NULL,
    userid      VARCHAR2(12)   CONSTRAINT board_userid_nn NOT NULL,
    CONSTRAINT board_bno_pk  PRIMARY KEY(bno),
    CONSTRAINT board_usrid_fk FOREIGN KEY(userid)
    REFERENCES Users(userid)
)