import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
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
  FormControl,
  InputLabel,
  Select,
  MenuItem,
} from '@mui/material';
import {
  Search as SearchIcon,
  Edit as EditIcon,
  Visibility as VisibilityIcon,
  Delete as DeleteIcon,
  Add as AddIcon,
} from '@mui/icons-material';
import apiService from '../../../../service/apiService';

interface Announcement {
  id: string;
  title: string;
  content: string;
  description: string;
  type: string;
  category: string;
  targetAudience: string;
  priority: string;
  publishDate: string;
  expiryDate: string;
  status: string;
  createdAt: string;
  createdBy: string;
}

interface SnackbarState {
  open: boolean;
  message: string;
  severity: 'success' | 'error';
}

const NoticeListPage: React.FC = () => {
  const navigate = useNavigate();

  const [announcements, setAnnouncements] = useState<Announcement[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(20);
  const [totalElements, setTotalElements] = useState(0);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  const [priorityFilter, setPriorityFilter] = useState('');

  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [selectedNotice, setSelectedNotice] = useState<Announcement | null>(null);
  const [deleting, setDeleting] = useState(false);

  const [snackbar, setSnackbar] = useState<SnackbarState>({
    open: false,
    message: '',
    severity: 'success',
  });

  const fetchAnnouncements = useCallback(async () => {
    try {
      setLoading(true);
      const response = await apiService.get('/announcements', {
        params: {
          page,
          size: rowsPerPage,
          ...(searchTerm ? { search: searchTerm } : {}),
          ...(statusFilter ? { status: statusFilter } : {}),
          ...(priorityFilter ? { priority: priorityFilter } : {}),
        },
      });

      const data = response?.data || response || {};
      const content = data.content || data.announcements || data || [];
      const items: Announcement[] = Array.isArray(content) ? content : [];

      setAnnouncements(
        items.map((item: any) => ({
          id: item.id?.toString() || '',
          title: item.title || '',
          content: item.content || '',
          description: item.description || item.content || '',
          type: item.type || item.category || '',
          category: item.category || item.type || '',
          targetAudience: item.targetAudience || '',
          priority: item.priority || '',
          publishDate: item.publishDate || '',
          expiryDate: item.expiryDate || '',
          status: item.status || '',
          createdAt: item.createdAt || '',
          createdBy: item.createdBy || '',
        }))
      );
      setTotalElements(data.totalElements ?? data.total ?? items.length);
    } catch (error) {
      console.error('Error fetching announcements:', error);
      setAnnouncements([]);
      setTotalElements(0);
      setSnackbar({ open: true, message: 'Failed to load announcements.', severity: 'error' });
    } finally {
      setLoading(false);
    }
  }, [page, rowsPerPage, searchTerm, statusFilter, priorityFilter]);

  useEffect(() => {
    fetchAnnouncements();
  }, [fetchAnnouncements]);

  const handleChangePage = (_: unknown, newPage: number) => setPage(newPage);

  const handleChangeRowsPerPage = (event: React.ChangeEvent<HTMLInputElement>) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const handleSearch = (event: React.ChangeEvent<HTMLInputElement>) => {
    setSearchTerm(event.target.value);
    setPage(0);
  };

  const handleDeleteClick = (notice: Announcement) => {
    setSelectedNotice(notice);
    setDeleteDialogOpen(true);
  };

  const handleDeleteConfirm = async () => {
    if (!selectedNotice) return;
    try {
      setDeleting(true);
      await apiService.delete(`/announcements/${selectedNotice.id}`);
      setSnackbar({ open: true, message: 'Notice deleted successfully.', severity: 'success' });
      setDeleteDialogOpen(false);
      setSelectedNotice(null);
      fetchAnnouncements();
    } catch (error) {
      console.error('Error deleting announcement:', error);
      setSnackbar({ open: true, message: 'Failed to delete notice. Please try again.', severity: 'error' });
    } finally {
      setDeleting(false);
    }
  };

  const handleDeleteCancel = () => {
    setDeleteDialogOpen(false);
    setSelectedNotice(null);
  };

  const handleSnackbarClose = () => {
    setSnackbar((prev) => ({ ...prev, open: false }));
  };

  const getPriorityColor = (priority: string): 'error' | 'warning' | 'info' | 'default' => {
    switch (priority?.toLowerCase()) {
      case 'high':
        return 'error';
      case 'medium':
        return 'warning';
      case 'low':
        return 'info';
      default:
        return 'default';
    }
  };

  const getStatusColor = (status: string): 'success' | 'default' | 'warning' => {
    switch (status?.toLowerCase()) {
      case 'active':
      case 'published':
        return 'success';
      case 'draft':
        return 'default';
      case 'expired':
        return 'warning';
      default:
        return 'default';
    }
  };

  const formatDate = (dateStr: string): string => {
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

  return (
    <Box sx={{ width: '100%', p: 3 }}>
      {/* Header */}
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3, flexWrap: 'wrap', gap: 2 }}>
        <Typography variant="h5">
          Notices &amp; Announcements
          <Chip
            label={`${totalElements} ${totalElements === 1 ? 'Notice' : 'Notices'}`}
            color="primary"
            size="small"
            sx={{ ml: 2, fontWeight: 'bold' }}
          />
        </Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => navigate('/dashboard/notices/add')}
        >
          Add Notice
        </Button>
      </Box>

      {/* Search and Filters */}
      <Paper sx={{ p: 2, mb: 3 }}>
        <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 2 }}>
          <TextField
            placeholder="Search by title..."
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
          <FormControl size="small" sx={{ minWidth: 140 }}>
            <InputLabel shrink>Status</InputLabel>
            <Select
              value={statusFilter}
              onChange={(e) => { setStatusFilter(e.target.value); setPage(0); }}
              displayEmpty
              renderValue={(selected) => selected || 'All Status'}
            >
              <MenuItem value="">All Status</MenuItem>
              <MenuItem value="ACTIVE">Active</MenuItem>
              <MenuItem value="PUBLISHED">Published</MenuItem>
              <MenuItem value="DRAFT">Draft</MenuItem>
              <MenuItem value="EXPIRED">Expired</MenuItem>
            </Select>
          </FormControl>
          <FormControl size="small" sx={{ minWidth: 140 }}>
            <InputLabel shrink>Priority</InputLabel>
            <Select
              value={priorityFilter}
              onChange={(e) => { setPriorityFilter(e.target.value); setPage(0); }}
              displayEmpty
              renderValue={(selected) => selected || 'All Priority'}
            >
              <MenuItem value="">All Priority</MenuItem>
              <MenuItem value="HIGH">High</MenuItem>
              <MenuItem value="MEDIUM">Medium</MenuItem>
              <MenuItem value="LOW">Low</MenuItem>
            </Select>
          </FormControl>
        </Box>
      </Paper>

      {/* Table */}
      <Paper sx={{ width: '100%', overflow: 'hidden' }}>
        <TableContainer sx={{ maxHeight: 'calc(100vh - 320px)' }}>
          <Table stickyHeader>
            <TableHead>
              <TableRow>
                <TableCell>Title</TableCell>
                <TableCell>Type</TableCell>
                <TableCell>Priority</TableCell>
                <TableCell>Target Audience</TableCell>
                <TableCell>Published Date</TableCell>
                <TableCell>Status</TableCell>
                <TableCell align="right">Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {loading ? (
                <TableRow>
                  <TableCell colSpan={7} align="center" sx={{ py: 6 }}>
                    <CircularProgress />
                    <Typography variant="body2" sx={{ mt: 1 }}>
                      Loading announcements...
                    </Typography>
                  </TableCell>
                </TableRow>
              ) : announcements.length > 0 ? (
                announcements.map((notice) => (
                  <TableRow hover key={notice.id}>
                    <TableCell>
                      <Typography variant="body2" fontWeight={500}>
                        {notice.title}
                      </Typography>
                    </TableCell>
                    <TableCell>
                      <Chip label={notice.type || notice.category || '-'} size="small" variant="outlined" />
                    </TableCell>
                    <TableCell>
                      <Chip
                        label={notice.priority || '-'}
                        size="small"
                        color={getPriorityColor(notice.priority)}
                      />
                    </TableCell>
                    <TableCell>{notice.targetAudience || '-'}</TableCell>
                    <TableCell>{formatDate(notice.publishDate)}</TableCell>
                    <TableCell>
                      <Chip
                        label={notice.status || '-'}
                        size="small"
                        color={getStatusColor(notice.status)}
                        variant="outlined"
                      />
                    </TableCell>
                    <TableCell align="right">
                      <Tooltip title="View">
                        <IconButton
                          size="small"
                          onClick={() => navigate(`/dashboard/notices/${notice.id}`)}
                        >
                          <VisibilityIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip title="Edit">
                        <IconButton
                          size="small"
                          onClick={() => navigate(`/dashboard/notices/${notice.id}/edit`)}
                        >
                          <EditIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                      <Tooltip title="Delete">
                        <IconButton
                          size="small"
                          color="error"
                          onClick={() => handleDeleteClick(notice)}
                        >
                          <DeleteIcon fontSize="small" />
                        </IconButton>
                      </Tooltip>
                    </TableCell>
                  </TableRow>
                ))
              ) : (
                <TableRow>
                  <TableCell colSpan={7} align="center" sx={{ py: 6 }}>
                    <Typography color="text.secondary">
                      No announcements found. Click "Add Notice" to create one.
                    </Typography>
                  </TableCell>
                </TableRow>
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
          onPageChange={handleChangePage}
          onRowsPerPageChange={handleChangeRowsPerPage}
        />
      </Paper>

      {/* Delete Confirmation Dialog */}
      <Dialog open={deleteDialogOpen} onClose={handleDeleteCancel}>
        <DialogTitle>Delete Notice</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Are you sure you want to delete <strong>{selectedNotice?.title}</strong>? This action
            cannot be undone.
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

      {/* Snackbar for feedback */}
      <Snackbar
        open={snackbar.open}
        autoHideDuration={4000}
        onClose={handleSnackbarClose}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'center' }}
      >
        <Alert onClose={handleSnackbarClose} severity={snackbar.severity} variant="filled" sx={{ width: '100%' }}>
          {snackbar.message}
        </Alert>
      </Snackbar>
    </Box>
  );
};

export default NoticeListPage;
