create table `order` (

    id bigint not null auto_increment,
    subtotal decimal(10,2) not null,
    freight_rate decimal(10,2) not null,
    total_value decimal(10,2) not null,

    status varchar(10) not null,

    primary key(id)

) engine=InnoDB default charset=utf8;