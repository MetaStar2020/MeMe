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
    
    let memeCollectionCellID = "MemeCollectionViewCell"
    
    var memes: [Meme]! {
        let object =  UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: - View Life Cycle
    
     override func viewDidLoad() {
           super.viewDidLoad()
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
        cell.collectionImageView.image = self.memes[indexPath.row].memedImage
            
        return cell
     }
    
    /* as example for DetailView
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[(indexPath as NSIndexPath).row]
        
        let memeViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        memeViewController.meme = meme
        
        self.navigationController!.pushViewController(memeViewController, animated: true)
    }*/
    
    
}
