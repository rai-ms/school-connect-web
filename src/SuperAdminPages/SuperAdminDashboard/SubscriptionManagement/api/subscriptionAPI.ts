import apiService from '../../../../service/apiService';
import { SUBSCRIPTION_ENDPOINTS } from '../../../../config/api.config';

// Plans
export const createPlan = (data: any) => apiService.post(SUBSCRIPTION_ENDPOINTS.PLANS, data);
export const getPlans = () => apiService.get(SUBSCRIPTION_ENDPOINTS.PLANS);
export const updatePlan = (id: string, data: any) => apiService.put(SUBSCRIPTION_ENDPOINTS.PLAN_BY_ID(id), data);
export const deletePlan = (id: string) => apiService.delete(SUBSCRIPTION_ENDPOINTS.PLAN_BY_ID(id));

// Subscriptions
export const assignSubscription = (data: any) => apiService.post(SUBSCRIPTION_ENDPOINTS.SUBSCRIPTIONS, data);
export const getSubscriptions = () => apiService.get(SUBSCRIPTION_ENDPOINTS.SUBSCRIPTIONS);
export const getSubscriptionByTenant = (tenantId: string) => apiService.get(SUBSCRIPTION_ENDPOINTS.SUBSCRIPTION_BY_TENANT(tenantId));
export const overrideStatus = (id: string, status: string) => apiService.put(SUBSCRIPTION_ENDPOINTS.SUBSCRIPTION_STATUS(id), { status });

// Invoices
export const getInvoices = (page = 0, size = 20) => apiService.get(`${SUBSCRIPTION_ENDPOINTS.INVOICES}?page=${page}&size=${size}`);
export const getInvoiceById = (id: string) => apiService.get(SUBSCRIPTION_ENDPOINTS.INVOICE_BY_ID(id));
export const markPaid = (id: string, data: any) => apiService.post(SUBSCRIPTION_ENDPOINTS.MARK_PAID(id), data);
export const cancelInvoice = (id: string) => apiService.post(SUBSCRIPTION_ENDPOINTS.CANCEL_INVOICE(id), {});
export const generateInvoice = (tenantId: string) => apiService.post(SUBSCRIPTION_ENDPOINTS.GENERATE_INVOICE(tenantId), {});
export const adjustInvoice = (id: string, data: any) => apiService.post(SUBSCRIPTION_ENDPOINTS.ADJUST_INVOICE(id), data);
