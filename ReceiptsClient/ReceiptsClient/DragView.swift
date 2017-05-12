//
//  DragView.swift
//  Rcpts
//
//  Created by Henrique on 5/11/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import Cocoa
//
//  StatusView.swift
//  Recipts
//
//  Created by Henrique on 5/10/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import Cocoa


class DragView: NSView {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    var clickMenu : NSMenu?
    let popover = NSPopover()
    
    var app : AppDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        
        register(forDraggedTypes: [NSFilenamesPboardType, NSURLPboardType])
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        self.layer?.backgroundColor = NSColor.lightGray.cgColor
        
        return .copy
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = nil
        
    }
    
    override func draggingEnded(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = nil
    }
    
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let pasteboard = sender.draggingPasteboard().propertyList(forType: "NSFilenamesPboardType") as? NSArray,
            let path = pasteboard[0] as? String
            else { return false }
        
        Swift.print("FilePath: \(path)")
        app?.showPopover(sender: nil, path: path)
        
        
        self.layer?.backgroundColor = nil
        
        return true
    }

}
