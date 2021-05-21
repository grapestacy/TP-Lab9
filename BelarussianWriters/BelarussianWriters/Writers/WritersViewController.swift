//
//  WritersViewController.swift
//  BelarussianWriters
//
//  Created by Stacy Vinogradova on 29.04.21.
//

import UIKit

class WritersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
   
    @IBOutlet weak var writersCollectionView: UICollectionView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var signOutButton: UIButton!
    static func newInstance() -> WritersViewController {
        return UIViewController.newInstance(of: WritersViewController.self)
    }
    
    var userDefaults = UserDefaults.standard
    var userid = 0
    var writers: [Writer] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        let name = userDefaults.object(forKey: "login\(userid)") as! String
        welcomeLabel.text = "welcome".localized + name
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "WriterCollectionViewCell", bundle: nil)
        writersCollectionView.register(nib, forCellWithReuseIdentifier: "WriterCollectionViewCell")
        writersCollectionView.dataSource = self
        writersCollectionView.delegate = self

        
        
        
        
        signOutButton.setTitle("signOut".localized, for: .normal)
       
    
        
        var writersDict: NSDictionary?
         if let path = Bundle.main.path(forResource: "Writers", ofType: "plist") {
            writersDict = NSDictionary(contentsOfFile: path)
         }
        for (writerID, writerInfo) in writersDict ?? [:] {
            if let writerInfoDict = writerInfo as? NSDictionary,
               let name = writerInfoDict["name"] as? String,
               let books = writerInfoDict["books"] as? String,
               let picture = writerInfoDict["picture"] as? String,
               let date = writerInfoDict["date"] as? String {
                var writer = Writer(name: name, books: books, picture: picture, date: date)
                writers.append(writer)
            }
               
        }
    
        print("test")
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        userDefaults.setValue(0, forKey: "isUserActive\(userid)")
        LoginViewController.newInstance().changeToRootViewController()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return writers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WriterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WriterCollectionViewCell", for: indexPath) as! WriterCollectionViewCell
        cell.imageView.image = UIImage(named: writers[indexPath.row].picture)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedVC = DetailedWriterViewController.newInstance()
        detailedVC.image = UIImage(named: writers[indexPath.row].picture) ?? UIImage()
        detailedVC.name = writers[indexPath.row].name
        detailedVC.date = writers[indexPath.row].date
       detailedVC.books = writers[indexPath.row].books
        navigationController?.pushViewController(detailedVC, animated: true)
    }

    
}
