// import React, { useState } from "react";
import Footer from "../components/Footer";
import UpdateForm from "../components/FormUpdate";
import Header from "../components/Header";
import React, { useEffect } from 'react'

const UpdateProduct = () => {
  useEffect(() => {
    document.title = 'Lu’mercé | Admin Update Product';
    return () => {
    };
  }, []);

  const navTit = "Edit Product";
  return (
    <div>
      <Header navTit={navTit}/>
      <UpdateForm />
      <Footer />
    </div>
  );
};

export default UpdateProduct;