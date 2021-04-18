# 33.假设成绩不重复，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
select tid from teacher where tname='张三';
select cid from course where tid = (select tid from teacher where tname='张三');

SELECT 
    *
FROM
    student
        LEFT JOIN
    sc USING (sid)
WHERE
    cid = (SELECT 
            cid
        FROM
            course
        WHERE
            tid = (SELECT 
                    tid
                FROM
                    teacher
                WHERE
                    tname = '张三'))
ORDER BY score DESC
LIMIT 1;

SELECT 
    *
FROM
    sc a
        LEFT JOIN
    student b USING (sid)
        LEFT JOIN
    course c USING (cid)
        LEFT JOIN
    teacher d USING (tid)
WHERE
    d.tname = '张三'
ORDER BY score DESC
LIMIT 1;

# 34.假设成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
SELECT 
    b.*, dense_rank() over (order by score desc) as score_rank
FROM
    sc a
        LEFT JOIN
    student b USING (sid)
        LEFT JOIN
    course c USING (cid)
        LEFT JOIN
    teacher d USING (tid)
WHERE
    d.tname = '张三';
    
select * 
from (SELECT 
    b.*, dense_rank() over (order by score desc) as score_rank, score
FROM
    sc a
        LEFT JOIN
    student b USING (sid)
        LEFT JOIN
    course c USING (cid)
        LEFT JOIN
    teacher d USING (tid)
WHERE
    d.tname = '张三') a
where score_rank=1;

# 35.查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩
SELECT DISTINCT
    a.*
FROM
    sc a
        JOIN
    sc b ON a.score = b.score AND a.sid = b.sid
        AND a.cid != b.cid;

# 36.查询每门功成绩最好的前两名
select * from (
select *, dense_rank() over (partition by cid order by score) as score_rank from sc) a 
where score_rank <= 2;

# 37.统计每门课程的学生选修人数（超过 5 人的课程才统计）
SELECT 
    cid, COUNT(*)
FROM
    sc
GROUP BY cid
HAVING COUNT(*) > 5;

# 38.检索至少选修两门课程的学生学号
SELECT 
    sid, COUNT(*)
FROM
    sc
GROUP BY sid
HAVING COUNT(*) >= 2;


# 39. 查询选修了全部课程的学生信息
select count(distinct cid) from course;
select sid from sc
group by sid
having count(cid) = (select count(distinct cid) from course);

SELECT 
    *
FROM
    student
WHERE
    sid IN (SELECT 
            sid
        FROM
            sc
        GROUP BY sid
        HAVING COUNT(cid) = (SELECT 
                COUNT(DISTINCT cid)
            FROM
                course));
