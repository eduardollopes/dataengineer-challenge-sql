INSERT INTO Item (category_id, name, price, status, cancellation_date)
VALUES
    (1, 'Smartphone X', 599.99, 'Active', '2023-02-21'),
    (2, 'Laptop Y', 1299.99, 'Active', '2023-02-20'),
    (3, 'Headphones Z', 79.99, 'Active', '2023-02-19'),
    (4, 'Smartwatch W', 149.99, 'Inactive', '2023-02-18'),
    (5, 'Camera V', 499.99, 'Active', '2023-02-17');

UPDATE Item
SET status = 'Active'
WHERE status = 'Inactive';

UPDATE Item
SET price = price + 49.99
WHERE price between 0 and 199.99;

INSERT INTO Item (category_id, name, price, status, cancellation_date)
VALUES
    (1, 'Fone de ouvido Bluetoth', 49.99, 'Active', '2024-01-01'),
    (2, 'Microfone Karaoke', 9.99, 'Active', '2024-01-01');