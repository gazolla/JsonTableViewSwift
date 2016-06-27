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
        if let request = NSMutableURLRequest(urlString: urlString, method: .GET) {
            connectToServer(request, completion: completion)
        } else {
            throwError(400, completion: completion)
        }
    }
    
    static func POST(urlString: String, body:NSData?, completion: (data: NSData?, error: NSError?)->Void){
        if let request = NSMutableURLRequest(urlString: urlString, method: .POST, body:body){
            connectToServer(request, completion: completion)
        } else {
            throwError(400, completion: completion)
        }
    }
    
    static func PUT(urlString: String, body:NSData?, completion: (data: NSData?, error: NSError?)->Void){
        if let request = NSMutableURLRequest(urlString: urlString, method: .PUT, body:body){
            connectToServer(request, completion: completion)
        } else {
            throwError(400, completion: completion)
        }
    }
    
    static func DELETE(urlString: String, completion: (data: NSData?, error: NSError?)->Void){
        if let request = NSMutableURLRequest(urlString: urlString, method: .DELETE){
            connectToServer(request, completion: completion)
        } else {
            throwError(400, completion: completion)
        }
    }
    
    static func connectToServer(request:NSMutableURLRequest, completion:(data:NSData?, error:NSError?) -> Void){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if let responseError = error{
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if 200...299 ~= httpResponse.statusCode {
                    completion(data: data, error: nil)
                } else {
                    throwError(httpResponse.statusCode, completion: completion)
                }
            }
        }
        task.resume()
    }
    
    static func throwError(code:Int, completion:(data:NSData?, error:NSError?)->Void){
        let statusError = NSError(domain: "com.gazapps", code: code, userInfo: [NSLocalizedDescriptionKey: NSHTTPURLResponse.localizedStringForStatusCode(code)])
        completion(data: nil, error: statusError)
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
    case GET
    case POST
    case PUT
    case HEAD
    case DELETE
    case PATCH
    case OPTIONS
    case TRACE
    case CONNECT
    case UNKNOWN 
}
