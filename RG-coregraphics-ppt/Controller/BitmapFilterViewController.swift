//
//  BitmapFilterViewController.swift
//  RG-coregraphics-ppt
//
//  Created by mac on 07/12/20.
//

import UIKit

class BitmapFilterViewController: UIViewController {
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    let image: UIImage! = UIImage(named: "stockholm-min")
    let filterOptions = [
        "Normal",
        "Grayscale",
        "Increase Contrast"
    ]
    var currentOption = 0 {
        didSet {
            updateFilterLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImage()
        // Do any additional setup after loading the view.
    }
    
    private func setupImage() {
        imageView.image = image
    }
    
    private func updateFilterLabel() {
        filterLabel.text = filterOptions[currentOption]
    }
    
    @IBAction func tapFilterChange(_ sender: Any) {
        currentOption = currentOption == 2 ? 0 : currentOption + 1
        
        switch currentOption {
        case 0:
            imageView.image = image
        case 1:
            imageView.image = ImageFilter().applyFilter(.grayscale, to: image)
        case 2:
            imageView.image = ImageFilter().applyFilter(.increaseContrast, to: image)
        default:
            return
        }
    }
    
}
