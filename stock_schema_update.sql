-- BACKUP & UNDO: DROP TABLE IF EXISTS material_allocations; ALTER TABLE materials DROP COLUMN total_stock IF EXISTS;

-- ADD STOCK ALLOCATION
ALTER TABLE materials ADD COLUMN total_stock DECIMAL(10,2) DEFAULT 0 COMMENT 'Initial total stock for material';

CREATE TABLE IF NOT EXISTS material_allocations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  material_id INT NOT NULL,
  project_id INT NOT NULL,
  allocated_qty DECIMAL(10,2) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (material_id) REFERENCES materials(id) ON DELETE CASCADE,
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
  UNIQUE KEY unique_allocation (material_id, project_id)
);

-- View for remaining stock
CREATE OR REPLACE VIEW material_stock_status AS
SELECT 
  m.id,
  m.name,
  m.total_stock,
  COALESCE(SUM(ma.allocated_qty), 0) as allocated_stock,
  (m.total_stock - COALESCE(SUM(ma.allocated_qty), 0)) as remaining_stock
FROM materials m
LEFT JOIN material_allocations ma ON m.id = ma.material_id
GROUP BY m.id;

