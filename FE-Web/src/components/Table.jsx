import { useState, useEffect } from "react"
import { useNavigate } from 'react-router-dom';
import React from "react"
import del from "./assets/delete_forever.png"
import edit from "./assets/edit.png"

const Tabel = () => {

  const [productList, setProductList] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    const apiEndpoint = 'https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products';

    fetch(apiEndpoint)
      .then(response => response.json())
      .then(data => {
        setProductList(data.data);
      })
      .catch(error => console.error('Error fetching data:', error));
  }, []);

  const handleDelete = async (productId) => {
    const shouldDelete = window.confirm('Are you sure about that?');

    
    if (!shouldDelete) {
      return;
    }

    try {
      const response = await fetch(`https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products/${productId}`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (response.ok) {
        setProductList((prevProductList) =>
          prevProductList.filter((product) => product._id !== productId)
        );
      } else {
        console.error('Gagal menghapus produk');
      }
    } catch (error) {
      console.error('Terjadi kesalahan:', error);
    }
  };

  const handleEdit = (productId) => {
    // Navigasi ke halaman formulir update dengan menyertakan ID produk
    navigate(`/editproduct/${productId}`);
  };

  const formatCurrency = (value) => {
    const formatter = new Intl.NumberFormat('id-ID', {
      style: 'currency',
      currency: 'IDR',
      minimumFractionDigits: 0,
    });
  
    return formatter.format(value);
  };
  

  return(
    <div className="table-container">
      <table>
        <thead>
            <tr>
              <th>No.</th>
              <th>Name</th>
              <th>Image</th>
              <th>Stock</th>
              <th>Price</th>
              <th>Action</th>
            </tr>
        </thead>
        <tbody className="this">
        {productList.map((product, index) => (
          <React.Fragment key={index}>
            <tr className="product-row">
              <td className="brdl">{index + 1}</td>
              <td>{product.name}</td>
              <td><img src={product.image} alt={product.name} /></td>
              <td>{product.quantity}</td>
              <td>{formatCurrency(product.price)}</td>
              <td className="brdt">
                <button style={{ border: 'none', background: 'none' }} onClick={() => handleEdit(product._id)}><img src={edit} alt="edit" style={{ width: '20px' }}/></button>
                <button style={{ border: 'none', background: 'none' }} onClick={() => handleDelete(product._id)}><img src={del} alt="delete" style={{ width: '20px' }}/></button>
              </td>
            </tr>
          </React.Fragment>
        ))}

        </tbody>
      </table>
    </div>
  )
}

export default Tabel