//
//  WebViewController.swift
//  FoodPin
//
//  Created by Ariel Ko on 2021/2/10.
//  Copyright © 2021 AppCoda. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var targetURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let url = URL(string: targetURL) {
            let request = URLRequest(url: url)
            webView.load(request)
        }

    }
    


}
