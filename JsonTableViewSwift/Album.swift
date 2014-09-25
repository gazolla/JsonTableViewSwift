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
    
}
