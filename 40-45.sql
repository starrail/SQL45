# 40. 查询各学生的年龄，只按年份来算
SELECT 
    year(now())-year(sage) as age
FROM
    Student;

# 41. 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一
SELECT 
    *, TIMESTAMPDIFF(YEAR, sage, NOW()) as age
FROM
    student;

# 42. 查询本周过生日的学生
SELECT 
    *
FROM
    student
WHERE
    WEEK(sage) = WEEK(NOW());
    
# 43. 查询下周过生日的学生
SELECT 
    *
FROM
    student
WHERE
    WEEK(sage) = WEEK(NOW()) + 1;
    
# 44. 查询本月过生日的学生
SELECT 
    *
FROM
    student
WHERE
    MONTH(sage) = MONTH(NOW());
    
# 45. 查询下月过生日的学生
SELECT 
    *
FROM
    student
WHERE
    MONTH(sage) = MONTH(NOW())+1;
