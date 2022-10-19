-- 创建 4 个示例表和索引
CREATE TABLE department -- 部门信息表
    ( dept_id    INTEGER NOT NULL PRIMARY KEY -- 部门编号，自增主键
    , dept_name  VARCHAR(50) NOT NULL -- 部门名称
    ) ;

CREATE TABLE job -- 职位信息表
    ( job_id     INTEGER NOT NULL PRIMARY KEY -- 职位编号，自增主键
    , job_title  VARCHAR(50) NOT NULL -- 职位名称
	, min_salary NUMERIC(8,2) NOT NULL -- 最低月薪
	, max_salary NUMERIC(8,2) NOT NULL -- 最高月薪
    ) ;

CREATE TABLE employee -- 员工信息表
    ( emp_id    INTEGER NOT NULL PRIMARY KEY -- 员工编号，自增主键
    , emp_name  VARCHAR(50) NOT NULL -- 员工姓名
    , sex       VARCHAR(10) NOT NULL -- 性别
    , dept_id   INTEGER NOT NULL -- 部门编号
    , manager   INTEGER -- 上级经理
    , hire_date DATE NOT NULL -- 入职日期
    , job_id    INTEGER NOT NULL -- 职位编号
    , salary    NUMERIC(8,2) NOT NULL -- 月薪
    , bonus     NUMERIC(8,2) -- 年终奖金
    , email     VARCHAR(100) NOT NULL -- 电子邮箱
	, comments  VARCHAR(500) -- 备注信息
	, create_by VARCHAR(50) NOT NULL -- 创建者
	, create_ts DATETIME NOT NULL -- 创建时间
	, update_by VARCHAR(50) -- 修改者
	, update_ts DATETIME -- 修改时间
    , CONSTRAINT ck_emp_sex CHECK (sex IN ('男', '女'))
    , CONSTRAINT ck_emp_salary CHECK (salary > 0)
    , CONSTRAINT uk_emp_email UNIQUE (email)
    , CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id)
    , CONSTRAINT fk_emp_job FOREIGN KEY (job_id) REFERENCES job(job_id)
    , CONSTRAINT fk_emp_manager FOREIGN KEY (manager) REFERENCES employee(emp_id)
    ) ;
CREATE INDEX idx_emp_name ON employee(emp_name);
CREATE INDEX idx_emp_dept ON employee(dept_id);
CREATE INDEX idx_emp_job ON employee(job_id);
CREATE INDEX idx_emp_manager ON employee(manager);

CREATE TABLE job_history -- 员工工作历史记录表
    ( history_id INTEGER NOT NULL PRIMARY KEY -- 工作历史编号，自增主键
	, emp_id     INTEGER NOT NULL -- 员工编号
	, dept_id    INTEGER NOT NULL -- 部门编号
    , job_id     INTEGER NOT NULL -- 职位编号
	, start_date DATE NOT NULL -- 开始日期
	, end_date   DATE NOT NULL -- 结束日期
	, CONSTRAINT fk_job_history_emp FOREIGN KEY (emp_id) REFERENCES employee(emp_id)
	, CONSTRAINT fk_job_history_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id)
	, CONSTRAINT fk_job_history_job FOREIGN KEY (job_id) REFERENCES job(job_id)
	, CONSTRAINT check_job_history_date CHECK (end_date >= start_date)
    ) ;
CREATE INDEX idx_job_history_emp ON job_history(emp_id);
CREATE INDEX idx_job_history_dept ON job_history(dept_id);
CREATE INDEX idx_job_history_job ON job_history(job_id);
