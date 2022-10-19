-- 创建 4 个示例表和索引
CREATE TABLE department
    ( dept_id    INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY
    , dept_name  VARCHAR(50) NOT NULL
    ) ;
COMMENT ON TABLE department IS '部门信息表';
COMMENT ON COLUMN department.dept_id IS '部门编号，自增主键';
COMMENT ON COLUMN department.dept_name IS '部门名称';

CREATE TABLE job
    ( job_id     INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY
    , job_title  VARCHAR(50) NOT NULL
	, min_salary NUMERIC(8,2) NOT NULL
	, max_salary NUMERIC(8,2) NOT NULL
    ) ;
COMMENT ON TABLE job IS '职位信息表';
COMMENT ON COLUMN job.job_id IS '职位编号，自增主键';
COMMENT ON COLUMN job.job_title IS '职位名称';
COMMENT ON COLUMN job.min_salary IS '最低月薪';
COMMENT ON COLUMN job.max_salary IS '最高月薪';

CREATE TABLE employee
    ( emp_id    INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY
    , emp_name  VARCHAR(50) NOT NULL
    , sex       VARCHAR(10) NOT NULL
    , dept_id   INTEGER NOT NULL
    , manager   INTEGER
    , hire_date DATE NOT NULL
    , job_id    INTEGER NOT NULL
    , salary    NUMERIC(8,2) NOT NULL
    , bonus     NUMERIC(8,2)
    , email     VARCHAR(100) NOT NULL
	, comments  VARCHAR(500)
	, create_by VARCHAR(50) NOT NULL
	, create_ts TIMESTAMP NOT NULL
	, update_by VARCHAR(50)
	, update_ts TIMESTAMP
    , CONSTRAINT ck_emp_sex CHECK (sex IN ('男', '女'))
    , CONSTRAINT ck_emp_salary CHECK (salary > 0)
    , CONSTRAINT uk_emp_email UNIQUE (email)
    , CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id)
    , CONSTRAINT fk_emp_job FOREIGN KEY (job_id) REFERENCES job(job_id)
    , CONSTRAINT fk_emp_manager FOREIGN KEY (manager) REFERENCES employee(emp_id)
    ) ;
COMMENT ON TABLE employee IS '员工信息表';
COMMENT ON COLUMN employee.emp_id IS '员工编号，自增主键';
COMMENT ON COLUMN employee.emp_name IS '员工姓名';
COMMENT ON COLUMN employee.sex IS '性别';
COMMENT ON COLUMN employee.dept_id IS '部门编号';
COMMENT ON COLUMN employee.manager IS '上级经理';
COMMENT ON COLUMN employee.hire_date IS '入职日期';
COMMENT ON COLUMN employee.job_id IS '职位编号';
COMMENT ON COLUMN employee.salary IS '月薪';
COMMENT ON COLUMN employee.bonus IS '年终奖金';
COMMENT ON COLUMN employee.email IS '电子邮箱';
COMMENT ON COLUMN employee.comments IS '备注信息';
COMMENT ON COLUMN employee.create_by IS '创建者';
COMMENT ON COLUMN employee.create_ts IS '创建时间';
COMMENT ON COLUMN employee.update_by IS '修改者';
COMMENT ON COLUMN employee.update_ts IS '修改时间';
CREATE INDEX idx_emp_name ON employee(emp_name);
CREATE INDEX idx_emp_dept ON employee(dept_id);
CREATE INDEX idx_emp_job ON employee(job_id);
CREATE INDEX idx_emp_manager ON employee(manager);

CREATE TABLE job_history
    ( history_id INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL PRIMARY KEY
	, emp_id     INTEGER NOT NULL
	, dept_id    INTEGER NOT NULL
    , job_id     INTEGER NOT NULL
	, start_date DATE NOT NULL
	, end_date   DATE NOT NULL
	, CONSTRAINT fk_job_history_emp FOREIGN KEY (emp_id) REFERENCES employee(emp_id)
	, CONSTRAINT fk_job_history_dept FOREIGN KEY (dept_id) REFERENCES department(dept_id)
	, CONSTRAINT fk_job_history_job FOREIGN KEY (job_id) REFERENCES job(job_id)
	, CONSTRAINT check_job_history_date CHECK (end_date >= start_date)
    ) ;
COMMENT ON TABLE job_history IS '员工工作历史记录表';
COMMENT ON COLUMN job_history.history_id IS '工作历史编号，自增主键';
COMMENT ON COLUMN job_history.emp_id IS '员工编号';
COMMENT ON COLUMN job_history.dept_id IS '部门编号';
COMMENT ON COLUMN job_history.job_id IS '职位编号';
COMMENT ON COLUMN job_history.start_date IS '开始日期';
COMMENT ON COLUMN job_history.end_date IS '结束日期';
CREATE INDEX idx_job_history_emp ON job_history(emp_id);
CREATE INDEX idx_job_history_dept ON job_history(dept_id);
CREATE INDEX idx_job_history_job ON job_history(job_id);
