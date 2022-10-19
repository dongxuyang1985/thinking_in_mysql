-- 生成 PostgreSQL 初始化数据
INSERT INTO department(dept_name) VALUES ('行政管理部');
INSERT INTO department(dept_name) VALUES ('人力资源部');
INSERT INTO department(dept_name) VALUES ('财务部');
INSERT INTO department(dept_name) VALUES ('研发部');
INSERT INTO department(dept_name) VALUES ('销售部');
INSERT INTO department(dept_name) VALUES ('保卫部');

INSERT INTO job(job_title, min_salary, max_salary) VALUES ('总经理', 24000, 50000);
INSERT INTO job(job_title, min_salary, max_salary) VALUES ('副总经理', 20000, 30000);
INSERT INTO job(job_title, min_salary, max_salary) VALUES ('人力资源总监', 20000, 30000);
INSERT INTO job(job_title, min_salary, max_salary) VALUES ('人力资源专员', 5000, 10000);
INSERT INTO job(job_title, min_salary, max_salary) VALUES ('财务经理', 10000, 20000);
INSERT INTO job(job_title, min_salary, max_salary) VALUES ('会计', 5000, 8000);
INSERT INTO job(job_title, min_salary, max_salary) VALUES ('开发经理', 12000, 20000);
INSERT INTO job(job_title, min_salary, max_salary) VALUES ('程序员', 5000, 12000);
INSERT INTO job(job_title, min_salary, max_salary) VALUES ('销售经理', 8000, 20000);
INSERT INTO job(job_title, min_salary, max_salary) VALUES ('销售人员', 4000, 8000);

INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('刘备', '男', 1, NULL, '2000-01-01', 1, 30000, 10000, 'liubei@shuguo.com', NULL, 'Admin', '2000-01-01 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('关羽', '男', 1, 1, '2000-01-01', 2, 26000, 10000, 'guanyu@shuguo.com', NULL, 'Admin', '2000-01-01 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('张飞', '男', 1, 1, '2000-01-01', 2, 24000, 10000, 'zhangfei@shuguo.com', NULL, 'Admin', '2000-01-01 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('诸葛亮', '男', 2, 1, '2006-03-15', 3, 24000, 8000, 'zhugeliang@shuguo.com', NULL, 'Admin', '2006-03-15 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('黄忠', '男', 2, 4, '2008-10-25', 4, 8000, NULL, 'huangzhong@shuguo.com', NULL, 'Admin', '2008-10-25 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('魏延', '男', 2, 4, '2007-04-01', 4, 7500, NULL, 'weiyan@shuguo.com', NULL, 'Admin', '2007-04-01 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('孙尚香', '女', 3, 1, '2002-08-08', 5, 12000, 5000, 'sunshangxiang@shuguo.com', NULL, 'Admin', '2002-08-08 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('孙丫鬟', '女', 3, 7, '2002-08-08', 6, 6000, NULL, 'sunyahuan@shuguo.com', NULL, 'Admin', '2002-08-08 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('赵云', '男', 4, 1, '2005-12-19', 7, 15000, 6000, 'zhaoyun@shuguo.com', NULL, 'Admin', '2005-12-19 10:00:00', 'Admin', '2006-12-31 10:00:00');
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('廖化', '男', 4, 9, '2009-02-17', 8, 6500, NULL, 'liaohua@shuguo.com', NULL, 'Admin', '2009-02-17 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('关平', '男', 4, 9, '2011-07-24', 8, 6800, NULL, 'guanping@shuguo.com', NULL, 'Admin', '2011-07-24 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('赵氏', '女', 4, 9, '2011-11-10', 8, 6600, NULL, 'zhaoshi@shuguo.com', NULL, 'Admin', '2011-11-10 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('关兴', '男', 4, 9, '2011-07-30', 8, 7000, NULL, 'guanxing@shuguo.com', NULL, 'Admin', '2011-07-30 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('张苞', '男', 4, 9, '2012-05-31', 8, 6500, NULL, 'zhangbao@shuguo.com', NULL, 'Admin', '2012-05-31 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('赵统', '男', 4, 9, '2012-05-03', 8, 6000, NULL, 'zhaotong@shuguo.com', NULL, 'Admin', '2012-05-03 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('周仓', '男', 4, 9, '2010-02-20', 8, 8000, NULL, 'zhoucang@shuguo.com', NULL, 'Admin', '2010-02-20 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('马岱', '男', 4, 9, '2014-09-16', 8, 5800, NULL, 'madai@shuguo.com', NULL, 'Admin', '2014-09-16 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('法正', '男', 5, 2, '2017-04-09', 9, 10000, 5000, 'fazheng@shuguo.com', NULL, 'Admin', '2017-04-09 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('庞统', '男', 5, 18, '2017-06-06', 10, 4100, 2000, 'pangtong@shuguo.com', NULL, 'Admin', '2017-06-06 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('蒋琬', '男', 5, 18, '2018-01-28', 10, 4000, 1500, 'jiangwan@shuguo.com', NULL, 'Admin', '2018-01-28 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('黄权', '男', 5, 18, '2018-03-14', 10, 4200, NULL, 'huangquan@shuguo.com', NULL, 'Admin', '2018-03-14 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('糜竺', '男', 5, 18, '2018-03-27', 10, 4300, NULL, 'mizhu@shuguo.com', NULL, 'Admin', '2018-03-27 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('邓芝', '男', 5, 18, '2018-11-11', 10, 4000, NULL, 'dengzhi@shuguo.com', NULL, 'Admin', '2018-11-11 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('简雍', '男', 5, 18, '2019-05-11', 10, 4800, NULL, 'jianyong@shuguo.com', NULL, 'Admin', '2019-05-11 10:00:00', NULL, NULL);
INSERT INTO employee(emp_name, sex, dept_id, manager, hire_date, job_id, salary, bonus, email, comments, create_by, create_ts, update_by, update_ts) VALUES ('孙乾', '男', 5, 18, '2018-10-09', 10, 4700, NULL, 'sunqian@shuguo.com', NULL, 'Admin', '2018-10-09 10:00:00', NULL, NULL);

INSERT INTO job_history(emp_id, dept_id, job_id, start_date, end_date) VALUES (9, 4, 8, '2005-12-19', '2006-12-31');
