//  
//  NearbyModel.swift
//  MVVM Sqlite
//
//  Created by Bhoopendra  on 30/07/19.
//  Copyright © 2019 Bhoopendra . All rights reserved.
//

import Foundation




struct NearbyModel: Codable {
    var response:Response?
}

struct Response:Codable{
    var headerLocation:String?
    var headerLocationGranularity:String?
    var totalResults:Int?
    var placesGroup:[PlacesGroup]?
    private enum CodingKeys: String, CodingKey {
        case headerLocation  = "headerLocation"
        case headerLocationGranularity  = "headerLocationGranularity"
        case totalResults = "totalResults"
        case placesGroup = "groups"
    }
}

struct PlacesGroup:Codable {
    var type:String?
    var places:[PlaceDetail]?
    private enum CodingKeys: String, CodingKey {
        case type  = "type"
        case places = "items"
    }
}

struct PlaceDetail:Codable {
    var venue:Venue?
    private enum CodingKeys: String, CodingKey {
        case venue  = "venue"
    }
}

struct Venue:Codable {
    var venueId:String?
    var venueName:String?
    var location:Location?
    
    private enum CodingKeys: String, CodingKey {
        case venueId  = "id"
        case venueName = "name"
        case location = "location"
    }
}

struct Location:Codable {
    var address:String?
    var crossStreet:String?
    var lat:Double?
    var lng:Double?
    var distance:Double?
    var city:String?
    var state:String?
    var country:String?
    var formattedAddress:[String]?
}
