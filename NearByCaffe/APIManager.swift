//
//  APIManager.swift
//  NewMontCalm
//
//  Created by Bhoopendra Umrao on 14/06/19.
//  Copyright © 2019 Jeevan chandra. All rights reserved.
//

import Foundation
import Alamofire


class APIManager{
    static let shared = APIManager()
    private var BaseURL = "http://webrc.lphibe.ack.neowebservices.co.uk/mobileapi"
    
    private init(){}
}

extension APIManager{
    
    fileprivate func createReuqest(urlString:String,params:Data?)-> URLRequest{
        var request:URLRequest = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringCacheData
        if let body = params{
            request.httpBody = body
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 200
        return request
    }
    
    //MARK: Post Method with Parameters
     func postHttpRequestWithBody(url: String, bodyParameter: Data?,isLoaderVisible:Bool,completion: @escaping (Data) -> Void, error: @escaping(String) -> Void){
        let request = createReuqest(urlString: "\(url)/31319", params: bodyParameter)
        
        print(String(bytes: bodyParameter!, encoding: .utf8)!)
        Alamofire.request(request).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let receivedData = response.data{
                    completion(receivedData)
                }else{
                    error("Something Went Wrong")
                }
                break
            case .failure(let error1):
                error("")
            }
        }
    }
    
     func postHttpRequestWithoutBody(url: String, completion: @escaping (Data) -> Void, error: @escaping(String) -> Void){
        var request:URLRequest = URLRequest(url: URL(string: "\(url)/31319")!)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringCacheData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(request).responseJSON { (response) in
            switch response.result {
            case .success:
                if let receivedData = response.data{
                    completion(receivedData)
                }else{
                    error(response.error?.localizedDescription ?? "")
                }
                break
            case .failure(let error1):
                error(error1.localizedDescription)
            }
        }
    }
    
}

