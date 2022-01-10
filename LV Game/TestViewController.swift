//
//  TestViewController.swift
//  LV Game
//
//  Created by Steffen Hauth on 02.01.22.
//

import UIKit

class TestViewController: UIViewController
{
    @IBOutlet weak var buttonOptions: UIBarButtonItem!
    @IBOutlet weak var buttonTest: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //navigationItem.title = "Startpage"
    }
    
    @IBAction func onTestButton(sender: UIBarButtonItem, forEvent event: UIEvent)
    {
        //self.navigationController?.popViewController(animated:true)
        let gameVC = self.storyboard!.instantiateViewController(identifier: "GameViewController")
        self.navigationController?.pushViewController(gameVC, animated: true)
    }

    @IBAction func onOptionsButton(sender: UIBarButtonItem, forEvent event: UIEvent)
    {
        let optionsVC = self.storyboard!.instantiateViewController(identifier: "OptionsViewController")
        self.navigationController?.pushViewController(optionsVC, animated: true)
    }
}
