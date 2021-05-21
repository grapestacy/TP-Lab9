//
//  UIViewController.swift
//  BelarussianWriters
//
//  Created by Stacy Vinogradova on 29.04.21.
//

import UIKit

extension UIViewController {
    
    public static func newInstance<T: UIViewController>(of viewControllerType: T.Type) -> T {
        let storyboard = UIStoryboard(name: viewControllerType.className, bundle: nil)
        return storyboard.instantiateInitialViewController() as! T
    }
    public func changeToRootViewController() {
        UIApplication.shared.windows.first?.rootViewController = self
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

