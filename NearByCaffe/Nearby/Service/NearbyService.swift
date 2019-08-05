//  
//  NearbyService.swift
//  MVVM Sqlite
//
//  Created by Bhoopendra  on 30/07/19.
//  Copyright © 2019 Bhoopendra . All rights reserved.
//

import Foundation
import Alamofire

class NearbyService: NearbyServiceProtocol {
    // Call protocol function

    func fetchNearByPlaces(success: @escaping(_ data: NearbyModel) -> (), failure: @escaping(_ error:String) -> ()) {

        let url = "https://api.foursquare.com/v2/venues/explore?client_id=[YOUR_CLIENT_ID]&client_secret=[YOUR_CLIENT_SECRET]&v=20180323&limit=300&ll=28.472790,77.063240&query=coffee"
        
        APIManager.shared.postHttpRequestWithoutBody(url: url, completion: { (response) in
            do{
                let decoded = try JSONDecoder().decode(NearbyModel.self, from: response)
                success(decoded)
            }catch let error{
                failure(error.localizedDescription)
            }
        }) { (error) in
            print(error)
        }
    }

}
