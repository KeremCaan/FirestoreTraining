//
//  FeedVC.swift
//  NeonAcademyFirestore
//
//  Created by Kerem Caan on 11.08.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class FeedVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate {
    private var collectionView: UICollectionView?
    var imagesArr: [UIImage] = []
    let uploadButton: UIBarButtonItem = UIBarButtonItem()
    var namesArr: [String] = []
    var indexPath: [Int] = []
    var docID: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        UploadImageVC().retrievePhotos()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.feedChanged),
            name: .feedChanged,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.nameChanged),
            name: .nameChanged,
            object: nil)
        
    }
    
    func configureUI() {
        
        loadDocs()
        view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        
        uploadButton.title = "Upload image."
        self.navigationItem.setRightBarButton(uploadButton, animated: true)
        uploadButton.target = self
        uploadButton.action = #selector(uploadImage)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else {
            return
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.frame = view.bounds
        
        
    }
    
    func loadDocs() {
        
        let db = Firestore.firestore()
        
        let query = db.collection("images").addSnapshotListener { snap, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if snap?.isEmpty != true {
                        self.docID.removeAll()
                        
                        for document in snap!.documents {
                            self.docID.append(document.documentID)
                            
                    }
                        self.collectionView?.reloadData()

                }
            }
        }
        
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .blue
        cell.configureUI(image: imagesArr[indexPath.row])
        cell.setNames(name: namesArr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CommentsVC()
        vc.docID = docID[indexPath.row]
        self.present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.width - 15))
        print("cell width : \(width)")
        return CGSize(width: width, height: 200)
    }
    
    @objc func uploadImage() {
        self.navigationController?.pushViewController(UploadImageVC(), animated: true)
    }
    
    @objc private func feedChanged(notification: NSNotification){
        imagesArr.removeAll()
        imagesArr.append(notification.userInfo!["feed"] as! UIImage)
        collectionView?.reloadData()
    }
    
    @objc private func nameChanged(notification: NSNotification){
        namesArr.removeAll()
        namesArr.append(notification.userInfo!["username"] as! String)
    }

}

