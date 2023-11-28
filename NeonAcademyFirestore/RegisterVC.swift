//
//  RegisterVC.swift
//  NeonAcademyFirestore
//
//  Created by Kerem Caan on 10.08.2023.
//

import UIKit
import FirebaseAuth

class RegisterVC: UIViewController {
    let label: UILabel = UILabel()
    let button: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func configureUI() {
        self.navigationItem.hidesBackButton = true
        
        view.backgroundColor = .gray
        
        view.addSubview(label)
        label.text = "Check your email for verification."
        label.textAlignment = .center
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(button)
        button.setTitle("Send verification mail.", for: .normal)
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(sendVerificationMail), for: .touchUpInside)
        button.titleLabel?.numberOfLines = 0
        button.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
        }
        
    }
    
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }

    @objc func sendVerificationMail() {
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                print("email has been sent.")
            })
        }
        else {
            print("cant send the email.")
        }
    }

}

