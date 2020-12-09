//
//  CanvasViewController.swift
//  RG-coregraphics-ppt
//
//  Created by mac on 07/12/20.
//

import UIKit

class CanvasViewController: UIViewController {

    let canvas = Canvas()
    
    let undoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Undo", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUndo), for: .touchUpInside)
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("clear", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
        return button
    }()
    
    let yellowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .yellow
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    let redButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    let blueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.addTarget(self, action: #selector(handleSliderChanged), for: .valueChanged)
        return slider
    }()
    
    @objc fileprivate func handleUndo() {
        canvas.undo()
    }
    
    @objc fileprivate func handleClear() {
        canvas.clear()
    }
    
    @objc fileprivate func handleColorChange(button: UIButton) {
        canvas.setStrokeColor(color: button.backgroundColor!)
    }
    
    @objc fileprivate func handleSliderChanged() {
        canvas.setStrokeWidth(width: slider.value)
    }
    
    override func loadView() {
        self.view = canvas
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        view.addSubview(canvas)
        //        canvas.frame = view.frame
        canvas.backgroundColor = .white
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        // Do any additional setup after loading the view.
        let colorStackView = UIStackView(arrangedSubviews: [
            yellowButton,
            redButton,
            blueButton
        ])
        colorStackView.distribution = .fillEqually
        
        let stackView = UIStackView(arrangedSubviews: [
            undoButton,
            clearButton,
            colorStackView,
            slider
        ])
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
    }


}
