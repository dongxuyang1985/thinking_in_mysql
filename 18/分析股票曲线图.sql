-- Oracle 12c
-- 创建股票价格表stock
-- scode代表股票代码、tradedate代表交易日期，price代表收盘价格
CREATE TABLE stock (scode VARCHAR2(10), tradedate DATE, price NUMERIC(6,2));

-- 生成测试数据
ALTER SESSION SET nls_date_format = 'YYYY-MM-DD';
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-01',79);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-02',61);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-03',57);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-04',56);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-05',50);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-06',65);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-07',53);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-08',56);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-09',51);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-10',42);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-11',40);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-12',32);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-13',55);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-14',42);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-15',30);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-16',30);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-17',47);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-18',59);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-19',58);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-20',44);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-21',48);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-22',32);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-23',37);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-24',42);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-25',49);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-26',51);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-27',58);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-28',39);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-29',43);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-30',66);
INSERT INTO stock (scode,tradedate,price) VALUES ('S001','2021-01-31',61);
