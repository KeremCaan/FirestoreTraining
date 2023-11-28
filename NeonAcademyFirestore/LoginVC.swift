//
//  LoginVC.swift
//  NeonAcademyFirstore
//
//  Created by Kerem Caan on 10.08.2023.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    let forgotPass: UIButton = UIButton()
    let loginButton: UIButton = UIButton()
    let registerButton: UIButton = UIButton()
    let emailTF: UITextField = UITextField()
    let passwordTF: UITextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    

    func configureUI() {
        self.navigationItem.hidesBackButton = true
        
        view.backgroundColor = .white
        
        view.addSubview(emailTF)
        emailTF.placeholder = "email"
        emailTF.textAlignment = .center
        emailTF.borderStyle = .line
        emailTF.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        view.addSubview(passwordTF)
        passwordTF.placeholder = "password"
        passwordTF.textAlignment = .center
        passwordTF.borderStyle = .line
        passwordTF.isSecureTextEntry = true
        passwordTF.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(250)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        view.addSubview(loginButton)
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(LogIn), for: .touchUpInside)
        loginButton.backgroundColor = .blue
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTF.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(75)
        }
        
        view.addSubview(registerButton)
        registerButton.setTitle("Register", for: .normal)
        registerButton.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        registerButton.backgroundColor = .blue
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(75)
        }
        
        view.addSubview(forgotPass)
        forgotPass.setTitle("Forgot Password ?", for: .normal)
        forgotPass.setTitleColor(.blue, for: .normal)
        forgotPass.addTarget(self, action: #selector(goToChange), for: .touchUpInside)
        forgotPass.titleLabel?.numberOfLines = 0
        forgotPass.titleLabel?.textAlignment = .center
        forgotPass.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        
    }
    
    @objc func goToRegister() {
        self.navigationController?.pushViewController(ViewController(), animated: true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Email is invalid. Please provide a proper email adress.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    @objc func goToChange() {
        Auth.auth().sendPasswordReset(withEmail: emailTF.text ?? "") { error in
            guard error == nil else{
                self.showAlert()
                return
            }
        }
    }
    
    @objc func LogIn() {
            Auth.auth().signIn(withEmail: emailTF.text ?? "", password: passwordTF.text ?? "") { [weak self] authResult, error in
              guard let strongSelf = self else { return }
                guard error == nil else{
                    print("Login failed.")
                    return
                }
                self?.navigationController?.pushViewController(TabBarController(), animated: true)
            }
        
    }

}

