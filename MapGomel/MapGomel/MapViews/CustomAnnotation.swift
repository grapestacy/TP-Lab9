//
//  CustomAnnotation.swift
//  MapGomel
//
//  Created by Stacy Vinogradova on 29.04.21.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var city: City?
    var color = UIColor.clear
    var musems = ""
    
     init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
