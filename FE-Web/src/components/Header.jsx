import logo from "./assets/Brand Icon.png"
import { useNavigate } from 'react-router-dom';

const Header = (props) => {
  const navigate = useNavigate();
  const handleButtonClick = () => {
    navigate('/addproduct');
  };

  return (
    <div className="header">
      <img src={logo} alt="logo" />
      <h1>{props.navTit}</h1>
      {props.showButton && <button onClick={handleButtonClick}>Add Item</button>}
    </div>
  )
}

export default Header