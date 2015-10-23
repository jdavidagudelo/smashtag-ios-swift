//
//  TweetTableViewController.swift
//  SmashTag
//
//  Created by Ingenieria y Software on 22/10/15.
//  Copyright © 2015 Ingenieria y Software. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate {

    
    var searchText: String? = "·#stanford"{
        didSet{
            lastSuccesfulRequest = nil
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
        {
        didSet{
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField
        {
            textField.resignFirstResponder()
            searchText = searchTextField.text
        }
        return true
    }
    var tweets = [[Tweet]]()
    var spinner: UIRefreshControl?
    var lastSuccesfulRequest: TwitterRequest?
    var nextRequestToAttempt: TwitterRequest?
         {
        get{
            if lastSuccesfulRequest == nil{
                if searchText != nil{
                    return TwitterRequest(search: searchText!, count: 100)
                }
                else{
                return nil
                }
            }else{
                return lastSuccesfulRequest!.requestForNewer!
            }
        }
    }
    @IBAction func refresh(sender: UIRefreshControl){
        refresh()
    }
    func refresh(){
        if searchText != nil
        {
             if let request = nextRequestToAttempt
             {
                refreshControl?.beginRefreshing()
                request.fetchTweets{(newTweets) -> Void in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if newTweets.count > 0
                    {
                        self.lastSuccesfulRequest = request
                        self.tweets.insert(newTweets, atIndex:0)
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                    }
                }
            }
            }
        }
        else{
            spinner?.endRefreshing()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      refresh()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    private struct StoryBoard{
        static let CellReuseIdentifier = "Tweet"
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
         // Configure the cell...
            let tweet = tweets[indexPath.section][indexPath.row]
            cell.tweet = tweet
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
