//
//  MemeCollectionViewController.swift
//  MeMe
//
//  Created by Chantal Deguire on 2020-04-10.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties: Variables and Constants
    
    @IBOutlet weak var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let memeCollectionCellID = "MemeCollectionViewCell"
    
    var memes: [Meme]! {
        let object =  UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: - View Life Cycle
    
     override func viewDidLoad() {
           super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let widthDimension = (view.frame.size.width - (2 * space)) / 3.0
        let heightDimension = (view.frame.size.height - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
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

   
/* Just to help implement later
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailedImage = memes[(indexPath as NSIndexPath).row]
        
        let memeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = detailedImage
        
        self.navigationController!.pushViewController(memeDetailViewController, animated: true)
    }*/
    
    
}
