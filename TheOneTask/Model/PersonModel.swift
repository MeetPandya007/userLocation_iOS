//
//  PersonModel.swift
//  TheOneTask
//
//  Created by Meet on 12/07/22.
//

import Foundation
  
class Person
{
    var name: String = ""
    var vicinity: String = ""
    var lat: Double?
    var lng: Double?
    
    init(name:String, vicinity:String, lat:Double, lng:Double)
    {
        self.name = name
        self.vicinity = vicinity
        self.lat = lat
        self.lng = lng
    }
}
