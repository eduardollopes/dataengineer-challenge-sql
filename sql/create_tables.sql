CREATE TABLE Customer (
    customer_id INTEGER PRIMARY KEY,
    email VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    gender CHAR(1),
    address VARCHAR(255),
    birth_date DATE,
    phone_number VARCHAR(20)
);

CREATE TABLE Seller (
    seller_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_id INTEGER, 
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id)
);


CREATE TABLE Category (
    category_id INTEGER PRIMARY KEY,
    category VARCHAR(255),
    description VARCHAR(255)
);

CREATE TABLE Item (
    item_id INTEGER PRIMARY KEY,
    category_id INTEGER,
    name VARCHAR(255),
    price DECIMAL(10, 2),
    status VARCHAR(255),
    cancellation_date TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE `Order` (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date TIMESTAMP,
    total_order DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE ItemOrder (
    order_id INTEGER,
    item_id INTEGER,
    quantity INTEGER,
    unit_price DECIMAL(10, 2),
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

CREATE TABLE Rating (
    rating_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    item_id INTEGER,
    rating INTEGER,
    comment TEXT,
    rating_date TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

CREATE TABLE HistoryUpdateItems (
    history_id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_id INTEGER,
    previous_price DECIMAL(10, 2),
    previous_status VARCHAR(255),
    operation_type VARCHAR(55),
    update_date TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

CREATE TABLE Shipping (
    shipping_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    shipping_date TIMESTAMP,
    shipping_cost DECIMAL(10, 2),
    delivery_address VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id)
);

CREATE TABLE PaymentMethod (
    payment_method_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    method_name VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE OrderPayment (
    order_id INTEGER,
    payment_method_id INTEGER,
    payment_amount DECIMAL(10, 2),
    PRIMARY KEY (order_id, payment_method_id),
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id),
    FOREIGN KEY (payment_method_id) REFERENCES PaymentMethod(payment_method_id)
);

CREATE TABLE OrderShipping (
    order_id INTEGER,
    shipping_id INTEGER,
    PRIMARY KEY (order_id, shipping_id),
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id),
    FOREIGN KEY (shipping_id) REFERENCES Shipping(shipping_id)
);

CREATE TABLE SubscriptionPlan (
    plan_id INTEGER PRIMARY KEY,
    plan_name VARCHAR(255),
    description TEXT
);

CREATE TABLE CustomerSubscription (
    customer_id INTEGER,
    plan_id INTEGER,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    PRIMARY KEY (customer_id, plan_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (plan_id) REFERENCES SubscriptionPlan(plan_id)
);
