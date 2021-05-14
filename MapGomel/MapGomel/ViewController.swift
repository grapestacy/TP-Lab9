//
//  ViewController.swift
//  MapGomel
//
//  Created by Stacy Vinogradova on 29.04.21.
//

import UIKit
import MapKit
import CoreData

let Gomel = City.init(name: "Gomel", museums: "\nCriminalistics Museum\nPalace of the Rumyantsevs and the Paskeviches\nHomiel Regional Museum of Military Glory", latitude: 52.4313, longitude: 30.9937)

let Turov = City.init(name: "Turov", museums: "\nTurovskiy Krayevedcheskiy Muzey\nTurov Birds Ringing Station", latitude: 52.0664, longitude: 27.7407)

let Chachersk = City.init(name: "Chachersk", museums: "\nIstoriko-Yetnograficheskii Muzei\nČačersk Town Hall", latitude: 52.9191, longitude: 30.9157)


var citiesForCore = [Gomel, Turov, Chachersk]
var cities = [City]()


protocol PhotoAnnotationDelegate: AnyObject {
    func presentController(city:City)
    func moveMap(zoomRegion: MKCoordinateRegion)
    func makeDestinationMKItem(coordinate: CLLocationCoordinate2D)
    func setChoosenAnnotation(annotation:MKAnnotation)

}

protocol RequestDelegate: AnyObject {
    func setWeather(cityName:String, weather: Weather)
}


class ViewController: UIViewController, RequestDelegate {

    var choosenannotation : MKAnnotation?
    var destinationMapItem : MKMapItem?
    var weathers:[Weather]?
    var cityWeather = [String:Weather]()

    var persistentContainer: NSPersistentContainer = {
          let container = NSPersistentContainer(name: "MapGomel")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
              if let error = error as NSError? {
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
      }()
    
    private var currentCoordinate: CLLocationCoordinate2D?
    private let locationManager = CLLocationManager()


    var destinationCoordinate: CLLocationCoordinate2D?
    var route: MKRoute?
    @IBOutlet weak var mapView: MKMapView!
    
    var weatherGertter = WeatherGetter()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokazatChtoUmeuRabotatSCoreData() //must be run only once
        pokazatChtoUmeuRabotatSCoreData2()
        weatherGertter.delegate = self
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        for city in cities{
        weatherGertter.getWeatherByCoordinates(latitude: city.latitude, longitude: city.longitude, name: city.name)
        }
        addannotatios()
    }

    func setWeather(cityName: String, weather: Weather) {
        cityWeather[cityName] = weather
    }
    
    @IBAction func routeTapped(_ sender: Any) {
        self.mapView.removeOverlays(self.mapView.overlays)
        if self.destinationMapItem == nil{
            self.destinationCoordinate = nil
                                         }
        if let destinationItem = self.destinationMapItem{
            if let currentCoord = self.currentCoordinate{
                if let choosenAnnotation = self.choosenannotation{
                               self.mapView.deselectAnnotation(choosenAnnotation, animated: true)
                                   self.destinationMapItem = nil
                               }
            let directionRequest = MKDirections.Request()
            let currentplaceMark = MKPlacemark(coordinate: currentCoord, addressDictionary: nil)
            let sourceMapItem = MKMapItem(placemark: currentplaceMark)
            
            
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationItem
                directionRequest.transportType = .any
            let directions = MKDirections(request: directionRequest)
            directions.calculate {
                (response, error) -> Void in
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    return
                }
                let route = response.routes[0]
                self.route = route
                self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                
                let rect = route.polyline.boundingMapRect
               
                self.destinationCoordinate = destinationItem.placemark.coordinate
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
    }
    }
    
    func pokazatChtoUmeuRabotatSCoreData () {

        let context: NSManagedObjectContext = {
            return persistentContainer.viewContext
          }()
        
        for city in citiesForCore {
            var coreCity = CoreCity(context: context)
            coreCity.name = city.name
            coreCity.musems = city.museums
            coreCity.latitude = city.latitude
            coreCity.longitude = city.longitude
            if context.hasChanges {
                      do {
                          try context.save()
                      } catch {
                        context.rollback()
                          let nserror = error as NSError
                          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                      }
                  }
        }
    }
    
    func pokazatChtoUmeuRabotatSCoreData2 () {
        let context: NSManagedObjectContext = {
            return persistentContainer.viewContext
          }()
        
        let fetchRequest: NSFetchRequest<CoreCity> = CoreCity.fetchRequest()
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                if let name = object.name,
                   let musems = object.musems{
                    cities.append(City.init(name: name, museums: musems, latitude: object.latitude, longitude: object.longitude))
                }
            }
            print("aaaa")
        }
        catch {
          context.rollback()
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        print("aa")
    }
}

extension ViewController:CLLocationManagerDelegate,MKMapViewDelegate, PhotoAnnotationDelegate {
    func presentController(city: City) {
        let vc = DescriptionViewController()
        if let weather = cityWeather[city.name] {
            vc.cityName = city.name
            vc.museumsInfo = city.museums
            vc.weather = weather
        self.present(vc, animated: true, completion: nil)
        }
    }
    
    func moveMap(zoomRegion: MKCoordinateRegion) {
        mapView.setRegion(zoomRegion, animated: true)

    }
    
    func setChoosenAnnotation(annotation: MKAnnotation) {
        self.choosenannotation = annotation
    }
    
    func makeDestinationMKItem(coordinate: CLLocationCoordinate2D) {
       let destinationPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        self.destinationMapItem = destinationMapItem
    }
    
    func addannotatios() {
        var myMapAnnotations:[CustomAnnotation] = []
        
        for city in cities {
            let coord = CLLocationCoordinate2D(latitude: CLLocationDegrees(city.latitude), longitude:CLLocationDegrees(city.longitude) )
            let musems = city.museums
            let myMapAnnotation = CustomAnnotation.init(coordinate: coord)
            myMapAnnotation.city = city
            myMapAnnotation.musems = musems
            myMapAnnotations.append(myMapAnnotation)
        }
        
        for myannotation in myMapAnnotations {
            self.mapView.addAnnotation(myannotation)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation
           else {
               return nil }

       let customAnnotationViewIdentifier = "MyAnnotation"

       var pin = mapView.dequeueReusableAnnotationView(withIdentifier: customAnnotationViewIdentifier) as? PhotoAnnotationView
       if let city = annotation.city {
           pin = PhotoAnnotationView(annotation: annotation, reuseIdentifier: customAnnotationViewIdentifier, model: city)
           pin?.delegate = self
       }

        pin?.markerTintColor = UIColor.red
        if let str = annotation.city?.name {
            let index = str.index(str.startIndex, offsetBy: 3)
            pin?.glyphText = String(str.prefix(upTo: index))
       } else {
           pin?.glyphText = "Me"
       }
       return pin
   }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        guard let latestLocation = locations.first else { return }
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
           
        }
        currentCoordinate = latestLocation.coordinate
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .init(red: 0, green: 0, blue: 1, alpha: 0.7)
        return renderer
    }
}
