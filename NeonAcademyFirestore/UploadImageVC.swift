//
//  UploadImageVC.swift
//  NeonAcademyFirestore
//
//  Created by Kerem Caan on 11.08.2023.
//

import UIKit
import SnapKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UploadImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let defaults = UserDefaults.standard
    private let storage = Storage.storage().reference()
    let feedVC = FeedVC()
    var usersArr: [String] = []
    var commentsArr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonTapped()
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String,
        let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
        }
        
        
    }

    
    @objc func buttonTapped() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        guard let imageData = image.pngData() else {
            return
        }
        
        let path = "images/\(UUID().uuidString).png"
        storage.child(path).putData(imageData) { _, error in
            guard error == nil else {
                print("failed to upload.")
                return
            }
            
        let db = Firestore.firestore()
        let userEmail = String((Auth.auth().currentUser?.email)!)
        db.collection("images").document().setData(["url": path,
                                                        "username": userEmail,
                                                    "users": self.usersArr,
                                                    "comment": self.commentsArr]) { error in
                if error == nil {
                    DispatchQueue.main.async {
                        self.retrievePhotos()
                    }
                }
            }
            
            picker.dismiss(animated: true)
            self.navigationController?.pushViewController(FeedVC(), animated: true)
            
        }

        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        self.navigationController?.pushViewController(FeedVC(), animated: true)
    }
    
    
    func retrievePhotos() {
        let db = Firestore.firestore()
        
        db.collection("images").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let nameUser = document.data()["username"]
                    DispatchQueue.main.async{
                        NotificationCenter.default.post(name: .nameChanged, object: "myObject",userInfo: ["username": nameUser!])
                    }
                }
            }
        }
        
        
        db.collection("images").getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                
                var paths = [String]()
                
                for doc in snapshot!.documents {
                    
                    paths.append(doc["url"] as! String)
                    
                }
                
                for path in paths {
                    let storageRef = Storage.storage().reference()
                    let fileRef = self.storage.child(path)
                    
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if error == nil && data != nil {
                            
                          let image = UIImage(data: data!)
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: .feedChanged, object: "myObject",userInfo: ["feed": image!])
                                    
                                }
                            
                            
                        }
                    }
                    
                }
                
            }
        }
        
    }
    

}
