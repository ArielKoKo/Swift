//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 28/10/2019.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
   
    @IBOutlet var emptyRestaurantView: UIView!
    
    var restaurants: [RestaurantMO] = []
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    
    //宣告搜尋控制器變數
    var searchController: UISearchController!
    
    //宣告新變數儲存搜尋結果
    var searchResults: [RestaurantMO] = []
     
    
    // MARK: - 視圖控制器生命週期
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont ]
        }
        
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = true
        
        // 從資料儲存區中讀取資料
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
        let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
        managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
            if let fetchedObjects = fetchResultController.fetchedObjects {
                restaurants = fetchedObjects
                
                }
            } catch {
                print(error)
            }
            
        }
       
        //搜尋列
        searchController = UISearchController(searchResultsController: nil)

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        //更改搜尋列外觀
        searchController.searchBar.placeholder = "Search Restaurants..."
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60)
        searchController.searchBar.autocapitalizationType = .none
        
        tableView.tableHeaderView = searchController.searchBar
    }

    //MARK: - 視圖被顯示時呼叫
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        
    //開啟滑動隱藏導覽列功能
    navigationController?.hidesBarsOnSwipe = true

    }
    
    
    // MARK: - 表格視圖資料源

    override func numberOfSections(in tableView: UITableView) -> Int {
        if restaurants.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return restaurants.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        //判斷是從搜尋結果或者是原來的陣列取得餐廳
        let restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        
        // Configure the cell...
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        
        if let restaurantImage = restaurants[indexPath.row].image {
            cell.thumbnailImageView.image = UIImage(data: restaurantImage as Data)
        }
        
        
        // Solution to exercise 2
        cell.heartImageView.isHidden = !self.restaurants[indexPath.row].isVisited ? true : false
        
        return cell
    }
    
     // MARK: - 表格視圖委派
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
        (action, sourceView, completionHandler) in
            
            // 從資料源刪除列
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
            
                appDelegate.saveContext()
            }
            
            //以true值來呼叫完成處理器
            completionHandler(true)
            self.restaurants.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)

        }
        
        let shareAction = UIContextualAction(style: .normal,title: "Share") {
        (action, sourceView, completionHandler) in
            
            let defaultText = "Just checking in at " + self.restaurants[indexPath.row].name!
            
            let activityController : UIActivityViewController
            
            if let restaurantImage = self.restaurants[indexPath.row].image,
              let imageToShare = UIImage(data: restaurantImage as Data)
            {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
         
            
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
                        
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
                
        deleteAction.backgroundColor = UIColor(red: 231, green: 76, blue: 60)
        deleteAction.image = UIImage(named: "delete")
        shareAction.backgroundColor = UIColor(red: 254, green: 149, blue: 38)
        shareAction.image = UIImage(named: "share")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
        
    }
     
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
        let checkInAction = UIContextualAction(style: .normal, title: "check-in") {
                (action, sourceView, completionHandler) in
                          
        let cell = tableView.cellForRow(at: indexPath) as? RestaurantTableViewCell
                            
            cell?.heartImageView.isHidden = self.restaurants[indexPath.row].isVisited ? true : false
                            
            self.restaurants[indexPath.row].isVisited = (self.restaurants[indexPath.row].isVisited) ? false : true
            
        completionHandler(true)
            
    }
        
        let checkInicon = restaurants[indexPath.row].isVisited ? "arrow.uturn.left" : "checkmark"
        
        checkInAction.backgroundColor = UIColor(red: 38, green: 162, blue: 78)
        checkInAction.image = UIImage(systemName: checkInicon)

        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkInAction])
    
        return swipeConfiguration
    
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - 導覽
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
              
                destinationController.hidesBottomBarWhenPushed = true
            }
        }
         
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
        }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type { case .insert:
            if let newIndexPath = newIndexPath { tableView.insertRows(at: [newIndexPath], with: .fade)
    }
        case .delete:
            if let indexPath = indexPath { tableView.deleteRows(at: [indexPath], with: .fade)
    }
        case .update:
            if let indexPath = indexPath { tableView.reloadRows(at: [indexPath], with: .fade)
    } default:
        tableView.reloadData() }
        if let fetchedObjects = controller.fetchedObjects {
         restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
       
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
    }
    
    //MARK: - 搜尋列
    func filterContent(for searchText: String) {
        
        searchResults = restaurants.filter({ (restaurant) -> Bool in
        if let name = restaurant.name,
            let location = restaurant.location {
            
            let isMatch = name.localizedCaseInsensitiveContains(searchText) ||
            location.localizedCaseInsensitiveContains(searchText)
            
            
            return isMatch
        }
        return false
    })

  }
    
    //更新搜尋結果
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            
            present(walkthroughViewController, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    
    
    
    
    
}

