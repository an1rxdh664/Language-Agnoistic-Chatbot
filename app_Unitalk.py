from flask import Flask, request, jsonify, send_from_directory
import json
import os
from flask_cors import CORS
import mysql.connector
import requests

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


MYSQL_CONFIG = {
    'host': 'localhost',
    'user': 'root',  # change as needed
    'password': '84260',  # set your MySQL root password
    'database': 'chatbot_db'
}

UPLOAD_FOLDER = os.path.join(os.path.dirname(__file__), 'uploads')
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
# ======================
# ROUTES
# ======================

# File upload endpoint
@app.route('/upload', methods=['POST', 'OPTIONS'])
def upload_file():
    if request.method == "OPTIONS":
        response = app.make_default_options_response()
        headers = response.headers
        headers["Access-Control-Allow-Origin"] = "*"
        headers["Access-Control-Allow-Methods"] = "POST, OPTIONS"
        headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
        return response
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']        
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    filename = file.filename
    save_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    file.save(save_path)    
    response = jsonify({'message': f'File {filename} uploaded successfully.'})
    response.headers["Access-Control-Allow-Origin"] = "*"
    return response

# ======================
# HELPER FUNCTIONS
# ======================
def get_db_connection():
    conn = mysql.connector.connect(**MYSQL_CONFIG)
    return conn

# ----------------------
# Translation (LibreTranslate)
# ----------------------
def translate_libre(text, source="auto", target="en"):
    url = "https://libretranslate.de/translate"
    payload = {"q": text, "source": source, "target": target, "format": "text"}
    headers = {"Content-Type": "application/json"}
    try:
        response = requests.post(url, json=payload, headers=headers, timeout=10)
        return response.json().get("translatedText", text)
    except Exception as e:
        return f"[Translation Error] {str(e)}"

# ----------------------
# Fallback (Lingva API)
# ----------------------
def lingva_fallback(text, target="en"):
    url = f"https://lingva.ml/api/v1/auto/{target}/{text}"
    try:
        response = requests.get(url, timeout=10)
        return response.json().get("translation", "Sorry, I couldn’t process your request.")
    except Exception as e:
        return f"[Lingva Error] {str(e)}"

# ----------------------
# DB Search
# ----------------------
def search_faq(user_message, lang="English"):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT ft.answer_text
            FROM faq_translations ft
            JOIN faq_entries f ON ft.faq_id = f.faq_id
            JOIN languages l ON ft.language_id = l.language_id
            WHERE l.language_name = %s
              AND %s LIKE CONCAT('%', ft.question_text, '%')
            ORDER BY f.priority DESC
            LIMIT 1
        """, (lang, user_message))
        row = cursor.fetchone()
        return row["answer_text"] if row else None
    except Exception as e:
        print("DB Error:", e)
        return None
    finally:
        conn.close()

def log_unanswered(user_message, lang="English", user_id=None):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        # get language_id
        cursor.execute("SELECT language_id FROM languages WHERE language_name = %s", (lang,))
        lang_row = cursor.fetchone()
        lang_id = lang_row["language_id"] if lang_row else None

        cursor.execute("""
            INSERT INTO unanswered_queries (user_id, language_id, question_text, created_at)
            VALUES (%s, %s, %s, NOW())
        """, (user_id, lang_id, user_message))
        conn.commit()
    except Exception as e:
        print("Error logging unanswered:", e)
    finally:
        conn.close()


# ======================
# ROUTES
# ======================
@app.route("/chat", methods=["POST", "OPTIONS"])
def chat():
    if request.method == "OPTIONS":
        response = app.make_default_options_response()
        headers = response.headers
        headers["Access-Control-Allow-Origin"] = "*"
        headers["Access-Control-Allow-Methods"] = "POST, OPTIONS"
        headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
        return response
    data = request.json
    user_message = data.get("message", "")
    lang = data.get("language", "English")

    if not user_message:
        return jsonify({"error": "Message is required"}), 400

    # 1. Normalize language code and translate input to English for matching
    lang_map = {
        'English': 'en',
        'Hindi': 'hi',
        'हिंदी': 'hi',
        'en': 'en',
        'hi': 'hi',
        # Add more mappings as needed
    }
    lang_code = lang_map.get(lang, 'en')
    translated_input = user_message
    if lang_code != 'en':
        translated_input = translate_libre(user_message, lang_code, 'en')


    # 2. Search in DB (return question, answer, category, priority) in user's preferred language
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT ft.question_text, ft.answer_text, fc.category_name, fe.priority
        FROM faq_translations ft
        JOIN languages l ON ft.language_id = l.language_id
        JOIN faq_entries fe ON ft.faq_id = fe.faq_id
        JOIN faq_categories fc ON fe.category_id = fc.category_id
        WHERE l.language_name = %s
        ORDER BY fe.priority DESC
    """, (lang,))
    rows = cursor.fetchall()
    conn.close()

    matched_question = None
    category = None
    priority = None
    answer = None
    best_ratio = 0.0
    from difflib import SequenceMatcher
    for row in rows:
        q_text = row["question_text"]
        # Exact or partial match
        if translated_input.lower() in q_text.lower() or q_text.lower() in translated_input.lower():
            matched_question = row["question_text"]
            answer = row["answer_text"]
            category = row["category_name"]
            priority = row["priority"]
            break
        # Fuzzy match
        ratio = SequenceMatcher(None, translated_input.lower(), q_text.lower()).ratio()
        if ratio > best_ratio and ratio > 0.6:
            best_ratio = ratio
            matched_question = row["question_text"]
            answer = row["answer_text"]
            category = row["category_name"]
            priority = row["priority"]

    # 3. If no DB match → log unanswered + improved fallback in user's language
    if not answer:
        log_unanswered(user_message, lang, None)
        # Try to get a fallback answer in English first
        fallback_en = lingva_fallback(translated_input, "en")
        # If the user's language is not English, translate the fallback answer to user's language
        if lang != "English":
            # Use Lingva to translate the fallback answer to user's language
            answer_translated = lingva_fallback(fallback_en, lang)
            # If Lingva fails, fallback to LibreTranslate
            if not answer_translated or answer_translated.startswith("[Lingva Error]"):
                answer_translated = translate_libre(fallback_en, "en", lang[:2].lower())
            answer = answer_translated or "Sorry, I couldn't find an answer in your language."
        else:
            answer = fallback_en or "Sorry, I couldn't find an answer."


    # 4. Translate matched question/category/answer back to original language (if not English)
    if lang_code != 'en':
        if matched_question:
            matched_question = translate_libre(matched_question, 'en', lang_code)
        if category:
            category = translate_libre(category, 'en', lang_code)
        if answer and answer != fallback_en:
            answer = translate_libre(answer, 'en', lang_code)

    response = app.response_class(
        response=json.dumps({
            "reply": answer,
            "matched_question": matched_question,
            "category": category,
            "priority": priority
        }, ensure_ascii=False),
        status=200,
        mimetype="application/json"
    )
    response.headers["Access-Control-Allow-Origin"] = "*"
    return response

from difflib import SequenceMatcher
from flask import request

from difflib import SequenceMatcher
from flask import request, jsonify

@app.route("/faq", methods=["GET"])
def get_faqs():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Get optional query parameters
    user_query = request.args.get("query", "").strip().lower()
    user_lang = request.args.get("lang", "").strip()

    # Build SQL dynamically (filter by language if provided)
    sql = """
        SELECT l.language_name, ft.question_text, ft.answer_text, 
               fc.category_name, fe.priority
        FROM faq_translations ft
        JOIN languages l ON ft.language_id = l.language_id
        JOIN faq_entries fe ON ft.faq_id = fe.faq_id
        JOIN faq_categories fc ON fe.category_id = fc.category_id
    """
    params = []
    if user_lang:
        sql += " WHERE l.language_name = %s"
        params.append(user_lang)

    sql += " ORDER BY fe.priority DESC"

    cursor.execute(sql, params)
    rows = cursor.fetchall()
    conn.close()

    # Convert to list of dicts
    faqs = [
        {
            "language": row["language_name"],
            "question": row["question_text"],
            "answer": row["answer_text"],
            "category": row["category_name"],
            "priority": row["priority"]
        }
        for row in rows
    ]

    # If no query filter → return all
    if not user_query:
        return jsonify(faqs)

    # Otherwise apply text search + fuzzy match
    results = []
    for faq in faqs:
        q_text = faq["question"].lower()

        # Exact / partial match
        if user_query in q_text:
            results.append(faq)
        else:
            # Fuzzy match if similarity > 0.6
            ratio = SequenceMatcher(None, user_query, q_text).ratio()
            if ratio > 0.6:
                results.append(faq)

    return jsonify(results)


import whisper
# Load the Whisper model once at startup
whisper_model = whisper.load_model("small")  # Changed from "base" to "small" for better accuracy

@app.route('/speech-to-text', methods=['POST', 'OPTIONS'])
def speech_to_text():
    if request.method == "OPTIONS":
        response = app.make_default_options_response()
        headers = response.headers
        headers["Access-Control-Allow-Origin"] = "*"
        headers["Access-Control-Allow-Methods"] = "POST, OPTIONS"
        headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
        return response
    if 'audio' not in request.files:
        print('No audio file provided in request.files')
        return jsonify({'error': 'No audio file provided'}), 400
    audio_file = request.files['audio']
    audio_path = os.path.join(app.config['UPLOAD_FOLDER'], audio_file.filename)
    audio_file.save(audio_path)
    print(f'Received audio file: {audio_file.filename}')
    print(f'Saved to: {audio_path}')
    try:
        result = whisper_model.transcribe(audio_path)
        print(f'Whisper result: {result}')
        response = jsonify({'text': result.get('text', '')})
        response.headers["Access-Control-Allow-Origin"] = "*"
        return response, 200
    except Exception as e:
        print(f'Whisper error: {e}')
        response = jsonify({'error': str(e)})
        response.headers["Access-Control-Allow-Origin"] = "*"
        return response, 500

if __name__ == "__main__":
    app.run(debug=True, port=5001)
