//
//  BCBrowser.swift
//  BookShelf
//
//  Created by steve on 2021/05/21.
//

import UIKit

class BCBrowser: BViewController {

    private var _shelf   : BShelf!
    private let _info    = BCInformation()
    private var _setting = BCSetting()
    private var _list    = [BItem]()

    @IBOutlet weak var lbTitle:   UILabel!
    @IBOutlet weak var tfSearch:  UITextField!
    @IBOutlet weak var btCancel:  UIButton!

    @IBOutlet weak var tvBrowser: UITableView!
    @IBOutlet weak var pvSerach:  UIProgressView!

    @IBOutlet weak var vwLoading: UIView!
    @IBOutlet weak var aiLoading: UIActivityIndicatorView!

    @IBAction
    func btSetting(_ sender: Any)
    {
        navDetail(_setting)
    }

    func loadShelf()
    {
        _shelf = __home.shelf
        _shelf.delegate = self
    }

    func loadBrowser()
    {
        tvBrowser.contentInset = UIEdgeInsets(top:0, left:0, bottom:300, right:0)
    }

    override
    func viewDidLoad()
    {
        super.viewDidLoad()

        loadBrowser()
        loadShelf()
    }

    func activeSearch(_ act: Bool, _ anim: Bool = true)
    {
        let sh = lbTitle.h  + 5
        let bw = btCancel.w + 10

        func active()
        {
            if vwHead.tag == act.intValue { return }
            vwHead.tag = act.intValue

            if act == true
            {
                vwHead.layout(oh: -sh)
                vwBody.layout(oh: sh, oy: -sh)
                tfSearch.layout(ow: -bw)

                lbTitle.alpha  = 0
                btCancel.alpha = 1
            }
            else
            {
                vwHead.layout(oh: sh)
                vwBody.layout(oh: -sh, oy: sh)
                tfSearch.layout(ow: bw)

                lbTitle.alpha  = 1
                btCancel.alpha = 0
            }
        }

        MAnim.run(animate: anim, active)
    }

    func showLoading(_ show: Bool)
    {
        if show == true
        {
            aiLoading.startAnimating()
            vwLoading.isHidden = false
            return
        }

        aiLoading.stopAnimating()
        vwLoading.isHidden = true
    }
}

extension BCBrowser: UITextFieldDelegate
{
    @IBAction
    func btCancel(_ sender: Any)
    {
        activeSearch(false, true)

        NSObject.cancelPreviousPerformRequests(withTarget: self)

        tfSearch.resignFirstResponder()
        tfSearch.text = nil

        _shelf.rqList(text: "")
        pvSerach.progress = 0
    }

    @objc
    func search()
    {
        pvSerach.progress = 0
        _shelf.rqList(text: tfSearch.text!)

        showLoading(true)
    }

    @IBAction
    func tfSearch(_ sender: Any)
    {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(search), with: nil, afterDelay: 1)
    }

    func textFieldShouldBeginEditing(_ tf: UITextField) -> Bool // return
    {
        activeSearch(true)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        tfSearch.resignFirstResponder()

        if tfSearch.text?.count == 0
        {
            activeSearch(false, true)
        }

        return true
    }
}

extension BCBrowser: UITableViewDelegate, UITableViewDataSource, IBShelfList
{
    func shelf(_ shelf: BShelf, onBody item: BItem)  {}
    func shelf(_ shelf: BShelf, onImage item: BItem) {}

    func shelf(_ shelf: BShelf, onListError text: String?)
    {
        if text == nil { showLoading(false) }

        let text = text == nil ? "NetError - has occurred." : "NetError - Try again."
        __home.toast(text)
    }
    
    func shelf(_ shelf: BShelf, onList list: [BItem])
    {
        showLoading(false)

        _list = list

        if shelf.total > 0
        {
            pvSerach.progress = Float(list.count) / Float(shelf.total)
        }

        tvBrowser.reloadData()
    }
    
    func tableView(_ tv: UITableView, numberOfRowsInSection s: Int) -> Int
    {
        let count = _list.count
        tv.isHidden = count == 0

        return count
    }
    
    func tableView(_ tv: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell
    {
        let cell = tv.dequeueReusableCell("BCBCell") as! BCBCell
        let item = _list[ip.r]

        cell.load(item, tfSearch.text!)

        return cell
    }
    
    func tableView(_ tv: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt ip: IndexPath)
    {
        let cell = cell as! BCBCell
        cell.unload()
    }

    func tableView(_ tv: UITableView, didSelectRowAt ip: IndexPath)
    {
        let item = _list[ip.r]

        _info.load(item)
        navPush(_info)

        tv.deselectRow(at: ip, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        tfSearch.resignFirstResponder()
    }
}
