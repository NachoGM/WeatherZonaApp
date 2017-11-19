//
//  WebZonaAppVC.swift
//  WeatherZonaApp
//
//  Created by Nacho MAC on 18/11/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit
  
class WebZonaAppVC: UIViewController {

    // MARKS: Declare Outlet
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load web
        webZonaApp()
    }

    // MARKS: Display web func
    func webZonaApp() {
        let visualfyURL = URL(string: "http://www.zonaapp.es/")
        let visualfyURLRequest = URLRequest(url: visualfyURL!)
        webView.loadRequest(visualfyURLRequest)
    }
    

}
