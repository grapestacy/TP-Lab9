//
//  photoAnnotationView.swift
//  PhotoApp
//
// Created by Stacy Vinogradova on 29.04.21.
//

import UIKit
import MapKit

class PhotoAnnotationView: MKMarkerAnnotationView {

    var city: City?
    weak var delegate: PhotoAnnotationDelegate?
 
    let animationDuration: TimeInterval = 0.5

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        canShowCallout = false
        isUserInteractionEnabled = true
}
    convenience  init(annotation: MKAnnotation?, reuseIdentifier: String?, model: City) {
        self.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.city = model
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
/*----------
    Pragma Mark
    ------*/
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(!selected, animated: animated)
        guard let annotationCoordinate = self.annotation?.coordinate else {
            return
        }
        let zoomRegion = MKCoordinateRegion(center: annotationCoordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        if let annotation = self.annotation,
           selected == true{
        self.delegate?.setChoosenAnnotation(annotation: annotation)
            self.delegate?.makeDestinationMKItem(coordinate: annotationCoordinate)
            self.delegate?.moveMap(zoomRegion: zoomRegion)
            self.delegate?.presentController(city: city ?? City.init())
        }

        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }



}
