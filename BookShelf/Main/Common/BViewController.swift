//
//  BViewController.swift
//  BookShelf
//
//  Created by steve on 2021/05/21.
//

import UIKit

var __home : BCHome!

class BViewController: UIViewController {

    @IBOutlet weak var vwHead: UIView!
    @IBOutlet weak var vwBody: UIView!

    var text = ""

    func layoutNotch()
    {
        if __isRound == true { return }

        vwHead?.layout(oh: -30)
        vwBody?.layout(oh: 30, oy: -30)
    }
    
    override
    func viewDidLoad()
    {
        super.viewDidLoad()
        layoutNotch()
    }

    func navPush(_ vc: BViewController, anim: Bool = true)
    {
        navigationController?.pushViewController(vc, animated: anim)
    }

    func navPop(_ anim: Bool = true)
    {
        navigationController?.popViewController(animated: anim)
    }

    func navDetail(_ vc: BViewController)
    {
        navigationController?.showDetailViewController(vc, sender:nil)
    }

    func navRoot(_ vc: BViewController)
    {
        let navc = UINavigationController(rootViewController: self)

        navc.isNavigationBarHidden = true
        navc.view.frame = vc.view.bounds
        navc.view.autoresizingMask = .MA

        vc.view.insertSubview(navc.view, at:0)
        vc.addChild(navc)
    }
}
