//
//  MapViewController.swift
//  FoodPin
//
//  Created by Ariel Ko on 2021/2/4.
//  Copyright © 2021 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!

    var restaurant: RestaurantMO!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location ?? "", completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            if let placemarks = placemarks {
               let placemark = placemarks[0]
               let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
               if let location = placemark.location {
                annotation.coordinate = location.coordinate
               self.mapView.showAnnotations([annotation], animated: true)
               self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
        
      mapView.delegate = self
      
      //在地圖上顯示指南針,比例,交通流量
      mapView.showsCompass = true
      mapView.showsScale = true
      mapView.showsTraffic = true
        
  }
    
    //MARK: - 地圖標註
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.glyphText = "😋"
        annotationView?.markerTintColor = UIColor.orange
        
        return annotationView
    }
    
    
}
