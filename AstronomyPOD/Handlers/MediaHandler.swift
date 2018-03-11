//
//  MediaHandler.swift
//  AstronomyPOD
//
//  Created by Jehad on 2/28/18.
//  Copyright © 2018 Sarkar. All rights reserved.
//

import Foundation
protocol MediaHandler {
    typealias CompletionHandler = (_ media:Media, _ error:String, _ success: Bool) -> Void
    func handle(strUrl: String, completionHandler: @escaping CompletionHandler) -> Void
}
