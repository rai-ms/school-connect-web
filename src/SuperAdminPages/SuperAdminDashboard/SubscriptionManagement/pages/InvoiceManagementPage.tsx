import React, { useEffect, useState } from 'react';
import { Box, Typography, Table, TableBody, TableCell, TableContainer, TableHead, TableRow,
  Paper, Chip, IconButton, Menu, MenuItem } from '@mui/material';
import { MoreVert } from '@mui/icons-material';
import MarkPaidModal from '../components/MarkPaidModal';
import { getInvoices, markPaid, cancelInvoice } from '../api/subscriptionAPI';

const statusColors: Record<string, 'success' | 'warning' | 'error' | 'default' | 'info'> = {
  PAID: 'success', PENDING: 'warning', OVERDUE: 'error', CANCELLED: 'default', DRAFT: 'info'
};

const InvoiceManagementPage: React.FC = () => {
  const [invoices, setInvoices] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const [selectedInvoice, setSelectedInvoice] = useState<any>(null);
  const [markPaidOpen, setMarkPaidOpen] = useState(false);

  const fetchInvoices = async () => {
    try {
      setLoading(true);
      const response = await getInvoices();
      const data = response.data;
      setInvoices(data.content || data || []);
    } catch (error) {
      console.error('Failed to fetch invoices:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { fetchInvoices(); }, []);

  const handleMarkPaid = async (data: { paymentReference: string; note: string }) => {
    if (selectedInvoice) {
      try {
        await markPaid(selectedInvoice.id, data);
        fetchInvoices();
      } catch (error) {
        console.error('Failed to mark as paid:', error);
      }
    }
  };

  const handleCancel = async () => {
    if (selectedInvoice) {
      try {
        await cancelInvoice(selectedInvoice.id);
        fetchInvoices();
      } catch (error) {
        console.error('Failed to cancel invoice:', error);
      }
    }
    setAnchorEl(null);
  };

  return (
    <Box p={3}>
      <Typography variant="h5" fontWeight="bold" mb={3}>Invoices</Typography>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Invoice #</TableCell>
              <TableCell>Tenant</TableCell>
              <TableCell>Period</TableCell>
              <TableCell>Students</TableCell>
              <TableCell>Amount</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Due Date</TableCell>
              <TableCell>Payment</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {loading ? (
              <TableRow><TableCell colSpan={9} align="center">Loading...</TableCell></TableRow>
            ) : invoices.length === 0 ? (
              <TableRow><TableCell colSpan={9} align="center">No invoices found</TableCell></TableRow>
            ) : invoices.map((inv) => (
              <TableRow key={inv.id}>
                <TableCell>{inv.invoiceNumber}</TableCell>
                <TableCell>{inv.tenantId}</TableCell>
                <TableCell>{inv.billingPeriodStart} - {inv.billingPeriodEnd}</TableCell>
                <TableCell>{inv.billableStudentCount}</TableCell>
                <TableCell>₹{inv.totalAmount}</TableCell>
                <TableCell>
                  <Chip label={inv.status} size="small" color={statusColors[inv.status] || 'default'} />
                </TableCell>
                <TableCell>{inv.dueDate}</TableCell>
                <TableCell>{inv.paymentMode || '-'}</TableCell>
                <TableCell>
                  <IconButton size="small" onClick={(e) => { setAnchorEl(e.currentTarget); setSelectedInvoice(inv); }}>
                    <MoreVert fontSize="small" />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      <Menu anchorEl={anchorEl} open={Boolean(anchorEl)} onClose={() => setAnchorEl(null)}>
        <MenuItem onClick={() => { setMarkPaidOpen(true); setAnchorEl(null); }}
          disabled={selectedInvoice?.status === 'PAID'}>
          Mark as Paid
        </MenuItem>
        <MenuItem onClick={handleCancel}
          disabled={selectedInvoice?.status === 'PAID' || selectedInvoice?.status === 'CANCELLED'}>
          Cancel Invoice
        </MenuItem>
      </Menu>

      {selectedInvoice && (
        <MarkPaidModal
          open={markPaidOpen}
          onClose={() => setMarkPaidOpen(false)}
          onSubmit={handleMarkPaid}
          invoiceNumber={selectedInvoice.invoiceNumber}
        />
      )}
    </Box>
  );
};

export default InvoiceManagementPage;
