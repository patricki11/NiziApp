//
//  MealSearchViewController.swift
//  NiziApp
//
//  Created by Wing lam on 02/01/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftKeychainWrapper

class MealSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var MealTable: UITableView!
    var meallist : [Meal] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meallist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchFoodCell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! SearchFoodTableViewCell
        let idx: Int = indexPath.row
        searchFoodCell.textLabel?.text = meallist[idx].name
        let url = URL(string: meallist[idx].picture)
        searchFoodCell.imageView?.kf.setImage(with: url)
        searchFoodCell.accessoryType = .disclosureIndicator
        return searchFoodCell
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func GetMeals() {
          NiZiAPIHelper.getFavoriteProducts(forPatient: 57, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
              
              guard let jsonResponse = response.data
              else { print("temp1"); return }
              
              let jsonDecoder = JSONDecoder()
              guard let foodlistJSON = try? jsonDecoder.decode( [Meal].self, from: jsonResponse )
              else { print("temp2"); return }
              
              self.meallist = foodlistJSON
              self.MealTable?.reloadData()
          })
      }
}
