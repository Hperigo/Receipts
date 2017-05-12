//
//  MainViewController.swift
//  Rcpts
//
//  Created by Henrique on 5/11/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet weak var datePicker: NSDatePicker!
    @IBOutlet var reciptImageView: NSImageView!
    
    
    // Text fields....
    @IBOutlet var ameTextField: NSTextField!
    @IBOutlet var valueTextField: NSTextField!
    @IBOutlet var tagTextField: NSTextField!
    
    var app : AppDelegate?
    //bt's
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        datePicker.dateValue = Date()

    }
    
    @IBAction func sendPressed(_ sender: Any) {
    
        
        
            let str = "{ \"name\":\"John\", \"age\":31, \"city\":\"New York\" }"
        
            let url = NSURL(string: "http://0.0.0.0:4000/uploader")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
        
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = str.data(using: .utf8)
    
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                if error != nil{
                    print(error!.localizedDescription)
                    return
                }
                
                let str = String.init(data: data!, encoding: .utf8)
                print( str! )
        
            }
            task.resume()
        
            app?.closePopover(sender: nil)
    }
    
    @IBAction func closePressed(_ sender: Any) {
        
            app?.closePopover(sender: nil)
        
    }
    
    @IBAction func quitPressed(_ sender: Any) {
        NSApplication.shared().terminate(sender)

    }

}
