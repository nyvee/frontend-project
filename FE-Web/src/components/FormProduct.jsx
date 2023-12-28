import { useState } from 'react';
import { useNavigate } from 'react-router-dom';

const Form = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    name: '',
    image: '',
    overview: '',
    description: '',
    quantity: 0,
    price: 0,
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData((prevData) => ({
      ...prevData,
      [name]: value,
    }));
  };

  const handleSubmit = async () => {
    try {
      const response = await fetch('https://ecommerce-api-ofvucrey6a-uc.a.run.app/api/products', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      if (response.ok) {
        console.log('Product created successfully!');
        navigate('/dashboard');
      } else {
        console.error('Failed to create product:', response.statusText);
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
          <button onClick={handleSubmit}>Create new Product</button>
        </div>
      </div>
    </div>
  )
}

export default Form