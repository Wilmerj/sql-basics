CREATE DATABASE clients;

USE clients;

CREATE TABLE if not exists clients (
    id int unsigned primary key auto_increment,
    name varchar(100) not null,
    email varchar(100) not null,
    phone_number varchar(20),
    created_at timestamp not null default current_timestamp,
    modified_at timestamp not null default current_timestamp on update current_timestamp
);


CREATE TABLE if not exists products (
    id int unsigned primary key auto_increment,
    name varchar(100) not null,
    slug varchar(200) not null unique,
    description text,
    created_at timestamp not null default current_timestamp,
    modified_at timestamp not null default current_timestamp on update current_timestamp
    sku varchar(100),
    price decimal(10, 2) not null default 0,
);

CREATE TABLE if not exists bills (
    id int unsigned primary key auto_increment,
    client_id int unsigned not null,
    total float,
    status enum('open', 'paid', 'lost') not null default 'open',
    created_at timestamp not null default current_timestamp,
    modified_at timestamp not null default current_timestamp on update current_timestamp,
    foreign key (client_id) references clients(id)
);


CREATE TABLE if not exists bill_products (
    id int unsigned primary key auto_increment,
    bill_id int unsigned not null,
    product_id int unsigned not null,
    quantity int unsigned not null default 1,
    date_added date not null default (current_date),
    price float not null default 0,
    discount float not null default 0,
    created_at timestamp not null default current_timestamp,
    modified_at timestamp not null default current_timestamp on update current_timestamp,
    foreign key (bill_id) references bills(id)
        on update cascade
        on delete cascade,
    foreign key (product_id) references products(id)
        on update cascade
        on delete cascade
);

CREATE TABLE investment (
    id int unsigned primary key auto_increment,
    product_id int unsigned not null,
    investment int not null default 0
);

/* clients table */
insert into clients (name, email, phone_number) values ('Wilmeriano', 'wilmeriano@gmail.com', '1234567890');

describe clients;
select * from clients;
drop table clients;
select name from clients where rand() < 0.01;
select count(*) from clients;
select * from clients where name like 'Mr.% III' or name like '%IV';
select * from clients where name like '%Gibson%';
select * from clients limit 10;
update clients set name = 'Wilmeriano mamarracho' where id = 10;
select * from clients where id = 10;
update clients set phone_number = null where name like 'wilmeriano%';
alter table clients add column active tinyint not null default 1 after phone_number;
select * from clients order by name asc limit 10;
update clients set active = 0 where id = 164167;
delete from clients where id = 69856 limit 1;
select * from clients where id = 69856;

/* products table */
insert into products (name, slug, description) values ('Iphone 14', 'iphone-14', 'The latest iPhone from Apple') ON DUPLICATE KEY UPDATE description = concat(description, ' ', values(slug));
insert into products (name, slug, description) values ('Iphone 15', 'iphone-15', 'The latest iPhone from Apple'),
select * from products;
select concat('The latest ', values(name), ' from ', values(slug)) from products;
alter table products add column sku varchar(100);
alter table products add column price decimal(10, 2) not null default 0;
select count(*) from products;
select name, price from products where price between 2000 and 2500;
select * from products where name id = 8;
alter table products add column stock int unsigned not null default 100;
update products set stock = stock - 20 where id = 88;
select name, stock, price * stock as total_value from products where price >= 100 and stock > 90 order by total_value asc limit 5, 10;
select count(*) from products where price < 500;
select sum(stock) from products;
select avg(price) from products;
select sum(price * stock) from products;
select email, if(email like '%gmail.com%', 1, 0) as is_gmail, if(email like '%hotmail.com%', 1, 0) as is_hotmail from clients order by rand() limit 30;

select email,
    case
        when email like '%gmail.com%' then 'gmail'
        when email like '%hotmail.com%' then 'hotmail'
        when email like '%yahoo.com%' then 'yahoo'
        else 'other'
    end as email_provider
    from clients order by rand() limit 30;

select
    case
        when email like '%gmail.com%' then 'gmail'
        when email like '%hotmail.com%' then 'hotmail'
        when email like '%yahoo.com%' then 'yahoo'
        else 'other'
    end as email_provider,
    count(*) as total_clients
from clients
where name like 'a%'
group by email_provider
having total_clients > 100
order by total_clients asc;

/* bills table */
insert into bills (client_id, total) values (1, 100.00);
select * from bills;
delete from bills where id = 2;
select count(*) from bills;

/* bill_products table */
insert into bill_products (bill_id, product_id, quantity) values (1, 1, 1);
select * from bill_products;
select count(*) from bill_products;
select * from bill_products where discount > 0;
select * from bill_products where date_added < '2024-09-10';
select * from bill_products where date_added between '2024-09-10' and '2024-09-20';


/* TEST ALTER COMMAND */
create table test (
    id int unsigned primary key auto_increment,
    name varchar(100) not null,
    quantity int unsigned not null default 1,
    created_at timestamp not null default current_timestamp,
    modified_at timestamp not null default current_timestamp on update current_timestamp
);

alter table test add column price float first; /* add column to test table at the first position */
alter table test add column price float after name; /* add column to test table after name column */
alter table test drop column price; /* drop column from test table */
alter table test modify column name varchar(200) not null; /* modify column from test table */
alter table test modify price decimal(10, 2) not null default 0; /* modify column price from test table to decimal(10, 2) and set default value to 0 */
alter table test rename column price to prices; /* rename column price from test table to prices, the type should be the same */
alter table test rename to test_new; /* rename table from test to test_new */


CREATE USER 'platzi'@'localhost' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON *.* TO 'platzi'@'localhost';
FLUSH PRIVILEGES;
exit;

/* investment table */
select * from investment;
insert into investment (product_id, investment) select id, stock * price from products;