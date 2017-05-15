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
    @IBOutlet var nameTextField: NSTextField!
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
    
        
        let receipt = getReceiptData()
        let sucess = app?.sendJsonToServer( receiptInfo: receipt )
        
        if(sucess == true ){
            let name = receipt.name! + ".jpg"
            app?.sendImageToServer(image: reciptImageView.image!, filename: name)
            app?.closePopover(sender: nil)
        }
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        
            app?.closePopover(sender: nil)
        
    }
    
    @IBAction func quitPressed(_ sender: Any) {
        app?.cleanup()
        NSApplication.shared().terminate(sender)

    }
    
    func getReceiptData() -> ReceiptInfo{
        
        let info : ReceiptInfo! = ReceiptInfo()
        info.name = nameTextField.stringValue
        info.value = valueTextField.stringValue
        info.date = datePicker.dateValue
        info.uuid = UUID().uuidString
        info.paid = true
        let stringTags = tagTextField.stringValue
        let tagArray = stringTags.components(separatedBy: ",")
        
        info.labels = tagArray
        
        return info
    }

}
