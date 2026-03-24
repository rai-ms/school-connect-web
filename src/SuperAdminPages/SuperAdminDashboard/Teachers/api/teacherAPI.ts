import apiService from '../../../../service/apiService';
import { Teacher, TeacherFilterOptions, TeacherListResponse } from '../types/teacher.types';

const mapTeacher = (t: any): Teacher => ({
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
});

export const teacherAPI = {
  async getTeachers(filters: Partial<TeacherFilterOptions> = {}): Promise<TeacherListResponse> {
    try {
      const page = (filters.page || 1) - 1;
      const size = filters.limit || 10;

      const response = await apiService.get('/teachers', {
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

      const data = response?.data || response || {};
      const content = data.content || data.teachers || data || [];
      const teachersArray = Array.isArray(content) ? content : [];
      const totalElements = data.totalElements ?? data.total ?? teachersArray.length;

      return {
        data: teachersArray.map(mapTeacher),
        total: totalElements,
        page: filters.page || 1,
        limit: size,
        totalPages: data.totalPages ?? Math.ceil(totalElements / size),
      };
    } catch (error) {
      console.error('Error fetching teachers:', error);
      return { data: [], total: 0, page: 1, limit: 10, totalPages: 0 };
    }
  },

  async getTeacherById(id: string): Promise<Teacher> {
    const response = await apiService.get(`/teachers/${id}`);
    const t = response?.data || response || {};
    return mapTeacher(t);
  },

  async createTeacher(formData: FormData): Promise<Teacher> {
    const response = await apiService.post('/teachers', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return response?.data || response;
  },

  async updateTeacher(id: string, formData: FormData): Promise<Teacher> {
    const response = await apiService.put(`/teachers/${id}`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return response?.data || response;
  },

  async deleteTeacher(id: string): Promise<void> {
    await apiService.delete(`/teachers/${id}`);
  },

  async getTeacherStatistics(): Promise<{
    total: number;
    active: number;
    inactive: number;
    bySpecialization: Record<string, number>;
  }> {
    try {
      const response = await apiService.get('/teachers/statistics');
      const data = response?.data || response || {};
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

  async exportTeachers(format: 'csv' | 'excel' = 'csv'): Promise<Blob> {
    try {
      const response = await apiService.get('/teachers/export', {
        params: { format },
        headers: { Accept: format === 'csv' ? 'text/csv' : 'application/vnd.ms-excel' },
      });
      return response as any;
    } catch (error) {
      console.error('Error exporting teachers:', error);
      return new Blob(['No data available'], { type: 'text/csv' });
    }
  },

  async uploadDocument(teacherId: string, file: File, type: 'resume' | 'certificate' | 'other' = 'other'): Promise<{ url: string }> {
    const formData = new FormData();
    formData.append('file', file);
    formData.append('type', type);
    const response = await apiService.post(`/teachers/${teacherId}/documents`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return response?.data || response;
  },

  async deleteDocument(teacherId: string, documentId: string): Promise<void> {
    await apiService.delete(`/teachers/${teacherId}/documents/${documentId}`);
  },

  async getAssignedClasses(teacherId: string): Promise<string[]> {
    const response = await apiService.get(`/teachers/${teacherId}/classes`);
    return response?.data || response || [];
  },

  async updateAssignedClasses(teacherId: string, classes: string[]): Promise<void> {
    await apiService.put(`/teachers/${teacherId}/classes`, { classes });
  },

  async getTeacherSchedule(teacherId: string): Promise<any> {
    const response = await apiService.get(`/teachers/${teacherId}/schedule`);
    return response?.data || response;
  },

  async updateTeacherSchedule(teacherId: string, schedule: any): Promise<void> {
    await apiService.put(`/teachers/${teacherId}/schedule`, schedule);
  },
};
