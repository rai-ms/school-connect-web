import React, { useState, useEffect, useCallback } from 'react';
import { SelectChangeEvent } from '@mui/material/Select';
import { useNavigate } from 'react-router-dom';
import {
  Box, Button, Table, TableBody, TableCell, TableContainer, TableHead, TableRow,
  Paper, IconButton, TextField, MenuItem, FormControl, InputLabel, Select,
  Chip, TablePagination, Typography, Tooltip, CircularProgress,
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import EditIcon from '@mui/icons-material/Edit';
import ViewIcon from '@mui/icons-material/Visibility';
import DeleteIcon from '@mui/icons-material/Delete';
import classAPI, { ClassData } from './classAPI';

const ClassList: React.FC = () => {
  const navigate = useNavigate();
  const [classes, setClasses] = useState<ClassData[]>([]);
  const [filteredClasses, setFilteredClasses] = useState<ClassData[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  const [filters, setFilters] = useState({
    status: '',
    searchQuery: '',
  });

  const loadClasses = useCallback(async () => {
    setLoading(true);
    try {
      const data = await classAPI.fetchClasses();
      setClasses(data);
    } catch (error) {
      console.error('Error loading classes:', error);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadClasses();
  }, [loadClasses]);

  // Apply filters
  useEffect(() => {
    let result = [...classes];
    if (filters.status) {
      result = result.filter(cls => cls.status === filters.status);
    }
    if (filters.searchQuery) {
      const q = filters.searchQuery.toLowerCase();
      result = result.filter(cls =>
        cls.className.toLowerCase().includes(q) ||
        cls.sections.some(s => s.name.toLowerCase().includes(q))
      );
    }
    setFilteredClasses(result);
  }, [classes, filters]);

  const handleDelete = async (id: string) => {
    if (!window.confirm('Are you sure you want to delete this class?')) return;
    try {
      await classAPI.deleteClass(id);
      setClasses(prev => prev.filter(cls => cls.id !== id));
    } catch (error) {
      console.error('Error deleting class:', error);
      alert('Failed to delete class.');
    }
  };

  const handleFilterChange = (e: SelectChangeEvent<unknown>) => {
    setFilters(prev => ({ ...prev, [e.target.name as string]: e.target.value }));
    setPage(0);
  };

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFilters(prev => ({ ...prev, searchQuery: e.target.value }));
    setPage(0);
  };

  return (
    <Box sx={{ p: 3 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h5" component="h1">Class Management</Typography>
        <Button
          variant="contained"
          color="primary"
          startIcon={<AddIcon />}
          onClick={() => navigate('/dashboard/classes/add')}
        >
          Add New Class
        </Button>
      </Box>

      {/* Filters */}
      <Paper sx={{ p: 2, mb: 3 }}>
        <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 2, alignItems: 'center' }}>
          <TextField
            label="Search Classes"
            variant="outlined"
            size="small"
            value={filters.searchQuery}
            onChange={handleSearchChange}
            sx={{ minWidth: 250 }}
          />
          <FormControl variant="outlined" size="small" sx={{ minWidth: 200 }}>
            <InputLabel>Status</InputLabel>
            <Select
              name="status"
              value={filters.status}
              onChange={handleFilterChange}
              label="Status"
            >
              <MenuItem value="">All Status</MenuItem>
              <MenuItem value="Active">Active</MenuItem>
              <MenuItem value="Inactive">Inactive</MenuItem>
            </Select>
          </FormControl>
        </Box>
      </Paper>

      {/* Class Table */}
      <Paper sx={{ width: '100%', overflow: 'hidden' }}>
        {loading ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', py: 6 }}>
            <CircularProgress />
          </Box>
        ) : (
          <>
            <TableContainer sx={{ maxHeight: 600 }}>
              <Table stickyHeader aria-label="class table">
                <TableHead>
                  <TableRow>
                    <TableCell>Class Name</TableCell>
                    <TableCell>Sections</TableCell>
                    <TableCell>Class Teachers</TableCell>
                    <TableCell>Capacity</TableCell>
                    <TableCell>Status</TableCell>
                    <TableCell>Actions</TableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {filteredClasses.length === 0 ? (
                    <TableRow>
                      <TableCell colSpan={6} align="center" sx={{ py: 4 }}>
                        {classes.length === 0 ? 'No classes found. Add a class to get started.' : 'No classes match your filters.'}
                      </TableCell>
                    </TableRow>
                  ) : (
                    filteredClasses
                      .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                      .map((cls) => (
                        <TableRow hover key={cls.id}>
                          <TableCell>{cls.className}</TableCell>
                          <TableCell>
                            <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5 }}>
                              {cls.sections.map(section => (
                                <Chip key={section.id} label={section.name} size="small" variant="outlined" />
                              ))}
                            </Box>
                          </TableCell>
                          <TableCell>
                            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0.5 }}>
                              {cls.sections.map(section => (
                                <Chip
                                  key={section.id}
                                  label={section.classTeacher?.name || 'Not Assigned'}
                                  size="small"
                                  variant={section.classTeacher ? 'filled' : 'outlined'}
                                  color={section.classTeacher ? 'primary' : 'default'}
                                />
                              ))}
                            </Box>
                          </TableCell>
                          <TableCell>
                            {cls.sections.reduce((sum, s) => sum + s.maxStudents, 0)}
                          </TableCell>
                          <TableCell>
                            <Chip
                              label={cls.status}
                              color={cls.status === 'Active' ? 'success' : 'default'}
                              size="small"
                              variant="outlined"
                            />
                          </TableCell>
                          <TableCell>
                            <Box sx={{ display: 'flex', gap: 0.5 }}>
                              <Tooltip title="View">
                                <IconButton size="small" onClick={() => navigate(`/dashboard/classes/${cls.id}`)}>
                                  <ViewIcon fontSize="small" />
                                </IconButton>
                              </Tooltip>
                              <Tooltip title="Edit">
                                <IconButton size="small" onClick={() => navigate(`/dashboard/classes/edit/${cls.id}`)}>
                                  <EditIcon fontSize="small" />
                                </IconButton>
                              </Tooltip>
                              <Tooltip title="Delete">
                                <IconButton size="small" color="error" onClick={() => handleDelete(cls.id)}>
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
              rowsPerPageOptions={[5, 10, 25]}
              component="div"
              count={filteredClasses.length}
              rowsPerPage={rowsPerPage}
              page={page}
              onPageChange={(_, p) => setPage(p)}
              onRowsPerPageChange={(e) => { setRowsPerPage(parseInt(e.target.value, 10)); setPage(0); }}
            />
          </>
        )}
      </Paper>
    </Box>
  );
};

export default ClassList;
