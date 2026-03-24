import React from 'react';
import { NavLink } from 'react-router-dom';
import {
  LayoutDashboard, School, Users, Settings, LogOut, GraduationCap,
  UserPlus, BookOpen, BookOpenText, Bell, CalendarCheck, BookOpenCheck,
  CreditCard, FileText, Calendar, MessageSquare, Database,
} from 'lucide-react';

type UserRole = 'superadmin' | 'admin' | 'teacher' | 'student' | 'parent';

interface MenuItem {
  key: string;
  icon: React.ReactNode;
  label: string;
  path?: string;
  exact?: boolean;
  roles: UserRole[];
  children?: { label: string; path: string }[];
}

interface DrawerProps {
  isOpen: boolean;
  onClose: () => void;
  onLogout: () => void;
}

const Drawer: React.FC<DrawerProps> = ({ onClose, onLogout }) => {
  const [expandedItems, setExpandedItems] = React.useState<Record<string, boolean>>({});
  const userRole = (localStorage.getItem('userRole') || 'admin') as UserRole;

  const toggleItem = (key: string) => {
    setExpandedItems(prev => ({
      ...prev,
      [key]: !prev[key]
    }));
  };

  const allMenuItems: MenuItem[] = [
    // -- Common --
    {
      key: 'dashboard',
      icon: <LayoutDashboard className="w-5 h-5" />,
      label: 'Dashboard',
      path: '/dashboard',
      exact: true,
      roles: ['superadmin', 'admin', 'teacher', 'student', 'parent'],
    },

    // -- Super Admin only --
    {
      key: 'schools',
      icon: <School className="w-5 h-5" />,
      label: 'Schools',
      roles: ['superadmin'],
      children: [
        { label: 'View Schools', path: '/dashboard/schools' },
        { label: 'Add School', path: '/dashboard/schools/add' },
      ],
    },

    // -- School Admin only --
    {
      key: 'students',
      icon: <GraduationCap className="w-5 h-5" />,
      label: 'Students',
      roles: ['admin'],
      children: [
        { label: 'View Students', path: '/dashboard/students' },
        { label: 'Add Student', path: '/dashboard/students/add' },
      ],
    },
    {
      key: 'teachers',
      icon: <UserPlus className="w-5 h-5" />,
      label: 'Teachers',
      roles: ['admin'],
      children: [
        { label: 'View Teachers', path: '/dashboard/teachers' },
        { label: 'Add Teacher', path: '/dashboard/teachers/add' },
      ],
    },
    {
      key: 'classes',
      icon: <BookOpen className="w-5 h-5" />,
      label: 'Classes',
      roles: ['admin'],
      children: [
        { label: 'View Classes', path: '/dashboard/classes' },
        { label: 'Add Class', path: '/dashboard/classes/add' },
        { label: 'Class Schedule', path: '/dashboard/classes/schedule' },
      ],
    },
    {
      key: 'subjects',
      icon: <BookOpenText className="w-5 h-5" />,
      label: 'Subjects',
      roles: ['admin'],
      children: [
        { label: 'View Subjects', path: '/dashboard/subjects' },
        { label: 'Add Subject', path: '/dashboard/subjects/add' },
      ],
    },
    {
      key: 'users',
      icon: <Users className="w-5 h-5" />,
      label: 'Users',
      path: '/dashboard/users',
      roles: ['admin'],
    },

    // -- Admin + Teacher --
    {
      key: 'attendance',
      icon: <CalendarCheck className="w-5 h-5" />,
      label: 'Attendance',
      roles: ['admin', 'teacher'],
      children: [
        { label: 'Mark Attendance', path: '/dashboard/attendance/mark' },
        { label: 'View Attendance', path: '/dashboard/attendance' },
      ],
    },
    {
      key: 'exams',
      icon: <BookOpenCheck className="w-5 h-5" />,
      label: 'Exams',
      roles: ['admin', 'teacher'],
      children: [
        { label: 'View Exams', path: '/dashboard/exams' },
        { label: 'Schedule Exam', path: '/dashboard/exams/schedule' },
        { label: 'Exam Results', path: '/dashboard/exams/results' },
      ],
    },
    {
      key: 'notices',
      icon: <Bell className="w-5 h-5" />,
      label: 'Notices',
      roles: ['admin', 'teacher', 'student', 'parent'],
      children: [
        { label: 'View Notices', path: '/dashboard/notices' },
        ...((['admin', 'teacher'] as UserRole[]).includes(userRole)
          ? [{ label: 'Add Notice', path: '/dashboard/notices/add' }]
          : []),
      ],
    },

    // -- Admin tools --
    {
      key: 'master-data',
      icon: <Database className="w-5 h-5" />,
      label: 'Master Data',
      path: '/dashboard/master-data',
      roles: ['admin'],
    },

    // -- Settings (all logged-in roles) --
    {
      key: 'settings',
      icon: <Settings className="w-5 h-5" />,
      label: 'Settings',
      path: '/dashboard/settings',
      roles: ['superadmin', 'admin', 'teacher', 'student', 'parent'],
    },
  ];

  const menuItems = allMenuItems.filter(item => item.roles.includes(userRole));

  return (
    <div 
      className={`h-full bg-white shadow-lg`}
      style={{
        height: '100vh',
        width: '100%',
        overflowY: 'auto'
      }}
    >
      <div className="flex flex-col h-full">
        {/* Logo + Role */}
        <div className="flex items-center justify-between h-16 px-4 border-b border-gray-200">
          <h1 className="text-xl font-bold text-gray-800">School Connect</h1>
          <span className={`text-xs font-semibold px-2 py-1 rounded-full ${
            userRole === 'superadmin' ? 'bg-purple-100 text-purple-700' :
            userRole === 'admin' ? 'bg-blue-100 text-blue-700' :
            userRole === 'teacher' ? 'bg-green-100 text-green-700' :
            userRole === 'student' ? 'bg-orange-100 text-orange-700' :
            'bg-gray-100 text-gray-700'
          }`}>
            {userRole === 'superadmin' ? 'Super Admin' :
             userRole === 'admin' ? 'School Admin' :
             userRole.charAt(0).toUpperCase() + userRole.slice(1)}
          </span>
        </div>

        {/* Navigation */}
        <nav className="flex-1 px-2 py-4 overflow-y-auto">
          <ul className="space-y-1">
            {menuItems.map((item) => (
              <li key={item.key || item.path}>
                {item.children ? (
                  <>
                    <button
                      onClick={() => toggleItem(item.key!)}
                      className={`flex items-center justify-between w-full px-4 py-3 text-sm font-medium rounded-lg mx-2 transition-colors ${
                        expandedItems[item.key!] ? 'text-blue-600' : 'text-gray-600 hover:bg-gray-100'
                      }`}
                    >
                      <div className="flex items-center">
                        <span className="mr-3">{item.icon}</span>
                        <span>{item.label}</span>
                      </div>
                      <svg
                        className={`w-4 h-4 transition-transform ${
                          expandedItems[item.key!] ? 'transform rotate-180' : ''
                        }`}
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                        xmlns="http://www.w3.org/2000/svg"
                      >
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                      </svg>
                    </button>
                    {expandedItems[item.key!] && (
                      <ul className="ml-8 mt-1 space-y-1">
                        {item.children.map((child, index) => (
                          <li key={`${item.key}-${index}`}>
                            <NavLink
                              to={child.path}
                              className={({ isActive }) =>
                                `flex items-center px-4 py-2 text-sm rounded-lg mx-2 transition-colors ${
                                  isActive
                                    ? 'bg-blue-50 text-blue-600 font-medium'
                                    : 'text-gray-600 hover:bg-gray-100'
                                }`
                              }
                              onClick={() => { if (window.innerWidth < 1024) onClose(); }}
                            >
                              <span className="truncate">{child.label}</span>
                            </NavLink>
                          </li>
                        ))}
                      </ul>
                    )}
                  </>
                ) : (
                  <NavLink
                    to={item.path}
                    end={item.exact}
                    className={({ isActive }) =>
                      `flex items-center px-4 py-3 text-sm font-medium rounded-lg mx-2 transition-colors ${
                        isActive
                          ? 'bg-blue-50 text-blue-600'
                          : 'text-gray-600 hover:bg-gray-100'
                      }`
                    }
                    onClick={onClose}
                  >
                    <span className="mr-3">{item.icon}</span>
                    <span className="truncate">{item.label}</span>
                  </NavLink>
                )}
              </li>
            ))}
          </ul>
        </nav>

        {/* Logout */}
        <div className="p-4 border-t border-gray-200 mt-auto">
          <button
            onClick={onLogout}
            className="flex items-center w-full px-4 py-2.5 text-sm font-medium text-red-600 rounded-lg hover:bg-red-50 transition-colors"
          >
            <LogOut className="w-5 h-5 mr-3" />
            <span>Logout</span>
          </button>
        </div>
      </div>
    </div>
  );
};

export default Drawer;
