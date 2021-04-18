# 15. 按各科成绩进行排序，并显示排名， Score 重复时保留名次空缺 
# row_nuber(), rank(), dense_rank()的区别
	#row_number(): 依次排序，不会出现相同排名
    #rank(): 出现相同排名时，跳跃排序
    #dense_rank():出现相同排名时，连续排序
select *, row_number() over (partition by cid order by score desc) from sc;

# 15.1 按各科成绩进行排序，并显示排名， Score 重复时合并名次
select *, rank() over (partition by cid order by score desc) from sc;
select *, dense_rank() over (partition by cid order by score desc) from sc;

# 16. 查询学生的总成绩，并进行排名，总分重复时保留名次空缺 
select sid, sum(score) as sum_score from sc group by sid;

select *, rank() over (order by sum_score desc) as ranking from 
(select sid, sum(score) as sum_score from sc group by sid) a;

# 16.1 查询学生的总成绩，并进行排名，总分重复时不保留名次空缺
select *, dense_rank() over (order by sum_score desc) as ranking from 
(select sid, sum(score) as sum_score from sc group by sid) a;

#17. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
select cid, 
concat(sum(case when score>=0 and score<60 then 1 else 0 end)/count(*),'%') as '[60-0]',
concat(sum(case when score>=60 and score<70 then 1 else 0 end)/count(*),'%') as '[70-60]',
concat(sum(case when score>=70 and score<80 then 1 else 0 end)/count(*),'%') as '[85-60]',
concat(sum(case when score>=85 and score<100 then 1 else 0 end)/count(*),'%') as '[100-85]'
from sc
group by cid;

SELECT 
    a.*, b.cname
FROM
    (SELECT 
        cid,
            CONCAT(SUM(CASE
                WHEN score >= 0 AND score < 60 THEN 1
                ELSE 0
            END) / COUNT(*), '%') AS '[60-0]',
            CONCAT(SUM(CASE
                WHEN score >= 60 AND score < 70 THEN 1
                ELSE 0
            END) / COUNT(*), '%') AS '[70-60]',
            CONCAT(SUM(CASE
                WHEN score >= 70 AND score < 80 THEN 1
                ELSE 0
            END) / COUNT(*), '%') AS '[85-60]',
            CONCAT(SUM(CASE
                WHEN score >= 85 AND score < 100 THEN 1
                ELSE 0
            END) / COUNT(*), '%') AS '[100-85]'
    FROM
        sc
    GROUP BY cid) a
        JOIN
    course b USING (cid);

# 18.查询各科成绩前三名的记录
select *, dense_rank() over(partition by cid order by score desc) as ranking
from sc;

select * from 
(select *, dense_rank() over(partition by cid order by score desc) as ranking
from sc) a
where ranking<=3;
