import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Box,
  Container,
  Typography,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Chip,
  IconButton,
  Tooltip,
  CircularProgress,
  Snackbar,
  Alert,
  TablePagination,
  TextField,
  MenuItem,
  Button,
  Stack,
} from '@mui/material';
import {
  Visibility as ViewIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
  FilterList as FilterIcon,
} from '@mui/icons-material';
import { format } from 'date-fns';
import { apiService } from '../../../../service/apiService';
import DeleteConfirmationModal from '../components/DeleteConfirmationModal';

interface AttendanceRecord {
  id: string;
  studentId: string;
  studentName: string;
  classId: string;
  className: string;
  sectionName: string;
  date: string;
  status: 'PRESENT' | 'ABSENT' | 'LATE';
  remarks: string;
  markedBy: string;
  createdAt: string;
}

interface ClassOption {
  id: string;
  className: string;
}

interface PaginatedResponse {
  content: AttendanceRecord[];
  totalElements: number;
  totalPages: number;
}

const statusConfig: Record<string, { color: 'success' | 'error' | 'warning'; label: string }> = {
  PRESENT: { color: 'success', label: 'Present' },
  ABSENT: { color: 'error', label: 'Absent' },
  LATE: { color: 'warning', label: 'Late' },
};

const AttendanceListPage: React.FC = () => {
  const navigate = useNavigate();

  const [records, setRecords] = useState<AttendanceRecord[]>([]);
  const [loading, setLoading] = useState(true);
  const [totalElements, setTotalElements] = useState(0);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(20);

  const [classes, setClasses] = useState<ClassOption[]>([]);
  const [selectedClassId, setSelectedClassId] = useState('');
  const [selectedDate, setSelectedDate] = useState('');

  const [deleteId, setDeleteId] = useState<string | null>(null);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [snackbar, setSnackbar] = useState({
    open: false,
    message: '',
    severity: 'success' as 'success' | 'error',
  });

  // Fetch class options for the dropdown
  useEffect(() => {
    const fetchClasses = async () => {
      try {
        const response = await apiService.get('/classes');
        const data = response?.data || response || {};
        setClasses(data.content || data || []);
      } catch {
        // Silently fail; the dropdown will just be empty
      }
    };
    fetchClasses();
  }, []);

  // Fetch attendance records
  const fetchRecords = useCallback(async () => {
    setLoading(true);
    try {
      if (selectedClassId && selectedDate) {
        // Filter by class and date
        const response = await apiService.get(
          `/attendance/class/${selectedClassId}`,
          { params: { date: selectedDate } }
        );
        const data = response?.data || response || [];
        const list = Array.isArray(data) ? data : data.content || [];
        setRecords(list);
        setTotalElements(list.length);
      } else {
        // Paginated list
        const response = await apiService.get('/attendance', {
          params: { page, size: rowsPerPage },
        });
        const payload = response?.data || response || {};
        setRecords(payload?.content ?? []);
        setTotalElements(payload?.totalElements ?? 0);
      }
    } catch {
      setSnackbar({
        open: true,
        message: 'Failed to load attendance records.',
        severity: 'error',
      });
      setRecords([]);
      setTotalElements(0);
    } finally {
      setLoading(false);
    }
  }, [page, rowsPerPage, selectedClassId, selectedDate]);

  useEffect(() => {
    fetchRecords();
  }, [fetchRecords]);

  // Handlers
  const handlePageChange = (_: unknown, newPage: number) => {
    setPage(newPage);
  };

  const handleRowsPerPageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setRowsPerPage(parseInt(e.target.value, 10));
    setPage(0);
  };

  const handleDeleteClick = (id: string) => {
    setDeleteId(id);
    setShowDeleteModal(true);
  };

  const handleDeleteConfirm = async () => {
    if (!deleteId) return;
    try {
      await apiService.delete(`/attendance/${deleteId}`);
      setSnackbar({
        open: true,
        message: 'Attendance record deleted successfully.',
        severity: 'success',
      });
      setShowDeleteModal(false);
      setDeleteId(null);
      fetchRecords();
    } catch {
      setSnackbar({
        open: true,
        message: 'Failed to delete the attendance record.',
        severity: 'error',
      });
    }
  };

  const handleClearFilters = () => {
    setSelectedClassId('');
    setSelectedDate('');
    setPage(0);
  };

  return (
    <Container maxWidth="xl" sx={{ mt: 4, mb: 4 }}>
      {/* Header */}
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4" fontWeight={600}>
          Attendance Management
        </Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => navigate('/dashboard/attendance/mark')}
        >
          Mark Attendance
        </Button>
      </Box>

      {/* Filters */}
      <Paper sx={{ p: 2, mb: 3 }}>
        <Stack direction={{ xs: 'column', sm: 'row' }} spacing={2} alignItems="center">
          <FilterIcon color="action" />
          <TextField
            select
            label="Class"
            size="small"
            value={selectedClassId}
            onChange={(e) => {
              setSelectedClassId(e.target.value);
              setPage(0);
            }}
            sx={{ minWidth: 200 }}
          >
            <MenuItem value="">All Classes</MenuItem>
            {classes.map((cls) => (
              <MenuItem key={cls.id} value={cls.id}>
                {cls.className}
              </MenuItem>
            ))}
          </TextField>

          <TextField
            type="date"
            label="Date"
            size="small"
            InputLabelProps={{ shrink: true }}
            value={selectedDate}
            onChange={(e) => {
              setSelectedDate(e.target.value);
              setPage(0);
            }}
            sx={{ minWidth: 180 }}
          />

          {(selectedClassId || selectedDate) && (
            <Button variant="outlined" size="small" onClick={handleClearFilters}>
              Clear Filters
            </Button>
          )}
        </Stack>
      </Paper>

      {/* Content */}
      {loading ? (
        <Box display="flex" justifyContent="center" alignItems="center" minHeight={300}>
          <CircularProgress />
        </Box>
      ) : records.length === 0 ? (
        <Paper sx={{ p: 6, textAlign: 'center' }}>
          <Typography variant="h6" color="text.secondary" gutterBottom>
            No attendance records found.
          </Typography>
          <Typography variant="body2" color="text.secondary" mb={3}>
            Mark attendance to get started.
          </Typography>
          <Button
            variant="contained"
            startIcon={<AddIcon />}
            onClick={() => navigate('/dashboard/attendance/mark')}
          >
            Mark Attendance
          </Button>
        </Paper>
      ) : (
        <Paper>
          <TableContainer>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell sx={{ fontWeight: 600 }}>Student</TableCell>
                  <TableCell sx={{ fontWeight: 600 }}>Class / Section</TableCell>
                  <TableCell sx={{ fontWeight: 600 }}>Date</TableCell>
                  <TableCell sx={{ fontWeight: 600 }}>Status</TableCell>
                  <TableCell sx={{ fontWeight: 600 }}>Remarks</TableCell>
                  <TableCell sx={{ fontWeight: 600 }} align="right">
                    Actions
                  </TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {records.map((record) => {
                  const status = statusConfig[record.status] ?? {
                    color: 'default' as const,
                    label: record.status,
                  };
                  return (
                    <TableRow key={record.id} hover>
                      <TableCell>{record.studentName}</TableCell>
                      <TableCell>
                        {record.className} / {record.sectionName}
                      </TableCell>
                      <TableCell>
                        {record.date
                          ? format(new Date(record.date), 'dd MMM yyyy')
                          : '-'}
                      </TableCell>
                      <TableCell>
                        <Chip
                          label={status.label}
                          color={status.color}
                          size="small"
                          variant="outlined"
                        />
                      </TableCell>
                      <TableCell>{record.remarks || '-'}</TableCell>
                      <TableCell align="right">
                        <Tooltip title="View">
                          <IconButton
                            size="small"
                            onClick={() => navigate(`/dashboard/attendance/view/${record.id}`)}
                          >
                            <ViewIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Edit">
                          <IconButton
                            size="small"
                            onClick={() => navigate(`/dashboard/attendance/edit/${record.id}`)}
                          >
                            <EditIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Delete">
                          <IconButton
                            size="small"
                            color="error"
                            onClick={() => handleDeleteClick(record.id)}
                          >
                            <DeleteIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                      </TableCell>
                    </TableRow>
                  );
                })}
              </TableBody>
            </Table>
          </TableContainer>

          <TablePagination
            component="div"
            count={totalElements}
            page={page}
            onPageChange={handlePageChange}
            rowsPerPage={rowsPerPage}
            onRowsPerPageChange={handleRowsPerPageChange}
            rowsPerPageOptions={[10, 20, 50]}
          />
        </Paper>
      )}

      {/* Delete confirmation */}
      <DeleteConfirmationModal
        open={showDeleteModal}
        onClose={() => setShowDeleteModal(false)}
        onConfirm={handleDeleteConfirm}
        title="Delete Attendance Record"
        description="Are you sure you want to delete this attendance record? This action cannot be undone."
        confirmText="Delete Record"
      />

      {/* Snackbar */}
      <Snackbar
        open={snackbar.open}
        autoHideDuration={6000}
        onClose={() => setSnackbar((s) => ({ ...s, open: false }))}
        anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
      >
        <Alert
          onClose={() => setSnackbar((s) => ({ ...s, open: false }))}
          severity={snackbar.severity}
          variant="filled"
          sx={{ width: '100%' }}
        >
          {snackbar.message}
        </Alert>
      </Snackbar>
    </Container>
  );
};

export default AttendanceListPage;
