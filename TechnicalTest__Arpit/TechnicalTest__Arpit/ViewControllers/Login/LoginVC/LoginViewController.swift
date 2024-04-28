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
    
    func setUpUI() {
        txtPhoneNumber.leftView = lableCountryCode
        txtPhoneNumber.leftViewMode = .always
    }
    //MARK: Button Click
    @IBAction func btnLoginClicked(_ sender: Any) {
        Loader.show()
        let phoneNumber = "+91" + (txtPhoneNumber.text ?? "")
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
//                ProgressHUD.dismiss()
               Loader.hide()
              if let error = error {
                  Utility.showAlert(vc: self, title: "Error", message: error.localizedDescription, buttons: ["OK"], buttonStyle: [.default], completion:  { index  in
                      
                  })
                return
              }
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                let loggedInUser = User(userId: "1", name: "", email: "", mobileNumber: (self.txtPhoneNumber.text ?? ""))
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
