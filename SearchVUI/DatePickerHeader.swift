//
//  DatePickerHeader.swift
//  SearchVUI
//
//  Created by Xiaomei Huang on 11/23/16.
//  Copyright © 2016 Xiaomei Huang. All rights reserved.
//

import UIKit

class DatePickerHeaderCell: UICollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    let weekdayFormat: DateFormatter = DateFormatter()
    
    let monthFormat = DateFormatter()

    let dayFormat = DateFormatter()
    
  //  let firstIndex = NSIndexPath(item: 0, section: 0)
    
    var selectedCell = NSIndexPath(item: 0, section: 0)
    
    var dateNo = "0"

    
    
    // initial header:
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    // add a collection view to header
    let datePickerHeader: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        // change default scroll direction to horizontal
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.darkGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    

    
    private let cellId = "cellId"
    
    func setupViews() {
        backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        
        datePickerHeader.dataSource = self
        datePickerHeader.delegate = self
        
        
        // register appcell
        datePickerHeader.register(DateCell.self, forCellWithReuseIdentifier: cellId)
        
        // add headerCollectionView
        addSubview(datePickerHeader)
        addConstraintFunc(format: "H:|[v0]|", views: datePickerHeader)
        addConstraintFunc(format: "V:|[v0]|", views: datePickerHeader)
    //    datePickerHeader.selectItem(at: firstIndex as IndexPath, animated: false, scrollPosition:UICollectionViewScrollPosition())
    
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DateCell
        weekdayFormat.dateFormat = "EEEE"
        monthFormat.dateFormat = "MMMM"
        dayFormat.dateFormat = "dd"
        
        let weekday = addDate(num: indexPath.item)
        //convert string into weekday
        let weekdayName: String = weekdayFormat.string(from: weekday as Date)

        let monthName: String = monthFormat.string(from: weekday as Date)
        cell.weekdate.text = weekdayName
        cell.month.text = monthName
        
        let dayName: String = dayFormat.string(from: weekday as Date)
        cell.day.text = dayName
        
        if selectedCell as IndexPath == indexPath {
            cell.weekdate.backgroundColor = UIColor.orange
            cell.backgroundColor = UIColor.black
            cell.month.textColor = UIColor.white
            cell.day.textColor = UIColor.white
        } else {
            cell.weekdate.backgroundColor = UIColor.white
            cell.backgroundColor = UIColor.white
            cell.month.textColor = UIColor.black
            cell.day.textColor = UIColor.black
        }
        
        return cell
    }
    
    
    
    
    //define cell size inside each row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: frame.height-10)
    }
    
    // return appcell margin between each other
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 6)
    }
    
    // select cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       let cell = collectionView.cellForItem(at: indexPath) as! DateCell
            print("selected:\(indexPath.item)")
        selectedCell = indexPath as NSIndexPath
        
        cell.weekdate.backgroundColor = UIColor.orange
        cell.backgroundColor = UIColor.black
        cell.month.textColor = UIColor.white
        cell.day.textColor = UIColor.white
        self.dateNo = "\(indexPath.item)"
        print(self.dateNo)
            
        collectionView.reloadData()
        
    }


    
    
    func addDate(num:Int) -> Date {
        return NSCalendar.current.date(byAdding: .day, value: num, to: Date())!
    }
    
    
}


class DateCell:BaseCell{
    var weekdate: UILabel = {
        var label = UILabel()
        label.text = "Thursday"
        label.font = UIFont(name:"AmericanTypewriter", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    var month: UILabel = {
        var label = UILabel()
        label.text = "NOV"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"AmericanTypewriter-Bold", size: 18)
        label.textAlignment = .center
        
        return label
    }()
    
    var day: UILabel = {
        var label = UILabel()
        label.text = "24"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name:"AmericanTypewriter-Bold", size: 18)
        label.textAlignment = .center
        
        return label
    }()
    
    
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = UIColor.white
        
        addSubview(weekdate)
        addConstraintFunc(format: "H:|-0-[v0]-0-|", views: weekdate)
        addConstraintFunc(format: "V:|-0-[v0(30)]", views: weekdate)
        
        addSubview(month)
        addConstraintFunc(format: "H:|-0-[v0]-0-|", views: month)
        addConstraintFunc(format: "V:[v1]-12-[v0]", views: month,weekdate)
        
        addSubview(day)
        addConstraintFunc(format: "H:|-0-[v0]-0-|", views: day)
        addConstraintFunc(format: "V:[v1]-5-[v0]", views: day,month)
        
    }
}


