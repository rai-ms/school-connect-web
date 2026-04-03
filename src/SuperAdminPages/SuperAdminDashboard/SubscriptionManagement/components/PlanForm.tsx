import React from 'react';
import { Dialog, DialogTitle, DialogContent, DialogActions, Button, TextField, MenuItem, Grid } from '@mui/material';
import { useFormik } from 'formik';

interface PlanFormProps {
  open: boolean;
  onClose: () => void;
  onSubmit: (values: any) => void;
  initialValues?: any;
  title: string;
}

const billingCycles = ['MONTHLY', 'QUARTERLY', 'HALF_YEARLY', 'YEARLY'];

const PlanForm: React.FC<PlanFormProps> = ({ open, onClose, onSubmit, initialValues, title }) => {
  const formik = useFormik({
    initialValues: initialValues || {
      name: '',
      basePrice: 0,
      perStudentPrice: 50,
      billingCycle: 'MONTHLY',
      gracePeriodDays: 7,
      readOnlyPeriodDays: 7,
      minDaysForBilling: 10,
      tenantId: '',
    },
    enableReinitialize: true,
    onSubmit: (values) => {
      onSubmit({ ...values, tenantId: values.tenantId || null });
      onClose();
    },
  });

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <DialogTitle>{title}</DialogTitle>
      <form onSubmit={formik.handleSubmit}>
        <DialogContent>
          <Grid container spacing={2}>
            <Grid item xs={12}>
              <TextField fullWidth label="Plan Name" name="name" value={formik.values.name}
                onChange={formik.handleChange} required />
            </Grid>
            <Grid item xs={6}>
              <TextField fullWidth label="Base Price (₹)" name="basePrice" type="number"
                value={formik.values.basePrice} onChange={formik.handleChange} required />
            </Grid>
            <Grid item xs={6}>
              <TextField fullWidth label="Per Student Price (₹)" name="perStudentPrice" type="number"
                value={formik.values.perStudentPrice} onChange={formik.handleChange} required />
            </Grid>
            <Grid item xs={6}>
              <TextField fullWidth select label="Billing Cycle" name="billingCycle"
                value={formik.values.billingCycle} onChange={formik.handleChange}>
                {billingCycles.map(c => <MenuItem key={c} value={c}>{c.replace('_', ' ')}</MenuItem>)}
              </TextField>
            </Grid>
            <Grid item xs={6}>
              <TextField fullWidth label="Min Days for Billing" name="minDaysForBilling" type="number"
                value={formik.values.minDaysForBilling} onChange={formik.handleChange}
                helperText="Student must be registered this many days to count" />
            </Grid>
            <Grid item xs={6}>
              <TextField fullWidth label="Grace Period (days)" name="gracePeriodDays" type="number"
                value={formik.values.gracePeriodDays} onChange={formik.handleChange} />
            </Grid>
            <Grid item xs={6}>
              <TextField fullWidth label="Read-Only Period (days)" name="readOnlyPeriodDays" type="number"
                value={formik.values.readOnlyPeriodDays} onChange={formik.handleChange} />
            </Grid>
            <Grid item xs={12}>
              <TextField fullWidth label="School Tenant ID (optional)" name="tenantId"
                value={formik.values.tenantId} onChange={formik.handleChange}
                helperText="Leave empty for global plan, or enter tenant ID for school-specific plan" />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose}>Cancel</Button>
          <Button type="submit" variant="contained" color="primary">Save Plan</Button>
        </DialogActions>
      </form>
    </Dialog>
  );
};

export default PlanForm;
