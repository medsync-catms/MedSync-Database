-- MedSync CATMS PostgreSQL Database Indexes
-- This file contains performance-optimized indexes for the MedSync database

BEGIN;

-- =============================================================================
-- PATIENT-RELATED INDEXES
-- =============================================================================

-- Index for patient searches by name (very common operation)
CREATE INDEX idx_patients_name ON patients (last_name, first_name);

-- Index for patient searches by phone number
CREATE INDEX idx_patients_phone ON patients (phone);

-- Index for patient searches by email
CREATE INDEX idx_patients_email ON patients (email);

-- Index for patients by registered branch (for branch-specific queries)
CREATE INDEX idx_patients_branch ON patients (registered_branch);

-- Index for active patients
CREATE INDEX idx_patients_active ON patients (is_active) WHERE is_active = true;

-- Index for patient date of birth (for age-based queries)
CREATE INDEX idx_patients_dob ON patients (date_of_birth);

-- Index for patient gender statistics
CREATE INDEX idx_patients_gender ON patients (gender);

-- Composite index for patient searches by branch and status
CREATE INDEX idx_patients_branch_active ON patients (registered_branch, is_active);

-- Index for patient emergency contacts by patient
CREATE INDEX idx_patient_contacts_patient ON patient_contacts (patient_id);

-- =============================================================================
-- APPOINTMENT-RELATED INDEXES
-- =============================================================================

-- Index for appointments by patient (most common lookup)
CREATE INDEX idx_appointments_patient ON appointments (patient_id);

-- Index for appointments by doctor
CREATE INDEX idx_appointments_doctor ON appointments (doctor_id);

-- Index for appointments by branch
CREATE INDEX idx_appointments_branch ON appointments (branch_id);

-- Index for appointments by date and time (for scheduling queries)
CREATE INDEX idx_appointments_datetime ON appointments (appointment_datetime);

-- Index for appointments by status
CREATE INDEX idx_appointments_status ON appointments (status);

-- Index for appointments by type
CREATE INDEX idx_appointments_type ON appointments (type);

-- Composite index for doctor's daily schedule
CREATE INDEX idx_appointments_doctor_date ON appointments (doctor_id, DATE(appointment_datetime));

-- Composite index for branch daily schedule
CREATE INDEX idx_appointments_branch_date ON appointments (branch_id, DATE(appointment_datetime));

-- Composite index for patient appointment history
CREATE INDEX idx_appointments_patient_datetime ON appointments (patient_id, appointment_datetime DESC);

-- Composite index for active appointments (scheduled, confirmed, in progress)
CREATE INDEX idx_appointments_active_status ON appointments (status, appointment_datetime) 
WHERE status IN ('Scheduled', 'Confirmed', 'In Progress');

-- Index for appointment date range queries (common for reports)
CREATE INDEX idx_appointments_date_range ON appointments (DATE(appointment_datetime));

-- =============================================================================
-- MEDICAL STAFF-RELATED INDEXES
-- =============================================================================

-- Index for medical staff by user_id
CREATE INDEX idx_medical_staff_user ON medical_staff (user_id);

-- Index for medical staff by specialty
CREATE INDEX idx_medical_staff_specialty ON medical_staff (specialty_id);

-- Index for medical staff by branch
CREATE INDEX idx_medical_staff_branch ON medical_staff (branch_id);

-- Index for active medical staff
CREATE INDEX idx_medical_staff_active ON medical_staff (is_active) WHERE is_active = true;

-- Index for medical staff by license number
CREATE INDEX idx_medical_staff_license ON medical_staff (license_number);

-- Index for medical staff name searches
CREATE INDEX idx_medical_staff_name ON medical_staff (last_name, first_name);

-- Composite index for active staff by branch and specialty
CREATE INDEX idx_medical_staff_branch_specialty_active ON medical_staff (branch_id, specialty_id, is_active);

-- =============================================================================
-- TREATMENT-RELATED INDEXES
-- =============================================================================

-- Index for treatments by service code
CREATE INDEX idx_treatments_service_code ON treatments (service_code);

-- Index for treatments by category
CREATE INDEX idx_treatments_category ON treatments (category_id);

-- Index for active treatments
CREATE INDEX idx_treatments_active ON treatments (is_active) WHERE is_active = true;

-- Index for treatment name searches
CREATE INDEX idx_treatments_name ON treatments (name);

-- Index for treatment price range queries
CREATE INDEX idx_treatments_price ON treatments (price);

-- Index for treatment records by appointment
CREATE INDEX idx_treatment_records_appointment ON treatment_records (appointment_id);

-- Index for treatment records by treatment
CREATE INDEX idx_treatment_records_treatment ON treatment_records (treatment_id);

-- Index for treatment records by recorded_by (medical staff)
CREATE INDEX idx_treatment_records_recorded_by ON treatment_records (recorded_by);

-- Index for treatment records by date
CREATE INDEX idx_treatment_records_date ON treatment_records (DATE(created_at));

-- =============================================================================
-- FINANCIAL/BILLING INDEXES
-- =============================================================================

-- Index for invoices by patient
CREATE INDEX idx_invoices_patient ON invoices (patient_id);

-- Index for invoices by appointment
CREATE INDEX idx_invoices_appointment ON invoices (appointment_id);

-- Index for invoices by status
CREATE INDEX idx_invoices_status ON invoices (status);

-- Index for invoices by invoice number
CREATE INDEX idx_invoices_number ON invoices (invoice_number);

-- Index for invoice date range queries
CREATE INDEX idx_invoices_date ON invoices (DATE(created_at));

-- Composite index for unpaid invoices
CREATE INDEX idx_invoices_unpaid ON invoices (status, created_at) 
WHERE status IN ('Draft', 'Sent', 'Overdue');

-- Index for payments by invoice
CREATE INDEX idx_payments_invoice ON payments (invoice_id);

-- Index for payments by payment method
CREATE INDEX idx_payments_method ON payments (payment_method);

-- Index for payments by processed_by
CREATE INDEX idx_payments_processed_by ON payments (processed_by);

-- Index for payments by date
CREATE INDEX idx_payments_date ON payments (DATE(payment_date));

-- Index for payment transaction references
CREATE INDEX idx_payments_transaction_ref ON payments (transaction_reference);

-- =============================================================================
-- INSURANCE-RELATED INDEXES
-- =============================================================================

-- Index for patient insurance by patient
CREATE INDEX idx_patient_insurance_patient ON patient_insurance (patient_id);

-- Index for patient insurance by provider
CREATE INDEX idx_patient_insurance_provider ON patient_insurance (provider_id);

-- Index for active patient insurance policies
CREATE INDEX idx_patient_insurance_active ON patient_insurance (is_active, expiration_date) 
WHERE is_active = true;

-- Index for insurance policy numbers
CREATE INDEX idx_patient_insurance_policy ON patient_insurance (policy_number);

-- Index for insurance claims by invoice
CREATE INDEX idx_insurance_claims_invoice ON insurance_claims (invoice_id);

-- Index for insurance claims by patient insurance
CREATE INDEX idx_insurance_claims_patient_insurance ON insurance_claims (patient_insurance_id);

-- Index for insurance claims by status
CREATE INDEX idx_insurance_claims_status ON insurance_claims (status);

-- Index for insurance claims by claim number
CREATE INDEX idx_insurance_claims_number ON insurance_claims (claim_number);

-- Index for insurance claims by submission date
CREATE INDEX idx_insurance_claims_submission_date ON insurance_claims (DATE(submission_date));

-- =============================================================================
-- BRANCH AND ADDRESS INDEXES
-- =============================================================================

-- Index for branches by address
CREATE INDEX idx_branches_address ON branches (address_id);

-- Index for active branches
CREATE INDEX idx_branches_active ON branches (is_active) WHERE is_active = true;

-- Index for branch hours by branch
CREATE INDEX idx_branch_hours_branch ON branch_hours (branch_id);

-- Index for branch hours by day of week
CREATE INDEX idx_branch_hours_day ON branch_hours (day_of_week);

-- Index for addresses by city (for location-based queries)
CREATE INDEX idx_addresses_city ON addresses (city);

-- Index for addresses by state
CREATE INDEX idx_addresses_state ON addresses (state);

-- Index for addresses by postal code
CREATE INDEX idx_addresses_postal_code ON addresses (postal_code);

-- =============================================================================
-- USER AND AUDIT INDEXES
-- =============================================================================

-- Index for users by username (login queries)
CREATE INDEX idx_users_username ON users (username);

-- Index for users by role
CREATE INDEX idx_users_role ON users (role);

-- Index for audit log by user
CREATE INDEX idx_audit_log_user ON audit_log (user_id);

-- Index for audit log by table and action (for monitoring specific operations)
CREATE INDEX idx_audit_log_table_action ON audit_log (table_name, action);

-- Index for audit log by timestamp (for time-based queries)
CREATE INDEX idx_audit_log_timestamp ON audit_log (timestamp);

-- Index for audit log by record_id (to track changes to specific records)
CREATE INDEX idx_audit_log_record ON audit_log (table_name, record_id);

-- =============================================================================
-- JSONB INDEXES (for insurance and contact info)
-- =============================================================================

-- GIN index for insurance provider contact info JSONB searches
CREATE INDEX idx_insurance_providers_contact_info ON insurance_providers USING GIN (contact_info);

-- GIN index for patient insurance coverage details
CREATE INDEX idx_patient_insurance_coverage ON patient_insurance USING GIN (coverage_details);

-- =============================================================================
-- PARTIAL INDEXES FOR PERFORMANCE
-- =============================================================================

-- Partial index for future appointments only
CREATE INDEX idx_appointments_future ON appointments (appointment_datetime, doctor_id) 
WHERE appointment_datetime > CURRENT_TIMESTAMP;

-- Partial index for today's appointments
CREATE INDEX idx_appointments_today ON appointments (doctor_id, appointment_datetime) 
WHERE DATE(appointment_datetime) = CURRENT_DATE;

-- Partial index for overdue invoices
CREATE INDEX idx_invoices_overdue ON invoices (created_at, patient_id) 
WHERE status = 'Overdue';

-- Partial index for pending insurance claims
CREATE INDEX idx_claims_pending ON insurance_claims (submission_date, patient_insurance_id) 
WHERE status IN ('Submitted', 'Under Review');

-- =============================================================================
-- TEXT SEARCH INDEXES
-- =============================================================================

-- Full-text search index for patient names
CREATE INDEX idx_patients_fulltext_name ON patients USING GIN (to_tsvector('english', first_name || ' ' || last_name));

-- Full-text search index for treatment names and descriptions
CREATE INDEX idx_treatments_fulltext ON treatments USING GIN (to_tsvector('english', name || ' ' || COALESCE(description, '')));

-- Full-text search index for medical staff names
CREATE INDEX idx_medical_staff_fulltext_name ON medical_staff USING GIN (to_tsvector('english', first_name || ' ' || last_name));

-- =============================================================================
-- COMPOSITE INDEXES FOR COMPLEX QUERIES
-- =============================================================================

-- Index for patient appointment statistics (count appointments per patient)
CREATE INDEX idx_patient_appointment_stats ON appointments (patient_id, status, DATE(appointment_datetime));

-- Index for doctor performance metrics
CREATE INDEX idx_doctor_performance ON appointments (doctor_id, status, DATE(appointment_datetime));

-- Index for branch revenue analysis
CREATE INDEX idx_branch_revenue ON treatment_records (appointment_id) 
INCLUDE (total_price, created_at);

-- Index for treatment popularity analysis
CREATE INDEX idx_treatment_popularity ON treatment_records (treatment_id, DATE(created_at));

COMMIT;

-- =============================================================================
-- INDEX MAINTENANCE RECOMMENDATIONS
-- =============================================================================

-- Display index creation summary
SELECT 'Database indexes created successfully!' as message;

-- Note: Regular ANALYZE should be run after bulk data loads to update statistics
-- ANALYZE;

-- Note: Consider REINDEX operations during maintenance windows for heavily updated tables
-- REINDEX TABLE appointments;
-- REINDEX TABLE patients;
-- REINDEX TABLE treatment_records;
