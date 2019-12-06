//
//  NiZiAPIHelper.swift
//  NiziApp
//
//  Created by Patrick Dammers on 03/12/2019.
//  Copyright © 2019 Samir Yeasin. All rights reserved.
//

import Foundation
import Alamofire

class NiZiAPIHelper {
    
    static let baseUrl = "https://appnizi-api.azurewebsites.net/api/"

    // DOCTORS //
    static func getAllDoctors() -> DataRequest {
        let apiMethod = "v1/doctor"
        return AF.request(baseUrl + apiMethod, method: .get)
    }

    static func getDoctor(byId doctorId: Int) -> DataRequest {
        let apiMethod = "v1/doctor/\(doctorId)"
        return AF.request(baseUrl + apiMethod, method: .post)
    }

    static func getPatients(forDoctor doctorId: Int) -> DataRequest {
        let apiMethod = "v1/doctor/\(doctorId)/patients"
        return AF.request(baseUrl + apiMethod, method: .get)

    }
    
    static func login(withDoctorCode authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/login/doctor"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        print(header)
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    // DOCTORS //
    
    
    // PATIENTS //
    static func getAllPatients() -> DataRequest {
        let apiMethod = "v1/patients"
        return AF.request(baseUrl + apiMethod, method: .post, parameters: nil)
    }
    
    static func getPatient(byId patientId: Int) -> DataRequest {
        let apiMethod = "v1/patient/\(patientId)"
        return AF.request(baseUrl + apiMethod, method: .get)
    }
    
    static func login(withPatientCode authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/login/patient"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    // PATIENTS //
    
    
    // FOOD //
    static func getProduct(byId productId: Int) -> DataRequest {
        let apiMethod = "v1/food/\(productId)"
        return AF.request(baseUrl + apiMethod, method: .get)
    }
    
    static func searchProducts(byName name: String) -> DataRequest {
        
        let productSearchCount = 30;
        
        let apiMethod = "v1/food/partial/\(name)/\(productSearchCount)"
        return AF.request(baseUrl + apiMethod, method: .get)
    }
    
    static func getFavoriteProducts(forPatient patientId: Int) -> DataRequest {
        let apiMethod = "v1/food/favorite/\(patientId)"
        return AF.request(baseUrl + apiMethod, method: .get)
    }
    
    static func addProductToFavorite(productId productId: Int, forPatient patientId: Int) -> DataRequest {
        let apiMethod = "v1/food/favorite"
        return AF.request(baseUrl + apiMethod, method: .post)
    }
    
    static func removeProductFromFavorites(productId productId: Int, forPatient patientId: Int) -> DataRequest {
        let apiMethod = "v1/food/favorite"
        return AF.request(baseUrl + apiMethod, method: .delete)
    }
    // FOOD //
    
    
    // CONSUMPTION //
    static func deleteConsumption(withId consumptionId: Int) -> DataRequest {
        let apiMethod = "v1/consumption/\(consumptionId)"
        return AF.request(baseUrl + apiMethod, method: .delete)
    }
    
    static func getConsumption(withId consumptionId: Int) -> DataRequest {
        let apiMethod = "v1/consumption/\(consumptionId)"
        return AF.request(baseUrl + apiMethod, method: .get)
    }
    
    static func updateConsumption(withId consumptionId: Int) -> DataRequest {
        let apiMethod = "v1/consumption/\(consumptionId)"
        return AF.request(baseUrl + apiMethod, method: .put)
    }
    
    static func getAllConsumptions(forPatient patientId: Int, between startDate: Date, and endDate: Date) -> DataRequest {
        let apiMethod = "v1/consumptions"
        return AF.request(baseUrl + apiMethod, method: HTTPMethod.get)
    }
    // CONSUMPTION //
    
    // WATER CONSUMPTION //
    static func createNewWaterConsumption(forPatient patientId: Int, withAmount amount: Int) -> DataRequest {
        let apiMethod = "v1/waterconsumption"
        return AF.request(baseUrl + apiMethod, method: .post)
    }
    
    static func getWaterConsumption(byId waterConsumptionId: Int) -> DataRequest {
        let apiMethod = "v1/waterconsumption/\(waterConsumptionId)"
        return AF.request(baseUrl + apiMethod, method: .get)
    }
    
    static func updateWaterConsumption(withId waterConsumptionId: Int, toAmount: Int) -> DataRequest {
        let apiMethod = "v1/waterconsumption/\(waterConsumptionId)"
        return AF.request(baseUrl + apiMethod, method: .put)
    }
    
    static func deleteWaterConsumption(withId waterConsumptionId: Int) -> DataRequest {
        let apiMethod = "v1/waterconsumption/\(waterConsumptionId)"
        return AF.request(baseUrl + apiMethod, method: .delete)
    }
    
    static func getWaterConsumption(forPatient patientId: Int, onDate: Date) -> DataRequest {
        let apiMethod = "v1/waterconsumption/daily/\(patientId)"
        return AF.request(baseUrl + apiMethod, method: .get)
    }
    
    static func getWaterConsumption(forPatient patientId: Int, between startDate: Date, and endDate: Date) -> DataRequest {
        let apiMethod = "v1/waterconsumption/period/\(patientId)"
        return AF.request(baseUrl + apiMethod, method: .get)
    }
    // WATER CONSUMPTION //
    
    // MEAL //
    static func addMeal(forPatient patientId: Int) -> DataRequest {
        let apiMethod = "v1/meal/\(patientId)"
        return AF.request(baseUrl + apiMethod, method: .post)
    }
    
    static func updateMeal(withId mealId: Int, forPatient patientId: Int) -> DataRequest {
        let apiMethod = "v1/meal/\(patientId)/\(mealId)"
        return AF.request(baseUrl + apiMethod, method: .put)
    }
    
    static func getAllMeals(forPatient patientId: Int) -> DataRequest {
        let apiMethod = "v1/meal/\(patientId)"
        return AF.request(baseUrl + apiMethod, method: .get)
    }
    
    static func deleteMeal(withId mealId: Int, forPatient patientId: Int) -> DataRequest {
        let apiMethod = "v1/meal"
        return AF.request(baseUrl + apiMethod, method: .delete)
    }
    // MEAL //
    
    // DIETARY MANAGEMENT //
    static func getDietaryManagement(forDiet dietId: Int) -> DataRequest {
        let apiMethod = "v1/dietaryManagement/\(dietId)"
        return AF.request(baseUrl + apiMethod, method: .get)
    }
    
    static func updateDieteryManagement(forDiet dietId: Int) -> DataRequest {
        let apiMethod = "v1/dietaryManagement/\(dietId)"
        return AF.request(baseUrl + apiMethod, method: .put)
    }
    
    static func createDietaryManagement(forPatient patientId: Int) -> DataRequest {
        let apiMethod = "v1/dietaryManagement"
        return AF.request(baseUrl + apiMethod, method: .post)
    }
    
    static func deleteDietaryManagement(forDiet dietId: Int) -> DataRequest {
        let apiMethod = "v1/dietaryManagement/\(dietId)"
        return AF.request(baseUrl + apiMethod, method: .delete)
    }
    // DIETARY MANAGEMENT //
}
