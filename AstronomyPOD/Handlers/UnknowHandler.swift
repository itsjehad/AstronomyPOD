//
//  UnknowHandler.swift
//  AstronomyPOD
//
//  Created by Jehad on 2/28/18.
//  Copyright © 2018 Sarkar. All rights reserved.
//

import Foundation
class UnknownHandler: MediaHandler{
    var strUrl: String = ""
    func handle(strUrl: String, completionHandler: @escaping CompletionHandler) -> Void {
        self.strUrl = strUrl
        //TODO: Handle Unown media
        completionHandler(Media(data: Data(), mediaType: MediaType.unknown), "Media type: Unknown can not be downloaded", false)
        Logger.log(message: "Media type not supported", event: .e)
    }
}
