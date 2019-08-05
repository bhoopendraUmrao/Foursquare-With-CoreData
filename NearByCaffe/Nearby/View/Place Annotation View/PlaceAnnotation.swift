//
//  PlaceAnnotation.swift
//  MVVM Sqlite
//
//  Created by Bhoopendra  on 30/07/19.
//  Copyright © 2019 Bhoopendra . All rights reserved.
//

import UIKit
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    var venue: VenueCoreData
    var coordinate: CLLocationCoordinate2D {
        if let latitude = venue.location?.lat , let longitude = venue.location?.lng{
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude), longitude: CLLocationDegrees(truncating: longitude))
        }
        return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        
    }
    
    init(venue: VenueCoreData) {
        self.venue = venue
        super.init()
    }
    
    var title: String? {
        return venue.name
    }
    
    var subtitle: String? {
        return venue.location?.formattedAddress?.joined(separator: ", ")
    }
}
