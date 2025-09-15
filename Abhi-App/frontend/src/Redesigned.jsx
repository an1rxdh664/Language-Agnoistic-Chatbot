import React, { useState, useRef, useEffect } from 'react';
import { Send, Mic, MicOff, Paperclip, Plus, MessageCircle, Moon, Sun, Globe, X, Menu, User, Hash } from 'lucide-react';

const AIChatbot = ({ onClose }) => {
  // Inject animated dots CSS once
  useEffect(() => {
    if (!document.head.querySelector('style[data-loading-dots]')) {
      const style = document.createElement('style');
      style.setAttribute('data-loading-dots', 'true');
      style.textContent = `
        .loading-dots span {
          opacity: 0.2;
          animation: loadingBlink 1.4s infinite both;
        }
        .loading-dots span:nth-child(2) { animation-delay: 0.2s; }
        .loading-dots span:nth-child(3) { animation-delay: 0.4s; }
        @keyframes loadingBlink {
          0%, 80%, 100% { opacity: 0.2; }
          40% { opacity: 1; }
        }
      `;
      document.head.appendChild(style);
    }
  }, []);
  const [darkMode, setDarkMode] = useState(false);
  // --- Loading animation state (easy to remove) ---
  const [loading, setLoading] = useState(false);
  // --- End loading animation state ---
  const [currentMessage, setCurrentMessage] = useState('');
  const [selectedLanguage, setSelectedLanguage] = useState('en');
  const [isRecording, setIsRecording] = useState(false);
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [currentChatId, setCurrentChatId] = useState('chat-1');
  const [chatHistory, setChatHistory] = useState({
    'chat-1': {
      id: 'chat-1',
      title: 'General Queries',
      messages: [
        { id: 1, type: 'bot', content: 'Hello! I am your AI Linguistic Assistant. How can I help you today?', timestamp: new Date() },
      ]
    }
  });

  const fileInputRef = useRef(null);
  const messagesEndRef = useRef(null);

  // Student info (replace with actual data from props/context)
  const studentInfo = {
    name: 'John Doe',
    rollNumber: 'CS21B001'
  };

  // Language options with Indian languages
  const languages = {
    en: { name: 'English', flag: '🇺🇸' },
    hi: { name: 'हिंदी', flag: '🇮🇳' },
    te: { name: 'తెలుగు', flag: '🇮🇳' },
    ta: { name: 'தமிழ்', flag: '🇮🇳' },
    bn: { name: 'বাংলা', flag: '🇮🇳' },
    gu: { name: 'ગુજરાતી', flag: '🇮🇳' }
  };

  // Example test cases for different languages
  const exampleQueries = {
    en: [
      "Explain quantum physics",
      "What is machine learning?",
      "Help me with calculus"
    ],
    hi: [
      "भौतिक विज्ञान समझाएं",
      "मशीन लर्निंग क्या है?",
      "गणित में मदद करें"
    ],
    te: [
      "భౌతిక శాస్త్రం వివరించండి",
      "మెషిన్ లర్నింగ్ అంటే ఏమిటి?",
      "గణితంలో సహాయం చేయండి"
    ],
    ta: [
      "இயற்பியல் விளக்கவும்",
      "இயந்திர கற்றல் என்றால் என்ன?",
      "கணிதத்தில் உதவி செய்யுங்கள்"
    ],
    bn: [
      "পদার্থবিজ্ঞান ব্যাখ্যা করুন",
      "মেশিন লার্নিং কি?",
      "গণিতে সাহায্য করুন"
    ],
    gu: [
      "ભૌતિકશાસ્ત્ર સમજાવો",
      "મશીન લર્નિંગ શું છે?",
      "ગણિતમાં મદદ કરો"
    ]
  };

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    scrollToBottom();
  }, [chatHistory]);

  const [selectedFile, setSelectedFile] = useState(null);

  // Helper to get current chat and examples
  const currentChat = chatHistory[currentChatId];
  const currentExamples = exampleQueries[selectedLanguage] || [];

  const sendMessage = async (message = currentMessage) => {

    if (!message.trim() && !selectedFile) return;

    const newMessage = {
      id: Date.now(),
      type: 'user',
      content: message,
      timestamp: new Date(),
      language: selectedLanguage
    };

    setChatHistory(prev => ({
      ...prev,
      [currentChatId]: {
        ...prev[currentChatId],
        messages: [...prev[currentChatId].messages, newMessage]
      }
    }));

    setCurrentMessage('');

    // --- Show loading animation (easy to remove) ---
    setLoading(true);
    const loadingMsgId = Date.now() + 0.5;
    setChatHistory(prev => ({
      ...prev,
      [currentChatId]: {
        ...prev[currentChatId],
        messages: [...prev[currentChatId].messages, { id: loadingMsgId, type: 'bot', loading: true }]
      }
    }));
    // --- End loading animation ---

    // Call backend API for text message
    try {
      const response = await fetch('http://localhost:5000/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message, language: languages[selectedLanguage].name })
      });
      const data = await response.json();
      const botResponse = {
        id: Date.now() + 1,
        type: 'bot',
        content: data.reply || 'Sorry, I could not get a response from the server.',
        timestamp: new Date()
      };
      setChatHistory(prev => ({
        ...prev,
        [currentChatId]: {
          ...prev[currentChatId],
          messages: prev[currentChatId].messages.filter(m => m.id !== loadingMsgId).concat(botResponse)
        }
      }));
    } catch (error) {
      const botResponse = {
        id: Date.now() + 1,
        type: 'bot',
        content: 'Error connecting to backend: ' + error.message,
        timestamp: new Date()
      };
      setChatHistory(prev => ({
        ...prev,
        [currentChatId]: {
          ...prev[currentChatId],
          messages: prev[currentChatId].messages.filter(m => m.id !== loadingMsgId).concat(botResponse)
        }
      }));
    }
    setLoading(false);

    // File upload if file is selected
    if (selectedFile) {
      const formData = new FormData();
      formData.append('file', selectedFile);
      try {
        const uploadResponse = await fetch('http://localhost:5000/upload', {
          method: 'POST',
          body: formData
        });
        const uploadData = await uploadResponse.json();
        const uploadBotResponse = {
          id: Date.now(),
          type: 'bot',
          content: uploadData.message || 'File uploaded.',
          timestamp: new Date()
        };
        setChatHistory(prev => ({
          ...prev,
          [currentChatId]: {
            ...prev[currentChatId],
            messages: [...prev[currentChatId].messages, uploadBotResponse]
          }
        }));
      } catch (error) {
        const uploadBotResponse = {
          id: Date.now(),
          type: 'bot',
          content: 'File upload failed: ' + error.message,
          timestamp: new Date()
        };
        setChatHistory(prev => ({
          ...prev,
          [currentChatId]: {
            ...prev[currentChatId],
            messages: prev[currentChatId].messages.map(msg =>
          msg.id === loadingId ? botResponse : msg
          )
          }
        }));
      }
      setSelectedFile(null); // Clear after upload
    }
  };

  const deleteChat = (chatId) => {
    setChatHistory(prev => {
      const updated = { ...prev };
      delete updated[chatId];
      // If the current chat is deleted, switch to another chat if available
      const remainingChats = Object.keys(updated);
      if (currentChatId === chatId && remainingChats.length > 0) {
        setCurrentChatId(remainingChats[0]);
      }
      return updated;
    });
  };

  const startNewChat = () => {
    const newChatId = `chat-${Date.now()}`;
    const newChat = {
      id: newChatId,
      title: 'New Chat',
      messages: [
        { id: 1, type: 'bot', content: 'Hello! I am your AI Linguistic Assistant. How can I help you today?', timestamp: new Date() }
      ]
    };

    setChatHistory(prev => ({ ...prev, [newChatId]: newChat }));
    setCurrentChatId(newChatId);
  };

  const handleFileUpload = async (event) => {
    const file = event.target.files[0];
    if (file) {
      setSelectedFile(file); // <-- Store file in state
      // Do not upload here; upload when sending message
    }
  };

  const mediaRecorderRef = useRef(null);
  const audioChunksRef = useRef([]);

  const toggleRecording = async () => {
    if (!isRecording) {
      // Start recording
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        alert('Audio recording is not supported in this browser.');
        return;
      }
      try {
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
        const mediaRecorder = new window.MediaRecorder(stream);
        audioChunksRef.current = [];
        mediaRecorder.ondataavailable = (e) => {
          if (e.data.size > 0) audioChunksRef.current.push(e.data);
        };
        mediaRecorder.onstop = async () => {
          const audioBlob = new Blob(audioChunksRef.current, { type: 'audio/webm' });
          // Send audioBlob to backend for transcription
          const formData = new FormData();
          formData.append('audio', audioBlob, 'recording.webm');
          try {
            const response = await fetch('http://localhost:5000/speech-to-text', {
              method: 'POST',
              body: formData
            });
            const data = await response.json();
            setCurrentMessage((prev) => (prev ? prev + ' ' : '') + (data.text || ''));
          } catch (error) {
            alert('Speech-to-text failed: ' + error.message);
          }
        };
        mediaRecorderRef.current = mediaRecorder;
        mediaRecorder.start();
        setIsRecording(true);
        setTimeout(() => {
          mediaRecorder.stop();
          setIsRecording(false);
        }, 10000); // Stop after 10 seconds
      } catch (error) {
        alert('Could not start recording: ' + error.message);
      }
    } else {
      // Stop recording
      mediaRecorderRef.current?.stop();
      setIsRecording(false);
    }
  };

  // Example query handler
  const handleExampleQuery = (example) => {
    setCurrentMessage(example);
    sendMessage(example);
  };

  // --- Animated dots loader (easy to remove) ---
  const AnimatedDotsLoader = () => {
    const [dotCount, setDotCount] = React.useState(1);
    React.useEffect(() => {
      const interval = setInterval(() => {
        setDotCount((prev) => (prev % 3) + 1);
      }, 400);
      return () => clearInterval(interval);
    }, []);
    return (
      <span style={{ display: 'inline-flex', alignItems: 'center', fontWeight: 500 }}>
        {'.'.repeat(dotCount)}
      </span>
    );
  };
  // --- End Animated dots loader ---

  return (
    <div className={`fixed inset-0 z-50 flex ${darkMode ? 'dark' : ''}`}>
      {/* Backdrop */}
      <div 
        className="fixed inset-0 bg-black bg-opacity-50"
        onClick={onClose}
      />
      
      {/* Main Container */}
      <div className={`relative m-auto w-full max-w-6xl h-full max-h-[90vh] flex rounded-lg overflow-hidden shadow-2xl ${
        darkMode ? 'bg-gray-900 text-white' : 'bg-white text-gray-900'
      }`}>
        
        {/* Sidebar */}
        <div className={`${sidebarOpen ? 'w-80' : 'w-0'} ${
          darkMode ? 'bg-gray-800 border-gray-700' : 'bg-gray-50 border-gray-200'
        } border-r transition-all duration-300 overflow-hidden`}>
          <div className="p-4 space-y-4">
            {/* Student Info */}
            <div className={`p-3 rounded-lg ${darkMode ? 'bg-gray-700' : 'bg-white'} shadow-sm`}>
              <div className="flex items-center space-x-2 text-sm">
                <User size={16} className="text-blue-500" />
                <span className="font-medium">{studentInfo.name}</span>
              </div>
              <div className="flex items-center space-x-2 text-sm text-gray-500 mt-1">
                <Hash size={14} />
                <span>{studentInfo.rollNumber}</span>
              </div>
            </div>

            {/* New Chat Button */}
            <button
              onClick={startNewChat}
              className={`w-full flex items-center space-x-2 p-3 rounded-lg transition-colors ${
                darkMode ? 'bg-gray-700 hover:bg-gray-600' : 'bg-white hover:bg-gray-100'
              } shadow-sm`}
            >
              <Plus size={16} />
              <span>New Chat</span>
            </button>

            {/* Chat History */}
            <div className="space-y-2">
              <h3 className="text-sm font-medium text-gray-500 uppercase tracking-wide">Chat History</h3>
              {Object.values(chatHistory).map((chat) => (
                <div key={chat.id} className="flex items-center group">
                  <button
                    onClick={() => setCurrentChatId(chat.id)}
                    className={`flex-1 text-left p-2 rounded-lg transition-colors ${
                      currentChatId === chat.id
                        ? (darkMode ? 'bg-blue-600' : 'bg-blue-100')
                        : (darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-200')
                    }`}
                  >
                    <div className="truncate text-sm">{chat.title}</div>
                    <div className="text-xs text-gray-500 mt-1">
                      {chat.messages.length} messages
                    </div>
                  </button>
                  {/* Show delete button for all except the first chat */}
                  {chat.id !== 'chat-1' && (
                    <button
                      onClick={() => deleteChat(chat.id)}
                      className="ml-2 p-1 rounded text-red-500 opacity-0 group-hover:opacity-100 transition-opacity"
                      title="Delete chat"
                    >
                      <X size={16} />
                    </button>
                  )}
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Main Chat Area */}
        <div className="flex-1 flex flex-col">
          {/* Header */}
          <div className={`flex items-center justify-between p-4 border-b ${
            darkMode ? 'border-gray-700 bg-gray-800' : 'border-gray-200 bg-white'
          }`}>
            <div className="flex items-center space-x-4">
              <button
                onClick={() => setSidebarOpen(!sidebarOpen)}
                className={`p-2 rounded-lg ${darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'}`}
              >
                <Menu size={20} />
              </button>
              
              <div className="flex items-center space-x-2">
                <div className="w-3 h-3 bg-green-500 rounded-full animate-pulse"></div>
                <h2 className="font-semibold">AI Linguistic Assistant</h2>
              </div>
            </div>
            {/* Language Selector */}
            <div className="flex items-center space-x-2">
              <select
                value={selectedLanguage}
                onChange={e => setSelectedLanguage(e.target.value)}
                className={`p-2 rounded-lg border ${darkMode ? 'bg-gray-700 text-white border-gray-600' : 'bg-white border-gray-300'}`}
              >
                {Object.entries(languages).map(([key, lang]) => (
                  <option key={key} value={key}>
                    {lang.flag} {lang.name}
                  </option>
                ))}
              </select>
              <button
                onClick={() => setDarkMode(!darkMode)}
                className={`p-2 rounded-lg ${darkMode ? 'bg-gray-700' : 'bg-gray-100'}`}
                title={darkMode ? "Switch to light mode" : "Switch to dark mode"}
              >
                {darkMode ? <Sun size={20} /> : <Moon size={20} />}
              </button>
              <button
                onClick={onClose}
                className={`p-2 rounded-lg ${darkMode ? 'bg-gray-700' : 'bg-gray-100'}`}
                title="Close"
              >
                <X size={20} />
              </button>
            </div>
          </div>

          {/* Example Queries */}
          <div className={`p-4 ${darkMode ? 'bg-gray-800' : 'bg-gray-50'}`}>
            <h3 className="text-lg font-medium mb-2">Welcome to AI Linguistic Assistant</h3>
            <p className="text-gray-500 mb-6">Try asking in your preferred language</p>
            <div className="space-y-2">
              <p className="text-sm text-gray-500">Example queries in {languages[selectedLanguage].name}:</p>
              {currentExamples.map((example, index) => (
                <button
                  key={index}
                  onClick={() => handleExampleQuery(example)}
                  className={`block mx-auto px-4 py-2 text-sm rounded-full transition-colors ${
                    darkMode ? 'bg-gray-700 hover:bg-gray-600' : 'bg-gray-100 hover:bg-gray-200'
                  }`}
                >
                  {example}
                </button>
              ))}
            </div>
          </div>

          {/* Chat Messages */}
          <div className="flex-1 overflow-y-auto p-4 space-y-2">
            {currentChat?.messages.map((message) => (
              <div
                key={message.id}
                className={`flex ${message.type === 'user' ? 'justify-end' : 'justify-start'}`}
              >
                <div
                  className={`max-w-xs lg:max-w-md px-4 py-2 rounded-lg ${
                    message.type === 'user'
                      ? 'bg-blue-500 text-white'
                      : (darkMode ? 'bg-gray-700' : 'bg-gray-100')
                  }`}
                >
                  {/* --- Loading animation block (easy to remove) --- */}
                  {message.loading ? (
                    <span className="inline-flex items-center">
                      <AnimatedDotsLoader />
                    </span>
                  ) : (
                    <>
                      {message.content}
                      {message.language && message.language !== 'en' && (
                        <div className="text-xs opacity-70 mt-1">
                          {languages[message.language]?.flag} {languages[message.language]?.name}
                        </div>
                      )}
                    </>
                  )}
                  {/* --- End loading animation block --- */}
                </div>
              </div>
            ))}
            <div ref={messagesEndRef} />
          </div>

          {/* Input Area */}
          <div className={`p-4 border-t ${darkMode ? 'border-gray-700' : 'border-gray-200'}`}>
            <div className="flex items-center space-x-2">
              {/* File Upload */}
              <input
                ref={fileInputRef}
                type="file"
                onChange={handleFileUpload}
                className="hidden"
                accept=".pdf,.doc,.docx,.txt,.jpg,.jpeg,.png"
              />
              <button
                onClick={() => fileInputRef.current?.click()}
                className={`p-2 rounded-lg transition-colors ${
                  darkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'
                }`}
              >
                <Paperclip size={20} />
              </button>

              {/* Show selected file name */}
              {selectedFile && (
                <div className="flex items-center space-x-2 bg-gray-100 px-2 py-1 rounded">
                  <span className="text-xs text-gray-700">{selectedFile.name}</span>
                  <button
                    onClick={() => setSelectedFile(null)}
                    className="text-red-500 hover:text-red-700"
                  >
                    <X size={16} />
                  </button>
                </div>
              )}

              {/* Message Input */}
              <input
                type="text"
                value={currentMessage}
                onChange={(e) => setCurrentMessage(e.target.value)}
                onKeyPress={(e) => e.key === 'Enter' && sendMessage()}
                placeholder={`Type your message in ${languages[selectedLanguage].name}...`}
                className={`flex-1 p-3 rounded-lg border focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                  darkMode 
                    ? 'bg-gray-700 border-gray-600 text-white' 
                    : 'bg-white border-gray-300'
                }`}
              />

              {/* Voice Input */}
              <button
                onClick={toggleRecording}
                className={`p-2 rounded-lg transition-all duration-200 relative
                  ${isRecording 
                    ? 'bg-red-600 text-white ring-2 ring-red-400 shadow-lg animate-pulse'
                    : (darkMode 
                        ? 'hover:bg-gray-700 bg-gray-800 text-blue-400'
                        : 'hover:bg-gray-100 bg-white text-blue-600'
                      )
                  }
                `}
                aria-label={isRecording ? "Stop recording" : "Start recording"}
              >
                {isRecording ? <Mic size={20} /> : <MicOff size={20} />}
                {isRecording && (
                  <span className="absolute top-0 right-0 w-2 h-2 bg-blue-400 rounded-full animate-ping"></span>
                )}
              </button>

              {/* Send Button */}
              <button
                onClick={() => sendMessage()}
                disabled={!currentMessage.trim() && !selectedFile}
                className={`p-2 rounded-lg transition-colors ${
                  currentMessage.trim() || selectedFile
                    ? 'bg-blue-500 text-white hover:bg-blue-600'
                    : (darkMode ? 'bg-gray-700 text-gray-500' : 'bg-gray-200 text-gray-400')
                }`}
              >
                <Send size={20} />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AIChatbot;