//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by Ariel Ko on 2021/2/10.
//  Copyright © 2021 AppCoda. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    var sectionTitles = ["Feedback", "Follow Us"]
    var sectionContent = [[(image: "store", text: "Rate us on App Store", link: "https://www.apple.com/ios/app-store/"),
                           (image: "chat", text: "Tell us your feedback", link: "http://www.appcoda.com/contact")],
                          [(image: "twitter", text: "Twitter", link: "https://twitter.com/appcodamobile"),
                           (image: "facebook", text: "Facebook", link: "https://facebook.com/appcodamobile"),
                           (image: "instagram", text: "Instagram", link: "https://www.instagram.com/appcodadotcom")]]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //設置導覽列外觀
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76,blue: 60), NSAttributedString.Key.font: customFont ]
        }
        
        //移除額外的分隔線
        tableView.tableFooterView = UIView()


    }

    // MARK: - 表格視圖資料源

    //設定標題列數
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionTitles.count
    }
    
    //設定內容列數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionContent[section].count
    }

    //MARK: - 呈現區塊的標題
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    //MARK: - 設定文字標籤並回傳CELL
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath)
        
        //回傳cell
        let cellData = sectionContent[indexPath.section][indexPath.row]
        cell.textLabel?.text = cellData.text
        cell.imageView?.image = UIImage(named: cellData.image)
        
        return cell
        
    }
    
    //MARK: - 當cell列選取時
    
    //表格CELL的選取,載入網頁內容
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = sectionContent[indexPath.section][indexPath.row].link
        
        //檢查區塊數
        switch indexPath.section {
            
        // Leave us feedback 區塊
        case 0:
            if indexPath.row == 0 {
            if let url = URL(string: link) {
                //開啟 Safari 瀏覽器
                UIApplication.shared.open(url)
                }
                
            } else if indexPath.row == 1 {
                // 使用 WKWebView 載入網頁內容,觸發showWebView Segue轉場至網頁視圖控制器
                performSegue(withIdentifier: "showWebView", sender: self)
            }
            
        // Follow us 區塊
        //使用 SFSafariViewController 載入網頁內容
        case 1:
            if let url = URL(string: link) {
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            }
            
        default:
        break
    }
    
    tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    //MARK: - segue的準備
    
    //找出所選項目的連結，並透過 targetURL 屬性設定來將它傳遞至網頁視圖控制器
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            if let destinationController = segue.destination as? WebViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                
                destinationController.targetURL = sectionContent[indexPath.section][indexPath.row].link
            }
        }
    }
        
        
        
}
