import image2 from "./assets/Image 2.png"
import image4 from "./assets/Image 4.png"
import image5 from "./assets/Image 5.png"

const Overview = () => {
  return(
    <div className="overview-container">
      <div className="imagebaru">
        <img src={image5} alt="" />
      </div>
      <div className="imagebaru">
        <img src={image4} alt="" />
      </div>
      <div className="imagebaru">
        <img src={image2} alt="" />
      </div>
    </div>
  )
}

export default Overview