//
//  MapViewModel.swift
//  UI-96
//
//  Created by にゃんにゃん丸 on 2021/01/05.
//

import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: NSObject,ObservableObject,CLLocationManagerDelegate {
    
    @Published var mapview = MKMapView()
    @Published var region : MKCoordinateRegion!
    
    @Published var permissionDenied = false
    @Published var maptype : MKMapType = .standard
    
    @Published var txt = ""
    
    @Published var places : [Place] = []
    
    
    func selectplace(place:Place){
        
        txt = ""
        guard let coordinate = place.placemark.location?.coordinate else {return}
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.placemark.name ??  "No_Name"
        mapview.removeAnnotations(mapview.annotations)
        mapview.addAnnotation(pointAnnotation)
        
        let coordinateregion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapview.setRegion(coordinateregion, animated: true)
        mapview.setVisibleMapRect(mapview.visibleMapRect, animated: true)
    }
    
    func searchQuery(){
        
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = txt
        MKLocalSearch(request: request).start { (responce, _) in
            guard let result = responce else {return}
            
            self.places = result.mapItems.compactMap({ (item) -> Place? in
                return Place(placemark: item.placemark)
            })
        }
        
        
        
    }
    
    
    
    
    func updateMaptipe(){
        if maptype == .standard{
            
            maptype = .hybridFlyover
            mapview.mapType = maptype
            
        }
        else{
            
            maptype = .standard
            mapview.mapType = maptype
        }
        
    }
    
    func forcusLocation(){
        
        
        guard let _ = region else {return}
        mapview.setRegion(region, animated: true)
        mapview.setVisibleMapRect(mapview.visibleMapRect,animated: true)
        
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .denied:
            permissionDenied.toggle()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case.authorizedWhenInUse:
            manager.requestLocation()
        default:
            ()
        }
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        self.mapview.setRegion(self.region, animated: true)
        self.mapview.setVisibleMapRect(self.mapview.visibleMapRect, animated: true)
    }
    
}


