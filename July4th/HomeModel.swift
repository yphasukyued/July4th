import Foundation
import MapKit

protocol HomeModelProtocal: class {
    func itemsDownloaded(_ items: NSArray)
}


class HomeModel: NSObject, URLSessionDataDelegate {
    
    //properties
    
    weak var delegate: HomeModelProtocal!
    var data : NSMutableData = NSMutableData()
    var urlPath: String = ""
    
    func downloadItems(_ type: String) {
        
        if type == "Points" {
            urlPath = "https://gis.howardcountymd.gov/iOS/July4th/GetPointsList.aspx"
        } else {
            urlPath = "https://gis.howardcountymd.gov/iOS/July4th/GetList.aspx"
        }
        let url: URL = URL(string: urlPath)!
        var session: Foundation.URLSession!
        let configuration = URLSessionConfiguration.default
        
        
        session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: url)
        
        task.resume()
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.data.append(data);
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("Failed to download data")
        }else {
            print("Data downloaded")
            self.parseJSON()
        }
    }
    
    func parseJSON() {
        
        var jsonResult: NSMutableArray = NSMutableArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: self.data as Data, options:JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        let locations: NSMutableArray = NSMutableArray()
        
        for item:AnyObject in jsonResult as [AnyObject] {
            
            let location = LocationModel()
            let category = (item["Category"] as? String)!
            let name = (item["Name"] as? String)!
            let latitude = (item["Y"] as? Double)!
            let longitude = (item["X"] as? Double)!
            
            location.category = category as String
            location.name = name as String
            location.latitude = latitude as Double
            location.longitude = longitude as Double
            
            locations.add(location)
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(locations)
            
        })
    }
}
