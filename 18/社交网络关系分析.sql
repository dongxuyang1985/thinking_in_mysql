-- 创建人员节点表Person
CREATE TABLE Person (
  id INTEGER NOT NULL PRIMARY KEY, -- 编号
  name VARCHAR(50) -- 姓名
) AS NODE;
INSERT INTO Person(id, name)
VALUES (1, '刘一'),(2, '陈二'),(3, '张三'),
       (4, '李四'),(5, '王五'),(6, '赵六'),
       (7, '孙七'),(8, '周八'),(9, '吴九');

-- 创建好友关系表friend
CREATE TABLE friend (
  degree INTEGER -- 好友亲密度
) AS EDGE;
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 1), (SELECT $node_id FROM Person WHERE id = 2), 66);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 2), (SELECT $node_id FROM Person WHERE id = 1), 66);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 1), (SELECT $node_id FROM Person WHERE id = 3), 84);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 3), (SELECT $node_id FROM Person WHERE id = 1), 84);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 1), (SELECT $node_id FROM Person WHERE id = 4), 95);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 4), (SELECT $node_id FROM Person WHERE id = 1), 95);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 1), (SELECT $node_id FROM Person WHERE id = 7), 80);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 7), (SELECT $node_id FROM Person WHERE id = 1), 80);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 1), (SELECT $node_id FROM Person WHERE id = 8), 82);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 8), (SELECT $node_id FROM Person WHERE id = 1), 82);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 2), (SELECT $node_id FROM Person WHERE id = 3), 77);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 3), (SELECT $node_id FROM Person WHERE id = 2), 77);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 2), (SELECT $node_id FROM Person WHERE id = 5), 90);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 5), (SELECT $node_id FROM Person WHERE id = 2), 90);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 3), (SELECT $node_id FROM Person WHERE id = 4), 90);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 4), (SELECT $node_id FROM Person WHERE id = 3), 90);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 4), (SELECT $node_id FROM Person WHERE id = 6), 70);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 6), (SELECT $node_id FROM Person WHERE id = 4), 70);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 5), (SELECT $node_id FROM Person WHERE id = 8), 50);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 8), (SELECT $node_id FROM Person WHERE id = 5), 50);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 7), (SELECT $node_id FROM Person WHERE id = 8), 61);
INSERT INTO friend ($from_id, $to_id, degree) VALUES((SELECT $node_id FROM Person WHERE id = 8), (SELECT $node_id FROM Person WHERE id = 7), 61);
