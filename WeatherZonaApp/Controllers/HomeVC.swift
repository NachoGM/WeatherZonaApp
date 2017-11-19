//
//  HomeVC.swift
//  WeatherZonaApp
//
//  Created by Nacho MAC on 17/11/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit
import MapKit
import SystemConfiguration
import CoreData
import CoreLocation
import SVProgressHUD
import Alamofire
import SwiftyJSON

protocol Utilities {
}
class HomeVC: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {

    
    // MARKS: Declare outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var loadWeatherCheckedBtn: UIButton!
    
    // MARKS: Declare NSLayout 4 animation
    @IBOutlet weak var button1Constraint: NSLayoutConstraint!
    @IBOutlet weak var button2Constraint: NSLayoutConstraint!
    
    var currentLocation = String()
    var citySelected = ""
    var tempArray = [Double]()
    var mapView = MKMapView()
    let location = CLLocationManager()
    
    
     // Declare vars 4 Core Data
     var City: [NSManagedObject] = []
     var Temp: [NSManagedObject] = []
     var WEather: [NSManagedObject] = []
     var IconURL: [NSManagedObject] = []
     var date: [NSManagedObject] = []

     var city: [Weather] = []
     var temp: [Weather] = []
     var weather: [Weather] = []
     var iconURL: [Weather] = []
     var dates: [Weather] = []

     var allCities: [String] = []
     var allDates: [String] = []
     var allWeather: [String] = []
     var allIcons: [String] = []
     var allTemps: [String] = []

    // MARKS: Declare var
    var animationPerformedOnce = false
     

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Check internet connections
        if (currentReachabilityStatus != .notReachable) != true {
            
            print("No internet connexion")
            
            OperationQueue.main.addOperation({
                self.displayMyAlertMessage(userMessage: "You have your wifi disabled. Please turn it on and try it again.")
                return;
            })
            
        } else {

            customButtons()
            constantsVC()
        }

        
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        constantsVC()
        
    }
    
    
    func constantsVC() {
        
        button1Constraint.constant -= view.bounds.width
        button2Constraint.constant -= view.bounds.width
    }
    
    
    func customButtons() {
                
        loadWeatherCheckedBtn.layer.cornerRadius = loadWeatherCheckedBtn.frame.size.width / 2
        loadWeatherCheckedBtn.layer.borderWidth = 2;
        loadWeatherCheckedBtn.layer.borderColor = UIColor.white.cgColor
        loadWeatherCheckedBtn.layer.shadowOpacity = 0.6
        loadWeatherCheckedBtn.layer.shadowColor = UIColor.gray.cgColor
        loadWeatherCheckedBtn.layer.shadowRadius = 5
        loadWeatherCheckedBtn.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        searchBtn.layer.cornerRadius = searchBtn.frame.size.width / 2
        searchBtn.layer.borderWidth = 2;
        searchBtn.layer.borderColor = UIColor.white.cgColor
        
        searchBtn.layer.shadowOpacity = 0.6
        searchBtn.layer.shadowColor = UIColor.gray.cgColor
        searchBtn.layer.shadowRadius = 5
        searchBtn.layer.shadowOffset = CGSize(width: 5, height: 0)
    }
    
    
    // MARKS: Display Animation
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if !animationPerformedOnce {
            
            UIView.animate(withDuration: 0.5, delay: 1.2, options: .curveEaseOut, animations: {
                self.button1Constraint.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                self.button2Constraint.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            

            
            
        }
    }
    
    // MARKS: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }


    // MARKS: Declare Location Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        SVProgressHUD.show(withStatus: "Loading Weather...")

        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
        let Localizacion = ("\(location.coordinate.latitude), \(location.coordinate.longitude)")
        print("CURRENT LOCATION = \(Localizacion)")
        
        // Get metadata from lat & lng and get our position info
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            // Print each key-value pair in a new row
            addressDict.forEach { print($0) }
            
            // Print fully formatted address
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                print(formattedAddress.joined(separator: ", "))
            }
            
            // Access each element manually
            if let locationName = addressDict["Name"] as? String {
                print(locationName)
                self.locationLabel.text = locationName
            }
            
            if let street = addressDict["Thoroughfare"] as? String {
                print(street)
            }
            
            if let city = addressDict["City"] as? String {
                print(city)
                
                let apiKey = "b892341f84449eb8"

                Alamofire.request("http://api.wunderground.com/api/\(apiKey)/conditions/q/Spain/\(city).json", method: .post).responseData { response in
                    
                    debugPrint("All Response Weather Info: \(String(describing: response))")
                    
                    
                    if((response.result.value != nil)){
                        
                        let jsonData = JSON(response.result.value!)
                        let currentObservation = jsonData["current_observation"]
                        let temp = currentObservation["temp_c"]
                        let icon = currentObservation["icon_url"]
                        let weather = currentObservation["weather"]

                        print("WEATHER = \(weather)")
                        print("ICON URL = \(icon)")
                        print("TEMP ºC = \(temp)")
                        
                        // Put info in labels & img
                        self.cityLabel.text = city
                        self.tempLabel.text = "\(temp) ºC"
                        self.weatherLabel.text = "\(weather)"
                        
                        let url = URL(string: "\(icon)")
                        let data = try? Data(contentsOf: url!)
                        
                        if data != nil {
                            let image = UIImage(data: data!)
                            self.myImageView.image = image
                        }
                    }
                    SVProgressHUD.dismiss()
                }
            }
            
            if let zip = addressDict["ZIP"] as? String {
                print(zip)
            }
            
            if let country = addressDict["Country"] as? String {
                print(country)
            }
        })
        mapView.showsUserLocation = true
    }
    
    
    // MARKS: Search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        // Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // Create the search request
        let searchRequest = MKLocalSearchRequest()
        
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        citySelected = searchRequest.naturalLanguageQuery!
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print("ERROR")
                
            } else {
                
                // Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                let cordinates = ("\(latitude!, longitude!)")
                print("COORDINATE = \(cordinates)")

                
                // Get date of last checked
                let dateformatter = DateFormatter()
                dateformatter.locale = Locale(identifier: "es")
                dateformatter.setLocalizedDateFormatFromTemplate("ddMMyy hh:mm:ss")
                dateformatter.dateStyle = DateFormatter.Style.short
                dateformatter.timeStyle = DateFormatter.Style.medium
                let Fecha = dateformatter.string(from: Date())
                
                // Start Alamofire
                let apiKey = "b892341f84449eb8"
                let city = self.citySelected

                Alamofire.request("http://api.wunderground.com/api/\(apiKey)/conditions/q/Spain/\(city).json", method: .post).responseData { response in
                    
                    debugPrint("All Response Weather Info: \(String(describing: response))")

                    if((response.result.value != nil)){
                        
                        let jsonData = JSON(response.result.value!)
                        let currentObservation = jsonData["current_observation"]
                        let temp = currentObservation["temp_c"]
                        let icon = currentObservation["icon_url"]
                        let weather = currentObservation["weather"]

                        print("WEATHER = \(weather)")
                        print("ICON URL = \(icon)")
                        print("TEMP ºC = \(temp)")
                        
                        // save data in coredata
                         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                         
                        let temperature = Weather(context:context)
                        temperature.city = city
                        temperature.temp = "\(temp)"
                        temperature.dates = Fecha
                        temperature.weather = "\(weather)"
                        temperature.iconURL = "\(icon)"
                        
                         (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        
                        
                        // Pass values to WeatherSearchedVC
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WeatherSearchedVC") as! WeatherSearchedVC
                        vc.cityName = city
                        vc.cityTemperatue = "\(temp) ºC"
                        vc.cityWeather = "\(weather)"
                        vc.iconURL = "\(icon)"
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    
    // MARKS: Alert Dialog
    func displayMyAlertMessage(userMessage: String) {
        
        let myAlert = UIAlertController(title:"Ups...", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "Understood", style: UIAlertActionStyle.default, handler: nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
    }

    
    // MARKS: Get data from Core Data
    func getData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName : "Weather")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let city = result.value(forKey: "city") as? String {
                        allCities.append(city)
                        print("TITLE = \(city)")
                    }
                    
                    if let date = result.value(forKey: "dates") as? String {
                        allDates.append(date)
                        print("DATE = \(date)")
                    }
                    
                    if let icon = result.value(forKey: "iconURL") as? String {
                        allIcons.append(icon)
                        print("ICON = \(icon)")
                    }
                    
                    if let weather = result.value(forKey: "weather") as? String {
                        allWeather.append(weather)
                        print("WEATHER = \(weather)")
                    }
                    
                    if let temperature = result.value(forKey: "temp") as? String {
                        allTemps.append(temperature)
                        print("ORIGINAL LANGUAGE = \(temperature)")
                    }
                    
                }
                
                // If everything is fine, pass to MoviesCheckedVC
                let detailedView = self.storyboard?.instantiateViewController(withIdentifier: "AllTemperatuerCheckedVC") as! AllTemperatuerCheckedVC
                self.present(detailedView, animated: true, completion: nil)
                
            } else {
                displayMyAlertMessage(userMessage: "You must search anything first.")
                return;
            }
            
        } catch {
            print("Error fetching data")
        }
    }
    
    // MARKS: Declare Actions
    @IBAction func lastCheckedBtn(_ sender: Any) {
        
        getData()
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
}


// MARKS: Extension 4 check if internet is avaiable
extension NSObject:Utilities{
    
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
}
