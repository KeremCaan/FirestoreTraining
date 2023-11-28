//
//  LoggedInVC.swift
//  NeonAcademyFirebase
//
//  Created by Kerem Caan on 10.08.2023.
//

import UIKit
import FirebaseAuth
import Firebase

class LoggedInVC: UIViewController {
    let imageView: UIImageView = UIImageView()
    let button: UIButton = UIButton()


    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    
    }
    

    func configureUI() {
        self.navigationItem.hidesBackButton = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.photoChanged),
            name: .photoChanged,
            object: nil)
        
        view.backgroundColor = .white
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)

        view.addSubview(imageView)
        imageView.image = UIImage(systemName: "person.fill")
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        view.addSubview(button)
        button.setTitle("Log Out", for: .normal)
        button.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        button.backgroundColor = .blue
        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-200)
            make.centerX.equalToSuperview()
            make.width.equalTo(75)
        }
    }
    
    @objc func signOutTapped() {
        let auth = Auth.auth()
        
        do{
           try auth.signOut()
            print("signed out")
        } catch let signOutError {
            print("error")
        }
        
        self.navigationController?.pushViewController(ViewController(), animated: true)
    }
    
    @objc private func photoChanged(notification: NSNotification){
        imageView.image = notification.userInfo!["image"] as? UIImage
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        let newViewController = PhotoSelectionVC()
        self.present(newViewController, animated: true)
    }
    
}

extension Notification.Name {
    static let photoChanged = Notification.Name("photoChanged")
    static let feedChanged = Notification.Name("feedChanged")
    static let nameChanged = Notification.Name("nameChanged")
}

