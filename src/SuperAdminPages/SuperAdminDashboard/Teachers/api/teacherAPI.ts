import axios from 'axios';
import { Teacher, TeacherFilterOptions, TeacherListResponse } from '../types/teacher.types';
import { TEACHER_ENDPOINTS } from '../../../../config/api.config';

const getAuthHeaders = () => {
  const token = localStorage.getItem('authToken');
  return token ? { Authorization: `Bearer ${token}` } : {};
};

export const teacherAPI = {
  // Get all teachers with filters
  async getTeachers(filters: Partial<TeacherFilterOptions> = {}): Promise<TeacherListResponse> {
    try {
      const page = (filters.page || 1) - 1; // Backend uses 0-based pages
      const size = filters.limit || 10;

      const response = await axios.get(TEACHER_ENDPOINTS.TEACHERS, {
        headers: getAuthHeaders(),
        params: {
          page,
          size,
          ...(filters.searchTerm ? { search: filters.searchTerm } : {}),
          ...(filters.status ? { status: filters.status } : {}),
          ...(filters.experienceMin ? { experienceMin: filters.experienceMin } : {}),
          ...(filters.sortBy ? { sortBy: filters.sortBy } : {}),
          ...(filters.sortOrder ? { sortOrder: filters.sortOrder } : {}),
        },
      });

      const data = response.data?.data || response.data || {};
      const content = data.content || data.teachers || data || [];
      const teachersArray = Array.isArray(content) ? content : [];

      const mappedTeachers: Teacher[] = teachersArray.map((t: any) => ({
        id: t.id?.toString() || '',
        teacherId: t.teacherId || t.employeeId || t.id?.toString() || '',
        fullName: t.fullName || t.name || `${t.firstName || ''} ${t.lastName || ''}`.trim(),
        email: t.email || '',
        phone: t.phone || t.phoneNumber || '',
        alternatePhone: t.alternatePhone || t.alternatePhoneNumber || undefined,
        dateOfBirth: t.dateOfBirth || t.dob || '',
        gender: t.gender || 'Other',
        qualification: t.qualification || t.education || '',
        experience: t.experience || t.yearsOfExperience || 0,
        specialization: t.specialization || t.subjects || [],
        assignedClasses: t.assignedClasses || t.classes || [],
        joiningDate: t.joiningDate || t.dateOfJoining || t.createdAt || '',
        address: t.address || '',
        isClassTeacher: t.isClassTeacher || false,
        transportAssigned: t.transportAssigned || false,
        hostelAssigned: t.hostelAssigned || false,
        status: (t.status === 'ACTIVE' || t.status === 'Active') ? 'Active' : 'Inactive',
        profilePhoto: t.profilePhoto || t.avatar || undefined,
        documents: t.documents || [],
        createdAt: t.createdAt || '',
        updatedAt: t.updatedAt || '',
      }));

      const totalElements = data.totalElements ?? data.total ?? mappedTeachers.length;

      return {
        data: mappedTeachers,
        total: totalElements,
        page: (filters.page || 1),
        limit: size,
        totalPages: data.totalPages ?? Math.ceil(totalElements / size),
      };
    } catch (error) {
      console.error('Error fetching teachers:', error);
      return { data: [], total: 0, page: 1, limit: 10, totalPages: 0 };
    }
  },

  // Get single teacher by ID
  async getTeacherById(id: string): Promise<Teacher> {
    const response = await axios.get(TEACHER_ENDPOINTS.TEACHER_BY_ID(id), {
      headers: getAuthHeaders(),
    });
    const t = response.data?.data || response.data || {};
    return {
      id: t.id?.toString() || '',
      teacherId: t.teacherId || t.employeeId || t.id?.toString() || '',
      fullName: t.fullName || t.name || `${t.firstName || ''} ${t.lastName || ''}`.trim(),
      email: t.email || '',
      phone: t.phone || '',
      alternatePhone: t.alternatePhone || undefined,
      dateOfBirth: t.dateOfBirth || '',
      gender: t.gender || 'Other',
      qualification: t.qualification || '',
      experience: t.experience || 0,
      specialization: t.specialization || t.subjects || [],
      assignedClasses: t.assignedClasses || t.classes || [],
      joiningDate: t.joiningDate || t.createdAt || '',
      address: t.address || '',
      isClassTeacher: t.isClassTeacher || false,
      transportAssigned: t.transportAssigned || false,
      hostelAssigned: t.hostelAssigned || false,
      status: (t.status === 'ACTIVE' || t.status === 'Active') ? 'Active' : 'Inactive',
      profilePhoto: t.profilePhoto || undefined,
      documents: t.documents || [],
      createdAt: t.createdAt || '',
      updatedAt: t.updatedAt || '',
    };
  },

  // Create new teacher
  async createTeacher(formData: FormData): Promise<Teacher> {
    const response = await axios.post(TEACHER_ENDPOINTS.TEACHERS, formData, {
      headers: {
        ...getAuthHeaders(),
        'Content-Type': 'multipart/form-data',
      },
    });
    return response.data?.data || response.data;
  },

  // Update teacher
  async updateTeacher(id: string, formData: FormData): Promise<Teacher> {
    const response = await axios.put(TEACHER_ENDPOINTS.TEACHER_BY_ID(id), formData, {
      headers: {
        ...getAuthHeaders(),
        'Content-Type': 'multipart/form-data',
      },
    });
    return response.data?.data || response.data;
  },

  // Delete teacher
  async deleteTeacher(id: string): Promise<void> {
    await axios.delete(TEACHER_ENDPOINTS.TEACHER_BY_ID(id), {
      headers: getAuthHeaders(),
    });
  },

  // Get teacher statistics
  async getTeacherStatistics(): Promise<{
    total: number;
    active: number;
    inactive: number;
    bySpecialization: Record<string, number>;
  }> {
    try {
      const response = await axios.get(`${TEACHER_ENDPOINTS.TEACHERS}/statistics`, {
        headers: getAuthHeaders(),
      });
      const data = response.data?.data || response.data || {};
      return {
        total: data.total || 0,
        active: data.active || 0,
        inactive: data.inactive || 0,
        bySpecialization: data.bySpecialization || {},
      };
    } catch (error) {
      console.error('Error fetching teacher statistics:', error);
      return { total: 0, active: 0, inactive: 0, bySpecialization: {} };
    }
  },

  // Export teachers data
  async exportTeachers(format: 'csv' | 'excel' = 'csv'): Promise<Blob> {
    try {
      const response = await axios.get(`${TEACHER_ENDPOINTS.TEACHERS}/export`, {
        headers: getAuthHeaders(),
        params: { format },
        responseType: 'blob',
      });
      return response.data;
    } catch (error) {
      console.error('Error exporting teachers:', error);
      // Fallback: return empty CSV blob
      return new Blob(['No data available'], { type: 'text/csv' });
    }
  },

  // Upload teacher document
  async uploadDocument(teacherId: string, file: File, type: 'resume' | 'certificate' | 'other' = 'other'): Promise<{ url: string }> {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('type', type);
    const response = await axios.post(
      `${TEACHER_ENDPOINTS.TEACHER_BY_ID(teacherId)}/documents`,
      formData,
      {
        headers: {
          ...getAuthHeaders(),
          'Content-Type': 'multipart/form-data',
        },
      }
    );
    return response.data?.data || response.data;
  },

  // Delete teacher document
  async deleteDocument(teacherId: string, documentId: string): Promise<void> {
    await axios.delete(
      `${TEACHER_ENDPOINTS.TEACHER_BY_ID(teacherId)}/documents/${documentId}`,
      { headers: getAuthHeaders() }
    );
  },

  // Get teacher's assigned classes
  async getAssignedClasses(teacherId: string): Promise<string[]> {
    const response = await axios.get(
      `${TEACHER_ENDPOINTS.TEACHER_BY_ID(teacherId)}/classes`,
      { headers: getAuthHeaders() }
    );
    return response.data?.data || response.data || [];
  },

  // Update teacher's assigned classes
  async updateAssignedClasses(teacherId: string, classes: string[]): Promise<void> {
    await axios.put(
      `${TEACHER_ENDPOINTS.TEACHER_BY_ID(teacherId)}/classes`,
      { classes },
      { headers: getAuthHeaders() }
    );
  },

  // Get teacher's schedule
  async getTeacherSchedule(teacherId: string): Promise<any> {
    const response = await axios.get(
      `${TEACHER_ENDPOINTS.TEACHER_BY_ID(teacherId)}/schedule`,
      { headers: getAuthHeaders() }
    );
    return response.data?.data || response.data;
  },

  // Update teacher's schedule
  async updateTeacherSchedule(teacherId: string, schedule: any): Promise<void> {
    await axios.put(
      `${TEACHER_ENDPOINTS.TEACHER_BY_ID(teacherId)}/schedule`,
      schedule,
      { headers: getAuthHeaders() }
    );
  }
};
