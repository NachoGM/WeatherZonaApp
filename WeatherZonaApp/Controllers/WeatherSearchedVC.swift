//
//  WeatherSearchedVC.swift
//  WeatherZonaApp
//
//  Created by Nacho MAC on 18/11/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit

class WeatherSearchedVC: UIViewController {

    // MARKS: Declare variables
    var cityName = String()
    var cityTemperatue = String()
    var cityWeather = String()
    var iconURL = String()
    
    // MARKS: Declare var
    var animationPerformedOnce = false
    
    // MARKS: Declare outlets
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var imageGallery: UIButton!
    // MARKS: Declare NSLayout 4 animation
    @IBOutlet weak var button1Constraint: NSLayoutConstraint!
    @IBOutlet weak var button2Constraint: NSLayoutConstraint!
    @IBOutlet weak var button3Constraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load func here
        constantsVC()
        
        customButtons()
        
        getInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        constantsVC()

    }

    // MARKS: Display constants
    func constantsVC() {
        
        button1Constraint.constant -= view.bounds.width
        button2Constraint.constant -= view.bounds.width
        button3Constraint.constant -= view.bounds.width

    }
    
    
    
    // MARKS: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    
    // MARKS: Display info in Outlets
    func getInfo() {
        city.text = cityName
        temperature.text = "\(cityTemperatue)ºC"
        weather.text = cityWeather
        
        let url = URL(string: iconURL)
        let data = try? Data(contentsOf: url!)
        
        if data != nil {
            let image = UIImage(data: data!)
            myImageView.image = image
        }
    }
    
    // MARKS: Customize buttons
    func customButtons() {
        
        backBtn.layer.cornerRadius = backBtn.frame.size.width / 2
        backBtn.layer.borderWidth = 2;
        backBtn.layer.borderColor = UIColor.white.cgColor
        backBtn.layer.shadowOpacity = 0.6
        backBtn.layer.shadowColor = UIColor.gray.cgColor
        backBtn.layer.shadowRadius = 5
        backBtn.layer.shadowOffset = CGSize(width: 5, height: 0)
          
        shareBtn.layer.cornerRadius = shareBtn.frame.size.width / 2
        shareBtn.layer.borderWidth = 2;
        shareBtn.layer.borderColor = UIColor.white.cgColor
        shareBtn.layer.shadowOpacity = 0.6
        shareBtn.layer.shadowColor = UIColor.gray.cgColor
        shareBtn.layer.shadowRadius = 5
        shareBtn.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        imageGallery.layer.cornerRadius = shareBtn.frame.size.width / 2
        imageGallery.layer.borderWidth = 2;
        imageGallery.layer.borderColor = UIColor.white.cgColor
        imageGallery.layer.shadowOpacity = 0.6
        imageGallery.layer.shadowColor = UIColor.gray.cgColor
        imageGallery.layer.shadowRadius = 5
        imageGallery.layer.shadowOffset = CGSize(width: 5, height: 0)
    }
    
    
    // MARKS: Display Animation
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !animationPerformedOnce {
            
            UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.button1Constraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 0.6, options: .curveEaseOut, animations: {
            self.button2Constraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
            
            UIView.animate(withDuration: 0.5, delay: 0.9, options: .curveEaseOut, animations: {
                self.button3Constraint.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
   
        }
    }
    
    //MARKS: Display Actions here
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareBtn(_ sender: Any) {
        
        // text to share
        let text = "Download the best weather app ever!"
        
        // set up activity view controller
        let textToShare = [ text  ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }

    @IBAction func imageGalleryBtn(_ sender: Any) {
        
        
        // Pass values to WeatherSearchedVC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebCityImagesVC") as! WebCityImagesVC
        vc.nameCity = self.cityName
        self.present(vc, animated: true, completion: nil)
    }
    
}
