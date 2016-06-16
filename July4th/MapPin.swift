import Foundation
import MapKit

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var pin: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, pin: String) {
        self.coordinate = coordinate
        self.title = title
        self.pin = pin
    }
}