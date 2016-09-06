import Foundation

class Networking {
    
    typealias networkingClosure = (data: NSData?, response: NSHTTPURLResponse?, error:NSError?) -> Void
    
    func getHTTPDataFromURL(url: NSURL?, success: networkingClosure, failure: networkingClosure) {
        
        let session = NSURLSession.sharedSession()
        if url != nil {
            
            let request = NSMutableURLRequest(URL: url!)
            request.setValue("hz7JPdKK069Ui1TRxxd1k8BQcocSVDkj219DVzzD", forHTTPHeaderField: "x-api-key")
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            let task = session.dataTaskWithRequest(request) {
                data, response, error in
                
                if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                    dispatch_async(dispatch_get_main_queue()) {
                        success(data: data, response: httpResponse, error: error)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        failure(data: data, response: response as? NSHTTPURLResponse, error: error)
                    }
                }
            }
            
            task.resume()
        }
    }
}