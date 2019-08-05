//  
//  NearbyViewModel.swift
//  MVVM Sqlite
//
//  Created by Bhoopendra  on 30/07/19.
//  Copyright © 2019 Bhoopendra . All rights reserved.
//

import Foundation

class NearbyViewModel {

    private let service: NearbyServiceProtocol

    private var model: NearbyModel = NearbyModel()
    
    private var coreDataModel = [VenueCoreData]()


    //MARK: -- Network checking

    /// Define networkStatus for check network connection
    var networkStatus = Reach().connectionStatus(){
        didSet{
            monitorStatus()
        }
    }

    /// Define boolean for internet status, call when network disconnected
    var isDisconnected: Bool = false {
        didSet {
            self.alertMessage = "No network connection. Please connect to the internet"
            self.internetConnectionStatus?()
        }
    }

    //MARK: -- UI Status

    /// Update the loading status, use HUD or Activity Indicator UI
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    /// Showing alert message, use UIAlertController or other Library
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    
    //MARK: -- Closure Collection
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?
    var didGetData: (() -> ())?

    init(withNearby serviceProtocol: NearbyServiceProtocol = NearbyService() ) {
        self.service = serviceProtocol

        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()

    }

    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }

    //MARK: -- Example Func
    func monitorStatus() {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            // call your service here
            
            self.service.fetchNearByPlaces(success: { (nearbyPlaces) in
                self.isLoading = false
                self.model = nearbyPlaces
                
                //Perform coredata operations
                CoreDataManager.shared.clearStorage(forEntity: Entity.VenueCoreData.rawValue)
                self.writeVenuesDataonDisk(venues: nearbyPlaces.response?.placesGroup?[0].places)
            
            }) { errorMsg in
                self.isLoading = false
                self.alertMessage = errorMsg
            }
        default:
            break
        }
    }

    func writeVenuesDataonDisk(venues:[PlaceDetail]?){
        for place in venues ?? []{
            do{
                guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else{return}
                let jsonData = try? JSONEncoder().encode(place.venue.self)
                // Parse JSON data
                
                let managedObjectContext = CoreDataManager.shared.context
                let decoder = JSONDecoder()
                decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
                _ = try decoder.decode(VenueCoreData.self, from: jsonData!)
                try managedObjectContext?.save()
            }catch{
                print("Parsing Error")
            }
        }
        self.fetchVenuesDataFromDisk()
    }
    
    func fetchVenuesDataFromDisk(withSort:[NSSortDescriptor] = []){
        if let venues = CoreDataManager.shared.fetchDataForEntity(forEntity: .VenueCoreData, sortDescriptor: withSort) as? [VenueCoreData]{
            self.coreDataModel = venues
            self.didGetData?()
        }
    }
}

extension NearbyViewModel {
    var venueList:[VenueCoreData]?{
        get{
            
            return coreDataModel
        }
    }
    
    var searchedLocation:String?{
        get{
            guard let header = model.response?.headerLocation else {return nil}
            return header
        }
    }
}
