//
//  MessageResponse.swift
//  HealthApp
//
//  Created by UHS on 23/12/2017.
//  Copyright © 2017 Apkia. All rights reserved.
//

import Foundation

struct MessageResponse {
    // MARK: Variables
    var id = String()
    var sender_name = String()
    var body = String()
    
    init(dictionary : [[String:Any]]) {
        for result in dictionary {
            id = result["id"] as! String
            sender_name = result["sender_name"] as! String
            body = result["body"] as! String
        }
    }
}

struct AppointmentResponse {
    // MARK: Variables
    var id = String()
    var doctor_name = String()
    var start_at = String()
    
    init(dictionary : [[String:Any]]) {
        for result in dictionary {
            id = result["id"] as! String
            doctor_name = result["doctor_name"] as! String
            start_at = result["start_at"] as! String
        }
    }
}
