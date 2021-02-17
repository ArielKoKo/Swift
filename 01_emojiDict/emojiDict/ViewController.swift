//
//  ViewController.swift
//  S3 Homework #2
//
//  Created by apple on 2021/1/19.
//  Copyright © 2021 ArielKo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black
        
        
    }
    
    @IBAction func showMessage(sender: UIButton) {
    
        let emojiDict = ["👾": "Alien monster", "👻": "Ghost", "🤓": "Nerdy", "🤖": "Robot"]
    
        let selectionButton = sender
        
        if let wordToLookup = selectionButton.titleLabel?.text {
            let meaning = emojiDict[wordToLookup]
            
            let alertControllar = UIAlertController(title: "Meaning", message: meaning, preferredStyle: UIAlertController.Style.alert)
            
            alertControllar.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alertControllar, animated: true, completion: nil)
            
        }
    
    }

}
