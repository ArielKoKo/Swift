//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Ariel Ko on 2021/2/11.
//  Copyright © 2021 AppCoda. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    
    var restaurants: [CKRecord] = []
    
    var spinner = UIActivityIndicatorView()
    
    //建立一個快取物件
    private var imageCache = NSCache<CKRecord.ID, NSURL>()
    
    
    //MARK: - 使用操作型 API 取得資料
    @objc func fetchRecordsFromCloud() {
        
        // 在更新之前移除目前的資料記錄
        restaurants.removeAll()
        tableView.reloadData()
        
        //使用 Convenience API 取得資料
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // 以query 建立查詢操作
        let queryOperation = CKQueryOperation(query: query)
            queryOperation.desiredKeys = ["name"]
            queryOperation.queuePriority = .veryHigh
            queryOperation.resultsLimit = 50
            queryOperation.recordFetchedBlock = { (record) -> Void in
                self.restaurants.append(record)
        }
        
        queryOperation.queryCompletionBlock = { [unowned self] (cursor, error) -> Void in
            if let error = error {
                print("Failed to get data from iCloud - \(error.localizedDescription)"
                )
            return
        }
        print("Successfully retrieve the data from iCloud")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
        
        //隱藏更新控制元件
        if let refreshControl = self.refreshControl { if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
            }
        }
        
        // 執行查詢
        publicDatabase.add(queryOperation)
        

    }
    
    
    // MARK: - 視圖控制器生命週期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //設定導覽列外觀
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont ]
        }
        

        
        //旋轉指示器初始化顯示
        spinner.style = .medium
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        // 定義旋轉指示器的佈局約束條件
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0), spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        // 啟用旋轉指示器
        spinner.startAnimating()
        
        //表格視圖重新載入之前呼叫停止動畫,並隱藏動態指示器
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.tableView.reloadData()
        }
        
        // 下拉更新控制
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControl.Event.valueChanged)
        
        fetchRecordsFromCloud()
        
        
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath)
        
        //設置 cell...
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.object(forKey: "name") as? String
        
        // 設定預設圖片
        cell.imageView?.image = UIImage(named: "photo")
        
        // 檢查圖片是否已經在快取中
        if let imageFileURL = imageCache.object(forKey: restaurant.recordID) {
            // 從快取中取得圖片
            print("Get image from cache")
            if let imageData = try? Data.init(contentsOf: imageFileURL as URL) {
                cell.imageView?.image = UIImage(data: imageData)
            }
        
    } else {
        // 在背景從雲端取得圖片
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
        fetchRecordsImageOperation.desiredKeys = ["image"]
        fetchRecordsImageOperation.queuePriority = .veryHigh
        
        fetchRecordsImageOperation.perRecordCompletionBlock = { [unowned self] (record, recordID, error) -> Void in
            if let error = error {
                print("Failed to get restaurant image: \(error.localizedDescription)")
                return
            }
            
            if let restaurantRecord = record,
                let image = restaurantRecord.object(forKey: "image"),
                let imageAsset = image as? CKAsset {
        
                if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!)
            {
            
            // 將預設圖片以餐廳圖片來取代
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: imageData)
                cell.setNeedsLayout()
            }
                
            // 加入 URL 至快取
            self.imageCache.setObject(imageAsset.fileURL! as NSURL, forKey : restaurant.recordID)
                }
            }
        }
            publicDatabase.add(fetchRecordsImageOperation)
        }
        
    return cell
}
        
}
