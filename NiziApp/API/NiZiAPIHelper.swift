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
    static func getAllDoctors(withDoctorCode authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/doctor"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }

    static func getDoctor(byId doctorId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/doctor/\(doctorId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }

    static func getPatients(forDoctor doctorId: Int, withAuthorization authorizationToken: String) -> DataRequest {
        let apiMethod = "v1/doctor/\(doctorId)/patients"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authorizationToken)"])
        return AF.request(baseUrl + apiMethod, method: .get, headers: header)

    }
    
    static func login(withDoctorCode authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/login/doctor"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    // DOCTORS //
    
    
    // PATIENTS //
    static func getAllPatients(withDoctorCode authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/patients"
        
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil)
    }
    
    static func addPatient(withDetails patient: Patient, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/patient"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .post, parameters: patient.toJSON(), encoding: JSONEncoding.default, headers: header)
    }
    
    static func getPatient(byId patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/patient/\(patientId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func login(withPatientCode authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/login/patient"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    // PATIENTS //
    
    
    // FOOD //
    static func getProduct(byId productId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/food/\(productId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func searchProducts(byName name: String, authenticationCode: String) -> DataRequest {
        let productSearchCount = 30;
        let apiMethod = "v1/food/partial/\(name)/\(productSearchCount)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func getFavoriteProducts(forPatient patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/food/favorite/\(patientId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func addProductToFavorite(productId productId: Int, forPatient patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/food/favorite"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .post, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func removeProductFromFavorites(productId productId: Int, forPatient patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/food/favorite"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .delete ,parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    // FOOD //
    
    
    // CONSUMPTION //
    static func deleteConsumption(withId consumptionId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/consumption/\(consumptionId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .delete, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func getConsumption(withId consumptionId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/consumption/\(consumptionId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func updateConsumption(withId consumptionId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/consumption/\(consumptionId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .put, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func getAllConsumptions(forPatient patientId: Int, between startDate: String, and endDate: String, authenticationCode: String) -> DataRequest {
        let parameter = ["patientId": patientId, "startDate": startDate, "endDate": endDate ] as [String : Any]
        let apiMethod = "v1/consumptions"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: HTTPMethod.get , parameters: parameter , headers: header)
    }
    // CONSUMPTION //
    
    // WATER CONSUMPTION //
    static func createNewWaterConsumption(forPatient patientId: Int, withAmount amount: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/waterconsumption"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .post, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func getWaterConsumption(byId waterConsumptionId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/waterconsumption/\(waterConsumptionId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func updateWaterConsumption(withId waterConsumptionId: Int, toAmount: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/waterconsumption/\(waterConsumptionId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .put , parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func deleteWaterConsumption(withId waterConsumptionId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/waterconsumption/\(waterConsumptionId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .delete , parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func getWaterConsumption(forPatient patientId: Int, onDate: Date, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/waterconsumption/daily/\(patientId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func getWaterConsumption(forPatient patientId: Int, between startDate: Date, and endDate: Date , authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/waterconsumption/period/\(patientId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get , parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    // WATER CONSUMPTION //
    
    // MEAL //
    static func addMeal(forPatient patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/meal/\(patientId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .post , parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func updateMeal(withId mealId: Int, forPatient patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/meal/\(patientId)/\(mealId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .put, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func getAllMeals(forPatient patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/meal/\(patientId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get , parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func deleteMeal(withId mealId: Int, forPatient patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/meal"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .delete , parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    // MEAL //
    
    // DIETARY MANAGEMENT //
    static func getDietaryManagement(forDiet dietId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/dietaryManagement/\(dietId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get , parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func updateDieteryManagement(forDiet dietId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/dietaryManagement/\(dietId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .put, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func createDietaryManagement(forPatient patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/dietaryManagement"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .post, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func deleteDietaryManagement(forDiet dietId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/dietaryManagement/\(dietId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .delete, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    // DIETARY MANAGEMENT //
}
