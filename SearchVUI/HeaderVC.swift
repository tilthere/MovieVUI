//
//  HeaderVC.swift
//  SearchVUI
//
//  Created by Xiaomei Huang on 11/16/16.
//  Copyright © 2016 Xiaomei Huang. All rights reserved.
//

import UIKit


// Header cell, need to add colletion view HeaderCollection
class Header: UICollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    

    let images = ["1","2", "3", "4", "5", "6", "7", "8","9"]

    // initial header:
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    // add a collection view to header
    let headerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        // change default scroll direction to horizontal
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.darkGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    // add seperate line between rows
    let divideLineView: UILabel = {
        let label = UILabel()
        label.text = "NOW PLAYING"
        label.font = UIFont(name:"Avenir-Black", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.orange
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "COMING SOON"
        label.font = UIFont(name:"AmericanTypewriter-Light", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    private let cellId = "cellId"

    func setupViews() {
        backgroundColor = UIColor.darkGray
        
        headerCollectionView.dataSource = self
        headerCollectionView.delegate = self
        
        // register appcell
        headerCollectionView.register(HeaderCell.self, forCellWithReuseIdentifier: cellId)

        addSubview(titleLabel)
        addConstraintFunc(format: "H:|-15-[v0(150)]", views: titleLabel)
        addConstraintFunc(format: "V:|-8-[v0(16)]", views: titleLabel)
        
        // add headerCollectionView
        addSubview(headerCollectionView)
        addConstraintFunc(format: "H:|[v0]|", views: headerCollectionView)
        addConstraintFunc(format: "V:[v1]-0-[v0]", views: headerCollectionView,titleLabel)
        
        addSubview(divideLineView)

        addConstraintFunc(format: "H:|-15-[v0(150)]", views: divideLineView)

        addConstraintFunc(format: "V:[v1]-0-[v0(40)]|", views: divideLineView,headerCollectionView)


        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HeaderCell
        
        cell.imageView.image = UIImage(named: self.images[indexPath.item])
        return cell
    }
    
    //define cell size inside each row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 230)  // minus the title label height
    }
    
    // return appcell margin between each other
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, 10)
    }
    

}

// add imageview to each cell
class HeaderCell : BaseCell {
    
    var imageView: UIImageView = {
        let iv = UIImageView()
     //   iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.yellow
        
        addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)

        
    }

    
}

