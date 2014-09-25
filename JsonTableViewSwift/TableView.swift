//
//  TableView.swift
//  JsonTableViewSwift
//
//  Created by Gazolla on 23/09/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit


class TableView: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var tableView : UITableView?
    var items :NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "JSON TableView"
        
        self.setupTableView()
        self.processJSON()
    }
    
    func processJSON(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        request(Method.POST, "http://itunes.apple.com/us/rss/topalbums/limit=200/json", parameters: nil, encoding: .JSON).responseJSON{(request, response, JSON, error) in
            
            if (error != nil){
                println(error, "\(error)")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                return
            }
            
            var artistName:String?
            var collectionName:String?
            var collectionPrice:String?
            var jsonError: NSError?
            
            if let feed = JSON!["feed"] as? NSDictionary {
                if let entries = feed["entry"] as? NSArray {
                    self.items = NSMutableArray()
                    for entry in entries {
                        
                        if let name = entry["im:artist"] as? NSDictionary {
                            if let label = name["label"] as? String {
                                artistName = label
                            }
                        }
                        if let title = entry["title"] as? NSDictionary {
                            if let label = title["label"] as? String {
                                collectionName = label
                            }
                        }
                        if let price = entry["im:price"] as? NSDictionary {
                            if let label = price["label"] as? String {
                                collectionPrice = label
                            }
                        }
                        let album = Album(anArtistName: artistName!, aCollectionName: collectionName!, aCollectionPrice: collectionPrice!)
                        self.items!.addObject(album)
                        
                    }
                }
            }
            self.updateTableViewAnimated()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func updateTableViewAnimated(){
        var tempArray : NSMutableArray = NSMutableArray()
        for index in 0..<(self.items!.count) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tempArray.addObject(indexPath)
        }
        self.tableView?.beginUpdates()
        self.tableView?.insertRowsAtIndexPaths(tempArray, withRowAnimation: UITableViewRowAnimation.Bottom)
        self.tableView?.endUpdates()
    }
    
    func setupTableView(){
        self.tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.registerClass(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let numberOfRows: Int = self.items?.count {
            return numberOfRows
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: CustomTableViewCell? =  tableView .dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? CustomTableViewCell
        
        let album:Album = self.items![indexPath.row] as Album
        cell!.textLabel?.text = album.artistName
        cell!.detailTextLabel?.text = album.collectionName
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!)
    {
        self.items?.removeObjectAtIndex(indexPath.row)
        self.tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle
    {
        return (UITableViewCellEditingStyle.Delete)
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        println("row = %d",indexPath.row)
    }

}
