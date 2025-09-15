-- MedSync CATMS PostgreSQL Database Seed Data
-- This file contains initial seed data for development and testing

BEGIN;

-- Insert addresses for branches
INSERT INTO addresses (line1, line2, city, state, postal_code) VALUES
('123 Medical Center Drive', 'Suite 100', 'Colombo', 'Western Province', '00100'),
('456 Health Plaza', 'Floor 2', 'Kandy', 'Central Province', '20000'),
('789 Wellness Boulevard', NULL, 'Galle', 'Southern Province', '80000'),

-- Insert branches
INSERT INTO branches (name, address_id, phone, email, is_active) VALUES
('MedSync Colombo', 1, '+94112345678', 'colombo@medsync.lk', true),
('MedSync Kandy', 2, '+94812345678', 'kandy@medsync.lk', true),
('MedSync Galle', 3, '+94912345678', 'galle@medsync.lk', true),

-- Insert branch hours (Monday to Friday: 8:00 AM - 6:00 PM, Saturday: 8:00 AM - 2:00 PM)
INSERT INTO branch_hours (branch_id, day_of_week, open_time, close_time) VALUES
-- Colombo Central
(1, 1, '08:00', '18:00'), -- Monday
(1, 2, '08:00', '18:00'), -- Tuesday
(1, 3, '08:00', '18:00'), -- Wednesday
(1, 4, '08:00', '18:00'), -- Thursday
(1, 5, '08:00', '18:00'), -- Friday
(1, 6, '08:00', '14:00'), -- Saturday
-- Kandy
(2, 1, '08:00', '18:00'),
(2, 2, '08:00', '18:00'),
(2, 3, '08:00', '18:00'),
(2, 4, '08:00', '18:00'),
(2, 5, '08:00', '18:00'),
(2, 6, '08:00', '14:00'),
-- Galle
(3, 1, '08:00', '18:00'),
(3, 2, '08:00', '18:00'),
(3, 3, '08:00', '18:00'),
(3, 4, '08:00', '18:00'),
(3, 5, '08:00', '18:00'),
(3, 6, '08:00', '14:00'),


-- Insert users
INSERT INTO users (id, username, password_hash, role) VALUES
('USR001', 'admin', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'admin'), -- password: secret
('USR002', 'dr.silva', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'doctor'),
('USR003', 'dr.perera', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'doctor'),
('USR004', 'dr.fernando', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'doctor'),
('USR005', 'dr.jayawardene', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'doctor'),
('USR006', 'nurse.kumari', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'nurse'),
('USR007', 'nurse.siri', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'nurse'),
('USR008', 'recept.nimal', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'receptionist'),
('USR009', 'recept.sunil', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'receptionist'),
('USR010', 'manager.priya', '$2b$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'manager');

-- Insert specialties
INSERT INTO specialties (name) VALUES
('General Medicine'),
('Cardiology'),
('Dermatology'),
('Pediatrics'),
('Orthopedics'),
('Gynecology'),
('Neurology'),
('Psychiatry'),
('Ophthalmology'),
('ENT (Ear, Nose, Throat)'),
('Endocrinology'),
('Gastroenterology');

-- Insert medical staff
INSERT INTO medical_staff (user_id, first_name, last_name, specialty_id, license_number, phone, email, branch_id, is_active) VALUES
('USR002', 'Ruwan', 'Silva', 1, 'SLMC001234', '+94771234567', 'r.silva@medsync.lk', 1, true),
('USR003', 'Kamala', 'Perera', 2, 'SLMC002345', '+94772345678', 'k.perera@medsync.lk', 1, true),
('USR004', 'Sunil', 'Fernando', 3, 'SLMC003456', '+94773456789', 's.fernando@medsync.lk', 2, true),
('USR005', 'Priyanka', 'Jayawardene', 4, 'SLMC004567', '+94774567890', 'p.jayawardene@medsync.lk', 3, true),
('USR006', 'Kumari', 'Wickramasinghe', NULL, 'SLN001234', '+94775678901', 'k.wickramasinghe@medsync.lk', 1, true),
('USR007', 'Siri', 'Bandara', NULL, 'SLN002345', '+94776789012', 's.bandara@medsync.lk', 2, true);

-- Insert treatment categories
INSERT INTO treatment_categories (name) VALUES
('Consultation'),
('Diagnostic Tests'),
('Minor Procedures'),
('Vaccinations'),
('Therapy'),
('Emergency Care'),
('Surgical Procedures'),
('Preventive Care');

-- Insert treatments/services
INSERT INTO treatments (service_code, name, description, price, category_id, is_active) VALUES
-- Consultations
('CONS001', 'General Consultation', 'Standard consultation with general practitioner', 2500.00, 1, true),
('CONS002', 'Specialist Consultation', 'Consultation with medical specialist', 4000.00, 1, true),
('CONS003', 'Follow-up Consultation', 'Follow-up visit for existing patients', 2000.00, 1, true),
('CONS004', 'Emergency Consultation', 'Emergency medical consultation', 5000.00, 6, true),

-- Diagnostic Tests
('DIAG001', 'Blood Test - Full Blood Count', 'Complete blood count analysis', 1500.00, 2, true),
('DIAG002', 'Blood Test - Lipid Profile', 'Cholesterol and lipid analysis', 2000.00, 2, true),
('DIAG003', 'Blood Sugar Test', 'Glucose level testing', 800.00, 2, true),
('DIAG004', 'ECG', 'Electrocardiogram', 2500.00, 2, true),
('DIAG005', 'X-Ray Chest', 'Chest X-ray examination', 3000.00, 2, true),
('DIAG006', 'Urine Analysis', 'Complete urine examination', 1000.00, 2, true),

-- Minor Procedures
('PROC001', 'Wound Dressing', 'Cleaning and dressing of wounds', 1500.00, 3, true),
('PROC002', 'Injection - Intramuscular', 'IM injection administration', 500.00, 3, true),
('PROC003', 'Injection - Intravenous', 'IV injection administration', 800.00, 3, true),
('PROC004', 'Suture Removal', 'Removal of surgical sutures', 1000.00, 3, true),
('PROC005', 'Blood Pressure Check', 'BP monitoring and assessment', 300.00, 8, true),

-- Vaccinations
('VACC001', 'COVID-19 Vaccination', 'COVID-19 vaccine administration', 2000.00, 4, true),
('VACC002', 'Flu Vaccination', 'Annual influenza vaccination', 1500.00, 4, true),
('VACC003', 'Hepatitis B Vaccination', 'Hepatitis B vaccine', 2500.00, 4, true),
('VACC004', 'Tetanus Vaccination', 'Tetanus toxoid vaccination', 1200.00, 4, true),

-- Therapy
('THER001', 'Physiotherapy Session', 'Physical therapy treatment', 3000.00, 5, true),
('THER002', 'Counseling Session', 'Psychological counseling', 4000.00, 5, true),

-- Preventive Care
('PREV001', 'Health Screening - Basic', 'Basic health checkup package', 8000.00, 8, true),
('PREV002', 'Health Screening - Comprehensive', 'Comprehensive health screening', 15000.00, 8, true);

-- Insert patient addresses
INSERT INTO addresses (line1, line2, city, state, postal_code) VALUES
('45 Galle Road', 'Apt 3B', 'Colombo', 'Western Province', '00300'),
('12 Kandy Road', NULL, 'Kandy', 'Central Province', '20000'),
('78 Main Street', 'House 78', 'Galle', 'Southern Province', '80000'),
('23 Sea Street', NULL, 'Negombo', 'Western Province', '11500'),
('67 Temple Road', 'Upper Floor', 'Colombo', 'Western Province', '00700'),
('34 Hill Street', NULL, 'Kandy', 'Central Province', '20000'),
('89 Beach Road', 'Villa 89', 'Galle', 'Southern Province', '80000'),
('56 Church Street', NULL, 'Negombo', 'Western Province', '11500');

-- Insert patients
INSERT INTO patients (id, first_name, last_name, date_of_birth, gender, address_id, phone, email, registered_branch, is_active) VALUES
('COL001', 'Amal', 'Perera', '1985-03-15', 'Male', 6, '+94711234567', 'amal.perera@gmail.com', 1, true),
('COL002', 'Nirmala', 'Silva', '1978-07-22', 'Female', 7, '+94722345678', 'nirmala.silva@yahoo.com', 1, true),
('COL003', 'Kasun', 'Fernando', '1990-11-08', 'Male', 8, '+94733456789', 'kasun.fernando@hotmail.com', 1, true),
('KDY001', 'Sanduni', 'Wijesinghe', '1982-05-30', 'Female', 9, '+94744567890', 'sanduni.w@gmail.com', 2, true),
('KDY002', 'Rohan', 'Jayawardene', '1975-12-12', 'Male', 10, '+94755678901', 'rohan.j@yahoo.com', 2, true),
('GAL001', 'Chamika', 'Bandara', '1988-09-03', 'Male', 11, '+94766789012', 'chamika.b@gmail.com', 3, true),
('GAL002', 'Dilani', 'Wickramasinghe', '1992-02-18', 'Female', 12, '+94777890123', 'dilani.w@hotmail.com', 3, true),
('NEG001', 'Nuwan', 'Rathnayake', '1980-06-25', 'Male', 13, '+94788901234', 'nuwan.r@gmail.com', 4, true);

-- Insert patient emergency contacts
INSERT INTO patient_contacts (patient_id, name, phone, relation) VALUES
('COL001', 'Malini Perera', '+94711234568', 'Wife'),
('COL001', 'Sunil Perera', '+94711234569', 'Father'),
('COL002', 'Ravi Silva', '+94722345679', 'Husband'),
('COL003', 'Kumari Fernando', '+94733456780', 'Mother'),
('KDY001', 'Ajith Wijesinghe', '+94744567891', 'Husband'),
('KDY002', 'Kamani Jayawardene', '+94755678902', 'Wife'),
('GAL001', 'Saman Bandara', '+94766789013', 'Brother'),
('GAL002', 'Chandra Wickramasinghe', '+94777890124', 'Mother'),
('NEG001', 'Priyani Rathnayake', '+94788901235', 'Wife');

-- Insert insurance providers
INSERT INTO insurance_providers (name, contact_info, processing_requirements, is_active) VALUES
('Sri Lanka Insurance Corporation', 
 '{"phone": "+94112345678", "email": "claims@slic.lk", "website": "www.slic.lk"}',
 'Requires pre-authorization for treatments above LKR 10,000', true),
('Ceylinco Life Insurance', 
 '{"phone": "+94112876543", "email": "health@ceylinco.com", "website": "www.ceylinco.com"}',
 'Digital claim submission preferred', true),
('AIA Insurance Lanka', 
 '{"phone": "+94113456789", "email": "support@aia.lk", "website": "www.aia.lk"}',
 'Online portal available for claim tracking', true),
('Union Assurance', 
 '{"phone": "+94114567890", "email": "claims@unionassurance.com", "website": "www.unionassurance.com"}',
 'Physical receipts required for all claims', true);

-- Insert sample patient insurance policies
INSERT INTO patient_insurance (patient_id, provider_id, policy_number, coverage_details, expiration_date, is_active) VALUES
('COL001', 1, 'SLIC001234567', 
 '{"coverage_limit": 500000, "annual_deductible": 5000, "coverage_percentage": 80}',
 '2025-12-31', true),
('COL002', 2, 'CEY002345678', 
 '{"coverage_limit": 750000, "annual_deductible": 7500, "coverage_percentage": 85}',
 '2025-11-30', true),
('KDY001', 3, 'AIA003456789', 
 '{"coverage_limit": 1000000, "annual_deductible": 10000, "coverage_percentage": 90}',
 '2025-10-15', true),
('GAL001', 1, 'SLIC004567890', 
 '{"coverage_limit": 300000, "annual_deductible": 3000, "coverage_percentage": 75}',
 '2025-08-20', true);

-- Insert sample appointments (mix of past and future)
INSERT INTO appointments (patient_id, doctor_id, branch_id, appointment_datetime, status, type, notes) VALUES
-- Past appointments
('COL001', 1, 1, '2025-09-10 09:00:00', 'Completed', 'Regular', 'Annual checkup'),
('COL002', 2, 1, '2025-09-11 10:30:00', 'Completed', 'Regular', 'Chest pain complaint'),
('KDY001', 3, 2, '2025-09-12 14:00:00', 'Completed', 'Follow-up', 'Skin condition follow-up'),
('GAL001', 4, 3, '2025-09-13 11:00:00', 'No Show', 'Regular', 'Vaccination appointment'),

-- Future appointments
('COL003', 1, 1, '2025-09-16 09:30:00', 'Scheduled', 'Regular', 'General consultation'),
('NEG001', 1, 1, '2025-09-17 15:00:00', 'Confirmed', 'Regular', 'Health screening'),
('KDY002', 3, 2, '2025-09-18 10:00:00', 'Scheduled', 'Follow-up', 'Blood pressure monitoring'),
('GAL002', 4, 3, '2025-09-19 16:00:00', 'Scheduled', 'Regular', 'Pediatric consultation'),

-- Emergency appointment
('COL001', 1, 1, '2025-09-14 18:30:00', 'Completed', 'Emergency', 'Sudden fever and headache');

-- Insert treatment records for completed appointments
INSERT INTO treatment_records (appointment_id, treatment_id, quantity, unit_price, consultation_notes, recorded_by) VALUES
-- Appointment 1 (COL001 annual checkup)
(1, 1, 1, 2500.00, 'General health assessment. Patient in good health.', 1),
(1, 5, 1, 1500.00, 'Blood test shows normal values', 1),
(1, 13, 1, 300.00, 'Blood pressure normal: 120/80', 1),

-- Appointment 2 (COL002 chest pain)
(2, 2, 1, 4000.00, 'Chest pain evaluation. Recommended ECG.', 2),
(2, 8, 1, 2500.00, 'ECG shows normal rhythm', 2),

-- Appointment 3 (KDY001 skin follow-up)
(3, 3, 1, 2000.00, 'Skin condition improving. Continue treatment.', 3),
(3, 15, 1, 1500.00, 'Wound dressing changed', 3),

-- Appointment 9 (COL001 emergency)
(9, 4, 1, 5000.00, 'Emergency consultation for fever. Viral infection suspected.', 1),
(9, 5, 1, 1500.00, 'Blood test to rule out bacterial infection', 1),
(9, 16, 1, 500.00, 'Paracetamol injection administered', 1);

-- Insert invoices
INSERT INTO invoices (patient_id, appointment_id, invoice_number, total_amount, status) VALUES
('COL001', 1, 'INV-2025-001', 4300.00, 'Paid'),
('COL002', 2, 'INV-2025-002', 6500.00, 'Paid'),
('KDY001', 3, 'INV-2025-003', 3500.00, 'Paid'),
('COL001', 9, 'INV-2025-004', 7000.00, 'Sent');

-- Insert payments
INSERT INTO payments (invoice_id, amount, payment_method, payment_date, transaction_reference, processed_by, notes) VALUES
(1, 4300.00, 'Cash', '2025-09-10 09:45:00', 'CASH-001', 'USR008', 'Payment received in full'),
(2, 6500.00, 'Credit Card', '2025-09-11 11:15:00', 'CC-123456789', 'USR008', 'Visa payment processed'),
(3, 3500.00, 'Bank Transfer', '2025-09-13 14:30:00', 'BT-987654321', 'USR009', 'Online bank transfer');

-- Insert sample insurance claims
INSERT INTO insurance_claims (invoice_id, patient_insurance_id, claim_number, claim_amount, approved_amount, status, submission_date, response_date) VALUES
(1, 1, 'CLM-2025-001', 4300.00, 3440.00, 'Paid', '2025-09-10 10:00:00', '2025-09-12 15:30:00'),
(2, 2, 'CLM-2025-002', 6500.00, 5525.00, 'Approved', '2025-09-11 12:00:00', '2025-09-13 10:00:00');

-- Insert sample audit log entries
INSERT INTO audit_log (user_id, action, table_name, record_id, old_values, new_values, timestamp, ip_address) VALUES
('USR002', 'CREATE', 'appointments', '1', NULL, 
 '{"patient_id": "COL001", "doctor_id": 1, "status": "Scheduled"}', 
 '2025-09-09 08:00:00', '192.168.1.100'),
('USR002', 'UPDATE', 'appointments', '1', 
 '{"status": "Scheduled"}', '{"status": "Completed"}', 
 '2025-09-10 09:00:00', '192.168.1.100'),
('USR008', 'CREATE', 'payments', '1', NULL, 
 '{"invoice_id": 1, "amount": 4300.00, "payment_method": "Cash"}', 
 '2025-09-10 09:45:00', '192.168.1.200');

-- Commit the transaction
COMMIT;

-- Display summary of inserted data
SELECT 'Seed data insertion completed successfully!' as message;
SELECT 'Total addresses: ' || COUNT(*) as summary FROM addresses
UNION ALL
SELECT 'Total branches: ' || COUNT(*) FROM branches
UNION ALL
SELECT 'Total users: ' || COUNT(*) FROM users
UNION ALL
SELECT 'Total medical staff: ' || COUNT(*) FROM medical_staff
UNION ALL
SELECT 'Total specialties: ' || COUNT(*) FROM specialties
UNION ALL
SELECT 'Total treatment categories: ' || COUNT(*) FROM treatment_categories
UNION ALL
SELECT 'Total treatments: ' || COUNT(*) FROM treatments
UNION ALL
SELECT 'Total patients: ' || COUNT(*) FROM patients
UNION ALL
SELECT 'Total appointments: ' || COUNT(*) FROM appointments
UNION ALL
SELECT 'Total invoices: ' || COUNT(*) FROM invoices
UNION ALL
SELECT 'Total payments: ' || COUNT(*) FROM payments
UNION ALL
SELECT 'Total insurance providers: ' || COUNT(*) FROM insurance_providers;
