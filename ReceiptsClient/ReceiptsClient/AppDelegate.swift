//
//  AppDelegate.swift
//  ReceiptsClient
//
//  Created by Henrique on 5/12/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

//
//  AppDelegate.swift
//  Recipts
//
//  Created by Henrique on 5/10/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    let popover = NSPopover()
    var popoverViewController : MainViewController?
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
 

        
//        statusItem.title = "Receipts"
        

        statusItem.button?.image = NSImage(named: "icon")
        statusItem.button?.image?.size = NSSize(width: 20, height: 20)
        
        let dragView = DragView(frame:(statusItem.button?.visibleRect)!)
        dragView.app = self
        statusItem.button?.addSubview(dragView)
        statusItem.action = #selector(togglePopover( sender: ));
        
        
        
        popoverViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        popoverViewController?.app = self
        popover.contentViewController = popoverViewController
        
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    // -- Behaviour ----
    
    func sendToServer(receiptInfo : ReceiptInfo) -> Bool{
        
        let str = "{ \"name\":\"John\", \"age\":31, \"city\":\"New York\" }"
        
        let url = NSURL(string: "http://0.0.0.0:4000/uploader")!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = receiptInfo.toJson()
        
        var sucess = true
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            if error != nil{
                print(error!.localizedDescription)
                sucess = false
                return
            }
            
            let str = String.init(data: data!, encoding: .utf8)
            print( str! )
            
        }
        task.resume()
    
        
        return sucess
    }
    
    
    // -- Popover ---
    
    func showPopover(sender: AnyObject?, path : NSURL?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            
            if(path != nil){
                
//                NSLog((path?.baseURL?.absoluteString)!)
//                let data = try ? Data(contentsOf: (path?.absoluteURL)! )
//                
//                let img  = NSImage(data: data?.base64EncodedData(options: NSData.Base64EncodingOptions.))
//                //let img = NSImage(byReferencing: (path?.baseURL)!)
////                let img  = NSImage(byReferencingFile: path!)
                
                if(path?.isFileURL == true){
                    let img = NSImage(byReferencing: path!.filePathURL!)
                    popoverViewController?.reciptImageView.image = img
                }else{
                    
                    let url = path?.absoluteURL
                    let data = try? Data(contentsOf: url!)
                    
                    let img = NSImage(data: data!)
                    popoverViewController?.reciptImageView.image = img
                    
                }
                

                
            }

        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender:nil, path: nil)
        }
    }
}

