//  
//  NearbyView.swift
//  MVVM Sqlite
//
//  Created by Bhoopendra  on 30/07/19.
//  Copyright © 2019 Bhoopendra . All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NearbyView: UIViewController {
    
    // OUTLETS HERE
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    // VARIABLES HERE
    var viewModel = NearbyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Searching Nearby Places"

        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.setupViewModel()
    }
    
    fileprivate func setupViewModel() {
        
        self.viewModel.showAlertClosure = {
            let alert = self.viewModel.alertMessage ?? ""
            self.showAlert(alert)
        }
        
        self.viewModel.updateLoadingStatus = {
            if self.viewModel.isLoading {
                print("LOADING...")
                self.activityView.startAnimating()
                self.activityView.isHidden = false
                self.mapView.isUserInteractionEnabled = false
            } else {
                print("DATA READY")
                self.activityView.isHidden = true
                self.activityView.stopAnimating()
                self.mapView.isUserInteractionEnabled = true
            }
        }
        
        self.viewModel.internetConnectionStatus = {
            print("Internet disconnected")
            let alert = self.viewModel.alertMessage ?? ""
            self.showAlert(alert)
            // show UI Internet is disconnected
        }
        
        self.viewModel.serverErrorStatus = {
            print("Server Error / Unknown Error")
            let alert = self.viewModel.alertMessage ?? ""
            self.showAlert(alert)
            // show UI Server is Error
        }
        
        self.viewModel.didGetData = {
            // update UI after get data
            self.title = self.viewModel.searchedLocation
            self.configurePlacesInMap()
        }
    }
}

extension NearbyView{
    fileprivate func showAlert(_ message:String){
            let alertController = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
    }
}

extension NearbyView{
    func configurePlacesInMap() {
        
        let visibleRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 28.472790, longitude: 77.063240), latitudinalMeters: 10000, longitudinalMeters: 10000)
        self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)
        
        guard  let places = viewModel.venueList else {
            return
        }
        var annotations = [MKAnnotation]()
        for place in places {
            let annotation = PlaceAnnotation(venue: place)
            annotations.append(annotation)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
}

extension NearbyView:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let visibleRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "kPersonWishListAnnotationName")
        
        if annotationView == nil {
            annotationView = PlacesAnotation(annotation: annotation, reuseIdentifier: "kPersonWishListAnnotationName")
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
}

