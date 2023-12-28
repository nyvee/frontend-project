import Footer from "../components/Footer"
import Home from "../components/Home"
import Overview from "../components/Overview"
import Superiority from "../components/Superiority"
import React, { useEffect } from 'react';

const Landing = () => {
  useEffect(() => {
    document.title = 'Lu’mercé | Home';
    return () => {
    };
  }, []);
  
  return(
    <div>
      <Home />
      <Overview />
      <Superiority />
      <Footer />
    </div>
  )
}

export default Landing