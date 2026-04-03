import React, { useState } from 'react';
import { Dialog, DialogTitle, DialogContent, DialogActions, Button, TextField } from '@mui/material';

interface MarkPaidModalProps {
  open: boolean;
  onClose: () => void;
  onSubmit: (data: { paymentReference: string; note: string }) => void;
  invoiceNumber: string;
}

const MarkPaidModal: React.FC<MarkPaidModalProps> = ({ open, onClose, onSubmit, invoiceNumber }) => {
  const [paymentReference, setPaymentReference] = useState('');
  const [note, setNote] = useState('');

  const handleSubmit = () => {
    onSubmit({ paymentReference, note });
    setPaymentReference('');
    setNote('');
    onClose();
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <DialogTitle>Mark Invoice {invoiceNumber} as Paid</DialogTitle>
      <DialogContent>
        <TextField fullWidth label="Payment Reference (UTR/Cheque No.)" value={paymentReference}
          onChange={(e) => setPaymentReference(e.target.value)} margin="normal" required />
        <TextField fullWidth label="Note" value={note} multiline rows={2}
          onChange={(e) => setNote(e.target.value)} margin="normal" />
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose}>Cancel</Button>
        <Button variant="contained" color="primary" onClick={handleSubmit}
          disabled={!paymentReference.trim()}>
          Mark as Paid
        </Button>
      </DialogActions>
    </Dialog>
  );
};

export default MarkPaidModal;
