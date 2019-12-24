//
//  SearchFoodViewController.swift
//  NiziApp
//
//  Created by Wing lam on 11/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit
import Kingfisher

class SearchFoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var foodlist : [Food] = []
    @IBOutlet weak var FoodTable: UITableView!
    @IBOutlet weak var SearchFoodInput: UITextField!
    @IBOutlet weak var SearchDayLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            NiZiAPIHelper.searchProducts(byName: SearchFoodInput.text!, authenticationCode: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik5ERkdPRFUxTnpJNFJEZ3lNakkxUmtFMU5EZ3dRMEUxTkVJM05UTTBSRGRFUTBFNE5FWkdNZyJ9.eyJpc3MiOiJodHRwczovL2FwcG5pemkuZXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDVkZGMyMThlOTg3MDRiMGVmNmM0NjY4YyIsImF1ZCI6WyJhcHBuaXppLm5sL2FwaSIsImh0dHBzOi8vYXBwbml6aS5ldS5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNTc3MTg0OTk3LCJleHAiOjE1NzcyNzEzOTcsImF6cCI6IlhydVlCWmVFWklKbDYzSDF5OWxIcURDZzhhTWhKbXhjIiwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSIsImd0eSI6InBhc3N3b3JkIn0.To3Bbm7d4JUif3I-u1RZiav2-Dlw6zFlhFCooc4ClsRRyLkuVKr7PqkeiBGCP9ndRt2_0jmAkQr1sDjen-XPD7D9c0gamrmnsJLpydl9jM37zKBb-nplSgzDhzvl1msBax-ROdocmLtFZifV4PuaGK52VpjJ3YI7LZWhJraWjbDuQLB7VYT9n72gKOLZrrAdyLd-CgeRTO3Le1JR023k55DPClOecW_Fvp-ijD4d8F05EBTblb6H_aMXeMucmVtXSsK7e4VgWJwTUcjJnXxwtJ3Euq_JFVU5JjHYkppclpjRPB6K3PlIbdFy-w887AXOIJ-dnP8xvBRG9xrukFdyGQ").responseData(completionHandler: { response in
              
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
