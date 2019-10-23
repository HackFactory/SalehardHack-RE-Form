//
//  MapViewController.swift
//  PowerMe
//
//  Created by Yaroslav Spirin on 22/10/2019.
//  Copyright © 2019 Yaroslav Spirin. All rights reserved.
//

import UIKit
import MapKit

struct MapAnnotationWrapper {
    var annotation: MKPointAnnotation!
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.annotation = MKPointAnnotation()
        self.annotation.coordinate = self.coordinate
    }
}

struct AnnotatedWorldPoint {
    var annotation: MapAnnotationWrapper
    var name: String
    var interests: String
    var distance: String
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 3000
    var locationHasBeenSet: Bool = false
    
    var lastLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkLocationServices()
        
        mapView.delegate = self
        searchBar.delegate = self
        setupLocationManager()
        
        showAnnotations()
    }
    
    private func showAnnotations() {
        let rawAnnotations = annotations.map { (worldPoint) -> MKPointAnnotation in
            let rawAnnotation = worldPoint.annotation.annotation
            rawAnnotation?.title = worldPoint.interests
            rawAnnotation?.subtitle = "\(worldPoint.name) находится на расстоянии \(worldPoint.distance) от Вас. Вы хотите пойти на встречу c \(worldPoint.name), чтобы посетить \(worldPoint.interests)?"
            return rawAnnotation!
        }
        
        mapView.addAnnotations(rawAnnotations)
    }
    
    
    let annotations: [AnnotatedWorldPoint] = [
        AnnotatedWorldPoint(annotation: MapAnnotationWrapper(coordinate: CLLocationCoordinate2D(latitude: 66.540899, longitude: 66.623402)),
                            name: "Вадим", interests: "Лыжные гонки", distance: "900м"),
        AnnotatedWorldPoint(annotation: MapAnnotationWrapper(coordinate: CLLocationCoordinate2D(latitude: 66.539700, longitude: 66.611102)),
                            name: "Алексей", interests: "Бассейн", distance: "1.3км"),
        AnnotatedWorldPoint(annotation: MapAnnotationWrapper(coordinate: CLLocationCoordinate2D(latitude: 66.543899, longitude: 66.619202)),
                            name: "Максим", interests: "Путешествия", distance: "700м"),
        AnnotatedWorldPoint(annotation: MapAnnotationWrapper(coordinate: CLLocationCoordinate2D(latitude: 66.541700, longitude: 66.6374102)),
                            name: "Владислав", interests: "Чтение", distance: "1.2км"),
        AnnotatedWorldPoint(annotation: MapAnnotationWrapper(coordinate: CLLocationCoordinate2D(latitude: 66.520899, longitude: 66.629542)),
                            name: "Артем", interests: "Утренняя прогулка", distance: "200м"),
        AnnotatedWorldPoint(annotation: MapAnnotationWrapper(coordinate: CLLocationCoordinate2D(latitude: 66.580700, longitude: 66.613202)),
                            name: "Станислав", interests: "Прогулка", distance: "2.3км"),
        AnnotatedWorldPoint(annotation: MapAnnotationWrapper(coordinate: CLLocationCoordinate2D(latitude: 66.53389, longitude: 66.623402)),
                            name: "Ярослав", interests: "Спортивный зал", distance: "1.6м"),
        AnnotatedWorldPoint(annotation: MapAnnotationWrapper(coordinate: CLLocationCoordinate2D(latitude: 66.54200, longitude: 66.611102)),
                            name: "Никита", interests: "Рыбалка", distance: "700км"),
    ]
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let title = view.annotation?.title,
            let subtitle = view.annotation?.subtitle else {
            return
        }
        
        let alertController = UIAlertController(title: title, message: subtitle, preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Откликнуться", style: .default) { (action) in
            let auxAlertController = UIAlertController(title: "Встреча назначена", message: nil, preferredStyle: .alert)
            self.present(auxAlertController, animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отказаться", style: .cancel)
        
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension MapViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
}

extension MapViewController {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
        
        guard !locationHasBeenSet else {
            return
        }
        
        guard let location = locations.last else { return }
        
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        locationHasBeenSet = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
