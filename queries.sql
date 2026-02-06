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
    created_at timestamp not null default current_timestamp,
    modified_at timestamp not null default current_timestamp on update current_timestamp,
    foreign key (bill_id) references bills(id)
        on update cascade
        on delete cascade,
    foreign key (product_id) references products(id)
        on update cascade
        on delete cascade
);

/* clients table */
insert into clients (name, email, phone_number) values ('Wilmeriano', 'wilmeriano@gmail.com', '1234567890');

describe clients;
select * from clients;

drop table clients;

/* products table */
insert into products (name, slug, description) values ('Iphone 14', 'iphone-14', 'The latest iPhone from Apple');
select * from products;

/* bills table */
insert into bills (client_id, total) values (1, 100.00);
select * from bills;
delete from bills where id = 2;

/* bill_products table */
insert into bill_products (bill_id, product_id, quantity) values (1, 1, 1);
select * from bill_products;


/* TEST ALTER COMMAND */
create table test (
    id int unsigned primary key auto_increment,
    name varchar(100) not null,
    quantity int unsigned not null default 1,
    created_at timestamp not null default current_timestamp,
    modified_at timestamp not null default current_timestamp on update current_timestamp
);

alter table test add column price float not null default 0; /* add column to test table */
alter table test drop column price; /* drop column from test table */