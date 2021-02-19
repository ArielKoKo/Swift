//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Ariel Ko on 2021/2/4.
//  Copyright © 2021 AppCoda. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    @IBOutlet var closerateButton: UIButton!
    
    var restaurant: RestaurantMO!
    


    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let restaurantImage = restaurant.image {
            backgroundImageView.image = UIImage(data: restaurantImage as Data)
        }
        
        //背景加入模糊與變暗視覺效果
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        let moveTopTransform = CGAffineTransform.init(translationX: 0, y: -600)
        
        
        
        //將所有評價按鈕變成隱藏與按鈕位置從右側
        for rateButton in rateButtons {
            rateButton.transform = moveScaleTransform
            rateButton.alpha = 0
        }
        
        //將關閉按鈕變成隱藏與按鈕位置從上側
        closerateButton.transform = moveTopTransform
        closerateButton.alpha = 0
        
    
    }

    //MARK: - 建立淡入效果
//    override func viewWillAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 0.4,delay: 0.1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
//            self.rateButtons[0].alpha = 1.0
//            self.rateButtons[0].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4,delay: 0.15,options: [], animations: {
//            self.rateButtons[1].alpha = 1.0
//            self.rateButtons[1].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4,delay: 0.2,options: [], animations: {
//            self.rateButtons[2].alpha = 1.0
//            self.rateButtons[2].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4,delay: 0.25,options: [], animations: {
//            self.rateButtons[3].alpha = 1.0
//            self.rateButtons[3].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4,delay: 0.3,options: [], animations: {
//            self.rateButtons[4].alpha = 1.0
//            self.rateButtons[4].transform = .identity
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.4,delay: 0.3,options: [], animations: {
//            self.closerateButton.alpha = 1.0
//            self.closerateButton.transform = .identity
//        }, completion: nil)
        
    
    //重複alpha = 0 & transform = .identity 用for-in迴圈取代
    override func viewWillAppear(_ animated: Bool) {
        for index in 0...4 {
            UIView.animate(withDuration: 0.4,delay: (0.1+0.05 * Double(index)), options: [], animations: {
                    self.rateButtons[index].alpha = 1.0
                    self.rateButtons[index].transform = .identity
                }, completion: nil)
            }
        }
        
    

    }
       

