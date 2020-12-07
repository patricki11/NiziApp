//
//  DiaryDetailViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 24/03/2020.
//  Copyright © 2020 Samir Yeasin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Kingfisher

/*

class DiaryDetailViewController: UIViewController {
    
    @IBOutlet weak var DetailTitle: UILabel!
    @IBOutlet weak var Portion: UILabel!
    @IBOutlet weak var ConsumtionValues: UILabel!
    @IBOutlet weak var Kcal: UILabel!
    @IBOutlet weak var Protein: UILabel!
    @IBOutlet weak var Fiber: UILabel!
    @IBOutlet weak var Calcium: UILabel!
    @IBOutlet weak var Sodium: UILabel!
    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var portionSizeLabel: UILabel!
    @IBOutlet weak var WaterLabel: UILabel!
    @IBOutlet weak var mealtimeSegment: UISegmentedControl!
    
    var foodItem: ConsumptionView?
    
    let patientIntID : Int? = Int(KeychainWrapper.standard.string(forKey: "patientId")!)
    
    @IBAction func RemoveConsumption(_ sender: Any) {
        Deleteconsumption(Id:foodItem!.consumptionId)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupData()
        // Do any additional setup after loading the view.
    }
    
    func SetupData()
    {
        DetailTitle.text = foodItem?.foodName
        
        let calorieString : String = String(format:"%.1f",foodItem!.kcal!)
        Kcal.text = calorieString
        
        let proteinString : String = String(format:"%.1f",foodItem!.protein!)
        Protein.text = proteinString
        
        let fiberString : String = String(format:"%.1f",foodItem!.fiber!)
        Fiber.text = fiberString
        
        let calciumString : String = String(format:"%.1f",foodItem!.calium!)
        Calcium.text = calciumString
        
        let sodiumString : String = String(format:"%.1f",foodItem!.sodium!)
        Sodium.text = sodiumString
        
        portionSizeLabel.text = "Gram"
        
        WaterLabel.text = "100"
        
    }
    
    func Deleteconsumption(Id id: Int){
        NiZiAPIHelper.deleteConsumption(withId: id, authenticationCode: KeychainWrapper.standard.string(forKey: "authToken")!).responseData(completionHandler: { response in
            let alertController = UIAlertController(
                title: NSLocalizedString("Success", comment: "Title"),
                message: NSLocalizedString("Consumptie is verwijdert", comment: "Message"),
                preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            guard response.data != nil
                else { print("temp1"); return }
        })
    }
}
 */
