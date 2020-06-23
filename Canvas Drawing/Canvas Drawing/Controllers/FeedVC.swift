//
//  FeedVC.swift
//  Canvas Drawing
//
//  Created by phani srikar on 20/06/20.
//  Copyright © 2020 phani srikar. All rights reserved.
//

import UIKit

class FeedVC:  UICollectionViewController, UICollectionViewDelegateFlowLayout   {

    let cellId = "FeedCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .offWhite
        collectionView.delegate = self
//        collectionView.datasource = self
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        print(collectionView.visibleCells)
    }
    
    
    //
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 20, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10 )
    }
}

class FeedCell :  UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame : frame)
        Setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Setup(){
        self.backgroundColor = UIColor.red
        self.layer.cornerRadius = 25
        let img = UIImageView()
        self.contentView.addSubview(img)
        img.image = UIImage(named: "")
        img.translatesAutoresizingMaskIntoConstraints = false
        
        img.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        img.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        img.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        img.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true        
    }
    
    
}
