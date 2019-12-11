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
            NiZiAPIHelper.searchProducts(byName: SearchFoodInput.text!, authenticationCode: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik5ERkdPRFUxTnpJNFJEZ3lNakkxUmtFMU5EZ3dRMEUxTkVJM05UTTBSRGRFUTBFNE5FWkdNZyJ9.eyJpc3MiOiJodHRwczovL2FwcG5pemkuZXUuYXV0aDAuY29tLyIsInN1YiI6ImF1dGgwfDVkZGMyMThlOTg3MDRiMGVmNmM0NjY4YyIsImF1ZCI6WyJhcHBuaXppLm5sL2FwaSIsImh0dHBzOi8vYXBwbml6aS5ldS5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNTc2MDI0MzQ3LCJleHAiOjE1NzYxMTA3NDcsImF6cCI6IlhydVlCWmVFWklKbDYzSDF5OWxIcURDZzhhTWhKbXhjIiwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSIsImd0eSI6InBhc3N3b3JkIn0.C0IRzdof7QGU2q8OoxjzHeFJPMFlsW8B1tQr-aqjh1hzg15eRopc1AOiHxzY46O-ddVCZZP6P47quJ7tFc2omUlFqrlDgLkjA50U5xwhzNv1KEbhnj_tj8OO0XPRzRSBFj_nfNDTpMewyTtz7j6oHkLGaIDl7rBvlnzrPFxKjCH2NpvbDUjsLWNJMezdMtoLoInuN3H9Gzpr3sSdaN0pfdvvpWjV6eKf4CTzWQUfwmaMwKA5oRWQzgEodwGxklNl2RwiH--j_2-EvhyxRtMX94L1vMBFquXgqVpcHWzdrCfQ5P90cat9jbK1VmzoATSF-S6XPPIA3_YaDfC4HAhhEg").responseData(completionHandler: { response in
              
              guard let jsonResponse = response.data
              else { print("temp1"); return }
              
              let jsonDecoder = JSONDecoder()
              guard let foodlistJSON = try? jsonDecoder.decode( [Food].self, from: jsonResponse )
              else { print("temp2"); return }
              
              self.foodlist = foodlistJSON
              self.FoodTable?.reloadData()
          })
      }
 
    
}
