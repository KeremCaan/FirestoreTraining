//
//  ChangePasswordVC.swift
//  NeonAcademyFirebase
//
//  Created by Kerem Caan on 10.08.2023.
//

import UIKit
import FirebaseAuth

class ChangePasswordVC: UIViewController {
    let oldPassTF: UITextField = UITextField()
    let newPassTF: UITextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    

    func configureUI() {
        
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        
        view.addSubview(oldPassTF)
        oldPassTF.placeholder = "Old Password"
        oldPassTF.textAlignment = .center
        oldPassTF.borderStyle = .line
        oldPassTF.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        view.addSubview(newPassTF)
        newPassTF.placeholder = "New Password"
        newPassTF.textAlignment = .center
        newPassTF.borderStyle = .line
        newPassTF.isSecureTextEntry = true
        newPassTF.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(250)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
    }
    
//    @objc func forgotPass() {
//        Auth.auth().sendPasswordReset(withEmail: email) { error in
//          // ...
//        }
//    }

}

