//
//  SearchFoodViewController.swift
//  NiziApp
//
//  Created by Wing lam on 11/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

class SearchFoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var foodlist : [Food] = []
    @IBOutlet weak var FoodTable: UITableView!
    @IBOutlet weak var SearchFoodInput: UITextField!
    @IBOutlet weak var SearchDayLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(KeychainWrapper.standard.string(forKey: "date")!)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodlist.count
      }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchFoodCell = tableView.dequeueReusableCell(withIdentifier: "searchFoodCell", for: indexPath) as! SearchFoodTableViewCell
        let idx: Int = indexPath.row
        searchFoodCell.textLabel?.text = foodlist[idx].name
        let url = URL(string: foodlist[idx].picture)
        searchFoodCell.imageView?.kf.setImage(with: url)
        searchFoodCell.accessoryType = .disclosureIndicator
        return searchFoodCell
      }
    
    @IBAction func SearchButton(_ sender: Any) {
        searchFood()
    }
    func searchFood() {
        NiZiAPIHelper.searchProducts(byName: SearchFoodInput.text!, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
              
              guard let jsonResponse = response.data
              else { print("temp1"); return }
              
              let jsonDecoder = JSONDecoder()
              guard let foodlistJSON = try? jsonDecoder.decode( [Food].self, from: jsonResponse )
              else { print("temp2"); return }
              
              self.foodlist = foodlistJSON
              self.FoodTable?.reloadData()
          })
      }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = self.foodlist[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"ProductDetailListViewController") as! FoodDetailViewController;()
        detailFoodVC.foodItem = food
        self.navigationController?.pushViewController(detailFoodVC, animated: true)
    }
}
