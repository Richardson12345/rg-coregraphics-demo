//
//  HomeSelectViewController.swift
//  RG-coregraphics-ppt
//
//  Created by mac on 07/12/20.
//

import UIKit

class HomeSelectViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let topicArr: [String] = [
        "Drawable Canvas",
        "Bitmap Filter",
        "Combine Layers",
        "Free Draw"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TopicTableViewCell", bundle: nil), forCellReuseIdentifier: "TopicTableViewCell")
    }
    
    func setupNavigation() {
//        navigationController?.navigationBar.isHidden = true
    }
    
}

extension HomeSelectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension HomeSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let defaultCell = tableView.dequeueReusableCell(withIdentifier: "TopicTableViewCell", for: indexPath) as? TopicTableViewCell {
            defaultCell.titleLabel.text = topicArr[indexPath.row]
            return defaultCell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = CanvasViewController(nibName: "CanvasViewController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = BitmapFilterViewController(nibName: "BitmapFilterViewController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = CombineLayerViewController(nibName: "CombineLayerViewController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = CGDemoViewController(nibName: "CGDemoViewController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
}
