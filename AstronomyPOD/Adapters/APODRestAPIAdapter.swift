//
//  APODRestAPIAdapter.swift
//  AstronomyPOD
//
//  Created by Jehad on 2/28/18.
//  Copyright © 2018 Sarkar. All rights reserved.
//

import Foundation

class APODRestAPIAdapter{
    typealias CompletionHandler = (_ apodModel:APODModel, _ error:String, _ success: Bool) -> Void
    var strUrl: String
    init(strUrl: String) {
        self.strUrl = strUrl
    }
    
    func download(completionHandler: @escaping CompletionHandler) {
        var apodModel: APODModel!
        let url = URL(string: self.strUrl)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            let jsonDecoder = JSONDecoder();
            do{
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode{
                    case 200, 202:
                        apodModel = try jsonDecoder.decode(APODModel.self, from: data!)
                        completionHandler(apodModel, "", true)
                    default:
                        completionHandler(apodModel, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode), false)
                    }
                }
            }
            catch {
                
            }
        }
        task.resume()
    }
    
    
}
