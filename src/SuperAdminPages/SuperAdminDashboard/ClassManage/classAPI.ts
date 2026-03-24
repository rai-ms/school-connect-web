import apiService from '../../../service/apiService';

export interface Teacher {
  id: string;
  name: string;
  email?: string;
}

export interface Section {
  id: string;
  name: string;
  studentCount: number;
  classTeacherId?: string | null;
  classTeacherName?: string | null;
  maxStudents: number;
  classTeacher?: Teacher;
}

export interface ClassData {
  id: string;
  className: string;
  code?: string;
  description?: string;
  status: 'Active' | 'Inactive';
  createdAt: string;
  updatedAt: string;
  sections: Section[];
}

const formatTimestamp = (ts: any): string => {
  if (!ts) return '';
  if (typeof ts === 'string') return ts;
  if (Array.isArray(ts)) {
    return new Date(ts[0], (ts[1] || 1) - 1, ts[2] || 1).toISOString();
  }
  return '';
};

const mapSection = (s: any): Section => ({
  id: s.id || '',
  name: s.name || '',
  studentCount: s.studentCount ?? s.capacity ?? 0,
  classTeacherId: s.classTeacherId || null,
  classTeacherName: s.classTeacherName || null,
  maxStudents: s.capacity ?? s.maxStudents ?? 40,
  classTeacher: s.classTeacherId
    ? { id: s.classTeacherId, name: s.classTeacherName || 'Assigned' }
    : undefined,
});

const mapClass = (c: any): ClassData => ({
  id: c.id || '',
  className: c.name || c.className || '',
  code: c.code || '',
  description: c.description || '',
  status: (c.status === 'INACTIVE' || c.status === 'Inactive') ? 'Inactive' : 'Active',
  createdAt: formatTimestamp(c.createdAt),
  updatedAt: formatTimestamp(c.updatedAt),
  sections: (c.sections || []).map(mapSection),
});

export const fetchClasses = async (): Promise<ClassData[]> => {
  try {
    const res = await apiService.get('/classes', { params: { page: 0, size: 100 } });
    const data = res?.data || res || {};
    const content = data.content || data.classes || data || [];
    const arr = Array.isArray(content) ? content : [];
    return arr.map(mapClass);
  } catch (error) {
    console.error('Error fetching classes:', error);
    return [];
  }
};

export const createClass = async (classData: any): Promise<ClassData> => {
  const body = {
    name: classData.className || classData.name,
    code: classData.code || '',
    description: classData.description || '',
    sections: (classData.sections || []).map((s: any) => ({
      name: s.name,
      capacity: s.maxStudents || 40,
      classTeacherId: s.classTeacherId || null,
    })),
  };
  const res = await apiService.post('/classes', body);
  return mapClass(res?.data || res);
};

export const updateClass = async (id: string, classData: any): Promise<ClassData> => {
  const body = {
    name: classData.className || classData.name,
    code: classData.code || '',
    description: classData.description || '',
    sections: (classData.sections || []).map((s: any) => ({
      id: s.id,
      name: s.name,
      capacity: s.maxStudents || 40,
      classTeacherId: s.classTeacherId || null,
    })),
  };
  const res = await apiService.put(`/classes/${id}`, body);
  return mapClass(res?.data || res);
};

export const getClassById = async (id: string): Promise<ClassData | null> => {
  try {
    const res = await apiService.get(`/classes/${id}`);
    const data = res?.data || res;
    return data ? mapClass(data) : null;
  } catch (error) {
    console.error('Error fetching class:', error);
    return null;
  }
};

export const deleteClass = async (id: string): Promise<void> => {
  await apiService.delete(`/classes/${id}`);
};

const classAPI = {
  fetchClasses,
  getClassById,
  createClass,
  updateClass,
  deleteClass,
};

export default classAPI;
