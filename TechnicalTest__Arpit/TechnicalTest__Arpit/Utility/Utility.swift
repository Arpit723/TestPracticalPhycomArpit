//
//  Utility.swift
//  TechnicalTest__Arpit
//
//  Created by Ravi Chokshi on 27/04/24.
//

import Foundation
import UIKit
import CoreLocation

class Utility {
    
    static func showAlert(vc: UIViewController = UIApplication.getTopViewController() ?? UIViewController(),
                          title:String?, message:String?, buttons: [String] = ["Ok"],
                          buttonStyle:[UIAlertAction.Style] = [.default], completion:((_ index:Int) -> Void)? = nil) -> Void{
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for index in 0..<buttons.count {
            
            let action = UIAlertAction(title: buttons[index], style: buttonStyle[index]) {_ in
                completion?(index)
            }
            alertController.addAction(action)
        }
        
        DispatchQueue.main.async {
            vc.present(alertController, animated: true, completion: nil)
        }
    }

   static func dateFormatterForPublishedAt(dateString: String) -> String {

        //2024-04-25T13:00:00+00:00
        commonDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        commonDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = commonDateFormatter.date(from:dateString) {
            //20th Sep, 2020 08:30 PM
            commonDateFormatter.dateFormat = date.dateFormatWithSuffix()
            return commonDateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    static func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double, completion: @escaping (String) -> ()) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = pdblLatitude
            //21.228124
            let lon: Double = pdblLongitude
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
//                        print(pm.country)
//                        print(pm.locality)
//                        print(pm.subLocality)
//                        print(pm.thoroughfare)
//                        print(pm.postalCode)
//                        print(pm.subThoroughfare)
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        print(addressString)
                        completion(addressString)
                  }
            })

        }
    
}


extension UIApplication {
    class func  getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}

extension Date {

    func dateFormatWithSuffix() -> String {
        return "dd'\(self.daySuffix())' MMM, yyyy hh:mm a"
    }

    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
}


class UnderlinedLabel: UILabel {

override var text: String? {
    didSet {
        guard let text = text else { return }
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        // Add other attributes if needed
        self.attributedText = attributedText
        }
    }
}
