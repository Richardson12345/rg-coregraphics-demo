//
//  CombineLayerViewController.swift
//  RG-coregraphics-ppt
//
//  Created by mac on 08/12/20.
//

import UIKit

class CombineLayerViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let image: UIImage! = UIImage(named: "stockholm-min")
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        // Do any additional setup after loading the view.
    }
    
    func setupImageView() {
        imageView.image = image
    }

    @IBAction func blenLayerTaped(_ sender: Any) {
        imageView.image = ImageFilter().addGhost(to: imageView.image!)
        imageView.image = ImageFilter().applyFilter(.grayscale, to: imageView.image!)
        
    }

}
