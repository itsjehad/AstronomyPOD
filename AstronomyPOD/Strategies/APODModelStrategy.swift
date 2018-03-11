//
//  APODModelStrategy.swift
//  AstronomyPOD
//
//  Created by Jehad on 2/28/18.
//  Copyright © 2018 Sarkar. All rights reserved.
//

import Foundation
class APODModelStrategy{
    static func getMediaHandle(mediaType: String) -> MediaHandler{
        switch mediaType.lowercased() {
        case "image":
            return ImageHandler()
        case "video":
            return VideoHandler()
        case "unknown":
            return UnknownHandler()
        default:
            return UnknownHandler()
        }
    }
}
