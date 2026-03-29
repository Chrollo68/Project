-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 29, 2026 at 09:52 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cividesk_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` int(11) NOT NULL,
  `labour_id` int(11) NOT NULL,
  `att_date` date NOT NULL,
  `status` enum('present','absent') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`id`, `labour_id`, `att_date`, `status`, `created_at`) VALUES
(1, 2, '2025-12-25', 'present', '2025-12-25 13:00:28'),
(2, 3, '2025-12-25', 'present', '2025-12-25 13:00:28'),
(3, 4, '2025-12-25', 'absent', '2025-12-25 13:00:28'),
(4, 7, '2025-12-25', 'absent', '2025-12-25 13:00:28'),
(5, 8, '2025-12-25', 'present', '2025-12-25 13:00:28'),
(6, 2, '2025-12-24', 'present', '2025-12-25 13:55:12'),
(7, 3, '2025-12-24', 'present', '2025-12-25 13:55:12'),
(8, 4, '2025-12-24', 'present', '2025-12-25 13:55:12'),
(9, 7, '2025-12-24', 'absent', '2025-12-25 13:55:12'),
(10, 8, '2025-12-24', 'absent', '2025-12-25 13:55:12'),
(11, 2, '2025-12-20', 'absent', '2025-12-25 13:55:32'),
(12, 3, '2025-12-20', 'absent', '2025-12-25 13:55:32'),
(13, 4, '2025-12-20', 'present', '2025-12-25 13:55:32'),
(14, 7, '2025-12-20', 'present', '2025-12-25 13:55:32'),
(15, 8, '2025-12-20', 'absent', '2025-12-25 13:55:32'),
(16, 2, '2025-12-27', 'present', '2025-12-27 14:26:47'),
(17, 3, '2025-12-27', 'present', '2025-12-27 14:26:47'),
(18, 4, '2025-12-27', 'absent', '2025-12-27 14:26:47'),
(19, 7, '2025-12-27', 'present', '2025-12-27 14:26:47'),
(20, 8, '2025-12-27', 'absent', '2025-12-27 14:26:47'),
(21, 2, '2025-12-28', 'present', '2025-12-28 15:41:22'),
(22, 3, '2025-12-28', 'absent', '2025-12-28 15:41:22'),
(23, 4, '2025-12-28', 'absent', '2025-12-28 15:41:22'),
(24, 7, '2025-12-28', 'absent', '2025-12-28 15:41:22'),
(25, 8, '2025-12-28', 'present', '2025-12-28 15:41:22'),
(48, 2, '2026-01-01', 'present', '2026-01-01 12:46:24'),
(49, 3, '2026-01-01', 'absent', '2026-01-01 12:46:24'),
(50, 4, '2026-01-01', 'present', '2026-01-01 12:46:24'),
(51, 7, '2026-01-01', 'present', '2026-01-01 12:46:24'),
(52, 8, '2026-01-01', 'absent', '2026-01-01 12:46:24'),
(53, 9, '2026-01-01', 'absent', '2026-01-01 12:46:24'),
(54, 15, '2026-02-25', 'absent', '2026-02-25 06:15:24'),
(55, 14, '2026-02-25', 'absent', '2026-02-25 06:15:24'),
(56, 13, '2026-02-25', 'absent', '2026-02-25 06:15:24'),
(57, 12, '2026-02-25', 'absent', '2026-02-25 06:15:24'),
(58, 11, '2026-02-25', 'absent', '2026-02-25 06:15:24'),
(59, 10, '2026-02-25', 'absent', '2026-02-25 06:15:24'),
(60, 9, '2026-02-25', 'absent', '2026-02-25 06:15:24'),
(61, 8, '2026-02-25', 'absent', '2026-02-25 06:15:24'),
(62, 7, '2026-02-25', 'absent', '2026-02-25 06:15:24'),
(63, 4, '2026-02-25', 'absent', '2026-02-25 06:15:24'),
(64, 3, '2026-02-25', 'absent', '2026-02-25 06:15:24'),
(65, 15, '2026-02-24', 'absent', '2026-02-25 06:25:46'),
(66, 14, '2026-02-24', 'absent', '2026-02-25 06:25:46'),
(67, 13, '2026-02-24', 'absent', '2026-02-25 06:25:46'),
(68, 12, '2026-02-24', 'absent', '2026-02-25 06:25:46'),
(69, 11, '2026-02-24', 'absent', '2026-02-25 06:25:46'),
(70, 10, '2026-02-24', 'absent', '2026-02-25 06:25:46'),
(71, 9, '2026-02-24', 'absent', '2026-02-25 06:25:46'),
(72, 8, '2026-02-24', 'absent', '2026-02-25 06:25:46'),
(73, 7, '2026-02-24', 'absent', '2026-02-25 06:25:46'),
(74, 4, '2026-02-24', 'absent', '2026-02-25 06:25:46'),
(75, 3, '2026-02-24', 'absent', '2026-02-25 06:25:46'),
(76, 15, '2026-02-23', 'absent', '2026-02-25 06:26:00'),
(77, 14, '2026-02-23', 'absent', '2026-02-25 06:26:00'),
(78, 13, '2026-02-23', 'absent', '2026-02-25 06:26:00'),
(79, 12, '2026-02-23', 'absent', '2026-02-25 06:26:00'),
(80, 11, '2026-02-23', 'absent', '2026-02-25 06:26:00'),
(81, 10, '2026-02-23', 'absent', '2026-02-25 06:26:00'),
(82, 9, '2026-02-23', 'absent', '2026-02-25 06:26:00'),
(83, 8, '2026-02-23', 'absent', '2026-02-25 06:26:00'),
(84, 7, '2026-02-23', 'absent', '2026-02-25 06:26:00'),
(85, 4, '2026-02-23', 'absent', '2026-02-25 06:26:00'),
(86, 3, '2026-02-23', 'absent', '2026-02-25 06:26:00'),
(87, 15, '2026-02-22', 'absent', '2026-02-25 06:26:12'),
(88, 14, '2026-02-22', '', '2026-02-25 06:26:13'),
(89, 13, '2026-02-22', 'present', '2026-02-25 06:26:13'),
(90, 12, '2026-02-22', 'absent', '2026-02-25 06:26:13'),
(91, 11, '2026-02-22', 'absent', '2026-02-25 06:26:13'),
(92, 10, '2026-02-22', 'absent', '2026-02-25 06:26:13'),
(93, 9, '2026-02-22', 'absent', '2026-02-25 06:26:13'),
(94, 8, '2026-02-22', 'absent', '2026-02-25 06:26:13'),
(95, 7, '2026-02-22', 'absent', '2026-02-25 06:26:13'),
(96, 4, '2026-02-22', 'absent', '2026-02-25 06:26:13'),
(97, 3, '2026-02-22', 'absent', '2026-02-25 06:26:13'),
(98, 15, '2026-02-21', 'absent', '2026-02-25 06:26:24'),
(99, 14, '2026-02-21', 'absent', '2026-02-25 06:26:24'),
(100, 13, '2026-02-21', 'absent', '2026-02-25 06:26:24'),
(101, 12, '2026-02-21', 'absent', '2026-02-25 06:26:24'),
(102, 11, '2026-02-21', 'absent', '2026-02-25 06:26:24'),
(103, 10, '2026-02-21', 'absent', '2026-02-25 06:26:24'),
(104, 9, '2026-02-21', 'absent', '2026-02-25 06:26:24'),
(105, 8, '2026-02-21', 'absent', '2026-02-25 06:26:24'),
(106, 7, '2026-02-21', 'absent', '2026-02-25 06:26:24'),
(107, 4, '2026-02-21', 'absent', '2026-02-25 06:26:24'),
(108, 3, '2026-02-21', 'absent', '2026-02-25 06:26:24'),
(109, 16, '2026-02-25', 'present', '2026-02-25 06:42:59'),
(110, 16, '2026-02-21', 'present', '2026-02-25 06:43:08'),
(111, 16, '2026-02-23', 'present', '2026-02-25 06:43:21'),
(112, 16, '2026-02-24', 'present', '2026-02-25 06:43:26'),
(113, 16, '2026-02-26', 'present', '2026-02-26 06:23:16'),
(114, 15, '2026-02-26', 'present', '2026-02-26 06:23:16'),
(115, 14, '2026-02-26', 'present', '2026-02-26 06:23:16'),
(116, 13, '2026-02-26', 'present', '2026-02-26 06:23:16'),
(117, 12, '2026-02-26', 'present', '2026-02-26 06:23:16'),
(118, 11, '2026-02-26', 'present', '2026-02-26 06:23:16'),
(119, 10, '2026-02-26', 'present', '2026-02-26 06:23:16'),
(120, 9, '2026-02-26', 'present', '2026-02-26 06:23:16'),
(121, 8, '2026-02-26', 'present', '2026-02-26 06:23:16'),
(122, 7, '2026-02-26', '', '2026-02-26 06:23:16'),
(123, 4, '2026-02-26', 'present', '2026-02-26 06:23:16'),
(124, 3, '2026-02-26', 'absent', '2026-02-26 06:23:16');

-- --------------------------------------------------------

--
-- Table structure for table `labour`
--

CREATE TABLE `labour` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `role` varchar(100) DEFAULT NULL,
  `wage` double DEFAULT NULL,
  `contact` varchar(50) DEFAULT NULL,
  `status` enum('active','deleted') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `labour`
--

INSERT INTO `labour` (`id`, `name`, `role`, `wage`, `contact`, `status`) VALUES
(1, 'Tushar Bodekar', 'plumber', 700, '9401267854', 'deleted'),
(2, 'Shubham Narvekar', 'Carpenter', 800, '6756345216', 'deleted'),
(3, 'karan mondkar', 'worker', 700, '7645232187', 'active'),
(4, 'Lajari Gawade', 'Carpenter', 750, '8275045685', 'active'),
(5, 'Pratiksha Patade', 'Labor', 150, '1254789645', 'deleted'),
(6, 'Purva Patade', 'Manager', 150, '9356893656', 'deleted'),
(7, 'Sanika Keluskar', 'Labor', 200, '9871223156', 'active'),
(8, 'Raj Sawant', 'Worker', 300, '9404157896', 'active'),
(9, 'Sandesh Chavan', 'Electrician', 450, '940415789', 'active'),
(10, 'Sameer Parab', 'labor', 500, '7896452178', 'active'),
(11, 'samar kanade', 'labour', 600, '9745863214', 'active'),
(12, 'Shubhank Shekhar Vengurlekar', 'labour', 250, '897546123', 'active'),
(13, 'tanu salunke', 'supervisior', 3000, '7977389682', 'active'),
(14, 'Swati Vikas Mestry', 'Carpenter', 400, '9182934585', 'active'),
(15, 'Samar Sandip Pawar', 'engineer', 1500, '789645267', 'active'),
(16, 'Divya Sutar', 'Carpenter', 500, '7896451257', 'active'),
(17, 'nidhi', 'saf safai', 12345, '9885647565', 'active'),
(18, 'munni', 'khadi fodne', 6767, '8383838383', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `labour_account_balances`
--

CREATE TABLE `labour_account_balances` (
  `id` int(11) UNSIGNED NOT NULL,
  `labour_id` int(11) UNSIGNED NOT NULL,
  `total_earnings` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_advance` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_payments` decimal(12,2) NOT NULL DEFAULT 0.00,
  `current_balance` decimal(12,2) NOT NULL DEFAULT 0.00,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `labour_account_balances`
--

INSERT INTO `labour_account_balances` (`id`, `labour_id`, `total_earnings`, `total_advance`, `total_payments`, `current_balance`, `updated_at`, `created_at`) VALUES
(1, 3, 0.00, 1000.00, 2000.00, -3000.00, '2026-02-26 05:13:04', '2026-02-26 05:13:04');

-- --------------------------------------------------------

--
-- Table structure for table `labour_payments`
--

CREATE TABLE `labour_payments` (
  `id` int(11) NOT NULL,
  `labour_id` int(11) NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `total_days` decimal(5,2) NOT NULL,
  `daily_wage` decimal(10,2) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_status` enum('pending','paid') DEFAULT 'pending',
  `paid_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `transaction_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `labour_payment_methods`
--

CREATE TABLE `labour_payment_methods` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(64) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `labour_payment_transactions`
--

CREATE TABLE `labour_payment_transactions` (
  `id` int(11) UNSIGNED NOT NULL,
  `labour_id` int(11) UNSIGNED NOT NULL,
  `project_id` int(11) UNSIGNED DEFAULT NULL,
  `reference_txn` int(11) DEFAULT NULL,
  `type` enum('earning','advance','payment','adjustment','reverse') NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `reference` varchar(128) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `recorded_by` int(11) UNSIGNED DEFAULT NULL,
  `recorded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `effective_date` date NOT NULL DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `labour_payment_transactions`
--

INSERT INTO `labour_payment_transactions` (`id`, `labour_id`, `project_id`, `reference_txn`, `type`, `amount`, `payment_method`, `reference`, `notes`, `recorded_by`, `recorded_at`, `effective_date`) VALUES
(1, 3, 1, NULL, 'advance', 1000.00, 'cash', 'ADV-20260226-001', 'Advance', 1, '2026-02-26 05:13:04', '2026-02-26'),
(2, 3, 1, NULL, 'payment', 2000.00, 'bank', 'PAY-20260226-001', 'Salary', 1, '2026-02-26 05:13:04', '2026-02-26');

-- --------------------------------------------------------

--
-- Table structure for table `materials`
--

CREATE TABLE `materials` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `price_per_unit` decimal(10,2) NOT NULL,
  `total_cost` decimal(10,2) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `total_stock` decimal(10,2) DEFAULT 0.00 COMMENT 'Initial total stock for material'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `materials`
--

INSERT INTO `materials` (`id`, `name`, `quantity`, `unit`, `price_per_unit`, `total_cost`, `project_id`, `created_at`, `total_stock`) VALUES
(4, 'Cement', 50.00, 'bags', 350.00, 17500.00, 1, '2026-03-21 17:19:01', 1000.00),
(5, 'Sand', 20.00, 'tons', 800.00, 16000.00, 1, '2026-03-21 17:19:01', 500.00),
(6, 'Steel Rods', 100.00, 'bars', 65.00, 6500.00, 2, '2026-03-21 17:19:01', 200.00),
(7, 'Bricks', 5000.00, 'pcs', 8.00, 40000.00, 3, '2026-03-21 17:19:01', 10000.00),
(8, 'Sand', 2.00, 'Brass', 12000.00, 24000.00, 10, '2026-03-24 18:33:07', 15.00),
(9, 'Stone', 200.00, 'piece', 15.00, 3000.00, 7, '2026-03-24 18:33:50', 63.00),
(10, 'steel', 3.50, 'tons', 15000.00, 52500.00, 7, '2026-03-24 18:40:50', 0.50),
(11, 'PVC Pipes', 40.00, '0', 150.00, 1800.00, 10, '2026-03-24 18:51:18', 12.00),
(12, 'PVC Pipes 2\"', 12.00, 'foot', 0.00, 0.00, NULL, '2026-03-24 19:48:08', 1000.00);

-- --------------------------------------------------------

--
-- Table structure for table `material_allocations`
--

CREATE TABLE `material_allocations` (
  `id` int(11) NOT NULL,
  `material_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `allocated_qty` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `material_allocations`
--

INSERT INTO `material_allocations` (`id`, `material_id`, `project_id`, `allocated_qty`, `created_at`, `updated_at`) VALUES
(1, 11, 10, 12.00, '2026-03-24 18:51:51', '2026-03-24 19:23:56'),
(5, 12, 10, 20.00, '2026-03-24 19:48:20', '2026-03-24 21:08:54');

-- --------------------------------------------------------

--
-- Stand-in structure for view `material_stock_status`
-- (See below for the actual view)
--
CREATE TABLE `material_stock_status` (
`id` int(11)
,`name` varchar(255)
,`total_stock` decimal(10,2)
,`allocated_stock` decimal(32,2)
,`remaining_stock` decimal(33,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `id` int(11) NOT NULL,
  `project_name` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `location` varchar(150) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `budget` decimal(12,2) NOT NULL,
  `status` enum('ongoing','completed') DEFAULT 'ongoing',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`id`, `project_name`, `description`, `location`, `start_date`, `end_date`, `budget`, `status`, `created_at`) VALUES
(1, 'Ghurye\'s Home', 'Renovation and restoring', 'Kudal', '2025-12-12', '2026-05-15', 300000.00, 'ongoing', '2026-02-24 05:15:26'),
(2, 'Redkar\'s Home', 'nckwgfuywefdukyew', 'Kolgaon', '2026-02-20', '2026-04-24', 800000.00, 'ongoing', '2026-02-24 05:37:52'),
(3, 'Naik\'s Home', 'jhfmjhdfrdfszdtghyjuihkv', 'Tendoli', '2026-02-18', '2026-02-28', 200000.00, 'ongoing', '2026-02-24 07:02:03'),
(4, 'Lalit\'s Home', 'sdjbcudfgyucd', 'Sawantwadi', '2026-02-04', '2026-04-17', 800000.00, 'ongoing', '2026-02-24 09:09:04'),
(5, 'Mahesh\'s Home', ' nb kdsvu z xz ', 'Kankavli', '2026-02-19', '2026-03-04', 200000.00, 'ongoing', '2026-02-24 10:14:43'),
(6, 'Mahesh\'s Sawant Home', 'Building the new home', 'Kankavli', '2025-11-07', '2026-02-28', 1200000.00, 'ongoing', '2026-02-24 15:45:46'),
(7, 'Mahesh\'s Home', 'renovation', 'Kankavli', '2025-12-18', '2026-05-14', 800000.00, 'ongoing', '2026-02-24 16:00:37'),
(8, 'Kedar\'s Home', 'njhbgfdsvb', 'Malvan', '2026-02-02', '2026-02-28', 100000.00, 'ongoing', '2026-02-24 16:09:39'),
(9, '', 'nhgfghjkl', 'Tulsuli', '0000-00-00', '0000-00-00', 50000.00, 'completed', '2026-02-24 16:15:19'),
(10, 'Bodekar HOme', 'zsvbxnv', 'Narur', '2026-02-05', '2026-04-24', 500000.00, 'ongoing', '2026-02-26 06:36:49');

-- --------------------------------------------------------

--
-- Table structure for table `project_labours`
--

CREATE TABLE `project_labours` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `labour_id` int(11) NOT NULL,
  `assigned_date` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `project_payments`
--

CREATE TABLE `project_payments` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `payment_date` date NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `type` enum('income','expense') NOT NULL,
  `category` varchar(100) NOT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `transaction_date` date DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `transaction_code` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `type`, `category`, `reference_id`, `amount`, `transaction_date`, `payment_method`, `description`, `project_id`, `created_at`, `transaction_code`) VALUES
(5, 'income', 'Extra Work', NULL, 50000.00, NULL, 'UPI', 'savxhagcjys', NULL, '2026-02-24 15:33:52', NULL),
(6, 'expense', 'Material', NULL, 15000.00, NULL, 'Cash', 'Grapphite Stones 1 Load', 5, '2026-02-24 15:44:09', NULL),
(7, 'expense', 'Labour', NULL, 54566.00, NULL, 'Cash', 'nbhvgcfd', 4, '2026-02-24 16:16:07', NULL),
(8, 'income', 'Other', NULL, 20000.00, NULL, 'Cheque', 'dfcgvhbjnk', NULL, '2026-02-24 16:18:15', NULL),
(9, 'expense', 'Equipment', NULL, 6000.00, NULL, 'Cash', 'machines', 8, '2026-02-24 17:06:32', NULL),
(10, 'expense', 'Transport', NULL, 5000.00, NULL, 'UPI', 'terrace', 9, '2026-02-24 17:16:57', NULL),
(11, 'expense', 'Material', NULL, 18674.00, NULL, 'Cash', 'Cement bags 29', 9, '2026-02-24 17:17:40', NULL),
(12, 'expense', 'Labour', NULL, 6000.00, NULL, 'Cash', 'Labour salary', 9, '2026-02-24 17:18:54', NULL),
(13, 'expense', 'Equipment', NULL, 50000.00, NULL, 'UPI', 'Breaker', 10, '2026-02-26 06:39:50', NULL),
(14, 'expense', 'Equipment', NULL, 5557.00, NULL, 'Bank Transfer', 'gytrfjkl;lk', 10, '2026-02-27 05:31:52', NULL),
(15, 'expense', 'Labour', NULL, 2500.00, NULL, 'Cash', 'Labour Payment', 10, '2026-02-27 07:01:49', NULL),
(16, 'income', 'Client Payment', NULL, 150000.00, NULL, 'Cash', 'Partial Payment', 10, '2026-02-27 07:02:42', NULL),
(17, 'income', 'Extra Work', NULL, 10000.00, NULL, 'Cheque', 'Footpath Repairing', NULL, '2026-02-27 07:03:57', NULL),
(18, 'expense', 'Miscellaneous', NULL, 1289.00, NULL, 'Cash', 'Petrol,Hardware', 10, '2026-02-27 07:04:52', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`) VALUES
(1, 'sachin', '12345', 'admin'),
(2, 'manager', '54321', 'user'),
(3, 'Tester', '54321', 'user'),
(4, 'Tester', '54321', 'user');

-- --------------------------------------------------------

--
-- Structure for view `material_stock_status`
--
DROP TABLE IF EXISTS `material_stock_status`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `material_stock_status`  AS SELECT `m`.`id` AS `id`, `m`.`name` AS `name`, `m`.`total_stock` AS `total_stock`, coalesce(sum(`ma`.`allocated_qty`),0) AS `allocated_stock`, `m`.`total_stock`- coalesce(sum(`ma`.`allocated_qty`),0) AS `remaining_stock` FROM (`materials` `m` left join `material_allocations` `ma` on(`m`.`id` = `ma`.`material_id`)) GROUP BY `m`.`id` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `labour_id` (`labour_id`);

--
-- Indexes for table `labour`
--
ALTER TABLE `labour`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `labour_account_balances`
--
ALTER TABLE `labour_account_balances`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `labour_id` (`labour_id`),
  ADD KEY `labour_id_2` (`labour_id`);

--
-- Indexes for table `labour_payments`
--
ALTER TABLE `labour_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transaction_id` (`transaction_id`);

--
-- Indexes for table `labour_payment_methods`
--
ALTER TABLE `labour_payment_methods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `labour_payment_transactions`
--
ALTER TABLE `labour_payment_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `labour_id` (`labour_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `reference_txn` (`reference_txn`),
  ADD KEY `recorded_at` (`recorded_at`);

--
-- Indexes for table `materials`
--
ALTER TABLE `materials`
  ADD PRIMARY KEY (`id`),
  ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `material_allocations`
--
ALTER TABLE `material_allocations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_allocation` (`material_id`,`project_id`),
  ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `project_labours`
--
ALTER TABLE `project_labours`
  ADD PRIMARY KEY (`id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `labour_id` (`labour_id`);

--
-- Indexes for table `project_payments`
--
ALTER TABLE `project_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=125;

--
-- AUTO_INCREMENT for table `labour`
--
ALTER TABLE `labour`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `labour_account_balances`
--
ALTER TABLE `labour_account_balances`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `labour_payments`
--
ALTER TABLE `labour_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `labour_payment_methods`
--
ALTER TABLE `labour_payment_methods`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `labour_payment_transactions`
--
ALTER TABLE `labour_payment_transactions`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `materials`
--
ALTER TABLE `materials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `material_allocations`
--
ALTER TABLE `material_allocations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `project_labours`
--
ALTER TABLE `project_labours`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `project_payments`
--
ALTER TABLE `project_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`labour_id`) REFERENCES `labour` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `labour_payments`
--
ALTER TABLE `labour_payments`
  ADD CONSTRAINT `fk_labour_payments_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `labour_payment_transactions`
--
ALTER TABLE `labour_payment_transactions`
  ADD CONSTRAINT `fk_lpt_transaction` FOREIGN KEY (`reference_txn`) REFERENCES `transactions` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `materials`
--
ALTER TABLE `materials`
  ADD CONSTRAINT `materials_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `material_allocations`
--
ALTER TABLE `material_allocations`
  ADD CONSTRAINT `material_allocations_ibfk_1` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `material_allocations_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `project_labours`
--
ALTER TABLE `project_labours`
  ADD CONSTRAINT `project_labours_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `project_labours_ibfk_2` FOREIGN KEY (`labour_id`) REFERENCES `labour` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `project_payments`
--
ALTER TABLE `project_payments`
  ADD CONSTRAINT `project_payments_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
