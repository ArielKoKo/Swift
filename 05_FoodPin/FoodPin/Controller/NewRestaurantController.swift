//
//  NewRestaurantController.swift
//  FoodPin
//
//  Created by Ariel Ko on 2021/2/5.
//  Copyright © 2021 AppCoda. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class NewRestaurantController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var restaurant: RestaurantMO!

    
    //MARK: - 自訂文字類別
    @IBOutlet var nameTextField: RoundedTextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet var typeTextField: RoundedTextField! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: RoundedTextField! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet var phoneTextField: RoundedTextField! {
        didSet {
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.tag = 5
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
    return true
    }
    
    @IBOutlet var photoImageView: UIImageView!
    

    //MARK: - 視圖控制器生命週期
    override func viewDidLoad() {
        super.viewDidLoad()

        //設置導覽外觀
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 35.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont ]
        }
        
        //移除表格分隔線
        tableView.separatorStyle = .none
    
  }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {(action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
                })
            
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: {(action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                    
                }
            })
            
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            
            
            //針對 iPad
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            present(photoSourceRequestController, animated: true, completion: nil)
            
        }
        
        
    }
    
    //圖片照片取得被選取的參數
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        let leadingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //文字欄位判斷欄位有無填寫,無填寫完則出現提示    @IBAction func saveButtonTapped(sender: AnyObject) {
        @IBAction func saveButtonTapped(sender: AnyObject) {
           if nameTextField.text == "" || typeTextField.text == "" || addressTextField.text == "" || phoneTextField.text == "" || descriptionTextView.text == "" {
    
           let alerController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            alerController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alerController, animated: true, completion: nil)
           
            return
     }
    
      print("Name: \(nameTextField.text ?? "")")
      print("Type: \(typeTextField.text ?? "")")
      print("Location: \(addressTextField.text ?? "")")
      print("Phone: \(phoneTextField.text ?? "")")
      print("Description: \(descriptionTextView.text ?? "")")
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                restaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
                restaurant.name  = nameTextField.text
                restaurant.type = typeTextField.text
                restaurant.location = addressTextField.text
                restaurant.phone = phoneTextField.text
                restaurant.summary = descriptionTextView.text
                restaurant.isVisited = false
                
                if let restaurantImage = photoImageView.image {
                    restaurant.image = restaurantImage.pngData()
                }
                
                print("Saving data to context ...")
                appDelegate.saveContext()
            }
    
      dismiss(animated: true, completion: nil)
        
    }
    
    func saveRecordToCloud(restaurant:RestaurantMO!) -> Void {
    // 準備要儲存的記錄
    let record = CKRecord(recordType: "Restaurant")
    record.setValue(restaurant.name, forKey: "name")
    record.setValue(restaurant.type, forKey: "type")
    record.setValue(restaurant.location, forKey: "location")
    record.setValue(restaurant.phone, forKey: "phone")
    record.setValue(restaurant.summary, forKey: "description")
        
    let imageData = restaurant.image! as Data
    
    // 調整圖片大小
    let originalImage = UIImage(data: imageData)!
    let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
    let scaledImage = UIImage(data: imageData, scale: scalingFactor)!
        
    // 將圖片寫進本地端檔案作為暫時的使用
    let imageFilePath = NSTemporaryDirectory() + restaurant.name!
    let imageFileURL = URL(fileURLWithPath: imageFilePath)
    try? scaledImage.jpegData(compressionQuality: 0.8)?.write(to: imageFileURL)
    // 建立要上傳的圖片素材
    let imageAsset = CKAsset(fileURL: imageFileURL)
    record.setValue(imageAsset, forKey: "image")
        
    // 讀取公共的iCloud 資料庫
    let publicDatabase = CKContainer.default().publicCloudDatabase
        
    // 儲存資料至iCloud
    publicDatabase.save(record, completionHandler: { (record, error) -> Void in
        // 移除暫存檔
        try? FileManager.default.removeItem(at: imageFileURL)
    })
   }
}
