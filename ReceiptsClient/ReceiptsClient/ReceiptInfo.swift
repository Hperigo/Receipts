//
//  ReceiptInfo.swift
//  ReceiptsClient
//
//  Created by Henrique on 5/12/17.
//  Copyright © 2017 Henrique. All rights reserved.
//

import Foundation

class ReceiptInfo{
    
    var uuid : String?
    var name : String?
    var value : String?
    
    var labels : [String] = []
    
    var date : Date?
    var paid : Bool?
    
    func toJson() -> Data{
        
        let jsonObject: [String: String]  =
            [
                "uuid": uuid!,
                "name": name!,
                "value": value!,
                "date": (date?.description)!,
                "paid": (paid?.description)!,
                "labels": labels.description
            ]
        
        let valid = JSONSerialization.isValidJSONObject(jsonObject) // true

        if(valid == false){
            NSLog("NOT valid JSON")
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        
        return jsonData!
    }
    
}
