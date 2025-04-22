
import {  BrowserRouter,Route, Routes} from 'react-router-dom';
import Home from './pages/Home';
import Navigation from './components/Navigation';

import './App.css'
import './index.css'

import AddTask from './pages/AddTask';
import ViewTask from './pages/ViewTask';
import EditTask from './pages/EditTask';



function App() {
  return (
    <BrowserRouter>
    <div className="grid md:grid-cols-1">
      <Navigation />
    </div>
    <main className="grid">
      <Routes>
          <Route path="/" element={<Home />} />
          <Route path="addtask" element={<AddTask />} />
          <Route path="viewtask">
              <Route  path=":id" element={<ViewTask />} />
          </Route>
          <Route path="edittask">
              <Route  path=":id" element={<EditTask />} />
          </Route>
      </Routes>
    </main>
  </BrowserRouter>
  )
}

export default App
