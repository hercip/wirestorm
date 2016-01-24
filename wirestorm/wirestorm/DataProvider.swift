//
//  DataProvider.swift
//  wirestorm
//
//  Created by Ciprian Herman on 24/01/16.
//  Copyright © 2016 Ciprian Herman. All rights reserved.
//

import UIKit

struct TableData {
    var lrgpic : String
    var name: String
    var position: String
    var smallpic: String
}


extension UIImageView {
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode, completionHandler:((UIColor) -> Void)?) {
        
        
        guard let url = NSURL(string: link) else {
            if completionHandler != nil  {
                return completionHandler!(UIColor.blueColor())
            }
            return
        }
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
                else {
                    print("err")
                    if completionHandler != nil  {
                        return completionHandler!(UIColor.redColor())
                    }
                    return
            }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image
                if completionHandler != nil  {
                    return completionHandler!(UIColor.greenColor())
                }
            }
        }).resume()
    }
    
}


class DataProvider: NSObject {

    func jsonFromRequest(completionHandler: ((AnyObject!) -> Void)!) {
        
        let requestURL = "https://s3-us-west-2.amazonaws.com/wirestorm/assets/response.json"
        let request = NSMutableURLRequest(URL: NSURL(string: requestURL)!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "GET"
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, err -> Void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if err != nil {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                return completionHandler(nil)
            }
            
            if data != nil {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSArray
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    return completionHandler(json)
                } catch {
                    print("error serializing JSON: \(error)")
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    return completionHandler(nil)
                }}
            
            
        })
        
        task.resume()
    }
    
    
    func requestData(completionHandler:(Array<TableData> -> Void)!) {
        self.requestArrayForRequest { (receivedAccounts) -> Void in
            if let tableData = self.loadTableData(receivedAccounts) {
                return completionHandler(tableData)
            }
            return completionHandler(Array<TableData>())
        }
    }
    
    func loadTableData(tableData:NSArray) -> Array<TableData>?{
        var newTableData = Array<TableData>()
        for tableDictionary in tableData {
            guard
                let lrgpic = tableDictionary["lrgpic"] as? String,
                let name = tableDictionary["name"] as? String,
                let position = tableDictionary["position"] as? String,
                let smallpic = tableDictionary["smallpic"] as? String
                else {return nil}
            let record = TableData(lrgpic: lrgpic, name: name, position: position, smallpic: smallpic)
            newTableData.append(record)
        }
        return newTableData
    }
    
    func requestArrayForRequest(completionHandler:(NSArray -> Void)!) {
        self.jsonFromRequest({result in
            if let received = result as? NSArray {
                return completionHandler(received)
            }
            
            let received = NSArray()
            return completionHandler(received)
        })
    }
}
