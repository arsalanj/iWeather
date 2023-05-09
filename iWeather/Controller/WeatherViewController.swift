//
//  ViewController.swift
//  iWeather
//
//  Created by Muhammad Mehdi on 08/05/2023.
//



import UIKit





class WeatherViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var forecastTableView: UITableView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var lastFetchedLabel: UILabel!
    
    let indicatorView = UIActivityIndicatorView(style: .gray)
    let refreshControl = UIRefreshControl()
    
    
    var forecastData: [Forecast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastTableView.dataSource = self
        forecastTableView.delegate = self
        
        indicatorView.hidesWhenStopped = true
        forecastTableView.tableHeaderView = indicatorView
        refreshControl.addTarget(self, action: #selector(refreshButtonTapped), for: .valueChanged)
        forecastTableView.refreshControl = refreshControl
        
        fetchWeatherData()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIButton) {
        print("refreshButtonTapped")
        fetchWeatherData()
    }
    
    func fetchWeatherData() {
        
        
        indicatorView.startAnimating()
        
        
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=43.58&longitude=-79.66&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto") else {
            print("Invalid URL")
            return
        }
        
        
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            
            DispatchQueue.main.async {
                self?.indicatorView.stopAnimating()
                self?.refreshControl.endRefreshing()
                
                
            }
            guard let data = data else {
                
                //                print()
                self?.showError(error: "Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                self?.processWeatherData(weatherData)
            } catch {
                
                //                print()
                self?.showError(error: "Error decoding weather data: \(error.localizedDescription)")
                
            }
        }.resume()
    }
    
    func processWeatherData(_ weatherData: WeatherData) {
        print("processWeatherData")
        
        // Get current date
        let currentDate = Date()
        
        // Create a date formatter
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd-MM-yy HH:mm:ss" // Customize the date format as per your requirement
        
        // Convert the date to a string
        let dateString = dateFormatter1.string(from: currentDate)
        

        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //        2023-05-08
        
        
        let numDays = min(weatherData.daily.time.count, 5)
        forecastData = Array(0..<numDays).map { index in
            let date = weatherData.daily.time[index]
            //            let temperature = weatherData.hourly.temperature_2m[index]
            let precipitationProbability = weatherData.daily.precipitation_probability_max[index]
            
            let minTemperature = weatherData.daily.temperature_2m_min[index]
            let maxTemperature = weatherData.daily.temperature_2m_max[index]
            
            var dateString = date
            if let formattedDate = dateFormatter.date(from: date){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMM d"
                
                dateString = dateFormatter.string(from: formattedDate)
            }
            
            let forecast = Forecast(date: dateString, minTemperature: minTemperature, maxTemperature: maxTemperature, precipitationProbability: precipitationProbability)
            
            return forecast
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.locationLabel.text = "City: Mississauga, ON" // Replace with your desired location
            self?.forecastTableView.reloadData()
            // Set the fetched date to the label
            self?.lastFetchedLabel.text = "Last fetched on: \(dateString)"
            
        }
    }
    
    
    func showError(error:String){
        DispatchQueue.main.async {
            
            self.errorLabel.isHidden = false
            self.errorLabel.text = error
        }
        
    }
    
    func hideError(){
        DispatchQueue.main.async {
            
            self.errorLabel.isHidden = true
        }
    }
    
}

extension WeatherViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastCell else {
            return UITableViewCell()
        }
        
        let forecast = forecastData[indexPath.row]
        cell.configure(with: forecast)
        
        return cell
    }
    
    
    
}

