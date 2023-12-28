import instagram from "./assets/instagram.svg"
import youtube from "./assets/youtube.svg"
import x from "./assets/x-twitter.svg"

const Footer = () => {
  return (
    <div className="footer-container">
      <div className="footer-information">
        <div className="address">
          <h2>LUMERCÉ COMPANY</h2>
          <p>123 Main Street</p>
          <p>Cityville, STATE 56789</p>
          <p>Phone: (555) 555-1234</p>
          <p>Email: info@example.com</p>
        </div>
        <div className="partnership">
          <h2>Partnership</h2>
          <a href="*">Wholesale Inquiries</a>
          <a href="*">Collaborations</a>
          <a href="*">Affiliate Program</a>
        </div>
        <div className="help">
          <h2>Get Help</h2>
          <a href="*">Customer Support</a>
          <a href="*">FAQs</a>
          <a href="*">Contact Us</a>
          <a href="*">Privacy Policy</a>
          <a href="*">Terms of Service</a>
        </div>
      </div>
      <div className="footer-overview">
        <h2>Lu’mercé</h2>
        <p>Timeless fashion, modern sophistication. Each piece a story of enduring beauty, curated for refined individuality. Founded in 1376, Lu’mercé redefines fashion with a unique blend of modern design and timeless appeal. Join us on a journey where every garment tells a tale of enduring allure.</p>
      </div>
      <div className="footer-social">
        <a href="*"><img src={youtube} alt="" /></a>    
        <a href="*"><img src={instagram} alt="" /></a>    
        <a href="*"><img src={x} alt="" /></a>    
      </div>
      <div className="footer-bottom">
        <h2>©2023 LUMERCÉ COMPANY. All rights reserved</h2>
      </div>
    </div>
  )
};

export default Footer;
