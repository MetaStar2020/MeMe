//
//  MemeCollectionViewController.swift
//  MeMe
//
//  Created by Chantal Deguire on 2020-04-10.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController, UITextFieldDelegate {
    
    // MARK: - Properties: Variables and Constants
    
    @IBOutlet weak var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let memeCollectionCellID = "MemeCollectionViewCell"
    
    var memes: [Meme]! {
        let object =  UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    //Set NSAttributes
       let memeTextAttributes: [NSAttributedString.Key: Any] = [
           NSAttributedString.Key.strokeColor: UIColor.black,
           NSAttributedString.Key.foregroundColor: UIColor.white,
           NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
           NSAttributedString.Key.strokeWidth: -3.0,
       ]
    
    // MARK: - View Life Cycle
    
     override func viewDidLoad() {
           super.viewDidLoad()
        
        memeCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let space:CGFloat = 3.0
        let widthDimension = (view.frame.size.width - (2 * space)) / 3.0
        //let heightDimension = (view.frame.size.height - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: widthDimension)
       }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
       
         memeCollectionView!.reloadData()
     }

         // MARK: - Required functions for UITableViewDataSource
     
     // Return the number of rows for the table.
     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.memes.count
     }

     // Provide a cell object for each row.
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Fetch a cell of the appropriate type.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memeCollectionCellID , for: indexPath) as! MemeCollectionViewCell
         print(indexPath)
        
        // Configure the cell’s contents.
        cell.collectionImageView.image = self.memes[indexPath.row].originalImage
        setTextStyle(cell.topText, self.memes[indexPath.row].topText )
        setTextStyle(cell.bottomText, self.memes[indexPath.row].bottomText)
         
        return cell
     }
    
    // Prepare for Segue from selected Item
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           self.performSegue(withIdentifier: "segueCollectionVCtoDetailVC", sender: self)
       }
    // MARK: - Navigation

          // In a storyboard-based application, you will often want to do a little preparation before navigation
          override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if (segue.identifier == "segueCollectionVCtoDetailVC") {
               let destVC: MemeDetailViewController = segue.destination as! MemeDetailViewController
            let indexPath = self.memeCollectionView.indexPathsForSelectedItems?.first
               destVC.currentMeme = self.memes[indexPath!.row]
           }
          }

   // MARK: - Setting Default Texts
   
      func setTextStyle(_ textLabel: UILabel, _ defaultText: String) {
          textLabel.attributedText = NSAttributedString(string: defaultText, attributes: memeTextAttributes)
          textLabel.textAlignment = NSTextAlignment.center
          textLabel.backgroundColor = UIColor.clear
          //textLabel.delegate = self
          textLabel.adjustsFontSizeToFitWidth = true
          textLabel.text = defaultText
        
      }
    
}


