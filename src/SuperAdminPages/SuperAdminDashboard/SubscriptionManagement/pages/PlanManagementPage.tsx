import React, { useEffect, useState } from 'react';
import { Box, Typography, Button, Table, TableBody, TableCell, TableContainer, TableHead, TableRow,
  Paper, IconButton, Chip } from '@mui/material';
import { Add, Edit, Delete } from '@mui/icons-material';
import PlanForm from '../components/PlanForm';
import { getPlans, createPlan, updatePlan, deletePlan } from '../api/subscriptionAPI';

const PlanManagementPage: React.FC = () => {
  const [plans, setPlans] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [formOpen, setFormOpen] = useState(false);
  const [editingPlan, setEditingPlan] = useState<any>(null);

  const fetchPlans = async () => {
    try {
      setLoading(true);
      const response = await getPlans();
      setPlans(response.data || []);
    } catch (error) {
      console.error('Failed to fetch plans:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchPlans(); }, []);

  const handleCreate = async (values: any) => {
    try {
      await createPlan(values);
      fetchPlans();
    } catch (error) {
      console.error('Failed to create plan:', error);
    }
  };

  const handleUpdate = async (values: any) => {
    try {
      await updatePlan(editingPlan.id, values);
      setEditingPlan(null);
      fetchPlans();
    } catch (error) {
      console.error('Failed to update plan:', error);
    }
  };

  const handleDelete = async (id: string) => {
    if (window.confirm('Are you sure you want to deactivate this plan?')) {
      try {
        await deletePlan(id);
        fetchPlans();
      } catch (error) {
        console.error('Failed to delete plan:', error);
      }
    }
  };

  const formatCycle = (cycle: string) => cycle.replace('_', ' ');

  return (
    <Box p={3}>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h5" fontWeight="bold">Subscription Plans</Typography>
        <Button variant="contained" startIcon={<Add />} onClick={() => setFormOpen(true)}>
          Create Plan
        </Button>
      </Box>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Plan Name</TableCell>
              <TableCell>Base Price</TableCell>
              <TableCell>Per Student</TableCell>
              <TableCell>Billing Cycle</TableCell>
              <TableCell>Grace Period</TableCell>
              <TableCell>Min Days</TableCell>
              <TableCell>Type</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {loading ? (
              <TableRow><TableCell colSpan={8} align="center">Loading...</TableCell></TableRow>
            ) : plans.length === 0 ? (
              <TableRow><TableCell colSpan={8} align="center">No plans found</TableCell></TableRow>
            ) : plans.map((plan) => (
              <TableRow key={plan.id}>
                <TableCell>{plan.name}</TableCell>
                <TableCell>₹{plan.basePrice}</TableCell>
                <TableCell>₹{plan.perStudentPrice}</TableCell>
                <TableCell>{formatCycle(plan.billingCycle)}</TableCell>
                <TableCell>{plan.gracePeriodDays}d + {plan.readOnlyPeriodDays}d</TableCell>
                <TableCell>{plan.minDaysForBilling}</TableCell>
                <TableCell>
                  <Chip label={plan.tenantId ? 'Custom' : 'Global'} size="small"
                    color={plan.tenantId ? 'primary' : 'default'} />
                </TableCell>
                <TableCell>
                  <IconButton size="small" onClick={() => { setEditingPlan(plan); setFormOpen(true); }}>
                    <Edit fontSize="small" />
                  </IconButton>
                  <IconButton size="small" color="error" onClick={() => handleDelete(plan.id)}>
                    <Delete fontSize="small" />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      <PlanForm
        open={formOpen}
        onClose={() => { setFormOpen(false); setEditingPlan(null); }}
        onSubmit={editingPlan ? handleUpdate : handleCreate}
        initialValues={editingPlan}
        title={editingPlan ? 'Edit Plan' : 'Create New Plan'}
      />
    </Box>
  );
};

export default PlanManagementPage;
