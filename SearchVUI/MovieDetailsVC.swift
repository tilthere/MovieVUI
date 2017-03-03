//
//  MovieDetailsVC.swift
//  SearchVUI
//
//  Created by Xiaomei Huang on 11/22/16.
//  Copyright © 2016 Xiaomei Huang. All rights reserved.
//

import UIKit


class MovieDetailsVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var movie: Movie?
    var theatres: [Theatre]?
    var allTheatres: [Theatre]?

    private let movieID = "movieID"
    private let ticketID = "ticketID"
    private let dateID = "dateID"
    
    
    let today = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        print (movie!.title!.uppercased())
        

        
        if theatres?.count == 0{
            theatres = allTheatres
        }
        
        navigationItem.title = movie?.title!.uppercased()
        collectionView?.backgroundColor = UIColor.orange

        // Register cell classes
        collectionView?.register(MovieDetailCell.self, forCellWithReuseIdentifier: movieID)
        collectionView?.register(TicketDetailCell.self, forCellWithReuseIdentifier: ticketID)
        collectionView?.register(DatePickerHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: dateID)


        let tomorrow = NSCalendar.current.date(byAdding: .day, value: 1, to: today as Date)
        print(tomorrow!)


        
 
//        print(today.get_WeekDay())
//        print(Date().dayOfWeek()!)
//        print(today.get_Day())
//        
//        print(today.dayOfWeek()!)
//        print(tomorrow!.dayOfWeek()!)
//        print(today.monthName()!)

    }
    
    
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
        return 1
        }
        return theatres!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ticketID, for: indexPath) as! TicketDetailCell
            let theatre = theatres![indexPath.item]
            cell.titleLabel.text = "\(theatre.name!)"
            cell.addressLabel.text = "\(theatre.address!), \(theatre.city!), \(theatre.state!), \(theatre.zip!)"
            cell.movieNo = (self.movie?.id!)!
            cell.theatreNo = theatre.id!

            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieID, for: indexPath) as! MovieDetailCell
        
        cell.imageView.image = UIImage(named: (movie?.image!)!.lowercased())
        
        return cell
        
    }
    
    

    
    // define size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
          return CGSize(width: view.frame.width, height: 250)
        }
        return CGSize(width: view.frame.width, height: 170)
    }
    
    
    // Margin between sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
    }
    
    // Set header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
        return CGSize(width: view.frame.width, height: 110)
        }
        return CGSize(width: view.frame.width, height: 0)

    }
    
    // Return header view
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: dateID, for: indexPath) as! DatePickerHeaderCell
        
        
        return header
 
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.theatres?[indexPath.item].name!)

    }
    



}



// cell classes




class TicketDetailCell: BaseCell{
    
    var movieNo = "4"
    var theatreNo = "1"
    var dateNo = "1"

    var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name:"AmericanTypewriter-Bold", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    var addressLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.black
        label.textAlignment = .center

 //       label.text = "Released"
        label.font = UIFont(name:"AvenirNextCondensed-Italic", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    var desLabel: UILabel = {
        let label = UILabel()
        label.text = "Please select a movie time to buy tickets"
        label.textAlignment = .center
        label.font = UIFont(name:"AvenirNextCondensed-Italic", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        return label
    }()
    
    
    
    var ticketBTN : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("11:15am", for: .normal)
        btn.backgroundColor = UIColor.orange
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var ticketBTN1 : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
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
        backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        
        
        addSubview(titleLabel)
        addConstraintFunc(format: "H:|-0-[v0]-0-|", views: titleLabel)
        addConstraintFunc(format: "V:|-0-[v0(40)]", views: titleLabel)
        
        addSubview(addressLabel)
        addConstraintFunc(format: "H:|-0-[v0]-0-|", views: addressLabel)
        addConstraintFunc(format: "V:[v1]-0-[v0(30)]", views: addressLabel,titleLabel)
        
        addSubview(desLabel)
        addConstraintFunc(format: "H:|-25-[v0]-5-|", views: desLabel)
        addConstraintFunc(format: "V:[v1]-20-[v0]", views: desLabel,addressLabel)
        
        addSubview(ticketBTN)
        addConstraintFunc(format: "H:|-20-[v0(85)]", views: ticketBTN)
        addConstraintFunc(format: "V:[v1]-20-[v0(30)]", views: ticketBTN,desLabel)
        
        addSubview(ticketBTN1)
        
        // center x
        addConstraint(NSLayoutConstraint(item: ticketBTN1, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
        addConstraintFunc(format: "H:[v0(85)]", views: ticketBTN1)

        
  //      addConstraintFunc(format: "H:[v1]-[v0(85)]-[v2]", views: ticketBTN1,ticketBTN,ticketBTN2)
        addConstraintFunc(format: "V:[v1]-20-[v0(30)]", views: ticketBTN1,desLabel)

        addSubview(ticketBTN2)
        addConstraintFunc(format: "H:[v0(85)]-20-|", views: ticketBTN2)
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


class MovieDetailCell: BaseCell{
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        //   iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "NOVEMBER 4,2016"
        label.numberOfLines = 0
        label.font = UIFont(name:"AmericanTypewriter-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    var desLabel1: UILabel = {
        let label = UILabel()
        label.text = "Released"
        label.numberOfLines = 0
        label.font = UIFont(name:"AvenirNextCondensed-Italic", size: 14)
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
    
    var desLabel4: UILabel = {
        let label = UILabel()
        label.text = "4,567 Fan Ratings"
        label.numberOfLines = 0
        label.font = UIFont(name:"AvenirNextCondensed-Italic", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.black
        
        addSubview(imageView)
        addConstraintFunc(format: "H:|-10-[v0(120)]", views: imageView)
        addConstraintFunc(format: "V:|-30-[v0(180)]", views: imageView)
        
        addSubview(desLabel1)
        addConstraintFunc(format: "H:[v1]-35-[v0]-5-|", views: desLabel1,imageView)
        addConstraintFunc(format: "V:|-20-[v0]", views: desLabel1)
        
        
        addSubview(titleLabel)
        addConstraintFunc(format: "H:[v1]-35-[v0]-5-|", views: titleLabel,imageView)
        addConstraintFunc(format: "V:[v1]-10-[v0]", views: titleLabel,desLabel1)
        
        addSubview(desLabel2)
        addConstraintFunc(format: "H:[v1]-35-[v0]-5-|", views: desLabel2,imageView)
        addConstraintFunc(format: "V:[v1]-10-[v0]", views: desLabel2,titleLabel)
        
        addSubview(desLabel3)
        addConstraintFunc(format: "H:[v1]-35-[v0]-5-|", views: desLabel3,imageView)
        addConstraintFunc(format: "V:[v1]-6-[v0]", views: desLabel3,desLabel2)
        
        addSubview(ratingBtn)
        addConstraintFunc(format: "H:[v1]-35-[v0(140)]", views: ratingBtn,imageView)
        addConstraintFunc(format: "V:[v1]-20-[v0(30)]", views: ratingBtn,desLabel3)
        
        addSubview(desLabel4)
        addConstraintFunc(format: "H:[v1]-35-[v0]-5-|", views: desLabel4,imageView)
        addConstraintFunc(format: "V:[v1]-6-[v0]", views: desLabel4,ratingBtn)
        
        
    }
    
}


