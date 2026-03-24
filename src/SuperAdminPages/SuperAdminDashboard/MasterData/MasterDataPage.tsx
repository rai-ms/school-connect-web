import React, { useState, useEffect, useCallback } from 'react';
import {
  Box, Typography, Chip, Paper, IconButton, Button, TextField,
  Dialog, DialogTitle, DialogContent, DialogActions, CircularProgress,
  Snackbar, Alert, Tooltip, Divider,
} from '@mui/material';
import {
  Add as AddIcon, Edit as EditIcon, Delete as DeleteIcon,
  InboxOutlined, Dataset as DatasetIcon,
} from '@mui/icons-material';
import apiService from '../../../service/apiService';

interface MasterDataItem {
  id: string;
  category: string;
  value: string;
  label: string;
  description?: string;
  displayOrder: number;
  active: boolean;
}

const CATEGORIES = [
  { key: 'DESIGNATION', label: 'Designations', hint: 'e.g. Principal, HOD, Senior Teacher' },
  { key: 'DEPARTMENT', label: 'Departments', hint: 'e.g. Science, Mathematics, English' },
  { key: 'EMPLOYEE_TYPE', label: 'Employee Types', hint: 'e.g. Permanent, Contractual, Part-time' },
  { key: 'SUBJECT_TYPE', label: 'Subjects', hint: 'e.g. Physics, Chemistry, Hindi' },
  { key: 'QUALIFICATION', label: 'Qualifications', hint: 'e.g. B.Ed, M.Sc, Ph.D' },
  { key: 'CLASS_CATEGORY', label: 'Class Categories', hint: 'e.g. Primary (1-5), Secondary (9-10)' },
  { key: 'FEE_CATEGORY', label: 'Fee Categories', hint: 'e.g. Tuition Fee, Transport Fee, Lab Fee' },
  { key: 'LEAVE_TYPE', label: 'Leave Types', hint: 'e.g. Casual Leave, Sick Leave, Earned Leave' },
];

const MasterDataPage: React.FC = () => {
  const [selectedCategory, setSelectedCategory] = useState(CATEGORIES[0].key);
  const [items, setItems] = useState<MasterDataItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<MasterDataItem | null>(null);
  const [deleteDialogOpen, setDeleteDialogOpen] = useState(false);
  const [deletingItem, setDeletingItem] = useState<MasterDataItem | null>(null);
  const [formData, setFormData] = useState({ label: '', value: '', description: '' });
  const [saving, setSaving] = useState(false);
  const [snackbar, setSnackbar] = useState({ open: false, message: '', severity: 'success' as 'success' | 'error' });

  const fetchItems = useCallback(async () => {
    setLoading(true);
    try {
      const res = await apiService.get(`/master-data?category=${selectedCategory}`);
      const data = res?.data || res || [];
      setItems(Array.isArray(data) ? data : []);
    } catch (err) {
      console.error('Error fetching master data:', err);
      setItems([]);
    } finally {
      setLoading(false);
    }
  }, [selectedCategory]);

  useEffect(() => {
    fetchItems();
  }, [fetchItems]);

  const autoValue = (label: string) =>
    label.toUpperCase().replace(/[^A-Z0-9]+/g, '_').replace(/^_|_$/g, '');

  const handleLabelChange = (label: string) => {
    setFormData(prev => ({
      ...prev,
      label,
      value: editingItem ? prev.value : autoValue(label),
    }));
  };

  const openAddDialog = () => {
    setEditingItem(null);
    setFormData({ label: '', value: '', description: '' });
    setDialogOpen(true);
  };

  const openEditDialog = (item: MasterDataItem) => {
    setEditingItem(item);
    setFormData({ label: item.label, value: item.value, description: item.description || '' });
    setDialogOpen(true);
  };

  const handleSave = async () => {
    if (!formData.label.trim() || !formData.value.trim()) return;
    setSaving(true);
    try {
      if (editingItem) {
        await apiService.put(`/master-data/${editingItem.id}`, {
          category: editingItem.category,
          label: formData.label.trim(),
          value: formData.value.trim(),
          description: formData.description.trim() || null,
        });
        setSnackbar({ open: true, message: 'Updated successfully', severity: 'success' });
      } else {
        await apiService.post('/master-data', {
          category: selectedCategory,
          label: formData.label.trim(),
          value: formData.value.trim(),
          description: formData.description.trim() || null,
        });
        setSnackbar({ open: true, message: 'Created successfully', severity: 'success' });
      }
      setDialogOpen(false);
      fetchItems();
    } catch (err: any) {
      setSnackbar({ open: true, message: err?.message || 'Failed to save', severity: 'error' });
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async () => {
    if (!deletingItem) return;
    try {
      await apiService.delete(`/master-data/${deletingItem.id}`);
      setSnackbar({ open: true, message: 'Deleted successfully', severity: 'success' });
      setDeleteDialogOpen(false);
      setDeletingItem(null);
      fetchItems();
    } catch (err: any) {
      setSnackbar({ open: true, message: err?.message || 'Failed to delete', severity: 'error' });
    }
  };

  const categoryLabel = CATEGORIES.find(c => c.key === selectedCategory)?.label || selectedCategory;

  return (
    <Box sx={{ p: 3 }}>
      {/* Header */}
      <Paper
        elevation={0}
        sx={{
          p: 3, mb: 3, borderRadius: 3,
          background: 'linear-gradient(135deg, #1e3a5f 0%, #3b82f6 100%)',
          color: 'white',
          display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        }}
      >
        <Box>
          <Typography variant="h5" fontWeight={700}>Master Data Management</Typography>
          <Typography variant="body2" sx={{ opacity: 0.85, mt: 0.5 }}>
            Manage designations, departments, subjects, qualifications and more
          </Typography>
        </Box>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={openAddDialog}
          sx={{
            bgcolor: 'rgba(255,255,255,0.2)', color: 'white',
            '&:hover': { bgcolor: 'rgba(255,255,255,0.3)' },
            fontWeight: 600, borderRadius: 2,
          }}
        >
          Add {categoryLabel.replace(/s$/, '')}
        </Button>
      </Paper>

      {/* Category Chips */}
      <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1, mb: 3 }}>
        {CATEGORIES.map(cat => (
          <Chip
            key={cat.key}
            label={cat.label}
            onClick={() => setSelectedCategory(cat.key)}
            color={selectedCategory === cat.key ? 'primary' : 'default'}
            variant={selectedCategory === cat.key ? 'filled' : 'outlined'}
            sx={{
              fontWeight: selectedCategory === cat.key ? 600 : 400,
              fontSize: '0.85rem', px: 1,
            }}
          />
        ))}
      </Box>

      {/* Items List */}
      <Paper sx={{ borderRadius: 3, overflow: 'hidden' }}>
        <Box sx={{ p: 2, bgcolor: 'grey.50', borderBottom: '1px solid', borderColor: 'divider' }}>
          <Typography variant="subtitle1" fontWeight={600}>
            {categoryLabel} ({items.length})
          </Typography>
        </Box>

        {loading ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', py: 6 }}>
            <CircularProgress />
          </Box>
        ) : items.length === 0 ? (
          <Box sx={{ textAlign: 'center', py: 8 }}>
            <InboxOutlined sx={{ fontSize: 48, color: 'grey.400', mb: 1 }} />
            <Typography color="text.secondary">No {categoryLabel.toLowerCase()} found</Typography>
            <Typography variant="body2" color="text.secondary" sx={{ mt: 0.5 }}>
              Tap "Add Entry" to create one
            </Typography>
          </Box>
        ) : (
          <Box>
            {items.map((item, index) => (
              <React.Fragment key={item.id}>
                {index > 0 && <Divider />}
                <Box
                  sx={{
                    display: 'flex', alignItems: 'center', px: 3, py: 2,
                    '&:hover': { bgcolor: 'grey.50' }, transition: 'background 0.2s',
                  }}
                >
                  {/* Order badge */}
                  <Box
                    sx={{
                      width: 40, height: 40, borderRadius: '50%',
                      bgcolor: 'primary.50', color: 'primary.main',
                      display: 'flex', alignItems: 'center', justifyContent: 'center',
                      fontWeight: 700, fontSize: '0.85rem', mr: 2, flexShrink: 0,
                      border: '2px solid', borderColor: 'primary.100',
                    }}
                  >
                    {index + 1}
                  </Box>

                  {/* Content */}
                  <Box sx={{ flex: 1, minWidth: 0 }}>
                    <Typography fontWeight={600} sx={{ lineHeight: 1.3 }}>
                      {item.label}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      Code: {item.value}
                      {item.description && ` — ${item.description}`}
                    </Typography>
                  </Box>

                  {/* Actions */}
                  <Box sx={{ display: 'flex', gap: 0.5, flexShrink: 0 }}>
                    <Tooltip title="Edit">
                      <IconButton size="small" onClick={() => openEditDialog(item)} color="primary">
                        <EditIcon fontSize="small" />
                      </IconButton>
                    </Tooltip>
                    <Tooltip title="Delete">
                      <IconButton
                        size="small" color="error"
                        onClick={() => { setDeletingItem(item); setDeleteDialogOpen(true); }}
                      >
                        <DeleteIcon fontSize="small" />
                      </IconButton>
                    </Tooltip>
                  </Box>
                </Box>
              </React.Fragment>
            ))}
          </Box>
        )}
      </Paper>

      {/* Add/Edit Dialog */}
      <Dialog open={dialogOpen} onClose={() => setDialogOpen(false)} maxWidth="sm" fullWidth>
        <DialogTitle sx={{ fontWeight: 600, pb: 1 }}>
          {editingItem ? 'Edit Entry' : 'Add New Entry'}
        </DialogTitle>
        <DialogContent sx={{ pt: '8px !important' }}>
          <Chip
            label={categoryLabel}
            color="primary"
            size="small"
            sx={{ mb: 2, fontWeight: 600 }}
          />
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2.5 }}>
            <TextField
              fullWidth label="Label"
              placeholder={CATEGORIES.find(c => c.key === selectedCategory)?.hint || ''}
              value={formData.label}
              onChange={e => handleLabelChange(e.target.value)}
              autoFocus
            />
            <TextField
              fullWidth label="Value / Code"
              placeholder="Auto-generated from label"
              value={formData.value}
              onChange={e => setFormData(prev => ({ ...prev, value: e.target.value }))}
              helperText="Auto-generated from label. You can customize it."
            />
            <TextField
              fullWidth label="Description (Optional)" placeholder="Optional description"
              value={formData.description}
              onChange={e => setFormData(prev => ({ ...prev, description: e.target.value }))}
              multiline rows={2}
            />
          </Box>
        </DialogContent>
        <DialogActions sx={{ px: 3, pb: 2 }}>
          <Button onClick={() => setDialogOpen(false)} disabled={saving}>Cancel</Button>
          <Button
            variant="contained" onClick={handleSave} disabled={saving || !formData.label.trim()}
            startIcon={saving ? <CircularProgress size={18} /> : null}
          >
            {saving ? 'Saving...' : editingItem ? 'Update' : 'Create'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* Delete Confirmation */}
      <Dialog open={deleteDialogOpen} onClose={() => setDeleteDialogOpen(false)}>
        <DialogTitle>Delete Entry</DialogTitle>
        <DialogContent>
          <Typography>
            Are you sure you want to delete <strong>{deletingItem?.label}</strong>? This cannot be undone.
          </Typography>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setDeleteDialogOpen(false)}>Cancel</Button>
          <Button color="error" variant="contained" onClick={handleDelete}>Delete</Button>
        </DialogActions>
      </Dialog>

      {/* Snackbar */}
      <Snackbar
        open={snackbar.open} autoHideDuration={3000}
        onClose={() => setSnackbar(prev => ({ ...prev, open: false }))}
        anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
      >
        <Alert
          onClose={() => setSnackbar(prev => ({ ...prev, open: false }))}
          severity={snackbar.severity} sx={{ width: '100%' }}
        >
          {snackbar.message}
        </Alert>
      </Snackbar>
    </Box>
  );
};

export default MasterDataPage;
