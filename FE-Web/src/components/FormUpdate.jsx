import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';

const UpdateForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const [formData, setFormData] = useState({
    name: '',
    image: '',
    overview: '',
    quantity: 0,
    price: 0,
    description: '',
  });

  useEffect(() => {
    // Ambil data produk yang sudah ada berdasarkan ID
    // console.log(formData.description)
    const fetchProductData = async () => {
      try {
        const response = await fetch(`https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products/${id}`);
        if (response.ok) {
          const productData = await response.json();
          // Isi nilai bidang formulir dengan data yang sudah ada
          setFormData(productData.data);
        } else {
          console.error('Gagal mengambil data produk:', response.statusText);
        }
      } catch (error) {
        console.error('Terjadi kesalahan mengambil data produk:', error.message);
      }
    };

    fetchProductData();
  }, [id]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevData) => ({
      ...prevData,
      [name]: value,
    }));
  };

  const handleSubmit = async () => {
    try {
      const response = await fetch(`https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      if (response.ok) {
        console.log('Product updated successfully!');
        navigate('/dashboard');
      } else {
        console.error('Failed to update product:', response.statusText);
      }
    } catch (error) {
      console.error('Error submitting form:', error.message);
    }
  };

  return(
    <div className="form-container">
      <div className="form">
        <div className="form-text">
          <div className="form-col">
            <div>
              <h4>Name</h4>
              <input type="text" name="name" value={formData.name} onChange={handleChange} />
            </div>
            <div>
              <h4>Image URL</h4>
              <input type="text" name="image" value={formData.image} onChange={handleChange} />
            </div>
            <div>
              <h4>Overview</h4>
              <input type="text" name="overview" value={formData.overview} onChange={handleChange} />
            </div>
            <div>
              <h4>Category</h4>
              <input type="text" name="category" value={formData.category} onChange={handleChange} />
            </div>
            <div>
              <h4>Quantity</h4>
              <input type="number" name="quantity" value={formData.quantity} onChange={handleChange} />
            </div>
            <div>
              <h4>Price</h4>
              <input type="number" name="price" value={formData.price} onChange={handleChange} />
            </div>
          </div>
          <div className="form-det">
            <div>
              <h4>Detail</h4>
              <textarea name="description" value={formData.description} onChange={handleChange}/>
            </div>
          </div>
        </div>
        <div className="form-button">
          <button onClick={handleSubmit}>Submit Change</button>
        </div>
      </div>
    </div>
  )
}

export default UpdateForm