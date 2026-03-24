import React, { useState, useEffect } from 'react';
import { useFormik } from 'formik';
import * as Yup from 'yup';
import { useNavigate } from 'react-router-dom';
import {
  Box,
  Button,
  Paper,
  TextField,
  Typography,
  Divider,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  FormControlLabel,
  Checkbox,
  Chip,
  FormHelperText,
  CircularProgress,
  Avatar,
  IconButton,
  Snackbar,
  Alert,
} from '@mui/material';
import {
  AddPhotoAlternate as AddPhotoIcon,
  Delete as DeleteIcon,
  Save as SaveIcon,
  Cancel as CancelIcon,
  Add as AddIcon,
  Badge as BadgeIcon,
} from '@mui/icons-material';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import { TeacherFormData } from './types/teacher.types';
import { teacherAPI } from './api/teacherAPI';
import apiService from '../../../service/apiService';

// Fallback if master data not seeded yet
const FALLBACK_QUALIFICATIONS = ['B.Ed', 'M.Ed', 'B.Sc', 'M.Sc', 'B.A', 'M.A', 'Ph.D', 'D.El.Ed', 'B.Tech', 'M.Tech', 'B.Com', 'M.Com', 'MBA', 'Other'];
const FALLBACK_SUBJECTS = ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'Hindi', 'Sanskrit', 'History', 'Geography', 'Political Science', 'Economics', 'Business Studies', 'Accountancy', 'Computer Science', 'Physical Education', 'Art', 'Music'];

interface MasterDataItem {
  id: string;
  name: string;
  code?: string;
}

const AddTeacherForm: React.FC = () => {
  const navigate = useNavigate();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const [documentPreviews, setDocumentPreviews] = useState<Array<{ file: File; preview: string }>>([]);
  const [employeeId, setEmployeeId] = useState('');
  const [designations, setDesignations] = useState<MasterDataItem[]>([]);
  const [departments, setDepartments] = useState<MasterDataItem[]>([]);
  const [employeeTypes, setEmployeeTypes] = useState<MasterDataItem[]>([]);
  const [subjects, setSubjects] = useState<string[]>([]);
  const [qualifications, setQualifications] = useState<string[]>([]);
  const [snackbar, setSnackbar] = useState({ open: false, message: '', severity: 'success' as 'success' | 'error' });

  // Fetch master data + next employee ID
  useEffect(() => {
    const extract = (res: any) => {
      if (res.status !== 'fulfilled') return [];
      const data = res.value?.data || res.value || [];
      return Array.isArray(data) ? data.map((d: any) => ({ id: d.id || d.value || d.code, name: d.label || d.name || d.value || '', code: d.value || d.code })) : [];
    };

    const fetchMasterData = async () => {
      try {
        const [nextIdRes, desigRes, deptRes, empTypeRes, subjectRes, qualRes] = await Promise.allSettled([
          apiService.get('/teachers/next-id'),
          apiService.get('/master-data?category=DESIGNATION'),
          apiService.get('/master-data?category=DEPARTMENT'),
          apiService.get('/master-data?category=EMPLOYEE_TYPE'),
          apiService.get('/master-data?category=SUBJECT_TYPE'),
          apiService.get('/master-data?category=QUALIFICATION'),
        ]);
        if (nextIdRes.status === 'fulfilled') {
          const id = nextIdRes.value?.data?.employeeId || nextIdRes.value?.employeeId || '';
          setEmployeeId(id);
        }
        setDesignations(extract(desigRes));
        setDepartments(extract(deptRes));
        setEmployeeTypes(extract(empTypeRes));

        const subjectItems = extract(subjectRes);
        setSubjects(subjectItems.length > 0 ? subjectItems.map(s => s.name) : FALLBACK_SUBJECTS);

        const qualItems = extract(qualRes);
        setQualifications(qualItems.length > 0 ? qualItems.map(q => q.name) : FALLBACK_QUALIFICATIONS);
      } catch (err) {
        console.error('Error fetching master data:', err);
        setSubjects(FALLBACK_SUBJECTS);
        setQualifications(FALLBACK_QUALIFICATIONS);
      }
    };
    fetchMasterData();
  }, []);

  // Form validation schema
  const validationSchema = Yup.object({
    fullName: Yup.string().required('Full name is required'),
    email: Yup.string().email('Invalid email address').required('Email is required'),
    phone: Yup.string()
      .required('Phone number is required')
      .matches(/^[0-9]{10}$/, 'Phone number must be 10 digits'),
    alternatePhone: Yup.string().matches(
      /^[0-9]{10}$/,
      'Alternate phone must be 10 digits'
    ),
    dateOfBirth: Yup.date()
      .required('Date of birth is required')
      .max(new Date(), 'Date of birth cannot be in the future'),
    gender: Yup.string().required('Gender is required'),
    qualification: Yup.string().required('Qualification is required'),
    experience: Yup.number()
      .typeError('Experience must be a number')
      .min(0, 'Experience cannot be negative')
      .required('Experience is required'),
    specialization: Yup.array()
      .min(1, 'Select at least one subject')
      .required('Specialization is required'),
    assignedClasses: Yup.array(),
    joiningDate: Yup.date()
      .required('Joining date is required')
      .max(new Date(), 'Joining date cannot be in the future'),
    address: Yup.string().required('Address is required'),
    isClassTeacher: Yup.boolean(),
    transportAssigned: Yup.boolean(),
    hostelAssigned: Yup.boolean(),
    password: Yup.string()
      .min(8, 'Password must be at least 8 characters')
      .required('Password is required'),
    confirmPassword: Yup.string()
      .oneOf([Yup.ref('password')], 'Passwords must match')
      .required('Confirm Password is required'),
  });

  // Formik form
  const formik = useFormik<TeacherFormData>({
    initialValues: {
      fullName: '',
      email: '',
      phone: '',
      alternatePhone: '',
      dateOfBirth: '',
      gender: 'Male',
      designation: '',
      department: '',
      employeeType: '',
      qualification: '',
      experience: 0,
      specialization: [],
      assignedClasses: [],
      joiningDate: new Date().toISOString().split('T')[0],
      address: '',
      isClassTeacher: false,
      transportAssigned: false,
      hostelAssigned: false,
      status: 'Active',
      password: '',
      confirmPassword: '',
    } as any,
    validationSchema,
    onSubmit: async (values) => {
      try {
        setIsSubmitting(true);
        
        const formData = new FormData();
        
        // Append all form fields to formData
        Object.entries(values).forEach(([key, value]) => {
          if (Array.isArray(value)) {
            value.forEach(item => formData.append(key, item));
          } else if (value !== null && value !== undefined) {
            formData.append(key, value);
          }
        });
        
        // Append profile photo if exists
        if (values.profilePhotoFile) {
          formData.append('profilePhoto', values.profilePhotoFile);
        }
        
        // Append document files if any
        if (values.documentFiles) {
          Array.from(values.documentFiles).forEach((file, index) => {
            formData.append(`documents[${index}]`, file);
          });
        }
        
        await teacherAPI.createTeacher(formData);
        setSnackbar({ open: true, message: 'Teacher created successfully!', severity: 'success' });
        setTimeout(() => navigate('/dashboard/teachers'), 1500);
      } catch (error: any) {
        console.error('Error creating teacher:', error);
        setSnackbar({ open: true, message: error?.message || 'Failed to create teacher', severity: 'error' });
      } finally {
        setIsSubmitting(false);
      }
    },
  });

  // Handle profile photo change
  const handleImageChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreview(reader.result as string);
        formik.setFieldValue('profilePhotoFile', file);
      };
      reader.readAsDataURL(file);
    }
  };

  // Handle document uploads
  const handleDocumentUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files;
    if (files) {
      const newFiles = Array.from(files).map(file => ({
        file,
        preview: URL.createObjectURL(file),
      }));
      setDocumentPreviews(prev => [...prev, ...newFiles]);
      formik.setFieldValue(
        'documentFiles',
        documentPreviews.map(doc => doc.file).concat(Array.from(files))
      );
    }
  };

  // Remove a document
  const handleRemoveDocument = (index: number) => {
    const newPreviews = [...documentPreviews];
    newPreviews.splice(index, 1);
    setDocumentPreviews(newPreviews);
    formik.setFieldValue(
      'documentFiles',
      newPreviews.map(doc => doc.file)
    );
  };

  // Remove profile photo
  const removeImage = () => {
    setImagePreview(null);
    formik.setFieldValue('profilePhotoFile', null);
  };

  return (
    <LocalizationProvider dateAdapter={AdapterDateFns}>
      <Box sx={{ p: 3, maxWidth: 1200, margin: '0 auto' }}>
        {/* Header with gradient */}
        <Paper
          elevation={0}
          sx={{
            p: 3,
            mb: 3,
            borderRadius: 3,
            background: 'linear-gradient(135deg, #1e3a5f 0%, #3b82f6 100%)',
            color: 'white',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
          }}
        >
          <Box>
            <Typography variant="h5" fontWeight={700}>Add New Teacher</Typography>
            <Typography variant="body2" sx={{ opacity: 0.85, mt: 0.5 }}>
              Fill in the details below to register a new teacher
            </Typography>
          </Box>
          {employeeId && (
            <Chip
              icon={<BadgeIcon sx={{ color: 'white !important' }} />}
              label={`ID: ${employeeId}`}
              sx={{
                bgcolor: 'rgba(255,255,255,0.2)',
                color: 'white',
                fontWeight: 600,
                fontSize: '0.9rem',
                height: 36,
                '& .MuiChip-icon': { color: 'white' },
              }}
            />
          )}
        </Paper>

        <Paper elevation={1} sx={{ p: 4, borderRadius: 3, mb: 4 }}>
          <form onSubmit={formik.handleSubmit}>
            {/* Profile Photo Section */}
            <Box sx={{ display: 'flex', justifyContent: 'center', mb: 4 }}>
              <Box sx={{ textAlign: 'center' }}>
                <Box sx={{ position: 'relative', display: 'inline-block' }}>
                  <Avatar
                    src={imagePreview || '/default-avatar.png'}
                    alt="Teacher"
                    sx={{ 
                      width: 120, 
                      height: 120, 
                      border: '2px solid',
                      borderColor: 'divider',
                      mb: 2,
                      backgroundColor: 'background.paper'
                    }}
                  />
                  {imagePreview && (
                    <IconButton
                      color="error"
                      onClick={removeImage}
                      size="small"
                      sx={{
                        position: 'absolute',
                        top: 0,
                        right: 0,
                        backgroundColor: 'background.paper',
                        '&:hover': {
                          backgroundColor: 'action.hover',
                        },
                        boxShadow: 1
                      }}
                    >
                      <DeleteIcon fontSize="small" />
                    </IconButton>
                  )}
                </Box>
                <Button
                  variant="outlined"
                  component="label"
                  startIcon={<AddPhotoIcon />}
                  size="small"
                  sx={{ mb: 1 }}
                >
                  Upload Photo
                  <input
                    type="file"
                    hidden
                    accept="image/*"
                    onChange={handleImageChange}
                  />
                </Button>
                <FormHelperText sx={{ fontSize: '0.75rem', mt: 0, color: 'text.secondary' }}>
                  Max size: 2MB (JPG, PNG)
                </FormHelperText>
              </Box>
            </Box>
            
            {/* Personal Information Section */}
            <Box sx={{ mb: 4 }}>
              <Typography variant="subtitle1" sx={{ fontWeight: 500, mb: 2, color: 'text.primary' }}>
                Personal Information
              </Typography>

              <Divider sx={{ mb: 3 }} />
              
              <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, gap: 2 }}>
                  <Box sx={{ flex: 1, minWidth: { md: 'calc(50% - 8px)' } }}>
                    <TextField
                      fullWidth
                      id="fullName"
                      name="fullName"
                      label="Full Name"
                      value={formik.values.fullName}
                      onChange={formik.handleChange}
                      onBlur={formik.handleBlur}
                      error={formik.touched.fullName && Boolean(formik.errors.fullName)}
                      helperText={formik.touched.fullName && formik.errors.fullName}
                      size="small"
                    />
                  </Box>
                  
                  <Box sx={{ flex: 1, minWidth: { md: 'calc(50% - 8px)' } }}>
                    <FormControl 
                      fullWidth 
                      size="small"
                      error={formik.touched.gender && Boolean(formik.errors.gender)}
                    >
                      <InputLabel id="gender-label">Gender</InputLabel>
                      <Select
                        labelId="gender-label"
                        id="gender"
                        name="gender"
                        value={formik.values.gender}
                        onChange={formik.handleChange}
                        onBlur={formik.handleBlur}
                        label="Gender"
                      >
                        <MenuItem value="Male">Male</MenuItem>
                        <MenuItem value="Female">Female</MenuItem>
                        <MenuItem value="Other">Other</MenuItem>
                      </Select>
                      {formik.touched.gender && formik.errors.gender && (
                        <FormHelperText>{formik.errors.gender}</FormHelperText>
                      )}
                    </FormControl>
                  </Box>
                </Box>
                
                <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, gap: 2 }}>
                  <Box sx={{ flex: 1, minWidth: { md: 'calc(50% - 8px)' } }}>
                    <DatePicker
                      label="Date of Birth"
                      value={formik.values.dateOfBirth ? new Date(formik.values.dateOfBirth) : null}
                      onChange={(date) => {
                        formik.setFieldValue('dateOfBirth', date ? date.toISOString().split('T')[0] : '');
                      }}
                      slotProps={{
                        textField: {
                          fullWidth: true,
                          size: 'small',
                          error: formik.touched.dateOfBirth && Boolean(formik.errors.dateOfBirth),
                          helperText: formik.touched.dateOfBirth && formik.errors.dateOfBirth,
                        },
                      }}
                    />
                  </Box>
                  <Box sx={{ flex: 1, minWidth: { md: 'calc(50% - 8px)' } }} />
                </Box>
                
                <Box>
                  <TextField
                    fullWidth
                    id="address"
                    name="address"
                    label="Address"
                    multiline
                    rows={3}
                    value={formik.values.address}
                    onChange={formik.handleChange}
                    onBlur={formik.handleBlur}
                    error={formik.touched.address && Boolean(formik.errors.address)}
                    helperText={formik.touched.address && formik.errors.address}
                    size="small"
                  />
                </Box>
              </Box>
            </Box>
            
            {/* Employment Details Section */}
            <Box sx={{ mb: 4 }}>
              <Typography variant="subtitle1" sx={{ fontWeight: 600, mb: 2, color: 'primary.main' }}>
                Employment Details
              </Typography>
              <Divider sx={{ mb: 3 }} />

              <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, gap: 2 }}>
                  <Box sx={{ flex: 1 }}>
                    {designations.length > 0 ? (
                      <FormControl fullWidth size="small">
                        <InputLabel>Designation</InputLabel>
                        <Select
                          name="designation"
                          value={formik.values.designation || ''}
                          onChange={formik.handleChange}
                          label="Designation"
                        >
                          {designations.map(d => (
                            <MenuItem key={d.id} value={d.name}>{d.name}</MenuItem>
                          ))}
                        </Select>
                      </FormControl>
                    ) : (
                      <TextField
                        fullWidth size="small"
                        name="designation"
                        label="Designation"
                        placeholder="e.g. Senior Teacher, HOD, Principal"
                        value={formik.values.designation || ''}
                        onChange={formik.handleChange}
                      />
                    )}
                  </Box>
                  <Box sx={{ flex: 1 }}>
                    {departments.length > 0 ? (
                      <FormControl fullWidth size="small">
                        <InputLabel>Department</InputLabel>
                        <Select
                          name="department"
                          value={formik.values.department || ''}
                          onChange={formik.handleChange}
                          label="Department"
                        >
                          {departments.map(d => (
                            <MenuItem key={d.id} value={d.name}>{d.name}</MenuItem>
                          ))}
                        </Select>
                      </FormControl>
                    ) : (
                      <TextField
                        fullWidth size="small"
                        name="department"
                        label="Department"
                        placeholder="e.g. Science, Arts, Commerce"
                        value={formik.values.department || ''}
                        onChange={formik.handleChange}
                      />
                    )}
                  </Box>
                </Box>

                <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, gap: 2 }}>
                  <Box sx={{ flex: 1 }}>
                    {employeeTypes.length > 0 ? (
                      <FormControl fullWidth size="small">
                        <InputLabel>Employee Type</InputLabel>
                        <Select
                          name="employeeType"
                          value={formik.values.employeeType || ''}
                          onChange={formik.handleChange}
                          label="Employee Type"
                        >
                          {employeeTypes.map(d => (
                            <MenuItem key={d.id} value={d.name}>{d.name}</MenuItem>
                          ))}
                        </Select>
                      </FormControl>
                    ) : (
                      <TextField
                        fullWidth size="small"
                        name="employeeType"
                        label="Employee Type"
                        placeholder="e.g. Permanent, Contractual, Part-time"
                        value={formik.values.employeeType || ''}
                        onChange={formik.handleChange}
                      />
                    )}
                  </Box>
                  <Box sx={{ flex: 1 }}>
                    <DatePicker
                      label="Joining Date"
                      value={formik.values.joiningDate ? new Date(formik.values.joiningDate) : null}
                      onChange={(date) => {
                        formik.setFieldValue('joiningDate', date ? date.toISOString().split('T')[0] : '');
                      }}
                      slotProps={{
                        textField: {
                          fullWidth: true,
                          size: 'small',
                          error: formik.touched.joiningDate && Boolean(formik.errors.joiningDate),
                          helperText: formik.touched.joiningDate && (formik.errors.joiningDate as string),
                        },
                      }}
                    />
                  </Box>
                </Box>
              </Box>
            </Box>

            {/* Contact Information Section */}
            <Box sx={{ mb: 4 }}>
              <Typography variant="subtitle1" sx={{ fontWeight: 500, mb: 2, color: 'text.primary' }}>
                Contact Information
              </Typography>
              <Divider sx={{ mb: 3 }} />
              
              <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, gap: 2 }}>
                  <Box sx={{ flex: 1, minWidth: { md: 'calc(50% - 8px)' } }}>
                    <TextField
                      fullWidth
                      id="email"
                      name="email"
                      label="Email Address"
                      type="email"
                      value={formik.values.email}
                      onChange={formik.handleChange}
                      onBlur={formik.handleBlur}
                      error={formik.touched.email && Boolean(formik.errors.email)}
                      helperText={formik.touched.email && formik.errors.email}
                      size="small"
                    />
                  </Box>
                  
                  <Box sx={{ flex: 1, minWidth: { md: 'calc(50% - 8px)' } }}>
                    <TextField
                      fullWidth
                      id="phone"
                      name="phone"
                      label="Phone Number"
                      type="tel"
                      value={formik.values.phone}
                      onChange={formik.handleChange}
                      onBlur={formik.handleBlur}
                      error={formik.touched.phone && Boolean(formik.errors.phone)}
                      helperText={formik.touched.phone && formik.errors.phone}
                      size="small"
                    />
                  </Box>
                </Box>
                
                <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, gap: 2 }}>
                  <Box sx={{ flex: 1, minWidth: { md: 'calc(50% - 8px)' } }}>
                    <TextField
                      fullWidth
                      id="alternatePhone"
                      name="alternatePhone"
                      label="Alternate Phone (Optional)"
                      type="tel"
                      value={formik.values.alternatePhone}
                      onChange={formik.handleChange}
                      onBlur={formik.handleBlur}
                      error={formik.touched.alternatePhone && Boolean(formik.errors.alternatePhone)}
                      helperText={formik.touched.alternatePhone && formik.errors.alternatePhone}
                      size="small"
                    />
                  </Box>
                  <Box sx={{ flex: 1, minWidth: { md: 'calc(50% - 8px)' } }} />
                </Box>
              </Box>
            </Box>
            
            {/* Academic Information Section */}
            <Box sx={{ mb: 4 }}>
              <Typography variant="subtitle1" sx={{ fontWeight: 500, mb: 2, color: 'text.primary' }}>
                Academic Information
              </Typography>
              <Divider sx={{ mb: 3 }} />
              
              <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
                <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, gap: 2 }}>
                  <Box sx={{ flex: 1, minWidth: { md: 'calc(50% - 8px)' } }}>
                    <FormControl fullWidth size="small" error={formik.touched.qualification && Boolean(formik.errors.qualification)}>
                      <InputLabel id="qualification-label">Highest Qualification</InputLabel>
                      <Select
                        labelId="qualification-label"
                        id="qualification"
                        name="qualification"
                        value={formik.values.qualification}
                        onChange={formik.handleChange}
                        onBlur={formik.handleBlur}
                        label="Highest Qualification"
                      >
                        {qualifications.map((qual) => (
                          <MenuItem key={qual} value={qual}>
                            {qual}
                          </MenuItem>
                        ))}
                      </Select>
                      {formik.touched.qualification && formik.errors.qualification && (
                        <FormHelperText>{formik.errors.qualification}</FormHelperText>
                      )}
                    </FormControl>
                  </Box>
                  
                  <Box sx={{ flex: 1, minWidth: { md: 'calc(50% - 8px)' } }}>
                    <TextField
                      fullWidth
                      id="experience"
                      name="experience"
                      label="Experience (Years)"
                      type="number"
                      value={formik.values.experience}
                      onChange={formik.handleChange}
                      onBlur={formik.handleBlur}
                      error={formik.touched.experience && Boolean(formik.errors.experience)}
                      helperText={formik.touched.experience && formik.errors.experience}
                      size="small"
                      InputProps={{
                        inputProps: { min: 0, max: 50 },
                      }}
                    />
                  </Box>
                </Box>
                
                <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, gap: 2 }}>
                  <Box sx={{ flex: 1, minWidth: { md: 'calc(50% - 8px)' } }}>
                    <FormControl fullWidth size="small" error={formik.touched.specialization && Boolean(formik.errors.specialization)}>
                      <InputLabel id="specialization-label">Subjects / Specialization</InputLabel>
                      <Select
                        labelId="specialization-label"
                        id="specialization"
                        name="specialization"
                        multiple
                        value={formik.values.specialization}
                        onChange={(e) => {
                          const value = e.target.value;
                          formik.setFieldValue(
                            'specialization',
                            typeof value === 'string' ? value.split(',') : value
                          );
                        }}
                        onBlur={formik.handleBlur}
                        label="Subjects / Specialization"
                        renderValue={(selected) => (
                          <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
                            {(selected as string[]).map((value) => (
                              <Chip key={value} label={value} size="small" />
                            ))}
                          </Box>
                        )}
                      >
                        {subjects.map((subject) => (
                          <MenuItem key={subject} value={subject}>
                            {subject}
                          </MenuItem>
                        ))}
                      </Select>
                      {formik.touched.specialization && formik.errors.specialization && (
                        <FormHelperText>{formik.errors.specialization}</FormHelperText>
                      )}
                    </FormControl>
                  </Box>
                </Box>
                
                <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1, mb: 2 }}>
                  <FormControlLabel
                    control={
                      <Checkbox
                        checked={formik.values.isClassTeacher}
                        onChange={formik.handleChange}
                        name="isClassTeacher"
                        color="primary"
                      />
                    }
                    label="Is Class Teacher?"
                  />
                  <FormControlLabel
                    control={
                      <Checkbox
                        checked={formik.values.transportAssigned}
                        onChange={formik.handleChange}
                        name="transportAssigned"
                        color="primary"
                      />
                    }
                    label="Transport Assigned"
                  />
                  <FormControlLabel
                    control={
                      <Checkbox
                        checked={formik.values.hostelAssigned}
                        onChange={formik.handleChange}
                        name="hostelAssigned"
                        color="primary"
                      />
                    }
                    label="Hostel Assigned"
                  />
                </Box>
              </Box>
            </Box>
            
            {/* Documents Section */}
            <Box sx={{ mb: 4 }}>
              <Typography variant="subtitle1" sx={{ fontWeight: 500, mb: 2, color: 'text.primary' }}>
                Documents
              </Typography>
              <Divider sx={{ mb: 3 }} />
              
              <Box sx={{ mb: 2 }}>
                <Button
                  variant="outlined"
                  component="label"
                  startIcon={<AddIcon />}
                  size="small"
                >
                  Upload Documents
                  <input
                    type="file"
                    hidden
                    multiple
                    onChange={handleDocumentUpload}
                    accept=".pdf,.doc,.docx,image/*"
                  />
                </Button>
                <Typography variant="caption" display="block" sx={{ mt: 1, color: 'text.secondary' }}>
                  Upload resume, certificates, or other documents (PDF, DOC, JPG, PNG)
                </Typography>
              </Box>
              
              {documentPreviews.length > 0 && (
                <Box sx={{ mt: 2 }}>
                  <Typography variant="body2" sx={{ mb: 1, fontWeight: 500 }}>
                    Selected Documents:
                  </Typography>
                  <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1 }}>
                    {documentPreviews.map((doc, index) => (
                      <Chip
                        key={index}
                        label={doc.file.name}
                        onDelete={() => handleRemoveDocument(index)}
                        variant="outlined"
                        size="small"
                      />
                    ))}
                  </Box>
                </Box>
              )}
            </Box>
            
            {/* Account Information Section */}
            <Box sx={{ mb: 4 }}>
              <Typography variant="subtitle1" sx={{ fontWeight: 500, mb: 2, color: 'text.primary' }}>
                Account Information
              </Typography>
              <Divider sx={{ mb: 3 }} />
              
              <Box sx={{ display: 'flex', flexDirection: { xs: 'column', md: 'row' }, gap: 2 }}>
                <Box sx={{ flex: 1, minWidth: { md: 'calc(50% - 8px)' } }}>
                  <TextField
                    fullWidth
                    id="password"
                    name="password"
                    label="Password"
                    type="password"
                    value={formik.values.password}
                    onChange={formik.handleChange}
                    onBlur={formik.handleBlur}
                    error={formik.touched.password && Boolean(formik.errors.password)}
                    helperText={formik.touched.password && formik.errors.password}
                    size="small"
                  />
                </Box>
                
                <Box sx={{ flex: 1, minWidth: { md: 'calc(50% - 8px)' } }}>
                  <TextField
                    fullWidth
                    id="confirmPassword"
                    name="confirmPassword"
                    label="Confirm Password"
                    type="password"
                    value={formik.values.confirmPassword}
                    onChange={formik.handleChange}
                    onBlur={formik.handleBlur}
                    error={formik.touched.confirmPassword && Boolean(formik.errors.confirmPassword)}
                    helperText={formik.touched.confirmPassword && formik.errors.confirmPassword}
                    size="small"
                  />
                </Box>
              </Box>
            </Box>
            
            {/* Form Actions */}
            <Box sx={{ mt: 4, display: 'flex', justifyContent: 'flex-end', gap: 2 }}>
              <Button
                variant="outlined"
                color="error"
                startIcon={<CancelIcon />}
                onClick={() => navigate('/dashboard/teachers')}
                disabled={isSubmitting}
              >
                Cancel
              </Button>
              <Button
                type="submit"
                variant="contained"
                color="primary"
                startIcon={isSubmitting ? <CircularProgress size={20} color="inherit" /> : <SaveIcon />}
                disabled={isSubmitting}
              >
                {isSubmitting ? 'Saving...' : 'Save Teacher'}
              </Button>
            </Box>
          </form>
        </Paper>
      </Box>
      <Snackbar
        open={snackbar.open}
        autoHideDuration={4000}
        onClose={() => setSnackbar(prev => ({ ...prev, open: false }))}
        anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
      >
        <Alert onClose={() => setSnackbar(prev => ({ ...prev, open: false }))} severity={snackbar.severity} sx={{ width: '100%' }}>
          {snackbar.message}
        </Alert>
      </Snackbar>
    </LocalizationProvider>
  );
};

export default AddTeacherForm;
