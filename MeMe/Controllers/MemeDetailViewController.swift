//
//  MemeDetailViewController.swift
//  MeMe
//
//  Created by Chantal Deguire on 2020-04-08.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: - Properties: Variables and Constants
    var currentMeme: Meme!
    
    //MARK: - Outlets
    @IBOutlet weak var detailedImageView: UIImageView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.detailedImageView.image = currentMeme.memedImage
       }
}
