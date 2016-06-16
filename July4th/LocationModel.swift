import Foundation

class LocationModel: NSObject {
    
    //properties
    var category: String?
    var name: String?
    var latitude: Double?
    var longitude: Double?
    
    
    //empty constructor
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    init(category: String, name: String, latitude: Double, longitude: Double) {
        
        self.category = category
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Category: \(category), Name: \(name), Latitude: \(latitude), Longitude: \(longitude)"
        
    }
    
    
}