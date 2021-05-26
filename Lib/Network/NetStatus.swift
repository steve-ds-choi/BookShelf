//
//  NetStatus.swift
//  BookShelf
//
//  Created by steve on 2021/05/22.
//

import UIKit
import Network

@available(iOS 12.0, *)
class NetStatus: NSObject {

    static let shared = NetStatus()

    private let netWifi = NWPathMonitor(requiredInterfaceType: .wifi)
    private let netCell = NWPathMonitor(requiredInterfaceType: .cellular)

    private var onChange : blk0_t!

    private var wifiStatus = NWPath.Status.requiresConnection
    private var cellStatus = NWPath.Status.requiresConnection

    private var status = false

    var isConnected: Bool { wifiStatus == .satisfied || cellStatus == .satisfied }
    var isConnectedOnCellular: Bool { cellStatus == .satisfied }

    private
    func onChanged()
    {
        if onChange == nil { return }

        if status == isConnected { return }
        status = isConnected

        onChange()
    }
    
    func looking(_ fn: @escaping blk0_t) {
        
        onChange = fn

        netWifi.pathUpdateHandler = { [weak self] path in
            self?.wifiStatus = path.status
            _ASYNC { self?.onChanged() }
        }

        netCell.pathUpdateHandler = { [weak self] path in
            self?.cellStatus = path.status
            _ASYNC { self?.onChanged() }
        }

        let queue = DispatchQueue(label: "NetLooking")
        netWifi.start(queue: queue)
        netCell.start(queue: queue)
    }

    func cancel() {
        netWifi.cancel()
        netCell.cancel()
    }
    
    class func isConnectedToNetwork() -> Bool {
        return shared.isConnected
    }
}
