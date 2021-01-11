//
//  BarCodeScanViewController.swift
//  NiziApp
//
//  Created by Samir Yeasin on 11/01/2021.
//  Copyright © 2021 Samir Yeasin. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftKeychainWrapper

class BarCodeScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var scannerBtn: UIButton!
    var foodlist                      : [NewFood] = []
    var weightUnit : Int = 0
    let patientIntID : Int = Int(KeychainWrapper.standard.string(forKey: "patientId")!)!
    @IBAction func Scan(_ sender: Any) {
    }
    
    
    var captureSession: AVCaptureSession!
       var previewLayer: AVCaptureVideoPreviewLayer!

       override func viewDidLoad() {
           super.viewDidLoad()

           view.backgroundColor = UIColor.black
           captureSession = AVCaptureSession()

           guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
           let videoInput: AVCaptureDeviceInput

           do {
               videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
           } catch {
               return
           }

           if (captureSession.canAddInput(videoInput)) {
               captureSession.addInput(videoInput)
           } else {
               failed()
               return
           }

           let metadataOutput = AVCaptureMetadataOutput()

           if (captureSession.canAddOutput(metadataOutput)) {
               captureSession.addOutput(metadataOutput)

               metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
               metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
           } else {
               failed()
               return
           }

           previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
           previewLayer.frame = view.layer.bounds
           previewLayer.videoGravity = .resizeAspectFill
           view.layer.addSublayer(previewLayer)

           captureSession.startRunning()
       }

       func failed() {
           let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
           ac.addAction(UIAlertAction(title: "OK", style: .default))
           present(ac, animated: true)
           captureSession = nil
       }

       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)

           if (captureSession?.isRunning == false) {
               captureSession.startRunning()
           }
       }

       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)

           if (captureSession?.isRunning == true) {
               captureSession.stopRunning()
           }
       }

       func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
           captureSession.stopRunning()

           if let metadataObject = metadataObjects.first {
               guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
               guard let stringValue = readableObject.stringValue else { return }
               AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
               found(code: stringValue)
           }

           dismiss(animated: true)
       }

       func found(code: String) {
        NiZiAPIHelper.getBarCodeFood(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withFood: code).responseData(completionHandler: { response in
            
            guard let jsonResponse = response.data
            else { print("temp1"); return }
            
            let jsonDecoder = JSONDecoder()
            guard let foodlistJSON = try? jsonDecoder.decode( [NewFood].self, from: jsonResponse )
            else { print("temp2"); return }
            
            self.foodlist = foodlistJSON
            
            let alert = UIAlertController(title: "Success", message: "Voedel is toegevoegd aan maaltijd", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                self.addConsumption()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let detailFoodVC = storyboard.instantiateViewController(withIdentifier:"ProductListViewController") as! SearchFoodViewController;()
                self.navigationController?.pushViewController(detailFoodVC, animated: false)
            }))
            self.present(alert, animated: true)
        })
       }

       override var prefersStatusBarHidden: Bool {
           return true
       }

       override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
           return .portrait
       }
    
    func addConsumption() {
        let date = KeychainWrapper.standard.string(forKey: "date")!
        
        let patient = self.createNewPatient(id: patientIntID)
        
        if(self.foodlist[0].weightId == nil){
            self.weightUnit = 8
        }
        else{
            self.weightUnit = (self.foodlist[0].weightId)!
        }
        
        let weight = self.createNewWeight(id: self.weightUnit, unit: "", short: "", createdAt: "", updatedAt: "")
        
        let consumption = self.createNewConsumptionObject(amount: 1, date: date, mealTime: KeychainWrapper.standard.string(forKey: "mealTime")!, patient: patient, weightUnit: weight, foodMealComponent: (self.foodlist[0].foodMealComponent)!)
        
        NiZiAPIHelper.addNewConsumption(withToken: KeychainWrapper.standard.string(forKey: "authToken")!, withDetails: consumption).responseData(completionHandler: { response in
        })
    }
    
    func createNewPatient(id: Int) -> PatientConsumption {
        let consumptionPatient : PatientConsumption = PatientConsumption(id: id)
        return consumptionPatient
    }
        
    func createNewConsumptionObject(amount: Float, date: String, mealTime: String, patient: PatientConsumption, weightUnit: newWeightUnit, foodMealComponent: newFoodMealComponent) -> NewConsumptionModel {
        
        let consumption : NewConsumptionModel = NewConsumptionModel(amount: amount, date: date, mealTime: mealTime, weightUnit: weightUnit, foodmealComponent: foodMealComponent, patient: patient)
        return consumption
    }
    
    func createNewWeight(id: Int, unit : String, short : String, createdAt: String, updatedAt : String) -> newWeightUnit {
        let consumptionWeight : newWeightUnit = newWeightUnit(id: id, unit: unit, short: short, createdAt: createdAt, updatedAt: updatedAt)
        return consumptionWeight
    }
}
