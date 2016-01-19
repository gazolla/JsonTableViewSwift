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
    var items :[Album]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.title = "JSON TableView"
        
        self.setupTableView()
        self.processJSON()
    }
    
    func processJSON(){
        let url : NSURL = NSURL(string: "http://itunes.apple.com/us/rss/topalbums/limit=200/json")!
        let request: NSURLRequest = NSURLRequest(URL: url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            if (error != nil){
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Retry", style: .Default, handler: { (alert:UIAlertAction) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    self.processJSON()
                    alertController.dismissViewControllerAnimated(true, completion: {})
                })
                
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: {})
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                return
            }
            
            do {
                let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                
                if let feed = jsonArray["feed"]  {
                    if let entries = feed!["entry"] as? NSArray {
                        self.items = []
                        for entry in entries {
                            let album:Album = Album()
                            if let name = entry["im:artist"] as? NSDictionary {
                                if let label = name["label"] as? String {
                                    album.artistName = label
                                }
                            }
                            if let title = entry["title"] as? NSDictionary {
                                if let label = title["label"] as? String {
                                    album.collectionName = label
                                }
                            }
                            if let price = entry["im:price"] as? NSDictionary {
                                if let label = price["label"] as? String {
                                    album.collectionPrice = label
                                }
                            }
                            
                            self.items!.append(album)
                            
                        }
                    }
                }

                    
                
            } catch {
                print("Fetch failed: \((error as NSError).localizedDescription)")
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.updateTableViewAnimated()
              //  self.tableView?.reloadData()
              //  self.navigationItem.rightBarButtonItem = self.searchButton
                self.tableView!.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            
        })
        
        task.resume()
        
    }

    
    
    func updateTableViewAnimated(){
        var tempArray : [NSIndexPath] = []
        for index in 0..<(self.items!.count) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tempArray.append(indexPath)
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
        let cell: CustomTableViewCell? =  tableView .dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? CustomTableViewCell
        
        let album = self.items![indexPath.row]
        cell!.textLabel?.text = album.artistName
        cell!.detailTextLabel?.text = album.collectionName
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        self.items?.removeAtIndex(indexPath.row)
        self.tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        return (UITableViewCellEditingStyle.Delete)
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("row = %d",indexPath.row)
    }

}
