from flask import Flask, request, jsonify, send_from_directory
import json
import os
from flask_cors import CORS
import mysql.connector
import requests
import re

# ======================
# CONFIG
# ======================
app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)


# Global CORS headers for all responses
@app.after_request
def add_cors_headers(response):
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS, PUT, DELETE"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
    return response

# Login endpoint for authentication
@app.route("/login", methods=["POST", "OPTIONS"])
def login():
    if request.method == "OPTIONS":
        return ('', 204)
    data = request.json
    roll_no = data.get("rollNumber")
    password = data.get("password")
    if not roll_no or not password:
        return jsonify({"error": "Roll number and password required"}), 400
    student = authenticate_student(roll_no, password)
    if not student:
        return jsonify({"error": "Invalid credentials"}), 401
    return jsonify(student)


# MySQL config for LMS DB
MYSQL_CONFIG = {
    'host': 'localhost',
    'user': 'root',  # change as needed
    'password': '84260',  # set your MySQL root password
    'database': 'lms'
}

UPLOAD_FOLDER = os.path.join(os.path.dirname(__file__), 'uploads')
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# ======================
# HELPER FUNCTIONS
# ======================
def get_db_connection():
    """Get MySQL database connection"""
    try:
        conn = mysql.connector.connect(**MYSQL_CONFIG)
        return conn
    except Exception as e:
        print(f"Error connecting to MySQL: {e}")
        return None

def get_student_info(roll_no):
    """Get student information from database by roll number only (for profile, not login)"""
    conn = get_db_connection()
    if not conn:
        return None
    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT s.*, c.course_name, c.course_code 
            FROM students s 
            JOIN courses c ON s.course_id = c.course_id 
            WHERE s.roll_no = %s
        """, (roll_no,))
        row = cursor.fetchone()
        if row:
            return row
        return None
    except Exception as e:
        print(f"Error fetching student info: {e}")
        return None
    finally:
        conn.close()

# New function for login authentication
def authenticate_student(roll_no, password):
    """Authenticate student by roll number and password"""
    conn = get_db_connection()
    if not conn:
        return None
    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT s.*, c.course_name, c.course_code 
            FROM students s 
            JOIN courses c ON s.course_id = c.course_id 
            WHERE s.roll_no = %s AND s.password = %s
        """, (roll_no, password))
        row = cursor.fetchone()
        if row:
            return row
        return None
    except Exception as e:
        print(f"Error authenticating student: {e}")
        return None
    finally:
        conn.close()

def search_student_data(query, student_id):
    """Search for student-specific information based on query"""
    conn = get_db_connection()
    if not conn:
        return None
    try:
        cursor = conn.cursor(dictionary=True)
        query_lower = query.lower()
        # Check what the user is asking about
        if any(word in query_lower for word in ['attendance', 'classes', 'present', 'absent']):
            return get_attendance_info(cursor, student_id)
        elif any(word in query_lower for word in ['marks', 'results', 'grades', 'scores']):
            return get_results_info(cursor, student_id)
        elif any(word in query_lower for word in ['assignments', 'homework', 'due', 'submit']):
            return get_assignments_info(cursor, student_id)
        elif any(word in query_lower for word in ['subjects', 'courses', 'syllabus']):
            return get_subjects_info(cursor, student_id)
        elif any(word in query_lower for word in ['timetable', 'schedule', 'classes today']):
            return get_timetable_info(cursor, student_id)
        elif any(word in query_lower for word in ['fees', 'payment', 'due amount']):
            return get_fees_info(cursor, student_id)
        elif any(word in query_lower for word in ['circulars', 'notices', 'announcements']):
            return get_circulars_info(cursor)
        elif any(word in query_lower for word in ['library', 'books', 'issued']):
            return get_library_info(cursor, student_id)
        return None
    except Exception as e:
        print(f"Error searching student data: {e}")
        return None
    finally:
        conn.close()

def get_attendance_info(cursor, student_id):
    """Get student attendance information"""
    cursor.execute("""
        SELECT sub.subject_name,
               COUNT(a.attendance_id) as total_classes,
               SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) as present_classes,
               ROUND((SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.attendance_id)), 2) as attendance_percentage
        FROM attendance a
        JOIN classes cl ON a.class_id = cl.class_id
        JOIN subjects sub ON cl.subject_id = sub.subject_id
        WHERE a.student_id = %s
        GROUP BY sub.subject_id, sub.subject_name
    """, (student_id,))
    results = cursor.fetchall()
    if results:
        return results
    return []

def get_results_info(cursor, student_id):
    """Get student results information"""
    cursor.execute("""
        SELECT sub.subject_name,
               SUM(CASE WHEN r.exam_type = 'Internal' THEN r.obtained_marks ELSE 0 END) as internal_marks,
               SUM(CASE WHEN r.exam_type = 'Semester' THEN r.obtained_marks ELSE 0 END) as semester_marks,
               SUM(r.obtained_marks) as total_marks,
               MAX(r.grade) as grade
        FROM results r
        JOIN subjects sub ON r.subject_id = sub.subject_id
        WHERE r.student_id = %s
        GROUP BY sub.subject_id, sub.subject_name
    """, (student_id,))
    results = cursor.fetchall()
    if results:
        return results
    return []

def get_assignments_info(cursor, student_id):
    """Get student assignments information"""
    cursor.execute("""
        SELECT sub.subject_name, a.title, a.description, a.due_date, 
               COALESCE(asub.status, 'Not Started') as submission_status
        FROM assignments a
        JOIN subjects sub ON a.subject_id = sub.subject_id
        JOIN student_subjects ss ON sub.subject_id = ss.subject_id
        LEFT JOIN assignment_submissions asub ON a.assignment_id = asub.assignment_id 
            AND asub.student_id = ss.student_id
        WHERE ss.student_id = %s
          AND a.due_date >= CURDATE()
        ORDER BY a.due_date
    """, (student_id,))
    results = cursor.fetchall()
    if results:
        return results
    return []

def get_subjects_info(cursor, student_id):
    """Get student subjects information"""
    cursor.execute("""
        SELECT sub.subject_name, sub.subject_code, sub.credits, t.name as teacher_name, t.email
        FROM student_subjects ss 
        JOIN subjects sub ON ss.subject_id = sub.subject_id 
        JOIN teachers t ON sub.teacher_id = t.teacher_id 
        WHERE ss.student_id = %s
    """, (student_id,))
    results = cursor.fetchall()
    if results:
        return results
    return []

def get_timetable_info(cursor, student_id):
    """Get student timetable information"""
    cursor.execute("""
        SELECT sub.subject_name, tt.day_of_week, tt.start_time, tt.end_time, tt.room_number, tt.class_type
        FROM timetable tt
        JOIN subjects sub ON tt.subject_id = sub.subject_id
        JOIN student_subjects ss ON sub.subject_id = ss.subject_id
        WHERE ss.student_id = %s
        ORDER BY FIELD(tt.day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), tt.start_time
    """, (student_id,))
    results = cursor.fetchall()
    if results:
        response = "Here's your weekly timetable:\n\n"
        current_day = ""
        for row in results:
            if row['day_of_week'] != current_day:
                current_day = row['day_of_week']
                response += f"📅 **{current_day}**\n"
            response += f"   {row['start_time']}-{row['end_time']}: {row['subject_name']} ({row['class_type']})\n"
            response += f"   Room: {row['room_number']}\n\n"
        return response
    return "No timetable found."

def get_fees_info(cursor, student_id):
    """Get student fees information"""
    cursor.execute("""
        SELECT academic_year, semester, total_amount, paid_amount, due_amount, 
               due_date, payment_status
        FROM fees
        WHERE student_id = %s
        ORDER BY academic_year DESC, semester DESC
        LIMIT 1
    """, (student_id,))
    row = cursor.fetchone()
    if row:
        response = f"💰 Fee Details for {row['academic_year']} (Semester {row['semester']}):\n\n"
        response += f"Total Amount: ₹{row['total_amount']}\n"
        response += f"Paid Amount: ₹{row['paid_amount']}\n"
        response += f"Due Amount: ₹{row['due_amount']}\n"
        response += f"Due Date: {row['due_date']}\n"
        response += f"Status: {row['payment_status']}\n"
        if row['due_amount'] > 0:
            response += f"\n⚠️ You have a pending amount of ₹{row['due_amount']}. Please pay before the due date."
        return response
    return "No fee information found."

def get_circulars_info(cursor):
    """Get recent circulars information"""
    cursor.execute("""
        SELECT title, category, published_date, priority
        FROM circulars
        WHERE is_active = 1 
          AND (expiry_date IS NULL OR expiry_date >= CURDATE())
        ORDER BY priority DESC, published_date DESC
        LIMIT 5
    """)
    results = cursor.fetchall()
    if results:
        return results
    return []

def get_library_info(cursor, student_id):
    """Get student library information"""
    cursor.execute("""
        SELECT lb.title, lb.author, lt.issue_date, lt.due_date, lt.status
        FROM library_transactions lt
        JOIN library_books lb ON lt.book_id = lb.book_id
        WHERE lt.student_id = %s
        ORDER BY lt.issue_date DESC
        LIMIT 5
    """, (student_id,))
    results = cursor.fetchall()
    if results:
        response = "📚 Your Library Books:\n\n"
        for row in results:
            status_emoji = "📖" if row['status'] == 'Issued' else "✅"
            response += f"{status_emoji} {row['title']} by {row['author']}\n"
            response += f"   Issued: {row['issue_date']} | Due: {row['due_date']}\n"
            response += f"   Status: {row['status']}\n\n"
        return response
    return "No library transactions found."

def generate_intelligent_fallback(user_message, lang="English"):
    """Generate intelligent fallback responses based on message content"""
    message_lower = user_message.lower()
    
    # Academic help queries
    if any(word in message_lower for word in ['help', 'explain', 'what is', 'how to', 'study']):
        return f"I can help you with academic queries! For specific subject help, please ask about your enrolled courses. You can also ask me about your attendance, assignments, results, timetable, or any college-related information."
    
    # Greeting responses
    if any(word in message_lower for word in ['hello', 'hi', 'hey', 'good morning', 'good afternoon', 'good evening']):
        return "Hello! I'm your LMS AI assistant. I can help you with:\n• Check attendance and results\n• View assignments and deadlines\n• Get your class timetable\n• See college notices and circulars\n• Check fee status\n• Library information\n\nWhat would you like to know?"
    
    # Farewell responses
    if any(word in message_lower for word in ['bye', 'goodbye', 'see you', 'thanks', 'thank you']):
        return "You're welcome! Feel free to ask me anything about your academics or college information anytime. Have a great day!"
    
    # Subject-specific queries
    subjects = ['java', 'mathematics', 'constitution', 'database', 'programming', 'math', 'dbms', 'oops']
    for subject in subjects:
        if subject in message_lower:
            return f"I see you're asking about {subject}. I can help you with course materials, assignments, and academic information. You can ask me about your syllabus, upcoming assignments, or exam schedule for this subject."
    
    # Default helpful response
    return "I'm your LMS AI assistant. I can help you with various academic queries like checking your attendance, viewing results, assignment deadlines, class schedules, and college notices. What specific information would you like to know about?"

# ----------------------
# Translation (LibreTranslate)
# ----------------------
def translate_libre(text, source="auto", target="en"):
    """Translate text using LibreTranslate API"""
    url = "https://libretranslate.de/translate"
    payload = {"q": text, "source": source, "target": target, "format": "text"}
    headers = {"Content-Type": "application/json"}
    try:
        response = requests.post(url, json=payload, headers=headers, timeout=10)
        if response.status_code == 200:
            return response.json().get("translatedText", text)
        else:
            print(f"Translation API error: {response.status_code}")
            return text
    except Exception as e:
        print(f"Translation error: {e}")
        return text

# ======================
# ROUTES
# ======================

@app.route('/upload', methods=['POST'])
def upload_file():
    """Handle file uploads"""
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']        
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    filename = file.filename
    save_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    file.save(save_path)    
    return jsonify({'message': f'File {filename} uploaded successfully.'}), 200

@app.route("/chat", methods=["POST"])
def chat():
    """Main chat endpoint with LMS integration and login authentication"""
    data = request.json
    user_message = data.get("message", "")
    lang = data.get("language", "English")
    roll_no = data.get("rollNumber", "ITM123")
    password = data.get("password", "")

    if not user_message:
        return jsonify({"error": "Message is required"}), 400

    # Authenticate student (login)
    student = authenticate_student(roll_no, password)
    if not student:
        return jsonify({"error": "Student not found"}), 404

    # Translate input to English if not English
    translated_input = user_message
    if lang != "English":
        translated_input = translate_libre(user_message, "auto", "en")
        print(f"Translated '{user_message}' to '{translated_input}'")

    # Search for student-specific information
    student_data_response = search_student_data(translated_input, student['student_id'])

    answer = None
    matched_question = None
    category = "Academic Information"
    priority = 1

    if student_data_response:
        # Found relevant student data
        answer = student_data_response
        matched_question = translated_input
    else:
        # Generate intelligent fallback
        answer = generate_intelligent_fallback(translated_input, lang)

    # Translate response back to user's language if not English
    if lang != "English" and answer:
        answer = translate_libre(answer, "en", lang[:2].lower())

    return app.response_class(
        response=json.dumps({
            "reply": answer,
            "matched_question": matched_question,
            "category": category,
            "priority": priority,
            "student_name": student['name'],
            "roll_number": student['roll_no']
        }, ensure_ascii=False),
        status=200,
        mimetype="application/json"
    )

@app.route("/student/<roll_no>", methods=["GET"])
def get_student_profile(roll_no):
    """Get complete student profile"""
    student = get_student_info(roll_no)
    if not student:
        return jsonify({"error": "Student not found"}), 404
    
    return jsonify(student)

@app.route("/courses/<roll_no>", methods=["GET"])
def get_courses(roll_no):
    """Get courses/subjects for a student"""
    student = get_student_info(roll_no)
    if not student:
        return jsonify({"error": "Student not found"}), 404
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        subjects = get_subjects_info(cursor, student['student_id'])
        return jsonify({"subjects": subjects})
    finally:
        conn.close()

@app.route("/assignments/<roll_no>", methods=["GET"])
def get_assignments(roll_no):
    """Get assignments for a student"""
    student = get_student_info(roll_no)
    if not student:
        return jsonify({"error": "Student not found"}), 404
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        assignments = get_assignments_info(cursor, student['student_id'])
        return jsonify({"assignments": assignments})
    finally:
        conn.close()

@app.route("/attendance/<roll_no>", methods=["GET"])
def get_attendance(roll_no):
    """Get attendance for a student"""
    student = get_student_info(roll_no)
    if not student:
        return jsonify({"error": "Student not found"}), 404
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        attendance = get_attendance_info(cursor, student['student_id'])
        return jsonify({"attendance": attendance})
    finally:
        conn.close()

@app.route("/marks/<roll_no>", methods=["GET"])
def get_marks(roll_no):
    """Get marks/results for a student"""
    student = get_student_info(roll_no)
    if not student:
        return jsonify({"error": "Student not found"}), 404
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        marks = get_results_info(cursor, student['student_id'])
        return jsonify({"marks": marks})
    finally:
        conn.close()

@app.route("/circulars", methods=["GET"])
def get_circulars():
    """Get recent circulars"""
    conn = get_db_connection()
    try:
        cursor = conn.cursor()
        circulars = get_circulars_info(cursor)
        return jsonify({"circulars": circulars})
    finally:
        conn.close()

# Speech-to-text functionality (if you have Whisper installed)
try:
    import whisper
    whisper_model = whisper.load_model("base")

    @app.route('/speech-to-text', methods=['POST'])
    def speech_to_text():
        """Convert speech to text using Whisper"""
        if 'audio' not in request.files:
            return jsonify({'error': 'No audio file provided'}), 400
        
        audio_file = request.files['audio']
        audio_path = os.path.join(app.config['UPLOAD_FOLDER'], audio_file.filename)
        audio_file.save(audio_path)
        
        try:
            result = whisper_model.transcribe(audio_path)
            return jsonify({'text': result.get('text', '')}), 200
        except Exception as e:
            return jsonify({'error': str(e)}), 500
        finally:
            # Clean up the uploaded file
            if os.path.exists(audio_path):
                os.remove(audio_path)

except ImportError:
    print("Whisper not installed. Speech-to-text functionality will be disabled.")

def authenticate_student(roll_no, password):
    """Authenticate student by roll number and password"""
    conn = get_db_connection()
    if not conn:
        return None
    try:
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT s.*, c.course_name, c.course_code 
            FROM students s 
            JOIN courses c ON s.course_id = c.course_id 
            WHERE s.roll_no = %s AND s.password = %s
        """, (roll_no, password))
        row = cursor.fetchone()
        if row:
            return row
        return None
    except Exception as e:
        print(f"Error authenticating student: {e}")
        return None
    finally:
        conn.close()

if __name__ == "__main__":
    print("LMS AI Assistant Flask App (MySQL)")
    app.run(debug=True)
