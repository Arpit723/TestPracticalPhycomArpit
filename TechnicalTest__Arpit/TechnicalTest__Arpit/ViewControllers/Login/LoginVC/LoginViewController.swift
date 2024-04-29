//
//  LoginViewController.swift
//  TechnicalTest__Arpit
//
//  Created by Ravi Chokshi on 27/04/24.
//

import UIKit
import FirebaseAuth
//import ProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!

    lazy var lableCountryCode = customize(UILabel()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        $0.text = "+91"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.textAlignment = .center

//        $0.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
    }
    //MARK: ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.locationManager?.startUpdatingLocation()
    }
    func setUpUI() {
        txtPhoneNumber.leftView = lableCountryCode
        txtPhoneNumber.leftViewMode = .always
    }
    //MARK: Button Click
    @IBAction func btnLoginClicked(_ sender: Any) {
        
        let valdiation = isValidate()
        
        guard valdiation.0 else {
            Utility.showAlert(title: "Error", message: valdiation.1)
            return
        }
        Loader.show()
        let phoneNumber = "+91" + (txtPhoneNumber.text ?? "")
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
               Loader.hide()
              if let error = error {
                  Utility.showAlert(vc: self, title: "Error", message: error.localizedDescription, buttons: ["OK"], buttonStyle: [.default], completion:  { index  in
                      
                  })
                return
              }
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                let loggedInUser = User(userId: "1", name: "", email: "", mobileNumber: (self.txtPhoneNumber.text ?? ""),currentLocation: ["lat": 0.0, "long": 0.0])
                let next = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                next.loggedInUser = loggedInUser
                self.navigationController?.pushViewController(next, animated: true)

          }
    }
    
    @IBAction func btnRegistrationClicked(_ sender: Any) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        next.isForRegistration = true
        self.navigationController?.pushViewController(next, animated: true)
    }
    

}

//AMRK: Valdaitions
extension  LoginViewController {
    
    func isValidate() -> (Bool, String){
        let phoneNumber = self.txtPhoneNumber.text ?? ""
        if phoneNumber.count < 10 {
            return (false, "Please enter phone number of 10 digits.")
        }
        return (true, "")
    }
}
