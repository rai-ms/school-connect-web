import { useState, useEffect } from 'react';
import {
  LineChart, BarChart, PieChart, Pie, Bar, Line, XAxis, YAxis,
  CartesianGrid, Tooltip, Legend, ResponsiveContainer, Cell,
} from 'recharts';
import apiService from '../../../../service/apiService';

const COLORS = ['#3b82f6', '#f97316', '#ef4444'];

export const AttendanceChart = () => {
  const [data, setData] = useState<{ name: string; attendance: number }[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await apiService.get('/analytics/attendance/trend');
        const trend = res?.data?.trend || res?.trend || [];
        const last7 = trend.slice(-7);
        const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        const mapped = last7.map((item: any) => {
          const dateArr = item.date;
          const d = new Date(dateArr[0], dateArr[1] - 1, dateArr[2]);
          return {
            name: days[d.getDay()],
            attendance: Math.round(item.percentage || 0),
          };
        });
        setData(mapped.length > 0 ? mapped : []);
      } catch (err) {
        console.error('Error fetching attendance trend:', err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  const isEmpty = data.length === 0 || data.every(d => d.attendance === 0);

  return (
    <div className="bg-white p-6 rounded-lg shadow">
      <h3 className="text-lg font-medium mb-4">Weekly Attendance</h3>
      <div className="h-64">
        {loading ? (
          <div className="h-full flex items-center justify-center text-gray-400">Loading...</div>
        ) : isEmpty ? (
          <div className="h-full flex items-center justify-center text-gray-400">
            No attendance data yet. Mark attendance to see trends.
          </div>
        ) : (
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={data}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="name" />
              <YAxis domain={[0, 100]} />
              <Tooltip formatter={(value: number) => `${value}%`} />
              <Legend />
              <Line
                type="monotone"
                dataKey="attendance"
                stroke="#3b82f6"
                strokeWidth={2}
                dot={{ r: 4 }}
                activeDot={{ r: 6 }}
                name="Attendance %"
              />
            </LineChart>
          </ResponsiveContainer>
        )}
      </div>
    </div>
  );
};

export const PerformanceChart = () => {
  const [data, setData] = useState<{ grade: string; students: number }[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await apiService.get('/analytics/exam/performance');
        const dist = res?.data?.gradeDistribution || res?.gradeDistribution || {};
        const grades = ['A', 'B', 'C', 'D', 'F'];
        const mapped = grades.map(g => ({
          grade: g,
          students: dist[g] || dist[g.toLowerCase()] || 0,
        }));
        setData(mapped);
      } catch (err) {
        console.error('Error fetching exam performance:', err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  const isEmpty = data.every(d => d.students === 0);

  return (
    <div className="bg-white p-6 rounded-lg shadow">
      <h3 className="text-lg font-medium mb-4">Student Performance</h3>
      <div className="h-64">
        {loading ? (
          <div className="h-full flex items-center justify-center text-gray-400">Loading...</div>
        ) : isEmpty ? (
          <div className="h-full flex items-center justify-center text-gray-400">
            No exam results yet. Conduct exams to see performance.
          </div>
        ) : (
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={data}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
              <XAxis dataKey="grade" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Bar dataKey="students" fill="#10b981" name="Students" radius={[4, 4, 0, 0]}>
                {data.map((_, index) => (
                  <Cell key={`cell-${index}`} fill={`rgba(16, 185, 129, ${1 - index * 0.15})`} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        )}
      </div>
    </div>
  );
};

export const FeeCollectionChart = () => {
  const [feeData, setFeeData] = useState({ collected: 0, pending: 0, overdue: 0 });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await apiService.get('/analytics/fee/summary');
        const d = res?.data || res || {};
        setFeeData({
          collected: d.totalCollected || 0,
          pending: d.totalPending || 0,
          overdue: d.totalOverdue || 0,
        });
      } catch (err) {
        console.error('Error fetching fee summary:', err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  const total = feeData.collected + feeData.pending + feeData.overdue;
  const pieData = [
    { name: 'Collected', value: feeData.collected },
    { name: 'Pending', value: feeData.pending },
    { name: 'Overdue', value: feeData.overdue },
  ].filter(d => d.value > 0);

  const formatCurrency = (val: number) =>
    new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 }).format(val);

  return (
    <div className="bg-white p-6 rounded-lg shadow">
      <h3 className="text-lg font-medium mb-4">Fee Collection Overview</h3>
      <div className="h-64 flex flex-col items-center">
        {loading ? (
          <div className="h-full flex items-center justify-center text-gray-400">Loading...</div>
        ) : total === 0 ? (
          <div className="h-full flex items-center justify-center text-gray-400">
            No fee data yet. Set up fee structure to track collection.
          </div>
        ) : (
          <>
            <div className="w-full h-48">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={pieData}
                    cx="50%"
                    cy="50%"
                    innerRadius={60}
                    outerRadius={80}
                    paddingAngle={5}
                    dataKey="value"
                    label={({ name, percent = 0 }) => `${name} ${(percent * 100).toFixed(0)}%`}
                  >
                    {pieData.map((_, index) => (
                      <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                    ))}
                  </Pie>
                  <Tooltip formatter={(value: number) => formatCurrency(value)} />
                  <Legend />
                </PieChart>
              </ResponsiveContainer>
            </div>
            <p className="mt-4 text-sm text-gray-500">
              Total Collected: <span className="font-medium">{formatCurrency(feeData.collected)}</span>
            </p>
          </>
        )}
      </div>
    </div>
  );
};
