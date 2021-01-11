//
//  protocol.swift
//  NiziApp
//
//  Created by Samir Yeasin on 06/01/2021.
//  Copyright © 2021 Samir Yeasin. All rights reserved.
//

import Foundation

protocol CartSelection {
    func addProductToCart(product : NewFood, atindex : Int)
}

protocol PresentDialog {
func addDiary(succeeded : Bool)
}

protocol NavigateToFood {
func goToSearch(mealTime : String)
}
