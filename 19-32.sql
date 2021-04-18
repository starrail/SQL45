#第五天： 19-32

# 19. 查询每门课程被选修的学生数
SELECT 
    CId, COUNT(*) 学生数
FROM
    SC
GROUP BY CId;


# 20.查询出只选修两门课程的学生学号和姓名
select sid from sc 
group by sid having count(cid)=2;

SELECT 
    sid, sname
FROM
    student
WHERE
    sid IN (SELECT 
            sid
        FROM
            sc
        GROUP BY sid
        HAVING COUNT(cid) = 2);

select a.sid, b.sname from 
(select sid, count(*) from sc 
group by sid having count(cid)=2) a
left join student b using(sid);


# 21. 查询男生、女生人数
SELECT 
    ssex, COUNT(*)
FROM
    student
GROUP BY ssex;


# 22.查询名字中含有「风」字的学生信息
SELECT 
    *
FROM
    student
WHERE
    sname LIKE '%风%' OR '风%';
    
    
# 23.查询同名同性学生名单，并统计同名人数
SELECT 
    a.*
FROM
    student a
        JOIN
    student b 
WHERE
    a.sname = b.sname and a.ssex=b.ssex AND a.sid != b.sid;

select 
sname, ssex, count(*)
from (SELECT 
    a.*
FROM
    student a
        JOIN
    student b 
WHERE
    a.sname = b.sname and a.ssex=b.ssex AND a.sid != b.sid) a 
group by sname, ssex;


# 24. 查询 1990 年出生的学生名单
SELECT 
    *
FROM
    student
WHERE
    sage LIKE '1990%';

SELECT 
    *
FROM
    student
WHERE
    YEAR(sage) = '1990';
    
SELECT 
    *
FROM
    student
WHERE
    LEFT(sage, 4) = '1990';

# 25. 查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
SELECT 
    cid, AVG(score) AS avg_score
FROM
    sc
GROUP BY cid
ORDER BY avg_score desc, cid;


# 26. 查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩
select sid, avg(score) avg_score from sc group by sid having avg(score) >= 85;

SELECT 
    sid, sname, avg_score
FROM
    student
        LEFT JOIN
    (SELECT 
        sid, AVG(score) avg_score
    FROM
        sc
    GROUP BY sid
    HAVING AVG(score) >= 85) a USING (sid); 
    
# 27. 查询课程名称为「数学」，且分数低于 60 的学生姓名和分数
SELECT 
    student.sid, sname, sc. cid, score
FROM
    student
        JOIN
    sc USING (sid)
        JOIN
    course USING (cid)
WHERE
    score < 60 AND cname = '数学';

select cid from course where cname='数学';
select * from sc a left join student b using(sid)
where cid = (select cid from course where cname='数学') and score<60;


# 28. 查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况）
SELECT 
    *
FROM
    student
        LEFT JOIN
    sc USING (sid);
    
    
# 29. 查询任何一门课程成绩在 70 分以上的姓名、课程名称和分数
SELECT 
    c.sname, b.cname, a.score
FROM
    sc a
        LEFT JOIN
    course b USING (cid)
        LEFT JOIN
    student c USING (sid)
WHERE
    score > 70;


# 30.查询不及格的课程
select distinct cid from sc where score<60;
SELECT 
    *
FROM
    course
WHERE
    cid IN (SELECT DISTINCT
            cid
        FROM
            sc
        WHERE
            score < 60);


# 31.查询课程编号为 01 且课程成绩在 80 分以上的学生的学号和姓名
select * from sc;

SELECT 
    sid, sname
FROM
    sc
        left JOIN
    student USING (sid)
WHERE
    cid = '01' AND score > 80;

# 32. 求每门课程的学生人数
SELECT 
    cid, COUNT(sid)
FROM
    sc
GROUP BY cid;
