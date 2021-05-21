//
//  ViewController.swift
//  BelarussianWriters
//
//  Created by Stacy Vinogradova on 29.04.21.
//

import UIKit


class ViewController: UIViewController {
    
    var userDefaults = UserDefaults.standard
    var usernumber = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userNumber = userDefaults.object(forKey: "userNumber") as? Int{
            usernumber = userNumber
        } else {
            userDefaults.setValue(0, forKey: "userNumber")
        }
        
        if let isUserActive = userDefaults.object(forKey: "isUserActive\(usernumber)") as? Int {
            if isUserActive == 0 {
            LoginViewController.newInstance().changeToRootViewController()
            } else {
               let WRVC =  WritersViewController.newInstance()
                WRVC.userid = usernumber
                let nav = UINavigationController(rootViewController: WRVC)
                nav.changeToRootViewController()
            }
        } else {
            LoginViewController.newInstance().changeToRootViewController()
        }
    }


}

