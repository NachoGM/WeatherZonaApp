//
//  WebCityImagesVC.swift
//  WeatherZonaApp
//
//  Created by Nacho MAC on 19/11/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit

class WebCityImagesVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var nameCity: String!
     
    override func viewDidLoad() {
        super.viewDidLoad()

        print("NAME CITY IS... \(nameCity!)")
        // Do any additional setup after loading the view.
        webImageCity()
    }

    // MARKS: Display web func
    func webImageCity() {
        let visualfyURL = URL(string: "https://www.google.es/search?q=\(nameCity!)&source=lnms&tbm=isch&sa=X&ved=0ahUKEwj5zf-D0svXAhUKvBQKHbD3BAgQ_AUIDCgD&biw=1603&bih=877")
        let visualfyURLRequest = URLRequest(url: visualfyURL!)
        webView.loadRequest(visualfyURLRequest)
    }

    @IBAction func backBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
