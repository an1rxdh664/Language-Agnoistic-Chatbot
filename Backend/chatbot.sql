-- ===============================
-- RESET DATABASE
-- ===============================
DROP DATABASE IF EXISTS chatbot_db;
CREATE DATABASE chatbot_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE chatbot_db;

-- ===============================
-- TABLES
-- ===============================

-- Languages
CREATE TABLE languages (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL UNIQUE
);

-- Users
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(100),
    language_preference_id INT,
    FOREIGN KEY (language_preference_id) REFERENCES languages(language_id)
);

-- Conversations
CREATE TABLE conversations (
    conversation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Conversation Logs
CREATE TABLE conversation_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    conversation_id INT,
    message_text TEXT NOT NULL,
    sender ENUM('user','bot') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id)
);

-- Unanswered Queries
CREATE TABLE unanswered_queries (
    query_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    language_id INT,
    question_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (language_id) REFERENCES languages(language_id)
);

-- FAQ Categories
CREATE TABLE faq_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- FAQ Entries
CREATE TABLE faq_entries (
    faq_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    priority INT DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES faq_categories(category_id)
);

-- FAQ Translations
CREATE TABLE faq_translations (
    translation_id INT AUTO_INCREMENT PRIMARY KEY,
    faq_id INT,
    language_id INT,
    question_text TEXT NOT NULL,
    answer_text TEXT NOT NULL,
    UNIQUE(faq_id, language_id),
    FOREIGN KEY (faq_id) REFERENCES faq_entries(faq_id),
    FOREIGN KEY (language_id) REFERENCES languages(language_id)
);

-- Intents
CREATE TABLE intents (
    intent_id INT AUTO_INCREMENT PRIMARY KEY,
    intent_name VARCHAR(100) NOT NULL UNIQUE
);

-- FAQ <-> Intents link
CREATE TABLE faq_intents (
    faq_id INT,
    intent_id INT,
    PRIMARY KEY(faq_id, intent_id),
    FOREIGN KEY (faq_id) REFERENCES faq_entries(faq_id),
    FOREIGN KEY (intent_id) REFERENCES intents(intent_id)
);

-- ===============================
-- SEED DATA
-- ===============================

-- Languages
INSERT INTO languages (language_name) VALUES ('English'), ('Hindi');

-- Categories
INSERT INTO faq_categories (category_name) VALUES
('Admissions'),
('Academics'),
('Examinations'),
('Hostel'),
('Rules & Regulations'),
('Fee Payment'),
('Scholarship'),
('Library'),
('Transport'),
('Placements');

-- FAQ Entries (10 questions)
INSERT INTO faq_entries (category_id, priority) VALUES
(1, 1), -- Admission
(2, 1), -- Academics
(3, 1), -- Exams
(4, 1), -- Hostel
(5, 1), -- Rules
(6, 1), -- Fee Payment
(7, 1), -- Scholarship
(8, 1), -- Library
(9, 1), -- Transport
(10, 1); -- Placements

-- FAQ Translations (English + Hindi)
INSERT INTO faq_translations (faq_id, language_id, question_text, answer_text) VALUES
-- Admission
(1, 1, 'What is the admission process?', 'Fill online form, upload documents, and wait for confirmation.'),
(1, 2, 'प्रवेश प्रक्रिया क्या है?', 'ऑनलाइन फॉर्म भरें, आवश्यक दस्तावेज अपलोड करें और पुष्टि का इंतजार करें।'),

-- Academics
(2, 1, 'When does the semester start?', 'The semester begins 2 weeks after orientation.'),
(2, 2, 'सेमेस्टर कब शुरू होता है?', 'ओरिएंटेशन के 2 हफ्ते बाद सेमेस्टर शुरू होता है।'),

-- Exams
(3, 1, 'When are exams conducted?', 'Mid-semester in October, End-semester in December.'),
(3, 2, 'परीक्षाएं कब आयोजित की जाती हैं?', 'मध्य सेमेस्टर अक्टूबर में और अंतिम सेमेस्टर दिसंबर में होता है।'),

-- Hostel
(4, 1, 'What are hostel rules?', 'Maintain discipline, follow timings, and respect staff.'),
(4, 2, 'छात्रावास के नियम क्या हैं?', 'अनुशासन बनाए रखें, समय का पालन करें और स्टाफ का सम्मान करें।'),

-- Rules
(5, 1, 'What are student regulations?', 'Follow dress code, attendance rules, and maintain discipline.'),
(5, 2, 'छात्रों के नियम क्या हैं?', 'ड्रेस कोड, उपस्थिति नियमों का पालन करें और अनुशासन बनाए रखें।'),

-- Fee Payment
(6, 1, 'When is the last date for fee payment?', 'The last date is 15th of every month. Late fees apply after that.'),
(6, 2, 'फीस भुगतान की अंतिम तिथि कब है?', 'फीस भुगतान की अंतिम तिथि हर महीने की 15 तारीख है। इसके बाद लेट फीस लगेगी।'),

-- Scholarship
(7, 1, 'How to apply for scholarship?', 'Apply via the official portal and upload required documents.'),
(7, 2, 'छात्रवृत्ति के लिए कैसे आवेदन करें?', 'आधिकारिक पोर्टल पर आवेदन करें और आवश्यक दस्तावेज अपलोड करें।'),

-- Library
(8, 1, 'What are library timings?', 'Library is open from 9 AM to 8 PM on weekdays.'),
(8, 2, 'पुस्तकालय का समय क्या है?', 'पुस्तकालय सप्ताह के दिनों में सुबह 9 बजे से रात 8 बजे तक खुला रहता है।'),

-- Transport
(9, 1, 'Is bus facility available?', 'Yes, bus routes are available for nearby cities.'),
(9, 2, 'क्या बस सुविधा उपलब्ध है?', 'हाँ, नजदीकी शहरों के लिए बस रूट उपलब्ध हैं।'),

-- Placements
(10, 1, 'How does placement work?', 'Companies visit campus, conduct tests, and interviews.'),
(10, 2, 'प्लेसमेंट कैसे होता है?', 'कंपनियां कैंपस आती हैं, टेस्ट और इंटरव्यू आयोजित करती हैं।');

-- Intents
INSERT INTO intents (intent_name) VALUES
('admission_process'),
('semester_info'),
('exam_schedule'),
('hostel_rules'),
('student_regulations'),
('fee_payment'),
('scholarship_info'),
('library_timings'),
('transport_facility'),
('placement_info');

-- FAQ-Intent Links
INSERT INTO faq_intents (faq_id, intent_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- ===============================
-- TEST DATA (users + conversations)
-- ===============================
INSERT INTO users (username, email, language_preference_id) VALUES
('anmol', 'anmol@example.com', 1),
('priya', 'priya@example.com', 2);

INSERT INTO conversations (user_id) VALUES (1), (2);

INSERT INTO conversation_logs (conversation_id, message_text, sender) VALUES
(1, 'When does the semester start?', 'user'),
(1, 'The semester begins 2 weeks after orientation.', 'bot'),
(2, 'फीस की अंतिम तिथि क्या है?', 'user'),
(2, 'फीस भुगतान की अंतिम तिथि हर महीने की 15 तारीख है।', 'bot');

-- ===============================
-- TEST QUERIES
-- ===============================

-- Get all FAQs with English questions
SELECT f.faq_id, c.category_name, t.question_text, t.answer_text
FROM faq_entries f
JOIN faq_categories c ON f.category_id = c.category_id
JOIN faq_translations t ON f.faq_id = t.faq_id
JOIN languages l ON t.language_id = l.language_id
WHERE l.language_name = 'English';

-- Get all FAQs with Hindi questions
SELECT f.faq_id, c.category_name, t.question_text, t.answer_text
FROM faq_entries f
JOIN faq_categories c ON f.category_id = c.category_id
JOIN faq_translations t ON f.faq_id = t.faq_id
JOIN languages l ON t.language_id = l.language_id
WHERE l.language_name = 'Hindi';

-- Get conversation logs with user and bot messages
SELECT u.username, cl.message_text, cl.sender, cl.created_at
FROM conversation_logs cl
JOIN conversations conv ON cl.conversation_id = conv.conversation_id
JOIN users u ON conv.user_id = u.user_id
ORDER BY cl.created_at;
