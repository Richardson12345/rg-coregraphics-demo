//
//  CGDemoViewController.swift
//  RG-coregraphics-ppt
//
//  Created by mac on 08/12/20.
//

import UIKit

class CGDemoViewController: UIViewController {

    @IBOutlet weak var drawView: DrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }


    @IBAction func drawSomethingTaped(_ sender: Any) {
        drawView.startDraw()
    }
    
}
