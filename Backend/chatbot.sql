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
INSERT INTO languages (language_name) VALUES 
('English'), 
('Hindi'), 
('Marathi'), 
('Tamil'), 
('Telugu');

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

-- FAQ Translations (EN + HI + MR + TA + TE)
INSERT INTO faq_translations (faq_id, language_id, question_text, answer_text) VALUES
-- Admission
(1, 1, 'What is the admission process?', 'Fill online form, upload documents, and wait for confirmation.'),
(1, 2, 'प्रवेश प्रक्रिया क्या है?', 'ऑनलाइन फॉर्म भरें, आवश्यक दस्तावेज अपलोड करें और पुष्टि का इंतजार करें।'),
(1, 3, 'प्रवेश प्रक्रिया काय आहे?', 'ऑनलाइन फॉर्म भरा, आवश्यक कागदपत्रे अपलोड करा आणि पुष्टीची वाट पाहा.'),
(1, 4, 'சேர்க்கை செயல்முறை என்ன?', 'ஆன்லைன் படிவத்தை நிரப்பி, ஆவணங்களை பதிவேற்றவும், உறுதிப்படுத்தலைக் காத்திருங்கள்.'),
(1, 5, 'ప్రవేశ ప్రక్రియ ఏమిటి?', 'ఆన్‌లైన్ ఫారం నింపి, అవసరమైన పత్రాలు అప్‌లోడ్ చేసి ధృవీకరణ కోసం వేచి ఉండండి.'),

-- Academics
(2, 1, 'When does the semester start?', 'The semester begins 2 weeks after orientation.'),
(2, 2, 'सेमेस्टर कब शुरू होता है?', 'ओरिएंटेशन के 2 हफ्ते बाद सेमेस्टर शुरू होता है।'),
(2, 3, 'सेमेस्टर केव्हा सुरू होतो?', 'ओरिएंटेशननंतर २ आठवड्यांनी सेमेस्टर सुरू होतो.'),
(2, 4, 'செமஸ்டர் எப்போது தொடங்குகிறது?', 'ஒரியண்டேஷனுக்கு இரண்டு வாரங்களுக்கு பிறகு செமஸ்டர் தொடங்குகிறது.'),
(2, 5, 'సెమిస్టర్ ఎప్పుడు ప్రారంభమవుతుంది?', 'ఒరియంటేషన్ తరువాత 2 వారాల తరువాత సెమిస్టర్ ప్రారంభమవుతుంది.'),

-- Exams
(3, 1, 'When are exams conducted?', 'Mid-semester in October, End-semester in December.'),
(3, 2, 'परीक्षाएं कब आयोजित की जाती हैं?', 'मध्य सेमेस्टर अक्टूबर में और अंतिम सेमेस्टर दिसंबर में होता है।'),
(3, 3, 'परीक्षा कधी घेतल्या जातात?', 'मध्य-सेमेस्टर ऑक्टोबरमध्ये आणि अंतिम सेमेस्टर डिसेंबरमध्ये असतो.'),
(3, 4, 'தேர்வுகள் எப்போது நடக்கின்றன?', 'நடுத்தேர்வு அக்டோபரில், இறுதித்தேர்வு டிசம்பரில் நடக்கின்றன.'),
(3, 5, 'పరీక్షలు ఎప్పుడు నిర్వహిస్తారు?', 'మధ్య సెమిస్టర్ అక్టోబర్‌లో, తుది సెమిస్టర్ డిసెంబర్‌లో ఉంటుంది.'),

-- Hostel
(4, 1, 'What are hostel rules?', 'Maintain discipline, follow timings, and respect staff.'),
(4, 2, 'छात्रावास के नियम क्या हैं?', 'अनुशासन बनाए रखें, समय का पालन करें और स्टाफ का सम्मान करें।'),
(4, 3, 'हॉस्टेलचे नियम काय आहेत?', 'शिस्त पाळा, वेळेचे पालन करा आणि स्टाफचा सन्मान करा.'),
(4, 4, 'ஹோஸ்டல் விதிகள் என்ன?', 'ஒழுங்கு காக்கவும், நேரத்தை பின்பற்றவும், பணியாளர்களை மதிக்கவும்.'),
(4, 5, 'హాస్టల్ నియమాలు ఏమిటి?', 'శిస్థను పాటించండి, సమయాన్ని పాటించండి మరియు సిబ్బందిని గౌరవించండి.'),

-- Rules
(5, 1, 'What are student regulations?', 'Follow dress code, attendance rules, and maintain discipline.'),
(5, 2, 'छात्रों के नियम क्या हैं?', 'ड्रेस कोड, उपस्थिति नियमों का पालन करें और अनुशासन बनाए रखें।'),
(5, 3, 'विद्यार्थ्यांचे नियम काय आहेत?', 'ड्रेस कोड पाळा, उपस्थितीचे नियम पाळा आणि शिस्त राखा.'),
(5, 4, 'மாணவர் விதிகள் என்ன?', 'டிரஸ் கோடு பின்பற்றவும், வருகை விதிகளை பின்பற்றவும், ஒழுங்கை பேணவும்.'),
(5, 5, 'విద్యార్థుల నియమాలు ఏమిటి?', 'డ్రెస్ కోడ్ పాటించండి, హాజరు నియమాలను పాటించండి మరియు శిస్థను కాపాడండి.'),

-- Fee Payment
(6, 1, 'When is the last date for fee payment?', 'The last date is 15th of every month. Late fees apply after that.'),
(6, 2, 'फीस भुगतान की अंतिम तिथि कब है?', 'फीस भुगतान की अंतिम तिथि हर महीने की 15 तारीख है। इसके बाद लेट फीस लगेगी।'),
(6, 3, 'फी भरण्याची शेवटची तारीख कोणती आहे?', 'प्रत्येक महिन्याची १५ तारीख शेवटची तारीख असते. त्यानंतर उशीर फी लागेल.'),
(6, 4, 'கட்டணம் செலுத்த கடைசி தேதி எது?', 'ஒவ்வொரு மாதமும் 15 ஆம் தேதி கடைசி தேதி. அதன் பிறகு அபராதம் வசூலிக்கப்படும்.'),
(6, 5, 'ఫీజు చెల్లించడానికి చివరి తేదీ ఏమిటి?', 'ప్రతి నెల 15వ తేదీ చివరి తేదీ. తర్వాత ఆలస్య రుసుము వర్తిస్తుంది.'),

-- Scholarship
(7, 1, 'How to apply for scholarship?', 'Apply via the official portal and upload required documents.'),
(7, 2, 'छात्रवृत्ति के लिए कैसे आवेदन करें?', 'आधिकारिक पोर्टल पर आवेदन करें और आवश्यक दस्तावेज अपलोड करें।'),
(7, 3, 'शिष्यवृत्ती साठी अर्ज कसा करायचा?', 'अधिकृत पोर्टलवर अर्ज करा आणि आवश्यक कागदपत्रे अपलोड करा.'),
(7, 4, 'உதவித்தொகைக்கு எப்படி விண்ணப்பிப்பது?', 'அதிகாரப்பூர்வ தளத்தில் விண்ணப்பிக்கவும் மற்றும் தேவையான ஆவணங்களை பதிவேற்றவும்.'),
(7, 5, 'విద్యార్థి వేతనం కోసం ఎలా దరఖాస్తు చేయాలి?', 'అధికారిక పోర్టల్‌లో దరఖాస్తు చేసి, అవసరమైన పత్రాలను అప్‌లోడ్ చేయండి.'),

-- Library
(8, 1, 'What are library timings?', 'Library is open from 9 AM to 8 PM on weekdays.'),
(8, 2, 'पुस्तकालय का समय क्या है?', 'पुस्तकालय सप्ताह के दिनों में सुबह 9 बजे से रात 8 बजे तक खुला रहता है।'),
(8, 3, 'लायब्ररीचे वेळापत्रक काय आहे?', 'लायब्ररी सकाळी ९ ते रात्री ८ पर्यंत उघडी असते.'),
(8, 4, 'நூலக நேரம் என்ன?', 'நூலகம் காலை 9 மணி முதல் இரவு 8 மணி வரை திறந்திருக்கும்.'),
(8, 5, 'లైబ్రరీ సమయాలు ఏమిటి?', 'లైబ్రరీ ఉదయం 9 గంటల నుండి రాత్రి 8 గంటల వరకు తెరిచి ఉంటుంది.'),

-- Transport
(9, 1, 'Is bus facility available?', 'Yes, bus routes are available for nearby cities.'),
(9, 2, 'क्या बस सुविधा उपलब्ध है?', 'हाँ, नजदीकी शहरों के लिए बस रूट उपलब्ध हैं।'),
(9, 3, 'बस सुविधा उपलब्ध आहे का?', 'होय, जवळच्या शहरांसाठी बस मार्ग उपलब्ध आहेत.'),
(9, 4, 'பஸ் வசதி உள்ளதா?', 'ஆம், அருகிலுள்ள நகரங்களுக்கு பஸ் வழிகள் உள்ளன.'),
(9, 5, 'బస్సు సౌకర్యం ఉందా?', 'అవును, సమీప పట్టణాల కోసం బస్సు మార్గాలు అందుబాటులో ఉన్నాయి.'),

-- Placements
(10, 1, 'How does placement work?', 'Companies visit campus, conduct tests, and interviews.'),
(10, 2, 'प्लेसमेंट कैसे होता है?', 'कंपनियां कैंपस आती हैं, टेस्ट और इंटरव्यू आयोजित करती हैं।'),
(10, 3, 'प्लेसमेंट कसे होतात?', 'कंपन्या कॅम्पसवर येतात, टेस्ट घेतात आणि मुलाखती घेतात.'),
(10, 4, 'ப்ளேஸ்மென்ட் எவ்வாறு நடக்கிறது?', 'நிறுவனங்கள் காம்பஸுக்கு வந்து தேர்வுகள் மற்றும் நேர்முகங்களை நடத்துகின்றன.'),
(10, 5, 'ప్లేస్మెంట్ ఎలా జరుగుతుంది?', 'కంపెనీలు క్యాంపస్‌కి వచ్చి పరీక్షలు మరియు ఇంటర్వ్యూలు నిర్వహిస్తాయి.');

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

-- Users & Conversations (Sample Data)
INSERT INTO users (username, email, language_preference_id) VALUES
('anmol', 'anmol@example.com', 1),
('priya', 'priya@example.com', 2);

INSERT INTO conversations (user_id) VALUES (1), (2);

INSERT INTO conversation_logs (conversation_id, message_text, sender) VALUES
(1, 'When does the semester start?', 'user'),
(1, 'The semester begins 2 weeks after orientation.', 'bot'),
(2, 'फीस की अंतिम तिथि क्या है?', 'user'),
(2, 'फीस भुगतान की अंतिम तिथि हर महीने की 15 तारीख है।', 'bot');
