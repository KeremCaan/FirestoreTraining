//
//  CommentsVC.swift
//  NeonAcademyFirestore
//
//  Created by Kerem Caan on 11.08.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class CommentsVC: UIViewController {
    let textField: UITextField = UITextField()
    let tableView: UITableView = UITableView()
    var commentsArr: [String] = []
    var usersArr: [String] = []
    var documentsArr: [QueryDocumentSnapshot] = []
    var docID = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadComments()


    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(textField)
        textField.placeholder = "Comment something."
        textField.borderStyle = .line
        textField.addTarget(self, action: #selector(commentMade), for: .editingDidEndOnExit)
        textField.textAlignment = .center
        textField.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-30)
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func commentMade() {
        
        let db = Firestore.firestore()
        
        
        commentsArr.append(self.textField.text!)
        usersArr.append((Auth.auth().currentUser?.email)!)
        db.collection("images").document(String(docID.prefix(20))).updateData(["comment": commentsArr]) { [self] err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                db.collection("images").document(String(docID.prefix(20))).updateData(["users": usersArr]) { [self] err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }

            }
            self.tableView.reloadData()
        }

    }
    
    func loadComments() {
        
        let db = Firestore.firestore()
        
        let query = db.collection("images").whereField("username", isEqualTo: (Auth.auth().currentUser?.email)!)
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.docID.append(document.documentID)
                    self.usersArr.append(contentsOf: document.data()["users"] as! Array)
                    self.commentsArr.append(contentsOf: document.data()["comment"] as! Array)
                    self.tableView.reloadData()
                }
            }
        }
        
    }

}

extension CommentsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = self.usersArr[indexPath.row]
        content.secondaryText = self.commentsArr[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    
}
