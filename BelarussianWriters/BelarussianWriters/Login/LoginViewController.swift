//
//  LoginViewController.swift
//  BelarussianWriters
//
//  Created by Stacy Vinogradova on 29.04.21.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var isCreateUserSegment: UISegmentedControl!
    
    @IBOutlet weak var loginLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var repeatPasswordLabel: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    var userDefaults = UserDefaults.standard
    var usernumber = 0;
    
    static func newInstance() -> LoginViewController {
        return UIViewController.newInstance(of: LoginViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repeatPasswordLabel.isHidden = true
        
        isCreateUserSegment.setTitle("login".localized, forSegmentAt: 0)
        isCreateUserSegment.setTitle("createAcc".localized, forSegmentAt: 1)
        loginLabel.placeholder = "login".localized
        emailLabel.placeholder = "email".localized
        passwordLabel.placeholder = "password".localized
        repeatPasswordLabel.placeholder = "repeatPassword".localized
        signInButton.setTitle("signIN".localized, for: .normal)
        
        if let userNumber = userDefaults.object(forKey: "userNumber") as? Int{
            usernumber = userNumber
        } else {
            userDefaults.setValue(0, forKey: "userNumber")
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func okButtonTapped(_ sender: Any) {
        switch isCreateUserSegment.selectedSegmentIndex {
        case 1:
            createNewAccount()
        case 0:
            loginWithExistedAccount()
        default:
            break
        }
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        if let seg = sender as? UISegmentedControl {
            if seg.selectedSegmentIndex == 0 {
                repeatPasswordLabel.isHidden = true
                signInButton.setTitle("signIN".localized, for: .normal)
            } else {
                repeatPasswordLabel.isHidden = false
                signInButton.setTitle("createAcc".localized, for: .normal)
            }
            
        }
    }
    private func createNewAccount (){
        for i in 0...usernumber {
            if loginLabel.text == userDefaults.object(forKey: "login\(i)") as? String { return }
        }
        
        if (loginLabel.text != "" && emailLabel.text != "" &&
                passwordLabel.text != "" && repeatPasswordLabel.text == passwordLabel.text){
            usernumber += 1
            userDefaults.setValue(loginLabel.text, forKey: "login\(usernumber)")
            userDefaults.setValue(emailLabel.text, forKey: "email\(usernumber)")
            userDefaults.setValue(passwordLabel.text, forKey: "password\(usernumber)")
            userDefaults.setValue(usernumber, forKey: "userNumber")
            userDefaults.setValue(1, forKey: "isUserActive\(usernumber)")
            
            let WRVC =  WritersViewController.newInstance()
             WRVC.userid = usernumber
            let nav = UINavigationController(rootViewController: WRVC)
            nav.changeToRootViewController()
        }
    }
    
    private func loginWithExistedAccount(){
    
        for i in 1...usernumber {
            if let login = userDefaults.object(forKey: "login\(i)") as? String,
               let password = userDefaults.object(forKey: "password\(i)") as? String,
               loginLabel.text == login && passwordLabel.text == password {
                userDefaults.setValue(1, forKey: "isUserActive\(usernumber)")
                
                let WRVC =  WritersViewController.newInstance()
                 WRVC.userid = usernumber
                WRVC.changeToRootViewController()
                return
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

