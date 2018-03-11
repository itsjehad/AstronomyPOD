//
//  ImageHandler.swift
//  AstronomyPOD
//
//  Created by Jehad on 2/28/18.
//  Copyright © 2018 Sarkar. All rights reserved.
//

import Foundation
class ImageHandler: MediaHandler{
    var strUrl: String = ""
    var media: Media!
    func handle(strUrl: String,completionHandler: @escaping CompletionHandler) -> Void {
        self.strUrl = strUrl
        let url = URL(string: strUrl)!
        let mediaTask = URLSession.shared.dataTask(with: url) { (mediaData, mediaResponse, mediaError) in
            if(mediaData != nil)
            {
                self.media = Media(data: mediaData!, mediaType: MediaType.image)
                completionHandler(self.media, "", true)
            }
            else{
                completionHandler(self.media!, "Media type: Image can not be downloaded", false)
            }
        }
        mediaTask.resume();
    }
}
