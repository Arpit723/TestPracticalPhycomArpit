import UIKit
import AVFoundation
import Photos
import MobileCoreServices

protocol ImagePickerDelegate: AnyObject {
    func imagePicker(_ imagePicker: ImagePicker, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType)
    func imagePicker(_ imagePicker: ImagePicker, didSelect image: UIImage)
    func cancelButtonDidClick(on imageView: ImagePicker)
    func errorSelectingImage(errorString: String)
}

class ImagePicker: NSObject {

    private weak var controller: UIImagePickerController?
    weak var delegate: ImagePickerDelegate?

    public func dismiss() { controller?.dismiss(animated: true, completion: nil) }
    
    /// Open image picker controller from view controller
    /// - Parameters:
    ///   - viewController: from which Image picker will open
    ///   - sourceType: camera or phto gallery to open
    public func present(parent viewController: UIViewController, sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = sourceType
            controller.mediaTypes = [(kUTTypeImage as String)]
            //Not including gif and quicktime images
            self.controller = controller
            DispatchQueue.main.async {
                viewController.present(controller, animated: true, completion: nil)
            }
        }
    }
}

// MARK: Get access to camera or photo library

extension ImagePicker {
    /// Opening Settings alert, from request access
    /// - Parameters:
    ///   - targetName: It is purpose string e.g. Photo gallery, access
    ///   - completion:false, will not open the Image picker controller,
    ///   if completion true then only image picker will open
   // Note: If user changed app settings, then app will be restarts
    private func showAlert(targetName: String,
                           from viewController: UIViewController,
                           completion: ((Bool) -> Void)?) {
        DispatchQueue.main.async {
            // Note: Add [weak self] in if using self in closure
//            guard let self = self else { return }
            let accessToTheString = ImagePickerStrings.accessToThe + " " + targetName
            let provideAccessToThe = ImagePickerStrings.provideAccessTo + " " + targetName

            let alertVC = UIAlertController(title: accessToTheString,
                                            message:  provideAccessToThe,
                                            preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: ImagePickerStrings.settings, style: .default, handler: { _ in
                guard   let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                        UIApplication.shared.canOpenURL(settingsUrl) else { completion?(false); return }
                // Note: If user changed app settings, then app will be restarts
                UIApplication.shared.open(settingsUrl, options: [:]) { _ in
                }
            }))
            alertVC.addAction(UIAlertAction(title: ImagePickerStrings.cancel, style: .cancel, handler: { _ in completion?(false) }))
//            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?
//                .rootViewController?.present(alertVC, animated: true, completion: nil)
            viewController.present(alertVC, animated: true, completion: nil)
        }
    }
    
    /// Request photo gallery access permission if permission granted delegate to viewcontroller,
    /// else open setting alert
    ///     /// - Parameter viewController: To pass to the settings alert, to present alert
    public func cameraAsscessRequest(from viewController: UIViewController) {
        if delegate == nil { return }
        let source = UIImagePickerController.SourceType.camera
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            delegate?.imagePicker(self, grantedAccess: true, to: source)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else { return }
                if granted {
                    self.delegate?.imagePicker(self, grantedAccess: granted, to: source)
                } else {
                    self.showAlert(targetName: ImagePickerStrings.camera, from: viewController) {
                        self.delegate?.imagePicker(self, grantedAccess: $0, to: source) }
                }
            }
        }
    }

    /// Request photo gallery access permission if permission granted delegate to viewcontroller,
    /// else open setting alert
    /// - Parameter viewController: To pass to the settings alert, to present alert
    public func photoGalleryAccessRequest(from viewController: UIViewController) {
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            let source = UIImagePickerController.SourceType.photoLibrary
            if result == .authorized {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.imagePicker(self, grantedAccess: result == .authorized, to: source)
                }
            } else {
                self.showAlert(targetName: ImagePickerStrings.photoGallery, from: viewController) {
                    self.delegate?.imagePicker(self, grantedAccess: $0, to: source) }
               }
        }
    }
}

// MARK: UINavigationControllerDelegate
extension ImagePicker: UINavigationControllerDelegate { }

// MARK: UIImagePickerControllerDelegate
extension ImagePicker: UIImagePickerControllerDelegate {

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                                   info: [UIImagePickerController.InfoKey: Any]) {
//            if info[UIImagePickerController.InfoKey.imageURL].
//        if (info[.imageURL] as? URL)?.pathExtension == "gif" {
//            delegate?.errorSelectingImage(errorString: "")
//            delegate?.cancelButtonDidClick(on: self)
//            return
//        }
        if let image = info[.editedImage] as? UIImage {
            delegate?.imagePicker(self, didSelect: image)
            return
        }

        if let image = info[.originalImage] as? UIImage {
            delegate?.imagePicker(self, didSelect: image)
        } else {
            print("Other source")
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.cancelButtonDidClick(on: self)
    }
}

enum ImagePickerStrings {
    static let accessToThe = "Access to the"
    static let provideAccessTo = "Please provide access to your"
    static let settings = "Settings"
    static let cancel = "Cancel"
    static let camera = "Camera"
    static let photoGallery = "Photo Gallery"

}
