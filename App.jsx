import {Routes, Route} from 'react-router-dom';

import UnitalkLanding from "./Uni_Webpage.jsx";

import Unitalk from "./Unitalk.jsx";     // CHATBOT PROJECT 

import AIChatbot from './Redesigned.jsx';

import StudentPortal from './LMS_page.jsx';

function App() {
  
  return(
    <Routes>
      <Route path="/" element={<StudentPortal/>} />
      <Route path="/Redesigned" element={<AIChatbot/>} />
    </Routes>

    

  );
}

export default App
