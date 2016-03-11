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
        
        dataType = type
        
        if type == "Winery" {
            urlPath = "https://gis.howardcountymd.gov/iOS/WineInTheWoods/GetWineryList.aspx"
        } else if type == "Food"
            || type == "Crafter"
            || type == "Sponsors" {
            urlPath = "https://gis.howardcountymd.gov/iOS/WineInTheWoods/GetName.aspx?mytype="+type
        } else if type == "Music" {
            urlPath = "https://gis.howardcountymd.gov/iOS/WineInTheWoods/GetEntertainerList.aspx?stage=All"
        } else if type == "Other" {
            urlPath = "https://gis.howardcountymd.gov/iOS/WineInTheWoods/GetOthersList.aspx"
        } else if type == "Points" {
            urlPath = "https://gis.howardcountymd.gov/iOS/WineInTheWoods/GetPointsList.aspx"
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
        
        var jsonElement: NSDictionary = NSDictionary()
        let locations: NSMutableArray = NSMutableArray()
        
        //print(jsonResult)
        
        for(var i = 0; i < jsonResult.count; i++)
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let location = LocationModel()
            var name: NSString = ""
            var desc: NSString = ""
            var locTime: NSString = ""
            var url: NSString = ""
            var phone: NSString = ""
            var pin: NSString = ""
            
            
            if dataType == "Winery" {
                name = (jsonElement["Wine_Maker"] as? String)!
                desc = (jsonElement["TentID"] as? String)!
                locTime = (jsonElement["City"] as? String)! +
                    ", " + (jsonElement["State"] as? String)! +
                    " " + (jsonElement["Zip"] as? String)!
                url = (jsonElement["URL"] as? String)!
                phone = (jsonElement["Phone"] as? String)!
                pin = (jsonElement["TentID"] as? String)!
            } else if dataType == "Food"
                || dataType == "Sponsors" {
                name = (jsonElement["NAME"] as? String)!
                desc = (jsonElement["DESCRIPTION"] as? String)!
                locTime = (jsonElement["TYPE"] as? String)!
                url = (jsonElement["URL2"] as? String)!
                pin = (jsonElement["TEXTLABEL"] as? String)!
            } else if dataType == "Crafter" {
                    name = (jsonElement["NAME"] as? String)!
                    desc = (jsonElement["DESCRIPTION"] as? String)!
                    locTime = (jsonElement["TYPE"] as? String)!
                    url = (jsonElement["URL2"] as? String)!
                    pin = "A" + (jsonElement["TEXTLABEL"] as? String)!
            } else if dataType == "Other" || dataType == "Points"{
                    name = (jsonElement["NAME"] as? String)!
                    desc = (jsonElement["DESCRIPTION"] as? String)!
                    locTime = (jsonElement["TYPE"] as? String)!
                    pin = (jsonElement["NAME"] as? String)!
            } else if dataType == "Music" {
                name = (jsonElement["ENTERTAINER"] as? String)!
                desc = (jsonElement["GENRE"] as? String)!
                locTime = (jsonElement["STAGE_NAME"] as? String)! +
                    " - " + (jsonElement["DATE_TIME"] as? String)!
                url = (jsonElement["URL"] as? String)!
                pin = (jsonElement["STAGE_NAME"] as? String)!
            }
            
            
            let latitude = jsonElement["Y"] as? Double
            let longitude = jsonElement["X"] as? Double
            
            location.name = name as String
            location.desc = desc as String
            location.locTime = locTime as String
            location.pin = pin as String
            location.latitude = latitude
            location.longitude = longitude
            location.url = url as String
            location.phone = phone as String
            locations.addObject(location)
            
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.delegate.itemsDownloaded(locations)
            
        })
    }
}