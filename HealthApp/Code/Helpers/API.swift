//
//  API.swift
//  HealthApp
//
//  Created by UHS on 23/12/2017.
//  Copyright © 2017 Apkia. All rights reserved.
//

import Foundation

class API {
    
    // MARK: - API (Get Method)
    /**
     Passes the URL to the server for data.
     - parameter urlString: urlString for the API
     - returns:  JSON Object of type Any.
     */
    class internal func fetchDatafromURLInBackground(urlString: String, completion: @escaping (_ JSONObject: Any?, _ error: NSError?) ->()) {
        
        let url: URL = URL.init(string: urlString)!
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url), completionHandler: {(data, response, error) -> Void in
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                completion(jsonObj, nil)
            }
        }).resume()
    }
}


