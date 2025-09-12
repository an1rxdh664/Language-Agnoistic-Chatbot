import React, { useState, useEffect, useRef } from 'react';
import {
  Globe, MessageCircle, Zap, Shield, Users, ArrowRight, 
  Sun, Moon, Sparkles, Languages, Volume2, Brain,
  CheckCircle, Star, Play, ChevronDown, TrendingUp,
  Award, Clock, Smartphone, Monitor, Headphones,
  BarChart3, Lock, Wifi, Download, Share2
} from 'lucide-react';

const UnitalkLanding = () => {
  const [isDarkMode, setIsDarkMode] = useState(true);
  const [currentLanguage, setCurrentLanguage] = useState(0);
  const [typingText, setTypingText] = useState('');
  const [currentTestimonial, setCurrentTestimonial] = useState(0);
  const [stats, setStats] = useState({ users: 0, languages: 0, translations: 0 });

  const [faqOpen, setFaqOpen] = useState(null);
  const heroRef = useRef(null);
  const featuresRef = useRef(null);
  const statsRef = useRef(null);

  const languages = [
    { name: 'Hello', flag: '🇺🇸', code: 'en' },
    { name: 'नमस्ते', flag: '🇮🇳', code: 'hi' },
    { name: 'Hola', flag: '🇪🇸', code: 'es' },
    { name: 'Bonjour', flag: '🇫🇷', code: 'fr' },
    { name: 'こんにちは', flag: '🇯🇵', code: 'ja' },
    { name: '你好', flag: '🇨🇳', code: 'zh' },
    { name: 'مرحبا', flag: '🇸🇦', code: 'ar' },
    { name: 'Привет', flag: '🇷🇺', code: 'ru' }
  ];

  const typingPhrases = [
    "Breaking language barriers...",
    "Connecting cultures...",
    "AI-powered conversations...",
    "Seamless translation..."
  ];

  const testimonials = [
    {
      name: "Sarah Chen",
      role: "International Business Manager",
      content: "Unitalk transformed how we communicate with our global team. Real-time translation is incredible!",
      avatar: "🧑‍💼",
      rating: 5
    },
    {
      name: "Dr. Ahmed Hassan",
      role: "Language Researcher",
      content: "The cultural awareness and context understanding is remarkable. It's like having a native speaker for every language.",
      avatar: "👨‍🔬",
      rating: 5
    },
    {
      name: "Maria Rodriguez",
      role: "Language Teacher",
      content: "My students love practicing with Unitalk. It provides natural conversations in multiple languages.",
      avatar: "👩‍🏫",
      rating: 5
    }
  ];

  // Persist theme preference
  useEffect(() => {
    const saved = localStorage.getItem('unitalk-theme');
    if (saved) {
      setIsDarkMode(saved === 'dark');
    } else {
      const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
      setIsDarkMode(prefersDark);
    }
  }, []);
  useEffect(() => {
    localStorage.setItem('unitalk-theme', isDarkMode ? 'dark' : 'light');
  }, [isDarkMode]);

  // Enable smooth anchor scrolling
  useEffect(() => {
    const html = document.documentElement;
    const prev = html.style.scrollBehavior;
    html.style.scrollBehavior = 'smooth';
    return () => { html.style.scrollBehavior = prev; };
  }, []);

  // Intersection Observer for scroll animations
  // Intersection Observer for bidirectional scroll animations
        useEffect(() => {
        const reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        if (reduced) return;

        const observer = new IntersectionObserver(
            (entries) => {
            entries.forEach((entry) => {
                const el = entry.target;
                if (entry.isIntersecting) {
                el.classList.add('is-visible');
                } else {
                el.classList.remove('is-visible');
                }
            });
            },
            { threshold: 0.15, rootMargin: '0px 0px -10% 0px' }
        );

        const animatedElements = document.querySelectorAll('.scroll-animate');
        animatedElements.forEach((el) => {
            el.classList.add('will-change-transform', 'transition-all', 'duration-700');
            el.classList.remove('is-visible');
            observer.observe(el);
        });

        return () => observer.disconnect();
        }, []);

  // Language rotation
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentLanguage((prev) => (prev + 1) % languages.length);
    }, 2000);
    return () => clearInterval(interval);
  }, []);

  // Typing animation
 useEffect(() => {
  let currentPhraseIndex = 0;
  let currentCharIndex = 0;
  let isDeleting = false;
  let timeoutId;

  const tick = () => {
    const currentPhrase = typingPhrases[currentPhraseIndex];
    if (!isDeleting && currentCharIndex < currentPhrase.length) {
      setTypingText(currentPhrase.substring(0, currentCharIndex + 1));
      currentCharIndex++;
      timeoutId = setTimeout(tick, 100);
    } else if (isDeleting && currentCharIndex > 0) {
      setTypingText(currentPhrase.substring(0, currentCharIndex - 1));
      currentCharIndex--;
      timeoutId = setTimeout(tick, 50);
    } else if (!isDeleting && currentCharIndex === currentPhrase.length) {
      timeoutId = setTimeout(() => {
        isDeleting = true;
        tick();
      }, 1500);
    } else if (isDeleting && currentCharIndex === 0) {
      isDeleting = false;
      currentPhraseIndex = (currentPhraseIndex + 1) % typingPhrases.length;
      timeoutId = setTimeout(tick, 500);
    }
  };

  tick();
  return () => clearTimeout(timeoutId);
}, []);

  // Stats counter animation
  useEffect(() => {
    const animateStats = () => {
      const targetStats = { users: 50000, languages: 50, translations: 1000000 };
      const duration = 2000;
      const steps = 60;
      const stepDuration = duration / steps;
      let currentStep = 0;
      const interval = setInterval(() => {
        if (currentStep <= steps) {
          const progress = currentStep / steps;
          setStats({
            users: Math.floor(targetStats.users * progress),
            languages: Math.floor(targetStats.languages * progress),
            translations: Math.floor(targetStats.translations * progress)
          });
          currentStep++;
        } else {
          clearInterval(interval);
        }
      }, stepDuration);
    };

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            animateStats();
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.5 }
    );

    if (statsRef.current) {
      observer.observe(statsRef.current);
    }

    return () => observer.disconnect();
  }, []);

  // Testimonial rotation
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentTestimonial((prev) => (prev + 1) % testimonials.length);
    }, 4000);
    return () => clearInterval(interval);
  }, []);

  const themeClasses = {
    bodyBg: isDarkMode ? 'bg-gradient-to-br from-gray-900 via-slate-900 to-gray-800' : 'bg-gradient-to-br from-gray-50 via-gray-100 to-gray-200',
    cardBg: isDarkMode ? 'bg-gray-800/60 border-gray-700/50' : 'bg-white/80 border-gray-200/50',
    text: isDarkMode ? 'text-white' : 'text-gray-900',
    textSecondary: isDarkMode ? 'text-gray-300' : 'text-gray-600',
    textTertiary: isDarkMode ? 'text-gray-400' : 'text-gray-500',
    headerBg: isDarkMode ? 'bg-gray-900/80' : 'bg-white/80'
  };

  const gradientText = isDarkMode ? 'from-indigo-500 to-purple-600' : 'from-indigo-700 to-purple-700';

  const handleTryUnitalk = () => {
    // Link to existing chatbot page
    window.location.href = '/chat';
  };

  const features = [
    {
      icon: <Globe className="w-8 h-8" />,
      title: "50+ Languages",
      description: "Communicate naturally in over 50 languages with automatic detection and seamless translation.",
      gradient: "from-blue-500 to-cyan-500"
    },
    {
      icon: <Brain className="w-8 h-8" />,
      title: "Smart Understanding",
      description: "Advanced AI that understands context, culture, and nuances across different languages.",
      gradient: "from-purple-500 to-pink-500"
    },
    {
      icon: <Volume2 className="w-8 h-8" />,
      title: "Voice Support",
      description: "Text-to-speech and speech-to-text in native languages with natural pronunciation.",
      gradient: "from-green-500 to-emerald-500"
    },
    {
      icon: <Zap className="w-8 h-8" />,
      title: "Real-time Translation",
      description: "Instant translation between languages without losing meaning or context.",
      gradient: "from-orange-500 to-red-500"
    },
    {
      icon: <Shield className="w-8 h-8" />,
      title: "Privacy First",
      description: "Your conversations are secure and private. We don't store your personal data.",
      gradient: "from-indigo-500 to-purple-500"
    },
    {
      icon: <Users className="w-8 h-8" />,
      title: "Cultural Awareness",
      description: "Understands cultural context and provides appropriate responses for different regions.",
      gradient: "from-pink-500 to-rose-500"
    }
  ];

  const additionalFeatures = [
    {
      icon: <Smartphone className="w-6 h-6" />,
      title: "Cross-Platform",
      description: "Available on web, mobile, and desktop"
    },
    {
      icon: <Wifi className="w-6 h-6" />,
      title: "Offline Mode",
      description: "Basic features work without internet"
    },
    {
      icon: <Lock className="w-6 h-6" />,
      title: "Enterprise Security",
      description: "Bank-level encryption and compliance"
    },
    {
      icon: <BarChart3 className="w-6 h-6" />,
      title: "Analytics Dashboard",
      description: "Track usage and learning progress"
    }
  ];

  const useCases = [
    "Language learning and practice",
    "International business communication",
    "Travel assistance and cultural guidance",
    "Educational support in multiple languages",
    "Customer service across language barriers",
    "Content translation and localization"
  ];

  const faqs = [
    {
      q: "How do I start a conversation?",
      a: "Click “Try Unitalk,” choose your language, then type or speak your message. The assistant detects and responds intelligently."
    },
    {
      q: "Can I switch languages mid-chat?",
      a: "Yes. You can write in any language at any time. Unitalk adapts automatically."
    },
    {
      q: "Does it support voice?",
      a: "Yes, with speech-to-text input and natural text-to-speech output in supported languages."
    },
    {
      q: "Is my data private?",
      a: "Your conversations are processed securely. Personal data is not stored for profiling."
    }
  ];

  return (
    <div className={`min-h-screen transition-all duration-300 ${themeClasses.bodyBg}`}>
      {/* Floating particles background */}
      {/* Background (aurora blobs) */}
        <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <div className="absolute inset-0">
            <div className={`aurora-blob ${isDarkMode ? 'aurora-dark' : 'aurora-light'}`} style={{ top: '-10%', left: '-10%', animationDelay: '0s' }} />
            <div className={`aurora-blob ${isDarkMode ? 'aurora-dark' : 'aurora-light'}`} style={{ bottom: '-20%', right: '-10%', animationDelay: '3s' }} />
            <div className={`aurora-blob ${isDarkMode ? 'aurora-dark' : 'aurora-light'}`} style={{ top: '20%', right: '15%', animationDelay: '6s' }} />
        </div>
        </div>

      {/* Header */}
      <header className={`fixed top-0 w-full z-50 ${themeClasses.headerBg} backdrop-blur-lg border-b ${isDarkMode ? 'border-gray-700/50' : 'border-gray-200/50'} transition-all duration-300`}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center transform hover:scale-110 transition-transform duration-200">
                <Sparkles className="w-6 h-6 text-white" />
              </div>
              <div>
                <h1 className={`text-xl font-bold ${themeClasses.text}`}>Unitalk</h1>
                <p className="text-xs text-indigo-400">Language Agnostic AI</p>
              </div>
            </div>
            
            <nav className="hidden md:flex items-center space-x-8">
              <a href="#features" className={`${themeClasses.textSecondary} hover:${isDarkMode ? 'text-white' : 'text-gray-900'} transition-all duration-200 hover:scale-105`}>
                Features
              </a>
              <a href="#how-it-works" className={`${themeClasses.textSecondary} hover:${isDarkMode ? 'text-white' : 'text-gray-900'} transition-all duration-200 hover:scale-105`}>
                How it works
              </a>
              <a href="#use-cases" className={`${themeClasses.textSecondary} hover:${isDarkMode ? 'text-white' : 'text-gray-900'} transition-all duration-200 hover:scale-105`}>
                Use cases
              </a>
              <a href="#testimonials" className={`${themeClasses.textSecondary} hover:${isDarkMode ? 'text-white' : 'text-gray-900'} transition-all duration-200 hover:scale-105`}>
                Reviews
              </a>
              <a href="#faq" className={`${themeClasses.textSecondary} hover:${isDarkMode ? 'text-white' : 'text-gray-900'} transition-all duration-200 hover:scale-105`}>
                FAQ
              </a>
            </nav>

            <div className="flex items-center space-x-4">
              <button
                onClick={() => setIsDarkMode(!isDarkMode)}
                className={`p-2 rounded-lg ${isDarkMode ? 'hover:bg-gray-700' : 'hover:bg-gray-100'} transition-all duration-200 hover:scale-110`}
                aria-label="Toggle theme"
                title="Toggle theme"
              >
                {isDarkMode ? <Sun className="w-5 h-5 text-yellow-400" /> : <Moon className="w-5 h-5 text-gray-700" />}
              </button>
              
              <button
                onClick={handleTryUnitalk}
                className="bg-gradient-to-r from-indigo-600 to-purple-600 text-white px-4 py-2 rounded-lg hover:from-indigo-700 hover:to-purple-700 transition-all duration-200 font-medium transform hover:scale-105 hover:shadow-lg"
              >
                Try Unitalk
              </button>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section ref={heroRef} className="pt-24 pb-12 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
        <div className="max-w-7xl mx-auto">
          <div className="text-center scroll-animate relative z-10">
            <div className="mb-8">
              <div className={`inline-flex items-center px-4 py-2 rounded-full ${isDarkMode ? 'bg-indigo-900/20 border border-indigo-500/20' : 'bg-indigo-100 border border-indigo-200'} mb-6 hover:scale-105 transition-transform duration-200`}>
                <Sparkles className="w-4 h-4 text-indigo-400 mr-2" />
                <span className="text-sm font-medium text-indigo-400">Introducing Unitalk</span>
              </div>
            </div>
            
            <h1 className={`relative z-10 text-4xl md:text-6xl lg:text-7xl font-bold ${themeClasses.text} mb-6 scroll-animate`}>
                AI that speaks
            <br />
            <span className={`bg-gradient-to-r ${gradientText} bg-clip-text text-transparent drop-shadow-sm`}>
                every language
            </span>
            </h1>
            
            <div className="mb-4 scroll-animate">
              <p className={`text-xl md:text-2xl ${themeClasses.textSecondary} mb-2`}>
                {typingText}
                <span className="animate-pulse">|</span>
              </p>
            </div>
            
            <p className={`text-lg md:text-xl ${themeClasses.textSecondary} mb-8 max-w-3xl mx-auto scroll-animate`}>
              Break language barriers with our advanced AI assistant that understands, translates, 
              and communicates naturally in over 50 languages.
            </p>

            {/* Dynamic Language Display */}
            <div className="mb-8 scroll-animate">
              <div className="flex items-center justify-center space-x-4 text-2xl">
                <span className="text-6xl transform hover:scale-110 transition-transform duration-200">{languages[currentLanguage].flag}</span>
                <div className="text-left">
                  <div className={`text-3xl font-bold ${themeClasses.text} transition-all duration-500`}>
                    {languages[currentLanguage].name}
                  </div>
                  <div className={`text-sm ${themeClasses.textTertiary}`}>
                    {languages.find(l => l.code === 'en')?.name || 'Hello'}
                  </div>
                </div>
              </div>
            </div>

            <div className="flex flex-col sm:flex-row gap-4 justify-center scroll-animate">
              <button
                onClick={handleTryUnitalk}
                className="bg-gradient-to-r from-indigo-600 to-purple-600 text-white px-8 py-4 rounded-full hover:from-indigo-700 hover:to-purple-700 transition-all duration-200 font-semibold text-lg flex items-center justify-center space-x-2 shadow-lg hover:shadow-xl transform hover:scale-105"
              >
                <span>Try Unitalk</span>
                <ArrowRight className="w-5 h-5" />
              </button>
              
              <a
                href="#how-it-works"
                className={`${themeClasses.cardBg} border backdrop-blur-lg px-8 py-4 rounded-full ${themeClasses.text} hover:shadow-lg transition-all duration-200 font-semibold text-lg flex items-center justify-center space-x-2 transform hover:scale-105`}
              >
                <Play className="w-5 h-5" />
                <span>See how it works</span>
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section ref={statsRef} className="py-16 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 text-center scroll-animate">
            <div className={`${themeClasses.cardBg} backdrop-blur-lg border rounded-2xl p-8 transform hover:scale-105 transition-all duration-300`}>
              <div className="text-4xl font-bold text-indigo-400 mb-2">{stats.users.toLocaleString()}+</div>
              <div className={`${themeClasses.textSecondary} font-medium`}>Active Users</div>
            </div>
            <div className={`${themeClasses.cardBg} backdrop-blur-lg border rounded-2xl p-8 transform hover:scale-105 transition-all duration-300`}>
              <div className="text-4xl font-bold text-purple-400 mb-2">{stats.languages}+</div>
              <div className={`${themeClasses.textSecondary} font-medium`}>Languages Supported</div>
            </div>
            <div className={`${themeClasses.cardBg} backdrop-blur-lg border rounded-2xl p-8 transform hover:scale-105 transition-all duration-300`}>
              <div className="text-4xl font-bold text-green-400 mb-2">{stats.translations.toLocaleString()}+</div>
              <div className={`${themeClasses.textSecondary} font-medium`}>Translations Made</div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" ref={featuresRef} className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16 scroll-animate">
            <h2 className={`text-3xl md:text-4xl font-bold ${themeClasses.text} mb-4`}>
              Powerful features for global communication
            </h2>
            <p className={`text-lg ${themeClasses.textSecondary} max-w-2xl mx-auto`}>
              Unitalk combines cutting-edge AI with deep language understanding to provide 
              seamless multilingual conversations.
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-16">
            {features.map((feature, index) => (
              <div key={index} className={`scroll-animate ${themeClasses.cardBg} backdrop-blur-lg border rounded-2xl p-6 hover:shadow-lg transition-all duration-300 transform hover:scale-105 hover:-translate-y-2`} style={{ animationDelay: `${index * 100}ms` }}>
                <div className={`w-14 h-14 bg-gradient-to-r ${feature.gradient} rounded-xl flex items-center justify-center text-white mb-4 transform hover:rotate-12 transition-transform duration-200`}>
                  {feature.icon}
                </div>
                <h3 className={`text-xl font-semibold ${themeClasses.text} mb-3`}>{feature.title}</h3>
                <p className={themeClasses.textSecondary}>{feature.description}</p>
              </div>
            ))}
          </div>

          {/* Additional Features Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 scroll-animate">
            {additionalFeatures.map((feature, index) => (
              <div key={index} className={`${themeClasses.cardBg} backdrop-blur-lg border rounded-xl p-4 text-center hover:shadow-md transition-all duration-300 transform hover:scale-105`}>
                <div className={`w-12 h-12 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-lg flex items-center justify-center text-white mx-auto mb-3`}>
                  {feature.icon}
                </div>
                <h4 className={`text-sm font-semibold ${themeClasses.text} mb-1`}>{feature.title}</h4>
                <p className={`text-xs ${themeClasses.textTertiary}`}>{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* How It Works Section */}
      <section id="how-it-works" className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-16 scroll-animate">
            <h2 className={`text-3xl md:text-4xl font-bold ${themeClasses.text} mb-4`}>
              How Unitalk works
            </h2>
            <p className={`text-lg ${themeClasses.textSecondary} max-w-2xl mx-auto`}>
              Three simple steps to start communicating in any language
            </p>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {[
              {
                step: "01",
                title: "Type or Speak",
                description: "Start a conversation in any language you're comfortable with. Unitalk automatically detects your language.",
                icon: <MessageCircle className="w-8 h-8" />
              },
              {
                step: "02", 
                title: "AI Processing",
                description: "Our advanced AI understands your message, considering cultural context and linguistic nuances.",
                icon: <Brain className="w-8 h-8" />
              },
              {
                step: "03",
                title: "Instant Response",
                description: "Get intelligent responses in your preferred language, or translate to communicate across language barriers.",
                icon: <Languages className="w-8 h-8" />
              }
            ].map((step, index) => (
              <div key={index} className="text-center scroll-animate" style={{ animationDelay: `${index * 200}ms` }}>
                <div className={`w-16 h-16 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-full flex items-center justify-center text-white mx-auto mb-4 transform hover:scale-110 transition-all duration-300`}>
                  {step.icon}
                </div>
                <div className="text-sm font-bold text-indigo-400 mb-2">STEP {step.step}</div>
                <h3 className={`text-xl font-semibold ${themeClasses.text} mb-3`}>{step.title}</h3>
                <p className={themeClasses.textSecondary}>{step.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Testimonials Section */}
      <section id="testimonials" className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-4xl mx-auto">
          <div className="text-center mb-16 scroll-animate">
            <h2 className={`text-3xl md:text-4xl font-bold ${themeClasses.text} mb-4`}>
              What users are saying
            </h2>
            <p className={`text-lg ${themeClasses.textSecondary}`}>
              Join thousands of satisfied users worldwide
            </p>
          </div>
          
          <div className={`${themeClasses.cardBg} backdrop-blur-lg border rounded-2xl p-8 text-center scroll-animate relative overflow-hidden`}>
            <div className="flex justify-center mb-4">
              {[...Array(5)].map((_, i) => (
                <Star key={i} className="w-6 h-6 text-yellow-400 fill-current" />
              ))}
            </div>
            
            <div className="mb-6 transition-all duration-500">
              <p className={`text-lg ${themeClasses.text} mb-4 italic`}>
                "{testimonials[currentTestimonial].content}"
              </p>
              <div className="flex items-center justify-center space-x-3">
                <div className="text-3xl">{testimonials[currentTestimonial].avatar}</div>
                <div className="text-left">
                  <div className={`font-semibold ${themeClasses.text}`}>
                    {testimonials[currentTestimonial].name}
                  </div>
                  <div className={`text-sm ${themeClasses.textTertiary}`}>
                    {testimonials[currentTestimonial].role}
                  </div>
                </div>
              </div>
            </div>
            
            <div className="flex justify-center space-x-2">
              {testimonials.map((_, index) => (
                <button
                  key={index}
                  onClick={() => setCurrentTestimonial(index)}
                  className={`w-3 h-3 rounded-full transition-all duration-200 ${index === currentTestimonial ? 'bg-indigo-500' : 'bg-gray-400'}`}
                  aria-label={`Show testimonial ${index + 1}`}
                />
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Use Cases Section */}
      <section id="use-cases" className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div className="scroll-animate">
              <h2 className={`text-3xl md:text-4xl font-bold ${themeClasses.text} mb-6`}>
                Perfect for every scenario
              </h2>
              <p className={`text-lg ${themeClasses.textSecondary} mb-8`}>
                Whether you're learning a new language, conducting international business, 
                or exploring different cultures, Unitalk adapts to your needs.
              </p>
              
              <div className="space-y-4">
                {useCases.map((useCase, index) => (
                  <div key={index} className="flex items-center space-x-3 scroll-animate" style={{ animationDelay: `${index * 100}ms` }}>
                    <CheckCircle className="w-6 h-6 text-green-500 flex-shrink-0" />
                    <span className={themeClasses.textSecondary}>{useCase}</span>
                  </div>
                ))}
              </div>
              
              <button
                onClick={handleTryUnitalk}
                className="mt-8 bg-gradient-to-r from-indigo-600 to-purple-600 text-white px-6 py-3 rounded-lg hover:from-indigo-700 hover:to-purple-700 transition-all duration-200 font-semibold flex items-center space-x-2 transform hover:scale-105 scroll-animate"
              >
                <span>Start chatting now</span>
                <ArrowRight className="w-5 h-5" />
              </button>
            </div>
            
            <div className={`${themeClasses.cardBg} backdrop-blur-lg border rounded-2xl p-8 scroll-animate`}>
              <div className="space-y-6">
                <div className="flex items-start space-x-4 animate-slide-in-left">
                  <div className="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center text-white text-sm font-bold">
                    U
                  </div>
                  <div className="flex-1">
                    <div className={`${isDarkMode ? 'bg-blue-600' : 'bg-blue-100'} rounded-lg p-3 text-sm`}>
                      <span className={isDarkMode ? 'text-white' : 'text-blue-900'}>Hello! How can I help you today?</span>
                    </div>
                  </div>
                </div>

                <div className="flex items-start space-x-4 justify-end animate-slide-in-right">
                  <div className="flex-1 max-w-[80%]">
                    <div className={`${isDarkMode ? 'bg-gray-700' : 'bg-gray-100'} rounded-lg p-3 text-sm`}>
                      <span className={themeClasses.text}>Translate “Good morning” to Japanese.</span>
                    </div>
                  </div>
                  <div className="w-8 h-8 bg-indigo-500 rounded-full flex items-center justify-center text-white text-sm font-bold">
                    Y
                  </div>
                </div>

                <div className="flex items-start space-x-4 animate-slide-in-left">
                  <div className="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center text-white text-sm font-bold">
                    U
                  </div>
                  <div className="flex-1">
                    <div className={`${isDarkMode ? 'bg-blue-600' : 'bg-blue-100'} rounded-lg p-3 text-sm`}>
                      <span className={isDarkMode ? 'text-white' : 'text-blue-900'}>“おはようございます” (Ohayō gozaimasu). Would you like the pronunciation?</span>
                    </div>
                  </div>
                </div>

                <div className="flex items-start space-x-4 justify-end animate-slide-in-right">
                  <div className="flex-1 max-w-[80%]">
                    <div className={`${isDarkMode ? 'bg-gray-700' : 'bg-gray-100'} rounded-lg p-3 text-sm`}>
                      <span className={themeClasses.text}>Yes, and also in Spanish.</span>
                    </div>
                  </div>
                  <div className="w-8 h-8 bg-indigo-500 rounded-full flex items-center justify-center text-white text-sm font-bold">
                    Y
                  </div>
                </div>

                <div className="flex items-start space-x-4 animate-slide-in-left">
                  <div className="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center text-white text-sm font-bold">
                    U
                  </div>
                  <div className="flex-1">
                    <div className={`${isDarkMode ? 'bg-blue-600' : 'bg-blue-100'} rounded-lg p-3 text-sm`}>
                      <span className={isDarkMode ? 'text-white' : 'text-blue-900'}>Spanish: “Buenos días”. Pronunciation: bweh-nos DEE-ahs.</span>
                    </div>
                  </div>
                </div>

              </div>
            </div>
          </div>
        </div>
      </section>

      {/* FAQ Section */}
      <section id="faq" className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-3xl mx-auto">
          <div className="text-center mb-10 scroll-animate">
            <h2 className={`text-3xl md:text-4xl font-bold ${themeClasses.text} mb-4`}>Frequently asked questions</h2>
            <p className={`text-lg ${themeClasses.textSecondary}`}>Everything you need to get started quickly.</p>
          </div>
          <div className="space-y-4">
            {faqs.map((item, idx) => {
              const open = faqOpen === idx;
              return (
                <div key={idx} className={`${themeClasses.cardBg} border rounded-xl overflow-hidden scroll-animate`}>
                  <button
                    onClick={() => setFaqOpen(open ? null : idx)}
                    className="w-full flex items-center justify-between px-5 py-4"
                    aria-expanded={open}
                  >
                    <span className={`font-medium ${themeClasses.text}`}>{item.q}</span>
                    <ChevronDown className={`w-5 h-5 transition-transform ${open ? 'rotate-180' : ''} ${themeClasses.textSecondary}`} />
                  </button>
                  <div className={`px-5 transition-all ${open ? 'py-4 max-h-40' : 'py-0 max-h-0'} overflow-hidden`}>
                    <p className={themeClasses.textSecondary}>{item.a}</p>
                  </div>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* Call-to-Action */}
      <section className="py-16 px-4 sm:px-6 lg:px-8">
        <div className={`${themeClasses.cardBg} max-w-5xl mx-auto border rounded-2xl p-8 text-center scroll-animate`}>
          <h3 className={`text-2xl md:text-3xl font-bold ${themeClasses.text} mb-3`}>Ready to talk without borders?</h3>
          <p className={`${themeClasses.textSecondary} mb-6`}>Jump into a conversation and experience instant understanding.</p>
          <button
            onClick={handleTryUnitalk}
            className="bg-gradient-to-r from-indigo-600 to-purple-600 text-white px-8 py-3 rounded-full hover:from-indigo-700 hover:to-purple-700 transition-all duration-200 font-semibold flex items-center justify-center space-x-2 mx-auto transform hover:scale-105"
          >
            <span>Open Chatbot</span>
            <ArrowRight className="w-5 h-5" />
          </button>
        </div>
      </section>

      {/* Footer */}
      <footer className={`px-4 sm:px-6 lg:px-8 pb-10`}>
        <div className="max-w-7xl mx-auto">
          <div className="flex flex-col md:flex-row items-center justify-between gap-4">
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-lg flex items-center justify-center">
                <Sparkles className="w-5 h-5 text-white" />
              </div>
              <span className={`font-semibold ${themeClasses.text}`}>Unitalk</span>
            </div>
            <div className="flex items-center gap-6">
              <a href="#features" className={`${themeClasses.textSecondary} hover:underline`}>Features</a>
              <a href="#how-it-works" className={`${themeClasses.textSecondary} hover:underline`}>How it works</a>
              <a href="#faq" className={`${themeClasses.textSecondary} hover:underline`}>FAQ</a>
              <button onClick={handleTryUnitalk} className="text-indigo-400 hover:text-indigo-300">Open Chatbot →</button>
            </div>
          </div>
          <div className={`text-center mt-6 text-sm ${themeClasses.textTertiary}`}>© {new Date().getFullYear()} Unitalk. All rights reserved.</div>
        </div>
      </footer>

      {/* Inline animation styles (for Tailwind-light setups) */}
        <style>{`
        /* Smooth aurora blobs */
        .aurora-blob {
            position: absolute;
            width: 60vmax;
            height: 60vmax;
            border-radius: 50%;
            filter: blur(60px);
            opacity: 0.35;
            animation: aurora 20s ease-in-out infinite;
            transform: translateZ(0);
        }
        .aurora-light {
            background: radial-gradient(35% 40% at 50% 50%, rgba(99,102,241,0.35), rgba(168,85,247,0.25), rgba(236,72,153,0.15) 70%, transparent 75%);
        }
        .aurora-dark {
            background: radial-gradient(35% 40% at 50% 50%, rgba(99,102,241,0.25), rgba(168,85,247,0.18), rgba(236,72,153,0.1) 70%, transparent 75%);
        }
        @keyframes aurora {
            0% { transform: translate3d(0,0,0) scale(1); }
            50% { transform: translate3d(3%, -2%, 0) scale(1.06); }
            100% { transform: translate3d(0,0,0) scale(1); }
        }

        /* Bidirectional scroll reveal */
        .scroll-animate { opacity: 0; transform: translateY(14px); }
        .scroll-animate.is-visible { opacity: 1; transform: translateY(0); }

        /* Optional chat bubble slide-ins */
        @keyframes slideInLeft { 0% { opacity: 0; transform: translateX(-16px); } 100% { opacity: 1; transform: translateX(0); } }
        @keyframes slideInRight { 0% { opacity: 0; transform: translateX(16px); } 100% { opacity: 1; transform: translateX(0); } }
        .animate-slide-in-left { animation: slideInLeft 500ms ease-out both; }
        .animate-slide-in-right { animation: slideInRight 500ms ease-out both; }
        `}</style>
    </div>
  );
};

export default UnitalkLanding;