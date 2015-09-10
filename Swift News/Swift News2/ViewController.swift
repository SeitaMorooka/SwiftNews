//
//  ViewController.swift
//  Swift News2
//
//  Created by 師岡誠太 on 2015/09/09.
//  Copyright (c) 2015年 Seita Morooka. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var entries = NSMutableArray()
    
    let newsUrlStrings = [
        "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://news.yahoo.co.jp/pickup/domestic/rss.xml&num=8",
        "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://news.yahoo.co.jp/pickup/world/rss.xml&num=8",
        "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://news.yahoo.co.jp/pickup/sports/rss.xml&num=8"
        ]
    
    let imageNames = [
    "japan.jpg",
    "world.jpg",
    "sport.jpg",
    ]

    @IBAction func refresh(sender: AnyObject) {
        entries.removeAllObjects()
        
        
        for newsUrlString in newsUrlStrings{
            
        var url = NSURL(string: newsUrlString)!
        var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { data, respinse, error in
            
            var dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            if var responseData = dict["responseData"] as? NSDictionary {
                if var feed = responseData["feed"] as? NSDictionary {
                    if var entries = feed["entries"] as? NSArray {
                        
                        var formatter = NSDateFormatter()
                        formatter.locale = NSLocale(localeIdentifier: "en-US")
                        formatter.dateFormat = "EEE, dd MMMM yyyy HH:mm:ss zzzz"
                        
                        for var i = 0; i < entries.count; i++ {
                            var entry = entries[i] as! NSMutableDictionary
                            
                        entry["url"] = newsUrlString
                            
                            var dateStr = entry["publishedDate"] as! String
                            var date = formatter.dateFromString(dateStr)
                            entry["date"] = date
                        }
                        
                        self.entries.addObjectsFromArray(entries as[AnyObject])
                        
                        self.entries.sortUsingComparator({ object1, object2 in
                            var date1 = object1["date"] as! NSDate
                            var date2 = object2["date"] as! NSDate
                            
                            var order = date1.compare(date2)
                            
                            if order == NSComparisonResult.OrderedAscending {
                                return NSComparisonResult.OrderedAscending
                            }
                            else if order == NSComparisonResult.OrderedAscending {
                                return NSComparisonResult.OrderedAscending
                            }
                            return order
                        })
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                
                self.tableView.reloadData()
                
            })
        })
        task.resume()
    }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("news") as! UITableViewCell

        var entry = entries[indexPath.row] as! NSDictionary
         
        var titleLabel = cell.viewWithTag(1) as! UILabel
        titleLabel.text = entry["title"] as? String
            
        var dateLabel = cell.viewWithTag(3) as! UILabel
        dateLabel.text = entry["publishedDate"] as? String
        
        var urlString = entry["url"] as! String
        var index = find(newsUrlStrings, urlString)
        var imageName = imageNames[index!]
        var image = UIImage(named: imageName)
            
        var imageView = cell.viewWithTag(4) as! UIImageView
        imageView.image = image
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("detail", sender: entries[indexPath.row])
    }
            
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "detail" {
            var detailController = segue.destinationViewController as! DetailController
                    
                    detailController.entry = sender as! NSDictionary
                }
            }
    }