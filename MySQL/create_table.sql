-- 创建 4 个示例表和索引
CREATE TABLE department
    ( dept_id    INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '部门编号，自增主键'
    , dept_name  VARCHAR(50) NOT NULL COMMENT '部门名称'
    ) ENGINE=InnoDB COMMENT '部门信息表';

CREATE TABLE job
    ( job_id     INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '职位编号，自增主键'
    , job_title  VARCHAR(50) NOT NULL COMMENT '职位名称'
	, min_salary NUMERIC(8,2) NOT NULL COMMENT '最低月薪'
	, max_salary NUMERIC(8,2) NOT NULL COMMENT '最高月薪'
    ) ENGINE=InnoDB COMMENT '职位信息表';

CREATE TABLE employee
    ( emp_id    INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '员工编号，自增主键'
    , emp_name  VARCHAR(50) NOT NULL COMMENT '员工姓名'
    , sex       VARCHAR(10) NOT NULL COMMENT '性别'
    , dept_id   INTEGER NOT NULL COMMENT '部门编号'
    , manager   INTEGER COMMENT '上级经理'
    , hire_date DATE NOT NULL COMMENT '入职日期'
    , job_id    INTEGER NOT NULL COMMENT '职位编号'
    , salary    NUMERIC(8,2) NOT NULL COMMENT '月薪'
    , bonus     NUMERIC(8,2) COMMENT '年终奖金'
    , email     VARCHAR(100) NOT NULL COMMENT '电子邮箱'
	, comments  VARCHAR(500) COMMENT '备注信息'
	, create_by VARCHAR(50) NOT NULL COMMENT '创建者'
	, create_ts TIMESTAMP NOT NULL COMMENT '创建时间'
	, update_by VARCHAR(50) COMMENT '修改者'
	, update_ts TIMESTAMP COMMENT '修改时间'
    , CONSTRAINT ck_emp_sex CHECK (sex IN ('男', '女'))
    , CONSTRAINT ck_emp_salary CHECK (salary > 0)
    , CONSTRAINT uk_emp_email UNIQUE (email)
    , CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id)
    , CONSTRAINT fk_emp_job FOREIGN KEY (job_id) REFERENCES job(job_id)
    , CONSTRAINT fk_emp_manager FOREIGN KEY (manager) REFERENCES employee(emp_id)
    ) ENGINE=InnoDB COMMENT '员工信息表';
CREATE INDEX idx_emp_name ON employee(emp_name);
CREATE INDEX idx_emp_dept ON employee(dept_id);
CREATE INDEX idx_emp_job ON employee(job_id);
CREATE INDEX idx_emp_manager ON employee(manager);

CREATE TABLE job_history
    ( history_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '工作历史编号，自增主键'
	, emp_id     INTEGER NOT NULL COMMENT '员工编号'
	, dept_id    INTEGER NOT NULL COMMENT '部门编号'
    , job_id     INTEGER NOT NULL COMMENT '职位编号'
	, start_date DATE NOT NULL COMMENT '开始日期'
	, end_date   DATE NOT NULL COMMENT '结束日期'
	, CONSTRAINT fk_job_history_emp FOREIGN KEY (emp_id) REFERENCES employee(emp_id)
	, CONSTRAINT fk_job_history_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id)
	, CONSTRAINT fk_job_history_job FOREIGN KEY (job_id) REFERENCES job(job_id)
	, CONSTRAINT check_job_history_date CHECK (end_date >= start_date)
    ) ENGINE=InnoDB COMMENT '员工工作历史记录表';
CREATE INDEX idx_job_history_emp ON job_history(emp_id);
CREATE INDEX idx_job_history_dept ON job_history(dept_id);
CREATE INDEX idx_job_history_job ON job_history(job_id);
