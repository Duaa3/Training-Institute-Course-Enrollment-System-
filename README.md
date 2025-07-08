# Training-Institute-Course-Enrollment-System
# 📚 Training Management System

A comprehensive database design and SQL project that models a scalable and normalized Training Management System (TMS) using relational schema, ER modeling, SQL DDL, and queries for different user perspectives (Admin, Trainer, and Trainee).

## 📌 Project Overview

Training Management Systems are essential tools for organizing, scheduling, and tracking employee learning. This project demonstrates the process of designing and implementing a TMS database from requirements analysis to SQL query execution.

Built as part of a data science and database design curriculum, this project focuses on:

- Designing normalized database schemas
- Writing and executing SQL DDL and DML statements
- Modeling real-world workflows for training institutions
- Practicing query logic from multiple user perspectives

## 📂 Contents

- ✅ Requirements Analysis
- ✅ ER Diagram
- ✅ Relational Schema Mapping
- ✅ SQL DDL Statements
- ✅ Sample Data
- ✅ SQL Queries for Admin, Trainer, and Trainee
- ✅ Data Modeling Research Insights
- ✅ Error Log & Troubleshooting

## 🧩 Key Features

- **Normalized Schema** (3NF): Avoids redundancy, ensures integrity
- **User Roles**: Admin, Trainer, and Trainee views
- **Scheduling Support**: Tracks timing, trainer assignments, and conflicts
- **SQL-Centric Design**: Focus on real-world DDL, DML, and query logic
- **Flexible Time Slots**: Supports Morning, Evening, and Weekend sessions

## 🧱 Database Schema

**Entities**:

- `Trainee(trainee_id, name, gender, email, background)`
- `Trainer(trainer_id, name, specialty, phone, email)`
- `Course(course_id, title, category, duration_hours, level)`
- `Schedule(schedule_id, course_id, trainer_id, start_date, end_date, time_slot)`
- `Enrollment(enrollment_id, trainee_id, course_id, enrollment_date)`

**Relationships**:

- A trainee can enroll in multiple courses
- A course can have multiple trainees and schedules
- A trainer can lead multiple scheduled sessions


