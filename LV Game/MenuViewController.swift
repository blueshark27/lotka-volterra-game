//
//  TestViewController.swift
//  LV Game
//
//  Created by Steffen Hauth on 02.01.22.
//

import UIKit

class MenuViewController: UIViewController
{
    @IBOutlet weak var buttonOptions: UIButton!
    @IBOutlet weak var buttonPlay: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //navigationItem.title = "Startpage"
    }
    
    @IBAction func onPlayButton(sender: UIButton, forEvent event: UIEvent)
    {
        let gameVC = self.storyboard!.instantiateViewController(identifier: "GameViewController")
        self.navigationController?.pushViewController(gameVC, animated: true)
    }

    @IBAction func onOptionsButton(sender: UIButton, forEvent event: UIEvent)
    {
        let optionsVC = self.storyboard!.instantiateViewController(identifier: "OptionsViewController")
        self.navigationController?.pushViewController(optionsVC, animated: true)
    }
}
