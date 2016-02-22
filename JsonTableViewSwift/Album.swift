//
//  Album.swift
//  JsonTableViewSwift
//
//  Created by Gazolla on 24/09/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit

class Album{
    
    var artistName : String?
    var collectionName : String?
    var collectionPrice : String?
    
    init(anArtistName : String, aCollectionName : String, aCollectionPrice : String){
        self.artistName = anArtistName
        self.collectionName = aCollectionName
        self.collectionPrice = aCollectionPrice
    }
    
    init(){
        
    }
    
    convenience required init(attrib:[String:AnyObject]){
        
        var artistName : String = ""
        var collectionName : String = ""
        var collectionPrice : String = ""
        
        if let name = attrib["im:artist"] {
            if let label = name["label"] as? String {
                artistName = label
            }
        }
        if let title = attrib["title"]  {
            if let label = title["label"] as? String {
                collectionName = label
            }
        }
        if let price = attrib["im:price"]  {
            if let label = price["label"] as? String {
                collectionPrice = label
            }
        }
        self.init(anArtistName : artistName, aCollectionName : collectionName, aCollectionPrice : collectionPrice)
        
    }
    
    static func findAll(completion:(album:[Album]?,error:NSError?)->()){
        let url = "http://itunes.apple.com/us/rss/topalbums/limit=200/json"
        HTTP.GET(url) { (data, error) -> Void in
            if let dt = data {
                var result:[Album] = []
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(dt, options: [])
                    if let feed = json["feed"]  {
                        if let entries = feed!["entry"] as? NSArray {
                            for entry in entries {
                                let album:Album = Album(attrib: entry as! [String : AnyObject])
                                result.append(album)
                                
                            }
                        }
                    }
                    completion(album: result, error: nil)
                } catch (let error as NSError){
                    completion(album: nil, error: error)
                }
            } else {
                completion(album: nil, error: error)
            }
            
        }
    }

    
}





