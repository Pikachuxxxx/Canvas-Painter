//
//  InternetConnectionManager.swift
//  Canvas Drawing
//
//  Created by phani srikar on 24/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import Foundation
import SystemConfiguration
/**
    A class to check for internet connectivity.
 */
public class InternetConnectionManager {
    public init() {}
    /**
      A function to check for the internet connection availability in swift
    
     - Returns: A boolean indication whether the device is connectied to internet or not.
    */
    public static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
