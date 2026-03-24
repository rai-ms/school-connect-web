import { useState, useEffect } from 'react';
import { Bell, Users, CheckCircle, Clock, FileText, AlertCircle } from 'lucide-react';
import apiService from '../../../../service/apiService';

interface Activity {
  id: string;
  event: string;
  time: string;
  type: string;
  status: 'completed' | 'pending';
}

const getIcon = (type: string) => {
  switch (type) {
    case 'USER': case 'STUDENT': case 'TEACHER': return <Users className="h-4 w-4" />;
    case 'ANNOUNCEMENT': return <Bell className="h-4 w-4" />;
    default: return <FileText className="h-4 w-4" />;
  }
};

const formatTime = (timestamp: string | number[]) => {
  try {
    let date: Date;
    if (Array.isArray(timestamp)) {
      date = new Date(timestamp[0], (timestamp[1] || 1) - 1, timestamp[2] || 1,
        timestamp[3] || 0, timestamp[4] || 0, timestamp[5] || 0);
    } else {
      date = new Date(timestamp);
    }
    const now = new Date();
    const diff = now.getTime() - date.getTime();
    const mins = Math.floor(diff / 60000);
    if (mins < 1) return 'Just now';
    if (mins < 60) return `${mins}m ago`;
    const hours = Math.floor(mins / 60);
    if (hours < 24) return `${hours}h ago`;
    const days = Math.floor(hours / 24);
    if (days === 1) return 'Yesterday';
    if (days < 7) return `${days} days ago`;
    return date.toLocaleDateString();
  } catch {
    return '';
  }
};

export const RecentActivity = () => {
  const [activities, setActivities] = useState<Activity[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [logsRes, announcementsRes] = await Promise.allSettled([
          apiService.get('/audit-logs', { params: { page: 0, size: 5 } }),
          apiService.get('/announcements', { params: { page: 0, size: 5 } }),
        ]);

        const items: Activity[] = [];

        if (logsRes.status === 'fulfilled') {
          const logs = logsRes.value?.content || logsRes.value?.data?.content || [];
          logs.forEach((log: any) => {
            items.push({
              id: `log-${log.id}`,
              event: `${log.action || log.operation || 'Action'}: ${log.entityType || log.resource || ''} ${log.details || ''}`.trim(),
              time: formatTime(log.timestamp || log.createdAt),
              type: log.entityType || 'OTHER',
              status: 'completed',
            });
          });
        }

        if (announcementsRes.status === 'fulfilled') {
          const announcements = announcementsRes.value?.content || announcementsRes.value?.data?.content || [];
          announcements.forEach((a: any) => {
            items.push({
              id: `ann-${a.id}`,
              event: `Notice: ${a.title || a.subject || 'Announcement'}`,
              time: formatTime(a.createdAt || a.publishDate),
              type: 'ANNOUNCEMENT',
              status: 'completed',
            });
          });
        }

        // Sort by most recent first (keep order from API which is already sorted)
        setActivities(items.slice(0, 8));
      } catch (err) {
        console.error('Error fetching recent activity:', err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  return (
    <div className="bg-white p-6 rounded-lg shadow">
      <h3 className="text-lg font-medium mb-4">Recent Activity</h3>
      <div className="space-y-4">
        {loading ? (
          <div className="py-8 text-center text-gray-400">Loading...</div>
        ) : activities.length === 0 ? (
          <div className="py-8 text-center text-gray-400">
            <AlertCircle className="h-8 w-8 mx-auto mb-2 text-gray-300" />
            <p>No recent activity yet.</p>
            <p className="text-xs mt-1">Activities will appear here as you use the system.</p>
          </div>
        ) : (
          activities.map((activity) => (
            <div key={activity.id} className="flex items-start space-x-3 group">
              <div className={`p-2 rounded-full ${
                activity.status === 'completed' ? 'bg-green-50 text-green-600' : 'bg-blue-50 text-blue-600'
              }`}>
                {activity.status === 'completed' ? (
                  <CheckCircle className="h-4 w-4" />
                ) : (
                  <Clock className="h-4 w-4" />
                )}
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center justify-between">
                  <p className="text-sm font-medium truncate">{activity.event}</p>
                  <span className="text-xs text-gray-500 ml-2 flex-shrink-0">{activity.time}</span>
                </div>
                <div className="flex items-center mt-1 text-xs text-gray-500">
                  <span className="flex items-center">
                    <span className="mr-1">{getIcon(activity.type)}</span>
                    {activity.status === 'completed' ? 'Completed' : 'Pending'}
                  </span>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};
