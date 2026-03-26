import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useFormik } from 'formik';
import * as Yup from 'yup';
import {
  Box,
  Button,
  Paper,
  TextField,
  Typography,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  FormHelperText,
  CircularProgress,
  Snackbar,
  Alert,
} from '@mui/material';
import {
  Save as SaveIcon,
  Cancel as CancelIcon,
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import apiService from '../../../../service/apiService';

const NOTICE_TYPES = ['GENERAL', 'ACADEMIC', 'EVENT', 'HOLIDAY', 'EXAM', 'FEE'] as const;
const TARGET_AUDIENCES = ['ALL', 'STUDENTS', 'TEACHERS', 'PARENTS'] as const;
const PRIORITIES = ['LOW', 'MEDIUM', 'HIGH', 'URGENT'] as const;

const validationSchema = Yup.object({
  title: Yup.string().required('Title is required').max(200, 'Title must be at most 200 characters'),
  content: Yup.string().required('Content is required'),
  type: Yup.string().oneOf([...NOTICE_TYPES]).required('Type is required'),
  targetAudience: Yup.string().oneOf([...TARGET_AUDIENCES]).required('Target audience is required'),
  priority: Yup.string().oneOf([...PRIORITIES]).required('Priority is required'),
  publishDate: Yup.date().nullable().required('Publish date is required'),
  expiryDate: Yup.date()
    .nullable()
    .required('Expiry date is required')
    .min(Yup.ref('publishDate'), 'Expiry date must be after publish date'),
});

const AddNoticePage: React.FC = () => {
  const navigate = useNavigate();
  const [snackbar, setSnackbar] = useState<{
    open: boolean;
    message: string;
    severity: 'success' | 'error';
  }>({ open: false, message: '', severity: 'success' });

  const formik = useFormik({
    initialValues: {
      title: '',
      content: '',
      type: '',
      targetAudience: '',
      priority: '',
      publishDate: null as Date | null,
      expiryDate: null as Date | null,
    },
    validationSchema,
    onSubmit: async (values) => {
      try {
        const authorId = localStorage.getItem('userId');
        if (!authorId) {
          setSnackbar({ open: true, message: 'Session expired. Please log in again.', severity: 'error' });
          return;
        }

        await apiService.post('/announcements', {
          title: values.title,
          content: values.content,
          type: values.type,
          targetAudience: values.targetAudience,
          priority: values.priority,
          publishDate: values.publishDate?.toISOString(),
          expiryDate: values.expiryDate?.toISOString(),
          authorId,
        });

        setSnackbar({ open: true, message: 'Notice created successfully!', severity: 'success' });
        setTimeout(() => navigate('/dashboard/notices'), 1500);
      } catch (error: any) {
        const raw = error?.message || '';
        const message = raw.includes('violates') || raw.includes('column')
          ? 'Failed to create notice. Please try again.'
          : raw || 'Failed to create notice. Please try again.';
        setSnackbar({ open: true, message, severity: 'error' });
      }
    },
  });

  return (
    <LocalizationProvider dateAdapter={AdapterDateFns}>
      <Box sx={{ p: 3, maxWidth: 900, margin: '0 auto' }}>
        {/* Gradient Header */}
        <Paper
          elevation={0}
          sx={{
            p: 3,
            mb: 3,
            borderRadius: 3,
            background: 'linear-gradient(135deg, #1e3a5f 0%, #3b82f6 100%)',
            color: 'white',
          }}
        >
          <Typography variant="h5" fontWeight={700}>
            Create Notice
          </Typography>
          <Typography variant="body2" sx={{ opacity: 0.85, mt: 0.5 }}>
            Fill in the details below to publish a new notice
          </Typography>
        </Paper>

        {/* Form */}
        <Paper elevation={1} sx={{ p: 4, borderRadius: 3 }}>
          <form onSubmit={formik.handleSubmit}>
            {/* Title */}
            <TextField
              fullWidth
              id="title"
              name="title"
              label="Title"
              value={formik.values.title}
              onChange={formik.handleChange}
              onBlur={formik.handleBlur}
              error={formik.touched.title && Boolean(formik.errors.title)}
              helperText={formik.touched.title && formik.errors.title}
              sx={{ mb: 3 }}
            />

            {/* Content */}
            <TextField
              fullWidth
              id="content"
              name="content"
              label="Content"
              multiline
              rows={5}
              value={formik.values.content}
              onChange={formik.handleChange}
              onBlur={formik.handleBlur}
              error={formik.touched.content && Boolean(formik.errors.content)}
              helperText={formik.touched.content && formik.errors.content}
              sx={{ mb: 3 }}
            />

            {/* Type, Target Audience, Priority - row */}
            <Box sx={{ display: 'flex', gap: 2, mb: 3, flexWrap: 'wrap' }}>
              <FormControl
                sx={{ flex: 1, minWidth: 180 }}
                error={formik.touched.type && Boolean(formik.errors.type)}
              >
                <InputLabel id="type-label">Type</InputLabel>
                <Select
                  labelId="type-label"
                  id="type"
                  name="type"
                  value={formik.values.type}
                  label="Type"
                  onChange={formik.handleChange}
                  onBlur={formik.handleBlur}
                >
                  {NOTICE_TYPES.map((t) => (
                    <MenuItem key={t} value={t}>
                      {t}
                    </MenuItem>
                  ))}
                </Select>
                {formik.touched.type && formik.errors.type && (
                  <FormHelperText>{formik.errors.type}</FormHelperText>
                )}
              </FormControl>

              <FormControl
                sx={{ flex: 1, minWidth: 180 }}
                error={formik.touched.targetAudience && Boolean(formik.errors.targetAudience)}
              >
                <InputLabel id="targetAudience-label">Target Audience</InputLabel>
                <Select
                  labelId="targetAudience-label"
                  id="targetAudience"
                  name="targetAudience"
                  value={formik.values.targetAudience}
                  label="Target Audience"
                  onChange={formik.handleChange}
                  onBlur={formik.handleBlur}
                >
                  {TARGET_AUDIENCES.map((a) => (
                    <MenuItem key={a} value={a}>
                      {a}
                    </MenuItem>
                  ))}
                </Select>
                {formik.touched.targetAudience && formik.errors.targetAudience && (
                  <FormHelperText>{formik.errors.targetAudience}</FormHelperText>
                )}
              </FormControl>

              <FormControl
                sx={{ flex: 1, minWidth: 180 }}
                error={formik.touched.priority && Boolean(formik.errors.priority)}
              >
                <InputLabel id="priority-label">Priority</InputLabel>
                <Select
                  labelId="priority-label"
                  id="priority"
                  name="priority"
                  value={formik.values.priority}
                  label="Priority"
                  onChange={formik.handleChange}
                  onBlur={formik.handleBlur}
                >
                  {PRIORITIES.map((p) => (
                    <MenuItem key={p} value={p}>
                      {p}
                    </MenuItem>
                  ))}
                </Select>
                {formik.touched.priority && formik.errors.priority && (
                  <FormHelperText>{formik.errors.priority}</FormHelperText>
                )}
              </FormControl>
            </Box>

            {/* Date pickers */}
            <Box sx={{ display: 'flex', gap: 2, mb: 4, flexWrap: 'wrap' }}>
              <DatePicker
                label="Publish Date"
                value={formik.values.publishDate}
                onChange={(value) => formik.setFieldValue('publishDate', value)}
                slotProps={{
                  textField: {
                    fullWidth: true,
                    sx: { flex: 1, minWidth: 200 },
                    error: formik.touched.publishDate && Boolean(formik.errors.publishDate),
                    helperText: formik.touched.publishDate && formik.errors.publishDate as string,
                    onBlur: () => formik.setFieldTouched('publishDate', true),
                  },
                }}
              />
              <DatePicker
                label="Expiry Date"
                value={formik.values.expiryDate}
                onChange={(value) => formik.setFieldValue('expiryDate', value)}
                minDate={formik.values.publishDate || undefined}
                slotProps={{
                  textField: {
                    fullWidth: true,
                    sx: { flex: 1, minWidth: 200 },
                    error: formik.touched.expiryDate && Boolean(formik.errors.expiryDate),
                    helperText: formik.touched.expiryDate && formik.errors.expiryDate as string,
                    onBlur: () => formik.setFieldTouched('expiryDate', true),
                  },
                }}
              />
            </Box>

            {/* Action buttons */}
            <Box sx={{ display: 'flex', gap: 2, justifyContent: 'flex-end' }}>
              <Button
                variant="outlined"
                startIcon={<CancelIcon />}
                onClick={() => navigate('/dashboard/notices')}
                disabled={formik.isSubmitting}
              >
                Cancel
              </Button>
              <Button
                type="submit"
                variant="contained"
                startIcon={formik.isSubmitting ? <CircularProgress size={20} color="inherit" /> : <SaveIcon />}
                disabled={formik.isSubmitting}
                sx={{
                  background: formik.isSubmitting
                    ? '#9ca3af'
                    : 'linear-gradient(135deg, #1e3a5f 0%, #3b82f6 100%)',
                  '&:hover': {
                    background: 'linear-gradient(135deg, #162d4a 0%, #2563eb 100%)',
                  },
                }}
              >
                {formik.isSubmitting ? 'Creating...' : 'Create Notice'}
              </Button>
            </Box>
          </form>
        </Paper>

        {/* Snackbar */}
        <Snackbar
          open={snackbar.open}
          autoHideDuration={4000}
          onClose={() => setSnackbar((prev) => ({ ...prev, open: false }))}
          anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
        >
          <Alert
            onClose={() => setSnackbar((prev) => ({ ...prev, open: false }))}
            severity={snackbar.severity}
            variant="filled"
            sx={{ width: '100%' }}
          >
            {snackbar.message}
          </Alert>
        </Snackbar>
      </Box>
    </LocalizationProvider>
  );
};

export default AddNoticePage;
