import { useState, useEffect } from 'react';
import { Users, GraduationCap, BookOpen, Bell, Building2 } from 'lucide-react';
import { StatsCard } from './components/StatsCard';
import { AttendanceChart, PerformanceChart, FeeCollectionChart } from './components/Charts';
import { RecentActivity } from './components/RecentActivity';
import axios from 'axios';
import { ANALYTICS_ENDPOINTS, SUPER_ADMIN_ENDPOINTS } from '../../../config/api.config';

interface DashboardStats {
  totalStudents: number;
  totalTeachers: number;
  totalClasses: number;
  activeNotices: number;
  totalSchools: number;
}

export const Dashboard = () => {
  const [stats, setStats] = useState<DashboardStats>({
    totalStudents: 0,
    totalTeachers: 0,
    totalClasses: 0,
    activeNotices: 0,
    totalSchools: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchDashboardData = async () => {
      const token = localStorage.getItem('authToken');
      const headers = token ? { Authorization: `Bearer ${token}` } : {};

      try {
        const [analyticsRes, tenantsRes] = await Promise.allSettled([
          axios.get(ANALYTICS_ENDPOINTS.DASHBOARD, { headers }),
          axios.get(SUPER_ADMIN_ENDPOINTS.TENANTS, { headers, params: { page: 0, size: 1 } }),
        ]);

        let dashStats: Partial<DashboardStats> = {};

        if (analyticsRes.status === 'fulfilled') {
          const data = analyticsRes.value.data?.data || analyticsRes.value.data || {};
          dashStats.totalStudents = data.totalStudents ?? data.students ?? 0;
          dashStats.totalTeachers = data.totalTeachers ?? data.teachers ?? 0;
          dashStats.totalClasses = data.totalClasses ?? data.classes ?? 0;
          dashStats.activeNotices = data.activeNotices ?? data.notices ?? 0;
        }

        if (tenantsRes.status === 'fulfilled') {
          const data = tenantsRes.value.data?.data || tenantsRes.value.data || {};
          dashStats.totalSchools = data.totalElements ?? data.total ?? 0;
        }

        setStats(prev => ({ ...prev, ...dashStats }));
      } catch (error) {
        console.error('Error fetching dashboard data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchDashboardData();
  }, []);

  const userName = localStorage.getItem('userName') || 'Admin';

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Welcome, {userName}</h1>
          <p className="text-muted-foreground">
            Here's what's happening with your school today.
          </p>
        </div>
        <div className="mt-4 md:mt-0">
          <div className="flex items-center space-x-2 text-sm text-gray-500">
            <span>{new Date().toLocaleDateString('en-US', {
              weekday: 'long',
              year: 'numeric',
              month: 'long',
              day: 'numeric'
            })}</span>
          </div>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <StatsCard
          title="Total Students"
          value={loading ? '...' : stats.totalStudents.toLocaleString()}
          icon={<Users className="h-5 w-5" />}
          trend={0}
          trendLabel=""
        />
        <StatsCard
          title="Total Teachers"
          value={loading ? '...' : stats.totalTeachers.toLocaleString()}
          icon={<GraduationCap className="h-5 w-5" />}
          trend={0}
          trendLabel=""
        />
        <StatsCard
          title="Total Classes"
          value={loading ? '...' : stats.totalClasses.toLocaleString()}
          icon={<BookOpen className="h-5 w-5" />}
          trend={0}
          trendLabel=""
        />
        <StatsCard
          title="Total Schools"
          value={loading ? '...' : stats.totalSchools.toLocaleString()}
          icon={<Building2 className="h-5 w-5" />}
          trend={0}
          trendLabel=""
        />
      </div>

      {/* Charts Section */}
      <div className="grid gap-6 md:grid-cols-2">
        <div className="space-y-6">
          <AttendanceChart />
          <PerformanceChart />
        </div>
        <div className="space-y-6">
          <FeeCollectionChart />
          <RecentActivity />
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
