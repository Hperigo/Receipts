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
//        statusItem.action = #selector(togglePopover( sender: ));
        statusItem.action = #selector(screenshot(sender: ))
        
        
        
        popoverViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        popoverViewController?.app = self
        popover.contentViewController = popoverViewController
        
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    // -- HTTP Requests ----
    
    func sendImageToServer( receipt: ReceiptInfo)  {
        
        var r  = URLRequest(url: URL(string: "http://0.0.0.0:4000/image")!)
        r.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
        let image = receipt.image
        let bits = image?.representations.first as? NSBitmapImageRep
        let data = bits?.representation(using: .JPEG, properties: [:])

        
        let str = String(data: receipt.toJson(), encoding: .utf8)
        
        r.httpBody = createBody(boundary: boundary,
                                data: data!,
                                mimeType: "image/jpg",
                                filename: receipt.fileName!, parameters: ["data" : str!])
        
        
        let task = URLSession.shared.dataTask(with: r) { data, response, error in
            guard let data = data, error == nil else {               // check for fundamental networking error
                return
            }
            do {
                let str = String.init(data: data, encoding: .utf8)
                print( str! )
//                return true
            } catch let error as NSError {
                print("error : \(error)")
            }
        }
        task.resume()
    }
    
    
    
    func createBody(boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String,
                    parameters:[String:String] ) -> Data {
        
        
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
    

    
    // -- Popover ---
    
    func showPopover(sender: AnyObject?, path : NSURL?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            
            if(path != nil){
                
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
        cleanup()
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender:nil, path: nil)
        }
    }
    
    func screenshot(sender: AnyObject?) {
        
        let task:Process = Process()
        task.launchPath = "/usr/sbin/screencapture"
        
        let temp_path = NSTemporaryDirectory() + "reciptsScreen.png"
        NSLog(temp_path)
        
        task.arguments  = ["-i", temp_path]
        
        task.launch()
    
        task.waitUntilExit()
//        togglePopover(sender: nil)
        
        showPopover(sender: nil, path: NSURL(fileURLWithPath: temp_path))
    }
    
    func cleanup(){
        
        let fileManager = FileManager.default
        
        // Delete 'hello.swift' file
        let temp_path = NSTemporaryDirectory() + "reciptsScreen.png"
        
        do {
            try fileManager.removeItem(atPath: temp_path)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
    }
}

// --
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

