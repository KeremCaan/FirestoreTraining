//
//  PhotoSelectionVC.swift
//  NeonAcademyFirestore
//
//  Created by Kerem Caan on 11.08.2023.
//

import UIKit
import SnapKit

class PhotoSelectionVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonTapped()
    }

    
    @objc func buttonTapped() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            NotificationCenter.default.post(name: .photoChanged, object: "myObject", userInfo: ["image": image])

        }
        
        picker.dismiss(animated: true)
        self.dismiss(animated: true)

        self.navigationController?.pushViewController(TabBarController(), animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        self.dismiss(animated: true)
        self.navigationController?.pushViewController(TabBarController(), animated: true)
    }
    

}
