//
//  ReceiptInfo.swift
//  ReceiptsClient
//
//  Created by Henrique on 5/12/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import Foundation
import Cocoa
import SwiftyJSON

class ReceiptInfo{
    
    var uuid : String?
    var fileName : String?
    var value : String?
    
    var tags : [String] = []
    
    var date : Date?
    var paid : Bool?
    
    var image : NSImage?
    
    func toJson() -> Data{

        let json : JSON = [
                "uuid": uuid!,
                "file_name": fileName!,
                "value": value!,
                "date": (date?.description)!,
                "paid": (paid?.description)!,
                "labels": tags
        ]
        
        let data = try? json.rawData()
        
        return data!
    }
    
}
