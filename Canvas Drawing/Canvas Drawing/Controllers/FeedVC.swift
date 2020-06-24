//
//  FeedVC.swift
//  Canvas Drawing
//
//  Created by phani srikar on 20/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import UIKit
import Firebase

let imageCache = NSCache<AnyObject, AnyObject>()

class FeedVC:  UICollectionViewController, UICollectionViewDelegateFlowLayout   {
    
    var folderList: [StorageReference]?
    var storage = Storage.storage()
    var downloadedImages : [UIImage] = []
    let cellId = "FeedCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView.reloadData()

        self.storage.reference().child("FeedImages").listAll(completion: {
          (result,error) in
            print("result is \(result.items)")
            self.folderList = result.items
                      DispatchQueue.main.async {
                        self.folderList?.forEach({ (refer) in
                            self.load(storageRef: refer)
                        })
                          self.collectionView.reloadData()
                      }
                  })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .offWhite
        collectionView.delegate = self
//        collectionView.datasource = self
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    //
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return downloadedImages.count ?? 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        if(downloadedImages.count > 0){
            if(downloadedImages[indexPath.row] != nil){
             print("Loading downloaded Image....")
                 cell.img.image = downloadedImages[indexPath.row]
            }
        }
        else{
            cell.img.image = UIImage(named: "Placeholder")
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 20, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10 )
    }
    
    
    func load(storageRef: StorageReference) {
        
        storageRef.downloadURL(completion: {(downloadURL,error) in
            
            // retrieves image if already available in cache
            if let imageFromCache = imageCache.object(forKey: downloadURL as AnyObject) as? UIImage {
                
                if(self.downloadedImages.count == 0){
                    self.downloadedImages.append(imageFromCache)
                }
                return
            }
            
            
            
            if(error != nil){
                print(error.debugDescription)
                return
            }
//                   print("url is \(downloadURL!)")
            print("Download Started")
            self.getData(from: downloadURL!) { data, response, error in
                guard let data = data, error == nil else { return }
//                print(response?.suggestedFilename ?? downloadURL!.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() { [weak self] in
                    let imageToCache = UIImage(data: data)
                    self!.downloadedImages.append(imageToCache!)
                    imageCache.setObject(imageToCache as AnyObject, forKey: downloadURL as AnyObject)
                    self?.collectionView.reloadData()
                }
            }
               
            })
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

}

class FeedCell :  UICollectionViewCell{
   
    var img = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        Setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Setup(){
        self.layer.cornerRadius = 25
        self.contentView.addSubview(img)
        img.image = UIImage(named: "Placeholder")
        img.translatesAutoresizingMaskIntoConstraints = false
        
        img.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        img.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        img.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        img.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true        
    }
    
    
}


  
