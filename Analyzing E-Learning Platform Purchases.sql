-- Create the Database --
create database if not exists elearning;
use elearning;

-- Create the Tables --
create table if not exists learners (
    learner_id int primary key,
    full_name varchar(100),
    country varchar(50)
);

create table if not exists courses (
    course_id int primary key,
    course_name varchar(100),
    category varchar(50),
    unit_price decimal(10)
);

create table if not exists purchases (
    purchase_id int primary key,
    learner_id int,
    course_id int,
    quantity int,
    purchase_date date,
    foreign key (learner_id) references learners(learner_id),
    foreign key (course_id) references courses(course_id)
);

-- Insert Sample Data --
insert into learners values
(1, 'lekha', 'chennai'),
(2, 'jeeva', 'coimbatore'),
(3, 'karthik', 'hyderabad'),
(4, 'ananya', 'bangalore'),
(5, 'vignesh', 'delhi');

insert into courses values
(101, 'data analytics', 'analytics', 12000),
(102, 'cybersecurity', 'security', 18000),
(103, 'full-stack', 'development', 25000),
(104, 'data science', 'data & ai', 30000),
(105, 'digital marketing', 'marketing', 15000);

insert into purchases values
(1001, 1, 101, 1, '2024-01-10'),
(1002, 1, 102, 1, '2024-01-15'),
(1003, 2, 101, 2, '2024-02-05'),
(1004, 3, 103, 1, '2024-02-20'),
(1005, 3, 104, 1, '2024-03-01'),
(1006, 5, 104, 1, '2024-03-18');

-- Data Exploration --

select format (unit_price, 2) as formatted_unit_price from courses;

select SUM(c.unit_price * p.quantity) as total_revenue from purchases p
join courses c on p.course_id = c.course_id;

select l.full_name, sum(p.quantity * c.unit_price) as total_spent from learners l
join purchases p on l.learner_id = p.learner_id
join courses c on p.course_id = c.course_id
group by l.full_name
order by total_spent desc
limit 1;

-- purchasing learners only --
select l.full_name as learner_name,
    c.course_name as course_name,
    c.category as course_category,
    p.quantity as quantity_purchased,
    p.quantity * c.unit_price as total_amount,
    p.purchase_date as purchase_date from purchases p
inner join learners l on p.learner_id = l.learner_id
inner join courses c on p.course_id = c.course_id;

-- all learners including non-purchasers --
select l.full_name as learner_name,
    c.course_name as course_name,
    c.category as course_category,
    p.quantity as quantity_purchased,
    p.quantity * c.unit_price as total_amount,
    p.purchase_date as purchase_date from learners l
left join purchases p on l.learner_id = p.learner_id
left join courses c on p.course_id = c.course_id;

-- all courses including non-purchased --
select l.full_name as learner_name,
    c.course_name as course_name,
    c.category as course_category,
    p.quantity as quantity_purchased,
    p.quantity * c.unit_price as total_amount,
    p.purchase_date as purchase_date from purchases p
right join courses c on p.course_id = c.course_id
left join learners l on p.learner_id = l.learner_id;

--  Analytical Queries --
-- Total spending per learner --
select l.full_name as learner_name,
    l.country as country,
    sum(p.quantity * c.unit_price) as total_spent from learners l
inner join purchases p on l.learner_id = p.learner_id
inner join courses c on p.course_id = c.course_id
group by l.full_name, l.country;

-- Top 3 most purchased courses --
select c.course_name as course,
    sum(p.quantity) as total_quantity_sold from purchases p
inner join courses c on p.course_id = c.course_id
group by c.course_name
order by total_quantity_sold desc
limit 3;

-- Course category total revenue & unique learners --
select c.category as course_category,
    sum(p.quantity * c.unit_price) as total_revenue,
    count(distinct p.learner_id) as unique_learners from purchases p
inner join courses c on p.course_id = c.course_id
group by c.category;

-- Learners who purchased from more than one category --
select l.full_name as learner_name,
    count(distinct c.category) as category_count from purchases p
inner join learners l on p.learner_id = l.learner_id
inner join courses c on p.course_id = c.course_id
group by l.full_name
having count(distinct c.category) > 1;

-- Courses not purchased --
select c.course_name as course,
    c.category as course_category from courses c
left join purchases p on c.course_id = p.course_id
where p.purchase_id is null;


