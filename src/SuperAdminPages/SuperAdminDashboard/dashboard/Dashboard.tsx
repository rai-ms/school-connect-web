import { useState, useEffect } from 'react';
import { Users, GraduationCap, BookOpen, Building2, CalendarCheck, CreditCard } from 'lucide-react';
import { StatsCard } from './components/StatsCard';
import { AttendanceChart, PerformanceChart, FeeCollectionChart } from './components/Charts';
import { RecentActivity } from './components/RecentActivity';
import apiService from '../../../service/apiService';

interface DashboardStats {
  totalStudents: number;
  totalTeachers: number;
  totalClasses: number;
  todayAttendance: number;
  pendingFees: number;
  totalSchools: number;
}

export const Dashboard = () => {
  const [stats, setStats] = useState<DashboardStats>({
    totalStudents: 0,
    totalTeachers: 0,
    totalClasses: 0,
    todayAttendance: 0,
    pendingFees: 0,
    totalSchools: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchDashboardData = async () => {
      const role = localStorage.getItem('userRole');
      const isSuperAdmin = role === 'superadmin';

      try {
        const promises: Promise<any>[] = [
          apiService.get('/analytics/dashboard'),
        ];
        if (isSuperAdmin) {
          promises.push(apiService.get('/superadmin/tenants', { params: { page: 0, size: 1 } }));
        }

        const results = await Promise.allSettled(promises);
        let dashStats: Partial<DashboardStats> = {};

        if (results[0].status === 'fulfilled') {
          const data = results[0].value?.data || results[0].value || {};
          dashStats.totalStudents = data.totalStudents ?? data.students ?? 0;
          dashStats.totalTeachers = data.totalTeachers ?? data.teachers ?? 0;
          dashStats.totalClasses = data.totalClasses ?? data.classes ?? 0;
          dashStats.todayAttendance = data.todayAttendancePercentage ?? 0;
          dashStats.pendingFees = data.pendingFeeAmount ?? 0;
        }

        if (isSuperAdmin && results[1]?.status === 'fulfilled') {
          const data = results[1].value?.data || results[1].value || {};
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
        {localStorage.getItem('userRole') === 'superadmin' && (
          <StatsCard
            title="Total Schools"
            value={loading ? '...' : stats.totalSchools.toLocaleString()}
            icon={<Building2 className="h-5 w-5" />}
          />
        )}
        <StatsCard
          title="Total Students"
          value={loading ? '...' : stats.totalStudents.toLocaleString()}
          icon={<Users className="h-5 w-5" />}
        />
        <StatsCard
          title="Total Teachers"
          value={loading ? '...' : stats.totalTeachers.toLocaleString()}
          icon={<GraduationCap className="h-5 w-5" />}
        />
        <StatsCard
          title="Today's Attendance"
          value={loading ? '...' : `${stats.todayAttendance}%`}
          icon={<CalendarCheck className="h-5 w-5" />}
        />
        {localStorage.getItem('userRole') !== 'superadmin' && (
          <StatsCard
            title="Pending Fees"
            value={loading ? '...' : `₹${stats.pendingFees.toLocaleString('en-IN')}`}
            icon={<CreditCard className="h-5 w-5" />}
          />
        )}
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
