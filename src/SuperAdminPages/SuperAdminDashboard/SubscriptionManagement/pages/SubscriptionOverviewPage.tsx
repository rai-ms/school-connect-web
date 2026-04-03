import React, { useEffect, useState } from 'react';
import { Box, Typography, Table, TableBody, TableCell, TableContainer, TableHead, TableRow,
  Paper, Chip, IconButton, Menu, MenuItem } from '@mui/material';
import { MoreVert } from '@mui/icons-material';
import { getSubscriptions, overrideStatus } from '../api/subscriptionAPI';

const statusColors: Record<string, 'success' | 'warning' | 'error' | 'default' | 'info'> = {
  ACTIVE: 'success', GRACE: 'warning', READ_ONLY: 'info', SUSPENDED: 'error', CANCELLED: 'default'
};

const SubscriptionOverviewPage: React.FC = () => {
  const [subscriptions, setSubscriptions] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const [selectedSub, setSelectedSub] = useState<any>(null);

  const fetchSubscriptions = async () => {
    try {
      setLoading(true);
      const response = await getSubscriptions();
      setSubscriptions(response.data || []);
    } catch (error) {
      console.error('Failed to fetch subscriptions:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchSubscriptions(); }, []);

  const handleStatusChange = async (status: string) => {
    if (selectedSub) {
      try {
        await overrideStatus(selectedSub.id, status);
        fetchSubscriptions();
      } catch (error) {
        console.error('Failed to update status:', error);
      }
    }
    setAnchorEl(null);
  };

  return (
    <Box p={3}>
      <Typography variant="h5" fontWeight="bold" mb={3}>School Subscriptions</Typography>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>School (Tenant ID)</TableCell>
              <TableCell>Plan</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Cycle</TableCell>
              <TableCell>Expires</TableCell>
              <TableCell>Next Billing</TableCell>
              <TableCell>Auto Renew</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {loading ? (
              <TableRow><TableCell colSpan={8} align="center">Loading...</TableCell></TableRow>
            ) : subscriptions.length === 0 ? (
              <TableRow><TableCell colSpan={8} align="center">No subscriptions found</TableCell></TableRow>
            ) : subscriptions.map((sub) => (
              <TableRow key={sub.id}>
                <TableCell>{sub.tenantId}</TableCell>
                <TableCell>{sub.plan?.name || '-'}</TableCell>
                <TableCell>
                  <Chip label={sub.status} size="small" color={statusColors[sub.status] || 'default'} />
                </TableCell>
                <TableCell>{sub.currentCycleStart} to {sub.currentCycleEnd}</TableCell>
                <TableCell>{sub.expiresAt}</TableCell>
                <TableCell>{sub.nextBillingDate}</TableCell>
                <TableCell>{sub.autoRenew ? 'Yes' : 'No'}</TableCell>
                <TableCell>
                  <IconButton size="small" onClick={(e) => { setAnchorEl(e.currentTarget); setSelectedSub(sub); }}>
                    <MoreVert fontSize="small" />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      <Menu anchorEl={anchorEl} open={Boolean(anchorEl)} onClose={() => setAnchorEl(null)}>
        <MenuItem onClick={() => handleStatusChange('ACTIVE')}>Set Active</MenuItem>
        <MenuItem onClick={() => handleStatusChange('SUSPENDED')}>Suspend</MenuItem>
        <MenuItem onClick={() => handleStatusChange('CANCELLED')}>Cancel</MenuItem>
      </Menu>
    </Box>
  );
};

export default SubscriptionOverviewPage;
