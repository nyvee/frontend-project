import React, {useState, useEffect} from "react"
import image from "./assets/Image 3.png"

const Home = () => {
  const [scroll, setScroll] = useState(false);
  const handleScroll = () => {
    setScroll(true);
  };
  useEffect(() => {
    if (scroll) {
      window.scrollTo({
        top: window.innerHeight,
        behavior: "smooth",
      });
      setScroll(false);
    }
  }, [scroll]);

  return(
    <div className="home-container">
      <div className="home-title">
        <h1>Lu’mercé</h1>
      </div>
      <div className="home-center">
        <div className="image">
          <img src={image} alt=""/>
        </div>
        <div className="home-text">
          <h2>Discover.</h2>
          <h2>Sophistication.</h2>
          <h2>Fashion.</h2>
        </div>
      </div>
      <button onClick={handleScroll}>Scroll Down</button>
    </div>
  )
}

export default Home