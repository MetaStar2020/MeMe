//
//  MemeTableViewController.swift
//  MeMe
//
//  Created by Chantal Deguire on 2020-04-10.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    let memeCellID = "MemesTableCell"
    
    var memes: [Meme]! {
        let object =  UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        print(appDelegate.memes.count)
        return appDelegate.memes
    }
    
    // MARK: - Views Control
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }

        // MARK: - Required functions for UITableViewDataSource
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: memeCellID , for: indexPath)
        print(indexPath)
       
       // Configure the cell’s contents.
        cell.imageView!.image = self.memes[indexPath.row].memedImage
        cell.textLabel!.text = self.memes[indexPath.row].topText + "..." + self.memes[indexPath.row].bottomText
        
        /*****   NEED TO IMPLEMENT:  textLabel! constraints...  and the memedImage needs to appear*/

           
       return cell
    }
    
}
