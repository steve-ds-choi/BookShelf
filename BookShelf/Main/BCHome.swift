//
//  BCHome.swift
//  BookShelf
//
//  Created by steve on 2021/05/21.
//

import UIKit

class BCHome: BViewController {

    var netConnected = false
    var needNet : BCNeedNet!
    let config  = BConfig()

    let shelf   = BShelf()
    let cache   = BCache()

    func onChangeNetwork(_ conneted: Bool)
    {
        netConnected = conneted
        needNet?.show(conneted == false)
    }

    func netLooking()
    {
        if #available(iOS 12.0, *) {
            let nl = NetStatus.shared
            nl.looking {
                self.onChangeNetwork(nl.isConnected)
            }
        }
    }

    override
    func viewDidLoad()
    {
        __home = self

        loadHelper()

        loadConfig()
        loadCache()
        loadShelf()

        loadBrowser()

        netLooking()

        super.viewDidLoad()
    }

    override
    func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        needNet = BCNeedNet()
        onChangeNetwork(netConnected)
    }

    func loadConfig()
    {
        config.path = "~/Library/Config".expandingTildeInPath
        config.load()
    }

    func loadCache()
    {
        cache.max  = config.cacheMax
        cache.save = config.cacheWrite

        cache.path = "~/Library/Cache".expandingTildeInPath
        cache.load()
    }

    func loadShelf()
    {
        shelf.load(cache)
    }

    func loadBrowser()
    {
        let root = BCBrowser()
        root.navRoot(self)
    }

    func toast(_ text: String)
    {
        BCToast.show(110, text)       
    }
}
