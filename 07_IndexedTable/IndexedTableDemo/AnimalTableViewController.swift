//
//  AnimalTableViewController.swift
//  IndexedTable
//
//  Created by Simon Ng on 3/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

var animalsDict = [String: [String]]()
var animalSectionTitles = [String]()


class AnimalTableViewController: UITableViewController {
    let animals = ["Bear", "Black Swan", "Buffalo", "Camel", "Cockatoo", "Dog", "Donkey", "Emu", "Giraffe", "Greater Rhea", "Hippopotamus", "Horse", "Koala", "Lion", "Llama", "Manatus", "Meerkat", "Panda", "Peacock", "Pig", "Platypus", "Polar Bear", "Rhinoceros", "Seagull", "Tasmania Devil", "Whale", "Whale Shark", "Wombat"]
    
    let animalIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L" , "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    // MARK: - 從animals陣列中產生一個字典
    func createAnimalDict() {
        // 建立一個迴圈for..in..檢查animals陣列
        for animal in animals {
            // 取得動物名的第一個字母並建立字典
            let firstLetterIndex = animal.index(animal.startIndex, offsetBy: 1)
            let animalKey = String(animal[..<firstLetterIndex])
            
            if var animalValues = animalsDict[animalKey] {
                animalValues.append(animal)
                animalsDict[animalKey] = animalValues
            } else {
                animalsDict[animalKey] = [animal]
            }
        }
        
        // 從字典的key取得區塊標題並做昇幂排列
        animalSectionTitles = [String](animalsDict.keys)
        animalSectionTitles.sort(by: { $0 < $1 })
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 產生動物字典
        createAnimalDict()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // 回傳區塊的總數
        return animalSectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 回傳區塊中的列數
        let animalKey = animalSectionTitles[section]
        guard let animalValues = animalsDict[animalKey] else {
            return 0
        }
        
        return animalValues.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // cell的設定...
        let animalKey = animalSectionTitles[indexPath.section]
        if let animalValues = animalsDict[animalKey] {
            cell.textLabel?.text = animalValues[indexPath.row]
        
            // 轉換動物名為小寫並且以下底線來取代所有出現的空格
            let imageFileName = animalValues[indexPath.row].lowercased().replacingOccurrences(of: " ", with: "_")
            cell.imageView?.image = UIImage(named: imageFileName)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 顯示每一個區塊的表頭
        return animalSectionTitles[section]
    }
    
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return animalIndexTitles
    }
    
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        guard let index = animalSectionTitles.firstIndex(of: title) else {
            return -1
        }
        
        return index
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = UIColor(red: 236.0/255.0, green: 240.0/255/0, blue: 241.0/255.0, alpha: 1.0)
        headerView.textLabel?.textColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        
        headerView.textLabel?.font = UIFont(name: "Avenir", size: 25.0)
    }

}
