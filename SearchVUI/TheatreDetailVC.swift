//
//  TheatreDetailVC.swift
//  SearchVUI
//
//  Created by Xiaomei Huang on 11/22/16.
//  Copyright © 2016 Xiaomei Huang. All rights reserved.
//

import UIKit


class TheatreDetailVC: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var movies: [Movie]?
    var theatre: Theatre?
    var allMovies : [Movie]!
    private let movieID = "movieID"
    private let theatreID = "theatreID"
    private let ticketID = "ticketID"
    private let dateID = "dateID"
    
    


    override func viewDidLoad() {
        super.viewDidLoad()

     //   navigationItem.title = theatre?.name!

        // Register cell classes
        collectionView?.backgroundColor = UIColor.darkGray
        
        collectionView?.register(DatePickerHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: dateID)
        
        collectionView?.register(TheatreInfoCell.self, forCellWithReuseIdentifier: theatreID)
        
        collectionView?.register(TheatreMoviesCell.self, forCellWithReuseIdentifier: movieID)
        
        if movies?.count == 0 {
            self.movies = allMovies
        }

    
    
    }
    
//    override func viewWillAppear(animated: Bool) {
//        if let index = self.tableView.indexPathForSelectedRow{
//            self.tableView.deselectRowAtIndexPath(index, animated: true)
//        }
//    }



    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if let count = movies?.count {
            return count
        } else {
            return 0
        }
    }

    
    // Set header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: view.frame.width, height: 110)
        }
        return CGSize(width: view.frame.width, height: 0)
        
    }
    
    // Return header view
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: dateID, for: indexPath) as! DatePickerHeaderCell

        return header
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieID, for: indexPath) as! TheatreMoviesCell
            let movie = movies?[indexPath.item]
            cell.imageView.image = UIImage(named: (movie?.image?.lowercased())!)
            cell.titleLabel.text = movie?.title!
            cell.movieNo = (movie?.id!)!
            cell.theatreNo = (self.theatre?.id!)!
            
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: theatreID, for: indexPath) as! TheatreInfoCell
        cell.nameLabel.text = theatre!.name!
        cell.addressLabel.text = "\(theatre!.address!), \(theatre!.city!), \(theatre!.state!), \(theatre!.zip!)"
        
        return cell
        
    }
    
    // define size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 110)
        }
        return CGSize(width: view.frame.width, height: 250)
    }
    
    
    // Margin between sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
    }

    

    

}

class TheatreMoviesCell: BaseCell{
    var movieNo = "4"
    var theatreNo = "1"
    var dateNo = "1"
    
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "finding dory")
        //   iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "FINDING DORY"
        label.numberOfLines = 0
        label.font = UIFont(name:"AmericanTypewriter-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    

    
    var desLabel2: UILabel = {
        let label = UILabel()
        label.text = "PG, 1 hr 32 min"
        label.numberOfLines = 0
        label.font = UIFont(name:"AvenirNextCondensed-Italic", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    var desLabel3: UILabel = {
        let label = UILabel()
        label.text = "Action/Children"
        label.numberOfLines = 0
        label.font = UIFont(name:"AvenirNextCondensed-Italic", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    
    
    var ratingBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named:"rating"), for: .normal)
        btn.layer.masksToBounds = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var desLabel: UILabel = {
        let label = UILabel()
        label.text = "Please select a movie time to buy tickets"
        label.font = UIFont(name:"AvenirNextCondensed-Italic", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        return label
    }()

    var ticketBTN : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("11:15am", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.backgroundColor = UIColor.orange
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var ticketBTN1 : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitle("1:15pm", for: .normal)
        btn.backgroundColor = UIColor.orange
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var ticketBTN2 : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitle("7:15pm", for: .normal)
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
        addConstraintFunc(format: "H:|-10-[v0(160)]", views: imageView)
        addConstraintFunc(format: "V:|-5-[v0(240)]", views: imageView)
        
        
        addSubview(titleLabel)
        addConstraintFunc(format: "H:[v1]-35-[v0]-5-|", views: titleLabel,imageView)
        addConstraintFunc(format: "V:|-20-[v0]", views: titleLabel)
        
        addSubview(ratingBtn)
        addConstraintFunc(format: "H:[v1]-35-[v0(140)]", views: ratingBtn,imageView)
        addConstraintFunc(format: "V:[v1]-2-[v0(30)]", views: ratingBtn,titleLabel)

        addSubview(desLabel2)
        addConstraintFunc(format: "H:[v1]-35-[v0]-5-|", views: desLabel2,imageView)
        addConstraintFunc(format: "V:[v1]-2-[v0]", views: desLabel2,ratingBtn)
        
        addSubview(desLabel3)
        addConstraintFunc(format: "H:[v1]-35-[v0]-5-|", views: desLabel3,imageView)
        addConstraintFunc(format: "V:[v1]-2-[v0]", views: desLabel3,desLabel2)
        
        addSubview(desLabel)
        addConstraintFunc(format: "H:[v1]-35-[v0]-5-|", views: desLabel,imageView)
        addConstraintFunc(format: "V:[v1]-20-[v0]", views: desLabel,desLabel3)
        
        addSubview(ticketBTN)
        addConstraintFunc(format: "H:[v1]-35-[v0(50)]", views: ticketBTN,imageView)
        addConstraintFunc(format: "V:[v1]-20-[v0(30)]", views: ticketBTN,desLabel)
        
        addSubview(ticketBTN1)
        addConstraintFunc(format: "H:[v1]-20-[v0(50)]", views: ticketBTN1,ticketBTN)
        addConstraintFunc(format: "V:[v1]-20-[v0(30)]", views: ticketBTN1,desLabel)
        
        addSubview(ticketBTN2)
        addConstraintFunc(format: "H:[v1]-20-[v0(50)]", views: ticketBTN2,ticketBTN1)
        addConstraintFunc(format: "V:[v1]-20-[v0(30)]", views: ticketBTN2,desLabel)
        
        ticketBTN.addTarget(self, action: #selector(checkOut1), for: .touchUpInside)
        ticketBTN1.addTarget(self, action: #selector(checkOut2), for: .touchUpInside)
        ticketBTN2.addTarget(self, action: #selector(checkOut3), for: .touchUpInside)

        
        
    }
    
    func checkOut1(){
        let id: String = movieNo + theatreNo + dateNo + "1"
        if let url = URL(string: "http://cis.myphillips.us/payment/index.html?showing=\(id)"){
            UIApplication.shared.open(url,options:[:])
        }
        print(id)
    }
    func checkOut2(){
        let id: String = movieNo + theatreNo + dateNo + "2"
        if let url = URL(string: "http://cis.myphillips.us/payment/index.html?showing=\(id)"){
            UIApplication.shared.open(url,options:[:])
        }
        print(id)
    }
    func checkOut3(){
        let id: String = movieNo + theatreNo + dateNo + "3"
        if let url = URL(string: "http://cis.myphillips.us/payment/index.html?showing=\(id)"){
            UIApplication.shared.open(url,options:[:])
        }
        print(id)
    }
    


    
}



class TheatreInfoCell: BaseCell {
    
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "CELEBRATION! CINEMA GRAND RAPIDS WOODLAND".uppercased()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name:"AmericanTypewriter-Bold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    var addressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "3195 28th St. SE, Grand Rapids, MI 49512"
        label.numberOfLines = 1
        label.font = UIFont(name:"AvenirNextCondensed-Italic", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    var phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "(616) 530-7469"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    var mapBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.setTitle("MAP IT", for: .normal)
        btn.backgroundColor = UIColor.orange
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)

        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.black
        
        
        addSubview(nameLabel)
        addConstraintFunc(format: "H:|-15-[v0]-5-|", views: nameLabel)
        addConstraintFunc(format: "V:|-15-[v0]", views: nameLabel)
        
        addSubview(addressLabel)
        addConstraintFunc(format: "H:|-15-[v0]-5-|", views: addressLabel)
        addConstraintFunc(format: "V:[v1]-10-[v0]", views: addressLabel,nameLabel)
        
        addSubview(phoneLabel)
        addConstraintFunc(format: "H:|-25-[v0]-5-|", views: phoneLabel)
        addConstraintFunc(format: "V:[v0]-18-|", views: phoneLabel)
        
        
        addSubview(mapBtn)
        addConstraintFunc(format: "H:[v0(80)]-15-|", views: mapBtn)
        addConstraintFunc(format: "V:[v0(20)]-15-|", views: mapBtn)
        
        
    }
    
    
}



