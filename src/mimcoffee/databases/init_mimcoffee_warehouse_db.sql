-- mimcoffee_warehouse.db initialize script

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    category TEXT,
    unit TEXT NOT NULL DEFAULT 'kg',
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS inventory;
CREATE TABLE inventory (
    inventory_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    quantity REAL NOT NULL DEFAULT 0,
    location TEXT,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS suppliers;
CREATE TABLE suppliers (
    supplier_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    contact_person TEXT,
    phone TEXT,
    email TEXT,
    address TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases (
    purchase_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    supplier_id INTEGER,
    quantity REAL NOT NULL,
    unit_cost REAL,
    total_cost REAL GENERATED ALWAYS AS (quantity * unit_cost) STORED,
    purchase_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    batch_number TEXT,
    expiry_date DATE,
    notes TEXT,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

DROP TABLE IF EXISTS sales_out;
CREATE TABLE sales_out (
    out_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    quantity REAL NOT NULL,
    destination TEXT,
    out_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

DROP TABLE IF EXISTS inventory_log;
CREATE TABLE inventory_log (
    log_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    change_type TEXT CHECK(change_type IN ('IN', 'OUT', 'ADJUST')) NOT NULL,
    quantity_change REAL NOT NULL,
    reason TEXT,
    reference_id INTEGER,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_purchases_date ON purchases(purchase_date);
CREATE INDEX idx_sales_out_date ON sales_out(out_date);


-- Insert sample data

-- Products
INSERT INTO products (product_code, name, category, unit, description) VALUES
('CF-ESP-001', 'Espresso Roast Beans', 'Coffee Beans', 'kg', 'Dark roast espresso beans with chocolate notes'),
('CF-LAT-002', 'Latte Blend Ground', 'Ground Coffee', 'kg', 'Medium grind for smooth lattes'),
('CF-CIT-003', 'Citrus Blend Coffee', 'Flavored Coffee', 'kg', 'Bright and zesty coffee with natural citrus notes'),
('CF-COL-004', 'Cold Brew Concentrate', 'Ready-to-Drink', 'L', 'Smooth cold brew, 2x concentrate'),
('CF-PKT-005', 'Single Origin Pour Over Kits', 'Brew Kits', 'pack', 'Ethiopian Yirgacheffe, 10 units per pack');

-- Suppliers
INSERT INTO suppliers (name, contact_person, phone, email, address) VALUES
('Golden Bean Co.', 'James Wilson', '+1-555-0123', 'james@goldenbean.com', '123 Roast Ave, Seattle, WA'),
('Tropical Aromas Ltd.', 'Lena Martinez', '+1-555-0456', 'lena@tropicalaromas.com', '456 Citrus Lane, Miami, FL'),
('Pure Brew Supplies', 'David Chen', '+1-555-0789', 'david@purebrew.com', '789 Filter St, Portland, OR');

-- Purchases (2025)
INSERT INTO purchases (product_id, supplier_id, quantity, unit_cost, batch_number, expiry_date, purchase_date, notes) VALUES
(1, 1, 50.0, 12.50, 'B2501-ESP', '2026-01-15', '2025-01-10', 'First batch of 2025'),
(3, 2, 30.0, 14.00, 'B2502-CIT', '2026-02-28', '2025-02-14', 'Valentine''s special citrus blend'),
(4, 3, 200.0, 3.20, 'B2503-CB', '2025-08-30', '2025-03-05', 'Cold brew for summer campaign'),
(2, 1, 40.0, 11.80, 'B2504-LAT', '2026-03-10', '2025-04-22', NULL),
(3, 2, 25.0, 14.00, 'B2505-CIT', '2026-04-15', '2025-05-18', 'Restock citrus due to high demand'),
(5, 3, 100.0, 8.50, 'B2506-PO', '2026-06-01', '2025-06-30', 'New product launch');

-- Inventory (reflecting total received stock before sales)
INSERT INTO inventory (product_id, quantity, location) VALUES
(1, 50.0, 'A-01-01'),
(2, 40.0, 'A-01-02'),
(3, 55.0, 'B-02-03'),
(4, 200.0, 'C-03-01'),
(5, 100.0, 'D-04-02');

-- Sales Out (2025)
INSERT INTO sales_out (product_id, quantity, destination, out_date, notes) VALUES
(1, 10.0, 'Downtown Flagship Store', '2025-01-20', NULL),
(3, 15.0, 'Online Orders', '2025-02-20', 'Valentine''s promo sales'),
(4, 50.0, 'Summer Pop-up Cafe', '2025-04-01', 'Event supply'),
(3, 20.0, 'Westside Branch', '2025-06-05', 'Top-selling product'),
(2, 12.0, 'Corporate Client - TechFlow Inc.', '2025-07-10', 'Monthly office supply'),
(5, 30.0, 'Gift Box Campaign', '2025-08-15', 'Holiday pre-order fulfillment');

-- Inventory Log (tracking all movements)
-- IN records
INSERT INTO inventory_log (product_id, change_type, quantity_change, reason, reference_id, timestamp) VALUES
(1, 'IN', 50.0, 'Purchase Receipt', 1, '2025-01-10'),
(3, 'IN', 30.0, 'Purchase Receipt', 2, '2025-02-14'),
(4, 'IN', 200.0, 'Purchase Receipt', 3, '2025-03-05'),
(2, 'IN', 40.0, 'Purchase Receipt', 4, '2025-04-22'),
(3, 'IN', 25.0, 'Purchase Receipt', 5, '2025-05-18'),
(5, 'IN', 100.0, 'Purchase Receipt', 6, '2025-06-30');

-- OUT records
INSERT INTO inventory_log (product_id, change_type, quantity_change, reason, reference_id, timestamp) VALUES
(1, 'OUT', -10.0, 'Sales Dispatch', 1, '2025-01-20'),
(3, 'OUT', -15.0, 'Sales Dispatch', 2, '2025-02-20'),
(4, 'OUT', -50.0, 'Event Fulfillment', 3, '2025-04-01'),
(3, 'OUT', -20.0, 'Branch Restock', 4, '2025-06-05'),
(2, 'OUT', -12.0, 'Corporate Order', 5, '2025-07-10'),
(5, 'OUT', -30.0, 'Campaign Shipment', 6, '2025-08-15');