//
//  HTTP.swift
//  JsonTableViewSwift
//
//  Created by Gazolla on 22/02/16.
//  Copyright © 2016 Gazolla. All rights reserved.
//

import UIKit

class HTTP {
    
    static func GET(urlString: String, completion: (data: NSData?, error: NSError?)->Void){
        let request = NSMutableURLRequest(urlString: urlString, method: .GET)
        connectToServer(request!, completion: completion)
    }
    
    static func POST(urlString: String, body:NSData?, completion: (data: NSData?, error: NSError?)->Void){
        let request = NSMutableURLRequest(urlString: urlString, method: .POST, body:body)
        connectToServer(request!, completion: completion)
    }
    
    static func PUT(urlString: String, body:NSData?, completion: (data: NSData?, error: NSError?)->Void){
        let request = NSMutableURLRequest(urlString: urlString, method: .PUT, body:body)
        connectToServer(request!, completion: completion)
    }
    
    static func DELETE(urlString: String, completion: (data: NSData?, error: NSError?)->Void){
        let request = NSMutableURLRequest(urlString: urlString, method: .DELETE)
        connectToServer(request!, completion: completion)
    }
    
    static func connectToServer(request:NSMutableURLRequest, completion:(data:NSData?, error:NSError?) -> Void){
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let responseError = error{
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 && httpResponse.statusCode != 201 && httpResponse.statusCode != 204 {
                    let statusError = NSError(domain: "com.gazapps", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        }
        task.resume()
    }

}

extension NSMutableURLRequest {
    public convenience init?(urlString:String, method:HTTPVerb, body:NSData?=nil){
        if let url = NSURL(string: urlString) {
            self.init(URL:url)
            self.addValue("application/json", forHTTPHeaderField: "Content-Type")
            self.addValue("application/Json", forHTTPHeaderField: "Accept")
            self.HTTPBody = body
            self.HTTPMethod = method.rawValue
        } else {
            return nil
        }
    }
}

public enum HTTPVerb: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case HEAD = "HEAD"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    case OPTIONS = "OPTIONS"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
    case UNKNOWN = "UNKNOWN"
}
