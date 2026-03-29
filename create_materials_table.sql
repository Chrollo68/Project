-- Run this in phpMyAdmin or MySQL to create table
CREATE TABLE IF NOT EXISTS materials (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  quantity DECIMAL(10,2) NOT NULL,
  unit VARCHAR(50),
  price_per_unit DECIMAL(10,2) NOT NULL,
  total_cost DECIMAL(10,2) NOT NULL,
  project_id INT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE SET NULL
);

