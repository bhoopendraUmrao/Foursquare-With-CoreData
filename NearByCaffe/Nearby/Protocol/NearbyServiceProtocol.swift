//  
//  NearbyServiceProtocol.swift
//  MVVM Sqlite
//
//  Created by Bhoopendra  on 30/07/19.
//  Copyright © 2019 Bhoopendra . All rights reserved.
//

import Foundation

protocol NearbyServiceProtocol {

    /// SAMPLE FUNCTION -* Please rename this function to your real function
    ///
    /// - Parameters:
    ///   - success: -- success closure response, add your Model on this closure.
    ///                 example: success(_ data: YourModelName) -> ()
    ///   - failure: -- failure closure response, add your Model on this closure.  
    ///                 example: success(_ data: APIError) -> ()
    func fetchNearByPlaces(success: @escaping(_ data: NearbyModel) -> (), failure: @escaping(_ error:String) -> ())
}
    
