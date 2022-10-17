-- 案例分析：社交网络关系
-- 创建用户表t_user
CREATE TABLE t_user(
  user_id   INTEGER PRIMARY KEY,
  user_name VARCHAR(50) NOT NULL
);

INSERT INTO t_user VALUES(1, '刘一');
INSERT INTO t_user VALUES(2, '陈二');
INSERT INTO t_user VALUES(3, '张三');
INSERT INTO t_user VALUES(4, '李四');
INSERT INTO t_user VALUES(5, '王五');
INSERT INTO t_user VALUES(6, '赵六');
INSERT INTO t_user VALUES(7, '孙七');
INSERT INTO t_user VALUES(8, '周八');
INSERT INTO t_user VALUES(9, '吴九');

-- 创建好友关系表t_friend
CREATE TABLE t_friend(
  user_id   INTEGER NOT NULL, 
  friend_id INTEGER NOT NULL, 
  PRIMARY KEY (user_id, friend_id)
);

INSERT INTO t_friend VALUES(1, 2);
INSERT INTO t_friend VALUES(2, 1);
INSERT INTO t_friend VALUES(1, 3);
INSERT INTO t_friend VALUES(3, 1);
INSERT INTO t_friend VALUES(1, 4);
INSERT INTO t_friend VALUES(4, 1);
INSERT INTO t_friend VALUES(1, 7);
INSERT INTO t_friend VALUES(7, 1);
INSERT INTO t_friend VALUES(1, 8);
INSERT INTO t_friend VALUES(8, 1);
INSERT INTO t_friend VALUES(2, 3);
INSERT INTO t_friend VALUES(3, 2);
INSERT INTO t_friend VALUES(2, 5);
INSERT INTO t_friend VALUES(5, 2);
INSERT INTO t_friend VALUES(3, 4);
INSERT INTO t_friend VALUES(4, 3);
INSERT INTO t_friend VALUES(4, 6);
INSERT INTO t_friend VALUES(6, 4);
INSERT INTO t_friend VALUES(5, 8);
INSERT INTO t_friend VALUES(8, 5);
INSERT INTO t_friend VALUES(7, 8);
INSERT INTO t_friend VALUES(8, 7);

-- 创建粉丝表t_follower
CREATE TABLE t_follower(
  user_id     INTEGER NOT NULL, 
  follower_id INTEGER NOT NULL, 
  PRIMARY KEY (user_id, follower_id)
);

INSERT INTO t_follower VALUES(1, 2);
INSERT INTO t_follower VALUES(1, 3);
INSERT INTO t_follower VALUES(1, 4);
INSERT INTO t_follower VALUES(1, 7);
INSERT INTO t_follower VALUES(2, 3);
INSERT INTO t_follower VALUES(3, 4);
INSERT INTO t_follower VALUES(4, 1);
INSERT INTO t_follower VALUES(5, 2);
INSERT INTO t_follower VALUES(5, 8);
INSERT INTO t_follower VALUES(6, 4);
INSERT INTO t_follower VALUES(7, 8);
INSERT INTO t_follower VALUES(8, 1);
INSERT INTO t_follower VALUES(8, 7);

-- 创建关注表t_followed
CREATE TABLE t_followed(
  user_id     INTEGER NOT NULL, 
  followed_id INTEGER NOT NULL, 
  PRIMARY KEY (user_id, followed_id)
);

INSERT INTO t_followed VALUES(1, 4);
INSERT INTO t_followed VALUES(1, 8);
INSERT INTO t_followed VALUES(2, 1);
INSERT INTO t_followed VALUES(2, 5);
INSERT INTO t_followed VALUES(3, 1);
INSERT INTO t_followed VALUES(3, 2);
INSERT INTO t_followed VALUES(4, 1);
INSERT INTO t_followed VALUES(4, 3);
INSERT INTO t_followed VALUES(4, 6);
INSERT INTO t_followed VALUES(7, 1);
INSERT INTO t_followed VALUES(7, 8);
INSERT INTO t_followed VALUES(8, 5);
INSERT INTO t_followed VALUES(8, 7);


-- 查找“赵六”和“孙七”之间的好友关系链
-- MySQL
WITH RECURSIVE relation(uid, fid, hops, path) AS (
  SELECT user_id, friend_id, 0, CONCAT(',', user_id , ',', friend_id)
  FROM t_friend
  WHERE user_id = 6
  UNION ALL
  SELECT r.uid, f.friend_id, hops+1, CONCAT(r.path, ',', f.friend_id)
  FROM relation r
  JOIN t_friend f 
  ON (r.fid = f.user_id) 
  AND (INSTR(r.path, CONCAT(',',f.friend_id,',')) = 0) 
  AND hops < 6
)
SELECT uid, fid, hops, substr(path, 2) AS path
FROM relation 
WHERE fid = 7
ORDER BY hops;

-- Oracle和SQLite
WITH relation(id, fid, hops, path) AS (
  SELECT user_id, friend_id, 0, user_id||','||friend_id
  FROM t_friend
  WHERE user_id = 6
  UNION ALL
  SELECT r.id, f.friend_id, hops+1, r.path||','||f.friend_id
  FROM relation r
  JOIN t_friend f
  ON (r.fid = f.user_id) 
  AND (INSTR(r.PATH, ','||f.friend_id||',') = 0) 
  AND hops < 6
)
SELECT id, fid, hops, path
FROM relation 
WHERE fid = 7
ORDER BY hops;

-- SQL Server
WITH relation(uid, fid, hops, path) AS (
  SELECT user_id, friend_id, 0, CAST(CONCAT(user_id , ',', friend_id) AS varchar)
  FROM t_friend
  WHERE user_id = 6
  UNION ALL
  SELECT r.uid, f.friend_id, hops+1, CAST(CONCAT(r.path, ',', f.friend_id) AS varchar)
  FROM relation r
  JOIN t_friend f 
  ON (r.fid = f.user_id) 
  AND (CHARINDEX(CONCAT(',',f.friend_id,','), r.PATH) = 0) 
  AND hops < 6
)
SELECT uid, fid, hops, path
FROM relation 
WHERE fid = 7
ORDER BY hops;

-- PostgreSQL
WITH RECURSIVE relation(uid, fid, hops, path) AS (
  SELECT user_id, friend_id, 0, CAST(CONCAT(user_id , ',', friend_id) AS varchar)
  FROM t_friend
  WHERE user_id = 6
  UNION ALL
  SELECT r.uid, f.friend_id, hops+1, CAST(CONCAT(r.path, ',', f.friend_id) AS varchar)
  FROM relation r
  JOIN t_friend f 
  ON (r.fid = f.user_id) 
  AND (POSITION(CONCAT(',',f.friend_id,',') IN r.PATH) = 0) 
  AND hops < 6
)
SELECT uid, fid, hops, path
FROM relation 
WHERE fid = 7
ORDER BY hops;
