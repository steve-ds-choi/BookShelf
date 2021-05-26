//
//  BCNeedNet.swift
//  BookShelf
//
//  Created by steve on 2021/05/22.
//

import UIKit

class BCNeedNet: BViewController {

    override
    func viewDidLoad()
    {
        super.viewDidLoad()
        view.loadBackgroundBlur()
    }
    
    func show(_ show: Bool)
    {
        if show == false
        {
            MAnim.run {
                self.view.alpha = 0
            } end: {
                self.view.removeFromSuperview()
            }

            return
        }

        view.frame = __home.view.bounds
        __home.view.addSubview(view)

        view.alpha = 0
        MAnim.run {
            self.view.alpha = 1
        }
    }
}
