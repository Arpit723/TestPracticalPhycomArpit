//
//  RegisterViewController.swift
//  TechnicalTest__Arpit
//
//  Created by Ravi Chokshi on 27/04/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    lazy var lableCountryCode = customize(UILabel()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        $0.text = "+91"
        $0.textColor = .black
        $0.textAlignment = .center
//        $0.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
    }
    
    var isForRegistration = false
    var loggedInUserInfo: [String: Any]?
    var autoIdToUpdateUser: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        if isForRegistration {
            
        } else {
            self.txtPhoneNumber.isEnabled = false
            let phoneNumber = UserDefaults.standard.string(forKey: UserDefaultKeys.loggedInPhoneNumber.rawValue)
            self.loadUserData(phoneNumber: phoneNumber ?? "")
        }
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        txtPhoneNumber.leftView = lableCountryCode
        txtPhoneNumber.leftViewMode = .always
    }
    
    func loadUserData(phoneNumber: String) {
        Loader.show()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            Loader.hide()
            print("snapshot \(snapshot)")
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let restDict = rest.value as? [String: Any] else { continue }
                for key in restDict.keys {
                    let mobile = (restDict[key] as? [String: Any])?["mobileNumber"] as? String ?? ""
                    let enteredMobileNo = phoneNumber
                    if mobile == enteredMobileNo {
                        self.autoIdToUpdateUser = key
                        self.loggedInUserInfo = restDict[key] as? [String: Any]
                        self.updateUI()
                        break
                    } else {
                        continue
                    }
                }
            }
        })

    }
    
    func updateUI() {
            self.txtPhoneNumber.text = self.loggedInUserInfo?["mobileNumber"] as? String ?? ""
            self.txtName.text = self.loggedInUserInfo?["name"] as? String ?? ""
            self.txtEmail.text = self.loggedInUserInfo?["email"] as? String ?? ""
    }

    @IBAction func btnSubmitClicked(_ sender: Any) {
            // Step 1: Add +91 country code by default
        
        if isForRegistration {
            Loader.show()
            let phoneNumber = "+91" + (txtPhoneNumber.text ?? "")
            PhoneAuthProvider.provider()
                .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                    Loader.hide()
                    guard  error == nil else {
                        Utility.showAlert(vc: self, title: "Error", message: error?.localizedDescription ?? "", buttons: ["OK"], buttonStyle: [.default], completion:  { index  in
                        })
                        return
                    }
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    
                    let loggedInUser = User(userId: "1", name: (self.txtName.text ?? ""), email: (self.txtEmail.text ?? ""), mobileNumber: (self.txtPhoneNumber.text ?? ""))
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                    next.isCameFromRegister = true
                    next.loggedInUser = loggedInUser
                    self.navigationController?.pushViewController(next, animated: true)
                    
                }
        } else {
            let ref = Database.database().reference()
            ref.child("users").child("\(self.autoIdToUpdateUser ?? "")").updateChildValues(["name": txtName.text ?? ""])
            ref.child("users").child("\(self.autoIdToUpdateUser ?? "")").updateChildValues(["email": txtEmail.text ?? ""])

            Utility.showAlert(title: "Success", message: "Profile updated.")
 
        }
    }
    
    @IBAction func btnSignOutClicked(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        UserDefaults.standard.setValue(false, forKey: UserDefaultKeys.isUserLoggedIn.rawValue)
        UserDefaults.standard.setValue("", forKey: UserDefaultKeys.loggedInPhoneNumber.rawValue)

        if self.tabBarController?.presentingViewController != nil {
            self.dismiss(animated: true)
        } else {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "LoginNavController") as! UINavigationController
            appDelegate.window?.rootViewController = next
      
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
