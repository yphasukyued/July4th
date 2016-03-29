import Foundation
import MapKit

protocol HomeModelProtocal: class {
    func itemsDownloaded(items: NSArray)
}


class HomeModel: NSObject, NSURLSessionDataDelegate {
    
    //properties
    
    weak var delegate: HomeModelProtocal!
    var data : NSMutableData = NSMutableData()
    var urlPath: String = ""
    var dataType: String = ""
    
    func downloadItems(type: String) {
        
        dataType = type.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        if type == "Points" {
            urlPath = "https://gis.howardcountymd.gov/iOS/July4th/GetPointsList.aspx"
        } else {
            urlPath = "https://gis.howardcountymd.gov/iOS/July4th/GetList.aspx?cat="+dataType
        }
        let url: NSURL = NSURL(string: urlPath)!
        var session: NSURLSession!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTaskWithURL(url)
        
        task.resume()
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        self.data.appendData(data);
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
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
            jsonResult = try NSJSONSerialization.JSONObjectWithData(self.data, options:NSJSONReadingOptions.AllowFragments) as! NSMutableArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        let locations: NSMutableArray = NSMutableArray()
        
        for item in jsonResult {
            
            let location = LocationModel()
            let category = (item["Category"] as? String)!
            let name = (item["Name"] as? String)!
            let desc = (item["Description"] as? String)!
            let url = (item["URL"] as? String)!
            let latitude = (item["Y"] as? Double)!
            let longitude = (item["X"] as? Double)!
            
            location.url = url as String
            location.category = category as String
            location.name = name as String
            location.desc = desc as String
            location.latitude = latitude as Double
            location.longitude = longitude as Double
            
            locations.addObject(location)
            
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.delegate.itemsDownloaded(locations)
            
        })
    }
}