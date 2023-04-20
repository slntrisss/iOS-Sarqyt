//
//  NavigationUtil.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.04.2023.
//

import Foundation
import UIKit

class NavigationUtil{
    static func popToRootView() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            findNavigationController(viewController:
                                        UIApplication.shared.windows.filter { $0.isKeyWindow
            }.first?.rootViewController)?
                .popToRootViewController(animated: true)
        }
    }
    static func findNavigationController(viewController: UIViewController?)
    -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        if let navigationController = viewController as? UINavigationController
        {
            return navigationController
        }
        for childViewController in viewController.children {
            return findNavigationController(viewController:
                                                childViewController)
        }
        return nil
    }
}
