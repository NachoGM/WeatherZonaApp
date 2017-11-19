//
//  AllTemperatuerCheckedVC.swift
//  WeatherZonaApp
//
//  Created by Nacho MAC on 19/11/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit
import CoreData
class AllTemperatuerCheckedVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // Var declared
    var city: [Weather] = []
    var dates: [Weather] = []
    var temp: [Weather] = []
    var weather: [Weather] = []
    var iconURL: [Weather] = []
    
    var allCities : [String] = []
    var allDates : [String] = []
    var allTemps : [String] = []
    var allWeather: [String] = []
    var allIcons: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        // Enable CollectionView DataSource & Delegate and reload data
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()    }

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
                        print("TOTAL = \(city)")
                    }
                    
                    if let date = result.value(forKey: "dates") as? String {
                        allDates.append(date)
                        print("TOTAL = \(date)")
                    }
                    
                    if let weather = result.value(forKey: "weather") as? String {
                        allWeather.append(weather)
                        print("TOTAL = \(weather)")
                    }
                    
                    if let temp = result.value(forKey: "temp") as? String {
                        allTemps.append(temp)
                        print("TOTAL = \(temp)")
                    }
                    
                    if let icon = result.value(forKey: "iconURL") as? String {
                        allIcons.append(icon)
                        print("TOTAL = \(icon)")
                    }
                }
            }
        } catch {
            print("Error fetching data")
        }
    }
    
    // MARKS: CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.allCities.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let cityText = self.allCities[indexPath.row]
        let dateText = self.allDates[indexPath.row]
        let tempText = "\(self.allTemps[indexPath.row]) ºC"
        cell.cityLabel.text = cityText
        cell.dateLabel.text = dateText
        cell.temperatureLabel.text = tempText
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 2 - 1
        
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailedView = self.storyboard?.instantiateViewController(withIdentifier: "WeatherSearchedVC") as! WeatherSearchedVC
        detailedView.cityName = allCities[indexPath.row]
        detailedView.cityTemperatue = allDates[indexPath.row]
        detailedView.iconURL = allIcons[indexPath.row]
        detailedView.cityWeather = allWeather[indexPath.row]
        detailedView.cityTemperatue = allTemps[indexPath.row]
        self.present(detailedView, animated: true, completion: nil)
         
    }
     
    
    // MARKS: Display Button Actions
    @IBAction func back(_ sender: Any) {

        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
