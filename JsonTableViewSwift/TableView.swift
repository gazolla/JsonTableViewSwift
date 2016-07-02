//
//  TableView.swift
//  JsonTableViewSwift
//
//  Created by Gazolla on 23/09/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit


class TableView<Item>: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var cellType:AnyClass
    let configureCell:(cell:UITableViewCell, item:Item)->()
    
    init(entries:[Item], cell:AnyClass, configureCell:(cell:UITableViewCell, item:Item)->()){
        self.cellType = cell
        self.configureCell = configureCell
        self.items = entries
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var items:[Item] = [] {
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
        self.view.addSubview(self.tableView)
    }
    
    func loadDataErrorMessage(error:NSError){
        let alertController = UIAlertController(title: "Error - \(error.code)", message: error.localizedDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (alert:UIAlertAction) -> Void in
            alertController.dismissViewControllerAnimated(true, completion: {})
        })
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: {})
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let item = self.items[indexPath.row]
        configureCell(cell: cell, item: item)
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
