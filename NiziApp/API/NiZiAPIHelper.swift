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
    
    static func readAllConsumption(withToken token: String, withPatient patientId: Int, betweenDate startDate: String, and endDate: String) -> DataRequest {
        let apiMethod = "consumptions?patient.id=\(patientId)&date_gte=\(startDate)&date_lte=\(endDate)"
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
    
    static func addNewConsumption(withToken token : String, withDetails consumption: NewConsumptionModel) -> DataRequest {
        let apiMethod = "consumptions"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        let parameters =
            [
                "amount": consumption.amount, "date": consumption.date, "meal_time": consumption.mealTime, "patient": ["id": consumption.patient.id], "weight_unit": ["unit": consumption.weightUnit.unit, "updated_at": consumption.weightUnit.updatedAt, "id": consumption.weightUnit.id, "created_at": consumption.weightUnit.createdAt, "short": consumption.weightUnit.short], "food_meal_component": ["foodId": consumption.foodmealComponent.foodId, "protein": consumption.foodmealComponent.protein, "id": consumption.foodmealComponent.id, "sodium": consumption.foodmealComponent.sodium, "name": consumption.foodmealComponent.name, "kcal":  consumption.foodmealComponent.kcal, "potassium": consumption.foodmealComponent.potassium, "water": consumption.foodmealComponent.water, "description": consumption.foodmealComponent.description, "fiber": consumption.foodmealComponent.fiber, "image_url": consumption.foodmealComponent.imageUrl, "portion_size": consumption.foodmealComponent.portionSize]
            ] as [String : Any]
        print(parameters)
        return AF.request(baseUrl + apiMethod, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
    }
    
    static func patchNewConsumption(withToken token : String, withDetails consumption: NewConsumptionPatch, withConsumptionId consumptionId: Int) -> DataRequest {
        let apiMethod = "consumptions/\(consumptionId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        let parameters =
            [
                "amount": consumption.amount, "date": consumption.date, "meal_time": consumption.mealTime
            ] as [String : Any]
        print(parameters)
        print(baseUrl+apiMethod)
        return AF.request(baseUrl + apiMethod, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: header)
    }
    //NEW CONSUMPTION //
    
    //NEW SEARCH FOOD//
    static func getFood(withToken token : String,withFood food: String) -> DataRequest{
        let apiMethod = "foods?name_contains=\(food)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        let parameters =
            [
                "name_eq":food
            ] as [String : Any]
        
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    
    static func getSingleFood(withToken token : String,withFood foodId: Int) -> DataRequest{
        let apiMethod = "foods/\(foodId)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    //NEW SEARCH FOOD//
    
    // NEW FAVORITE FOOD //
    static func GetMyFoods(withToken token : String, withPatient patientId: Int) -> DataRequest{
        let apiMethod = "My-Foods?patients_id.id=\(patientId)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    
    static func GetMyFoodsSearch(withToken token : String, withPatient patientId: Int, withFood food : String) -> DataRequest{
        let apiMethod = "My-Foods?patients_id.id=\(patientId)&food.name_contains=\(food)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    
    static func addMyFood(withToken token : String, withPatientId patientId: String, withFoodId foodId: Int) -> DataRequest {
        let apiMethod = "My-Foods"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        let parameters =
            [
                "food": foodId, "patients_id": patientId
            ] as [String : Any]
        print(parameters)
        return AF.request(baseUrl + apiMethod, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
    }
    
    static func deleteFavorite(withToken token : String, withConsumptionId favoriteId: Int) -> DataRequest{
        let apiMethod = "My-Foods/\(favoriteId)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        return AF.request(baseUrl + apiMethod, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    
    static func searchOneFoodFavorite(withToken token : String, withFood foodId: Int, withPatient patientId : String) -> DataRequest{
        let apiMethod = "My-Foods/?patients_id.id=\(patientId)&food.id=\(foodId)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        print(apiMethod)
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    
    
    // NEW FAVORITE FOOD //
    
    //GET CONVERSATIONS //
    static func GetConversations(withToken token : String, withPatient patientId: Int) -> DataRequest{
        let apiMethod = "feedbacks?patient.id=\(patientId)&_sort=date:DESC"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    //GET CONVERSATIONS //
    
    // CREATE CONVERSATIONS //
    static func createConversation(withDetails conversation: NewConversation, authorization token: String) -> DataRequest {
        let apiMethod = "feedbacks"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        
        return AF.request(baseUrl + apiMethod, method: .post, parameters: conversation.toNewConversation(), encoding: JSONEncoding.default, headers: header)
    }
    // CREATE CONVERSATIONS //
    
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
    
    static func addPatient(withDetails patient: NewPatient, authenticationCode: String) -> DataRequest {
        let apiMethod = "patients"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        let jsonEncoder = JSONDecoder()
        let parameters = patient.toNewPatientJSON()
        
        print(parameters);
        return AF.request(baseUrl + apiMethod, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
    }
    
    static func addUser(withDetails user: NewUser, authenticationCode: String) -> DataRequest {
        let apiMethod = "users"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        let parameters = user.toNewPatientUserJson()
        return AF.request(baseUrl + apiMethod, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
    }
    
    static func deleteUser(byId userId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "users/\(userId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .delete, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func checkIfUserExists(email: String, authenticationCode: String) -> DataRequest {
        let apiMethod = "users?email=\(email)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func getPatient(byId patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "patients/\(patientId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func deletePatient(byId patientId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "patients/\(patientId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .delete, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func updatePatientData(byId patientId: Int, withDetails patient: NewPatient, authenticationCode: String) -> DataRequest {
        let apiMethod = "patients/\(patientId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .put, parameters: patient.toUpdatedPatientJSON(), encoding: JSONEncoding.default, headers: header)
    }
    
    static func updatePatientUserData(byId userId: Int, withDetails user: NewUser, authenticationCode: String) -> DataRequest {
        let apiMethod = "users/\(userId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .put, parameters: user.toUpdatedPatientUserJson(), encoding: JSONEncoding.default, headers: header)
    }
    // PATIENTS //
    
    // NEW MEAL //
    static func getMeals(withToken token : String,withPatient patientId: Int, withText searchText : String) -> DataRequest{
        let search = "&food.name_contains=\(searchText)"
        let apiMethod = "meals?patient.id=\(patientId)&name_contains=\(searchText)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    
    static func createMeal(withToken token : String, withDetails consumption: NewMeal, withPatient patientid : Int) -> DataRequest {
        let apiMethod = "Meals"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        let parameters =
            [
                "patient": ["id": patientid], "weight_unit": [ "id": consumption.weightUnit.id], "food_meal_component": ["foodId": consumption.foodMealComponent.foodId, "protein": consumption.foodMealComponent.protein, "id": consumption.foodMealComponent.id, "sodium": consumption.foodMealComponent.sodium, "name": consumption.foodMealComponent.name, "kcal":  consumption.foodMealComponent.kcal, "potassium": consumption.foodMealComponent.potassium, "water": consumption.foodMealComponent.water, "description": consumption.foodMealComponent.description, "fiber": consumption.foodMealComponent.fiber, "image_url": consumption.foodMealComponent.imageUrl, "portion_size": consumption.foodMealComponent.portionSize], "name": consumption.foodMealComponent.name
            ] as [String : Any]
        print(parameters)
        return AF.request(baseUrl + apiMethod, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
    }
    
    static func addMealFood(withToken token : String, withFoods foodId: Int, withMeal mealId: Int, withAmount amount : Float) -> DataRequest {
        let apiMethod = "meal-foods"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        let parameters =
            [
                "amount": amount, "meal": mealId, "food": foodId
            ] as [String : Any]
        print(parameters)
        return AF.request(baseUrl + apiMethod, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
    }
    
    static func deleteMeal(withToken token : String, withMealId mealId: Int) -> DataRequest{
        let apiMethod = "Meals/\(mealId)"
        let header = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        return AF.request(baseUrl + apiMethod, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    
    static func removeMealFood(withToken token : String, withFoods mealFoodId: Int) -> DataRequest {
        let apiMethod = "meal-foods/\(mealFoodId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        print(apiMethod)
        return AF.request(baseUrl + apiMethod, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    
    static func patchMeal(withToken token : String, withDetails consumption: newFoodMealComponent, withMeal mealId : Int) -> DataRequest {
        let apiMethod = "Meals/\(mealId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(token)"])
        let parameters =
            [
                "food_meal_component": ["protein": consumption.protein, "id": consumption.id, "sodium": consumption.sodium, "name": consumption.name, "kcal":  consumption.kcal, "potassium": consumption.potassium, "water": consumption.water, "description": consumption.description, "fiber": consumption.fiber, "image_url": consumption.imageUrl], "name": consumption.name
            ] as [String : Any]
        print(parameters)
        return AF.request(baseUrl + apiMethod, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: header)
    }
    // NEW MEAL //
    
    // DIETARY MANAGEMENT //
    static func getDietaryManagement(forDiet dietId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "dietary-managements?patient.id_eq=\(dietId)&is_active=true"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get , parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    
    static func updateDieteryManagement(forDiet dietId: Int, withGuideline guideline: NewDietaryManagement, authenticationCode: String) -> DataRequest {
        let apiMethod = "dietary-managements/\(dietId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .put, parameters: guideline.toInactiveDietaryManagement(), encoding: JSONEncoding.default , headers: header)
    }
    
    static func createDietaryManagement(forPatient patientId: Int, withGuideline guideline: NewDietaryManagement, authenticationCode: String) -> DataRequest {
        let apiMethod = "dietary-managements"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .post, parameters: guideline.toNewDietaryManagement(), encoding: JSONEncoding.default , headers: header)
    }
    
    static func deleteDietaryManagement(forDiet dietId: Int, authenticationCode: String) -> DataRequest {
        let apiMethod = "dietary-maangements/\(dietId)"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .delete, parameters: nil, encoding: JSONEncoding.default , headers: header)
    }
    // DIETARY MANAGEMENT //
    
    // WEIGHT UNIT //
    static func getWeightUnits(authenticationCode: String) -> DataRequest {
        let apiMethod = "weight-units"
        let header : HTTPHeaders = HTTPHeaders(["Authorization" : "Bearer \(authenticationCode)"])
        return AF.request(baseUrl + apiMethod, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header)
    }
    // WEIGHT UNIT //
}
