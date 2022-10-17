-- 创建销量表sales_monthly
-- product表示产品名称，ym表示年月，amount表示销售金额（元）
CREATE TABLE sales_monthly(product VARCHAR(20), ym VARCHAR(10), amount NUMERIC(10, 2));

-- 生成测试数据
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201801',10159.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201802',10211.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201803',10247.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201804',10376.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201805',10400.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201806',10565.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201807',10613.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201808',10696.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201809',10751.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201810',10842.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201811',10900.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201812',10972.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201901',11155.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201902',11202.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201903',11260.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201904',11341.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201905',11459.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('苹果','201906',11560.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201801',10138.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201802',10194.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201803',10328.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201804',10322.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201805',10481.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201806',10502.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201807',10589.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201808',10681.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201809',10798.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201810',10829.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201811',10913.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201812',11056.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201901',11161.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201902',11173.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201903',11288.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201904',11408.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201905',11469.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('香蕉','201906',11528.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201801',10154.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201802',10183.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201803',10245.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201804',10325.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201805',10465.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201806',10505.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201807',10578.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201808',10680.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201809',10788.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201810',10838.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201811',10942.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201812',10988.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201901',11099.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201902',11181.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201903',11302.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201904',11327.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201905',11423.00);
INSERT INTO sales_monthly (product,ym,amount) VALUES ('桔子','201906',11524.00);


-- 创建银行交易日志表transfer_log
-- Oracle、MySQL、PostgreSQL以及SQLite
CREATE TABLE transfer_log
( log_id    INTEGER NOT NULL PRIMARY KEY, -- 交易日志编号
  log_ts    TIMESTAMP NOT NULL, -- 交易时间
  from_user VARCHAR(50) NOT NULL, -- 交易发起账号
  to_user   VARCHAR(50), -- 交易接收账号
  type      VARCHAR(10) NOT NULL, -- 交易类型
  amount    NUMERIC(10) NOT NULL -- 交易金额（元）
);

-- SQL Server
CREATE TABLE transfer_log
( log_id    INTEGER NOT NULL PRIMARY KEY, -- 交易日志编号
  log_ts    DATETIME2 NOT NULL, -- 交易时间
  from_user VARCHAR(50) NOT NULL, -- 交易发起账号
  to_user   VARCHAR(50), -- 交易接收账号
  type      VARCHAR(10) NOT NULL, -- 交易类型
  amount    NUMERIC(10) NOT NULL -- 交易金额（元）
);

-- 生成测试数据
-- Oracle 需要执行以下ALTER语句
-- ALTER SESSION SET nls_timestamp_format = 'YYYY-MM-DD HH24:MI:SS';
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (1,'2021-01-02 10:31:40','62221234567890',NULL,'存款',50000);
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (2,'2021-01-02 10:32:15','62221234567890',NULL,'存款',100000);
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (3,'2021-01-03 08:14:29','62221234567890','62226666666666','转账',200000);
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (4,'2021-01-05 13:55:38','62221234567890','62226666666666','转账',150000);
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (5,'2021-01-07 20:00:31','62221234567890','62227777777777','转账',300000);
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (6,'2021-01-09 17:28:07','62221234567890','62227777777777','转账',500000);
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (7,'2021-01-10 07:46:02','62221234567890','62227777777777','转账',100000);
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (8,'2021-01-11 09:36:53','62221234567890',NULL,'存款',40000);
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (9,'2021-01-12 07:10:01','62221234567890','62228888888881','转账',10000);
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (10,'2021-01-12 07:11:12','62221234567890','62228888888882','转账',8000);
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (11,'2021-01-12 07:12:36','62221234567890','62228888888883','转账',5000);
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (12,'2021-01-12 07:13:55','62221234567890','62228888888884','转账',6000);
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (13,'2021-01-12 07:14:24','62221234567890','62228888888885','转账',7000);
INSERT INTO transfer_log (log_id,log_ts,from_user,to_user,type,amount) VALUES (14,'2021-01-21 12:11:16','62221234567890','62228888888885','转账',70000);
