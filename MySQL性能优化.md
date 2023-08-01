# 第一部分、库表结构优化

## 1.1 数据库设计

不规范的数据库设计存在数据冗余以及插入、更新、删除异常问题。

![在这里插入图片描述](https://img-blog.csdnimg.cn/d0dae7f9d2f7445b989eb9659f01adfa.png#pic_center)

规范化（Normalization）是数据库设计的一系列原理和技术，主要用于减少表中数据的冗余，增加完整性和一致性，同时使得数据库易于维护和扩展。

![在这里插入图片描述](https://img-blog.csdnimg.cn/72b1dbdc0e7840c38b5f2723b2a79475.png#pic_center)

对于大多数的数据库系统而言，到达第三范式就已经足够了。也就是说，表需要定义主键，表中的字段都是不可再分的单一属性。非主键字段必须完全依赖于主键，不能只依赖于主键的一部分。属性不依赖于其它的非主属性。

对于前三个范式而言，只需要将不同的实体/对象单独存储到一张表中，并且通过外键建立它们之间的联系即可满足。

![在这里插入图片描述](https://img-blog.csdnimg.cn/1cd053328f604e4fbbd7d531f314ca02.png#pic_center)

规范化可能导致连接查询（JOIN）过多，从而降低数据库的性能。因此，有时候为了提高某些查询或者应用的性能而故意降低规范反的程度，也就是反规范化。

常用的反规范化方法包括：

 - 增加冗余字段；
 - 增加计算列；
 - 将小表合成大表等。

例如，想要知道每个部门的员工数量，需要同时连接部门表和员工表；可以在部门表中增加一个字段（emp_numbers），查询时就不需要再连接员工表，但是每次增加或者删除员工时需要更新该字段。

反规范化可能带来数据完整性的问题；因此，通常我们应该先进行规范化设计，再根据实际情况考虑是否需要反规范化。一般来说，数据仓库（Data Warehouse）和在线分析系统（OLAP）会使用到反规范化的技术，因为它们以复杂查询和报表分析为主。

> 📚推荐图书：《数据库系统概念（第七版）》。

## 1.2 选择数据类型

<img src="https://img-blog.csdnimg.cn/3fc06f1263f8443daf02712303e42233.png" style="zoom: 40%;" />

我们在选择字段的数据类型时，首先应该满足存储业务数据的要求，其次还需要考虑性能和使用的便捷性。

一般来说，我们可以先确定基本的类型：

 - 文本数据使用字符串类型进行存储。

 - 数值数据，尤其是需要进行算术运算的数据，使用数字类型。

 - 日期和时间信息最好使用原生的日期时间类型。

 - 文档、图片、音频和视频等使用二进制类型。推荐存储在文件服务器上，数据库中存储文件的路径。

然后进一步确定具体的数据类型。

**在满足数据存储和扩展的前提下，尽量使用更小的数据类型**。这样可以节省一些存储，通常性能也会更好。例如，对于一个小型公司而言，员工人数通常不会超过几百，可以使用SMALLINT类型存储员工编号。

**尽量避免使用NULL属性**。NULL需要更多的存储和额外的处理，尽量使用NOT NULL加上默认值。

**如果一个字段同时出现在多个表中，我们应该使用相同的数据类型**。例如，员工表中的部门编号（dept\_id）字段与部门表的编号（dept\_id）字段应该保持名称和类型一致。

## 1.3 数字类型

### 1.3.1 整数类型

MySQL支持TINYINT、SMALLINT、MEDIUMINT、INT（INTEGER）以及BIGINT整数类型。如果为整数类型指定了UNSIGNED属性，可以存储的正整数范围将会扩大一倍。

| 数字类型  | 存储（字节） | 有符号类型最小值 | 有符号类型最大值 | 无符号类型最小值 | 无符号类型最大值 |
| :-------: | :----------: | :--------------: | :--------------: | :--------------: | :--------------: |
|  TINYINT  |      1       |       -128       |       127        |        0         |       255        |
| SMALLINT  |      2       |      -32768      |      32767       |        0         |      65535       |
| MEDIUMINT |      3       |     -8388608     |     8388607      |        0         |     16777215     |
|    INT    |      4       |   -2147483648    |    2147483647    |        0         |    4294967295    |
|  BIGINT   |      8       |      2^63^       |     2^63^-1      |        0         |     2^64^-1      |

> ⚠️MySQL 8.0.17开始，整数类型的显示宽度（例如INT(10)）和ZEROFILL选项已经被弃用，将来的版本中会删除。

### 1.3.2 实数类型

MySQL提供了精确数字类型DECIMAL，也支持浮点数类型FLOAT和DOUBLE。

DECIMAL(p, s)用于存储对精度要求严格的数据，例如财务。其中精度p表示总的有效位数，刻度s表示小数点后允许的位数。例如，123.04的精度为5，刻度为2。

> DECIMAL使用二进制格式存储，每9个数字使用4字节表示。NUMERIC是DECIMAL的同义词。

FLOAT是单精度浮点数，需要4字节存储空间；DOUBLE是双精度浮点数，需要8字节存储空间。浮点数使用近似运算，速度比DECIMAL更快但可能丢失精度。

```sql
CREATE TABLE t(d1 DOUBLE, d2 DOUBLE);
INSERT INTO t(d1, d2) VALUES (101.40, 80.0);

SELECT *
FROM t 
WHERE d1-d2=21.4; -- 101.40-80.0
d1|d2|
--+--+
```

> 💡一种折衷的方案是使用BIGINT替代DECIMAL存储财务数据。例如要存储精确到万分之一分的金额，可以将数据乘以100万倍之后存储到BIGINT，可以减少存储并优化计算性能，不过应用程序可能需要增加额外的处理。

## 1.4 字符串类型

MySQL字符串类型用于存储字符和字符串数据，包括二进制数据，例如图片或者文件。字符串数据可以支持比较运算符和模式匹配运算符，例如LIKE、正则表达式匹配以及全文检索。

MySQL支持的字符串类型包括CHAR、VARCHAR、BINARY、VARBINARY、BLOB、TEXT、ENUM以及SET。其中 CHAR、VARCHAR、TEXT、ENUM 以及SET包含字符集和排序规则属性，默认继承表的字符集和排序规则。MySQL 8.0默认使用utf8mb4字符集。

### 1.4.1 CHAR与VARCHAR

CHAR(n)类型表示长度固定的字符串，n表示字符的最大数量，取值范围从0到255。如果输入的字符串长度不够，将会使用空格进行填充。默认情况下没有设置SQL模式PAD\_CHAR\_TO\_FULL\_LENGTH，MySQL读取CHAR字段时自动截断了尾部的空格。

```sql
CREATE TABLE t (c1 CHAR, c5 CHAR(5));
INSERT INTO t VALUES ('a','a');

mysql> select concat(c1, '!'), concat(c5, '!') from t;
+-----------------+-----------------+
| concat(c1, '!') | concat(c5, '!') |
+-----------------+-----------------+
| a!              | a!              |
+-----------------+-----------------+

mysql> SET sql_mode = 'PAD_CHAR_TO_FULL_LENGTH';
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> select concat(c1, '!'), concat(c5, '!') from t;
+-----------------+-----------------+
| concat(c1, '!') | concat(c5, '!') |
+-----------------+-----------------+
| a!              | a    !          |
+-----------------+-----------------+

mysql> SET sql_mode = default;
```

MySQL使用比较运算符（=、<>、>、< 等）和LIKE操作符比较和匹配CHAR数据时不考虑尾部空格。例如：

```sql
mysql> select c5 from t where c5='a';
+------+
| c2   |
+------+
| a    |
+------+

mysql> select c5 from t where c5 like 'a    ';
Empty set (0.00 sec)
```

> ⚠️通常来说，只有存储固定长度的数据时，才会考虑使CHAR类型。例如18位身份证，6位邮政编码等。

VARCHAR(n)存储可变长度的字符串，n表示字符的最大数量，取值范围从0到65535。VARCHAR需要额外的1或者2字节存储字符串的长度，最大长度小于等于255时额外需要1字节，否则需要2字节。

VARCHAR字段的实际最大长度受限于最大的行大小（65536字节，所有字段长度之和）以及字符集。例如，utf8mb4字符集中的一个字符最多占用4个字节，因此这种字符集的VARCHAR字段可以声明的最大长度为16383。

```sql
DROP TABLE IF EXISTS t;
CREATE TABLE t (c VARCHAR(16384));
SQL Error [1074] [42000]: Column length too big for column 'c' (max = 16383); use BLOB or TEXT instead
```

VARCHAR存储实际的内容，比CHAR更节省空间，但是可能会因为更新导致页分裂。

> 💡对于文本数据，优先使用VARCHAR类型。例如名字、电子邮箱、产品描述等。

### 1.4.2 BINARY与VARBINARY

BINARY(M)和VARBINARY(M)类型与CHAR和VARCHAR类型类似，但是存储的内容为二进制字节串，而不是普通字符串。其中M表示最大的字节长度，分别为255和65535。这两种类型使用binary字符集和排序规则，基于字节数值进行比较和排序。

存储BINARY数据时，在尾部使用0x00（字节0）填充到指定长度，查询时不会删除尾部的0字节。所有的字节对应比较操作都有意义，包括ORDER BY和DISTINCT操作，0x00和空格比较的结果不相等，0x00的排序在空格前面。

```sql
DROP TABLE IF EXISTS t;
CREATE TABLE t (c BINARY(3));
INSERT INTO t VALUES ('a');

mysql> SELECT * FROM t where c='a';
Empty set (0.00 sec)

mysql> SELECT * FROM t where c='a\0\0';
+------------+
| c          |
+------------+
| 0x610000   |
+------------+
```

存储VARBINARY数据时，不会使用0x00（字节0）填充，查询时不会删除尾部的0字节。所有的字节对应比较操作都有意义，包括ORDER BY和DISTINCT操作，0x00和空格比较的结果不相等，0x00的排序在空格前面。

> BINARY(M)和VARBINARY(M)类型与CHAR和VARCHAR类型的存储需求也类似，但是以字节为单位。比较时也是按照字节进行，速度更快。

### 1.4.3 TEXT与BLOB

TEXT类型可以用于存储长文本字符串，长度支持1字节到4GB。MySQL不会在服务器内存中缓存TEXT数据，而是从磁盘中读取，所有访问时比CHAR和VARCHAR类型更慢一些。MySQL插入或者查询时不会对TEXT数据尾部空格进行任何处理。

MySQL提供了4种形式的TEXT类型：TINYTEXT、TEXT、MEDIUMTEXT以及LONGTEXT。

*   TINYTEXT，最大长度为255个字节，类似于VARCHAR(255)。每个TINYTEXT值需要1字节额外的存储表示长度；
*   TEXT（SAMLLTEXT），最大长度为64KB，类似于VARCHAR(65535)。每个TEXT值需要2字节额外的存储表示长度；&#x20;
*   MEDIUMTEXT，最大长度为16MB。每个MEDIUMTEXT值需要3字节额外的存储表示长度；
*   LONGTEXT，最大长度为4GB。每个LONGTEXT值需要4字节额外的存储表示长度。

> 💡TEXT数据类型一般用于存储文章内容、产品文档等信息。只有在普通字符串类型的长度无法满足时才会考虑使用TEXT类型，推荐单独使用一个表存储这种字段。

BLOB类型可以用于存储二进制大对象，长度支持1字节到4GB；BLOB类型使用binary字符集和排序规则，基于字节数值进行比较和排序。MySQL不会在服务器内存中缓存BLOB数据，而是从磁盘中读取，所有访问时比BINARY和VARBINARY类型更慢一些。MySQL插入或者查询时不会对BLOB数据尾部空格进行任何处理。&#x20;

MySQL提供了4种形式的BLOB类型：TINYBLOB、BLOB、MEDIUMBLOB以及LONGBLOB。

*   TINYBLOB，最大长度为255个字节，类似于VARBINARY(255)。每个TINYBLOB值需要1字节额外的存储表示长度；
*   BLOB（SMALLBLOB），最大长度为64KB，类似于VARBINARY(65535)。每个BLOB值需要2字节额外的存储表示长度；
*   MEDIUMBLOB，最大长度为16MB。每个MEDIUMBLOB值需要3字节额外的存储表示长度；
*   LONGBLOB，最大长度为4GB。每个LONGBLOB值需要4字节额外的存储表示长度。

MySQL使用独立的“外部存储”处理TEXT和BLOB数据，而且只对数据的max\_sort\_length字节进行排序，不支持完整数据的索引和排序。

> ⚠️BLOB 数据类型一般用于存储图片、文档、视频等信息，但是不建议这样使用。推荐使用单独的对象存储二进制内容，并且在数据库中保存文件路径。

### 1.4.4 ENUM类型

ENUM(‘value1’,‘value2’,…)类型定义了一个枚举，即取值限定为‘value1’、‘value2’、…、NULL或者‘’之一的字符串对象。ENUM数据在内部使用整数表示，最多包含65535个不同的值。

每个枚举元素最大的长度为M<=255并且(M\*w) <=1020，其中M是元素的字面长度，w是字符集中字符可能占用的最大字节数。

使用枚举类型的优势在于：

*   在字段的取值有限时提供紧凑的数据存储，枚举在内部使用整数表示，需要1字节或2字节存储；
*   查询结果的可读性，内部整数在查询结果中显示为相应的字符串。

```sql
CREATE TABLE shirts (
name VARCHAR(40),
size ENUM('x-small', 'small', 'medium', 'large', 'x-large')
);
INSERT INTO shirts (name, size) VALUES ('dress shirt','large'), ('t-shirt','medium'), ('polo shirt','small');

SELECT name, size FROM shirts WHERE size = 'medium';
+---------+--------+
| name    | size   |
+---------+--------+
| t-shirt | medium |
+---------+--------+
```

如果插入100万条‘medium’数据，需要100万字节存储；如果直接使用VARCHAR类型，需要6倍存储。

使用枚举类型时需要注意枚举值的排序使用内部的索引数字，而不是字符串。例如，对于ENUM(‘b’, ‘a’)字符b排在a之前。枚举类型和字符串类型的连接查询性能更慢。

```sql
SELECT name, size, size+0 FROM shirts
ORDER BY size;
+----------+--------+--------+
name       | size   | size+0 |
+----------+--------+--------+
polo shirt | small  | 2      |
t-shirt    | medium | 3      |
dress shirt| large  | 4      |
+----------+--------+--------+
```

> ⚠️不推荐使用ENUM类型，可以使用查找表。MySQL 8.0支持CHECK约束，也可以实现相同的效果。

### 1.4.5 SET类型

SET(‘value1’,‘value2’,…)类型定义了一个集合，即取值限定为‘value1’、‘value2’、…中零个或多个的字符串对象。SET数据在内部使用整数表示，最多包含64个不同的成员。

每个集合元素最大的长度为M<=255并且(M\*w)<=1020，其中M是元素的字面长度，w是字符集中字符可能占用的最大字节数。

```sql
DROP TABLE IF EXISTS t;
CREATE TABLE t (c SET('read','write'));
INSERT INTO t VALUES (''),('read'),('write'),('read,write');

mysql> SELECT c+0 FROM t;
+------+
| c+0  |
+------+
|    0 |
|    1 |
|    2 |
|    3 |
+------+
```

SET对象的存储空间由集合成员的个数决定；如果个数为N，对象占用(N+7)/8字节，向上取整为1、2、3、4或者8字节。

MySQL提供了FIND_IN_SET、FIELD等函数，方便了SET数据类型的使用。

> 💡SET类型的一个典型应用时访问控制列表（ACL）。

## 1.5 日期时间类型

MySQL 提供了以下存储日期时间值的数据类型：DATE、TIME、DATETIME、TIMESTAMP以及YEAR。其中，TIME、DATETIME、TIMESTAMP支持小数秒，最多6位小数（微秒）。

### 1.5.1 日期类型

DATE表示日期类型，支持的范围从 '1000-01-01' 到 '9999-12-31'，占用3个字节。DATE数据的显示格式为 'YYYY-MM-DD'。例如：

```sql
DROP TABLE IF EXISTS t;
CREATE TABLE t(birth_date date);
INSERT INTO t VALUES ('2023-04-01');

mysql> SELECT * FROM t;
+------------+
| birth_date |
+------------+
| 2023-04-01 |
+------------+
```

MySQL使用4位数字存储日期数据中的年份，如果输入2位年份，将会使用以下规则：

 - 00~69之间的年份转换为2000~2069；
 - 70~99之间的年份转换为1970~1999。

例如：

```java
INSERT INTO t VALUES ('01-10-31'), ('81-10-31');

mysql> SELECT * FROM t;
+------------+
| birth_date |
+------------+
| 2023-04-01 |
| 2001-10-31 |
| 1981-10-31 |
+------------+
3 rows in set (0.00 sec)
```

以上规则同样适用于其他数据类型中的年份信息，包括DATETIME、TIMESTAMP以及YEAR。

如果只需要存储年份信息，可以使用YEAR类型。YEAR类型占用1个字节，显示格式位 'YYYY'，范围从1901到2155，以及0000。

### 1.5.2 时间类型

MySQL使用TIME类型表示一天中的时间，格式为'HH:MM:SS'，范围小于24小时。另外，也可以使用TIME表示两个事件之间的时间间隔，格式为'hhh:mm:ss'，范围从'-838:59:59' 到 '838:59:59'。TIME类型需要3字节存储空间。

MySQL使用TIME(N)表示包含小数部分的时间，最多包含6位小数（微秒），默认为0位。如果包含了小数秒，TIME需要额外的存储，TIME(1)和TIME(2)需要4字节，TIME(3)和TIME(4)需要5字节，TIME(5) 和TIME(6)需要6字节存储。

### 1.5.3 时间戳类型

DATETIME(N)和TIMESTAMP(N)类型可以同时存储日期（DATE）和时间（TIME）信息，也就是时间戳。

DATETIME类型使用 'YYYY-MM-DD hh:mm:ss[.fraction]' 格式显示，支持范围'1000-01-01 00:00:00.000000' 到'9999-12-31 23:59:59.999999'，默认0位小数秒，需要5字节存储。如果支持小数秒，额外的存储和TIME(N)类似。

TIMESTAMP类型使用UTC时区进行存储，支持范围'1970-01-01 00:00:01.000000' UTC到'2038-01-19 03:14:07.999999' UTC，默认0位小数秒，需要4字节存储。如果支持小数秒，额外的存储和TIME(N)类似。

例如：

```sql
DROP TABLE IF EXISTS t;
CREATE TABLE t (dt DATETIME, ts TIMESTAMP);

SET time_zone = '+00:00';
INSERT INTO t VALUES (now(), now());

mysql> SELECT * FROM t;
+---------------------+---------------------+
| dt                  | ts                  |
+---------------------+---------------------+
| 2023-04-15 14:09:57 | 2023-04-15 14:09:57 |
+---------------------+---------------------+
1 row in set (0.00 sec)
```

两者在UTC时区相同，然后修改会话的时区：

```sql
mysql> SET time_zone = '+08:00';
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT * FROM t;
+---------------------+---------------------+
| dt                  | ts                  |
+---------------------+---------------------+
| 2023-04-15 14:09:57 | 2023-04-15 22:09:57 |
+---------------------+---------------------+
1 row in set (0.00 sec)
```

结果显示，TIMESTAMP类型会随着当前时区进行调整。

DATETIME和TIMESTAMP类型支持自动初始化或者更新为当前日期时间，在字段定义时分别使用DEFAULT CURRENT_TIMESTAMP和ON UPDATE CURRENT_TIMESTAMP属性进行设置。例如：

```sql
DROP TABLE IF EXISTS t;
CREATE TABLE t (
  id int, 
  dt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO t(id) VALUES (1);

mysql> SELECT * FROM t;
+------+---------------------+---------------------+
| id   | dt                  | ts                  |
+------+---------------------+---------------------+
|    1 | 2020-09-10 14:33:25 | 2020-09-10 22:33:25 |
+------+---------------------+---------------------+
1 row in set (0.00 sec)
```

另一种存储时间戳的方式是使用UNIX时间戳，即当前时间距离1970年1月1日的秒数来表示时间。例如，使用INT可以支持到2038年，无符号的INT可以支持到2106年。

这种存储方式的缺点就是可读性不强。MySQL提供了FORM_UNIXTIME和UNIX_TIMESATMP函数处理整数和时间戳的转换，也可以依赖应用程序进行格式处理。

## 1.6 JSON类型

MySQL 5.7.8开始支持原生JSON数据类型，可以支持更加高效的JSON文档存储和管理。原生JSON数据类型提供了自动的格式验证以及优化的存储格式，可以快速访问文档中的元素节点。例如：

```sql
CREATE TABLE employee_json(
  emp_id    INTEGER NOT NULL PRIMARY KEY,
  emp_info  JSON NOT NULL
);

INSERT INTO employee_json 
VALUES (1, '{"emp_name": "刘备", "sex": "男", "dept_id": 1, "manager": null, "hire_date": "2000-01-01", "job_id": 1, "income": [{"salary":30000}, {"bonus": 10000}], "email": "liubei@shuguo.com"}');

SELECT emp_id,
       emp_info->>'$.emp_name' emp_name,
       emp_info->>'$.income[0].salary' salary
FROM employee_json
WHERE emp_info->>'$.emp_name' = '刘备';
emp_id|emp_name|salary|
------+--------+------+
     1|刘备     |30000 |
```

JSON文档的最大长度不能超过系统变量max_allowed_packet（默认64MB）的限制。

除了JSON数据类型之外，MySQL还提供了许多JSON处理函数和操作符，例如：

- 构造JSON对象的JSON_OBJECT、JSON_ARRAY；
- 查询指定元素的->（JSON_EXTRACT）、->>（JSON_UNQUOTE + JSON_EXTRACT）；
- 将JSON数据转换为SQL数据的JSON_TABLE；
- 更新JSON数据的JSON_SET、JSON_INSERT、JSON_REPLACE、JSON_REMOVE
- 格式验证的JSON_VALID函数。

一般来说，JSON字段所需的存储和LONGBLOB或者LONGTEXT差不多。不过，JSON文档的二进制编码需要额外的存储，包括元数据和字典信息。举例来说，JSON文档中的字符串需要额外的4到10个字节存储。

JSON数据类型的优势是结构更灵活，不需要预定义字段。MySQL支持基于虚拟列的索引，可以为JSON节点创建索引，优化查询性能。

```sql
ALTER TABLE employee_json 
ADD COLUMN dept_id INT GENERATED ALWAYS AS (emp_info->"$.dept_id");

CREATE INDEX idx_employee_dept_id ON employee_json(dept_id);

-- 查看执行计划
EXPLAIN
SELECT *
FROM employee_json
WHERE dept_id = 1;
Name         |Value               |
-------------+--------------------+
id           |1                   |
select_type  |SIMPLE              |
table        |employee_json       |
partitions   |                    |
type         |ref                 |
possible_keys|idx_employee_dept_id|
key          |idx_employee_dept_id|
key_len      |5                   |
ref          |const               |
rows         |1                   |
filtered     |100.0               |
Extra        |                    |
```

MySQL 8.0.17开始支持多值索引，可以基于JSON数组字段创建索引。

## 1.7 选择主键类型

- 主键字段最好没有业务意义，避免变更可能带来的问题。


- 对于InnoDB而言，整数类型是最优的主键类型，推荐使用自增（AUTO_INCREMENT）属性。


- 尽量避免使用字符串作为主键类型，它们占用更多的存储，性能不如整数类型。尤其需要注意随机字符串，例如UUID函数，这种方式会导致插入数据和查询性能问题。可以考虑使用UUID_TO_BIN函数将UUID转换为16字节的数字，存储在BINARY(16)类型中，查询时使用HEX函数转换。


## 1.8 常见问题

设计MySQL数据库时，应该尽量避免以下问题：

- 混合使用了不同的存储引擎，例如一些表使用InnoDB，一些表使用MyISAM。建议统一使用InnoDB存储引擎。
- 使用VARCHAR存储IP地址。IP地址应该使用32位无符号整数，节省空间。可以利用INET_ATON和INET_NTOA函数进行转换。
- 使用VARCHAR存储日期和时间。这种方式需要占用更多存储，而且无法支持算术运算，例如返回两个日期之间的时间间隔。
- 为了避免扩展问题使用TEXT或者超长的VARCHAR。

# 第二部分、索引优化

## 2.1 索引简介

以下是一个简单的查询语句，它的作用是查找编号为5的员工：

```sql
SELECT *
FROM employee
WHERE emp_id = 5;
```

如果没有索引，数据库就只能扫描整个员工表，然后依次判断每个数据记录中的员工编号是否等于5并且返回满足条件的数据。这种查找数据的方法被称为**全表扫描**（Full Table Scan）。

全表扫描最大的一个问题，就是当表中的数据量逐渐增加时性能随之明显下降，因为磁盘I/O是数据库最大的性能瓶颈。 

> 💡当表中的数据量很小（例如配置表），或者查询需要访问表中大量数据（数据仓库），索引对查询的优化效果不会很明显。

为了解决大量磁盘访问带来的性能问题，MySQL引入了一个新的数据结构：索引（Index）。索引在MySQL中也被称为键（Key）。MySQL默认使用B-树（B+树）索引，它就像图书后面的关键字索引一样，按照关键字进行排序并且提供了指向具体内容的页码。

<img src="https://img-blog.csdnimg.cn/20190903165117187.png" style="zoom: 33%;" />

B-树索引就像是一棵倒立的树，树的节点按照顺序进行组织，节点左侧的数据都小于该节点的值，节点右侧的数据都大于该节点的值。B+树索引基于B-树索引进行了优化， 它们只在叶子节点存储索引数据（降低树的
高度，从而减少了磁盘访问次数） ，并且增加了叶子节点或者兄弟节点之间的指针（优化范围查询）。 

举例来说，假设索引的每个分支节点可以存储100个键值，100万条记录只需要3层B-树即可完成索引。 数据库通过索引查找指定数据时需要读取3次磁盘I/O（每次磁盘I/O读取整个索引节点）就可以得到查询结果。

如果采用全表扫描的方式，数据库需要执行的磁盘I/O可能高出几个数量级。 当数据量增加到1亿 条记录时， 通过索引访问只需要增加一次磁盘I/O即可， 全表扫描则需要再增加几个数量级的磁盘I/O。  

<img src="https://img-blog.csdnimg.cn/ba29a3b45f664cdcb72486f7793c704f.png" style="zoom: 33%;" />

> 💡主流数据库默认使用的都是B-树（B+树、 B*树）索引，它们实现了稳定且快速的数据查找（O(log n) 对数时间复杂度），可以用于优化=、<、 <=、 >、 BETWEEN、 IN运算符以及字符串的前向匹配（“ABC%”）等查询条件。  

## 2.2 聚簇索引

聚集索引（Clustered Index）将表中的数据按照索引（通常是主键） 的结构进行存储。 也就
是说，聚集索引的叶子节点中直接存储了表的数据，而不是指向数据的指针。

<img src="https://img-blog.csdnimg.cn/da85ed8791a94158af1dec6e03003265.png" style="zoom: 50%;" />

聚集索引其实是一种特殊的表， MySQL（InnoDB）和 Microsoft SQL Server 将这种结构的表称为聚集索引， Oracle数据库中将其称为索引组织表（IOT）。这种存储数据的方式类似于Key-Value存储，适合基于主键进行查询的应用。

- 如果定义了主键，InnoDB使用主键聚集数据；
- 如果没有定义主键，InnoDB使用第一个非空的UNIQUE索引聚集数据；
- 如果没有主键和可用的UNIQUE索引，InnoDB使用一个隐藏的内部ID字段聚集数据。

## 2.3 辅助索引

MySQL（InnoDB）中的辅助索引也被称为二级索引（Secondary Index），叶子节点存储了聚集索引的键值（通常是主键）。

<img src="https://img-blog.csdnimg.cn/1792990f75364448a7f3950e85de5b0c.png" style="zoom: 50%;" />

我们通过二级索引查找数据时，系统需要先找到相应的主键值，再通过主键索引查找相应的数据（回表）。因此，创建聚集索引的主键字段越小，索引就越小。这也是我们通常使用自增数字而不是UUID作为MySQL主键的原因之一。 

## 2.4 复合索引

复合索引是基于多个字段创建的索引，也叫多列索引。

<img src="https://img-blog.csdnimg.cn/b60d2b420332440ea46392064e79cc32.png" style="zoom: 50%;" />

复合索引可以避免为每个字段创建单独的索引，使用复合索引时最重要的是索引字段的顺序。

复合索引首先按照第一个（最左侧）字段排序，然后按照第二个字段排序，以此类推。因此，一个选择索引字段顺序的经验法则是：将选择性最高的字段放在最前面。

```sql
SELECT count(DISTINCT emp_name)/count(*) emp_name_sel,
       count(DISTINCT sex)/count(*) sex_sel
FROM employee;

emp_name_sel|sex_sel|
------------+-------+
      1.0000| 0.0800|
```

注意：如果数据分布不均匀，这种经验法则可能对于特定值的查询性能很差。

最左前缀匹配原则：复合索引(col1, col2, col3)，相当于以下三个索引：

- (col1)
- (col1, col2)
- (col1, col2, col3)

举例来说，它可以用于优化以下查询条件：

- WHERE col1 = val1 AND col2 = val2 AND col3 = val3
- WHERE col1 = val1 AND col2 = val2
- WHERE col1 = val1
- WHERE col1 = val1 AND col2 BETWEEN val2 AND val3
- WHERE col1 BETWEEN val1 AND val2
- WHERE col1 LIKE 'ABC%'

## 2.5 前缀索引

前缀索引（Prefix Index）是指基于字段的前一部分内容创建的索引。BLOB 、TEXT或者很长的VARCHAR类型字段必须使用前缀索引，因为MySQL对索引的长度有限制。MySQL 5.7默认不能超过3072字节。

前缀索引的优点是可以节省空间， 提高索引性能，但缺点是会降低索引的选择性。

索引的选择性是指不重复的索引值（基数）和表中的数据总量的比值，范围处于（1/总数据量）到1之间。选择性越高的索引查询效率越高，因为可以过滤掉更多的数据。主键和唯一索引的选择性是1。

```sql
SELECT count(DISTINCT LEFT(email,3))/count(DISTINCT email) left3,
       count(DISTINCT LEFT(email,4))/count(DISTINCT email) left4,
       count(DISTINCT LEFT(email,5))/count(DISTINCT email) left5,
       count(DISTINCT LEFT(email,6))/count(DISTINCT email) left6
FROM employee;

left3 |left4 |left5 |left6 |
------+------+------+------+
0.6000|0.7200|0.9200|1.0000|
```

示例中，当前缀长度到达6的时候，选择性和索引整个email字段没有区别。因此，可以基于该字段创建一个前缀索引：

```sql
CREATE INDEX idx_employee_email ON employee(email(6));
```

前缀索引也存在缺点，MySQL不能使用前缀索引进行排序（ORDER BY）和分组（GROUP BY），也不能实现索引覆盖扫描。

> 💡前缀索引的设计关键在于保证足够的选择性，同时又不能太长，以便节约存储。

## 2.6 函数索引

MySQL 8.0支持函数索引（Function-Based Index），也被称为表达式索引（Expression-Based Index），是基于函数或者表达式创建的索引。

例如，员工的电子邮箱不区分大小写并且唯一，我们可以基于LOWER(email)函数创建一个唯一的函数索引。

```sql
explain
select * 
from employee
where lower(email) = lower('ZhangFei@shuguo.com');
Name         |Value      |
-------------+-----------+
id           |1          |
select_type  |SIMPLE     |
table        |employee   |
partitions   |           |
type         |ALL        |
possible_keys|           |
key          |           |
key_len      |           |
ref          |           |
rows         |25         |
filtered     |100.0      |
Extra        |Using where|

create unique index uk_emp_email_lower on employee( (lower(email)) );
analyze table test;

explain
select * 
from employee
where lower(email) = lower('ZhangFei@shuguo.com');
Name         |Value             |
-------------+------------------+
id           |1                 |
select_type  |SIMPLE            |
table        |employee          |
partitions   |                  |
type         |const             |
possible_keys|uk_emp_email_lower|
key          |uk_emp_email_lower|
key_len      |403               |
ref          |const             |
rows         |1                 |
filtered     |100.0             |
Extra        |                  |
```

函数索引能够支持其他方式无法使用的数据类型，例如JSON数据。

```sql
CREATE TABLE employees (
  data JSON,
  INDEX idx ((CAST(data->>"$.name" AS CHAR(30)) COLLATE utf8mb4_bin))
);
INSERT INTO employees VALUES
  ('{ "name": "james", "salary": 9000 }'),
  ('{ "name": "James", "salary": 10000 }'),
  ('{ "name": "Mary", "salary": 12000 }'),
  ('{ "name": "Peter", "salary": 8000 }');
  
SELECT * FROM employees WHERE data->>'$.name' = 'James';
```

函数索引要求完全按照索引定义的相同方式指定查询中的条件。

## 2.7 降序索引

MySQL 8.0支持降序索引（Descending index）：索引定义中的DESC不再被忽略，而是以降序方式存储索引键值。

在之前的版本中，索引支持反向扫描，但是性能稍差一些。降序索引可以进行正向扫描，效率更高。当查询需要针对某些列升序排序，同时针对另一些列降序排序时，降序索引使得优化器可以使用多列混合索引扫描。

```sql
CREATE TABLE t (
  id INT AUTO_INCREMENT PRIMARY KEY, c1 INT, c2 INT,
  INDEX idx1 (c1 ASC, c2 ASC),
  INDEX idx2 (c1 ASC, c2 DESC),
  INDEX idx3 (c1 DESC, c2 ASC),
  INDEX idx4 (c1 DESC, c2 DESC)
);
```

优化器可以为不同的ORDER BY子句使用正向索引扫描，而不需要执行 *filesort* 排序。

```sql
explain 
select * 
from t 
ORDER BY c1 ASC, c2 DESC;

Name         |Value      |
-------------+-----------+
id           |1          |
select_type  |SIMPLE     |
table        |t          |
partitions   |           |
type         |index      |
possible_keys|           |
key          |idx2       |
key_len      |10         |
ref          |           |
rows         |1          |
filtered     |100.0      |
Extra        |Using index|
```

> 💡MySQL 8.0不再对GROUP BY操作进行隐式排序，排序需要明确指定ORDER BY。

## 2.8 隐藏索引

MySQL 8.0支持隐藏索引（invisible index），也称为不可见索引。隐藏索引不会被优化器使用。

> ⚠️主键不能设置为隐藏（包括显式设置或隐式设置）。

```sql
CREATE TABLE t1 (
  i INT,
  j INT,
  k INT,
  INDEX i_idx (i) INVISIBLE
) ENGINE = InnoDB;

CREATE INDEX j_idx ON t1 (j) INVISIBLE;
ALTER TABLE t1 ADD INDEX k_idx (k) INVISIBLE;
```

索引的可见性不会影响索引的维护。例如，无论索引是否可见，每次修改表中的数据时都需要对相应索引进行更新，而且唯一索引都会阻止插入重复的列值。

MySQL系统变量optimizer_switch中的use_invisible_indexes设置控制了优化器构建执行计划时是否使用隐藏索引。如果设置为off（默认值），优化器将会忽略隐藏索引（与引入该属性之前的行为相同）。如果设置为on，隐藏索引仍然不可见，但是优化器在构建执行计划时将会考虑这些索引。

不可见索引特性可以用于测试删除某个索引对于查询性能的影响，同时又不需要真正删除索引，也就避免了错误删除之后的索引重建。对于一个大表上的索引进行删除重建将会非常耗时，而将其设置为不可见或可见将会非常简单快捷。

> 💡隐藏索引应用场景：软删除、灰度发布。

## 2.9 覆盖索引

在某些情况下，查询语句通过索引访问就可以返回所需的结果，不需要访问表中的数据（回表），此时我们把这个索引称为覆盖索引（Covering Index）。某些数据库中称之为Index Only Scan。

```sql
explain
select emp_id, dept_id  
from employee
where dept_id = 5;
Name         |Value       |
-------------+------------+
id           |1           |
select_type  |SIMPLE      |
table        |employee    |
partitions   |            |
type         |ref         |
possible_keys|idx_emp_dept|
key          |idx_emp_dept|
key_len      |4           |
ref          |const       |
rows         |8           |
filtered     |100.0       |
Extra        |Using index |
```

此时的执行计划中Extra列显示Using index。

覆盖索引是优化器选择的一种执行计划；或者也可以说，任何索引在某种情况下都可能称为覆盖索引。

> 💡任何索引都包含了主键列，可用覆盖通过索引查找主键的查询语句。

## 2.10 索引和排序

 MySQL数据排序可用通过 *filesort* 或者索引顺序扫描的方式实现。

```sql
EXPLAIN
SELECT * 
FROM employee e 
ORDER BY emp_name;
Name         |Value         |
-------------+--------------+
id           |1             |
select_type  |SIMPLE        |
table        |e             |
partitions   |              |
type         |ALL           |
possible_keys|              |
key          |              |
key_len      |              |
ref          |              |
rows         |25            |
filtered     |100.0         |
Extra        |Using filesort|

EXPLAIN
SELECT emp_id, emp_name 
FROM employee e 
ORDER BY emp_name;
Name         |Value       |
-------------+------------+
id           |1           |
select_type  |SIMPLE      |
table        |e           |
partitions   |            |
type         |index       |
possible_keys|            |
key          |idx_emp_name|
key_len      |202         |
ref          |            |
rows         |25          |
filtered     |100.0       |
Extra        |Using index |
```

MySQL索引即可以用于查询数据，也可以用于实现排序。前提是索引字段的顺序和ORDER BY子句字段的顺序完全一致（最左前缀原则）。

对于复合索引(col1, col2, col3)，可以用于优化以下查询：

- WHERE col1 = val1 ORDER BY col2, col3
- WHERE col1 = val1 ORDER BY col2 DESC
- WHERE col1 BETWEEN val1 AND val2 ORDER BY col1, col2

但是无法使用该索引实现以下查询中的排序：

- WHERE col1 = val1 ORDER BY col2 DESC, col3
- WHERE col1 = val1 ORDER BY col3
- WHERE col1 BETWEEN val1 AND val2 ORDER BY col2, col3

如果查询连接了多个表，只有ORDER BY子句字段全部属于第一个表时，才能利用索引进行排序。

## 2.11 重复索引和冗余索引

MySQL允许在相同的字段上按照相同的顺序创建多个相同类型的索引，也就是**重复索引**。这样会占用更多存储空间，也导致优化器需要进行更多的评估。

```sql
CREATE TABLE t (
  id INT AUTO_INCREMENT PRIMARY KEY,
  c1 INT UNIQUE, 
  c2 INT,
  INDEX idx_pk (id),
  INDEX idx1 (c1)
);
```

以上示例中的索引idx_pk和idx1都属于重复索引。

复合索引字段顺序不同，则不算重复索引。例如(col1, col2)和(col2, col1)不是重复索引。

索引类型不同，则不算重复索引。例如INDEX(col)和FULLTEXT INDEX(col)不是重复索引。

> 💡MySQL（InnoDB）自动为主键、唯一约束以及外键约束创建相应的索引。

**冗余索引**是指已经字段被其他索引包含的索引。

如果已经存在复合索引(col1, col2)，那么索引(col1)就是冗余索引，因为前者可用替代索引(col1)。不过需要注意，索引(col2)不是冗余索引，因为col2不是索引(col1, col2)的最左前缀列。

索引(col1, id)是一个冗余索引，因为辅助索引中一定会包含主键字段。

> 💡一般建议基于已有的索引进行扩展，而不是不断增加新的冗余索引，但是也存在例外。

重复索引和冗余索引的处理方法就是删除索引，但是删除之前需要确认不会产生副作用。MySQL 8.0可用利用不可见索引特性减少影响。

另外，可能会存在从未使用过的索引，通过系统视图sys.schema_unused_indexes查看，建议确认后删除。

## 2.12 索引和DML

索引不仅会对查询产生影响，对数据进行插入、更新和删除操作时也需要同步维护索引结构。

**INSERT语句**

对于INSERT语句而言，索引越多执行越慢。插入数据必然导致增加索引项，这种操作的成本往往比插入数据本身更高，因为索引必须保持顺序和B+树的平衡（索引节点拆分）。因此，优化插入语句的最好方法就是减少不必要的索引。

> 💡没有任何索引时的插入性能是最好的，因此在加载大量数据时，可以临时删除所有的索引并在加载完成后重建索引。

**UPDATE语句**

UPDATE语句如果指定了查询条件，可以通过索引提高更新操作的性能，因为通过索引可以快速找到需要修改的数据。

另一方面，UPDATE语句如果修改了索引字段的值，需要删除旧的索引项并增加新的索引项。因此，更新操作的性能通常也取决于索引的数量。为了优化UPDATE语句，频繁更新的字段不适合创建索引；同时应该尽量避免修改过多的字段。

**DELETE语句**

对于DELETE语句而言，如果指定了查询条件，可以通过索引提高删除操作的性能。因为它和UPDATE语句一样，需要先执行一个SELECT语句找到需要删除的数据。

删除操作涉及的索引更新和插入操作类似，只不过它是删除一些索引项并确保索引树的平衡。因此，索引越多删除性能越差。不过有一个例外就是没有任何索引，这个时候性能会更差，因为数据库需要执行全表扫描才能找到需要删除的数据。

## 2.13 索引设计原则

> 📚推荐图书：《数据库索引设计与优化》

三星索引：

- 索引将相关的数据存储在一起，减少需要扫描的数据量，获得一星；
- 索引中的数据顺序和查询排序顺序一致，避免排序操作，获得二星；
- 索引包含了查询所需的全部字段，避免随机IO，获得三星。

```sql
CREATE TABLE t (
  id INT AUTO_INCREMENT PRIMARY KEY, 
  c1 INT,
  c2 INT,
  INDEX idx1 (c1, c2)
);

EXPLAIN 
SELECT *
FROM t 
WHERE c1>100
ORDER BY c1, c2;
Name         |Value                   |
-------------+------------------------+
id           |1                       |
select_type  |SIMPLE                  |
table        |t                       |
partitions   |                        |
type         |index                   |
possible_keys|idx1                    |
key          |idx1                    |
key_len      |10                      |
ref          |                        |
rows         |1                       |
filtered     |100.0                   |
Extra        |Using where; Using index|
```

既然索引可以优化查询的性能，那么我们是不是遇到性能问题就创建一个新的索引，或者直接将所有字段都进行索引？显然并非如此，因为索引在提高查询速度的同时也需要付出一定的代价：

- 首先，索引需要占用磁盘空间。索引独立于数据而存在，过多的索引会导致占用大量的空间。
- 其次，进行DML操作时，也需要对索引进行维护；维护索引有时候比修改数据更加耗时。

一般来说，可以考虑为以下情况创建索引：

 - 经常出现在WHERE条件或者ORDER BY中的字段创建索引，可以避免全表扫描和额外的排序操作；
 - 多表连接查询的关联字段或者外键涉及的字段，可以避免全表扫描和外键级联操作导致的锁表；
 - 查询中的GROUP BY分组操作字段。

对于交易类型的系统，首先找出查询时间最长或者占用资源最多的语句，检查它们涉及的表结构、索引结构，判断表结构和索引是否合理。如果这些优化还不能满足要求，另一个方法就是SQL查询优化。 

# 第三部分、查询优化

## 3.1 MySQL逻辑结构

MySQL使用典型的客户端/服务器（Client/Server）结构，逻辑结构图如下所示：

<img src="https://img-blog.csdnimg.cn/20200207113542412.png" alt="20200207113542412.png (1184×820) (csdnimg.cn)" style="zoom: 50%;" />

MySQL逻辑体系结构大体可以分为三层：客户端、服务器层以及存储引擎层。其中，服务器层又包括了连接管理、SQL接口、解析器、优化器、缓冲与缓存以及各种管理工具与服务等。

具体来说，每个组件的作用如下：

- **客户端**，连接MySQL服务器的各种工具和应用程序。例如*mysql*命令行工具、*mysqladmin*以及各种驱动程序等。
- **连接管理**，负责监听和管理客户端的连接以及线程处理等。每一个连接到MySQL服务器的请求都会被分配一个连接线程。连接线程负责与客户端的通信，接受客户端发送的命令并且返回服务器处理的结果。
- **~~查询缓存~~** ，用于将执行过的SELECT语句和结果缓存在内存中。每次执行查询之前判断是否命中缓存，如果命中直接返回缓存的结果。缓存命中需要满足许多条件，SQL语句完全相同，上下文环境相同等。实际上除非是只读应用，查询缓存的失效频率非常高，任何对表的修改都会导致缓存失效；因此，查询缓存在MySQL 8.0中已经被删除。
- **SQL接口**，接收客户端发送的各种DML和DDL命令，并且返回用户查询的结果。另外还包括所有的内置函数（日期、时间、数学以及加密函数）和跨存储引擎的功能，例如存储过程、触发器、视图等。
- **解析器**，对SQL语句进行解析，例如语义和语法的分析和检查，以及对象访问权限检查等。
- **优化器**，利用数据库的统计信息决定SQL语句的最佳执行方式。使用索引还是全表扫描的方式访问表，多表连接的实现方式等。优化器是决定查询性能的关键组件，而数据库的统计信息是优化器判断的基础。
- **缓存与缓冲**，由一系列缓存组成的，例如数据缓存、索引缓存以及对象权限缓存等。对于已经访问过的磁盘数据，在缓冲区中进行缓存；下次访问时可以直接读取内存中的数据，从而减少磁盘IO。
- **存储引擎**，存储引擎是对底层物理数据执行实际操作的组件，为服务器层提供各种操作数据的API。MySQL支持插件式的存储引擎，包括InnoDB、MyISAM、Memory等。
- **管理工具**，MySQL提供的系统管理和控制工具，例如备份与恢复、复制、集群等。

## 3.2 查询执行过程

一个查询语句从客户端的提交开始直到服务器返回最终的结果，整个过程大致如下图所示：

<img src="https://img-blog.csdnimg.cn/20191022173838222.png" style="zoom:50%;" />

**第一步：客户端提交SQL语句**。当然，在此之前客户端必须连接到数据库服务器。在上图中的连接器就是负责建立和管理客户端的连接。

我们使用客户端工具*mysql*连接到MySQL服务器：

```bash
[root@sqlhost ~]# mysql -h 192.168.56.104 -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 18
Server version: 8.0.33 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

**第二步：分析器/解析器**。分析器首先解析SQL语句，识别出各个组成部分；然后进行语法分析，检查SQL语句的语法是否符合规范。例如，以下语句中的FROM错写成了FORM：

```mysql
SELECT *
FORM employee
WHERE emp_id  = 1;

SQL Error [1064] [42000]: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'FORM employee
WHERE emp_id  = 1' at line 2
```

数据库返回了一个语法错误。

接下来是语义检查，确认查询中的表或者字段等对象是否存在，用户是否拥有访问权限等。例如，以下语句写错了表名：

```mysql
SELECT *
FROM employe
WHERE emp_id  = 1;

SQL Error [1146] [42S02]: Table 'hrdb.employe' doesn't exist
```

数据库显示对象不存在或者无效。这一步还包括处理语句中的表达式，视图转换等。

**第三步：优化器**。利用数据库收集到的统计信息决定SQL语句的最佳执行方式。例如，使用索引还是全表扫描的方式访问单个表，使用什么顺序连接多个表。优化器是决定查询性能的关键组件，而数据库的统计信息是优化器判断的基础。

**第四步：执行器**。根据优化之后的执行计划，调用相应的执行模块获取数据，并返回给客户端。对于MySQL而言，会根据表的存储引擎调用不同的接口获取数据。如果数据已经被缓存，可以直接从缓冲区获取。

## 3.3 优化器工作原理

MySQL优化器使用基于成本的优化方式（Cost-based Optimization），以SQL语句作为输入，利用内置的成本模型和数据字典信息以及存储引擎的统计信息决定使用哪些步骤实现查询语句，也就是查询计划。

<img src="https://img-blog.csdnimg.cn/20200628111821293.png" alt="20200628111821293.png (1271×583) (csdnimg.cn)" style="zoom:50%;" />



查询优化和地图导航的概念非常相似，我们通常只需要输入想要的结果（目的地），优化器负责找到最有效的实现方式（最佳路线）。需要注意，导航并不一定总是返回最快的路线，因为系统获得的交通数据并不可能是绝对准确的；与此类似，优化器也是基于特定模型、各种配置和统计信息进行选择，因此也不可能总是获得最佳执行方式。

从高层次来说，MySQL Server可以分为两部分：服务器层以及存储引擎层。其中，优化器工作在服务器层，位于存储引擎API之上。优化器的工作过程从语义上可以分为四个阶段：

1. **逻辑转换**，包括否定消除、等值传递和常量传递、常量表达式求值、外连接转换为内连接、子查询转换、视图合并等；
2. **优化准备**，例如索引ref和range访问方法分析、查询条件扇出值（fan out，过滤后的记录数）分析、常量表检测；
3. **基于成本优化**，包括访问方法和连接顺序的选择等；
4. **执行计划改进**，例如表条件下推、访问方法调整、排序避免以及索引条件下推。

### 3.3.1 逻辑转换

MySQL优化器首先可能会以不影响结果的方式对查询进行转换，转换的目标是尝试消除某些操作从而更快地执行查询。例如（[数据来源](https://github.com/dongxuyang1985/thinking_in_sql)）：

```mysql
explain
select *
from employee
where salary > 10000 and 1=1;
    
Name         |Value      |
-------------+-----------+
id           |1          |
select_type  |SIMPLE     |
table        |employee   |
partitions   |           |
type         |ALL        |
possible_keys|           |
key          |           |
key_len      |           |
ref          |           |
rows         |25         |
filtered     |33.33      |
Extra        |Using where|

1 row in set, 1 warning (0.00 sec)

mysql> show warnings\G
*************************** 1. row ***************************
  Level: Note
   Code: 1003
Message: /* select#1 */ select `hrdb`.`employee`.`emp_id` AS `emp_id`,`hrdb`.`employee`.`emp_name` AS `emp_name`,`hrdb`.`employee`.`sex` AS `sex`,`hrdb`.`employee`.`dept_id` AS `dept_id`,`hrdb`.`employee`.`manager` AS `manager`,`hrdb`.`employee`.`hire_date` AS `hire_date`,`hrdb`.`employee`.`job_id` AS `job_id`,`hrdb`.`employee`.`salary` AS `salary`,`hrdb`.`employee`.`bonus` AS `bonus`,`hrdb`.`employee`.`email` AS `email` from `hrdb`.`employee` where (`hrdb`.`employee`.`salary` > 10000.00)
1 row in set (0.00 sec)
```

显然，查询条件中的1=1是完全多余的。没有必要为每一行数据都执行一次计算；删除这个条件也不会影响最终的结果。执行EXPLAIN语句之后，通过SHOW WARNINGS命令可以查看逻辑转换之后的SQL语句，从上面的结果可以看出1=1已经不存在了。

> SHOW WARNINGS命令输出中的Message显示了优化器如何限定查询语句中的表名和列名、应用了重写和优化规则后的查询语句以及优化过程的其他信息。
>
> 目前只有SELECT语句相关的额外信息可以通过SHOW WARNINGS语句进行查看，其他语句（DELETE、INSERT、REPLACE 和UPDATE）显示的信息为空。

下表列出了一些逻辑转换的示例：

| 原始语句                                                     | 重写形式                                                     | 备注                                                         |
| :----------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| select * from employee where emp_id = 1;                     | /* select#1 */ select '1' AS \`emp_id\`,'刘备' AS \`emp_name\`,'男' AS \`sex\`,'1' AS \`dept_id\`,NULL AS \`manager\`,'2000-01-01' AS \`hire_date\`,'1' AS \`job_id\`,'30000.00' AS \`salary\`,'10000.00' AS \`bonus\`,'liubei@shuguo.com' AS \`email\` from \`hrdb\`.\`employee\` where true | 通过主键或唯一索引进行等值查找时，在选择执行计划之前就完成了转换，重写为查询常量。 |
| select * from employee where emp_id = 0;                     | /* select#1 */ select NULL AS \`emp_id\`,NULL AS \`emp_name\`,NULL AS \`sex\`,NULL AS \`dept_id\`,NULL AS \`manager\`,NULL AS \`hire_date\`,NULL AS \`job_id\`,NULL AS \`salary\`,NULL AS \`bonus\`,NULL AS \`email\` from \`hrdb\`.\`employee\` where multiple equal(0, NULL) | 通过主键或唯一索引查找不存在的值。                           |
| select emp_name from employee e, (select * from department where dept_name ='研发部') as d where d.dept_id = e.dept_id and e.salary > 10000; | /* select#1 */ select \`hrdb\`.\`e\`.\`emp_name\` AS \`emp_name\` from \`hrdb\`.\`employee\` \`e\` join \`hrdb\`.\`department\` where ((\`hrdb\`.\`e\`.\`dept_id\` = \`hrdb\`.\`department\`.\`dept_id\`) and (\`hrdb\`.\`e\`.\`salary\` > 10000.00) and (\`hrdb\`.\`department\`.\`dept_name\` = '研发部')) | 派生表子查询转换为连接查询                                   |

我们也可以通过**优化器跟踪**进一步了解优化器的执行过程，例如：

```mysql
mysql> SET optimizer_trace="enabled=on";
Query OK, 0 rows affected (0.03 sec)

mysql> select * from employee where emp_id = 1 and dept_id = emp_id;
+--------+----------+-----+---------+---------+------------+--------+----------+----------+-------------------+
| emp_id | emp_name | sex | dept_id | manager | hire_date  | job_id | salary   | bonus    | email             |
+--------+----------+-----+---------+---------+------------+--------+----------+----------+-------------------+
|      1 | 刘备     | 男  |       1 |    NULL | 2000-01-01 |      1 | 30000.00 | 10000.00 | liubei@shuguo.com |
+--------+----------+-----+---------+---------+------------+--------+----------+----------+-------------------+
1 row in set (0.00 sec)

mysql> select * from information_schema.optimizer_trace\G
*************************** 1. row ***************************
                            QUERY: select * from employee where emp_id = 1 and dept_id = emp_id
                            TRACE: {
  "steps": [
    {
      "join_preparation": {
        "select#": 1,
        "steps": [
          {
            "expanded_query": "/* select#1 */ select `employee`.`emp_id` AS `emp_id`,`employee`.`emp_name` AS `emp_name`,`employee`.`sex` AS `sex`,`employee`.`dept_id` AS `dept_id`,`employee`.`manager` AS `manager`,`employee`.`hire_date` AS `hire_date`,`employee`.`job_id` AS `job_id`,`employee`.`salary` AS `salary`,`employee`.`bonus` AS `bonus`,`employee`.`email` AS `email` from `employee` where ((`employee`.`emp_id` = 1) and (`employee`.`dept_id` = `employee`.`emp_id`))"
          }
        ]
      }
    },
    {
      "join_optimization": {
        "select#": 1,
        "steps": [
          {
            "condition_processing": {
              "condition": "WHERE",
              "original_condition": "((`employee`.`emp_id` = 1) and (`employee`.`dept_id` = `employee`.`emp_id`))",
              "steps": [
                {
                  "transformation": "equality_propagation",
                  "resulting_condition": "(multiple equal(1, `employee`.`emp_id`, `employee`.`dept_id`))"
                },
                {
                  "transformation": "constant_propagation",
                  "resulting_condition": "(multiple equal(1, `employee`.`emp_id`, `employee`.`dept_id`))"
                },
                {
                  "transformation": "trivial_condition_removal",
                  "resulting_condition": "multiple equal(1, `employee`.`emp_id`, `employee`.`dept_id`)"
                }
              ]
            }
          },
		  ...
        ]
      }
    },
    {
      "join_execution": {
        "select#": 1,
        "steps": [
        ]
      }
    }
  ]
}
MISSING_BYTES_BEYOND_MAX_MEM_SIZE: 0
          INSUFFICIENT_PRIVILEGES: 0
1 row in set (0.00 sec)
```

优化器跟踪输出主要包含了三个部分：

- join_preparation，准备阶段，返回了字段名扩展之后的SQL语句。对于1=1这种多余的条件，也会在这个步骤被删除；
- join_optimization，优化阶段。其中condition_processing中包含了各种逻辑转换，经过等值传递（equality_propagation）之后将条件dept_id = emp_id转换为了dept_id = 1。另外constant_propagation表示常量传递，trivial_condition_removal表示无效条件移除；
- join_execution，执行阶段。

优化器跟踪还可以显示其他基于成本优化的过程，后续我们还会使用该功能。关闭优化器跟踪的方式如下：

```mysql
SET optimizer_trace="enabled=off";
```

### 3.3.2 基于成本的优化

MySQL优化器采用基于成本的优化方式，简化的步骤如下：

1. 为每个操作指定一个成本；
2. 计算每个可能的执行计划各个步骤的成本总和；
3. 选择总成本最小的执行计划。

为了找到最佳执行计划，优化器需要比较不同的查询方案。随着查询中表的数量增加，可能的执行计划会呈现指数级增长；因为每个表都可能使用全表扫描或者不同的索引访问方法，连接查询可能使用任意顺序。对于少量表的连接查询（通常少于7到10个）可能不会产生问题，但是更多的表可能会导致查询优化的时间比执行时间还要长。

所以优化器不可能遍历所有的执行方案，一种更灵活的优化方法是允许用户控制优化器在查找最佳查询计划时的遍历程度。一般来说，优化器评估的计划越少，则编译查询所花费的时间就越少；但另一方面，由于优化器忽略了一些计划，因此可能找到的不是最佳计划。

**控制优化程度**

MySQL提供了两个系统变量，可以用于控制优化器的优化程度：

- [optimizer_prune_level](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_optimizer_prune_level)， 基于返回行数的评估忽略某些执行计划，这种启发式的方法可以极大地减少优化时间而且很少丢失最佳计划。因此，该参数的默认设置为1；如果确认优化器错过了最佳计划，可以将该参数设置为0，不过这样可能导致优化时间的增加。
- [optimizer_search_depth](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_optimizer_search_depth)，优化器查找的深度。如果该参数大于查询中表的数量，可以得到更好的执行计划，但是优化时间更长；如果小于表的数量，可以更快完成优化，但可能获得的不是最优计划。例如，对于12、13个或者更多表的连接查询，如果将该参数设置为表的个数，可能需要几小时或者几天时间才能完成优化；如果将该参数修改为3或者4，优化时间可能少于1分钟。该参数的默认值为62；如果不确定是否合适，可以将其设置为0，让优化器自动决定搜索的深度。

**设置成本常量**

MySQL优化器计算的成本主要包括I/O成本和CPU成本，每个步骤的成本由内置的“成本常量”进行估计。另外，这些成本常量可以通过系统数据库（mysql）中的server_cost和engine_cost两个表进行查询和设置。

server_cost中存储的是常规服务器操作的成本估计值：

```mysql
select * from mysql.server_cost;

cost_name                   |cost_value|last_update        |comment|default_value|
----------------------------+----------+-------------------+-------+-------------+
disk_temptable_create_cost  |          |2021-11-22 15:18:16|       |         20.0|
disk_temptable_row_cost     |          |2021-11-22 15:18:16|       |          0.5|
key_compare_cost            |          |2021-11-22 15:18:16|       |         0.05|
memory_temptable_create_cost|          |2021-11-22 15:18:16|       |          1.0|
memory_temptable_row_cost   |          |2021-11-22 15:18:16|       |          0.1|
row_evaluate_cost           |          |2021-11-22 15:18:16|       |          0.1|
```

cost_value为空表示使用default_value。其中，

- **disk_temptable_create_cost**和**disk_temptable_row_cost**代表了在基于磁盘的存储引擎（例如InnoDB）中使用内部临时表的评估成本。增加这些值会使得优化器倾向于较少使用内部临时表的查询计划。
- **key_compare_cost**代表了比较记录键的评估成本。增加该值将导致需要比较多个键值的查询计划变得更加昂贵。例如，执行filesort排序的查询计划比通过索引避免排序的查询计划相对更加昂贵。
- **memory_temptable_create_cost**和**memory_temptable_row_cost**代表了在MEMORY存储引擎中使用内部临时表的评估成本。增加这些值会使得优化器倾向于较少使用内部临时表的查询计划。
- **row_evaluate_cost**代表了计算记录条件的评估成本。增加该值会导致检查许多数据行的查询计划变得更加昂贵。例如，与读取少量数据行的索引范围扫描相比，全表扫描变得相对昂贵。

engine_cost中存储的是特定存储引擎相关操作的成本估计值：

```mysql
select * from mysql.engine_cost;

engine_name|device_type|cost_name             |cost_value|last_update        |default_value|
-----------+-----------+----------------------+----------+-------------------+-------------+
default    |          0|io_block_read_cost    |          |2021-11-22 15:18:16|          1.0|
default    |          0|memory_block_read_cost|          |2021-11-22 15:18:16|         0.25|
```

engine_name表示存储引擎，“default”表示所有存储引擎，也可以为不同的存储引擎插入特定的数据。cost_value为空表示使用default_value。其中，

- **io_block_read_cost**代表了从磁盘读取索引或数据块的成本。增加该值会使读取许多磁盘块的查询计划变得更加昂贵。例如，与读取较少块的索引范围扫描相比，全表扫描变得相对昂贵。
- **memory_block_read_cost**与io_block_read_cost类似，但是它表示从数据库缓冲区读取索引或数据块的成本。

我们来看一个例子，执行以下语句：

```mysql
explain format=json
select *
from employee
where dept_id between 4 and 5;

{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "2.75"
    },
    "table": {
      "table_name": "employee",
      "access_type": "ALL",
      "possible_keys": [
        "idx_emp_dept"
      ],
      "rows_examined_per_scan": 25,
      "rows_produced_per_join": 17,
      "filtered": "68.00",
      "cost_info": {
        "read_cost": "1.05",
        "eval_cost": "1.70",
        "prefix_cost": "2.75",
        "data_read_per_join": "9K"
      },
      "used_columns": [
        "emp_id",
        "emp_name",
        "sex",
        "dept_id",
        "manager",
        "hire_date",
        "job_id",
        "salary",
        "bonus",
        "email"
      ],
      "attached_condition": "(`hrdb`.`employee`.`dept_id` between 4 and 5)"
    }
  }
}
```

查询计划显示使用了全表扫描（access_type = ALL），而没有选择idx_emp_dept。通过优化器跟踪可以看到具体原因：

```mysql
                  "analyzing_range_alternatives": {
                    "range_scan_alternatives": [
                      {
                        "index": "idx_emp_dept",
                        "ranges": [
                          "4 <= dept_id <= 5"
                        ],
                        "index_dives_for_eq_ranges": true,
                        "rowid_ordered": false,
                        "using_mrr": false,
                        "index_only": false,
                        "rows": 17,
                        "cost": 6.21,
                        "chosen": false,
                        "cause": "cost"
                      }
                    ],
                    "analyzing_roworder_intersect": {
                      "usable": false,
                      "cause": "too_few_roworder_scans"
                    }
                  }
```

使用全表扫描的总成本为2.75，使用范围扫描的总成本为6.21。这是因为查询返回了employee表中大部分的数据，通过索引范围扫描，然后再回表反而会比直接扫描表更慢。

接下来我们将数据行比较的成本常量row_evaluate_cost从0.1改为1，并且刷新内存中的值：

```mysql
update mysql.server_cost 
set cost_value=1 
where cost_name='row_evaluate_cost';

flush optimizer_costs;
```

然后重新连接数据库，再次获取执行计划的结果如下：

```mysql
{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "38.51"
    },
    "table": {
      "table_name": "employee",
      "access_type": "range",
      "possible_keys": [
        "idx_emp_dept"
      ],
      "key": "idx_emp_dept",
      "used_key_parts": [
        "dept_id"
      ],
      "key_length": "4",
      "rows_examined_per_scan": 17,
      "rows_produced_per_join": 17,
      "filtered": "100.00",
      "index_condition": "(`hrdb`.`employee`.`dept_id` between 4 and 5)",
      "cost_info": {
        "read_cost": "21.51",
        "eval_cost": "17.00",
        "prefix_cost": "38.51",
        "data_read_per_join": "9K"
      },
      "used_columns": [
        "emp_id",
        "emp_name",
        "sex",
        "dept_id",
        "manager",
        "hire_date",
        "job_id",
        "salary",
        "bonus",
        "email"
      ]
    }
  }
}
```

此时，优化器选择的范围扫描（access_type = range）。虽然它的成本增加为38.51，但是使用全表扫描的代价更高。

最后，记得将row_evaluate_cost的还原成默认设置并重新连接数据库：

```mysql
update mysql.server_cost 
set cost_value= null
where cost_name='row_evaluate_cost';

flush optimizer_costs;
```

> ⚠️不要轻易修改成本常量，因为这样可能导致许多查询计划变得更糟！在大多数生产情况下，推荐通过添加优化器提示（optimizer hint）控制查询计划的选择。

**数据字典与统计信息**

除了成本常量之外，MySQL优化器在优化的过程中还会使用数据字典和存储引擎中的统计信息。例如表的数据量、索引、索引的唯一性以及字段是否可以为空都会影响到执行计划的选择，包括数据的访问方法和表的连接顺序等。

MySQL会在日常操作过程中粗略统计表的大小和索引的基数（Cardinality），我们也可以使用[ANALYZE TABLE](https://dev.mysql.com/doc/refman/8.0/en/analyze-table.html)语句手动更新表的统计信息和索引的数据分布。

```mysql
ANALYZE TABLE tbl_name [, tbl_name] ...;
```

这些统计信息默认会持久化到数据字典表mysql.innodb_index_stats和mysql.innodb_table_stats中，也可以通过INFORMATION_SCHEMA视图TABLES、STATISTICS以及INNODB_INDEXES进行查看。

另外，从MySQL 8.0开始增加了直方图统计（histogram statistics），也就是字段值的分布情况。用户同样可以通过ANALYZE TABLE语句生成或者删除字段的直方图：

```mysql
ANALYZE TABLE tbl_name
UPDATE HISTOGRAM ON col_name [, col_name] ...
[WITH N BUCKETS];

ANALYZE TABLE tbl_name
DROP HISTOGRAM ON col_name [, col_name] ...;
```

其中，WITH N BUCKETS用于指定直方图统计时桶的个数，取值范围从1到1024，默认为100。

直方图统计主要用于没有创建索引的字段，当查询使用这些字段与常量进行比较时，MySQL优化器会使用直方图统计评估过滤之后的行数。例如，以下语句显示了没有直方图统计时的优化器评估：

```mysql
explain analyze
select * 
from employee
where salary = 10000;

-> Filter: (employee.salary = 10000.00)  (cost=2.75 rows=3) (actual time=0.612..0.655 rows=1 loops=1)
    -> Table scan on employee  (cost=2.75 rows=25) (actual time=0.455..0.529 rows=25 loops=1)
```

由于salary字段上既没有索引也没有直方图统计，因此优化器评估返回的行数为3，但实际返回的行数为1。

我们为salary字段创建直方图统计：

```sql
analyze table employee update histogram on salary;
Table        |Op       |Msg_type|Msg_text                                         |
-------------|---------|--------|-------------------------------------------------|
hrdb.employee|histogram|status  |Histogram statistics created for column 'salary'.|
```

然后再次查看执行计划：

```mysql
explain analyze
select * 
from employee
where salary = 10000;

-> Filter: (employee.salary = 10000.00)  (cost=2.75 rows=1) (actual time=0.265..0.291 rows=1 loops=1)
    -> Table scan on employee  (cost=2.75 rows=25) (actual time=0.206..0.258 rows=25 loops=1)
```

此时，优化器评估的行数和实际返回的行数一致，都是1。

MySQL使用数据字典表column_statistics存储字段值分布的直方图统计，用户可以通过查询视图INFORMATION_SCHEMA.COLUMN_STATISTICS获得直方图信息：

```mysql
select * from information_schema.column_statistics;
SCHEMA_NAME|TABLE_NAME|COLUMN_NAME|HISTOGRAM                                            |-----------|----------|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
hrdb       |employee  |salary     |{"buckets": [[4000.00, 0.08], [4100.00, 0.12], [4200.00, 0.16], [4300.00, 0.2], [4700.00, 0.24000000000000002], [4800.00, 0.28], [5800.00, 0.32], [6000.00, 0.4], [6500.00, 0.48000000000000004], [6600.00, 0.52], [6800.00, 0.56], [7000.00, 0.600000000000000|
```

删除以上直方图统计的命令如下：

```sql
analyze table employee drop histogram on salary;
```

索引和直方图之间的区别在于：

- 索引需要随着数据的修改而更新；
- 直方图通过命令手动更新，不会影响数据更新的性能。但是，直方图统计会随着数据修改变得过时。

相对于直方图统计，优化器会优先选择索引范围优化评估返回的数据行。因为对于索引字段而言，范围优化可以获得更加准确的评估。

### 3.3.3 控制优化器行为

MySQL提供了一个系统变量[ optimizer_switch](https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_optimizer_switch)，用于控制优化器的优化行为。

```mysql
select @@optimizer_switch;
@@optimizer_switch|
--------------------------------------------------------------------------------------|
index_merge=on,index_merge_union=on,index_merge_sort_union=on,index_merge_intersection=on,engine_condition_pushdown=on,index_condition_pushdown=on,mrr=on,mrr_cost_based=on,block_nested_loop=on,batched_key_access=off,materialization=on,semijoin=on,loosescan=on,firstmatch=on,duplicateweedout=on,subquery_materialization_cost_based=on,use_index_extensions=on,condition_fanout_filter=on,derived_merge=on,use_invisible_indexes=off,skip_scan=on,hash_join=on,subquery_to_derived=off,prefer_ordering_index=on,hypergraph_optimizer=off,derived_condition_pushdown=on|
```

它的值由一组标识组成，每个标识的值都可以为on或off，表示启用或者禁用了相应的优化行为。

该变量支持全局和会话级别的设置，可以在运行时进行更改。

```mysql
SET [GLOBAL|SESSION] optimizer_switch='command[,command]...';
```

其中，command可以是以下形式：

- default，将所有优化行为设置为默认值。
- opt_name=default，将指定优化行为设置为默认值。
- opt_name=off，禁用指定的优化行为。
- opt_name=on，启用指定的优化行为。

我们以索引条件下推（index_condition_pushdown）优化为例，演示修改optimizer_switch的效果。首先执行以下语句查看执行计划：

```mysql
explain
select * 
from employee e
where e.email like 'zhang%';

Name         |Value                |
-------------+---------------------+
id           |1                    |
select_type  |SIMPLE               |
table        |e                    |
partitions   |                     |
type         |range                |
possible_keys|uk_emp_email         |
key          |uk_emp_email         |
key_len      |402                  |
ref          |                     |
rows         |2                    |
filtered     |100.0                |
Extra        |Using index condition|
```

其中，Extra字段中的“Using index condition”表示使用了索引条件下推。

然后禁用索引条件下推优化：

```mysql
set optimizer_switch='index_condition_pushdown=off';
```

然后再次查看执行计划：

```mysql
Name         |Value       |
-------------+------------+
id           |1           |
select_type  |SIMPLE      |
table        |e           |
partitions   |            |
type         |range       |
possible_keys|uk_emp_email|
key          |uk_emp_email|
key_len      |402         |
ref          |            |
rows         |2           |
filtered     |100.0       |
Extra        |Using where |
```

Extra字段变成了“Using where”，意味着需要访问表中的数据然后再应用该条件过滤。如果使用优化器跟踪，可以看到更详细的差异。

还原索引条件下推优化：

```mysql
set optimizer_switch='index_condition_pushdown=default';
```

### 3.3.4 优化器和索引提示

虽然通过系统变量optimizer_switch可以控制优化器的优化策略，但是一旦改变它的值，后续的查询都会受到影响，除非再次进行设置。

另一种控制优化器策略的方法就是[优化器提示](https://dev.mysql.com/doc/refman/8.0/en/optimizer-hints.html)（Optimizer Hint）和[索引提示](https://dev.mysql.com/doc/refman/8.0/en/index-hints.html)（Index Hint），它们只对单个语句有效，而且优先级比optimizer_switch更高。

**优化器提示**使用 /*+ … */ 注释风格的语法，可以对连接顺序、表访问方式、索引使用方式、子查询、语句执行时间限制、系统变量以及资源组等进行语句级别的设置。

例如，在没有使用优化器提示的情况下：

```mysql
explain
select * 
from employee e
join department d on d.dept_id = e.dept_id
where e.salary = 10000;

id|select_type|table|partitions|type  |possible_keys|key    |key_len|ref           |rows|filtered|Extra      |
--|-----------|-----|----------|------|-------------|-------|-------|--------------|----|--------|-----------|
 1|SIMPLE     |e    |          |ALL   |idx_emp_dept |       |       |              |  25|     4.0|Using where|
 1|SIMPLE     |d    |          |eq_ref|PRIMARY      |PRIMARY|4      |hrdb.e.dept_id|   1|   100.0|           |
```

优化器选择employee作为驱动表，并且使用全表扫描返回salary = 10000的数据；然后通过主键查找department中的记录。

然后我们通过优化器提示join_order修改两个表的连接顺序：

```mysql
explain
select /*+ join_order(d, e) */ * 
from employee e
join department d on d.dept_id = e.dept_id
where e.salary = 10000;

id|select_type|table|partitions|type|possible_keys|key|key_len|ref|rows|filtered|Extra                                     |
--|-----------|-----|----------|----|-------------|---|-------|---|----|--------|------------------------------------------|
 1|SIMPLE     |d    |          |ALL |PRIMARY      |   |       |   |   6|   100.0|                                          |
 1|SIMPLE     |e    |          |ALL |idx_emp_dept |   |       |   |  25|     4.0|Using where; Using join buffer (hash join)|
```

此时，优化器选择了department作为驱动表；同时访问employee时选择了全表扫描。我们可以再增加一个索引相关的优化器提示index：

```mysql
explain
select /*+ join_order(d, e) index(e idx_emp_dept) */ * 
from employee e
join department d on d.dept_id = e.dept_id
where e.salary = 10000;

id|select_type|table|partitions|type|possible_keys|key         |key_len|ref           |rows|filtered|Extra      |
--|-----------|-----|----------|----|-------------|------------|-------|--------------|----|--------|-----------|
 1|SIMPLE     |d    |          |ALL |PRIMARY      |            |       |              |   6|   100.0|           |
 1|SIMPLE     |e    |          |ref |idx_emp_dept |idx_emp_dept|4      |hrdb.d.dept_id|   5|    10.0|Using where|
```

最终，优化器选择了通过索引idx_emp_dept查找employee中的数据。

需要注意的是，通过提示禁用某个优化行为可以阻止优化器使用该优化；但是启用某个优化行为不代表优化器一定会使用该优化，它可以选择使用或者不使用。

> ⚠️开发和测试过程可以使用优化器提示和索引提示，但是生产环境中需要小心使用。因为实际数据和环境会随着时间发生变化，而且MySQL优化器也会越来越智能，合理的参数配置定时的统计更新通常是更好地选择。

**索引提示**为优化器提供了如何选择索引的信息，直接出现在表名之后：

```mysql
tbl_name [[AS] alias] 
    USE {INDEX|KEY} [FOR {JOIN|ORDER BY|GROUP BY}] (index_name, ...)
  | {IGNORE|FORCE} {INDEX|KEY} [FOR {JOIN|ORDER BY|GROUP BY}] (index_name, ...)
```

USE INDEX提示优化器使用某个索引，IGNORE INDEX提示优化器忽略某个索引，FORCE INDEX强制使用某个索引。

例如，以下语句使用了USE INDEX索引提示：

```mysql
explain
select * 
from employee e use index (idx_emp_job)
join department d on d.dept_id = e.dept_id
where e.salary = 10000;

id|select_type|table|partitions|type  |possible_keys|key    |key_len|ref           |rows|filtered|Extra      |
--|-----------|-----|----------|------|-------------|-------|-------|--------------|----|--------|-----------|
 1|SIMPLE     |e    |          |ALL   |             |       |       |              |  25|    10.0|Using where|
 1|SIMPLE     |d    |          |eq_ref|PRIMARY      |PRIMARY|4      |hrdb.e.dept_id|   1|   100.0|           |
```

虽然使用了索引提示，但是由于索引idx_emp_job和查询完全无关，优化器最终还是没有选择使用该索引。

以下示例使用了IGNORE INDEX索引提示：

```mysql
explain
select * 
from employee e
join department d ignore index (PRIMARY)
on d.dept_id = e.dept_id
where e.salary = 10000;

id|select_type|table|partitions|type|possible_keys|key|key_len|ref|rows|filtered|Extra                                     |
--|-----------|-----|----------|----|-------------|---|-------|---|----|--------|------------------------------------------|
 1|SIMPLE     |e    |          |ALL |idx_emp_dept |   |       |   |  25|    10.0|Using where                               |
 1|SIMPLE     |d    |          |ALL |             |   |       |   |   6|   16.67|Using where; Using join buffer (hash join)|
```

IGNORE INDEX使得优化器放弃了department的主键查找，最终选择了hash join连接两个表。该示例也可以通过优化器提示no_index实现：

```mysql
explain
select /*+ no_index(d PRIMARY) */ * 
from employee e
join department d
on d.dept_id = e.dept_id
where e.salary = 10000;
```

> ⚠️从MySQL 8.0.20开始，提供了等价形式的索引级别优化器提示，将来的版本可能会废弃传统形式的索引提示。

### 3.3.5 优化器的局限性

MySQL优化器可以很好地处理大部分查询语句，尤其是简单查询。随着MySQL版本的更新，对于复杂查询的实现也更加高效，例如MySQL 8.0支持提供了哈希连接（Hash Join）算法，替代之前基于块的嵌套循环连接（Block Nested-Loop Join），可以极大地提升多表连接的性能。

尽管如此，MySQL优化器目前仍然存在一些局限性，某些情况下的实现并不是最优方案。我们需要了解这些限制，并通过改写查询或者采用其他方法优化性能。

- **不支持并行执行**。MySQL采用单进程多线程模型，不支持多核并行执行特性。可以在应用层拆分查询，实现多个SQL语句的并行查询。

- **UNION的限制**。优化器选项[derived_condition_pushdown](https://dev.mysql.com/doc/refman/8.0/en/derived-condition-pushdown-optimization.html)可以将查询条件下推到子查询内部，包括使用了UNION子句的派生表，但不是所有的外部查询子句都可以下推，例如LIMIT子句。

  ```mysql
  CREATE TABLE t1 (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    c1 INT, 
    KEY i1 (c1)
  );
  
  CREATE TABLE t2 (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    c1 INT, 
    KEY i1 (c1)
  );
  
  EXPLAIN FORMAT=TREE 
  SELECT * FROM 
  (  SELECT id, c1 FROM t1
     UNION ALL
     SELECT id, c1 FROM t2) v
  WHERE c1 = 12;
  
  -> Table scan on v  (cost=2.16..3.42 rows=2)
      -> Union all materialize  (cost=0.90..0.90 rows=2)
          -> Covering index lookup on t1 using i1 (c1=12)  (cost=0.35 rows=1)
          -> Covering index lookup on t2 using i1 (c1=12)  (cost=0.35 rows=1)
  
  
  EXPLAIN FORMAT=TREE 
  SELECT * FROM 
  (  SELECT id, c1 FROM t1
     UNION ALL
     SELECT id, c1 FROM t2) v
  WHERE c1 = 12
  LIMIT 10;
  
  -> Limit: 10 row(s)  (cost=2.16..3.42 rows=2)
      -> Table scan on v  (cost=2.16..3.42 rows=2)
          -> Union all materialize  (cost=0.90..0.90 rows=2)
              -> Covering index lookup on t1 using i1 (c1=12)  (cost=0.35 rows=1)
              -> Covering index lookup on t2 using i1 (c1=12)  (cost=0.35 rows=1)
  ```

- **不允许更新和查询同一张表**。例如：

  ```mysql
  UPDATE t1 AS o
  SET c1 = (SELECT count(*) FROM t1 AS i WHERE i.id=o.id);
  
  SQL 错误 [1093] [HY000]: You can't specify target table 'o' for update in FROM clause
  ```

  这个问题可以使用派生表解决：

  ```mysql
  UPDATE t1 
  JOIN (SELECT id, count(*) tot FROM t1 GROUP BY id) AS i
  USING (id)
  SET t1.c1 = i.tot;
  ```

## 3.4 慢查询分析

慢查询最常见的原因就是访问了太多数据，可能是过多的数据行，也可能是过多的字段。

查询可能请求了不需要的数据，返回客户端之后被抛弃。这种情况会消耗额外的MySQL服务器资源、网络资源以及应用服务器的资源。具体案例包括：

- 在应用端的分页会返回全部结果，但是只显示前面N条记录。这种查询应该加上LIMIT子句。

- SELECT *很有可能返回了不必要的字段，应该指定具体的字段名。

- 应用程序可能存在重复查询相同数据的情况，应该使用缓存减少查询次数。

查看MySQL慢查询日志状态：

```mysql
show variables like '%slow_query_log%';

Variable_name      |Value                   |
-------------------+------------------------+
slow_query_log     |ON                      |
slow_query_log_file|LAPTOP-DGRB6HD9-slow.log|
```

开启MySQL慢查询日志，可以使用以下命令：

```mysql
mysql> set global slow_query_log=on;

mysql> set global slow_query_log_file='/var/log/mysql/mysql-slow.log';

mysql> set global long_query_time=1;

mysql> set global log_queries_not_using_indexes=on;
```

以上命令修改的内容在重启服务之后失效。如果想要永久生效，可以使用MySQL 8.0新增的SET PERSIST命令，或者修改配置文件my.cnf：

```
[mysqld]
# 开启慢查询日志
slow-query-log=on

# 指定慢查询日志文件
slow_query_log_file='/var/log/mysql/mysql-slow.log'

# 设置慢查询时间阈值，单位为秒
long_query_time=1

# 记录没有使用索引的查询
log_queries_not_using_indexes=on
```

启用慢查询日志之后，超过阈值的查询都会被记录到日志文件中。例如：

```shell
# Time: 2023-07-02T14:37:52.796023Z
# User@Host: root[root] @ localhost [127.0.0.1]  Id:    62
# Query_time: 27.041530  Lock_time: 0.000484 Rows_sent: 0  Rows_examined: 0
use hrdb;
SET timestamp=1648651045;
/* ApplicationName=DBeaver 21.3.0 - SQLEditor <Script-4.sql> */ WITH RECURSIVE transfer(start_station, stop_station, stops, paths) AS (
  SELECT station_name, next_station, 1 AS stops, concat(station_name,'->',next_station)
  FROM bj_subway 
  WHERE station_name = '王府井'
  UNION ALL 
  SELECT t.start_station, t.stop_station, stops+1, concat(paths,'->', s.next_station)
  FROM transfer t
  JOIN bj_subway s ON (t.stop_station = s.station_name)
)
SELECT *
FROM transfer
WHERE stop_station = '积水潭'
LIMIT 0, 200;
```

对于慢查询日志的分析，可以使用MySQL自带的mysqldumpslow工具。例如，查看日志中最慢的5个查询：

```shell
mysqldumpslow -t 5 /var/log/mysql/mysql-slow.log    
```

mysqldumpslow提供的日志分析功能比较简单。我们也可以使用Percona公司的pt-query-digest工具，它提供了更加全面的日志分析功能，可以分析通用日志、二进制日志（binlog）以及慢查询日志等。

```shell
# 分析慢查询日志
pt-query-digest /var/log/mysql/mysql-slow.log

# 分析binlog日志
pt-query-digest --type=binlog mysql-bin.000001.sql 

# 分析普通日志
pt-query-digest --type=genlog localhost.log
```

> ⚠️开启MySQL慢查询日志对性能会产生一定的影响，建议按需使用，一般不建议在生产环境默认启用。

## 3.5 执行计划

执行计划（execution plan，也叫查询计划或者解释计划）是MySQL服务器执行SQL语句的具体步骤。例如，通过索引还是全表扫描访问表中的数据，连接查询的实现方式和连接的顺序，分组和排序操作的实现方式等。

负责生成执行计划的组件就是优化器，优化器利用表结构、字段、索引、查询条件、数据库的统计信息和配置参数决定SQL语句的最佳执行方式。

### 3.5.1 获取执行计划

MySQL提供了[EXPLAIN](https://dev.mysql.com/doc/refman/8.0/en/explain.html)语句，用于获取SQL语句的执行计划。该语句的基本形式如下：

```sql
{EXPLAIN | DESCRIBE | DESC}
{
    SELECT statement
  | TABLE statement
  | DELETE statement
  | INSERT statement
  | REPLACE statement
  | UPDATE statement
}
```

EXPLAIN和DESCRIBE是同义词，可以通用。实际应用中，DESCRIBE主要用于查看表的结构，EXPLAIN主要用于获取执行计划。MySQL可以获取SELECT、INSERT、DELETE、UPDATE、REPLACE等语句的执行计划。MySQL 8.0.19开始，支持[TABLE](https://dev.mysql.com/doc/refman/8.0/en/table.html)语句的执行计划。

举例来说：

```mysql
explain
select *
from employee;

Name         |Value   |
-------------+--------+
id           |1       |
select_type  |SIMPLE  |
table        |employee|
partitions   |        |
type         |ALL     |
possible_keys|        |
key          |        |
key_len      |        |
ref          |        |
rows         |25      |
filtered     |100.0   |
Extra        |        |
```

MySQL中的执行计划包含了12列信息，下表列出了各个字段的作用：

| 列名              | 作用                                                         |
| :---------------- | :----------------------------------------------------------- |
| **id**            | 语句中SELECT的序号。如果是UNION操作的结果，显示为NULL；此时table列显示为 <unionM,N>。 |
| **select_type**   | SELECT 的类型，包括：<br>   SIMPLE，不涉及UNION或者子查询的简单查询；<br>   PRIMARY，最外层SELECT；<br>   UNION，UNION中第二个或之后的SELECT；<br>   DEPENDENT UNION，UNION中第二个或之后的SELECT，该SELECT依赖于外部查询；<br>   UNION RESULT，UNION操作的结果；<br>   SUBQUERY，子查询中的第一个SELECT；<br>   DEPENDENT SUBQUERY，子查询中的第一个SELECT，该SELECT依赖于外部查询；<br>   DERIVED，派生表，即FROM中的子查询；<br>   DEPENDENT DERIVED，依赖于其他表的派生表；<br>   MATERIALIZED，物化子查询；<br>   UNCACHEABLE SUBQUERY，无法缓存结果的子查询，对于外部表中的每一行都需要重新查询；<br> - UNION中第二个或之后的SELECT，该UNION属于UNCACHEABLE SUBQUERY。 |
| **table**         | 数据行的来源表，也有可能是以下值之一：<br>   <unionM,N>，id 为M和N的SELECT并集运算的结果；<br>   \<derivedN>，id 为N的派生表的结果；<br>   \<subqueryN>，id 为N的物化子查询的结果。 |
| **partitions**    | 对于分区表而言，表示数据行所在的分区；普通表显示为 NULL。    |
| **type**          | 连接类型或者访问类型，性能从好到差依次为：<br>    system，表中只有一行数据，这是const类型的特殊情况；<br>    const，最多返回一条匹配的数据，在查询的最开始读取；<br>    eq_ref，对于前面的每一行，从该表中读取一行数据；<br>    ref，对于前面的每一行，从该表中读取匹配索引值的所有数据行；<br>    fulltext，通过FULLTEXT索引查找数据；<br>    ref_or_null，与ref类似，额外加上NULL值查找；<br>    index_merge，使用索引合并优化技术，此时key列显示使用的所有索引；<br>    unique_subquery，替代以下情况时的eq_ref：`value IN (SELECT primary_key FROM single_table WHERE some_expr)`；<br>    index_subquery，与unique_subquery类似，用于子查询中的非唯一索引：`value IN (SELECT key_column FROM single_table WHERE some_expr)`；<br>    range，使用索引查找范围值；<br>    index，与ALL类型相同，只不过扫描的是索引；<br>    ALL，全表扫描，通常表示存在性能问题。 |
| **possible_keys** | 可能用到的索引，实际上不一定使用。                           |
| **key**           | 实际使用的索引。                                             |
| **key_len**       | 实际使用的索引的长度。                                       |
| **ref**           | 用于和key中的索引进行比较的字段或者常量，从而判断是否返回数据行。 |
| **rows**          | 执行查询需要检查的行数，对于InnoDB是一个估计值。             |
| **filtered**      | 根据查询条件过滤之后行数百分比，rows × filtered表示进入下一步处理的行数。 |
| **Extra**         | 包含了额外的信息。例如Using temporary表示使用了临时表，Using filesort表示需要额外的排序操作等。 |

这些字段的含义我们在下文中进行解读。

### 3.5.2 解读执行计划

理解执行计划中每个字段的含义可以帮助我们知悉MySQL内部的操作过程，找到性能问题的所在并有针对性地进行优化。在执行计划的输出信息中，最重要的字段就是type。

**type 字段**

type被称为连接类型（join type）或者访问类型（access type），它显示了MySQL如何访问表中的数据。

访问类型会直接影响到查询语句的性能，性能从好到差依次为：

- **system**，表中只有一行数据（系统表），这是const类型的特殊情况；
- **const**，最多返回一条匹配的数据，在查询的最开始读取；
- **eq_ref**，对于前面的每一行，从该表中读取一行数据；
- **ref**，对于前面的每一行，从该表中读取匹配索引值的所有数据行；
- **fulltext**，通过FULLTEXT索引查找数据；
- **ref_or_null**，与ref类似，额外加上NULL值查找；
- **index_merge**，使用索引合并优化技术，此时key列显示使用的所有索引；
- **unique_subquery**，替代以下情况时的eq_ref: value IN (SELECT primary_key FROM single_table WHERE some_expr)；
- **index_subquery**，与unique_subquery类似，用于子查询中的非唯一索引：value IN (SELECT key_column FROM single_table WHERE some_expr)；
- **range**，使用索引查找范围值；
- **index**，与ALL类型相同，只不过扫描的是索引；
- **ALL**，全表扫描，通常表示存在性能问题。

**const**和**eq_ref**都意味着着通过PRIMARY KEY或者UNIQUE索引查找唯一值；它们的区别在于const对于整个查询只返回一条数据，eq_ref对于前面的结果集中的每条记录只返回一条数据。例如以下查询通过主键（key = PRIMARY）进行等值查找：

```mysql
explain
select * 
from employee
where emp_id = 1;

Name         |Value   |
-------------+--------+
id           |1       |
select_type  |SIMPLE  |
table        |employee|
partitions   |        |
type         |const   |
possible_keys|PRIMARY |
key          |PRIMARY |
key_len      |4       |
ref          |const   |
rows         |1       |
filtered     |100.0   |
Extra        |        |
```

const只返回一条数据，是一种非常快速的访问方式，所以相当于一个常量（constant）。

以下语句通过主键等值连接两个表：

```mysql
explain
select * 
from employee e
join department d
on (e.dept_id = d.dept_id)
where e.emp_id in(1, 2);

id|select_type|table|partitions|type  |possible_keys       |key    |key_len|ref           |rows|filtered|Extra      |
--|-----------|-----|----------|------|--------------------|-------|-------|--------------|----|--------|-----------|
 1|SIMPLE     |e    |          |range |PRIMARY,idx_emp_dept|PRIMARY|4      |              |   2|   100.0|Using where|
 1|SIMPLE     |d    |          |eq_ref|PRIMARY             |PRIMARY|4      |hrdb.e.dept_id|   1|   100.0|           |
```

对于employee中返回的每一行（table = e），department 表通过主键（key = PRIMARY）返回且仅返回一条数据（type = eq_ref）。Extra字段中的Using where表示将经过条件过滤后的数据传递给下个表或者客户端。

**unique_subquery**本质上也是eq_ref索引查找，用于优化以下形式的子查询：

```mysql
value IN (SELECT primary_key FROM single_table WHERE some_expr)
```

**ref**、**ref_or_null**以及**range**表示通过范围查找所有匹配的索引项，然后根据需要再访问表中的数据。通常意味着使用了非唯一索引或者唯一索引的前面部分字段进行数据访问，例如：

```mysql
explain
select * 
from employee e
where e.dept_id = 1;

Name         |Value       |
-------------+------------+
id           |1           |
select_type  |SIMPLE      |
table        |e           |
partitions   |            |
type         |ref         |
possible_keys|idx_emp_dept|
key          |idx_emp_dept|
key_len      |4           |
ref          |const       |
rows         |3           |
filtered     |100.0       |
Extra        |            |

explain
select * 
from employee e
join department d
on (e.dept_id = d.dept_id )
where d.dept_id = 1;

id|select_type|table|partitions|type |possible_keys|key         |key_len|ref  |rows|filtered|Extra|
--|-----------|-----|----------|-----|-------------|------------|-------|-----|----|--------|-----|
 1|SIMPLE     |d    |          |const|PRIMARY      |PRIMARY     |4      |const|   1|   100.0|     |
 1|SIMPLE     |e    |          |ref  |idx_emp_dept |idx_emp_dept|4      |const|   3|   100.0|     |
```

以上两个查询语句都是通过索引idx_emp_dept返回employee表中的数据。

ref_or_null和ref的区别在于查询中包含了IS NULL条件。例如：

```mysql
alter table employee modify column dept_id int null;

explain
select * 
from employee e
where e.dept_id = 1 or dept_id is null;

Name         |Value                |
-------------+---------------------+
id           |1                    |
select_type  |SIMPLE               |
table        |e                    |
partitions   |                     |
type         |ref_or_null          |
possible_keys|idx_emp_dept         |
key          |idx_emp_dept         |
key_len      |5                    |
ref          |const                |
rows         |4                    |
filtered     |100.0                |
Extra        |Using index condition|
```

其中，Extra字段显示为Using index condition，意味着通过索引访问表中的数据之前，直接通过WHERE语句中出现的索引字段条件过滤数据。这是MySQL 5.6之后引入了一种优化，叫做[索引条件下推](https://dev.mysql.com/doc/refman/8.0/en/index-condition-pushdown-optimization.html)（Index Condition Pushdown）。

为了显示ref_or_null，我们需要将字段dept_id设置为可空，测试之后记得重新修改为NOT NULL：

```mysql
alter table employee modify column dept_id int not null;
```

**range**通常出现在使用=、<>、>、>=、<、<=、IS NULL、<=>、BETWEEN、LIKE或者IN()运算符和索引字段进行比较时，例如：

```mysql
explain
select * 
from employee e
where e.email like 'zhang%';

Name         |Value                          |
-------------+-------------------------------+
id           |1                              |
select_type  |SIMPLE                         |
table        |e                              |
partitions   |                               |
type         |range                          |
possible_keys|uk_emp_email,idx_employee_email|
key          |uk_emp_email                   |
key_len      |402                            |
ref          |                               |
rows         |2                              |
filtered     |100.0                          |
Extra        |Using index condition          |
```

**index_subquery**本质上也是ref范围索引查找，用于优化以下形式的子查询：

```mysql
value IN (SELECT key_column FROM single_table WHERE some_expr)
```

**index_merge**表示索引合并，当查询通过多个索引range访问方式返回数据时，MySQL可以先对这些索引扫描结果合并成一个，然后通过这个索引获取表中的数据。例如：

```mysql
explain
select * 
from employee e
where dept_id = 1 or job_id = 1;

Name         |Value                                             |
-------------+--------------------------------------------------+
id           |1                                                 |
select_type  |SIMPLE                                            |
table        |e                                                 |
partitions   |                                                  |
type         |index_merge                                       |
possible_keys|idx_emp_dept,idx_emp_job                          |
key          |idx_emp_dept,idx_emp_job                          |
key_len      |4,4                                               |
ref          |                                                  |
rows         |4                                                 |
filtered     |100.0                                             |
Extra        |Using union(idx_emp_dept,idx_emp_job); Using where|
```

其中，字段key显示了使用的索引列表；Extra中的Using union(PRIMARY,idx_emp_job) 是索引合并的算法，这里采用了并集算法（查询条件使用了or运算符）。

**index**表示扫描整个索引，以下两种情况会使用这种访问方式：

 - 查询可以直接通过索引返回所需的字段信息，也就是index-only scan。此时Extra字段显示为Using index。例如：

   ```mysql
   explain
   select dept_id
   from employee;
   
   Name         |Value       |
   -------------+------------+
   id           |1           |
   select_type  |SIMPLE      |
   table        |employee    |
   partitions   |            |
   type         |index       |
   possible_keys|            |
   key          |idx_emp_dept|
   key_len      |4           |
   ref          |            |
   rows         |25          |
   filtered     |100.0       |
   Extra        |Using index |
   ```

   查询所需的dept_id字段通过扫描索引idx_emp_dept即可获得，所以采用了index访问类型。

 - 通过扫描索引执行全表扫描，从而按照索引的顺序返回数据。此时Extra字段不会出现Using index。

   ```mysql
   explain
   select *
   from employee force index (idx_emp_name)
   order by emp_name;
   
   Name         |Value       |
   -------------+------------+
   id           |1           |
   select_type  |SIMPLE      |
   table        |employee    |
   partitions   |            |
   type         |index       |
   possible_keys|            |
   key          |idx_emp_name|
   key_len      |202         |
   ref          |            |
   rows         |25          |
   filtered     |100.0       |
   Extra        |            |
   ```

   为了演示index访问方式，我们使用了强制索引（force index）；否则，MySQL选择使用全表扫描（ALL）。

**ALL**表示全表扫描，这是一种I/O密集型的操作，通常意味着存在性能问题。例如：

```mysql
explain
select *
from employee;

Name         |Value   |
-------------+--------+
id           |1       |
select_type  |SIMPLE  |
table        |employee|
partitions   |        |
type         |ALL     |
possible_keys|        |
key          |        |
key_len      |        |
ref          |        |
rows         |25      |
filtered     |100.0   |
Extra        |        |
```

因为employee表本身不大，而且我们查询了所有的数据，这种情况下全表扫描反而是一个很好的访问方法。但是，以下查询显然需要进行优化：

```mysql
explain
select *
from employee
where salary = 10000;

Name         |Value      |
-------------+-----------+
id           |1          |
select_type  |SIMPLE     |
table        |employee   |
partitions   |           |
type         |ALL        |
possible_keys|           |
key          |           |
key_len      |           |
ref          |           |
rows         |25         |
filtered     |10.0       |
Extra        |Using where|
```

显然，针对这种查询语句，我们可以通过为salary字段创建一个索引进行优化。

**Extra字段**

执行计划输出中的Extra字段通常会显示更多的信息，可以帮助我们发现性能问题的所在。上文中我们已经介绍了一些Extra字段的信息，需要重点关注的输出内容包括：

 - **Using where**，表示将WHERE条件过滤后的数据传递给下个数据表或者返回客户端。如果访问类型为ALL或者index，而Extra字段不是Using where，意味着查询语句可能存在问题（除非想要获取全部数据）。

 - **Using index condition**，表示通过索引访问表之前，基于查询条件中的索引字段进行一次过滤，只返回必要的索引项。这也就是索引条件下推优化。

 - **Using index**，表示直接通过索引即可返回所需的字段信息（index-only scan），不需要访问表。对于InnoDB，如果通过主键获取数据，不会显示Using index，但仍然是index-only scan。此时，访问类型为index，key字段显示为PRIMARY。

 - **Using filesort**，意味着需要执行额外的排序操作，通常需要占用大量的内存或者磁盘。例如：

   ```mysql
   explain
   select *
   from employee
   where dept_id =3
   order by hire_date;
   
   Name         |Value         |
   -------------+--------------+
   id           |1             |
   select_type  |SIMPLE        |
   table        |employee      |
   partitions   |              |
   type         |ref           |
   possible_keys|idx_emp_dept  |
   key          |idx_emp_dept  |
   key_len      |4             |
   ref          |const         |
   rows         |2             |
   filtered     |100.0         |
   Extra        |Using filesort|
   ```

   索引通常可以用于优化排序操作，我们可以为索引idx_emp_dept增加一个hire_date字段来消除示例中的排序。

 - **Using temporary**，意味着需要创建临时表保存中间结果。例如：

   ```mysql
   explain
   select dept_id,job_id, sum(salary)
   from employee
   group by dept_id, job_id;
   
   Name         |Value          |
   -------------+---------------+
   id           |1              |
   select_type  |SIMPLE         |
   table        |employee       |
   partitions   |               |
   type         |ALL            |
   possible_keys|               |
   key          |               |
   key_len      |               |
   ref          |               |
   rows         |25             |
   filtered     |100.0          |
   Extra        |Using temporary|
   ```

   示例中的分组操作需要使用临时表，同样可以通过增加索引进行优化。

### 3.5.3 访问谓词与过滤谓词

在SQL中，WHERE条件也被称为谓词（predicate）。MySQL数据库中的谓词存在以下三种使用方式：

 - **访问谓词**（access predicate），在执行计划的输出中对应于key_len和ref字段。访问谓词代表了索引叶子节点遍历的开始和结束条件。
 - **索引过滤谓词**（index filter predicate），在执行计划中对应于Extra字段的Using index condition。索引过滤谓词在遍历索引叶子节点时用于判断是否返回该索引项，但是不会用于判断遍历的开始和结束条件，也就不会缩小索引扫描的范围。
 - **表级过滤谓词**（table level filter predicate），在执行计划中对应于Extra字段的Using where。谓词中的非索引字段条件在表级别进行判断，意味着数据库需要访问表中的数据然后再应用该条件。

一般来说，对于相同查询语句，访问谓词的性能好于索引过滤谓词，索引过滤谓词的性能好于表级过滤谓词。

MySQL执行计划中不会显示每个条件对应的谓词类型，而只是笼统地显示使用了哪种谓词类型。我们创建一个示例表：

```mysql
create table test (
  id int not null auto_increment primary key,
  col1 int,
  col2 int,
  col3 int);

insert into test(col1, col2, col3)
values (1,1,1), (2,4,6), (3,6,9);

create index test_idx on test (col1, col2);

analyze table test;
```

以下语句使用col1和col2作为查询条件：

```mysql
explain
select *
from test
where col1=1 and col2=1;

Name         |Value      |
-------------+-----------+
id           |1          |
select_type  |SIMPLE     |
table        |test       |
partitions   |           |
type         |ref        |
possible_keys|test_idx   |
key          |test_idx   |
key_len      |10         |
ref          |const,const|
rows         |1          |
filtered     |100.0      |
Extra        |           |
```

其中，Extra字段为空；key = test_idx表示使用索引进行查找，key_len = 10就是col1和col2两个字段的长度（可空字段长度加1）；ref = const,const表示使用了索引中的两个字段和常量进行比较，从而判断是否返回索引记录。因此，该语句中的WHERE条件是一个访问谓词。

接下来我们仍然使用col1和col2作为查询条件，但是修改一下返回的字段：

```mysql
explain
select id, col1, col2
from test
where col1=1 and col2=1;

Name         |Value      |
-------------+-----------+
id           |1          |
select_type  |SIMPLE     |
table        |test       |
partitions   |           |
type         |ref        |
possible_keys|test_idx   |
key          |test_idx   |
key_len      |10         |
ref          |const,const|
rows         |1          |
filtered     |100.0      |
Extra        |Using index|
```

其中，Extra字段中的Using index不是Using index condition，它是一个index-only scan，因为所有的查询结果都可以通过索引直接返回（包括id）；其他字段的信息和上面的示例相同。因此，该语句中的WHERE条件也是一个访问谓词。

然后使用col1进行范围查询：

```mysql
explain analyze
select *
from test
where col1 between 1 and 2 and col2=1;

-> Index range scan on test using test_idx over (1 <= col1 <= 2 AND col2 = 1), with index condition: ((test.col2 = 1) and (test.col1 between 1 and 2))  (cost=0.71 rows=1) (actual time=0.0234..0.0281 rows=1 loops=1)
```

其中，Extra字段中显示为Using index condition；key_len = 10就是col1和col2两个字段的长度（可空字段长度加1）。该语句中的WHERE条件是一个索引过滤谓词，需要通过索引判断是否访问表中的数据。

最后使用col1和col3作为查询条件：

```mysql
explain
select *
from test
where col1=1 and col3=1;

Name         |Value      |
-------------+-----------+
id           |1          |
select_type  |SIMPLE     |
table        |test       |
partitions   |           |
type         |ref        |
possible_keys|test_idx   |
key          |test_idx   |
key_len      |5          |
ref          |const      |
rows         |1          |
filtered     |33.33      |
Extra        |Using where|
```

其中，Extra字段中显示为Using where，表示访问表中的数据然后再应用查询条件col3=1；key = test_idx表示使用索引进行查找，key_len = 5就是col1字段的长度（可空字段长度加1）；ref = const表示常量等值比较；filtered = 33.33意味着经过查询条件比较之后只保留三分之一的数据。因此，该语句中的WHERE条件是一个表级过滤谓词，意味着数据库需要访问表中的数据然后再应用该条件。

### 3.5.4 EXPLAIN格式化参数

EXPLAIN语句支持使用FORMAT选项指定不同的输出格式：

```mysql
{EXPLAIN | DESCRIBE | DESC}
FORMAT = {TRADITIONAL | JSON | TREE}
explainable_stmt
```

默认的格式为TRADITIONAL，以表格的形式显示输出信息；JSON选项以JSON格式显示信息；MySQL 8.0.16之后支持TREE选项，以树形结构输出了比默认格式更加详细的信息，这也是唯一能够显示hash join的格式。

例如，以下语句输出了JSON格式的执行计划：

```mysql
explain format=json
select *
from employee
where emp_id = 1;

{
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "1.00"
    },
    "table": {
      "table_name": "employee",
      "access_type": "const",
      "possible_keys": [
        "PRIMARY"
      ],
      "key": "PRIMARY",
      "used_key_parts": [
        "emp_id"
      ],
      "key_length": "4",
      "ref": [
        "const"
      ],
      "rows_examined_per_scan": 1,
      "rows_produced_per_join": 1,
      "filtered": "100.00",
      "cost_info": {
        "read_cost": "0.00",
        "eval_cost": "0.10",
        "prefix_cost": "0.00",
        "data_read_per_join": "568"
      },
      "used_columns": [
        "emp_id",
        "emp_name",
        "sex",
        "dept_id",
        "manager",
        "hire_date",
        "job_id",
        "salary",
        "bonus",
        "email"
      ]
    }
  }
}
```

其中，大部分的节点信息和表格形式的字段能够对应；但是也返回了一些额外的信息，尤其是各种操作的成本信息cost_info，可以帮助我们了解不同执行计划之间的成本差异。

以下语句返回了树状结构的执行计划：

```mysql
explain format=tree
select *
from employee e1
join employee e2 
on e1.salary = e2.salary;

-> Inner hash join (e2.salary = e1.salary)  (cost=65.51 rows=63)
    -> Table scan on e2  (cost=0.02 rows=25)
    -> Hash
        -> Table scan on e1  (cost=2.75 rows=25)
```

从结果可以看出，该执行计划使用了Inner hash join实现两个表的连接查询。

### 3.5.5 获取指定连接的执行计划

EXPLAIN语句也可以用于获取指定连接中正在执行的SQL语句的执行计划，语法如下：

```mysql
EXPLAIN [FORMAT = {TRADITIONAL | JSON | TREE}] 
FOR CONNECTION connection_id;
```

其中，connection_id是连接标识符，可以通过字典表INFORMATION_SCHEMA.PROCESSLIST或者 SHOW PROCESSLIST命令获取。如果某个会话中存在长时间运行的慢查询语句，在另一个会话中执行该命令可以获得相关的诊断信息。

首先获取当前连接的会话标识符：

```mysql
mysql> SELECT CONNECTION_ID();
+-----------------+
| CONNECTION_ID() |
+-----------------+
|              30 |
+-----------------+
1 row in set (0.00 sec)
```

如果此时在当前会话中获取执行计划，将会返回错误信息：

```mysql
mysql> EXPLAIN FOR CONNECTION 30;
ERROR 3012 (HY000): EXPLAIN FOR CONNECTION command is supported only for SELECT/UPDATE/INSERT/DELETE/REPLACE
```

因为只有SELECT、UPDATE、INSERT、DELETE、REPLACE语句支持执行计划，而我们当前正在执行的是EXPLAIN语句。

在当前会话中执行一个大表查询：

```mysql
mysql> select * from large_table;
```

然后在另一个会话中执行EXPLAIN命令：

```mysql
explain for connection 30;

id|select_type|table      |partitions|type|possible_keys|key|key_len|ref|rows  |filtered|Extra|
--|-----------|-----------|----------|----|-------------|---|-------|---|------|--------|-----|
 1|SIMPLE     |large_table|          |ALL |             |   |       |   |244296|   100.0|     |
```

如果指定会话没有正在运行的语句，EXPLAIN命令将会返回空结果。

### 3.5.6 获取实际执行计划

MySQL 8.0.18增加了一个新的命令：EXPLAIN ANALYZE。该语句用于运行一个语句并且产生EXPLAIN结果，包括执行时间和迭代器（iterator）信息，可以获取优化器的预期执行计划和实际执行计划之间的差异。

```mysql
{EXPLAIN | DESCRIBE | DESC} ANALYZE select_statement
```

例如，以下EXPLAIN语句返回了查询计划和成本估算：

```mysql
explain format=tree
select * 
from employee e
join department d
on (e.dept_id = d.dept_id )
where e.emp_id in(1, 2);

-> Nested loop inner join  (cost=1.61 rows=2)
    -> Filter: (e.emp_id in (1,2))  (cost=0.91 rows=2)
        -> Index range scan on e using PRIMARY  (cost=0.91 rows=2)
    -> Single-row index lookup on d using PRIMARY (dept_id=e.dept_id)  (cost=0.30 rows=1)
```

那么，实际上的执行计划和成本消耗情况呢？我们可以使用EXPLAIN ANALYZE语句查看：

```mysql
explain analyze 
select * 
from employee e
join department d
on (e.dept_id = d.dept_id )
where e.emp_id in(1, 2);

-> Nested loop inner join  (cost=1.61 rows=2) (actual time=0.238..0.258 rows=2 loops=1)
    -> Filter: (e.emp_id in (1,2))  (cost=0.91 rows=2) (actual time=0.218..0.233 rows=2 loops=1)
        -> Index range scan on e using PRIMARY  (cost=0.91 rows=2) (actual time=0.214..0.228 rows=2 loops=1)
    -> Single-row index lookup on d using PRIMARY (dept_id=e.dept_id)  (cost=0.30 rows=1) (actual time=0.009..0.009 rows=1 loops=2)
```

对于每个迭代器，EXPLAIN ANALYZE输出了以下信息：

 - 估计执行成本，某些迭代器不计入成本模型；
 - 估计返回行数；
 - 返回第一行的实际时间（ms）；
 - 返回所有行的实际时间（ms），如果存在多次循环，显示平均时间；
 - 实际返回行数；
 - 循环次数。

在输出结果中的每个节点包含了下面所有节点的汇总信息，所以最终的估计信息和实际信息如下：

```mysql
-> Nested loop inner join  (cost=1.61 rows=2) (actual time=0.238..0.258 rows=2 loops=1)
```

查询通过嵌套循环内连接实现；估计成本为1.61，估计返回2行数据；实际返回第一行数据的时间为0.238 ms，实际返回所有数据的平均时间为0.258 ms，实际返回了2行数据，嵌套循环操作执行了1次。

循环的实现过程是首先通过主键扫描employee表并且应用过滤迭代器：

```mysql
    -> Filter: (e.emp_id in (1,2))  (cost=0.91 rows=2) (actual time=0.218..0.233 rows=2 loops=1)
        -> Index range scan on e using PRIMARY  (cost=0.91 rows=2) (actual time=0.214..0.228 rows=2 loops=1)
```

其中，应用过滤迭代器返回第一行数据的时间为0.218 ms，包括索引扫描的0.214 ms；返回所有数据的平均时间为0.233 ms，包括索引扫描的0.228 ms；绝大部分时间都消耗在了索引扫描，总共返回了2条数据。

然后循环上一步返回的2条数据，扫描department表的主键返回其他数据：

```mysql
    -> Single-row index lookup on d using PRIMARY (dept_id=e.dept_id)  (cost=0.30 rows=1) (actual time=0.009..0.009 rows=1 loops=2)
```

其中，loops=2表示这个迭代器需要执行2次；每次返回1行数据，所以两个实际时间都是0.009 ms。

以上示例的预期执行计划和实际执行计划基本上没有什么差异。但有时候并不一定如此，例如：

```mysql
explain analyze 
select * 
from employee e
join department d
on (e.dept_id = d.dept_id )
where e.salary = 10000;

-> Nested loop inner join  (cost=3.63 rows=3) (actual time=0.427..0.444 rows=1 loops=1)
    -> Filter: (e.salary = 10000.00)  (cost=2.75 rows=3) (actual time=0.406..0.423 rows=1 loops=1)
        -> Table scan on e  (cost=2.75 rows=25) (actual time=0.235..0.287 rows=25 loops=1)
    -> Single-row index lookup on d using PRIMARY (dept_id=e.dept_id)  (cost=0.29 rows=1) (actual time=0.018..0.018 rows=1 loops=1)
```

我们使用salary字段作为过滤条件，该字段没有索引。执行计划中的最大问题在于估计返回的行数是3，而实际返回的行数是1；这是由于缺少字段的直方图统计信息。

我们对employee表进行分析，收集字段的直方图统计之后再查看执行计划：

```mysql
analyze table employee update histogram on salary;

explain analyze 
select * 
from employee e
join department d
on (e.dept_id = d.dept_id )
where e.salary = 10000;

-> Nested loop inner join  (cost=3.10 rows=1) (actual time=0.092..0.105 rows=1 loops=1)
    -> Filter: (e.salary = 10000.00)  (cost=2.75 rows=1) (actual time=0.082..0.093 rows=1 loops=1)
        -> Table scan on e  (cost=2.75 rows=25) (actual time=0.056..0.080 rows=25 loops=1)
    -> Single-row index lookup on d using PRIMARY (dept_id=e.dept_id)  (cost=0.35 rows=1) (actual time=0.009..0.009 rows=1 loops=1)
```

估计返回的行数变成了1，和实际执行结果相同。

## 3.6 优化案例

### 3.6.1 优化SELECT *

我们应该**避免使用 SELECT \* FROM t**， 因为它表示查询表中的所有字段。这种写法通常导致数据库需要读取更多的数据，尤其是大字段；同时网络也需要传输更多的数据，从而导致性能的下降。

另一个问题是优化器可能无法选择最优执行计划，例如：

```mysql
EXPLAIN 
SELECT id, col1, col2
FROM test;

Name         |Value      |
-------------+-----------+
id           |1          |
select_type  |SIMPLE     |
table        |test       |
partitions   |           |
type         |index      |
possible_keys|           |
key          |test_idx   |
key_len      |10         |
ref          |           |
rows         |3          |
filtered     |100.0      |
Extra        |Using index|

EXPLAIN 
SELECT *
FROM test;

Name         |Value |
-------------+------+
id           |1     |
select_type  |SIMPLE|
table        |test  |
partitions   |      |
type         |ALL   |
possible_keys|      |
key          |      |
key_len      |      |
ref          |      |
rows         |3     |
filtered     |100.0 |
Extra        |      |
```

第一个查询使用了索引覆盖扫描进行优化，第二个查询只能使用全表扫描。

SELECT *存在的主要原因是它可用简化开发，提高代码复用。但是考虑性能的影响，通常不建议这样编写。

### 3.6.2 拆分复杂查询

一般来说，使用更少的查询返回数据会更好，因为可以减少解析和优化次数，以及网络通信的开销等。

但是，MySQL对于多次小的查询也足够高效，有时候将一个复杂的大查询拆分成多个简单的小查询更有优势。例如：将多表连接查询拆分为多个单表查询，然后在应用程序端对结果进行合并处理。

```mysql
SELECT p.title, p.content, ...
FROM tag t
JOIN tag_post tp ON tp.tag_id = t.id
JOIN post p ON p.id = tp.post_id
WHERE t.tag = 'mysql';
```

以上查询可以拆分为下面多个查询：

```mysql
SELECT id FROM tag WHERE tag = 'mysql'; -- 返回1234
SELECT post_id FROM tag_post WHERE tag_id = 1234; -- 返回123、456、789、9098、8904
SELECT p.title, p.content, ... FROM post WHERE id IN (123,456,789,9098,8904);
```

拆分之后的查询可以利用以下优势：

- 应用程序缓存。如果标签mysql的信息已经在缓存中，第一个查询不需要执行。如果文章123、567等已经缓存，第三个查询的IN列表可以更小。
- 单表查询可以减少锁的竞争。
- 可以更容易拆分数据库，提高可扩展性和性能。
- 将IN列表中的ID提前排序，可以提高查询性能。
- 如果连接查询中重复引用同一个表，在应用程序中连接可以减少相同数据的重复访问。

其次，当应用程序可以延迟加载部分信息时，也可以将一个复杂的查询拆分为多个查询，从而提高系统响应。例如，用户查看订单列表时只显示基本信息，点击具体订单时再查询详细信息。

另外，将一个处理大量数据的查询切分批次执行，也可能会优化性能。例如删除旧数据：

```mysql
DELETE FROM log
WHERE create_time < '2023-06-01';
```

一次性删除大量数据会导致大量的锁、事务日志、系统资源消耗。如果拆分成多个批量处理的操作，对系统的性能影响会更小：

```mysql
DELETE FROM log
WHERE create_time < '2023-06-01'
LIMIT 10000;

...
```

当然，拆分查询不应该过度滥用。例如，应用层通过循环调用 N 次相同的查询，每次返回一条记录；或者通过不同的查询返回一行数据中的多个字段。

### 3.6.3 避免索引失效

即使创建了合适的索引，如果SQL语句写的有问题，数据库也不会使用索引。导致索引失效的常见问题包括：

- 在WHERE子句中对索引字段进行表达式运算或者使用函数都会导致索引失效。例如：

  ```mysql
  EXPLAIN 
  SELECT *
  FROM employee
  WHERE dept_id + 1 = 2;
  
  Name         |Value      |
  -------------+-----------+
  id           |1          |
  select_type  |SIMPLE     |
  table        |employee   |
  partitions   |           |
  type         |ALL        |
  possible_keys|           |
  key          |           |
  key_len      |           |
  ref          |           |
  rows         |25         |
  filtered     |100.0      |
  Extra        |Using where|
  ```

- 字段的数据类型不匹配，例如字符串和整数进行比较，包括隐式类型转换，都可能导致索引失效。例如：

  ```mysql
  CREATE TABLE t(id int PRIMARY KEY, num varchar(10), status int);
  CREATE INDEX idx_t_num ON t(num);
  
  EXPLAIN
  SELECT *
  FROM t 
  WHERE num = 1;
  
  Name         |Value      |
  -------------+-----------+
  id           |1          |
  select_type  |SIMPLE     |
  table        |t          |
  partitions   |           |
  type         |ALL        |
  possible_keys|idx_t_num  |
  key          |           |
  key_len      |           |
  ref          |           |
  rows         |1          |
  filtered     |100.0      |
  Extra        |Using where|
  ```

- 字符集不一致的两个字段关联时，也会导致索引无法使用。对于MySQL，尤其需要注意字符集utf8和utf8mb4的区别。

- 复合索引查询条件不满足最左前缀原则，无法使用索引；使用LIKE匹配时，如果通配符出现在左侧无法使用索引。

记住，最重要的是学会使用EXPLAIN查看执行计划，及时发现索引失效并找出原因。

### 3.6.4 优化分页查询

分页查询是指为了改善前端用户的体验和系统性能，将查询结果分批返回和展示。分页查询常用的两种方式：

- **OFFSET分页**，利用OFFSET以及LIMIT子句指定偏移量和返回的行数，性能随着偏移量的增加明显下降。
- **Keyset分页**，利用每次返回的记录集查找下一次的数据，性能不受数据量和偏移量的影响。可以实现页面无限滚动效果。

例如：

```mysql
CREATE TABLE users(
  id integer PRIMARY KEY,
  name varchar(50) NOT NULL,
  pswd varchar(50) NOT NULL,
  email varchar(50),
  create_time timestamp NOT NULL,
  notes varchar(200)
);

INSERT INTO users(id, name, pswd, email,create_time)
WITH RECURSIVE t(id, name, pswd, email,create_time) AS (
SELECT 1, CAST(concat('user', 1) AS char(50)), 'e10adc3949ba59abbe56e057f20f883e', CAST(concat('user',1,'@test.com') AS char(50)), '2020-01-01 00:00:00'
UNION ALL
SELECT id+1, concat('user', id+1), pswd, concat('user',id+1,'@test.com'), create_time+ INTERVAL mod(id,2) MINUTE
FROM t WHERE id<1000000
)
SELECT /*+ SET_VAR(cte_max_recursion_depth = 1M) */* FROM t;

# 创建分页索引
CREATE INDEX idx_user_ct ON users(create_time);

# OFFSET分页 
SELECT *
FROM users
ORDER BY create_time, id
LIMIT 20 OFFSET 100000;

# KEYSET分页 
SELECT *
FROM users
WHERE create_time>='2020-12-02 00:10:00' and id>20
ORDER BY create_time, id
LIMIT 20;
```

两种分页查询的性能比较如下：

<img src="https://img-blog.csdnimg.cn/2bd035cdf8614d658daa3547d644be55.png" alt="2bd035cdf8614d658daa3547d644be55.png (1360×783) (csdnimg.cn)" style="zoom: 33%;" />



### 3.6.5 优化COUNT查询

COUNT(*)、COUNT(1)、COUNT(id)函数的作用都是统计数据的行数，它们的性能区别可以忽略；COUNT(col)函数的作用是统计字段col不为空的行数。

COUNT()函数通常需要扫描大量的数据行，比较难以优化。MySQL可以使用索引覆盖扫描优化，但效果有限。

```mysql
EXPLAIN
SELECT count(*)
FROM employee;

Name         |Value       |
-------------+------------+
id           |1           |
select_type  |SIMPLE      |
table        |e           |
partitions   |            |
type         |index       |
possible_keys|            |
key          |idx_emp_dept|
key_len      |4           |
ref          |            |
rows         |25          |
filtered     |100.0       |
Extra        |Using index |
```

如果业务可以接受近似统计值，可以考虑使用EXPLAIN命令显示的评估值。

其他优化方案包括使用汇总表，以及外部缓存系统（例如Redis）等。

### 3.6.6 SQL子句的执行顺序

以下是SQL中各个子句的语法顺序，前面括号内的数字代表了它们的逻辑执行顺序：

```mysql
(6) SELECT [DISTINCT | ALL] col1, col2, agg_func(col3) AS alias
(1) FROM t1 JOIN t2
(2) ON (join_conditions)
(3) WHERE where_conditions
(4) GROUP BY col1, col2
(5) HAVING having_condition
(7) UNION [ALL]
   ...
(8) ORDER BY col1 ASC,col2 DESC
(9) LIMIT num_rows OFFSET m;
```

SQL并不是按照编写顺序先执行SELECT，然后再执行FROM子句。从逻辑上讲，SQL语句的执行顺序如下：

1. 首先，**FROM和JOIN是SQL语句执行的第一步**。它们的逻辑结果是一个笛卡尔积，决定了接下来要操作的数据集。注意逻辑执行顺序并不代表物理执行顺序，实际上数据库在获取表中的数据之前会使用ON和WHERE过滤条件进行优化访问。
2. 其次，**应用ON条件对上一步的结果进行过滤并生成新的数据集**。
3. 然后，**执行WHERE子句对上一步的数据集再次进行过滤**。WHERE和ON大多数情况下的效果相同，但是外连接查询有所区别，我们将会在下文给出示例。
4. 接着，**基于GROUP BY子句指定的表达式进行分组**；同时，对于每个分组计算聚合函数agg_func的结果。经过GROUP BY处理之后，数据集的结构就发生了变化，只保留了分组字段和聚合函数的结果；
5. 如果存在GROUP BY子句，可以**利用HAVING针对分组后的结果进一步进行过滤**，通常是针对聚合函数的结果进行过滤。
6. 接下来，**SELECT可以指定要返回的列**；如果指定了DISTINCT关键字，需要对结果集进行去重操作。另外还会为指定了AS的字段生成别名。
7. 如果还有**集合操作符**（UNION、INTERSECT、EXCEPT）和其他的SELECT语句，执行该查询并且**合并两个结果集**。
8. 然后，**应用ORDER BY子句对结果进行排序**。如果存在GROUP BY子句或者DISTINCT关键字，只能使用分组字段和聚合函数进行排序；否则，可以使用FROM和 JOIN表中的任何字段排序。
9. 最后，**LIMIT和OFFSET限定了最终返回的行数**。

了解SQL逻辑执行顺序可以帮助我们进行SQL优化。例如WHERE子句在HAVING子句之前执行，因此我们应该尽量使用WHERE进行数据过滤，避免无谓的操作；除非业务需要针对聚合函数的结果进行过滤。

除此之外，理解SQL的逻辑执行顺序还可以帮助我们避免一些常见的错误，例如以下语句：

```mysql
-- 错误示例
SELECT emp_name AS empname
FROM employee
WHERE empname ='张飞';
```

该语句的错误在于WHERE条件中引用了列别名；从上面的逻辑顺序可以看出，执行WHERE条件时还没有执行SELECT子句，也就没有生成字段的别名。

另外一个需要注意的操作就是GROUP BY，例如：

```mysql
-- GROUP BY 错误示例
SELECT dept_id, emp_name, AVG(salary)
FROM employee
GROUP BY dept_id;
```

由于经过GROUP BY处理之后结果集只保留了分组字段和聚合函数的结果，示例中的emp_name字段已经不存在；从业务逻辑上来说，按照部门分组统计之后再显示某个员工的姓名没有意义。如果需要同时显示员工信息和所在部门的汇总，可以使用窗口函数。

> 📝如果使用了GROUP BY分组，之后的SELECT、ORDER BY等只能引用分组字段或者聚合函数；否则，可以引用FROM和JOIN表中的任何字段。

还有一些逻辑问题可能不会直接导致查询出错，但是会返回不正确的结果；例如外连接查询中的ON和WHERE条件。以下是一个左外连接查询的示例：

```mysql
SELECT e.emp_name, d.dept_name
FROM employee e
LEFT JOIN department d ON (e.dept_id = d.dept_id)
WHERE e.emp_name ='张飞';
emp_name|dept_name|
--------|---------|
张飞     |行政管理部|

SELECT e.emp_name, d.dept_name
FROM employee e
LEFT JOIN department d ON (e.dept_id = d.dept_id AND e.emp_name ='张飞');
emp_name|dept_name|
--------|---------|
刘备     |   [NULL]|
关羽     |   [NULL]|
张飞     |行政管理部|
诸葛亮   |   [NULL]|
...
```

第一个查询在ON子句中指定了连接的条件，同时通过WHERE子句找出了“张飞”的信息。

第二个查询将所有的过滤条件都放在ON子句中，结果返回了所有的员工信息。这是因为左外连接会返回左表中的全部数据，即使ON子句中指定了员工姓名也不会生效；而WHERE条件在逻辑上是对连接操作之后的结果进行过滤。

# 第四部分、硬件优化

todo

# 第五部分、配置优化

todo

# 第六部分、架构优化

todo
