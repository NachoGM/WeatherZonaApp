//
//  SettingsVC.swift
//  WeatherZonaApp
//
//  Created by Nacho MAC on 17/11/2017.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let visualfyURL = URL(string: "https://www.visualfy.es/sobre-nosotros?ls=enabled")
        let visualfyURLRequest = URLRequest(url: visualfyURL!)
        webView.loadRequest(visualfyURLRequest)
        
    }
    
    // MARKS: Modify Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
