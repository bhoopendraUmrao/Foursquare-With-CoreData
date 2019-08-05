//
//  PlaceAnnotationView.swift
//  MVVM Sqlite
//
//  Created by Bhoopendra  on 30/07/19.
//  Copyright © 2019 Bhoopendra . All rights reserved.
//

import UIKit
import MapKit


class PlaceAnnotationView: UIView {
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var markAsFavorite: UIButton!{
        didSet{
            markAsFavorite.addTarget(self, action: #selector(self.markFavoriteClicked(_:)), for: .touchUpInside)
        }
    }
    var markFavoriteClosure: (() -> ())?
    var venue: VenueCoreData!
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear//UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureWithVenue(venue: VenueCoreData) { // 5
        self.venue = venue
        placeName.text = venue.name
        address.text = venue.location?.formattedAddress?.joined(separator: ", ")
    }
    
    @IBAction func markFavoriteClicked(_ sender:UIButton){
        markFavoriteClosure?()
    }
    
    // MARK: - Hit test. We need to override this to detect hits in our custom callout.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check if it hit our annotation detail view components.
        
        // details button
        if let result = markAsFavorite.hitTest(convert(point, to: markAsFavorite), with: event) {
            return result
        }
        
        // fallback to our background content view
        return self
    }
}

class PlacesAnotation:MKMarkerAnnotationView{
    weak var customCalloutView: PlaceAnnotationView?
    var kPersonMapPinImage:UIImage = #imageLiteral(resourceName: "nonFavoritePlacedPin")
    var kPersonMapPinImageFavorite:UIImage = #imageLiteral(resourceName: "favoritePlacedPin")

    var kPersonMapAnimationTime = 0.5
    
    
    
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    // MARK: - life cycle
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false // 1
        self.clusteringIdentifier = "unicycle"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // 1
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        glyphImage = kPersonMapPinImage
    }
    
    func loadPersonDetailMapView() -> PlaceAnnotationView? {
        
        if let views = Bundle.main.loadNibNamed("PlaceAnnotationView", owner: self, options: nil) as? [PlaceAnnotationView], views.count > 0 {
            let placeDetailMapView = views.first!
            if let placeAnnotation = annotation as? PlaceAnnotation {
                let venue = placeAnnotation.venue
                placeDetailMapView.configureWithVenue(venue: venue)
                placeDetailMapView.frame = CGRect(origin: placeDetailMapView.frame.origin, size: CGSize(width: 300, height: 175))
            }
            return placeDetailMapView
        }
        return nil
    }
    
    // MARK: - callout showing and hiding
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected { // 2
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
            
            if let newCustomCalloutView = loadPersonDetailMapView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= (newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0))
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height + 50
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView as PlaceAnnotationView
                
                self.customCalloutView?.markFavoriteClosure = {
                    self.glyphImage = self.glyphImage == self.kPersonMapPinImageFavorite ? self.kPersonMapPinImage : self.kPersonMapPinImageFavorite
                }
                
                // animate presentation
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 1.0
                    })
                }
            }
        } else { // 3
            if customCalloutView != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
            }
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if super passed hit test, return the result
        if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
        else { // test in our custom callout.
            if customCalloutView != nil {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            } else { return nil }
        }
    }
}
