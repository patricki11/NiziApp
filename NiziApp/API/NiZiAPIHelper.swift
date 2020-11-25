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
    
    static let baseUrl = "http://104.45.16.76:1337/"

    // LOGIN //
    static func login(withUsername username: String, andPassword password: String) -> DataRequest {
        let apiMethod = "auth/local"
        var parameters =
        [
            "identifier": username,
            "password": password
        ]
        
        return AF.request(baseUrl + apiMethod, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
    }
    
    static func login(withToken token: String) ->
        DataRequest {
        let apiMethod = "users/me"
        var header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
            
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    // LOGIN //
    
    // NEW CONSUMPTION //
    static func readAllConsumption(withToken token : String,withPatient patientId: Int, withStartDate startDate: String) -> DataRequest{
        let apiMethod = "consumptions?patient.id=\(patientId)&date=\(startDate)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    
    static func readConsumption(withToken token : String,withConsumptionId consumptionId: Int) -> DataRequest{
        let apiMethod = "consumptions/\(consumptionId)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    
    static func deleteConsumption2(withToken token : String, withConsumptionId consumptionId: Int) -> DataRequest{
        let apiMethod = "consumptions/\(consumptionId)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        return AF.request(baseUrl + apiMethod, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    
    static func addNewConsumption(withToken token : String, withDetails consumption: NewConsumption, authenticationCode: String) -> DataRequest {
         let apiMethod = "consumptions"
         let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
         let parameters = consumption.toJSON()
         print(parameters);
         return AF.request(baseUrl + apiMethod, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
     }
    //NEW CONSUMPTION //
    
    //NEW SEARCH FOOD//
    static func getFood(withToken token : String,withFood food: String) -> DataRequest{
        let apiMethod = "foods?name_eq=\(food)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        let parameters =
        [
            "name_eq":food
        ] as [String : Any]
        
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    
    //NEW SEARCH FOOD//
    
    // NEW FAVORITE FOOD //
    static func GetMyFoods(withToken token : String, withPatient patientId: Int) -> DataRequest{
        let apiMethod = "My-Foods?patients_ids.id=\(patientId)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    // NEW FAVORITE FOOD //
    
    //GET CONVERSATIONS //
    static func GetConversations(withToken token : String, withPatient patientId: Int) -> DataRequest{
        let apiMethod = "feedbacks?patient.id=\(patientId)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    //GET CONVERSATIONS //
    
    
    
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
        let apiMethod = "patients?doctor.id_eq=\(doctorId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authorizationToken)"])
        return AF.request(baseUrl + apiMethod, method: .get, headers: header)

    }
    // DOCTORS //
    
    
    // PATIENTS //
    static func getAllPatients(withDoctorCode authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/patients"
        
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil)
    }
    
    static func addPatient(withDetails patient: PatientLogin, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/patient"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        let jsonEncoder = JSONDecoder()
        let parameters = patient.toJSON()
        print(parameters);
        return AF.request(baseUrl + apiMethod, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
    }
    
    static func getPatient(byId patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/patient/\(patientId)"
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
    
    static func addProductToFavorite(forproductId productId: Int, forPatient patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/food/favorite?patientId=\(patientId)&foodId=\(productId)"
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
    
    static func addConsumption(withDetails consumption: Consumption, authenticationCode: String) -> DataRequest {
         let apiMethod = "v1/consumptions"
         let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
         let jsonEncoder = JSONDecoder()
         let parameters = consumption.toJSON()
         print(parameters);
         return AF.request(baseUrl + apiMethod, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
     }
    // CONSUMPTION //
    
    // WATER CONSUMPTION //
    /*
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
 */
    // WATER CONSUMPTION //
    
    // MEAL //
    static func addMeal(withDetails meal: Meal, forPatient patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/meal/\(patientId)"
        let parameters = meal.toJSON()
        print(parameters)
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .post , parameters: parameters, encoding: JSONEncoding.default , headers: header)
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
        let apiMethod = "v1/meal?patientId=\(patientId)&mealId=\(mealId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .delete , parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    // MEAL //
    
    // DIETARY MANAGEMENT //
    static func getDietaryManagement(forDiet dietId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "dietary-managements?patient.id_eq=\(dietId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get , parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func updateDieteryManagement(forDiet dietId: Int, withGuideline guideline: DietaryManagement, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/dietaryManagement/\(dietId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .put, parameters: guideline.toJson(), encoding: JSONEncoding.default , headers: header)
    }
    
    static func createDietaryManagement(forPatient patientId: Int, withGuideline guideline: DietaryManagement, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/dietaryManagement"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .post, parameters: guideline.toJson(), encoding: JSONEncoding.default , headers: header)
    }
    
    static func deleteDietaryManagement(forDiet dietId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "v1/dietaryManagement/\(dietId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .delete, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    // DIETARY MANAGEMENT //
}
