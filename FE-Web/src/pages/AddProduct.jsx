// import React, { useState } from "react";
import Footer from "../components/Footer";
import Form from "../components/FormProduct";
import Header from "../components/Header";
import React, { useEffect } from 'react';

const CreateProduct = () => {
  useEffect(() => {
    document.title = 'Lu’mercé | Admin Add Product';
    return () => {
    };
  }, []);

  const navTit = "Add Product";
  return (
    <div>
      <Header navTit={navTit}/>
      <Form />
      <Footer />
    </div>
  );
};

export default CreateProduct;