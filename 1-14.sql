# 1.查询"01"课程比"02"课程成绩高的学生的信息及课程分数
SELECT 
    *
FROM
    Student a
        JOIN
    SC b USING (SId)
        JOIN
    SC c ON b.CId = '01' AND c.CId = '02'
        AND a.SId = c.SId
WHERE
    b.score > c.score;
    
SELECT 
    *
FROM
    Student a
        JOIN
    SC b USING (SId)
        JOIN
    SC c USING (SID)
WHERE
    b.score > c.score AND b.CId = '01'
        AND c.CId = '02'
        AND a.SId = c.SId;
    
# 1.1 .查询存在" 01 "课程但可能不存在" 02 "课程的情况(不存在时显示为 null )
SELECT 
    *
FROM
    SC a
        LEFT JOIN
    SC b USING (SId)
WHERE
    a.CId = '01' AND b.CId = '02';
    
# 1.2 .查询同时存在01和02课程的情况
SELECT 
    *
FROM
    SC a
        JOIN
    SC b USING (SId)
WHERE
    a.CId = '01' AND b.CId = '02';

# 1.3 .查询选择了02课程但没有01课程的情况
SELECT 
    *
FROM
    SC
WHERE
    SId NOT IN (SELECT 
            SId
        FROM
            SC
        WHERE
            CId = '01')
        AND CId = '02';

# 2.查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩
SELECT 
    SId, AVG(score) avg_score
FROM
    sc
GROUP BY SId
HAVING AVG(score) >= 60;

SELECT 
    a.SId, a.Sname, avg_score
FROM
    Student a
        left JOIN
    (SELECT 
        SId, AVG(score) avg_score
    FROM
        sc
    GROUP BY SId
    HAVING AVG(score) >= 60) b USING (SId);  
    
    
# 3.查询在 SC 表存在成绩的学生信息
SELECT 
    b.*
FROM
    (SELECT 
        SId
    FROM
        SC
    GROUP BY SId) a
        LEFT JOIN
    Student b USING (SId);
    
SELECT 
    *
FROM
    Student
WHERE
    SId IN (SELECT DISTINCT
            (SId)
        FROM
            SC);
            
# 4. 查询所有同学的学生编号、学生姓名、选课总数、所有课程的成绩总和
SELECT 
    a.SId, a.Sname, course_no, total_score
FROM
    Student a
        LEFT JOIN
    (SELECT 
        SId, COUNT(CId) course_no, SUM(score) total_score
    FROM
        SC
    GROUP BY SId) b USING (SId);
    
# 4.1. 查有成绩的学生信息
SELECT 
    *
FROM
    Student
WHERE
    SId IN (SELECT 
            SId
        FROM
            SC
        GROUP BY SId);

# 5.查询「李」姓老师的数量
SELECT 
    COUNT(*)
FROM
    Teacher
WHERE
    Tname LIKE '李%';
    
# 6. 查询学过「张三」老师授课的同学的信息
SELECT 
    s.*
FROM
    Teacher
        JOIN
    Course USING (TId)
        JOIN
    SC USING (CId)
        JOIN
    Student s USING (SId)
WHERE
    Tname = '张三';

# 7. 查询没有学全所有课程的同学的信息
SELECT 
    *
FROM
    Student
WHERE
    SId IN (SELECT 
            SId
        FROM
            SC
        GROUP BY SId
        HAVING COUNT(CId) < (SELECT 
                COUNT(DISTINCT CId)
            FROM
                Course));

SELECT 
    Student.*, ct
FROM
    Student
        JOIN
    (SELECT 
        SId, COUNT(CId) AS ct
    FROM
        SC
    GROUP BY SId
    HAVING ct < (SELECT 
            COUNT(CId)
        FROM
            Course)) b USING (SId);
                
# 8.查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息
SELECT 
    Student.*
FROM
    Student
WHERE
    SId IN (SELECT 
            SId
        FROM
            SC
        WHERE
            CId IN (SELECT 
                    CId
                FROM
                    SC
                WHERE
                    SId = '01'));
                    
SELECT DISTINCT
    student.*
FROM
    Student
        JOIN
    (SELECT 
        *
    FROM
        SC
    WHERE
        CId IN (SELECT 
                CId
            FROM
                SC
            WHERE
                SId = '01')) a;
                
# 9.查询和" 01 "号的同学学习的课程完全相同的其他同学的信息
# 没有学习以外课程且学习数量相等
# 学了01号同学课程以外其他课程的同学
SELECT 
    SId
FROM
    SC
WHERE
    CId NOT IN (SELECT 
            CId
        FROM
            SC
        WHERE
            SId = '01');
# 排除之前找到的同学以及01号同学
SELECT 
    SId
FROM
    SC
WHERE
    SId NOT IN (SELECT 
            SId
        FROM
            SC
        WHERE
            CId NOT IN (SELECT 
                    CId
                FROM
                    SC
                WHERE
                    SId = '01'))
        AND SId != '01'
GROUP BY SId;
#课程数量相等
SELECT 
    SId
FROM
    SC
WHERE
    SId NOT IN (SELECT 
            SId
        FROM
            SC
        WHERE
            CId NOT IN (SELECT 
                    CId
                FROM
                    SC
                WHERE
                    SId = '01'))
        AND SId != '01'
GROUP BY SId
HAVING COUNT(CId) = (SELECT 
        COUNT(CId)
    FROM
        SC
    WHERE
        SId = '01');
# 关联学生表
SELECT 
    b.*
FROM
    (SELECT 
        SId
    FROM
        SC
    WHERE
        SId NOT IN (SELECT 
                SId
            FROM
                SC
            WHERE
                CId NOT IN (SELECT 
                        CId
                    FROM
                        SC
                    WHERE
                        SId = '01'))
            AND SId != '01'
    GROUP BY SId
    HAVING COUNT(CId) = (SELECT 
            COUNT(CId)
        FROM
            SC
        WHERE
            SId = '01')) a
        JOIN
    Student b USING (SId);
            
# 10.查询没学过"张三"老师讲授的任一门课程的学生姓名
# 张三老师教过的课程CId
select cid from course join teacher using (TId) where Tname='张三';
# 关联成绩表获取学过张三老师课程的sid
select sid from sc a left join course b using(cid) join teacher c using(tid) where tname='张三';
# 关联学生表 筛选出没有学过张三课程的sid
SELECT DISTINCT
    (sname)
FROM
    student a
WHERE
    sid NOT IN (SELECT 
            sid
        FROM
            sc a
                LEFT JOIN
            course b USING (cid)
                JOIN
            teacher c USING (tid)
        WHERE
            tname = '张三');

# 11.查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select a.SId, a.Sname, avg(b.score) from Student a join SC b using(SId)
where b.score<60
group by a.SId, a.Sname;
select a.SId, a.Sname, count(*) from Student a join SC b using(SId)
where b.score<60
group by a.SId, a.Sname
having count(*) >= 2;

SELECT 
    a.SId, a.Sname, AVG(b.score)
FROM
    Student a
        JOIN
    SC b USING (SId)
WHERE
    (a.SID , a.Sname) IN (SELECT 
            a.SId, a.Sname
        FROM
            Student a
                JOIN
            SC b USING (SId)
        WHERE
            b.score < 60
        GROUP BY a.SId , a.Sname
        HAVING COUNT(*) >= 2)
GROUP BY a.SId , a.Sname;

# 12.检索" 01 "课程分数小于 60，按分数降序排列的学生信息
SELECT 
    b.*
FROM
    SC a
        JOIN
    Student b USING (SId)
WHERE
    a.CId = '01' AND a.score < 60
ORDER BY a.score DESC;

# 13.按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
select a.sid, b.cid, b.score
from student a 
left join sc b
using(sid);

select sid, avg(score)
from sc
group by sid;

SELECT 
    a.sid, a.cid, a.score, avg_score
FROM
    (SELECT 
        a.sid, b.cid, b.score
    FROM
        student a
    LEFT JOIN sc b USING (sid)) a
        LEFT JOIN
    (SELECT 
        sid, AVG(score) AS avg_score
    FROM
        sc
    GROUP BY sid) b USING (sid)
ORDER BY b.avg_score DESC;

# 14. 查询各科成绩最高分、最低分和平均分
select 
cid, count(*) as 选修人数,
max(score) as max,
min(score) as min, 
avg(score) as avg,
sum(case when score >= 60 then 1 else 0 end)/count(*) as 及格率,
sum(case when score >= 70 and  score < 80 then 1 else 0 end)/count(*) as 中等率,
sum(case when score >= 80 and  score < 90 then 1 else 0 end)/count(*) as 优良率,
sum(case when score >= 90 then 1 else 0 end)/count(*) as 优秀率
from sc 
group by cid
order by count(*) desc, cid asc;

select 
a.*, b.cname
from 
(select 
cid, count(*) as 选修人数,
max(score) as max,
min(score) as min, 
avg(score) as avg,
sum(case when score >= 60 then 1 else 0 end)/count(*) as 及格率,
sum(case when score >= 70 and  score < 80 then 1 else 0 end)/count(*) as 中等率,
sum(case when score >= 80 and  score < 90 then 1 else 0 end)/count(*) as 优良率,
sum(case when score >= 90 then 1 else 0 end)/count(*) as 优秀率
from sc 
group by cid
order by count(*) desc, cid asc) a 
left join course b
using (cid);