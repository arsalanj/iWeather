//
//  TableViewCell.swift
//  iWeather
//
//  Created by Muhammad Mehdi on 08/05/2023.
//

import UIKit

 


class ForecastCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    
    
    @IBOutlet weak var cardView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        // Set elevation and shadow
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4

        // Set curved border
        cardView.layer.cornerRadius = 10
//        cardView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]  // Top right and top left corners
        cardView.clipsToBounds = true
        
        cardView.layer.borderWidth = 1.0
        cardView.layer.borderColor = UIColor.gray.cgColor  //
        
        
    }

    
    
    
    func configure(with forecast: Forecast) {
        
    
        
        
        dateLabel.text = forecast.date
        temperatureLabel.text = "Temperature: \(forecast.minTemperature)°C to \(forecast.maxTemperature)°C"
        precipitationLabel.text = "Precipitation: \(forecast.precipitationProbability)%"
    }
    
}
