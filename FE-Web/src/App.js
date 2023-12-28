import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Landing from "./pages/Landing";
import Notfound from "./pages/NotFound";
import AddProduct from "./pages/AddProduct";
import Dashboard from "./pages/Dashboard";
import UpdateProduct from "./pages/UpdateProduct";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Landing />} />
        <Route path="*" element={<Notfound />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/addproduct" element={<AddProduct />} />
        <Route path="/editproduct/:id" element={<UpdateProduct />} />
      </Routes>
    </Router>
  );
}

export default App;
