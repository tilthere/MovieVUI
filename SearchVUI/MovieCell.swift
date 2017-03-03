//
//  MovieCell.swift
//  SearchVUI
//
//  Created by Xiaomei Huang on 11/18/16.
//  Copyright © 2016 Xiaomei Huang. All rights reserved.
//

import UIKit


// Header
class MovieCell: BaseCell{
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        //   iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "the edge of seventeen".uppercased()
        label.numberOfLines = 0
        label.font = UIFont(name:"AmericanTypewriter", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    var desLabel: UILabel = {
        let label = UILabel()
        label.text = "A high school junior becomes upset after learning that her best friend is dating her older brother."
        label.numberOfLines = 0
        label.font = UIFont(name:"AvenirNextCondensed-Italic", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    var ticketBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("Buy Tickets", for: .normal)
        btn.backgroundColor = UIColor.orange
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true

        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()


    
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.black
        
        addSubview(imageView)
        addConstraintFunc(format: "H:|-15-[v0(100)]", views: imageView)
        addConstraintFunc(format: "V:|-15-[v0(150)]", views: imageView)
        
        addSubview(titleLabel)
        addConstraintFunc(format: "H:[v1]-35-[v0]-5-|", views: titleLabel,imageView)
        addConstraintFunc(format: "V:|-30-[v0]", views: titleLabel)

        addSubview(desLabel)
        addConstraintFunc(format: "H:[v1]-35-[v0]-5-|", views: desLabel,imageView)
        addConstraintFunc(format: "V:[v1]-20-[v0]", views: desLabel,titleLabel)
        
//        addSubview(ticketBtn)
//        addConstraintFunc(format: "H:[v0(85)]-15-|", views: ticketBtn)
//        addConstraintFunc(format: "V:[v0(25)]-15-|", views: ticketBtn)

        
    }
    
}



