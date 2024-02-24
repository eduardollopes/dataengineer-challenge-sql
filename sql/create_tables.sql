CREATE DATABASE MercadoLivre;

USE MercadoLivre;

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    email VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    gender CHAR(1),
    address VARCHAR(255),
    birth_date DATE,
    phone_number VARCHAR(20)
);

CREATE TABLE Category (
    category_id INT PRIMARY KEY,
    description VARCHAR(255)
);

CREATE TABLE Item (
    item_id INT PRIMARY KEY,
    category_id INT,
    name VARCHAR(255),
    price DECIMAL(10, 2),
    status VARCHAR(255),
    cancellation_date DATE,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Order (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_order DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE ItemOrder (
    order_id INT,
    item_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES Order(order_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

CREATE TABLE Rating (
    rating_id INT PRIMARY KEY,
    customer_id INT,
    item_id INT,
    rating INT,
    comment TEXT,
    rating_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

CREATE TABLE HistoryUpdateItems (
    history_id INT PRIMARY KEY,
    item_id INT,
    previous_price DECIMAL(10, 2),
    previous_status VARCHAR(255),
    update_date DATE,
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);
