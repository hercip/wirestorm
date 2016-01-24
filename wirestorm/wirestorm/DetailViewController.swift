//
//  DetailViewController.swift
//  wirestorm
//
//  Created by Ciprian Herman on 24/01/16.
//  Copyright © 2016 Ciprian Herman. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {


    @IBOutlet weak var imageView: UIImageView!

    var stringUrl: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let stringUrl = self.stringUrl {
            if let imageView = self.imageView {
                imageView.downloadedFrom(link: stringUrl, contentMode: .ScaleAspectFit, completionHandler: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

