//
//  OTPViewController.swift
//  TechnicalTest__Arpit
//
//  Created by Ravi Chokshi on 27/04/24.
//

import UIKit
import SVPinView
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import FirebaseDatabase


class OTPViewController: UIViewController {
    
    @IBOutlet weak var pinView: SVPinView!
    var isCameFromRegister = false
    var loggedInUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupOtpView()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func setupOtpView() {
        
        pinView.pinLength = 6
        //        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 15.0
        pinView.textColor = UIColor.black
        //        pinView.shouldSecureText = true
        pinView.style = .box
        pinView.shouldSecureText = false
        
        pinView.borderLineColor = UIColor.blue.withAlphaComponent(0.4)
        pinView.activeBorderLineColor = UIColor.blue
        pinView.borderLineThickness = 1
        pinView.activeBorderLineThickness = 1
        
        //        pinView.font = FontBook.plexSerifRegular.of(size: 14.0)
        
        pinView.keyboardType = .numberPad
        
        pinView.keyboardAppearance = .default
        //        pinView.pinIinputAccessoryView = UIView()
        pinView.placeholder = "------"
        pinView.becomeFirstResponderAtIndex = 0
        
        pinView.fieldBackgroundColor = UIColor.white
        pinView.fieldCornerRadius = 15.0
        pinView.activeFieldCornerRadius = 15.0
        
        pinView.didFinishCallback = { [weak self] pin in
            print("didFinishCallback")
            guard let self = self else {
                return
            }
            //MARK: - Verify OTP Code
            ////            let (isCodeExpiredVar, _ ) = self?.isOTPExpired() ?? (true, 0)
            //            if isCodeExpiredVar {
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            Loader.show()
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID ?? "",
                verificationCode: pin
            )
            self.firebaseSignIn(credential: credential)
            if "123456" == pin {
            } else {
                //                self?.pinView.shake()
                self.pinView.clearPin(completionHandler: nil)
                self.pinView.becomeFirstResponder()
            }
        }
        pinView.didChangeCallback = { pin in
            //            submitButton.isEnabled = isValid(pin)
            print("didChangeCallback \(self.pinView.getPin())")
        }
        
    }
    
    func firebaseSignIn(credential: PhoneAuthCredential)   {
        Auth.auth().signIn(with: credential  as AuthCredential) { authResult, error in
            let isMFAEnabled = false
            Loader.hide()
            if let error = error {
                Utility.showAlert(vc: self, title: "Error", message: "Invalid OTP.", buttons: ["OK"], buttonStyle: [.default], completion: { index in
                    
                })
                
            } else {
                var ref: DatabaseReference!
                ref = Database.database().reference()
                
                if self.isCameFromRegister {
                    let user = Auth.auth().currentUser
                    var userData = [String: String]()
                    userData["name"] = self.loggedInUser?.name ?? ""
                    userData["email"] = self.loggedInUser?.email ?? ""
                    userData["mobileNumber"] = self.loggedInUser?.mobileNumber ?? ""
                    ref.child("users").childByAutoId().setValue(userData, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            print("error adding user \(error?.localizedDescription ?? "")")
                            return
                        }
                        print("User added successfully")
                    })
                    UserDefaults.standard.setValue((self.loggedInUser?.mobileNumber ?? ""), forKey: UserDefaultKeys.loggedInPhoneNumber.rawValue)
                    self.goToHomeScreen()
                } else {
                    ref.observeSingleEvent(of: .value, with: { snapshot in
                        print("snapshot \(snapshot)")
                        var isUserFound = false
                        for rest in snapshot.children.allObjects as! [DataSnapshot] {
                            guard let restDict = rest.value as? [String: Any] else { continue }
                            for key in restDict.keys {
                                let mobile = (restDict[key] as? [String: Any])?["mobileNumber"] as? String ?? ""
                                let enteredMobileNo = self.loggedInUser?.mobileNumber ?? ""
                                if mobile == enteredMobileNo {
                                    UserDefaults.standard.setValue((self.loggedInUser?.mobileNumber ?? ""), forKey: UserDefaultKeys.loggedInPhoneNumber.rawValue)
                                    self.goToHomeScreen()
                                    isUserFound = true
                                    break
                                } else {
                                    continue
                                }
                            }
                            if !isUserFound {
                                Utility.showAlert(title: "Invalid phone number.", message: "Soory, no user is found with entered phone number.",completion: { index in
                                    self.navigationController?.popViewController(animated: true)
                                })
                            }

                        }
                    })
                    
                                           
                }
                
                return
            }
            // ...
            return
        }
        // User is signed in
        // ...
        print("User is signed in")
        
    }
    
    func goToHomeScreen() {
        UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.isUserLoggedIn.rawValue)
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
    }
}
