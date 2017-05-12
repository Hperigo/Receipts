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
        
        let dragView = DragView(frame: NSRect(x: 0, y: 0, width: 24, height: 24))
        dragView.app = self
        
        statusItem.button?.addSubview(dragView)
        statusItem.action = #selector(togglePopover( sender: ));
        
        popoverViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        popover.contentViewController = popoverViewController
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    // -- Behaviour ----
    
    func sendToServer(){
        // TODO: make data class
    }
    
    
    // -- Popover ---
    
    func showPopover(sender: AnyObject?, path : String?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            
        
            let img  = NSImage(byReferencingFile: path!)
            popoverViewController?.reciptImageView.image = img
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

