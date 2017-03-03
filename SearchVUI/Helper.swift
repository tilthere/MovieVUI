//
//  Helpers.swift
//  FirebaseNote
//
//  Created by Xiaomei Huang on 11/15/16.
//  Copyright © 2016 Xiaomei Huang. All rights reserved.
//

import UIKit


// help function of constraints
extension UIView{
    func addConstraintFunc(format: String, views: UIView...){
        var viewDict = [String:UIView]()
        for (index,view) in views.enumerated(){
            let key = "v\(index)"
            viewDict[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDict))
    }
    
}

// view.translatesAutoresizingMaskIntoConstraints = false

//addConstraintFunc(format: "H:|[v0]|", views: divideLineView)
//addConstraintFunc(format: "V:[v0(0.5)]|", views: divideLineView)

//addConstraintFunc(format: "H:|-14-[v0(100)]-8-[v1]", views: imageView,textLabel)
//addConstraintFunc(format: "V:|-14-[v0(20)]", views: textLabel)



// basic cell set up
class BaseCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    func setupViews(){
        
    }
}

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    func setupViews(){
        
    }

}

extension NSDate{
    //Function will return the current year
    func  get_year() -> NSInteger {
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        let component: NSDateComponents = calendar.components(NSCalendar.Unit.year, from: self as Date) as NSDateComponents
        return component.year;
    }
    //Function will reutrn the current month Number
    func  get_Month() -> NSInteger {
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        let component: NSDateComponents = calendar.components(NSCalendar.Unit.month, from: self as Date) as NSDateComponents
        return component.month;
    }
    //Function Will return the number of day of the month.
    func  get_Day() -> NSInteger {
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        let component: NSDateComponents = calendar.components(NSCalendar.Unit.day, from: self as Date) as NSDateComponents
        return component.day;
    }
    //Will return the number day of week. like Sunday =1 , Monday = 2
    func  get_WeekDay() -> NSInteger {
        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        let component: NSDateComponents = calendar.components(NSCalendar.Unit.weekday, from: self as Date) as NSDateComponents
        return component.weekday;
    }
}

// Weekday
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date()).capitalized
        // or capitalized(with: locale)
    }
}

//print(Date().dayOfWeek()!) // Wednesday

// Month Name
extension Date {
    func monthName() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: Date()).capitalized
        // or capitalized(with: locale)
    }
}

//print(Date().monthName()!) // October
