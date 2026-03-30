import apiService from '../../../service/apiService';
import { FILE_ENDPOINTS } from '../../../config/api.config';

export interface FileUploadResponse {
  id: string;
  originalName: string;
  contentType: string;
  fileSize: number;
  entityType?: string;
  entityId?: string;
  downloadUrl: string;
  createdAt: string;
}

export const fileAPI = {
  async upload(
    file: File,
    entityType?: string,
    entityId?: string
  ): Promise<FileUploadResponse> {
    const formData = new FormData();
    formData.append('file', file);
    if (entityType) formData.append('entityType', entityType);
    if (entityId) formData.append('entityId', entityId);

    const response = await apiService.post(FILE_ENDPOINTS.UPLOAD, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return response?.data || response;
  },

  async uploadMultiple(
    files: File[],
    entityType?: string,
    entityId?: string
  ): Promise<FileUploadResponse[]> {
    const formData = new FormData();
    files.forEach((file) => formData.append('files', file));
    if (entityType) formData.append('entityType', entityType);
    if (entityId) formData.append('entityId', entityId);

    const response = await apiService.post(FILE_ENDPOINTS.UPLOAD_MULTIPLE, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return response?.data || response;
  },

  async list(page = 0, size = 20): Promise<{ content: FileUploadResponse[]; totalElements: number }> {
    const response = await apiService.get(`${FILE_ENDPOINTS.LIST}?page=${page}&size=${size}`);
    return response?.data || response;
  },

  async getEntityFiles(entityType: string, entityId: string): Promise<FileUploadResponse[]> {
    const response = await apiService.get(FILE_ENDPOINTS.ENTITY_FILES(entityType, entityId));
    return response?.data || response;
  },

  getDownloadUrl(id: string): string {
    const baseUrl = import.meta.env.VITE_API_URL || '';
    return `${baseUrl}${FILE_ENDPOINTS.DOWNLOAD(id)}`;
  },

  async deleteFile(id: string): Promise<void> {
    await apiService.delete(FILE_ENDPOINTS.DELETE(id));
  },
};
