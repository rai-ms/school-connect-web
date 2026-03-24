import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Box, Button, Table, TableBody, TableCell, TableContainer, TableHead, TableRow,
  Paper, IconButton, TextField, FormControl, InputLabel, Select, MenuItem,
  Chip, TablePagination, Typography, Tooltip, CircularProgress,
  Dialog, DialogTitle, DialogContent, DialogContentText, DialogActions,
  Snackbar, Alert,
} from '@mui/material';
import { SelectChangeEvent } from '@mui/material/Select';
import AddIcon from '@mui/icons-material/Add';
import EditIcon from '@mui/icons-material/Edit';
import ViewIcon from '@mui/icons-material/Visibility';
import DeleteIcon from '@mui/icons-material/Delete';
import apiService from '../../../../service/apiService';

interface Subject {
  id: string;
  name: string;
  code: string;
  description: string;
  classId: string;
  className: string;
  teacherId: string;
  teacherName: string;
  status: string;
  createdAt: string;
}

interface SubjectsResponse {
  content: Subject[];
  totalElements: number;
  totalPages: number;
}

interface SnackbarState {
  open: boolean;
  message: string;
  severity: 'success' | 'error';
}

const SubjectListPage: React.FC = () => {
  const navigate = useNavigate();

  const [subjects, setSubjects] = useState<Subject[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(20);
  const [totalElements, setTotalElements] = useState(0);
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState('');

  // Delete dialog
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [subjectToDelete, setSubjectToDelete] = useState<Subject | null>(null);
  const [deleting, setDeleting] = useState(false);

  // Snackbar
  const [snackbar, setSnackbar] = useState<SnackbarState>({
    open: false,
    message: '',
    severity: 'success',
  });

  const showSnackbar = (message: string, severity: 'success' | 'error') => {
    setSnackbar({ open: true, message, severity });
  };

  const handleCloseSnackbar = () => {
    setSnackbar(prev => ({ ...prev, open: false }));
  };

  const fetchSubjects = useCallback(async () => {
    setLoading(true);
    try {
      const response = await apiService.get<SubjectsResponse>('/subjects', {
        params: { page, size: rowsPerPage },
      });
      const data = response.data;
      setSubjects(data.content);
      setTotalElements(data.totalElements);
    } catch (error: any) {
      console.error('Error fetching subjects:', error);
      showSnackbar(error.message || 'Failed to load subjects.', 'error');
      setSubjects([]);
      setTotalElements(0);
    } finally {
      setLoading(false);
    }
  }, [page, rowsPerPage]);

  useEffect(() => {
    fetchSubjects();
  }, [fetchSubjects]);

  // Client-side filtering on the fetched page
  const filteredSubjects = subjects.filter(subject => {
    const matchesSearch = !searchQuery || [
      subject.name,
      subject.code,
      subject.className,
      subject.teacherName,
    ].some(field => field?.toLowerCase().includes(searchQuery.toLowerCase()));

    const matchesStatus = !statusFilter || subject.status === statusFilter;

    return matchesSearch && matchesStatus;
  });

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearchQuery(e.target.value);
  };

  const handleStatusFilterChange = (e: SelectChangeEvent<unknown>) => {
    setStatusFilter(e.target.value as string);
  };

  const handlePageChange = (_: unknown, newPage: number) => {
    setPage(newPage);
  };

  const handleRowsPerPageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setRowsPerPage(parseInt(e.target.value, 10));
    setPage(0);
  };

  // Delete handlers
  const handleDeleteClick = (subject: Subject) => {
    setSubjectToDelete(subject);
    setDeleteDialogOpen(true);
  };

  const handleDeleteCancel = () => {
    setDeleteDialogOpen(false);
    setSubjectToDelete(null);
  };

  const handleDeleteConfirm = async () => {
    if (!subjectToDelete) return;
    setDeleting(true);
    try {
      await apiService.delete(`/subjects/${subjectToDelete.id}`);
      showSnackbar(`Subject "${subjectToDelete.name}" deleted successfully.`, 'success');
      setDeleteDialogOpen(false);
      setSubjectToDelete(null);
      fetchSubjects();
    } catch (error: any) {
      console.error('Error deleting subject:', error);
      showSnackbar(error.message || 'Failed to delete subject.', 'error');
    } finally {
      setDeleting(false);
    }
  };

  const getStatusColor = (status: string): 'success' | 'error' | 'default' => {
    switch (status?.toLowerCase()) {
      case 'active':
        return 'success';
      case 'inactive':
        return 'error';
      default:
        return 'default';
    }
  };

  return (
    <Box sx={{ p: 3 }}>
      {/* Header */}
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h5" component="h1">Subject Management</Typography>
        <Button
          variant="contained"
          color="primary"
          startIcon={<AddIcon />}
          onClick={() => navigate('/dashboard/subjects/add')}
        >
          Add Subject
        </Button>
      </Box>

      {/* Filters */}
      <Paper sx={{ p: 2, mb: 3 }}>
        <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 2, alignItems: 'center' }}>
          <TextField
            label="Search Subjects"
            variant="outlined"
            size="small"
            value={searchQuery}
            onChange={handleSearchChange}
            placeholder="Search by name, code, class, or teacher"
            sx={{ minWidth: 300 }}
          />
          <FormControl variant="outlined" size="small" sx={{ minWidth: 200 }}>
            <InputLabel>Status</InputLabel>
            <Select
              value={statusFilter}
              onChange={handleStatusFilterChange}
              label="Status"
            >
              <MenuItem value="">All Status</MenuItem>
              <MenuItem value="ACTIVE">Active</MenuItem>
              <MenuItem value="INACTIVE">Inactive</MenuItem>
            </Select>
          </FormControl>
        </Box>
      </Paper>

      {/* Subject Table */}
      <Paper sx={{ width: '100%', overflow: 'hidden' }}>
        {loading ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', py: 6 }}>
            <CircularProgress />
          </Box>
        ) : (
          <>
            <TableContainer sx={{ maxHeight: 600 }}>
              <Table stickyHeader aria-label="subject table">
                <TableHead>
                  <TableRow>
                    <TableCell>Name</TableCell>
                    <TableCell>Code</TableCell>
                    <TableCell>Class</TableCell>
                    <TableCell>Teacher</TableCell>
                    <TableCell>Status</TableCell>
                    <TableCell>Actions</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {filteredSubjects.length === 0 ? (
                    <TableRow>
                      <TableCell colSpan={6} align="center" sx={{ py: 4 }}>
                        <Typography color="text.secondary">
                          {subjects.length === 0
                            ? 'No subjects found. Add a subject to get started.'
                            : 'No subjects match your filters.'}
                        </Typography>
                      </TableCell>
                    </TableRow>
                  ) : (
                    filteredSubjects.map((subject) => (
                      <TableRow hover key={subject.id}>
                        <TableCell>{subject.name}</TableCell>
                        <TableCell>
                          <Chip label={subject.code} size="small" variant="outlined" />
                        </TableCell>
                        <TableCell>{subject.className || '-'}</TableCell>
                        <TableCell>{subject.teacherName || '-'}</TableCell>
                        <TableCell>
                          <Chip
                            label={subject.status}
                            color={getStatusColor(subject.status)}
                            size="small"
                            variant="outlined"
                          />
                        </TableCell>
                        <TableCell>
                          <Box sx={{ display: 'flex', gap: 0.5 }}>
                            <Tooltip title="View">
                              <IconButton
                                size="small"
                                onClick={() => navigate(`/dashboard/subjects/${subject.id}`)}
                              >
                                <ViewIcon fontSize="small" />
                              </IconButton>
                            </Tooltip>
                            <Tooltip title="Edit">
                              <IconButton
                                size="small"
                                onClick={() => navigate(`/dashboard/subjects/edit/${subject.id}`)}
                              >
                                <EditIcon fontSize="small" />
                              </IconButton>
                            </Tooltip>
                            <Tooltip title="Delete">
                              <IconButton
                                size="small"
                                color="error"
                                onClick={() => handleDeleteClick(subject)}
                              >
                                <DeleteIcon fontSize="small" />
                              </IconButton>
                            </Tooltip>
                          </Box>
                        </TableCell>
                      </TableRow>
                    ))
                  )}
                </TableBody>
              </Table>
            </TableContainer>
            <TablePagination
              rowsPerPageOptions={[10, 20, 50]}
              component="div"
              count={totalElements}
              rowsPerPage={rowsPerPage}
              page={page}
              onPageChange={handlePageChange}
              onRowsPerPageChange={handleRowsPerPageChange}
            />
          </>
        )}
      </Paper>

      {/* Delete Confirmation Dialog */}
      <Dialog open={deleteDialogOpen} onClose={handleDeleteCancel}>
        <DialogTitle>Delete Subject</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Are you sure you want to delete the subject "{subjectToDelete?.name}"? This action cannot be undone.
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleDeleteCancel} disabled={deleting}>
            Cancel
          </Button>
          <Button onClick={handleDeleteConfirm} color="error" variant="contained" disabled={deleting}>
            {deleting ? <CircularProgress size={20} /> : 'Delete'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* Snackbar for notifications */}
      <Snackbar
        open={snackbar.open}
        autoHideDuration={4000}
        onClose={handleCloseSnackbar}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
      >
        <Alert onClose={handleCloseSnackbar} severity={snackbar.severity} variant="filled" sx={{ width: '100%' }}>
          {snackbar.message}
        </Alert>
      </Snackbar>
    </Box>
  );
};

export default SubjectListPage;
