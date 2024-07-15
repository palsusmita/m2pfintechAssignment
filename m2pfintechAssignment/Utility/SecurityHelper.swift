//
//  SecurityHelper.swift
//  m2pfintechAssignment
//
//  Created by susmita on 12/07/24.
//

import UIKit

class SecurityHelper {
    static func isDeviceJailbroken() -> Bool {
        return UIDevice.current.isJailBroken
    }
}
