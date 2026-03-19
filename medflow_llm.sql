-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 19, 2026 at 08:18 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `medflow_llm`
--

-- --------------------------------------------------------

--
-- Table structure for table `ai_chat_history`
--

CREATE TABLE `ai_chat_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `role` enum('patient','doctor') DEFAULT NULL,
  `user_message` text DEFAULT NULL,
  `ai_response` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ai_chat_history`
--

INSERT INTO `ai_chat_history` (`id`, `user_id`, `role`, `user_message`, `ai_response`, `created_at`) VALUES
(1, 15, 'patient', 'I have chest pain', 'Based on your symptoms, please consult a doctor if the problem continues.', '2025-12-26 18:00:29'),
(2, 3, 'doctor', 'Patient has fever for 3 days', 'Possible diagnosis: Viral fever. Suggest CBC and hydration.', '2025-12-26 18:01:45'),
(3, 3, 'doctor', 'Patient has fever for 3 days', 'Possible diagnosis: Viral fever. Suggest CBC and hydration.', '2025-12-26 18:04:20');

-- --------------------------------------------------------

--
-- Table structure for table `allergies`
--

CREATE TABLE `allergies` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `allergy_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `allergies`
--

INSERT INTO `allergies` (`id`, `patient_id`, `allergy_name`) VALUES
(1, 1, 'Peanuts');

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` varchar(255) NOT NULL,
  `doctor_id` varchar(255) DEFAULT NULL,
  `patient_id` varchar(255) DEFAULT NULL,
  `patient_name` varchar(255) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `time` varchar(50) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `avatar_initial` varchar(10) DEFAULT NULL,
  `avatar_bg` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`id`, `doctor_id`, `patient_id`, `patient_name`, `date`, `time`, `type`, `status`, `avatar_initial`, `avatar_bg`) VALUES
('appt-1', 'doctor-456', 'patient-1', 'Sarah Johnson', '2026-01-08', '09:00 AM', 'Video Consultation', 'Confirmed', 'S', 'bg-slate-700'),
('appt-2', 'doctor-456', 'patient-2', 'Michael Chen', '2026-01-08', '10:30 AM', 'In-person Consultation', 'Pending', 'M', 'bg-slate-700'),
('appt-3', 'doctor-456', 'patient-3', 'Emma Wilson', '2026-01-08', '11:15 AM', 'Chat Consultation', 'Confirmed', 'E', 'bg-slate-700');

-- --------------------------------------------------------

--
-- Table structure for table `app_settings`
--

CREATE TABLE `app_settings` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` varchar(255) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `app_settings`
--

INSERT INTO `app_settings` (`id`, `patient_id`, `setting_key`, `setting_value`, `updated_at`) VALUES
(1, 15, 'notifications', 'on', '2025-12-26 20:04:02'),
(2, 15, 'dark_mode', 'off', '2025-12-26 20:04:02'),
(3, 15, 'language', 'en', '2025-12-26 20:04:02');

-- --------------------------------------------------------

--
-- Table structure for table `consultation_notes`
--

CREATE TABLE `consultation_notes` (
  `id` int(11) NOT NULL,
  `appointment_id` int(11) DEFAULT NULL,
  `doctor_notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `consultation_notes`
--

INSERT INTO `consultation_notes` (`id`, `appointment_id`, `doctor_notes`, `created_at`) VALUES
(1, 15, 'Patient reports mild headache. Advised rest and hydration.', '2025-12-26 09:36:50');

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `id` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `specialty` varchar(100) DEFAULT NULL,
  `license_number` varchar(100) DEFAULT NULL,
  `role` varchar(50) DEFAULT 'doctor',
  `is_verified` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`id`, `full_name`, `email`, `password`, `phone`, `specialty`, `license_number`, `role`, `is_verified`, `created_at`) VALUES
('06eca80c-98f9-4db2-9ac1-0473bffcad19', 'Suresh', 'kundavishnuvardhan@gmail.com', '123', '123456789', NULL, NULL, 'doctor', 1, '2026-01-20 17:27:11'),
('12ff540f-a020-4d3b-ad60-eed7ed79c973', 'Dr. Dynamic', 'dr_dynamic_8578@medflow.com', 'password', '9422520073', NULL, NULL, 'doctor', 0, '2026-01-20 17:24:01'),
('301cedf0-0cec-44ea-a62b-fe6f2eec8bcf', 'DOCTOR', 'doc1@gmail.com', '123', '123', 'Cardio', '123', 'doctor', 1, '2026-01-20 18:13:13'),
('33959a29-8a6e-4dfe-9cef-ef720d9a709f', 'Ram', 'ram12@gmail.com', '123', '123', 'Cardiologist', '123456', 'doctor', 1, '2026-01-20 17:39:21'),
('3cf486fa-0adb-4906-93d0-cc969c103246', 'Dr. Test', 'doc_4937@test.com', 'password123', '+15550002', NULL, NULL, 'doctor', 0, '2026-01-21 13:11:40'),
('5f675734-e16c-400c-af45-c42078c04a01', 'Sai', 'hugginasaicharan@gmail.com', 'sai22', '6305583131', 'General', 'DOC-001', 'doctor', 1, '2026-01-21 13:26:12'),
('625c55f6-c46a-47c8-a87c-4f848bdab6f9', 'Heart', 'heart@gmail.com', '11', '11', 'Cardiologist', '123456', 'doctor', 1, '2026-01-20 19:10:48'),
('6fadb99a-e9f3-4a34-b3b2-e7743a79048c', 'Marie', 'marie890@gmail.com', 'marie', '6305583131', 'Cardiologist', 'QNp456#', 'doctor', 1, '2026-01-21 13:20:15'),
('8c2208bd-f6c1-4f99-bad0-582fce89bfd0', 'Dr. Smith', 'doctor@example.com', 'password', '0987654321', 'Cardiology', 'DOC-TEST', 'doctor', 1, '2026-01-21 13:26:12'),
('8ef28b0c-d763-4d0d-8608-bd50c9c76bf4', 'Dr Debug', 'dr.debug.2199@test.com', 'password123', '555-0000', NULL, NULL, 'doctor', 0, '2026-01-20 17:30:15'),
('c8b02cef-4ff1-4115-a962-554ecfd5e234', 'Vardhan ', 'vardhan@gmail.com', '11', '11', 'Neurologist ', '123', 'doctor', 1, '2026-01-20 19:34:50'),
('dbc71d59-3f6d-44eb-b864-dbab9276560b', 'Ash', 'ash@gmail.com', '11', '11', 'Cardio', '122', 'doctor', 1, '2026-01-20 19:38:14'),
('e51a5a2b-c871-4398-8382-69d85cef70ac', 'Dr. Dynamic', 'dr_dynamic_1301@medflow.com', 'password', '5502722044', NULL, NULL, 'doctor', 0, '2026-01-20 17:23:21'),
('fa94562f-040d-475d-874f-cfff087e22d6', 'Kunda', 'kunda@123', '11', '122', 'Neuro', '11', 'doctor', 1, '2026-01-20 19:44:15');

-- --------------------------------------------------------

--
-- Table structure for table `doctor_availability`
--

CREATE TABLE `doctor_availability` (
  `id` int(11) NOT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `available_day` varchar(20) DEFAULT NULL,
  `time_from` varchar(20) DEFAULT NULL,
  `time_to` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor_availability`
--

INSERT INTO `doctor_availability` (`id`, `doctor_id`, `available_day`, `time_from`, `time_to`) VALUES
(1, 10, 'Monday', '10:00', '14:00'),
(2, 10, 'Monday', '10:00', '13:00');

-- --------------------------------------------------------

--
-- Table structure for table `doctor_profiles`
--

CREATE TABLE `doctor_profiles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `specialization` varchar(100) DEFAULT NULL,
  `experience` int(11) DEFAULT NULL,
  `license_no` varchar(100) DEFAULT NULL,
  `verification_status` tinyint(1) DEFAULT 0,
  `verification_document` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor_profiles`
--

INSERT INTO `doctor_profiles` (`id`, `user_id`, `name`, `specialization`, `experience`, `license_no`, `verification_status`, `verification_document`) VALUES
(5, 8, 'Dr Test', 'Neurology', 5, 'LIC2002', 1, NULL),
(7, 4, 'Dr John Doe', 'Internal Medicine', 6, 'LIC2001', 0, 'uploads/verification/doctor2_license.pdf'),
(11, 10, 'Dr. Ramesh Kumar', 'Cardiology', 9, 'LIC-999999', 1, 'uploads/verification/dr10_license.pdf');

-- --------------------------------------------------------

--
-- Table structure for table `emergency_contacts`
--

CREATE TABLE `emergency_contacts` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `relation` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `emergency_contacts`
--

INSERT INTO `emergency_contacts` (`id`, `patient_id`, `name`, `phone`, `relation`) VALUES
(1, 15, 'Ramesh Kumar', '9876543210', 'Father');

-- --------------------------------------------------------

--
-- Table structure for table `e_prescriptions`
--

CREATE TABLE `e_prescriptions` (
  `id` int(11) NOT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `prescription_text` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `e_prescriptions`
--

INSERT INTO `e_prescriptions` (`id`, `doctor_id`, `patient_id`, `prescription_text`, `created_at`) VALUES
(1, 3, 15, 'Paracetamol 500mg twice daily for 3 days. Drink plenty of fluids.', '2025-12-26 17:11:29'),
(2, 3, 15, 'FOLLOW-UP SCHEDULED\nDate: 2025-01-08\nNotes: Check BP and sugar levels\n', '2025-12-26 17:22:12');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `comments` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `patient_id`, `rating`, `comments`, `created_at`) VALUES
(1, 15, 5, 'Great app experience', '2025-12-26 20:30:29');

-- --------------------------------------------------------

--
-- Table structure for table `handwritten_docs`
--

CREATE TABLE `handwritten_docs` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `image_path` text DEFAULT NULL,
  `extracted_text` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `handwritten_docs`
--

INSERT INTO `handwritten_docs` (`id`, `patient_id`, `image_path`, `extracted_text`, `created_at`) VALUES
(1, 5, 'C:\\xampp\\htdocs\\medflow_api\\handwritten_document/uploads/handwritten/1766482514_clean.webp', 'Sample extracted text from handwritten document.', '2025-12-23 09:35:14');

-- --------------------------------------------------------

--
-- Table structure for table `health_records`
--

CREATE TABLE `health_records` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `record_type` varchar(50) DEFAULT NULL,
  `file_path` text DEFAULT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `health_records`
--

INSERT INTO `health_records` (`id`, `patient_id`, `record_type`, `file_path`, `uploaded_at`) VALUES
(1, 15, 'Lab Report', 'uploads/lab_report_15.pdf', '2025-12-26 18:14:40');

-- --------------------------------------------------------

--
-- Table structure for table `insurance_details`
--

CREATE TABLE `insurance_details` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `provider_name` varchar(100) DEFAULT NULL,
  `policy_number` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `insurance_details`
--

INSERT INTO `insurance_details` (`id`, `patient_id`, `provider_name`, `policy_number`) VALUES
(1, 1, 'Star Health', 'POL123456');

-- --------------------------------------------------------

--
-- Table structure for table `medical_history`
--

CREATE TABLE `medical_history` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `disease_name` varchar(100) DEFAULT NULL,
  `since_year` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `medical_history`
--

INSERT INTO `medical_history` (`id`, `patient_id`, `disease_name`, `since_year`) VALUES
(1, 1, 'Diabetes', '2018');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `sender_id` varchar(255) DEFAULT NULL,
  `receiver_id` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `timestamp` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `type` enum('appointment','prescription','system','alert') DEFAULT 'system',
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `type`, `is_read`, `created_at`) VALUES
(1, 7, 'Test Notification', 'This is a test notification.', 'system', 0, '2025-12-22 19:43:47');

-- --------------------------------------------------------

--
-- Table structure for table `otp_codes`
--

CREATE TABLE `otp_codes` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `otp_code` varchar(6) NOT NULL,
  `expires_at` datetime NOT NULL,
  `is_used` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `otp_verification`
--

CREATE TABLE `otp_verification` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `otp_code` varchar(10) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `otp_verification`
--

INSERT INTO `otp_verification` (`id`, `user_id`, `otp_code`, `is_verified`, `created_at`) VALUES
(1, 1, '626075', 1, '2025-12-18 04:56:48'),
(2, 9960, '829652', 0, '2026-02-19 07:55:45');

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `id` varchar(255) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT 0,
  `role` varchar(50) DEFAULT 'patient',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`id`, `full_name`, `email`, `password`, `phone`, `is_verified`, `role`, `created_at`) VALUES
('10f7082a-c33f-4a3f-a83c-b23e25713200', 'Sam', 'vishnu1@gmail.com', '123', '123', 1, 'patient', '2026-01-20 17:28:36'),
('42c81e5d-c54e-4124-97a1-8288e3259b1b', 'Vish', 'vish1@gmail.com', '123', '123', 1, 'patient', '2026-01-20 18:08:16'),
('4a0dc52d-0d10-47f3-b628-a29f3af68607', 'Test Patient', 'pat_8688@test.com', 'password123', '+15550001', 0, 'patient', '2026-01-21 13:11:37'),
('6f890497-c324-463d-b59c-1273c6f23cc3', 'John', 'chilakaabhigna01@gmail.com', 'sai22', '7416551722', 1, 'patient', '2026-01-21 13:11:04'),
('874f1a35-c83a-40c7-a431-92b3513823b6', 'Ram', 'ram123@gmail.com', '123', '1234', 1, 'patient', '2026-01-20 17:40:06'),
('945983c5-ac1f-401d-9e69-63f41daacedf', 'John', 'chilakaabhigna62@gmail.com', 'sai22', '7416551722', 1, 'patient', '2026-01-21 13:12:38'),
('d576547e-8a07-47e5-abaf-98f819c1f685', 'Test Patient', 'pat_5185@test.com', 'password123', '+15550001', 0, 'patient', '2026-01-20 17:16:24'),
('eca5735b-43e1-482e-821c-33dd3d0779b7', 'Bablu', 'chilakabablu989@gmail.com', 'abhii', '9866948457', 1, 'patient', '2026-01-21 13:18:13');

-- --------------------------------------------------------

--
-- Table structure for table `patient_consents`
--

CREATE TABLE `patient_consents` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `consent_type` varchar(100) NOT NULL,
  `consent_status` tinyint(1) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patient_consents`
--

INSERT INTO `patient_consents` (`id`, `patient_id`, `consent_type`, `consent_status`, `created_at`) VALUES
(1, 15, 'data_sharing', 1, '2025-12-26 20:08:30');

-- --------------------------------------------------------

--
-- Table structure for table `patient_profiles`
--

CREATE TABLE `patient_profiles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `blood_group` varchar(10) DEFAULT NULL,
  `height` varchar(10) DEFAULT NULL,
  `weight` varchar(10) DEFAULT NULL,
  `address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patient_profiles`
--

INSERT INTO `patient_profiles` (`id`, `user_id`, `dob`, `gender`, `blood_group`, `height`, `weight`, `address`) VALUES
(1, 1, '2000-01-01', 'female', 'A+', '165', '58', 'Bangalore, India');

-- --------------------------------------------------------

--
-- Table structure for table `patient_records`
--

CREATE TABLE `patient_records` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `avatar_initial` varchar(10) DEFAULT NULL,
  `avatar_color` varchar(50) DEFAULT NULL,
  `medical_history` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`medical_history`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patient_records`
--

INSERT INTO `patient_records` (`id`, `name`, `age`, `gender`, `avatar_initial`, `avatar_color`, `medical_history`) VALUES
('P-001', 'Sarah Johnson', 34, 'Female', 'S', 'text-cyan-400', NULL),
('P-002', 'Michael Chen', 45, 'Male', 'M', 'text-cyan-400', NULL),
('P-003', 'Emma Wilson', 28, 'Female', 'E', 'text-cyan-400', NULL),
('P-004', 'Robert Fox', 62, 'Male', 'R', 'text-cyan-400', NULL),
('P-005', 'Lisa Anderson', 51, 'Female', 'L', 'text-cyan-400', NULL),
('P-006', 'James Wilson', 39, 'Male', 'J', 'text-cyan-400', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `prescriptions`
--

CREATE TABLE `prescriptions` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `image_path` text DEFAULT NULL,
  `extracted_text` text DEFAULT NULL,
  `summary` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `prescriptions`
--

INSERT INTO `prescriptions` (`id`, `patient_id`, `image_path`, `extracted_text`, `summary`, `created_at`) VALUES
(2, 1, 'uploads/1766474826_prescription-template_x.png', 'Paracetamol 500mg twice daily for 5 days', 'Patient prescribed Paracetamol for fever and pain.', '2025-12-23 07:27:06');

-- --------------------------------------------------------

--
-- Table structure for table `privacy_policy`
--

CREATE TABLE `privacy_policy` (
  `id` int(11) NOT NULL,
  `content` text NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `privacy_policy`
--

INSERT INTO `privacy_policy` (`id`, `content`, `updated_at`) VALUES
(1, 'This is the privacy policy of MedFlow. We respect user data, ensure confidentiality, and comply with healthcare data regulations.', '2025-12-26 20:15:59');

-- --------------------------------------------------------

--
-- Table structure for table `scan_reports`
--

CREATE TABLE `scan_reports` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `report_type` varchar(50) DEFAULT NULL,
  `image_path` text DEFAULT NULL,
  `ai_interpretation` text DEFAULT NULL,
  `abnormal_findings` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `scan_reports`
--

INSERT INTO `scan_reports` (`id`, `patient_id`, `report_type`, `image_path`, `ai_interpretation`, `abnormal_findings`, `created_at`) VALUES
(1, 5, 'CT Scan', 'C:\\xampp\\htdocs\\medflow_api\\scan_lab_report_interpretation/uploads/scans/1766479824_scan_report.webp', 'No major abnormalities detected in the scan', 'None', '2025-12-23 08:50:24');

-- --------------------------------------------------------

--
-- Table structure for table `shared_records`
--

CREATE TABLE `shared_records` (
  `id` int(11) NOT NULL,
  `record_id` int(11) DEFAULT NULL,
  `doctor_id` int(11) DEFAULT NULL,
  `shared_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shared_records`
--

INSERT INTO `shared_records` (`id`, `record_id`, `doctor_id`, `shared_at`) VALUES
(5, 1, 3, '2025-12-26 19:01:20');

-- --------------------------------------------------------

--
-- Table structure for table `support_tickets`
--

CREATE TABLE `support_tickets` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `status` varchar(20) DEFAULT 'open',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `support_tickets`
--

INSERT INTO `support_tickets` (`id`, `patient_id`, `subject`, `message`, `status`, `created_at`) VALUES
(1, 15, 'Login issue', 'Unable to login after password reset', 'open', '2025-12-26 20:23:25');

-- --------------------------------------------------------

--
-- Table structure for table `symptoms`
--

CREATE TABLE `symptoms` (
  `id` int(11) NOT NULL,
  `patient_id` int(11) DEFAULT NULL,
  `symptom_text` text DEFAULT NULL,
  `severity` varchar(20) DEFAULT NULL,
  `ai_result` text DEFAULT NULL,
  `risk_level` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `symptoms`
--

INSERT INTO `symptoms` (`id`, `patient_id`, `symptom_text`, `severity`, `ai_result`, `risk_level`, `created_at`) VALUES
(5, 15, 'Fever and headache for 2 days', 'moderate', 'Possible viral infection. Stay hydrated.', 'medium', '2025-12-23 03:49:20');

-- --------------------------------------------------------

--
-- Table structure for table `symptom_logs`
--

CREATE TABLE `symptom_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `symptoms` text NOT NULL,
  `body_part` varchar(100) DEFAULT NULL,
  `ai_result` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `role` enum('patient','doctor') DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `language` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `role`, `full_name`, `email`, `phone`, `password`, `language`, `created_at`) VALUES
(1, 'patient', 'Rahul Kumar', 'rahul@example.com', '9876543210', '$2y$10$Ds0f4uKrqQQcfUUShPiRJeFKt5HRIheETWRjOcJaXixMCsKXlBx9G', NULL, '2025-12-18 04:25:33'),
(6, 'patient', 'priyanka', 'priya@example.com', '8645043210', '$2y$10$U3Eq96U7wlacUhhQK4KTRuZbS3.WMsdjFvgwgmVka64nx/KvCf08e', NULL, '2025-12-18 04:28:39'),
(7, 'doctor', 'Dr John Doe', 'doctor@medflow.com', '9999999999', 'test123', NULL, '2025-12-22 18:28:36'),
(8, 'doctor', 'Dr Test', 'drtest@medflow.com', '9999999999', '1234', NULL, '2025-12-22 18:55:29'),
(9, 'doctor', 'Sai', 'hugginasaicharan@gmail.com', NULL, 'sai', NULL, '2026-01-08 02:08:39'),
(10, 'patient', 'Sai', 'cherrypersonal77@gmail.com', NULL, 'sai', NULL, '2026-01-08 02:09:33'),
(11, 'patient', 'Abhigna ', 'abhignachilaka25@gmail.com', NULL, 'Abhigna#2005', NULL, '2026-01-08 03:56:31'),
(12, 'patient', 'Rajeswari', 'rajimandala99@gmail.com', NULL, 'Raji@12345', NULL, '2026-01-08 09:22:12'),
(13, 'doctor', 'Dr. Smith', 'doctor@example.com', NULL, 'password', NULL, '2026-01-09 18:19:38'),
(14, 'patient', 'Test Patient', 'patient@example.com', NULL, 'password', NULL, '2026-01-09 18:19:38'),
(15, 'patient', 'Test User', 'test_7d37a20a-d3ef-4a62-9ca9-ba58b651f64f@example.com', NULL, 'pass123', NULL, '2026-01-10 04:20:56'),
(474, 'patient', 'Test User', 'test_bdabff72-d5a4-46b9-b40a-ef991ac246ea@example.com', NULL, 'pass123', NULL, '2026-01-10 04:32:31'),
(6738, 'patient', 'Vishnu. K', 'animafuture1gaming@gmail.com', NULL, '123', NULL, '2026-01-20 17:07:32'),
(7530, 'patient', 'John', 'alukapardhu909@gmail.com', NULL, 'sai22', NULL, '2026-01-10 04:28:37'),
(7531, 'patient', 'Hfbu', 'charan@gmail.com', NULL, 'sai', NULL, '2026-01-10 04:39:48'),
(9955, 'patient', 'John', 'gsgsh@gmail.com', NULL, 'sai', NULL, '2026-01-10 05:27:33'),
(9956, 'patient', 'Abhigna Chilaka', 'abhign@example.com', '9876943210', '$2y$10$XeUHaYWSVjXhFAvmDhtE1OIAHWvli2HseMlplTVdNjpSS1IyvnbGu', NULL, '2026-02-18 19:22:02'),
(9957, 'patient', 'Ruthish Peddagani', 'peddaganiruthish@gmail.com', '8897710595', '$2y$10$f1rZC5R7jwqHAC0N0u73D.be0qth3i0zsv2tUvm.wfVJ5OmWj2G.K', NULL, '2026-02-18 19:47:39'),
(9958, 'patient', 'Ruthish', 'homiqqoffice@gmail.com', '8897710596', '$2y$10$fXbc/J6rvwJ/dIeYIOhlPOWyHeuET5bhcB0LRM00u0uWGA7a0Utue', NULL, '2026-02-19 01:32:08'),
(9959, 'patient', 'Abhigna Chilaka', 'abhignachilaka5@gmail.com', '+918019338457', '$2y$10$we1U2Y36n9PMXhrLRqN4wO4PIc6IK2I0g4HGCm2m90ySPgJR4VoU6', NULL, '2026-02-19 07:54:07'),
(9960, 'patient', 'Abhigna Chilaka', 'arul072004@gmail.com', '9944179932', '$2y$10$kVDFzmnXdx5836HXPvmSleCib4gHC.A/hLCn5JSIAEayrKROH81ru', NULL, '2026-02-19 07:54:40'),
(9961, 'doctor', 'mounisha', 'mounishachowdary74@gmail.com', '+917845770124', '$2y$10$5kYCeoOJP1elHFJIe5J5e.t1J9nkv.OaVzH.wR2DE4naZFkM9HZeW', NULL, '2026-02-19 08:15:17'),
(9962, 'patient', 'Abhigna Chilaka', 'manikandanarumugam9788@gnail.com', '6382607244', '$2y$10$Z1750LhZmcAItAJeYfzJWOY.oDTPq586N5FaD/xwAcdJUytQ/nLia', NULL, '2026-02-19 08:23:34');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ai_chat_history`
--
ALTER TABLE `ai_chat_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `allergies`
--
ALTER TABLE `allergies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `app_settings`
--
ALTER TABLE `app_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_setting` (`patient_id`,`setting_key`);

--
-- Indexes for table `consultation_notes`
--
ALTER TABLE `consultation_notes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `doctor_availability`
--
ALTER TABLE `doctor_availability`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `doctor_profiles`
--
ALTER TABLE `doctor_profiles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `emergency_contacts`
--
ALTER TABLE `emergency_contacts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `e_prescriptions`
--
ALTER TABLE `e_prescriptions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `handwritten_docs`
--
ALTER TABLE `handwritten_docs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `health_records`
--
ALTER TABLE `health_records`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `insurance_details`
--
ALTER TABLE `insurance_details`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `medical_history`
--
ALTER TABLE `medical_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `otp_codes`
--
ALTER TABLE `otp_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `otp_verification`
--
ALTER TABLE `otp_verification`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `patient_consents`
--
ALTER TABLE `patient_consents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_consent` (`patient_id`,`consent_type`);

--
-- Indexes for table `patient_profiles`
--
ALTER TABLE `patient_profiles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `patient_records`
--
ALTER TABLE `patient_records`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `prescriptions`
--
ALTER TABLE `prescriptions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `privacy_policy`
--
ALTER TABLE `privacy_policy`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `scan_reports`
--
ALTER TABLE `scan_reports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shared_records`
--
ALTER TABLE `shared_records`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `symptoms`
--
ALTER TABLE `symptoms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `symptom_logs`
--
ALTER TABLE `symptom_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ai_chat_history`
--
ALTER TABLE `ai_chat_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `allergies`
--
ALTER TABLE `allergies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `app_settings`
--
ALTER TABLE `app_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `consultation_notes`
--
ALTER TABLE `consultation_notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `doctor_availability`
--
ALTER TABLE `doctor_availability`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `doctor_profiles`
--
ALTER TABLE `doctor_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `emergency_contacts`
--
ALTER TABLE `emergency_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `e_prescriptions`
--
ALTER TABLE `e_prescriptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `handwritten_docs`
--
ALTER TABLE `handwritten_docs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `health_records`
--
ALTER TABLE `health_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `insurance_details`
--
ALTER TABLE `insurance_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `medical_history`
--
ALTER TABLE `medical_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `otp_codes`
--
ALTER TABLE `otp_codes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `otp_verification`
--
ALTER TABLE `otp_verification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `patient_consents`
--
ALTER TABLE `patient_consents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `patient_profiles`
--
ALTER TABLE `patient_profiles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `prescriptions`
--
ALTER TABLE `prescriptions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `privacy_policy`
--
ALTER TABLE `privacy_policy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `scan_reports`
--
ALTER TABLE `scan_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `shared_records`
--
ALTER TABLE `shared_records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `support_tickets`
--
ALTER TABLE `support_tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `symptoms`
--
ALTER TABLE `symptoms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `symptom_logs`
--
ALTER TABLE `symptom_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9963;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `otp_codes`
--
ALTER TABLE `otp_codes`
  ADD CONSTRAINT `otp_codes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `symptom_logs`
--
ALTER TABLE `symptom_logs`
  ADD CONSTRAINT `symptom_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
