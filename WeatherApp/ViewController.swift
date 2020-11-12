//
//  ViewController.swift
//  WeatherApp
//
//  Created by JOEL CRAWFORD on 11/12/20.
//  Copyright © 2020 JOEL CRAWFORD. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let myCellSize:CGSize = CGSize(width: 337, height: 256) //cell size
    let myVertSpacing:  CGFloat = CGFloat( 8.0 ) //vertical spacing for cell
    
    
    var bookMarkedArray:[WeatherClass] = [] //storing data bookmarked
    
    var forecastData = [WeatherClass]()
    
    
    
    @IBOutlet weak var optionMenuBtn: UIBarButtonItem!
    
    @IBOutlet weak var outerContainerUIView: UIView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    @IBOutlet weak var homeContainerUIView: UIView!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Delegates
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        
        
        updateWeatherForLocation(location: "United Kingdom")
        
    }
    
    //==============
    
    
    @IBAction func searchMenu(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func optionMenuTapped(_ sender: UIBarButtonItem) {
    }
    
    
    
    
    
    
    //=======Collection view =========
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        print("This is total number of items in section: \(forecastData.count)")
        
        return forecastData.count

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print("sizeForItemAt hit!")
        
        return myCellSize
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCVCell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! homeCollectionViewCell
        
        
        let weatherObject = forecastData[indexPath.item]

        myCVCell.locationLabel.text! = weatherObject.cityName
        
        myCVCell.humidity.text! = "\(String(weatherObject.humidity) ) %"
        myCVCell.pressure.text! = "\(String(weatherObject.pressure) ) %"
        
        
        
        
        //Formatting Date
        let unixTimeInterval: Int = weatherObject.date
        let stringDate = Utilities.convertUnixTimeStampToStringDate(unixTimeInterval: unixTimeInterval)
        myCVCell.locationDate.text! = stringDate
        
        
        let convertedTempInCelcius = Utilities.convertFromKelvinToCelcius(tempInKelvin: weatherObject.temperature)
        
        myCVCell.locationTemp.text! = "\(Int(convertedTempInCelcius)) °C"
        
        
        return myCVCell
        
    }
    
    
    
    
    
    
    
}


//======================================================================================================

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: myVertSpacing, left: myVertSpacing, bottom: myVertSpacing, right: myVertSpacing)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return myVertSpacing
        
    }
    
}





extension ViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //calls when the user tap the search bar
        
        //1. hide the keyboard
        searchBar.resignFirstResponder()
        
        //2.checks if the user enters something in the search bar
        if let searchTerm = searchBar.text, !searchTerm.isEmpty{
            
            //update weather for location
            updateWeatherForLocation(location: searchTerm)
            
        }
        
    }
    
    
    
    func updateWeatherForLocation(location: String){
        
        //since the api returns latitude and longitude; we convert them to address using core location
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error: Error?) in
            
            
            if error == nil { //if no error occurs
                //check if we have location, use the first object in,  error and check its location
                if let location = placemarks?.first?.location{
                    WeatherClass.forecast(withLocation: location.coordinate, completion: { (results: [WeatherClass]?) in
                        
                        //we need to check if we have weather info
                        if let weatherData = results {
                            
                            self.forecastData = weatherData //assign the forecast data to weather arrar
                            
                            //reload our data on the dispatch queue
                            DispatchQueue.main.async {
                                
                                self.homeCollectionView.reloadData()
                                
                            }
                        }
                        
                    })
                    
                }
                
            }
        }
        
        
    }
    
}




