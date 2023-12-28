import Footer from "../components/Footer"
import Header from "../components/Header"
import Tabel from "../components/Table"
import React, { useEffect } from 'react'

const Dashboard = () => {
  useEffect(() => {
    document.title = 'Lu’mercé | Admin Dashboard';
    return () => {
    };
  }, []);

  const navTit = "Dashboard"
  const button = true
  return(
    <div>
      <Header navTit={navTit} showButton={button}/>
      <Tabel/>
      <Footer/>
    </div>
  )
}

export default Dashboard