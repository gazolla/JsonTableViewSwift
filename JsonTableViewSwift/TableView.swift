//
//  TableView.swift
//  JsonTableViewSwift
//
//  Created by Gazolla on 23/09/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit


class TableView: UIViewController{
    
    var items:[Album] = [] {
        didSet{
            self.tableView.reloadData()
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
    }
    
    var error:NSError? {
        didSet{
            self.loadDataErrorMessage(error!)
        }
    }

    lazy var tableView : UITableView = {
        let tv = UITableView(frame: self.view.frame, style: UITableViewStyle.Grouped)
        tv.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        tv.delegate = self
        tv.dataSource = self
        tv.registerClass(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "JSON TableView"
        self.view.addSubview(self.tableView)
    }
    
    func loadDataErrorMessage(error:NSError){
        let alertController = UIAlertController(title: "Error - \(error.code)", message: error.localizedDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (alert:UIAlertAction) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            alertController.dismissViewControllerAnimated(true, completion: {})
        })
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: {})
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TableView:UITableViewDelegate, UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: CustomTableViewCell =  tableView .dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableViewCell
        cell.album = self.items[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        self.items.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        return (UITableViewCellEditingStyle.Delete)
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("row = %d",indexPath.row)
    }

}
