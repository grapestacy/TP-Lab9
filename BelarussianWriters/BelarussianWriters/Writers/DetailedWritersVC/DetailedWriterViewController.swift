//
//  DetailedWriterViewController.swift
//  BelarussianWriters
//
//  Created by Ivan Zhuravskiy on 30.04.21.
//

import UIKit

class DetailedWriterViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var booksLabel: UILabel!
    
    var image = UIImage()
    var name = ""
    var books = ""
    var date = ""
    
    
    static func newInstance() -> DetailedWriterViewController {
        return UIViewController.newInstance(of: DetailedWriterViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        nameLabel.text = name.localized
        dateLabel.text = date.localized
        booksLabel.text = books.localized
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
