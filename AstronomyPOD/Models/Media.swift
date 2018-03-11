//
//  Media.swift
//  AstronomyPOD
//
//  Created by Jehad on 3/1/18.
//  Copyright © 2018 Sarkar. All rights reserved.
//

import Foundation

public enum MediaType{
    case image
    case video
    case unknown
}

struct Media {
    var data: Data
    var mediaType: MediaType
    
    init(data: Data, mediaType: MediaType) {
        self.data = data
        self.mediaType = mediaType
    }
    init(){
        data = Data()
        self.mediaType = MediaType.unknown
    }
    func getMediaType() -> MediaType{
        return mediaType
    }
    func getMediaData() -> Data{
        return data
    }
}
