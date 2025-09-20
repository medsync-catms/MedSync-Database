-- MedSync CATMS PostgreSQL Database Schema
-- Based on the provided ERD

-- Create ENUM types
CREATE TYPE role AS ENUM ('admin', 'doctor', 'nurse', 'receptionist', 'manager');
CREATE TYPE gender AS ENUM ('Male', 'Female');
CREATE TYPE appointment_status AS ENUM ('Scheduled', 'Confirmed', 'In Progress', 'Completed', 'Cancelled', 'No Show');
CREATE TYPE appointment_type AS ENUM ('Regular', 'Emergency', 'Walk-in', 'Follow-up');
CREATE TYPE invoice_status AS ENUM ('Draft', 'Sent', 'Paid', 'Overdue', 'Cancelled');
CREATE TYPE payment_method AS ENUM ('Cash', 'Credit Card', 'Debit Card', 'Bank Transfer', 'Insurance', 'Cheque');
CREATE TYPE claim_status AS ENUM ('Submitted', 'Under Review', 'Approved', 'Rejected', 'Paid', 'Cancelled');

-- Addresses table
CREATE TABLE addresses (
    id SERIAL PRIMARY KEY,
    line1 TEXT NOT NULL,
    line2 TEXT,
    city TEXT NOT NULL,
    state TEXT,
    postal_code TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Branches table
CREATE TABLE branches (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    address_id INTEGER NOT NULL REFERENCES addresses(id),
    phone TEXT,
    email TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Branch hours table
CREATE TABLE branch_hours (
    id SERIAL PRIMARY KEY,
    branch_id INTEGER NOT NULL REFERENCES branches(id),
    day_of_week SMALLINT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6), -- 0=Sunday, 6=Saturday
    open_time TIME NOT NULL,
    close_time TIME NOT NULL,
    UNIQUE(branch_id, day_of_week)
);

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role role NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Specialties table
CREATE TABLE specialties (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Medical staff table
CREATE TABLE medical_staff (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    specialty_id INTEGER REFERENCES specialties(id),
    license_number TEXT UNIQUE,
    phone TEXT,
    email TEXT,
    branch_id INTEGER NOT NULL REFERENCES branches(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patients table
CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    date_of_birth DATE NOT NULL,
    gender gender NOT NULL,
    address_id INTEGER NOT NULL REFERENCES addresses(id),
    phone TEXT NOT NULL,
    email TEXT,
    registered_branch INTEGER NOT NULL REFERENCES branches(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patient emergency contacts table
CREATE TABLE patient_contacts (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    relation TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Treatment categories table
CREATE TABLE treatment_categories (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Treatments/Services catalog table
CREATE TABLE treatments (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    category_id INTEGER NOT NULL REFERENCES treatment_categories(id),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Appointments table
CREATE TABLE appointments (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    doctor_id INTEGER NOT NULL REFERENCES medical_staff(id),
    branch_id INTEGER NOT NULL REFERENCES branches(id),
    appointment_datetime TIMESTAMP NOT NULL,
    status appointment_status DEFAULT 'Scheduled',
    type appointment_type DEFAULT 'Regular',
    notes TEXT,
    cancellation_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Treatment records table (what was actually performed during appointment)
CREATE TABLE treatment_records (
    id SERIAL PRIMARY KEY,
    appointment_id INTEGER NOT NULL REFERENCES appointments(id),
    treatment_id INTEGER NOT NULL REFERENCES treatments(id),
    quantity INTEGER DEFAULT 1 CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    total_price DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    consultation_notes TEXT,
    recorded_by INTEGER NOT NULL REFERENCES medical_staff(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Invoices table
CREATE TABLE invoices (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    appointment_id INTEGER REFERENCES appointments(id),
    invoice_number TEXT UNIQUE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status invoice_status DEFAULT 'Draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payments table
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES invoices(id),
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_method payment_method NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_reference TEXT,
    processed_by INTEGER NOT NULL REFERENCES users(id),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insurance providers table
CREATE TABLE insurance_providers (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    contact_info JSONB,
    processing_requirements TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Patient insurance policies table
CREATE TABLE patient_insurance (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id),
    provider_id INTEGER NOT NULL REFERENCES insurance_providers(id),
    policy_number TEXT NOT NULL,
    coverage_details JSONB,
    expiration_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(patient_id, provider_id, policy_number)
);

-- Insurance claims table
CREATE TABLE insurance_claims (
    id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES invoices(id),
    patient_insurance_id INTEGER NOT NULL REFERENCES patient_insurance(id),
    claim_number TEXT UNIQUE NOT NULL,
    claim_amount DECIMAL(10,2) NOT NULL CHECK (claim_amount >= 0),
    approved_amount DECIMAL(10,2) DEFAULT 0 CHECK (approved_amount >= 0),
    status claim_status DEFAULT 'Submitted',
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    response_date TIMESTAMP,
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit log table
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    action TEXT NOT NULL,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    old_values JSONB,
    new_values JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address INET,
    user_agent TEXT
);