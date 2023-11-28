//
//  ViewController.swift
//  NeonAcademyFirestore
//
//  Created by Kerem Caan on 10.08.2023.
//

import UIKit
import SnapKit
import FirebaseAuth

class ViewController: UIViewController {
    let emailTF: UITextField = UITextField()
    let passwordTF: UITextField = UITextField()
    let registerButton: UIButton = UIButton()
    let registeredButton: UIButton = UIButton()
    var email = ""
    var password = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        let user = Auth.auth().currentUser
        if user != nil && user?.isEmailVerified == true {
            self.navigationController?.pushViewController(TabBarController(), animated: true)
        }
    }
    
    
    
    func configureUI() {
        self.navigationItem.hidesBackButton = true
        
        view.backgroundColor = .white
        
        view.addSubview(emailTF)
        emailTF.placeholder = "email"
        emailTF.textAlignment = .center
        emailTF.borderStyle = .line
        emailTF.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(200)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        view.addSubview(passwordTF)
        passwordTF.placeholder = "password"
        passwordTF.textAlignment = .center
        passwordTF.borderStyle = .line
        passwordTF.isSecureTextEntry = true
        passwordTF.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(250)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        view.addSubview(registerButton)
        registerButton.setTitle("Register", for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerButton.backgroundColor = .blue
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTF.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(75)
        }
        
        view.addSubview(registeredButton)
        registeredButton.setTitle("Have you registered before?", for: .normal)
        registeredButton.setTitleColor(.blue, for: .normal)
        registeredButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        registeredButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        
    }
    
    
    
    @objc func registerButtonTapped() {

        if emailTF.text != "" && passwordTF.text != "" {
            email = emailTF.text!
            password = passwordTF.text!
        }else {
            print("missing data")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in guard let strongSelf = self else{
            return
        }
            guard error == nil else{
                strongSelf.showCreateAccount(email: self!.email, password: self!.password)
                return
            }
            self?.navigationController?.pushViewController(LoginVC(), animated: true)
            print("you have logged in.")
        }
    }
    
    func showCreateAccount(email: String, password: String) {
        let alert = UIAlertController(title: "Create Account.", message: "Would you like to create an account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let strongSelf = self else{
                    return
                }
                    guard error == nil else{
                        print("Account creation failed.")
                        return
                    }
                    
                    print("you have logged in.")
                self!.sendVerificationMail()
                
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        
        present(alert, animated: true)
    }
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }

    public func sendVerificationMail() {
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                self.present(RegisterVC(), animated: true)
            })
        }
        else {
            self.navigationController?.pushViewController(LoginVC(), animated: true)
        }
    }
    
    @objc func goToLogin(){
        self.navigationController?.pushViewController(LoginVC(), animated: true)
    }


}


