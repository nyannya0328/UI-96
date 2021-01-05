//
//  Place.swift
//  UI-96
//
//  Created by にゃんにゃん丸 on 2021/01/05.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    var id = UUID().uuidString
    var placemark : CLPlacemark
    
}


