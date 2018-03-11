//
//  VideoHandler.swift
//  AstronomyPOD
//
//  Created by Jehad on 2/28/18.
//  Copyright © 2018 Sarkar. All rights reserved.
//

import Foundation
//TODO: Will have to modify this class to handle Video media.
class VideoHandler: MediaHandler{
    var strUrl: String = ""
    func handle(strUrl: String,completionHandler: @escaping CompletionHandler) -> Void {
        self.strUrl = strUrl
        //TODO: Handle Video media
        completionHandler(Media(data: Data(), mediaType: MediaType.video), "Media type: Video can not be downloaded", false)
        Logger.log(message: "Not yet implemented", event: .e)
    }
}
