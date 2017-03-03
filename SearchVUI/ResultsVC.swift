//
//  ResultsVC.swift
//  SearchVUI
//
//  Created by Xiaomei Huang on 11/17/16.
//  Copyright © 2016 Xiaomei Huang. All rights reserved.
//

// if search for location name, return theatre results

import UIKit


class ResultsVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    private let theatreID = "theatreID"
    let headerID = "headerID"
    let movieID = "movieID"
    var task : DispatchWorkItem?

//    var keywords : String?
    
//    var sentences : String =  "trolls in woodland"
    
    var sentences : String?
    
    
    var keywordsList = ["woodland","RiverTown","AMC","North","IMAX","grand rapids","christmas","seventeen","doctor","dragon","celebration","17","dory"]
    var keywordMatches = [String]()
    
    
    var movies = [Movie]()
    var theatres = [Theatre]()
    var tickets = [Ticket]()
    var filteredMovies = [Movie]()
    var filteredTheatres = [Theatre]()
    var sectionTitle = [String]()
    
    var results = SearchResults()
    
    var keywordsTxt : UILabel = {
        let tv = UILabel()
        tv.backgroundColor = UIColor.black
        tv.textColor = UIColor.white
        tv.numberOfLines = 0
        tv.font = UIFont.systemFont(ofSize: 14)
     //   tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    // add seperate line between rows
    let divideLineView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.orange
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.collectionView?.backgroundColor = UIColor.darkGray
        
        self.collectionView!.register(TheatreCell.self, forCellWithReuseIdentifier: theatreID)
        self.collectionView!.register(MovieResultsCell.self, forCellWithReuseIdentifier: movieID)

        collectionView?.register(HeaderTitle.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)


        //set title color by UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        self.navigationItem.title = "Results"
        
       // print (sentences)
        self.keywordsTxt.text = "  Results for \"\(sentences!)\" "
        self.view.addSubview(keywordsTxt)
        view.addConstraintFunc(format: "H:|-0-[v0]-0-|", views: keywordsTxt)
        view.addConstraintFunc(format: "V:|-2-[v0]", views: keywordsTxt)
        
        self.view.addSubview(divideLineView)
        view.addConstraintFunc(format: "H:|[v0]|", views: divideLineView)
        view.addConstraintFunc(format: "V:[v1]-12-[v0(1)]", views: divideLineView,keywordsTxt)
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintFunc(format: "H:|[v0]|", views: collectionView!)
        view.addConstraintFunc(format: "V:[v1]-0-[v0]-0-|", views: self.collectionView!,divideLineView)
        
        loadMovieData()
        loadTheatreData()
        loadTicketData()
        checkKeywords(sentence: sentences!)
        
//        filterContentForSearchText(searchText: sentences)
//        print(self.results)
        
        self.keywordMatches.append(sentences!)
        
        filterContentForSearchText(searchTexts: keywordMatches)
        
        // remove duplicate results
        self.results.movies = Array(Set(self.results.movies))
        self.results.theatres = Array(Set(self.results.theatres))

        print("filteredMovies final:\(results.movies.count)")
        print("filteredTheatres final:\(results.theatres.count)")
        
        if self.results.movies.count == 0 && self.results.theatres.count == 0 {
            print("i will go back to search")
            self.keywordsTxt.text = "WE COULDN'T FIND ANY RESULTS FOR \"\(sentences!)\", PLEASE TRY AGAIN!"
            
            self.keywordsTxt.backgroundColor = UIColor.orange
            self.collectionView?.removeFromSuperview()
            self.divideLineView.removeFromSuperview()
            // set task after 6 sec
            self.task = DispatchWorkItem {
                self.backToMain()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: task!)
            
        }
    
    }
    
    func backToMain(){
        navigationController?.popViewController(animated: true)
    }
    

    
    
    func loadMovieData(){
        // load data:
        let url = Bundle.main.url(forResource: "all", withExtension: "json")
        let data = NSData(contentsOf: url!)
        
        do {
            let json = try(JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! [String:AnyObject])
            let ajson = json["Movies"] as! [AnyObject]
            for index in 0...(ajson.count - 1) {
                let aObject = ajson[index] as! [String : AnyObject]
                let movie = Movie()
                print("keywordlist: \(keywordsList)")
                movie.setValuesForKeys(aObject)
                let title = movie.title! as String
                self.keywordsList.append(title)

                self.movies.append(movie)
            }
//            print (movies.count)
//            print(movies[0].showtimes![0].dateTime!)
            
        } catch let err {
            print (err)
        }
        self.collectionView?.reloadData()

        
    }
    
    func loadTheatreData(){
        // load data:
        let url = Bundle.main.url(forResource: "all", withExtension: "json")
        let data = NSData(contentsOf: url!)
        
        do {
            let json = try(JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! [String:AnyObject])
            let ajson = json["theatres"] as! [AnyObject]
            for index in 0...(ajson.count - 1) {
                let aObject = ajson[index] as! [String : AnyObject]
                let theatre = Theatre()
                theatre.setValuesForKeys(aObject)
                self.theatres.append(theatre)
            }
            
        } catch let err {
            print (err)
        }
        self.collectionView?.reloadData()

    }
    
    func loadTicketData(){
        // load data:
        let url = Bundle.main.url(forResource: "all", withExtension: "json")
        let data = NSData(contentsOf: url!)
        
        do {
            let json = try(JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! [String:AnyObject])
            let ajson = json["tickets"] as! [AnyObject]
            for index in 0...(ajson.count - 1) {
                let aObject = ajson[index] as! [String : AnyObject]
                let ticket = Ticket()
                ticket.setValuesForKeys(aObject)
                self.tickets.append(ticket)
                print(ticket.movieID!)
            }
            
        } catch let err {
            print (err)
        }
        
    }
    
    func filterContentForSearchText(searchTexts: [String]) {
      
        var searchText : String!
        for text in searchTexts {
            if text == "17" {
                searchText = "seventeen"
            } else {
                searchText = text
            }
            print("search for \(searchText)........")
            filteredMovies = movies.filter { movie in
                let movieNameMatch = movie.title!.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return movieNameMatch != nil
            }
            filteredTheatres = theatres.filter { theatre in
                let theatreCityMatch = theatre.city!.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                let theatreNameMatch = theatre.name!.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return theatreCityMatch != nil || theatreNameMatch != nil
                
            }
            print("filteredTheatres: \(filteredTheatres.count)")
            print("filteredMovies: \(filteredMovies.count)")

            self.results.movies += filteredMovies
            self.results.theatres += filteredTheatres
        }
        self.collectionView?.reloadData()

    }

    
    func checkKeywords(sentence:String){
        for key in self.keywordsList {
            
            if sentence.lowercased().range(of:key.lowercased()) != nil {
            keywordMatches.append(key)
                print("key:\(key)")
            }
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return self.results.theatres.count
        } else if section == 0 {
            return self.results.movies.count
        }
        return 0
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: theatreID, for: indexPath) as! TheatreCell
            let theatre = self.results.theatres[indexPath.item]
            let name = theatre.name!
            let address = theatre.address!
            cell.addressLabel.text = address
            cell.nameLabel.text = name
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieID, for: indexPath) as! MovieResultsCell
        let movie = self.results.movies[indexPath.item]
        let title = movie.title!.uppercased()
        cell.titleLabel.text = title
        cell.desLabel.text = movie.descriptn!
        cell.imageView.image = UIImage(named: movie.image!.lowercased())
        return cell
    
    }

    // define size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 180)
        }
        return CGSize(width: view.frame.width, height: 120)
    }

    // Margin between sections
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // Set header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 && self.results.movies.count == 0 {
            return CGSize(width: view.frame.width, height: 0)
        }
        if section == 1 && self.results.theatres.count == 0 {
            return CGSize(width: view.frame.width, height: 0)
        }
        return CGSize(width: view.frame.width, height: 40)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

         let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! HeaderTitle
        if indexPath.section == 0 {
            header.nameLabel.text = "MOVIES (\(self.results.movies.count))"
        }
        if indexPath.section == 1 {
            header.nameLabel.text = "THEATRE (\(self.results.theatres.count))"
        }
        header.backgroundColor = UIColor.clear
        
        return header
    }
    
    // push to app detail view
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
        if indexPath.section == 0 {
            let movie = self.results.movies[indexPath.item]
            let theatres = self.results.theatres
            showMovieDetails(movie:movie,theatres:theatres)
        }
        if indexPath.section == 1 {
            let theatre = self.results.theatres[indexPath.item]
            showTheatreDetails(theatre:theatre)
        }
    }
    
    func showMovieDetails(movie:Movie,theatres: [Theatre]){
        let layout = UICollectionViewFlowLayout()
        let movieDetailsVC = MovieDetailsVC(collectionViewLayout:layout)
        movieDetailsVC.movie = movie
        movieDetailsVC.theatres = results.theatres
        movieDetailsVC.allTheatres = self.theatres
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
    
    func showTheatreDetails(theatre:Theatre){
        let layout = UICollectionViewFlowLayout()
        let theatreDetailsVC = TheatreDetailVC(collectionViewLayout:layout)
        theatreDetailsVC.theatre = theatre
        theatreDetailsVC.movies = results.movies
        theatreDetailsVC.allMovies = movies
        
        navigationController?.pushViewController(theatreDetailsVC, animated: true)
    }



}
















// CELLS CLASSES

class HeaderTitle: BaseCell{
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name:"AmericanTypewriter", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    override func setupViews() {
        super.setupViews()
        addSubview(nameLabel)
        addConstraintFunc(format: "H:|-15-[v0]-5-|", views: nameLabel)
        addConstraintFunc(format: "V:|-[v0]-|", views: nameLabel)

    }
}



class TheatreCell: BaseCell {
    
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "CELEBRATION! CINEMA GRAND RAPIDS WOODLAND".uppercased()
        label.numberOfLines = 0
        label.font = UIFont(name:"AmericanTypewriter", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        return label
    }()
    
    var addressLabel: UILabel = {
        let label = UILabel()
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
        addConstraintFunc(format: "H:|-15-[v0]-5-|", views: phoneLabel)
        addConstraintFunc(format: "V:[v0]-18-|", views: phoneLabel)

        
        addSubview(mapBtn)
        addConstraintFunc(format: "H:[v0(80)]-15-|", views: mapBtn)
        addConstraintFunc(format: "V:[v0(25)]-15-|", views: mapBtn)
        
        
    }
    
    
}


class MovieResultsCell: BaseCell {
    
    
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
        label.font = UIFont(name:"AvenirNextCondensed-Italic", size: 13)
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
    
    // add seperate line between rows
    let divideLineView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.orange
        return label
    }()
    
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.black
        
        addSubview(imageView)
        addConstraintFunc(format: "H:|-25-[v0(100)]", views: imageView)
        addConstraintFunc(format: "V:|-10-[v0(150)]", views: imageView)
        
        addSubview(titleLabel)
        addConstraintFunc(format: "H:[v1]-35-[v0]-10-|", views: titleLabel,imageView)
        addConstraintFunc(format: "V:|-20-[v0]", views: titleLabel)
        
        addSubview(desLabel)
        addConstraintFunc(format: "H:[v1]-35-[v0]-10-|", views: desLabel,imageView)
        addConstraintFunc(format: "V:[v1]-15-[v0]", views: desLabel,titleLabel)
        
//        addSubview(ticketBtn)
//        addConstraintFunc(format: "H:[v0(85)]-15-|", views: ticketBtn)
//        addConstraintFunc(format: "V:[v0(25)]-30-|", views: ticketBtn)
        
        addSubview(divideLineView)
        addConstraintFunc(format: "H:|[v0]|", views: divideLineView)
        addConstraintFunc(format: "V:[v0(1)]-0-|", views: divideLineView)

        
    }
    
    
}







