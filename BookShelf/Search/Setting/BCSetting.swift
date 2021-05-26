//
//  BCSetting.swift
//  BookShelf
//
//  Created by steve on 2021/05/21.
//

import UIKit

class BCSetting: BViewController {

    private var _cache : BCache!
    private var _config: BConfig!

    @IBOutlet weak var slMax   : UISlider!
    @IBOutlet weak var swWrite : UISwitch!
    @IBOutlet weak var vwFiles : UIView!
    @IBOutlet weak var lbFiles : UILabel!
    @IBOutlet weak var lbImages: UILabel!
    @IBOutlet weak var lbMax   : UILabel!
    
    func setFiles()
    {
        if _cache.save == false {
            lbFiles.text = "0"
            return
        }

        lbFiles.text = "\(_cache.max) / \(_cache.files)"
    }
    
    func setImages()
    {
        lbImages.text = "\(_cache.max) / \(_cache.count)"
    }

    func enableFiles(_ enable: Bool)
    {
        vwFiles.alpha = enable ? 1 : 0.3
        vwFiles.isUserInteractionEnabled = enable
    }

    @IBAction
    func swWrite(_ sw: UISwitch)
    {
        let on = sw.isOn

        _config.cacheWrite = on

        _cache.save = on
        _cache.commitAll()
        
        enableFiles(on)
    
        setFiles()
    }
    
    @objc
    func onMax()
    {
        _cache.max = Int(slMax.value)
        _config.cacheMax = _cache.max

        setImages()
        setFiles()
    }
    
    @IBAction
    func slMax(_ sl: UISlider)
    {
        lbMax.text = String(Int(sl.value))

        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(onMax), with: nil, afterDelay: 1)
    }
    
    @IBAction
    func btClearImages(_ sender: Any)
    {
        _cache.clrImages()
        setImages()
    }
    
    @IBAction
    func btClearFiles(_ sender: Any)
    {
        _cache.clrFiles()
        setFiles()
    }
    
    @IBAction
    func btClearAll(_ sender: Any)
    {
        _cache.clrAll()

        setImages()
        setFiles()
    }
    
    @IBAction
    func btDone(_ sender: Any)
    {
        dismiss(animated: true)
    }

    override
    func viewDidLoad()
    {
        super.viewDidLoad()

        _config = __home.config
        _cache  = __home.cache
    }
    
    func loadCache()
    {
        swWrite.isOn = _cache.save
        enableFiles(_cache.save)

        setFiles()
        setImages()

        slMax.value = Float(_cache.max)
        lbMax.text  = String(_cache.max)
    }
    
    override
    func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        loadCache()
    }
}
