-- 案例分析
-- 创建银行卡信息表bank_card
CREATE TABLE bank_card(
  card_id   VARCHAR(20) NOT NULL PRIMARY KEY, -- 卡号
  user_name VARCHAR(50) NOT NULL, -- 用户名
  balance   NUMERIC(10,4) NOT NULL, -- 余额
  CHECK (balance >= 0)
);
INSERT INTO bank_card VALUES ('62220801', 'A', 1000);
INSERT INTO bank_card VALUES ('62220802', 'B', 0);

-- 创建交易流水表transaction_log
CREATE TABLE transaction_log
(
  log_id      INT AUTO_INCREMENT PRIMARY KEY, -- 交易流水编号，MySQL
  log_id      INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Oracle以及PostgreSQL
  log_id      INT IDENTITY PRIMARY KEY, -- Microsoft SQL Server
  log_ts      TIMESTAMP NOT NULL, -- 交易时间戳
  log_ts      DATETIME2 NOT NULL, -- Microsoft SQL Server
  txn_type    VARCHAR(10) NOT NULL, -- 交易类型
  card_id     VARCHAR(20) NOT NULL, -- 交易卡号
  target_card VARCHAR(20), -- 对方卡号
  amount      NUMERIC(10,4) NOT NULL, -- 金额
  remark      VARCHAR(200), -- 备注
  CHECK (txn_type IN('存款','取现','汇入','转出')),
  CHECK (amount > 0)
);

-- 实现转账功能的存储过程
-- Oracle
CREATE OR REPLACE PROCEDURE transfer_accounts(
  p_from_card IN VARCHAR2, -- 转账卡号
  p_to_card   IN VARCHAR2, -- 对方卡号
  p_amount    IN NUMERIC, -- 转账金额
  p_remark    IN VARCHAR2 -- 备注信息
)
AS
  ln_cnt INTEGER := 0;
BEGIN
  -- 转账金额必须大于零
  IF (p_amount IS NULL OR p_amount <= 0) THEN
    RAISE_APPLICATION_ERROR(-20001, '转账金额必须大于零!');
  END IF;

  -- 检测交易卡号
  SELECT COUNT(*)
  INTO ln_cnt
  FROM bank_card
  WHERE card_id = p_from_card;
  IF (ln_cnt = 0) THEN
    RAISE_APPLICATION_ERROR(-20002, '交易卡号不存在!');
  END IF;

  -- 检测对方卡号
  SELECT COUNT(*)
  INTO ln_cnt
  FROM bank_card
  WHERE card_id = p_to_card;
  IF (ln_cnt = 0) THEN
    RAISE_APPLICATION_ERROR(-20003, '对方卡号不存在!');
  END IF;

  -- 扣除转账卡号内的金额
  UPDATE bank_card
  SET balance = balance - p_amount
  WHERE card_id = p_from_card;

  -- 增加对方卡号内的金额
  UPDATE bank_card
  SET balance = balance + p_amount
  WHERE card_id = p_to_card;

  -- 记录转账交易流水
  INSERT INTO transaction_log(log_ts, txn_type, card_id, target_card, amount, remark)
  VALUES (current_timestamp, '转出', p_from_card, p_to_card, p_amount, p_remark);
  INSERT INTO transaction_log(log_ts, txn_type, card_id, target_card, amount, remark)
  VALUES (current_timestamp, '汇入', p_to_card, p_from_card, p_amount, p_remark);

  COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
END;

-- MySQL
DELIMITER $$

CREATE PROCEDURE transfer_accounts(
  IN p_from_card VARCHAR(20), -- 转账卡号
  IN p_to_card   VARCHAR(20), -- 对方卡号
  IN p_amount    NUMERIC(10,4), -- 转账金额
  IN p_remark    VARCHAR(200) -- 备注信息
)
BEGIN
  DECLARE ln_cnt INTEGER DEFAULT 0;
  
  -- 转账金额必须大于零
  IF (p_amount IS NULL OR p_amount <= 0) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = '转账金额必须大于零!';
  END IF;

  -- 转账交易卡号
  SELECT COUNT(*)
  INTO ln_cnt
  FROM bank_card
  WHERE card_id = p_from_card;
  IF (ln_cnt = 0) THEN
    SIGNAL SQLSTATE '45001'
      SET MESSAGE_TEXT = '交易卡号不存在!';
  END IF;

  -- 转账对方卡号
  SELECT COUNT(*)
  INTO ln_cnt
  FROM bank_card
  WHERE card_id = p_to_card;
  IF (ln_cnt = 0) THEN
    SIGNAL SQLSTATE '45002'
      SET MESSAGE_TEXT = '对方卡号不存在!';
  END IF;

  -- 扣除转账卡号内的金额
  UPDATE bank_card
  SET balance = balance - p_amount
  WHERE card_id = p_from_card;

  -- 增加对方卡号内的金额
  UPDATE bank_card
  SET balance = balance + p_amount
  WHERE card_id = p_to_card;

  -- 记录转账交易流水
  INSERT INTO transaction_log(log_ts, txn_type, card_id, target_card, amount, remark)
  VALUES (current_timestamp, '转出', p_from_card, p_to_card, p_amount, p_remark);
  INSERT INTO transaction_log(log_ts, txn_type, card_id, target_card, amount, remark)
  VALUES (current_timestamp, '汇入', p_to_card, p_from_card, p_amount, p_remark);

END;

DELIMITER ;

-- SQL Server
CREATE OR ALTER PROCEDURE transfer_accounts(
  @p_from_card VARCHAR(20), -- 转账卡号
  @p_to_card   VARCHAR(20), -- 对方卡号
  @p_amount    NUMERIC(10,4), -- 转账金额
  @p_remark    VARCHAR(200) -- 备注信息
)
AS
BEGIN
  DECLARE @ln_cnt INTEGER = 0;
  
  -- 转账金额必须大于零
  IF (@p_amount IS NULL OR @p_amount <= 0)
  BEGIN 
	RAISERROR('转账金额必须大于零!', 11, 1);
  END;

  -- 转账交易卡号
  SELECT @ln_cnt = COUNT(*)
  FROM bank_card
  WHERE card_id = @p_from_card;
  IF (@ln_cnt = 0)
  BEGIN
    RAISERROR('交易卡号不存在!', 11, 2);
  END;

  -- 转账对方卡号
  SELECT @ln_cnt = COUNT(*)
  FROM bank_card
  WHERE card_id = @p_to_card;
  IF (@ln_cnt = 0)
  BEGIN
    RAISERROR('交易卡号不存在!', 11, 3);
  END;

  -- 扣除转账卡号内的金额
  UPDATE bank_card
  SET balance = balance - @p_amount
  WHERE card_id = @p_from_card;

  -- 增加对方卡号内的金额
  UPDATE bank_card
  SET balance = balance + @p_amount
  WHERE card_id = @p_to_card;

  -- 记录转账交易流水
  INSERT INTO transaction_log(log_ts, txn_type, card_id, target_card, amount, remark)
  VALUES (current_timestamp, '转出', @p_from_card, @p_to_card, @p_amount, @p_remark);
  INSERT INTO transaction_log(log_ts, txn_type, card_id, target_card, amount, remark)
  VALUES (current_timestamp, '汇入', @p_to_card, @p_from_card, @p_amount, @p_remark);

END;

-- PostgreSQL
CREATE OR REPLACE PROCEDURE transfer_accounts(
  p_from_card IN VARCHAR, -- 转账卡号
  p_to_card   IN VARCHAR, -- 对方卡号
  p_amount    IN NUMERIC, -- 转账金额
  p_remark    IN VARCHAR -- 备注信息
)
LANGUAGE plpgsql
AS $$
  DECLARE ln_cnt INTEGER := 0;
BEGIN
  -- 转账金额必须大于零
  IF (p_amount IS NULL OR p_amount <= 0) THEN
    RAISE EXCEPTION '转账金额必须大于零!';
  END IF;

  -- 检测交易卡号
  SELECT COUNT(*)
  INTO ln_cnt
  FROM bank_card
  WHERE card_id = p_from_card;
  IF (ln_cnt = 0) THEN
    RAISE EXCEPTION '交易卡号不存在!';
  END IF;

  -- 检测对方卡号
  SELECT COUNT(*)
  INTO ln_cnt
  FROM bank_card
  WHERE card_id = p_to_card;
  IF (ln_cnt = 0) THEN
    RAISE EXCEPTION '对方卡号不存在!';
  END IF;

  -- 扣除转账卡号内的金额
  UPDATE bank_card
  SET balance = balance - p_amount
  WHERE card_id = p_from_card;

  -- 增加对方卡号内的金额
  UPDATE bank_card
  SET balance = balance + p_amount
  WHERE card_id = p_to_card;

  -- 记录转账交易流水
  INSERT INTO transaction_log(log_ts, txn_type, card_id, target_card, amount, remark)
  VALUES (current_timestamp, '转出', p_from_card, p_to_card, p_amount, p_remark);
  INSERT INTO transaction_log(log_ts, txn_type, card_id, target_card, amount, remark)
  VALUES (current_timestamp, '汇入', p_to_card, p_from_card, p_amount, p_remark);

END;
$$
