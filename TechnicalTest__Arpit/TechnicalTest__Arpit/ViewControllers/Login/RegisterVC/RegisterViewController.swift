//
//  RegisterViewController.swift
//  TechnicalTest__Arpit
//
//  Created by Ravi Chokshi on 27/04/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterViewController: UIViewController {

    @IBOutlet weak var btnSubmit: UIButton!

    @IBOutlet weak var btnSignOut: UIButton!

    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var lblCurrentLocation: UILabel!
    @IBOutlet weak var imgvProfilePic: UIImageView!
    private lazy var imagePicker: ImagePicker = {
       let imagePicker = ImagePicker()
       return imagePicker
   }()
    var isComingFromList = false
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
    @IBOutlet weak var btnImage: UIButton!
    
    var isForRegistration = false
    var loggedInUserInfo: [String: Any]?
    var autoIdToUpdateUser: String?
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.locationManager?.startUpdatingLocation()
        imagePicker.delegate = self
        setUpUI()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if isForRegistration {
            let dict = ["liveLocation": ["lat" :appDelegate.currentLocation?.coordinate.latitude ?? 0.0, "long": appDelegate.currentLocation?.coordinate.longitude ?? 0.0]]
                showCurrentLocationString(dict: dict)
        } else if isComingFromList {
            
            self.btnImage.isEnabled = false
            self.txtPhoneNumber.isEnabled = false
            self.txtName.isEnabled = false
            self.txtEmail.isEnabled = false
            self.updateUI()
            self.loadImage()
            btnSubmit.isHidden = true
            btnSignOut.isHidden = true
        }else {
            self.txtPhoneNumber.isEnabled = false
            let phoneNumber = UserDefaults.standard.string(forKey: UserDefaultKeys.loggedInPhoneNumber.rawValue)
            self.loadUserData(phoneNumber: phoneNumber ?? "")
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK: UI Methods
    func setUpUI() {
        txtPhoneNumber.leftView = lableCountryCode
        txtPhoneNumber.leftViewMode = .always
        
        if !isForRegistration {
            self.imgvProfilePic.layer.cornerRadius = self.imgvProfilePic.frame.size.width/2.0
            self.imgvProfilePic.layer.masksToBounds = true
        }
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
                        self.loadImage()
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
            showCurrentLocationString(dict: self.loggedInUserInfo)
    }
    
    func showCurrentLocationString(dict: [String: Any]? = nil) {
        self.lblCurrentLocation.isHidden = true
            if  let locationCoordinates = dict?["liveLocation"] as? [String: Double], let lat = locationCoordinates["lat"], let long = locationCoordinates["long"] {
               Utility.getAddressFromLatLon(pdblLatitude: lat, withLongitude: long, completion: { addressString in
                   if addressString.count > 0 {
                       self.lblCurrentLocation.text = "Location:\n \(addressString)"
                       self.lblCurrentLocation.isHidden = false
                   }
               })
            }
    }

    //MARK: button clicks
    @IBAction func btnSubmitClicked(_ sender: Any) {
            // Step 1: Add +91 country code by default
        let valdiation = isValidate()
        
        guard valdiation.0 else {
            Utility.showAlert(title: "Error", message: valdiation.1)
            return
        }
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
                    
                    let loggedInUser = User(userId: "1", name: (self.txtName.text ?? ""), email: (self.txtEmail.text ?? ""), mobileNumber: (self.txtPhoneNumber.text ?? ""),currentLocation: ["lat":0.0, "long":0.0])
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                    next.isCameFromRegister = true
                    next.loggedInUser = loggedInUser
                    self.navigationController?.pushViewController(next, animated: true)
                    
                }
        } else {
            let ref = Database.database().reference()
            ref.child("users").child("\(self.autoIdToUpdateUser ?? "")").updateChildValues(["name": txtName.text ?? ""])
            ref.child("users").child("\(self.autoIdToUpdateUser ?? "")").updateChildValues(["email": txtEmail.text ?? ""])
            ref.child("users").child("\(self.autoIdToUpdateUser ?? "")").updateChildValues(["liveLocation": ["lat" :appDelegate.currentLocation?.coordinate.latitude ?? 0.0, "long": appDelegate.currentLocation?.coordinate.longitude ?? 0.0]])

            Utility.showAlert(title: "Success", message: "Profile updated.")
            
            self.uploadImage()
 
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
    @IBAction func btnProfilePicClicked(_ sender: Any) {
        self.showActionSheet()
    }


}

//MARK: Valdiations

extension  RegisterViewController {
    
    func isValidate() -> (Bool, String){

        let name = self.txtName.text ?? ""
        if name.count == 0 {
            return (false, "Please enter your name.")
        }

        let email = self.txtEmail.text ?? ""
        if email.count == 0 {
            return (false, "Please enter your email.")
        } else if !Utility.isValidEmail(email) {
            return (false, "Please enter valid email.")
        }

        let phoneNumber = self.txtPhoneNumber.text ?? ""
        if phoneNumber.count < 10 {
            return (false, "Please enter phone number of 10 digits.")
        }
        
        return (true, "")
    }
}

//MARK: Upload Image
extension RegisterViewController {
    
    func loadImage() {
        if let imageUrl = self.loggedInUserInfo?["imageUrl"] as? String {
            //              if imageURL.hasPrefix("gs://") {
            Storage.storage().reference(forURL: imageUrl).getData(maxSize: INT64_MAX) {(data, error) in
                if let error = error {
                    print("Error downloading: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    print("Image \(imageUrl)")
                        self.imgvProfilePic.image = UIImage(data: data ?? Data())
                        self.view.layoutIfNeeded()
            }
            }
        }
    }
    
    func uploadImage() {
        Loader.show()
        let uid = Auth.auth().currentUser?.uid ?? ""
        let storageRef = Storage.storage().reference()
        let userPhone = self.txtPhoneNumber.text ?? ""
        let filePath = "\(uid)/\(userPhone).jpg"
        let imageData = imgvProfilePic.image?.jpegData(compressionQuality: 0.8)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"


        storageRef.child(filePath)
                .putData(imageData!, metadata: metadata) { [weak self] (metadata, error) in
                    Loader.hide()
                  if let error = error {
                    print("Error uploading: \(error)")
                      Utility.showAlert(title: "Error", message: "Error uploading image.")

                    return
                  }
                    let ref = Database.database().reference()
                    ref.child("users").child("\(self?.autoIdToUpdateUser ?? "")").updateChildValues(["imageUrl": storageRef.child((metadata?.path ?? "")).description])
                    Utility.showAlert(title: "Success", message: "Image uplaoded successfully.")
              }
            }
}

//MARK: Image picker
extension RegisterViewController {
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: UIAlertController.Style.actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Camera",
                                            style: UIAlertAction.Style.default,
                                            handler: { (_: UIAlertAction!) -> Void in
            self.cameraButtonTapped(UIButton())
        }))

        actionSheet.addAction(UIAlertAction(title: "Gallery",
                                            style: UIAlertAction.Style.default,
                                            handler: { (_: UIAlertAction!) -> Void in
            self.photoButtonTapped(UIButton())
        }))

        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: UIAlertAction.Style.cancel,
                                            handler: nil))

        self.present(actionSheet, animated: true, completion: nil)

    }
    @objc func photoButtonTapped(_ sender: UIButton) { imagePicker.photoGalleryAccessRequest(from: self) }
    @objc func cameraButtonTapped(_ sender: UIButton) { imagePicker.cameraAsscessRequest(from: self) }

    
    
}

extension RegisterViewController: ImagePickerDelegate {

    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage) {
        print(#function)
//        viewModel.selectedProfileImage = image
//        viewModel.isAnythingChanged = true
//        tableViewForm.reloadData()
        imgvProfilePic.image = image
        imagePicker.dismiss()
    }

    func cancelButtonDidClick(on imageView: ImagePicker) { imagePicker.dismiss() }
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
    func errorSelectingImage(errorString: String) {
        //Toast.shared.show(title: "Failed",
          //         message: errorString,
            //       state: .failure)
        Utility.showAlert(title: "Error", message: errorString)
    }
}

extension RegisterViewController: LocationUpdateDelegate {
    func locationUpdated() {
        let dict = ["liveLocation": ["lat" :appDelegate.currentLocation?.coordinate.latitude ?? 0.0, "long": appDelegate.currentLocation?.coordinate.longitude ?? 0.0]]
        showCurrentLocationString(dict: dict)
    }
}
