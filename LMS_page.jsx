import React, { useState, useEffect, useRef } from 'react';
import { MessageCircle, X, Send, BookOpen, FileText, BarChart3, Bell, LogOut, ArrowLeft, Download } from 'lucide-react';

// Import your AIChatbot component here
import AIChatbot from './Redesigned';

const StudentPortal = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [currentPage, setCurrentPage] = useState('dashboard');
  const [isChatbotOpen, setIsChatbotOpen] = useState(false);
  const [chatMessages, setChatMessages] = useState([
    { id: 1, text: "Hello! I'm your student assistant. How can I help you today?", sender: 'bot', timestamp: new Date().toLocaleTimeString() }
  ]);
  const [chatInput, setChatInput] = useState('');
  const [loginError, setLoginError] = useState('');
  const [formData, setFormData] = useState({ rollNumber: '', password: '' });
  
  const chatMessagesRef = useRef(null);

  // Auto-scroll chat messages
  useEffect(() => {
    if (chatMessagesRef.current) {
      chatMessagesRef.current.scrollTop = chatMessagesRef.current.scrollHeight;
    }
  }, [chatMessages]);

  // Student data (dynamic)
  const [studentData, setStudentData] = useState(null);

  // Dynamic LMS data states
  const [courses, setCourses] = useState([]);
  const [assignments, setAssignments] = useState([]);
  const [attendanceData, setAttendanceData] = useState([]);
  const [marksData, setMarksData] = useState([]);
  const [circulars, setCirculars] = useState([]);

  // Fetch all LMS data after successful login
  useEffect(() => {
    if (isAuthenticated && studentData) {
      // Courses
      fetch(`http://localhost:5000/courses/${studentData.roll_no}`)
        .then(res => res.json())
        .then(data => setCourses(data.subjects || []));

      // Assignments
      fetch(`http://localhost:5000/assignments/${studentData.roll_no}`)
        .then(res => res.json())
        .then(data => setAssignments(data.assignments || []));

      // Attendance
      fetch(`http://localhost:5000/attendance/${studentData.roll_no}`)
        .then(res => res.json())
        .then(data => setAttendanceData(data.attendance || []));

      // Marks
      fetch(`http://localhost:5000/marks/${studentData.roll_no}`)
        .then(res => res.json())
        .then(data => setMarksData(data.marks || []));

      // Circulars (no roll_no needed)
      fetch(`http://localhost:5000/circulars`)
        .then(res => res.json())
        .then(data => setCirculars(data.circulars || []));
    }
  }, [isAuthenticated, studentData]);

  // Login handler
  const handleLogin = () => {
    // Send POST to /login with rollNumber and password
    fetch('http://localhost:5000/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ rollNumber: formData.rollNumber, password: formData.password })
    })
      .then(res => {
        if (!res.ok) {
          if (res.status === 401) throw new Error('Invalid credentials. Please check your roll number and password.');
          if (res.status === 400) throw new Error('Please enter both roll number and password.');
          throw new Error('Login failed.');
        }
        return res.json();
      })
      .then(data => {
        setStudentData(data);
        setIsAuthenticated(true);
        setLoginError('');
      })
      .catch(err => {
        setLoginError(err.message);
      });
  };

  // Logout handler
  const handleLogout = () => {
  setIsAuthenticated(false);
  setCurrentPage('dashboard');
  setFormData({ rollNumber: '', password: '' });
  setLoginError('');
  setStudentData(null);
  };

  // Chat functions
  const sendChatMessage = () => {
    if (!chatInput.trim()) return;

    const userMessage = {
      id: Date.now(),
      text: chatInput,
      sender: 'user',
      timestamp: new Date().toLocaleTimeString()
    };

    setChatMessages(prev => [...prev, userMessage]);

    // Generate bot response
    setTimeout(() => {
      const botResponse = generateBotResponse(chatInput);
      const botMessage = {
        id: Date.now() + 1,
        text: botResponse,
        sender: 'bot',
        timestamp: new Date().toLocaleTimeString()
      };
      setChatMessages(prev => [...prev, botMessage]);
    }, 1000);

    setChatInput('');
  };

  const generateBotResponse = (message) => {
    const lowerMessage = message.toLowerCase();
    if (lowerMessage.includes('attendance')) {
      return "You can check your attendance in the Attendance & Marks section. Your overall attendance is looking good!";
    } else if (lowerMessage.includes('assignment')) {
      return "You have pending assignments in Java and Mathematics. Check the Assignments section for details.";
    } else if (lowerMessage.includes('marks') || lowerMessage.includes('result')) {
      return "Your results are available in the Attendance & Marks section. Great job on your grades!";
    } else if (lowerMessage.includes('course')) {
      return "You can find all course materials including notes and PPTs in the Courses section.";
    } else if (lowerMessage.includes('circular') || lowerMessage.includes('notice')) {
      return "Check the Circulars section for the latest announcements including exam timetables and scholarship deadlines.";
    }
    return "I'm here to help! This is a placeholder chatbot. You can replace this with your real chatbot implementation.";
  };

  const handleChatKeyPress = (e) => {
    if (e.key === 'Enter') {
      sendChatMessage();
    }
  };

  // Login Page Component
  const LoginPage = () => (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-xl p-10 w-full max-w-md border border-gray-200">
        <div className="text-center mb-8">
          <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <BookOpen className="w-8 h-8 text-green-500" />
          </div>
          <h1 className="text-3xl font-bold text-gray-800 mb-2">Student Portal</h1>
          <p className="text-gray-600">Welcome back! Please login to your account.</p>
        </div>
        
        <div className="space-y-5">
          <div>
            <label className="block text-gray-700 font-medium mb-2">Roll Number</label>
            <input
              type="text"
              value={formData.rollNumber}
              onChange={(e) => setFormData({...formData, rollNumber: e.target.value})}
              placeholder="Enter your roll number"
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 focus:outline-none transition-all"
              required
            />
          </div>
          
          <div>
            <label className="block text-gray-700 font-medium mb-2">Password</label>
            <input
              type="password"
              value={formData.password}
              onChange={(e) => setFormData({...formData, password: e.target.value})}
              placeholder="Enter your password"
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 focus:outline-none transition-all"
              required
            />
          </div>
          
          <button
            type="button"
            onClick={handleLogin}
            className="w-full bg-blue-500 hover:bg-blue-600 text-white py-3 rounded-lg font-medium transition-all duration-200 hover:transform hover:-translate-y-0.5"
          >
            Login
          </button>
          
          {loginError && (
            <div className="text-red-500 text-sm text-center bg-red-50 p-3 rounded-lg">{loginError}</div>
          )}
        </div>
        
        <div className="mt-6 text-center text-sm text-gray-600 bg-gray-50 p-4 rounded-lg">
          <p><strong>Demo Credentials:</strong></p>
          <p>Roll Number: ITM123</p>
          <p>Password: 12345</p>
        </div>
      </div>
    </div>
  );

  // Header Component
  const Header = ({ title }) => (
    <div className="bg-white border-b border-gray-200 shadow-sm p-6 flex justify-between items-center">
      <h1 className="text-2xl font-bold text-gray-800">{title}</h1>
      <button
        onClick={handleLogout}
        className="bg-gray-100 hover:bg-gray-200 text-gray-700 px-4 py-2 rounded-lg transition-colors flex items-center space-x-2"
      >
        <LogOut className="w-4 h-4" />
        <span>Logout</span>
      </button>
    </div>
  );

  // Dashboard Component
  const Dashboard = () => (
    <div>
      <Header title="Student Dashboard" />
      <div className="p-8 bg-gray-50 min-h-screen">
        {/* Student Info */}
        {studentData ? (
          <div className="bg-gradient-to-r from-green-400 to-blue-500 text-white p-6 rounded-xl mb-8 shadow-lg">
            <h2 className="text-2xl font-bold mb-4">Welcome, {studentData.name}!</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
              <div className="bg-white bg-opacity-20 p-4 rounded-lg backdrop-blur-sm">
                <strong className="block text-sm opacity-80 mb-1">Roll Number</strong>
                {studentData.roll_no}
              </div>
              <div className="bg-white bg-opacity-20 p-4 rounded-lg backdrop-blur-sm">
                <strong className="block text-sm opacity-80 mb-1">Course</strong>
                {studentData.course_name}
              </div>
              <div className="bg-white bg-opacity-20 p-4 rounded-lg backdrop-blur-sm">
                <strong className="block text-sm opacity-80 mb-1">Year</strong>
                {studentData.year || '-'}
              </div>
              <div className="bg-white bg-opacity-20 p-4 rounded-lg backdrop-blur-sm">
                <strong className="block text-sm opacity-80 mb-1">Semester</strong>
                {studentData.semester || '-'}
              </div>
            </div>
          </div>
        ) : (
          <div className="bg-white text-gray-700 p-6 rounded-xl mb-8 shadow-lg">Loading student info...</div>
        )}

        {/* Navigation Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div
            onClick={() => setCurrentPage('courses')}
            className="bg-white border border-gray-200 rounded-xl p-6 text-center cursor-pointer hover:border-blue-300 hover:shadow-lg hover:transform hover:-translate-y-1 transition-all"
          >
            <BookOpen className="w-12 h-12 text-blue-500 mx-auto mb-4" />
            <h3 className="font-bold text-gray-800 mb-2">Courses</h3>
            <p className="text-gray-600 text-sm">View course materials, notes, and PPTs</p>
          </div>
          <div
            onClick={() => setCurrentPage('assignments')}
            className="bg-white border border-gray-200 rounded-xl p-6 text-center cursor-pointer hover:border-blue-300 hover:shadow-lg hover:transform hover:-translate-y-1 transition-all"
          >
            <FileText className="w-12 h-12 text-blue-500 mx-auto mb-4" />
            <h3 className="font-bold text-gray-800 mb-2">Assignments</h3>
            <p className="text-gray-600 text-sm">Submit assignments and view deadlines</p>
          </div>
          <div
            onClick={() => setCurrentPage('attendance')}
            className="bg-white border border-gray-200 rounded-xl p-6 text-center cursor-pointer hover:border-blue-300 hover:shadow-lg hover:transform hover:-translate-y-1 transition-all"
          >
            <BarChart3 className="w-12 h-12 text-blue-500 mx-auto mb-4" />
            <h3 className="font-bold text-gray-800 mb-2">Attendance & Marks</h3>
            <p className="text-gray-600 text-sm">Check your attendance and exam results</p>
          </div>
          <div
            onClick={() => setCurrentPage('circulars')}
            className="bg-white border border-gray-200 rounded-xl p-6 text-center cursor-pointer hover:border-blue-300 hover:shadow-lg hover:transform hover:-translate-y-1 transition-all"
          >
            <Bell className="w-12 h-12 text-blue-500 mx-auto mb-4" />
            <h3 className="font-bold text-gray-800 mb-2">Circulars</h3>
            <p className="text-gray-600 text-sm">Important notices and announcements</p>
          </div>
        </div>
      </div>
    </div>
  );

  // Courses Page
  const CoursesPage = () => (
    <div>
      <Header title="My Courses" />
      <div className="p-8 bg-gray-50 min-h-screen">
        <div className="flex justify-between items-center mb-8">
          <h2 className="text-3xl font-bold text-gray-800">Course Materials</h2>
          <button
            onClick={() => setCurrentPage('dashboard')}
            className="bg-gray-600 text-white px-6 py-3 rounded-lg hover:bg-gray-700 transition-colors flex items-center space-x-2"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Back to Dashboard</span>
          </button>
        </div>
        <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
          {courses.length === 0 ? (
            <div className="text-gray-600">No courses found.</div>
          ) : (
            courses.map((course, index) => (
              <div key={index} className="bg-white border border-gray-200 rounded-xl p-6 shadow-md hover:shadow-lg transition-shadow">
                <h3 className="text-xl font-bold text-gray-800 mb-4">{course.subject_name || course.title}</h3>
                <p className="text-gray-600 mb-2"><strong>Course Code:</strong> {course.subject_code || course.code}</p>
                <p className="text-gray-600 mb-2"><strong>Credits:</strong> {course.credits}</p>
                <p className="text-gray-600 mb-4"><strong>Instructor:</strong> {course.teacher_name || course.instructor}</p>
                {/* Materials if available */}
                {course.materials && (
                  <div className="flex flex-wrap gap-2">
                    {course.materials.map((material, idx) => (
                      <button
                        key={idx}
                        className="bg-blue-500 text-white px-4 py-2 rounded-lg text-sm hover:bg-blue-600 transition-colors"
                      >
                        {material}
                      </button>
                    ))}
                  </div>
                )}
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );

  // Assignments Page
  const AssignmentsPage = () => (
    <div>
      <Header title="Assignments" />
      <div className="p-8 bg-gray-50 min-h-screen">
        <div className="flex justify-between items-center mb-8">
          <h2 className="text-3xl font-bold text-gray-800">Pending Assignments</h2>
          <button
            onClick={() => setCurrentPage('dashboard')}
            className="bg-gray-600 text-white px-6 py-3 rounded-lg hover:bg-gray-700 transition-colors flex items-center space-x-2"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Back to Dashboard</span>
          </button>
        </div>
        <div className="bg-white rounded-xl shadow-lg overflow-hidden border border-gray-200">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-gray-800 text-white">
                  <th className="px-6 py-4 text-left font-semibold">Assignment</th>
                  <th className="px-6 py-4 text-left font-semibold">Course</th>
                  <th className="px-6 py-4 text-left font-semibold">Due Date</th>
                  <th className="px-6 py-4 text-left font-semibold">Status</th>
                  <th className="px-6 py-4 text-left font-semibold">Action</th>
                </tr>
              </thead>
              <tbody>
                {assignments.length === 0 ? (
                  <tr><td colSpan="5" className="text-center text-gray-600 py-4">No assignments found.</td></tr>
                ) : (
                  assignments.map((assignment, idx) => (
                    <tr key={assignment.id || idx} className="border-b border-gray-100 hover:bg-gray-50">
                      <td className="px-6 py-4 text-gray-800">{assignment.title}</td>
                      <td className="px-6 py-4 text-gray-600">{assignment.course || assignment.subject_name}</td>
                      <td className="px-6 py-4 text-gray-600">{assignment.dueDate || assignment.due_date}</td>
                      <td className="px-6 py-4">
                        <span className={`px-3 py-1 rounded-full text-xs font-medium ${
                          assignment.status === 'Submitted' ? 'bg-green-100 text-green-800' :
                          assignment.status === 'In Progress' ? 'bg-yellow-100 text-yellow-800' :
                          'bg-red-100 text-red-800'
                        }`}>
                          {assignment.status || 'Pending'}
                        </span>
                      </td>
                      <td className="px-6 py-4">
                        <button
                          className={`px-4 py-2 rounded text-xs font-medium ${
                            assignment.status === 'Submitted' 
                              ? 'bg-gray-300 text-gray-600 cursor-not-allowed'
                              : 'bg-green-500 text-white hover:bg-green-600'
                          }`}
                          disabled={assignment.status === 'Submitted'}
                        >
                          {assignment.status === 'Submitted' ? 'View' : 
                           assignment.status === 'In Progress' ? 'Continue' : 'Submit'}
                        </button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );

  // Attendance Page
  const AttendancePage = () => (
    <div>
      <Header title="Attendance & Marks" />
      <div className="p-8 bg-gray-50 min-h-screen">
        <div className="flex justify-between items-center mb-8">
          <h2 className="text-3xl font-bold text-gray-800">Academic Performance</h2>
          <button
            onClick={() => setCurrentPage('dashboard')}
            className="bg-gray-600 text-white px-6 py-3 rounded-lg hover:bg-gray-700 transition-colors flex items-center space-x-2"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Back to Dashboard</span>
          </button>
        </div>
        {/* Attendance Table */}
        <h3 className="text-xl font-bold text-gray-800 mb-4">Attendance Record</h3>
        <div className="bg-white rounded-xl shadow-lg overflow-hidden mb-8 border border-gray-200">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-gray-800 text-white">
                  <th className="px-6 py-4 text-left font-semibold">Subject</th>
                  <th className="px-6 py-4 text-left font-semibold">Total Classes</th>
                  <th className="px-6 py-4 text-left font-semibold">Present</th>
                  <th className="px-6 py-4 text-left font-semibold">Absent</th>
                  <th className="px-6 py-4 text-left font-semibold">Attendance %</th>
                </tr>
              </thead>
              <tbody>
                {attendanceData.length === 0 ? (
                  <tr><td colSpan="5" className="text-center text-gray-600 py-4">No attendance data found.</td></tr>
                ) : (
                  attendanceData.map((record, idx) => (
                    <tr key={idx} className="border-b border-gray-100 hover:bg-gray-50">
                      <td className="px-6 py-4 text-gray-800">{record.subject || record.subject_name}</td>
                      <td className="px-6 py-4 text-gray-600">{record.total || record.total_classes}</td>
                      <td className="px-6 py-4 text-gray-600">{record.present || record.present_count}</td>
                      <td className="px-6 py-4 text-gray-600">{record.absent || record.absent_count}</td>
                      <td className={`px-6 py-4 font-bold ${(record.percentage || record.attendance_percentage) >= 75 ? 'text-green-600' : 'text-red-600'}`}>
                        {record.percentage || record.attendance_percentage}%
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
        {/* Marks Table */}
        <h3 className="text-xl font-bold text-gray-800 mb-4">Examination Results</h3>
        <div className="bg-white rounded-xl shadow-lg overflow-hidden border border-gray-200">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="bg-gray-800 text-white">
                  <th className="px-6 py-4 text-left font-semibold">Subject</th>
                  <th className="px-6 py-4 text-left font-semibold">Internal (40)</th>
                  <th className="px-6 py-4 text-left font-semibold">Semester (60)</th>
                  <th className="px-6 py-4 text-left font-semibold">Total (100)</th>
                  <th className="px-6 py-4 text-left font-semibold">Grade</th>
                </tr>
              </thead>
              <tbody>
                {marksData.length === 0 ? (
                  <tr><td colSpan="5" className="text-center text-gray-600 py-4">No marks data found.</td></tr>
                ) : (
                  marksData.map((record, idx) => (
                    <tr key={idx} className="border-b border-gray-100 hover:bg-gray-50">
                      <td className="px-6 py-4 text-gray-800">{record.subject || record.subject_name}</td>
                      <td className="px-6 py-4 text-gray-600">{record.internal || record.internal_marks}</td>
                      <td className="px-6 py-4 text-gray-600">{record.semester || record.semester_marks}</td>
                      <td className="px-6 py-4 text-gray-600">{record.total || record.total_marks}</td>
                      <td className={`px-6 py-4 font-bold ${
                        (record.grade || record.grade_letter) === 'A' ? 'text-green-600' : 
                        (record.grade || record.grade_letter) === 'B' ? 'text-yellow-600' : 'text-red-600'
                      }`}>
                        {record.grade || record.grade_letter}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );

  // Circulars Page
  const CircularsPage = () => (
    <div>
      <Header title="Circulars & Notices" />
      <div className="p-8 bg-gray-50 min-h-screen">
        <div className="flex justify-between items-center mb-8">
          <h2 className="text-3xl font-bold text-gray-800">Important Announcements</h2>
          <button
            onClick={() => setCurrentPage('dashboard')}
            className="bg-gray-600 text-white px-6 py-3 rounded-lg hover:bg-gray-700 transition-colors flex items-center space-x-2"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Back to Dashboard</span>
          </button>
        </div>
        <div className="space-y-4">
          {circulars.length === 0 ? (
            <div className="text-gray-600">No circulars found.</div>
          ) : (
            circulars.map((circular, idx) => (
              <div key={circular.id || idx} className="bg-white border border-gray-200 rounded-xl p-6 flex justify-between items-center hover:border-blue-300 hover:shadow-md transition-all">
                <div>
                  <h4 className="font-bold text-gray-800 mb-2">{circular.title}</h4>
                  <p className="text-gray-600 text-sm">Published: {circular.published_date || circular.date} | Category: {circular.category}</p>
                </div>
                <button className="bg-blue-500 text-white px-6 py-3 rounded-lg hover:bg-blue-600 transition-colors flex items-center space-x-2">
                  <Download className="w-4 h-4" />
                  <span>Download PDF</span>
                </button>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );

  // Chatbot Component (placeholder - replace with your actual AIChatbot)
  const Chatbot = () => (
    <>
      <button
        onClick={() => setIsChatbotOpen(!isChatbotOpen)}
        className="fixed bottom-5 right-5 w-14 h-14 bg-green-500 hover:bg-green-600 rounded-full text-white shadow-lg hover:scale-110 transition-transform z-50"
      >
        <MessageCircle className="w-6 h-6 mx-auto" />
      </button>
      
      {isChatbotOpen && (
        <AIChatbot onClose={() => setIsChatbotOpen(false)} />
      )}
    </>
  );

  // Main render logic
  if (!isAuthenticated) {
  return <LoginPage />;
  }

  const renderPage = () => {
    switch (currentPage) {
      case 'courses': return <CoursesPage />;
      case 'assignments': return <AssignmentsPage />;
      case 'attendance': return <AttendancePage />;
      case 'circulars': return <CircularsPage />;
      default: return <Dashboard />;
    }
  };

  return (
    <div className="h-screen bg-gray-50 overflow-hidden">
      {renderPage()}
      <Chatbot />
    </div>
  );
};

export default StudentPortal;