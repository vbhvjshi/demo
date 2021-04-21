//
//  APIHandler.swift
//  DemoApp
//
//  Created by VAIBHAV JOSHI on 21/04/21.
//

import Foundation
import UIKit
import Alamofire


internal let shared: ApiHandler = {
    return ApiHandler()
}()

class ApiHandler {
 
    func sendGetRequest(url: String, completionHandler: @escaping ( _ response : [String : AnyObject]?, _ statusCode: Int?, _ error: Error?) -> Void) {
        let semaphore = DispatchSemaphore (value: 0)

        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response  as? HTTPURLResponse {
                guard let responseData = data else {
                    print(String(describing: error))
                    return
                }
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) as? [String: AnyObject]
                    print_debug(object: jsonObject)
                    completionHandler(jsonObject,httpResponse.statusCode, error)
                } catch let error {
                    completionHandler(nil, httpResponse.statusCode, error)
                    return
                }
            }
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    
    func getRequest(url : String, completionHandler: @escaping ( _ response : [String : AnyObject], _ data: Data?, _ error:Error?) -> Void)  {
        
        Alamofire.request(url,method:.get)
            .responseJSON(completionHandler: { response in
                
                //        Alamofire.request(url,method:.get,encoding:URLEncoding.httpBody)
                //            .responseJSON(completionHandler: { response in
                
                //
                //                debugPrint(response)
                //
                if((response.result.value) != nil) {
                    
                    
                    
                    // 2. now pass your variable / result to completion handler
                    completionHandler(response.result.value as! [String:AnyObject], response.data, nil)
                    
                    
                } else {
                    completionHandler([:],nil,response.error)
                }
            })
        
        
    }
    
}


func print_debug <T> (object: T) {
    print(object)
}
