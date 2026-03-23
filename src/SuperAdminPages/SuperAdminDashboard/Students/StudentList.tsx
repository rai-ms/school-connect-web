import React, { useState, useEffect } from 'react';
import {
  Box,
  Button,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TablePagination,
  TextField,
  InputAdornment,
  IconButton,
  Chip,
  Tooltip,
  Menu,
  MenuItem,
  Typography,
  Avatar,
  Badge,
  FormControl,
  InputLabel,
  Select,
  CircularProgress,
} from '@mui/material';
import {
  Search as SearchIcon,
  MoreVert as MoreVertIcon,
  Edit as EditIcon,
  Visibility as VisibilityIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
  FileDownload as ExportIcon,
} from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { STUDENT_ENDPOINTS } from '../../../config/api.config';

interface Student {
  id: string;
  name: string;
  rollNo: number | string;
  class: string;
  section: string;
  gender: string;
  parentContact: string;
  status: string;
  admissionDate: string;
  avatar: string;
}

const StudentList: React.FC = () => {
  const navigate = useNavigate();
  const [students, setStudents] = useState<Student[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [totalElements, setTotalElements] = useState(0);
  const [searchTerm, setSearchTerm] = useState('');
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const [selectedStudent, setSelectedStudent] = useState<string | null>(null);
  const [filters, setFilters] = useState({
    class: '',
    section: '',
    gender: '',
    status: '',
  });

  const getAuthHeaders = () => {
    const token = localStorage.getItem('authToken');
    return token ? { Authorization: `Bearer ${token}` } : {};
  };

  const fetchStudents = async () => {
    try {
      setLoading(true);
      const response = await axios.get(STUDENT_ENDPOINTS.STUDENTS, {
        headers: getAuthHeaders(),
        params: {
          page: page,
          size: rowsPerPage,
          ...(searchTerm ? { search: searchTerm } : {}),
          ...(filters.status ? { status: filters.status } : {}),
          ...(filters.class ? { className: filters.class } : {}),
          ...(filters.gender ? { gender: filters.gender } : {}),
        },
      });

      const data = response.data?.data || response.data || {};
      const content = data.content || data.students || data || [];
      const studentsArray = Array.isArray(content) ? content : [];

      const mappedStudents: Student[] = studentsArray.map((s: any) => ({
        id: s.id?.toString() || s.studentId || '',
        name: s.fullName || s.name || `${s.firstName || ''} ${s.lastName || ''}`.trim(),
        rollNo: s.rollNo || s.rollNumber || s.admissionNumber || '',
        class: s.className || s.class || s.grade || '',
        section: s.section || s.sectionName || '',
        gender: s.gender || '',
        parentContact: s.parentContact || s.parentPhone || s.guardianPhone || s.phone || '',
        status: s.status === 'ACTIVE' || s.status === 'Active' ? 'Active' : 'Inactive',
        admissionDate: s.admissionDate || s.createdAt || '',
        avatar: s.profilePhoto || s.avatar || '',
      }));

      setStudents(mappedStudents);
      setTotalElements(data.totalElements ?? data.total ?? mappedStudents.length);
    } catch (error) {
      console.error('Error fetching students:', error);
      setStudents([]);
      setTotalElements(0);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchStudents();
  }, [page, rowsPerPage, searchTerm, filters]);

  const handleChangePage = (_: unknown, newPage: number) => setPage(newPage);

  const handleChangeRowsPerPage = (event: React.ChangeEvent<HTMLInputElement>) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const handleSearch = (event: React.ChangeEvent<HTMLInputElement>) => {
    setSearchTerm(event.target.value);
    setPage(0);
  };

  const handleFilterChange = (filter: string, value: string) => {
    setFilters(prev => ({ ...prev, [filter]: value }));
    setPage(0);
  };

  const handleMenuOpen = (event: React.MouseEvent<HTMLElement>, studentId: string) => {
    setAnchorEl(event.currentTarget);
    setSelectedStudent(studentId);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
    setSelectedStudent(null);
  };

  const handleView = (id: string) => {
    navigate(`/dashboard/students/${id}`);
    handleMenuClose();
  };

  const handleEdit = (id: string) => {
    navigate(`/dashboard/students/${id}/edit`);
    handleMenuClose();
  };

  const handleDelete = async (id: string) => {
    if (!window.confirm('Are you sure you want to delete this student?')) {
      handleMenuClose();
      return;
    }
    try {
      await axios.delete(STUDENT_ENDPOINTS.STUDENT_BY_ID(id), {
        headers: getAuthHeaders(),
      });
      fetchStudents();
    } catch (error) {
      console.error('Error deleting student:', error);
      alert('Failed to delete student. Please try again.');
    }
    handleMenuClose();
  };

  const uniqueClasses = [...new Set(students.map(s => s.class).filter(Boolean))];
  const uniqueSections = [...new Set(students.map(s => s.section).filter(Boolean))];
  const uniqueGenders = [...new Set(students.map(s => s.gender).filter(Boolean))];
  const statuses = ['Active', 'Inactive'];

  return (
    <Box sx={{ width: '100%', p: 3 }}>
      {/* Header */}
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3, flexWrap: 'wrap', gap: 2 }}>
        <Typography variant="h5">
          Students
          <Chip
            label={`${totalElements} ${totalElements === 1 ? 'Student' : 'Students'}`}
            color="primary"
            size="small"
            sx={{ ml: 2, fontWeight: 'bold' }}
          />
        </Typography>
        <Box sx={{ display: 'flex', gap: 2 }}>
          <Button variant="outlined" startIcon={<ExportIcon />} onClick={() => console.log('Export CSV')}>
            Export
          </Button>
          <Button variant="contained" startIcon={<AddIcon />} onClick={() => navigate('/dashboard/students/add')}>
            Add Student
          </Button>
        </Box>
      </Box>

      {/* Search & Filters */}
      <Paper sx={{ p: 2, mb: 3 }}>
        <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 2 }}>
          <TextField
            placeholder="Search by name, ID, or class..."
            size="small"
            value={searchTerm}
            onChange={handleSearch}
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <SearchIcon />
                </InputAdornment>
              ),
            }}
            sx={{ flex: 1, minWidth: 250 }}
          />

          {[
            { label: 'Class', key: 'class', options: uniqueClasses, placeholder: 'All Classes' },
            { label: 'Section', key: 'section', options: uniqueSections, placeholder: 'All Sections' },
            { label: 'Gender', key: 'gender', options: uniqueGenders, placeholder: 'All Genders' },
            { label: 'Status', key: 'status', options: statuses, placeholder: 'All Status' },
          ].map(({ label, key, options, placeholder }) => (
            <FormControl key={key} size="small" sx={{ minWidth: 140 }}>
              <InputLabel shrink>{label}</InputLabel>
              <Select
                value={filters[key as keyof typeof filters]}
                onChange={(e) => handleFilterChange(key, e.target.value)}
                displayEmpty
                renderValue={(selected) => selected || placeholder}
              >
                <MenuItem value="">{placeholder}</MenuItem>
                {options.map(opt => (
                  <MenuItem key={opt} value={opt}>{opt}</MenuItem>
                ))}
              </Select>
            </FormControl>
          ))}
        </Box>
      </Paper>

      {/* Student Table */}
      <Paper sx={{ width: '100%', overflow: 'hidden' }}>
        <TableContainer sx={{ maxHeight: 'calc(100vh - 300px)' }}>
          <Table stickyHeader>
            <TableHead>
              <TableRow>
                <TableCell>Student</TableCell>
                <TableCell>ID / Roll No.</TableCell>
                <TableCell>Class / Section</TableCell>
                <TableCell>Gender</TableCell>
                <TableCell>Parent Contact</TableCell>
                <TableCell>Status</TableCell>
                <TableCell align="right">Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {loading ? (
                <TableRow>
                  <TableCell colSpan={7} align="center" sx={{ py: 4 }}>
                    <CircularProgress />
                    <Typography variant="body2" sx={{ mt: 1 }}>Loading students...</Typography>
                  </TableCell>
                </TableRow>
              ) : students.length > 0 ? students.map(student => (
                <TableRow hover key={student.id}>
                  <TableCell>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
                      <Badge
                        overlap="circular"
                        anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
                        variant="dot"
                        color={student.status === 'Active' ? 'success' : 'error'}
                      >
                        <Avatar src={student.avatar} sx={{ width: 36, height: 36 }} />
                      </Badge>
                      <Box>
                        <Typography variant="body2">{student.name}</Typography>
                        <Typography variant="caption" color="text.secondary">
                          {student.admissionDate ? new Date(student.admissionDate).toLocaleDateString() : ''}
                        </Typography>
                      </Box>
                    </Box>
                  </TableCell>
                  <TableCell>
                    <Typography variant="body2">{student.id}</Typography>
                    <Typography variant="caption" color="text.secondary">Roll: {student.rollNo}</Typography>
                  </TableCell>
                  <TableCell>
                    <Typography variant="body2">Class {student.class}</Typography>
                    <Typography variant="caption" color="text.secondary">Section {student.section}</Typography>
                  </TableCell>
                  <TableCell>{student.gender}</TableCell>
                  <TableCell>{student.parentContact}</TableCell>
                  <TableCell>
                    <Chip
                      label={student.status}
                      size="small"
                      color={student.status === 'Active' ? 'success' : 'default'}
                      variant="outlined"
                    />
                  </TableCell>
                  <TableCell align="right">
                    <Tooltip title="Actions">
                      <IconButton size="small" onClick={(e) => handleMenuOpen(e, student.id)}>
                        <MoreVertIcon />
                      </IconButton>
                    </Tooltip>
                  </TableCell>
                </TableRow>
              )) : (
                <TableRow>
                  <TableCell colSpan={7} align="center" sx={{ py: 4 }}>
                    <Typography color="textSecondary">No students found</Typography>
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </TableContainer>
        <TablePagination
          rowsPerPageOptions={[5, 10, 25]}
          component="div"
          count={totalElements}
          rowsPerPage={rowsPerPage}
          page={page}
          onPageChange={handleChangePage}
          onRowsPerPageChange={handleChangeRowsPerPage}
        />
      </Paper>

      {/* Action Menu */}
      <Menu
        anchorEl={anchorEl}
        open={Boolean(anchorEl)}
        onClose={handleMenuClose}
        anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
        transformOrigin={{ vertical: 'top', horizontal: 'right' }}
        PaperProps={{ style: { minWidth: 180 } }}
      >
        <MenuItem onClick={() => selectedStudent && handleView(selectedStudent)}>
          <VisibilityIcon fontSize="small" sx={{ mr: 1 }} />
          View Details
        </MenuItem>
        <MenuItem onClick={() => selectedStudent && handleEdit(selectedStudent)}>
          <EditIcon fontSize="small" sx={{ mr: 1 }} />
          Edit
        </MenuItem>
        <MenuItem onClick={() => selectedStudent && handleDelete(selectedStudent)} sx={{ color: 'error.main' }}>
          <DeleteIcon fontSize="small" sx={{ mr: 1 }} />
          Delete
        </MenuItem>
      </Menu>
    </Box>
  );
};

export default StudentList;
