import React, { useState, useEffect, useCallback } from 'react';
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
  Typography,
  CircularProgress,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogContentText,
  DialogActions,
  Snackbar,
  Alert,
} from '@mui/material';
import {
  Search as SearchIcon,
  Edit as EditIcon,
  Visibility as VisibilityIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
  EventNote as EventNoteIcon,
} from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';
import apiService from '../../../../service/apiService';

interface Exam {
  id: string;
  name: string;
  title?: string;
  examType: string;
  className: string;
  startDate: string;
  endDate: string;
  status: string;
  totalMarks: number;
  passingMarks: number;
  createdAt: string;
}

interface ExamsResponse {
  content: Exam[];
  totalElements: number;
  totalPages: number;
}

type SnackbarSeverity = 'success' | 'error';

export const ExamListPage: React.FC = () => {
  const navigate = useNavigate();

  const [exams, setExams] = useState<Exam[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(20);
  const [totalElements, setTotalElements] = useState(0);
  const [searchTerm, setSearchTerm] = useState('');

  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [examToDelete, setExamToDelete] = useState<Exam | null>(null);
  const [deleting, setDeleting] = useState(false);

  const [snackbar, setSnackbar] = useState<{
    open: boolean;
    message: string;
    severity: SnackbarSeverity;
  }>({ open: false, message: '', severity: 'success' });

  const fetchExams = useCallback(async () => {
    try {
      setLoading(true);
      const response = await apiService.get<ExamsResponse>('/exams', {
        params: {
          page,
          size: rowsPerPage,
          ...(searchTerm ? { search: searchTerm } : {}),
        },
      });
      const data = response?.data ?? response;
      setExams(data.content ?? []);
      setTotalElements(data.totalElements ?? 0);
    } catch (err: any) {
      const message = err?.message || 'Failed to fetch exams';
      setSnackbar({ open: true, message, severity: 'error' });
      setExams([]);
      setTotalElements(0);
    } finally {
      setLoading(false);
    }
  }, [page, rowsPerPage, searchTerm]);

  useEffect(() => {
    fetchExams();
  }, [fetchExams]);

  const handlePageChange = (_: unknown, newPage: number) => {
    setPage(newPage);
  };

  const handleRowsPerPageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setRowsPerPage(parseInt(e.target.value, 10));
    setPage(0);
  };

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearchTerm(e.target.value);
    setPage(0);
  };

  const openDeleteDialog = (exam: Exam) => {
    setExamToDelete(exam);
    setDeleteDialogOpen(true);
  };

  const closeDeleteDialog = () => {
    setDeleteDialogOpen(false);
    setExamToDelete(null);
  };

  const handleDelete = async () => {
    if (!examToDelete) return;
    try {
      setDeleting(true);
      await apiService.delete(`/exams/${examToDelete.id}`);
      setSnackbar({
        open: true,
        message: 'Exam deleted successfully',
        severity: 'success',
      });
      closeDeleteDialog();
      fetchExams();
    } catch (err: any) {
      const message = err?.message || 'Failed to delete exam';
      setSnackbar({ open: true, message, severity: 'error' });
    } finally {
      setDeleting(false);
    }
  };

  const getStatusChip = (status: string) => {
    const normalized = status?.toLowerCase() ?? '';
    let color: 'success' | 'warning' | 'info' | 'default' = 'default';
    if (normalized === 'completed') color = 'success';
    else if (normalized === 'ongoing') color = 'warning';
    else if (normalized === 'upcoming') color = 'info';

    return (
      <Chip
        label={status}
        color={color}
        size="small"
        sx={{ textTransform: 'capitalize' }}
      />
    );
  };

  const formatDate = (dateStr: string) => {
    if (!dateStr) return '-';
    try {
      return new Date(dateStr).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
      });
    } catch {
      return dateStr;
    }
  };

  const getExamName = (exam: Exam) => exam.name || exam.title || '-';

  return (
    <Box sx={{ p: 3 }}>
      {/* Header */}
      <Box
        sx={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          mb: 3,
        }}
      >
        <Typography variant="h5" fontWeight={600}>
          Exam Management
        </Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => navigate('/dashboard/exams/schedule')}
        >
          Schedule New Exam
        </Button>
      </Box>

      <Paper sx={{ width: '100%', overflow: 'hidden' }}>
        {/* Search */}
        <Box sx={{ p: 2 }}>
          <TextField
            size="small"
            placeholder="Search exams..."
            value={searchTerm}
            onChange={handleSearchChange}
            sx={{ minWidth: 300 }}
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <SearchIcon color="action" />
                </InputAdornment>
              ),
            }}
          />
        </Box>

        {/* Loading */}
        {loading ? (
          <Box
            sx={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              py: 8,
            }}
          >
            <CircularProgress />
          </Box>
        ) : exams.length === 0 ? (
          /* Empty state */
          <Box
            sx={{
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'center',
              py: 8,
            }}
          >
            <EventNoteIcon sx={{ fontSize: 64, color: 'text.disabled', mb: 2 }} />
            <Typography variant="h6" color="text.secondary">
              No exams found. Schedule an exam to get started.
            </Typography>
            <Button
              variant="outlined"
              startIcon={<AddIcon />}
              sx={{ mt: 2 }}
              onClick={() => navigate('/dashboard/exams/schedule')}
            >
              Schedule Exam
            </Button>
          </Box>
        ) : (
          /* Table */
          <>
            <TableContainer>
              <Table stickyHeader>
                <TableHead>
                  <TableRow>
                    <TableCell>Exam Name</TableCell>
                    <TableCell>Type</TableCell>
                    <TableCell>Class</TableCell>
                    <TableCell>Start Date</TableCell>
                    <TableCell>End Date</TableCell>
                    <TableCell align="center">Total Marks</TableCell>
                    <TableCell>Status</TableCell>
                    <TableCell align="center">Actions</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {exams.map((exam) => (
                    <TableRow key={exam.id} hover>
                      <TableCell>
                        <Typography variant="body2" fontWeight={500}>
                          {getExamName(exam)}
                        </Typography>
                      </TableCell>
                      <TableCell>{exam.examType || '-'}</TableCell>
                      <TableCell>{exam.className || '-'}</TableCell>
                      <TableCell>{formatDate(exam.startDate)}</TableCell>
                      <TableCell>{formatDate(exam.endDate)}</TableCell>
                      <TableCell align="center">{exam.totalMarks ?? '-'}</TableCell>
                      <TableCell>{getStatusChip(exam.status)}</TableCell>
                      <TableCell align="center">
                        <Tooltip title="View">
                          <IconButton
                            size="small"
                            color="info"
                            onClick={() => navigate(`/dashboard/exams/${exam.id}`)}
                          >
                            <VisibilityIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Edit">
                          <IconButton
                            size="small"
                            color="primary"
                            onClick={() =>
                              navigate(`/dashboard/exams/${exam.id}/edit`)
                            }
                          >
                            <EditIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Delete">
                          <IconButton
                            size="small"
                            color="error"
                            onClick={() => openDeleteDialog(exam)}
                          >
                            <DeleteIcon fontSize="small" />
                          </IconButton>
                        </Tooltip>
                      </TableCell>
                    </TableRow>
                  ))}
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
          </>
        )}
      </Paper>

      {/* Delete confirmation dialog */}
      <Dialog open={deleteDialogOpen} onClose={closeDeleteDialog}>
        <DialogTitle>Delete Exam</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Are you sure you want to delete{' '}
            <strong>{examToDelete ? getExamName(examToDelete) : ''}</strong>? This
            action cannot be undone.
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={closeDeleteDialog} disabled={deleting}>
            Cancel
          </Button>
          <Button
            onClick={handleDelete}
            color="error"
            variant="contained"
            disabled={deleting}
            startIcon={deleting ? <CircularProgress size={16} /> : undefined}
          >
            {deleting ? 'Deleting...' : 'Delete'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* Snackbar */}
      <Snackbar
        open={snackbar.open}
        autoHideDuration={4000}
        onClose={() => setSnackbar((s) => ({ ...s, open: false }))}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
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
    </Box>
  );
};

export default ExamListPage;
