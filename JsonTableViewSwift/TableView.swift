//
//  TableView.swift
//  JsonTableViewSwift
//
//  Created by Gazolla on 23/09/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit


class TableView: UIViewController,UITableViewDelegate, UITableViewDataSource {

    lazy var tableView : UITableView = {
        let tv = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tv.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        tv.delegate = self
        tv.dataSource = self
        tv.registerClass(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    var items :[Album] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.title = "JSON TableView"
        
        self.view.addSubview(self.tableView)
        self.loadData()
    }
    
    func loadData(){
        Album.findAll { (albums, error) -> () in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if (error != nil){
                self.loadDataErrorMessage(error!)
                return
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.items = albums!
                    self.tableView.reloadData()
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                })
            }
        }
    }

    func loadDataErrorMessage(error:NSError){
        let alertController = UIAlertController(title: "Error - \(error.code)", message: error.localizedDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Retry", style: .Default, handler: { (alert:UIAlertAction) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.loadData()
            alertController.dismissViewControllerAnimated(true, completion: {})
        })
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: {})
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: CustomTableViewCell? =  tableView .dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? CustomTableViewCell
        
        let album = self.items[indexPath.row]
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
        self.items.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        
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
