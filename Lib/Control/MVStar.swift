//
//  MVRating.swift
//  BookShelf
//
//  Created by steve on 2021/05/24.
//

import UIKit

class MVStar: UIView {

    var image: UIImage!

    var max  = 5
    var gap  = CGFloat(0)
    var maxw = CGFloat(0)
    let subv = UIView()
    
    var rating: CGFloat = 0
    {
        didSet {
            w = maxw * (rating / CGFloat(max)) + image.w - 2
            subv.isHidden = rating == 0
        }
    }

    func load()
    {
        let w = image.w
        let h = image.h

        var x = CGFloat(0)
        var f = bounds

        f.x = w * 0.5
        f.w = f.w - w

        subv.clipsToBounds = true
        subv.autoresizingMask = .MF
        subv.frame = f

        addSubview(subv)

        for _ in 0..<max
        {
            let iv = UIImageView(image: image)
            iv.autoresizingMask = .MLT

            iv.frame = CGRect(x+1, 0, w, h)
            subv.addSubview(iv)
        
            x += w + gap
        }        

        maxw = x - gap
    }
}
