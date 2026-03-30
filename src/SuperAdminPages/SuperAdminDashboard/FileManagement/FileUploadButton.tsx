import React, { useRef, useState } from 'react';
import {
  Button,
  Box,
  CircularProgress,
  Chip,
} from '@mui/material';
import { CloudUpload, Delete, InsertDriveFile } from '@mui/icons-material';
import { toast } from 'react-toastify';
import { fileAPI, FileUploadResponse } from './fileAPI';

interface FileUploadButtonProps {
  entityType?: string;
  entityId?: string;
  accept?: string;
  multiple?: boolean;
  maxSizeMB?: number;
  onUploadComplete?: (files: FileUploadResponse[]) => void;
  label?: string;
}

const FileUploadButton: React.FC<FileUploadButtonProps> = ({
  entityType,
  entityId,
  accept = '.jpg,.jpeg,.png,.pdf,.doc,.docx,.xls,.xlsx,.csv',
  multiple = false,
  maxSizeMB = 10,
  onUploadComplete,
  label = 'Upload File',
}) => {
  const inputRef = useRef<HTMLInputElement>(null);
  const [uploading, setUploading] = useState(false);
  const [uploadedFiles, setUploadedFiles] = useState<FileUploadResponse[]>([]);

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || files.length === 0) return;

    const fileArray = Array.from(files);
    const oversized = fileArray.filter((f) => f.size > maxSizeMB * 1024 * 1024);
    if (oversized.length > 0) {
      toast.error(`File(s) exceed ${maxSizeMB}MB limit: ${oversized.map((f) => f.name).join(', ')}`);
      return;
    }

    setUploading(true);
    try {
      let results: FileUploadResponse[];
      if (multiple && fileArray.length > 1) {
        results = await fileAPI.uploadMultiple(fileArray, entityType, entityId);
      } else {
        const result = await fileAPI.upload(fileArray[0], entityType, entityId);
        results = [result];
      }

      setUploadedFiles((prev) => [...prev, ...results]);
      onUploadComplete?.(results);
      toast.success(`${results.length} file(s) uploaded successfully`);
    } catch (err: any) {
      toast.error(err?.message || 'Upload failed');
    } finally {
      setUploading(false);
      if (inputRef.current) inputRef.current.value = '';
    }
  };

  const handleDelete = async (fileId: string) => {
    try {
      await fileAPI.deleteFile(fileId);
      setUploadedFiles((prev) => prev.filter((f) => f.id !== fileId));
      toast.success('File deleted');
    } catch {
      toast.error('Failed to delete file');
    }
  };

  return (
    <Box>
      <Button
        variant="outlined"
        component="label"
        startIcon={uploading ? <CircularProgress size={18} /> : <CloudUpload />}
        disabled={uploading}
      >
        {uploading ? 'Uploading...' : label}
        <input
          ref={inputRef}
          type="file"
          hidden
          accept={accept}
          multiple={multiple}
          onChange={handleFileChange}
        />
      </Button>

      {uploadedFiles.length > 0 && (
        <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1, mt: 1 }}>
          {uploadedFiles.map((file) => (
            <Chip
              key={file.id}
              icon={<InsertDriveFile fontSize="small" />}
              label={`${file.originalName} (${(file.fileSize / 1024).toFixed(0)}KB)`}
              onDelete={() => handleDelete(file.id)}
              deleteIcon={<Delete fontSize="small" />}
              variant="outlined"
              size="small"
            />
          ))}
        </Box>
      )}
    </Box>
  );
};

export default FileUploadButton;
