import React, { useState, useEffect } from 'react';
import {
  Box, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, TablePagination,
  Paper, TextField, InputAdornment, Button, IconButton, Chip, Menu, MenuItem,
  Typography, CircularProgress, Tooltip, Fab, Badge, Avatar, useTheme
} from '@mui/material';
import {
  Search as SearchIcon,
  FilterList as FilterListIcon,
  MoreVert as MoreVertIcon,
  Add as AddIcon,
  School as SchoolIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Visibility as VisibilityIcon,
  Lock as LockIcon,
  LockOpen as LockOpenIcon,
  Person as PersonIcon
} from '@mui/icons-material';
import { useNavigate } from 'react-router-dom';
import apiService from '../../../service/apiService';

// Types
export interface School {
  id: string;
  name: string;
  schoolCode: string;
  board: string;
  city: string;
  status: 'Active' | 'Inactive';
  createdDate: string;
  admin: {
    name: string;
    email: string;
  };
}

const SchoolList: React.FC = () => {
  const theme = useTheme();
  const navigate = useNavigate();
  const [schools, setSchools] = useState<School[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [totalElements, setTotalElements] = useState(0);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('All');
  const [boardFilter, setBoardFilter] = useState<string>('All');
  const [sortConfig, setSortConfig] = useState<{ key: keyof School; direction: 'asc' | 'desc' }>({
    key: 'createdDate',
    direction: 'desc'
  });
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const [selectedSchool, setSelectedSchool] = useState<School | null>(null);

  // Fetch schools data from real API
  const fetchSchools = async () => {
    try {
      setLoading(true);
      const response = await apiService.get('/superadmin/tenants', {
        params: {
          page: page,
          size: rowsPerPage,
          ...(searchTerm ? { search: searchTerm } : {}),
        },
      });

      const data = response?.data || response || {};
      const content = data.content || data.tenants || data || [];
      const schoolsArray = Array.isArray(content) ? content : [];

      const mappedSchools: School[] = schoolsArray.map((tenant: any) => ({
        id: tenant.id?.toString() || '',
        name: tenant.name || tenant.schoolName || '',
        schoolCode: tenant.identifier || tenant.schoolCode || tenant.code || '',
        board: tenant.board || tenant.subscriptionPlan || 'N/A',
        city: tenant.city || '',
        status: (tenant.status === 'ACTIVE' || tenant.status === 'Active') ? 'Active' : 'Inactive',
        createdDate: tenant.createdAt || tenant.createdDate || '',
        admin: {
          name: tenant.adminName || tenant.admin?.name || tenant.contactPerson || 'N/A',
          email: tenant.email || tenant.admin?.email || tenant.contactEmail || 'N/A',
        },
      }));

      setSchools(mappedSchools);
      setTotalElements(data.totalElements ?? data.total ?? mappedSchools.length);
    } catch (error) {
      console.error('Error fetching schools:', error);
      setSchools([]);
      setTotalElements(0);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchSchools();
  }, [page, rowsPerPage, searchTerm]);

  // Filter schools locally for status and board
  const filteredSchools = React.useMemo(() => {
    return schools.filter(school => {
      const matchesStatus = statusFilter === 'All' || school.status === statusFilter;
      const matchesBoard = boardFilter === 'All' || school.board === boardFilter;
      return matchesStatus && matchesBoard;
    }).sort((a, b) => {
      if (a[sortConfig.key] < b[sortConfig.key]) {
        return sortConfig.direction === 'asc' ? -1 : 1;
      }
      if (a[sortConfig.key] > b[sortConfig.key]) {
        return sortConfig.direction === 'asc' ? 1 : -1;
      }
      return 0;
    });
  }, [schools, statusFilter, boardFilter, sortConfig]);

  const handleChangePage = (event: unknown, newPage: number) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event: React.ChangeEvent<HTMLInputElement>) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const handleSort = (key: keyof School) => {
    setSortConfig(prev => ({
      key,
      direction: prev.key === key && prev.direction === 'asc' ? 'desc' : 'asc'
    }));
  };

  const handleMenuOpen = (event: React.MouseEvent<HTMLElement>, school: School) => {
    setAnchorEl(event.currentTarget);
    setSelectedSchool(school);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
    setSelectedSchool(null);
  };

  const handleViewSchool = (school: School) => {
    console.log('View school:', school);
  };

  const handleEditSchool = (school: School) => {
    console.log('Edit school:', school);
  };

  const handleDeleteSchool = async (school: School) => {
    if (!window.confirm(`Are you sure you want to delete "${school.name}"?`)) {
      handleMenuClose();
      return;
    }
    try {
      await apiService.delete(`/superadmin/tenants/${school.id}`);
      fetchSchools();
    } catch (error) {
      console.error('Error deleting school:', error);
      alert('Failed to delete school. Please try again.');
    }
    handleMenuClose();
  };

  const handleToggleStatus = async (school: School) => {
    try {
      const action = school.status === 'Active' ? 'suspend' : 'activate';
      await apiService.post(`/superadmin/tenants/${school.id}/${action}`);
      fetchSchools();
    } catch (error) {
      console.error('Error toggling school status:', error);
      alert('Failed to update school status. Please try again.');
    }
    handleMenuClose();
  };

  const handleLoginAsAdmin = (school: School) => {
    console.log('Login as admin for school:', school);
    handleMenuClose();
  };

  const emptyRows = rowsPerPage - Math.min(rowsPerPage, filteredSchools.length);

  return (
    <Box sx={{ width: '100%', p: 3 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h5" component="h1">
          Schools
          <Chip
            label={`${totalElements} ${totalElements === 1 ? 'School' : 'Schools'}`}
            color="primary"
            size="small"
            sx={{ ml: 2, fontWeight: 'bold' }}
          />
        </Typography>

        <Button
          variant="contained"
          color="primary"
          startIcon={<AddIcon />}
          onClick={() => navigate('/dashboard/schools/add', { replace: true })}>
          Add New School
        </Button>
      </Box>

      {/* Search and Filters */}
      <Paper sx={{ p: 2, mb: 3 }}>
        <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 2, alignItems: 'center' }}>
          <TextField
            placeholder="Search by name, code or city..."
            variant="outlined"
            size="small"
            value={searchTerm}
            onChange={(e) => {
              setSearchTerm(e.target.value);
              setPage(0);
            }}
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <SearchIcon />
                </InputAdornment>
              ),
            }}
            sx={{ flex: 1, minWidth: 250 }}
          />

          <TextField
            select
            label="Status"
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            size="small"
            sx={{ minWidth: 150 }}
          >
            {['All', 'Active', 'Inactive'].map((status) => (
              <MenuItem key={status} value={status}>
                {status}
              </MenuItem>
            ))}
          </TextField>

          <TextField
            select
            label="Board"
            value={boardFilter}
            onChange={(e) => setBoardFilter(e.target.value)}
            size="small"
            sx={{ minWidth: 150 }}
          >
            {['All', 'CBSE', 'ICSE', 'State Board', 'IB', 'IGCSE'].map((board) => (
              <MenuItem key={board} value={board}>
                {board}
              </MenuItem>
            ))}
          </TextField>

          <Button
            variant="outlined"
            startIcon={<FilterListIcon />}
            onClick={() => {
              console.log('Advanced filters');
            }}
          >
            More Filters
          </Button>
        </Box>
      </Paper>

      {/* Schools Table */}
      <Paper sx={{ width: '100%', overflow: 'hidden' }}>
        <TableContainer sx={{ maxHeight: 'calc(100vh - 300px)' }}>
          <Table stickyHeader aria-label="schools table">
            <TableHead>
              <TableRow>
                <TableCell>School Name</TableCell>
                <TableCell>School Code</TableCell>
                <TableCell>Board</TableCell>
                <TableCell>Status</TableCell>
                <TableCell>Created Date</TableCell>
                <TableCell>Admin</TableCell>
                <TableCell align="right">Actions</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {loading ? (
                <TableRow>
                  <TableCell colSpan={7} align="center" sx={{ py: 4 }}>
                    <CircularProgress />
                    <Typography variant="body2" sx={{ mt: 1 }}>Loading schools...</Typography>
                  </TableCell>
                </TableRow>
              ) : filteredSchools.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={7} align="center" sx={{ py: 4 }}>
                    <SchoolIcon sx={{ fontSize: 64, color: 'text.disabled', mb: 1 }} />
                    <Typography variant="h6" color="textSecondary">
                      No schools found
                    </Typography>
                    <Typography variant="body2" color="textSecondary" sx={{ mt: 1, mb: 2 }}>
                      {searchTerm || statusFilter !== 'All' || boardFilter !== 'All'
                        ? 'Try adjusting your search or filter criteria'
                        : 'Get started by adding a new school'}
                    </Typography>
                    {!searchTerm && statusFilter === 'All' && boardFilter === 'All' && (
                      <Button
                        variant="contained"
                        color="primary"
                        startIcon={<AddIcon />}
                        onClick={() => navigate('/dashboard/schools/add')}
                      >
                        Add New School
                      </Button>
                    )}
                  </TableCell>
                </TableRow>
              ) : (
                filteredSchools.map((school) => (
                    <TableRow
                      key={school.id}
                      hover
                      sx={{ '&:hover': { backgroundColor: 'action.hover', cursor: 'pointer' } }}
                      onClick={() => handleViewSchool(school)}
                    >
                      <TableCell>
                        <Box sx={{ display: 'flex', alignItems: 'center' }}>
                          <Avatar sx={{ bgcolor: 'primary.main', mr: 2 }}>
                            <SchoolIcon />
                          </Avatar>
                          <Box>
                            <Typography variant="subtitle2">{school.name}</Typography>
                            <Typography variant="body2" color="textSecondary">{school.city}</Typography>
                          </Box>
                        </Box>
                      </TableCell>
                      <TableCell>{school.schoolCode}</TableCell>
                      <TableCell>{school.board}</TableCell>
                      <TableCell>
                        <Chip
                          label={school.status}
                          size="small"
                          color={school.status === 'Active' ? 'success' : 'default'}
                          variant="outlined"
                        />
                      </TableCell>
                      <TableCell>
                        {school.createdDate ? new Date(school.createdDate).toLocaleDateString() : 'N/A'}
                      </TableCell>
                      <TableCell>
                        <Box sx={{ display: 'flex', alignItems: 'center' }}>
                          <Avatar sx={{ width: 32, height: 32, mr: 1, bgcolor: 'primary.main' }}>
                            <PersonIcon fontSize="small" />
                          </Avatar>
                          <Box>
                            <Typography variant="body2">{school.admin.name}</Typography>
                            <Typography variant="caption" color="textSecondary">
                              {school.admin.email}
                            </Typography>
                          </Box>
                        </Box>
                      </TableCell>
                      <TableCell align="right">
                        <IconButton
                          size="small"
                          onClick={(e) => {
                            e.stopPropagation();
                            handleMenuOpen(e, school);
                          }}
                        >
                          <MoreVertIcon />
                        </IconButton>
                      </TableCell>
                    </TableRow>
                  ))
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
        onClick={(e) => e.stopPropagation()}
      >
        <MenuItem onClick={() => selectedSchool && handleViewSchool(selectedSchool)}>
          <VisibilityIcon fontSize="small" sx={{ mr: 1 }} />
          View Details
        </MenuItem>
        <MenuItem onClick={() => selectedSchool && handleEditSchool(selectedSchool)}>
          <EditIcon fontSize="small" sx={{ mr: 1 }} />
          Edit
        </MenuItem>
        <MenuItem onClick={() => selectedSchool && handleToggleStatus(selectedSchool)}>
          {selectedSchool?.status === 'Active' ? (
            <>
              <LockIcon fontSize="small" sx={{ mr: 1 }} />
              Deactivate
            </>
          ) : (
            <>
              <LockOpenIcon fontSize="small" sx={{ mr: 1 }} />
              Activate
            </>
          )}
        </MenuItem>
        <MenuItem onClick={() => selectedSchool && handleLoginAsAdmin(selectedSchool)}>
          <PersonIcon fontSize="small" sx={{ mr: 1 }} />
          Login as Admin
        </MenuItem>
        <MenuItem
          onClick={() => selectedSchool && handleDeleteSchool(selectedSchool)}
          sx={{ color: 'error.main' }}
        >
          <DeleteIcon fontSize="small" sx={{ mr: 1 }} />
          Delete
        </MenuItem>
      </Menu>
    </Box>
  );
};

export default SchoolList;
