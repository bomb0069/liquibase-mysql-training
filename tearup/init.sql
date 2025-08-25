DROP DATABASE IF EXISTS store;
CREATE DATABASE IF NOT EXISTS store CHARACTER SET utf8 COLLATE utf8_general_ci;
USE store;

CREATE TABLE users (
    id BIGINT AUTO_INCREMENT,
    first_name varchar(255),
    last_name varchar(255),
    created timestamp DEFAULT current_timestamp,
    updated timestamp DEFAULT current_timestamp ON UPDATE current_timestamp,
    PRIMARY KEY (id)
) CHARACTER SET utf8 COLLATE utf8_general_ci;

INSERT INTO users (first_name, last_name) VALUES ("sck", "shuhari");


CREATE TABLE products (
    id BIGINT AUTO_INCREMENT,
    product_name varchar(255),
    product_brand varchar(255),
    stock int,
    product_price double,
    image_url varchar(255),
    created timestamp DEFAULT current_timestamp,
    updated timestamp DEFAULT current_timestamp ON UPDATE current_timestamp,
    PRIMARY KEY (id)
) CHARACTER SET utf8 COLLATE utf8_general_ci;

INSERT INTO products (id,product_name,product_brand,stock,product_price,image_url) VALUE 
(1,"Balance Training Bicycle","SportsFun",100,119.95,"/Balance_Training_Bicycle.png"),
(2,"43 Piece dinner Set","CoolKidz",200,12.95,"/43_Piece_dinner_Set.png"),
(3,"Horses and Unicorns Set","CoolKidZ",32,24.95,"/Horses_and_Unicorns_Set.png"),
(4,"Hoppity Ball 26 inch","SportsFun",12,29.95,"/Hoppity_Ball_26_inch.png"),
(5,"Sleeping Queens Board Game","CoolKidZ",10,12.95,"/Sleeping_Queens_Board_Game.png"),
(6,"Princess Palace","CoolKidZ",7,24.95,"/Princess_Palace.png"),
(7,"Best Friends Forever Magnetic Dress Up","CoolKidZ",15,24.95,"/Best_Friends_Forever_Magnetic_Dress_Up.png"),
(8,"City Gargage Truck Lego","Lego",10,19.95,"/City_Gargage_Truck_Lego.png"),
(9,"Kettrike Tricycle","SportsFun",10,249.95,"/Kettrike_Tricycle.png"),
(10,"Princess Training Bicycle","SportsFun",0,119.95,"/Princess_Training_Bicycle.png"),
(11,"Earth DVD Game","VideoVroom",2,34.99,"/Earth_DVD_Game.png"),
(12,"Twilight Board Game","GeekToys",7,24.95,"/Twilight_Board_Game.png"),
(13,"Settlers of Catan Board Game","GeekToys",11,44.95,"/Settlers_of_Catan_Board_Game.png"),
(14,"OMG - Gossip Girl Board Game","GeekToys",14,24.95,"/OMG_Gossip_Girl_Board_Game.png"),
(15,"Sailboat","CoolKidZ",10,24.95,"/Sailboat.png"),
(16,"Scrabble","GeekToys",10,19.95,"/Scrabble.png"),
(17,"Start Wars Darth Vader Lego","GeekToys",9,39.95,"/Start_Wars_Darth_Vader_Lego.png"),
(18,"Snoopy Sno-Cone Machine","Modelz",12,24.95,"/Snoopy_Sno_Cone_Machine.png"),
(19,"Gourmet Cupcake Maker","CoolKidZ",15,39.95,"/Gourmet_Cupcake_Maker.png"),
(20,"Creator Beach House Lego","Lego",0,39.95,"/Creator_Beach_House_Lego.png"),
(21,"Jacques the Peacock Play and Grow","CoolKidZ",7,12.95,"/Jacques_the_Peacock_Play_and_Grow.png"),
(22,"Nutbrown Hare","CoolKidZ",0,12.99,"/Nutbrown_Hare.png"),
(23,"Dancing Aligator","CoolKidZ",4,19.95,"/Dancing_Aligator.png"),
(24,"Mashaka the Monkey","BarnyardBlast",5,36.95,"/Mashaka_the_Monkey.png");

CREATE TABLE shipping_methods (
    id BIGINT AUTO_INCREMENT,
    name varchar(255),
    description varchar(255),
    fee double,
    created timestamp DEFAULT current_timestamp,
    updated timestamp DEFAULT current_timestamp ON UPDATE current_timestamp,
    PRIMARY KEY (id)
) CHARACTER SET utf8 COLLATE utf8_general_ci;

INSERT INTO shipping_methods (id,name,description,fee) VALUE 
(1,"Kerry","4-5 business days",50),
(2,"Thai Post","5-15 business days",50),
(3,"Lineman","1-2 business days",100);

CREATE TABLE payment_methods (
    id BIGINT AUTO_INCREMENT,
    name varchar(255),
    description varchar(255),
    created timestamp DEFAULT current_timestamp,
    updated timestamp DEFAULT current_timestamp ON UPDATE current_timestamp,
    PRIMARY KEY (id)
) CHARACTER SET utf8 COLLATE utf8_general_ci;

INSERT INTO payment_methods (id,name,description) VALUE 
(1,"Credit Card / Debit Card", ""),
(2,"Line Pay", "");

CREATE TABLE carts (
    id BIGINT AUTO_INCREMENT,
    user_id BIGINT,
    product_id BIGINT,
    quantity int,
    created timestamp DEFAULT current_timestamp,
    updated timestamp DEFAULT current_timestamp ON UPDATE current_timestamp,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
) CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE orders (
    id BIGINT AUTO_INCREMENT,
    user_id BIGINT,
    shipping_method_id BIGINT,
    payment_method_id BIGINT,
    sub_total_price double,
    discount_price double,
    total_price double,
    burn_point int,
    earn_point int,
    shipping_fee double,
    transaction_id varchar(255) DEFAULT '',
    status ENUM('created', 'paid', 'completed','cancel') DEFAULT 'created',
    authorized timestamp DEFAULT current_timestamp,
    created timestamp DEFAULT current_timestamp,
    updated timestamp DEFAULT current_timestamp ON UPDATE current_timestamp,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_methods(id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
) CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE order_product (
    order_id BIGINT,
    product_id BIGINT,
    quantity int,
    product_price double
) CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE order_shipping (
    id int AUTO_INCREMENT,
    order_id BIGINT,
    user_id BIGINT,
    method_id BIGINT,
    address varchar(255),
    sub_district varchar(255),
    district varchar(255),
    province varchar(255),
    zip_code varchar(5),
    recipient_first_name varchar(255),
    recipient_last_name varchar(255),
    phone_number varchar(13),
    created timestamp DEFAULT current_timestamp,
    updated timestamp DEFAULT current_timestamp ON UPDATE current_timestamp,
    PRIMARY KEY (id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (method_id) REFERENCES shipping_methods(id)
) CHARACTER SET utf8 COLLATE utf8_general_ci;
