//
//  MapView.swift
//  UI-96
//
//  Created by にゃんにゃん丸 on 2021/01/05.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @EnvironmentObject var model : MapViewModel
    
    func makeCoordinator() -> Coordinator {
        
        
        return MapView.Coordinator()
     
       
        
    }
    func makeUIView(context: Context) -> MKMapView {
        
        let view = model.mapview
        view.showsUserLocation = true
        view.delegate = context.coordinator
        return view
        
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class Coordinator : NSObject,MKMapViewDelegate{
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation.isKind(of: MKUserLocation.self){return nil}
            
            else{
                
                 let pinAnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin_View")
                pinAnotation.tintColor = .red
                pinAnotation.animatesDrop = true
                pinAnotation.canShowCallout = true
                
                return pinAnotation
                
            }
            
            
        }
        
        
    }
   
}


