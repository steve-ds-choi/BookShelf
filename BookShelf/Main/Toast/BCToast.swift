//
//  BCToast.swift
//  BookShelf
//
//  Created by steve on 2021/05/25.
//

import UIKit

class BCToast: BViewController {

    @IBOutlet weak var lbText: UILabel!

    override
    func viewDidLoad()
    {
        super.viewDidLoad()

        view.loadBackgroundBlur(.light)
        view.cornerRadius = 10
    }
    
    func pop(_ y: CGFloat, _ text: String)
    {
        let home = __home.view!

        let v = view!
        var f = v.frame

        f.w = home.w - 40
        f.x = (home.w - f.w) * 0.5
        f.y = y

        v.frame = f
        lbText.text = text

        home.addSubview(v)

        MAnim.run {
            v.alpha = 1
        }

        MAnim.delay = 2
        MAnim.run {
            v.alpha = 0
        } end: {
            v.removeFromSuperview()
        }
    }

    static
    func show(_ y: CGFloat, _ text: String)
    {
        let toast = BCToast()
        toast.pop(y, text)
    }
}
