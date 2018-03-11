//
//  UILableExtensions.swift
//  AstronomyPOD
//
//  Created by Jehad on 2/28/18.
//  Copyright © 2018 Sarkar. All rights reserved.
//

import UIKit

extension UILabel {
    func numberOfVisibleLines(newRect: CGRect)-> Int {
        let textSize = CGSize(width: CGFloat(newRect.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}
