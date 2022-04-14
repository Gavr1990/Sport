//
//  ModelOfSports.swift
//  Sport
//
//  Created by Андрей Гаврилов on 11.04.2022.
//

import Foundation

struct Sport: Decodable {
    var name: String
    var place: String
    var time: String
    var isDataFromFirebase: String
    
//    init(name: String, place: String, time: String, isDataFromFirebase: String) {
//        self.name = name
//        self.place = place
//        self.time = time
//        self.isDataFromFirebase = isDataFromFirebase
//    }
    
//    init(json: [String: Any]) {
//        self.name = json["name"] as? String ?? ""
//        self.place = json["place"] as? String ?? ""
//        self.time = json["time"] as? String ?? ""
//        self.isDataFromFirebase = json["isDataFromFirebase"] as? String ?? ""
//    }
}
