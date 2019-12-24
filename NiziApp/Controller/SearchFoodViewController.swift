//
//  SearchFoodViewController.swift
//  NiziApp
//
//  Created by Wing lam on 11/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import UIKit

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
        searchFoodCell.productTitle?.text = foodlist[idx].name
          return searchFoodCell
      }
    
    @IBAction func SearchButton(_ sender: Any) {
        searchFood()
    }
    func searchFood() {
            NiZiAPIHelper.searchProducts(byName: SearchFoodInput.text!, authenticationCode: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik5ERkdPRFUxTnpJNFJEZ3lNakkxUmtFMU5EZ3dRMEUxTkVJM05UTTBSRGRFUTBFNE5FWkdNZyJ9.eyJpc3MiOiJodHRwczovL2FwcG5pemkuZXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDVkZGMyMThlOTg3MDRiMGVmNmM0NjY4YyIsImF1ZCI6WyJhcHBuaXppLm5sL2FwaSIsImh0dHBzOi8vYXBwbml6aS5ldS5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNTc3MDk1ODUwLCJleHAiOjE1NzcxODIyNTAsImF6cCI6IlhydVlCWmVFWklKbDYzSDF5OWxIcURDZzhhTWhKbXhjIiwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSIsImd0eSI6InBhc3N3b3JkIn0.KX-oZ8QZT7SHBC2uFvTdt7XqqbmOU_g-EKcnMDYCTle5SxKIEoVo1YqhhK3gy2vU4RUW9RjEXaj3fZECEzA1xBji2fHhMJv_qZDLuCSSSFdi_DeoL6u7iBJN8DCSG3_ov_4rpam65VcJZp0TsQ3KA8UMenkWZ2mP-61Lnr3wT1dPpIv8RdyaTRr0jfzD6zRfM8PIK0es6AcmrcBV5QX940YR8PaPlSsccvoY5LyJMoNr2-PjyLyJkd5z06w9a9ZQb0So0okWhk7MaTi-HcT-ju5tQg3Z8-pyPatMli4B2KB-oGwGH6j1OuEJ_plUGfUnPgMw9uuu2VZNiK7qDyTLgA").responseData(completionHandler: { response in
              
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
        print(indexPath)
    }
}
