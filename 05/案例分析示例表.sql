-- 创建员工联系电话表emp_contact
CREATE TABLE emp_contact(
  emp_id          INT NOT NULL PRIMARY KEY, -- 员工编号
  work_phone      VARCHAR(20), -- 工作电话
  mobile_phone    VARCHAR(20), -- 移动电话
  home_phone      VARCHAR(20), -- 家庭电话
  emergency_phone VARCHAR(20) -- 紧急联系人电话
);

-- 插入测试数据
INSERT INTO emp_contact VALUES (1, '010-61231111', NULL, NULL, NULL);
INSERT INTO emp_contact VALUES (2, NULL, '13222222222', NULL, NULL);
INSERT INTO emp_contact VALUES (3, NULL, NULL, NULL, '13123450000');
INSERT INTO emp_contact VALUES (4, NULL, NULL, '010-61234444', NULL);
INSERT INTO emp_contact VALUES (5, NULL, NULL, NULL, NULL);
