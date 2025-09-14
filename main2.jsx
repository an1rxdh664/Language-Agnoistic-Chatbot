import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './Unitalk.jsx'
import Unitalk from './Unitalk.jsx'
import AIChatbot from './Redesigned.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <AIChatbot />
  </StrictMode>,
)