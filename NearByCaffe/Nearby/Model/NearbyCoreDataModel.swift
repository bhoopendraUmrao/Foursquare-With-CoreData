//
//  NearbyCoreDataModel.swift
//  MVVM Sqlite
//
//  Created by Bhoopendra  on 30/07/19.
//  Copyright © 2019 Bhoopendra . All rights reserved.
//

import Foundation
import CoreData

class VenueCoreData:NSManagedObject,Codable{
    
    enum CodingKeys:String,CodingKey{
        case id  = "id"
        case name = "name"
        case location = "location"
        case isMarkedFavorite = "isMarkedFavorite"
    }
    
    @NSManaged var id:String?
    @NSManaged var name:String?
    @NSManaged var isMarkedFavorite:NSNumber?
    @NSManaged var location:LocationCoreData?
    //MARk:- Decodable
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,let entity = NSEntityDescription.entity(forEntityName: Entity.VenueCoreData.rawValue, in: managedObjectContext) else {
            fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        
        do{
            let isMakedFavorite = try container.decodeIfPresent(Bool.self, forKey: .name)
            self.isMarkedFavorite = NSNumber(booleanLiteral: isMakedFavorite ?? false)
        }catch{
            self.isMarkedFavorite = NSNumber(booleanLiteral:  false)
        }
        
        self.location = try container.decodeIfPresent(LocationCoreData.self, forKey: .location)
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(location, forKey: .location)
    }
}



class LocationCoreData:NSManagedObject,Codable{
    
    enum CodingKeys:String,CodingKey{
        case address = "address"
        case crossStreet = "crossStreet"
        case lat = "lat"
        case lng = "lng"
        case distance = "distance"
        case city = "city"
        case state = "state"
        case country = "country"
        case formattedAddress = "formattedAddress"
    }

    @NSManaged var address:String?
    @NSManaged var crossStreet:String?
    @NSManaged var lat:NSNumber?
    @NSManaged var lng:NSNumber?
    @NSManaged var distance:NSNumber?
    @NSManaged var city:String?
    @NSManaged var state:String?
    @NSManaged var country:String?
    @NSManaged var formattedAddress:[String]?
    
    //MARk:- Decodable
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,let entity = NSEntityDescription.entity(forEntityName: Entity.LocationCoreData.rawValue, in: managedObjectContext) else {
            fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.crossStreet = try container.decodeIfPresent(String.self, forKey: .crossStreet)
        do{
            let latitude = try container.decodeIfPresent(Double.self, forKey: .lat)
            self.lat = NSNumber(value: latitude ?? 0.0)
        }catch{
            self.lat = NSNumber(value: 0.0)
        }
        do{
            let longitude = try container.decodeIfPresent(Double.self, forKey: .lng)
            self.lng = NSNumber(value: longitude ?? 0.0)
        }catch{
            self.lng = NSNumber(value:  0.0)
        }
        
        do{
            let distance = try container.decodeIfPresent(Double.self, forKey: .distance)
            self.distance = NSNumber(value: distance ?? 0.0)
        }catch{
            self.distance = NSNumber(value:  0.0)
        }
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.formattedAddress = try container.decodeIfPresent([String].self, forKey: .formattedAddress)
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(crossStreet, forKey: .crossStreet)
        
        let latitude = Double(truncating: lat ?? 0.0)
        try container.encode(latitude, forKey: .lat)
        
        let longitude = Double(truncating: lng ?? 0.0)
        try container.encode(longitude, forKey: .lng)
        
        let distancenew = Double(truncating: distance ?? 0.0)
        try container.encode(distancenew, forKey: .distance)
        
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(country, forKey: .country)
        try container.encode(formattedAddress, forKey: .formattedAddress)
    }
}
