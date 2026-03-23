// Base API URL - uses Vite env variable
const BASE_URL = import.meta.env.VITE_API_URL || 'https://school-connect-6qt9.onrender.com/api';

// Authentication Endpoints
export const AUTH_ENDPOINTS = {
  LOGIN: `${BASE_URL}/auth/login`,
  REGISTER: `${BASE_URL}/auth/register`,
  REFRESH_TOKEN: `${BASE_URL}/auth/refresh`,
  LOGOUT: `${BASE_URL}/auth/logout`,
  FORGOT_PASSWORD: `${BASE_URL}/auth/forgot-password`,
  RESET_PASSWORD: `${BASE_URL}/auth/reset-password`,
  VERIFY_EMAIL: `${BASE_URL}/auth/verify-email`,
  CHANGE_PASSWORD: `${BASE_URL}/auth/change-password`,
};

// User Management Endpoints
export const USER_ENDPOINTS = {
  USERS: `${BASE_URL}/users`,
  PROFILE: (userId: string) => `${BASE_URL}/users/${userId}`,
  STATISTICS: `${BASE_URL}/users/statistics`,
};

// Tenant/School Management Endpoints
export const TENANT_ENDPOINTS = {
  REGISTER: `${BASE_URL}/tenants/register`,
  CURRENT: `${BASE_URL}/tenants/current`,
  STATISTICS: `${BASE_URL}/tenants/statistics`,
  SETTINGS: `${BASE_URL}/tenant/settings`,
};

// Super Admin Endpoints
export const SUPER_ADMIN_ENDPOINTS = {
  TENANTS: `${BASE_URL}/superadmin/tenants`,
  TENANT_BY_ID: (id: string) => `${BASE_URL}/superadmin/tenants/${id}`,
  ACTIVATE: (id: string) => `${BASE_URL}/superadmin/tenants/${id}/activate`,
  SUSPEND: (id: string) => `${BASE_URL}/superadmin/tenants/${id}/suspend`,
  SUBSCRIPTION: (id: string) => `${BASE_URL}/superadmin/tenants/${id}/subscription`,
  GLOBAL_STATS: `${BASE_URL}/superadmin/tenants/statistics/global`,
};

// Student Management Endpoints
export const STUDENT_ENDPOINTS = {
  STUDENTS: `${BASE_URL}/students`,
  STUDENT_BY_ID: (id: string) => `${BASE_URL}/students/${id}`,
  NEXT_ID: `${BASE_URL}/students/next-id`,
  IMPORT: `${BASE_URL}/students/import`,
  EXPORT: `${BASE_URL}/students/export`,
  STATISTICS: `${BASE_URL}/students/statistics`,
};

// Teacher Management Endpoints
export const TEACHER_ENDPOINTS = {
  TEACHERS: `${BASE_URL}/teachers`,
  TEACHER_BY_ID: (id: string) => `${BASE_URL}/teachers/${id}`,
  NEXT_ID: `${BASE_URL}/teachers/next-id`,
  ASSIGNMENTS: `${BASE_URL}/teachers/assignments`,
};

// Class/Section Management
export const CLASS_ENDPOINTS = {
  CLASSES: `${BASE_URL}/classes`,
  CLASS_BY_ID: (id: string) => `${BASE_URL}/classes/${id}`,
  SECTIONS: (classId: string) => `${BASE_URL}/classes/${classId}/sections`,
};

// Subject Management
export const SUBJECT_ENDPOINTS = {
  SUBJECTS: `${BASE_URL}/subjects`,
  SUBJECT_BY_ID: (id: string) => `${BASE_URL}/subjects/${id}`,
};

// Attendance
export const ATTENDANCE_ENDPOINTS = {
  ATTENDANCE: `${BASE_URL}/attendance`,
  BULK: `${BASE_URL}/attendance/bulk`,
  BY_CLASS: (classId: string) => `${BASE_URL}/attendance/class/${classId}`,
  BY_STUDENT: (studentId: string) => `${BASE_URL}/attendance/student/${studentId}`,
};

// Exam Management
export const EXAM_ENDPOINTS = {
  EXAMS: `${BASE_URL}/exams`,
  EXAM_BY_ID: (id: string) => `${BASE_URL}/exams/${id}`,
  TYPES: `${BASE_URL}/exams/types`,
  MARKS: (examId: string) => `${BASE_URL}/exams/${examId}/marks`,
  RESULTS: (examId: string) => `${BASE_URL}/exams/${examId}/results`,
};

// Fee Management
export const FEE_ENDPOINTS = {
  TYPES: `${BASE_URL}/fees/types`,
  STRUCTURE: `${BASE_URL}/fees/structure`,
  PAYMENT: `${BASE_URL}/fees/payment`,
  COLLECTION_REPORT: `${BASE_URL}/fees/report/collection`,
  OVERDUE: `${BASE_URL}/fees/overdue`,
};

// Leave Management
export const LEAVE_ENDPOINTS = {
  TYPES: `${BASE_URL}/leave/types`,
  REQUESTS: `${BASE_URL}/leave/requests`,
  PENDING: `${BASE_URL}/leave/requests/pending`,
  BALANCE: `${BASE_URL}/leave/balance`,
};

// Announcements
export const ANNOUNCEMENT_ENDPOINTS = {
  ANNOUNCEMENTS: `${BASE_URL}/announcements`,
};

// Timetable
export const TIMETABLE_ENDPOINTS = {
  PERIODS: `${BASE_URL}/timetable/periods`,
  ENTRIES: `${BASE_URL}/timetable/entries`,
  BY_CLASS: (classId: string) => `${BASE_URL}/timetable/class/${classId}`,
};

// Analytics
export const ANALYTICS_ENDPOINTS = {
  DASHBOARD: `${BASE_URL}/analytics/dashboard`,
  ATTENDANCE_TREND: `${BASE_URL}/analytics/attendance/trend`,
  FEE_SUMMARY: `${BASE_URL}/analytics/fee/summary`,
  STUDENT_DEMOGRAPHICS: `${BASE_URL}/analytics/student/demographics`,
  EXAM_PERFORMANCE: `${BASE_URL}/analytics/exam/performance`,
};

// Master Data
export const MASTER_DATA_ENDPOINTS = {
  BY_CATEGORY: (category: string) => `${BASE_URL}/master-data?category=${category}`,
  ALL: `${BASE_URL}/master-data/all`,
  CREATE: `${BASE_URL}/master-data`,
  UPDATE: (id: string) => `${BASE_URL}/master-data/${id}`,
  DELETE: (id: string) => `${BASE_URL}/master-data/${id}`,
};

// Reports
export const REPORT_ENDPOINTS = {
  REPORT_CARD: (studentId: string) => `${BASE_URL}/reports/student/${studentId}/report-card`,
  FEE_RECEIPT: (paymentId: string) => `${BASE_URL}/reports/fee-receipt/${paymentId}`,
};

// Config
export const CONFIG_ENDPOINTS = {
  MOBILE: `${BASE_URL}/config/mobile`,
};

export { BASE_URL };
