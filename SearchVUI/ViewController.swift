//
//  ViewController.swift
//  SearchVUI
//
//  Created by Xiaomei Huang on 11/15/16.
//  Copyright © 2016 Xiaomei Huang. All rights reserved.
//

import UIKit
import Speech

class ViewController: UICollectionViewController, SFSpeechRecognizerDelegate,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    let images = ["the edge of seventeen", "arrival", "doctor strange", "the take", "trolls", "pete's dragon", "almost christmas", "finding dory", "the secret life of pets"]
    
    var movies = [Movie]()
    var theatres = [Theatre]()
    

    
    var blurEffect : UIBlurEffect! = nil
    var blurEffectView : UIVisualEffectView! = nil
    let window = UIApplication.shared.keyWindow!
    var task : DispatchWorkItem?

    
    var searchBar: UISearchBar!
    var microphoneButton: UIBarButtonItem!
    
    var keyWords = ""
    
    var closeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named:"close"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    var popUpView : UIView = {
        
        let view = UIView()
        var textView : UITextView = {
            let tv = UITextView()
            tv.backgroundColor = UIColor.black
            tv.textColor = UIColor.white
            tv.font = UIFont.systemFont(ofSize: 16)
            tv.translatesAutoresizingMaskIntoConstraints = false
            tv.isUserInteractionEnabled = false
            
            return tv
        }()
        
        view.addSubview(textView)
        view.addConstraintFunc(format: "H:|[v0]|", views: textView)
        view.addConstraintFunc(format: "V:[v0(180)]|", views: textView)
        
        return view
        
    } ()
    
    var textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.black
        tv.textColor = UIColor.white
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()

    
    var keywordsTxt : UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.black
        tv.textColor = UIColor.white
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    
    
    private let cellID = "cellID"
    private let headerID = "headerID"

    
    
    fileprivate let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    
    fileprivate var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    fileprivate var recognitionTask: SFSpeechRecognitionTask?
    fileprivate let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  //      print("keyword: \(self.keyWords)")

        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView?.backgroundColor = UIColor.darkGray
        // Register cell
        collectionView?.register(MovieCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)

        
        // load data:
        let url = Bundle.main.url(forResource: "all", withExtension: "json")
        let data = NSData(contentsOf: url!)
        
        do {
            let json = try(JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! [String:AnyObject])
            let ajson = json["Movies"] as! [AnyObject]
            for index in 0...(ajson.count - 1) {
                let aObject = ajson[index] as! [String : AnyObject]
                let movie = Movie()
                movie.setValuesForKeys(aObject)
                movies.append(movie)
            }
            print (movies.count)
            print(movies[0].showtimes![0].dateTime!)

        } catch let err {
            print (err)
        }
        
        loadTheatreData()
        
        
        
        
//        // add image to background
//        UIGraphicsBeginImageContext(self.view.frame.size)
//        UIImage(named: "dory")?.draw(in: self.view.bounds)
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        self.collectionView?.backgroundColor = UIColor(patternImage: image)

        
        //   Add microphone button to the right
        microphoneButton = UIBarButtonItem(image: #imageLiteral(resourceName: "microphone"), style: .plain, target: self, action: #selector(microphoneTapped))
        
        navigationItem.rightBarButtonItem = microphoneButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.red
        
        // Add location button to left
        microphoneButton = UIBarButtonItem(image:#imageLiteral(resourceName: "location"), style: .plain, target: self, action: #selector(getLocation))
        
        navigationItem.leftBarButtonItem = microphoneButton
        navigationItem.leftBarButtonItem?.tintColor = UIColor.orange

        
        
        // Add Search bar
        let frame = CGRect(x: 30, y: -8, width: 350, height: 60)
        self.searchBar = UISearchBar(frame: frame)
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        
        
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Include the search bar within the navigation bar.
        self.navigationItem.titleView = searchBar

        
        
        // keyboard
        let hideTab = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTab.numberOfTapsRequired = 1
        //cancel the hidetab function
        hideTab.cancelsTouchesInView = false
        view.addGestureRecognizer(hideTab)
        
        
        
        // blurView
        blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        

        
        speechRecognizer.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in

            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
    }
    
  func hideKeyboardTap(searchBar:UISearchBar){
     //   self.navigationController?.navigationBar.endEditing(true)
        self.searchBar.endEditing(true)
    
        print("endediting")

    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.resignFirstResponder()
        
        return true
    }
    
    
    
    func microphoneTapped(_ sender: AnyObject) {

        self.keyWords = ""
        self.microphoneButton.isEnabled = false
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
        }
        
        startRecording()

        
    //    Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(enableButton), userInfo: nil, repeats: false)
        
//        let mainQueue = DispatchQueue.main
//        let deadline = DispatchTime.now() + .seconds(3)
//        mainQueue.asyncAfter(deadline: deadline) {
//            self.enableButton()
//        }
        
        // set task after 6 sec
        self.task = DispatchWorkItem {
            self.enableButton()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 9, execute: task!)
        
        if self.microphoneButton.isEnabled == false {

        self.window.addSubview(blurEffectView)
        textView.text = "Tell us what movies, theatres you want to search?"

            
        // add popup window
        self.window.addSubview(popUpView)
            window.addConstraintFunc(format: "H:|[v0]|", views: popUpView)
            window.addConstraintFunc(format: "V:[v0(150)]|", views: popUpView)
            
        self.popUpView.addSubview(closeBtn)
        self.popUpView.addConstraintFunc(format: "H:[v0(30)]-15-|", views: closeBtn)
        self.popUpView.addConstraintFunc(format: "V:[v0(30)]-15-|", views: closeBtn)
        self.closeBtn.addTarget(self, action: #selector(closeWindow), for: .touchUpInside)
            
        self.popUpView.addSubview(textView)
        self.popUpView.addConstraintFunc(format: "H:|-15-[v0]-15-|", views: textView)
        self.popUpView.addConstraintFunc(format: "V:|-2-[v0(80)]", views: textView)
        }
    
    }
    
    // close dialog window
    func closeWindow(){
        print("close!")
        self.task?.cancel()
        self.popUpView.removeFromSuperview()
        self.blurEffectView?.removeFromSuperview()
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        self.microphoneButton.isEnabled = true
    }
    

    
    
    func enableButton() {
        
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()

        print ("keywords in enable button:\(self.keyWords)")
        self.blurEffectView?.removeFromSuperview()
        self.popUpView.removeFromSuperview()
        
        // if get the keywords from voice, go to the results view
        if !self.keyWords.isEmpty {
            self.showResults(self.keyWords)
            
            
        // if nothing heard, pop up an message for 2 second
        }
        else {
          //  print( self.view.subviews.contains(keywordsTxt))
            self.keywordsTxt.text = "Didn't hear anything, please try again!"
            self.keywordsTxt.textColor = UIColor.red
            self.view.addSubview(keywordsTxt)
            view.addConstraintFunc(format: "H:|[v0]|", views: keywordsTxt)
            view.addConstraintFunc(format: "V:|[v0(80)]", views: keywordsTxt)
            self.task = DispatchWorkItem {
                self.dismisskeywordsView()}
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: task!)
        }
  
    }
    
    func dismisskeywordsView() {
        self.keywordsTxt.removeFromSuperview()
    }
    
    
    
    @objc func showResults (_ sentences: String){

        // Initiation
        let layout = UICollectionViewFlowLayout()
        let resultsVC = ResultsVC(collectionViewLayout: layout)
        navigationController?.pushViewController(resultsVC, animated: true)
        resultsVC.sentences = sentences
        
    }
    
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // prepare for the audio reording
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        // use for pass data to apple servers
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        
        // check audio engine
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        //check recognitionRequest instantiated and not nil
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        //report partial result as user speaks
        recognitionRequest.shouldReportPartialResults = true
        
        // start recognition with completion handler
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
           // define if the recognition is final
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString
                self.keyWords = (result?.bestTranscription.formattedString)!
                print ("keywords in 1:\(self.keyWords)")
                isFinal = (result?.isFinal)!
                
            } else {
                self.keyWords = ""
                print("I can't hear you")
                print ("keywords in 2:\(self.keyWords)")
            }
            
            // stop audio input and recognitionrequest and task
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        // add audio input to recognitionrequest , it's ok to add the audio input after starting recognition task
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
    }
    
    //make sure that speech recognition is available when creating a speech recognition task
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    

    
    func getLocation (){
        print("locaion button pressed")
        searchBar.placeholder = "Grand rapids, Michigan"
    }
    
    
    // setup collection views
    // Set header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    // Return header view
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! Header
        return header
    }
    
    // return three cells
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MovieCell
        let movie = self.movies[indexPath.item]
        let img = movie.image?.lowercased()
        cell.imageView.image = UIImage(named: img!)
        cell.desLabel.text = movie.descriptn!
        cell.titleLabel.text = movie.title?.uppercased()
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    
    // from UICollectionViewDelegateFlowLayout method
    // set cell width to full view width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // default cell height
        return CGSize(width: view.frame.width, height: 180)
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("row selected")
            let movie = self.movies[indexPath.item]
            let theatres = [Theatre]()
            showMovieDetails(movie:movie,theatres:theatres)

    }
    
    
    func showMovieDetails(movie:Movie,theatres: [Theatre]){
        let layout = UICollectionViewFlowLayout()
        let movieDetailsVC = MovieDetailsVC(collectionViewLayout:layout)
        movieDetailsVC.movie = movie
        movieDetailsVC.theatres = self.theatres
        
        navigationController?.pushViewController(movieDetailsVC, animated: true)
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


}

