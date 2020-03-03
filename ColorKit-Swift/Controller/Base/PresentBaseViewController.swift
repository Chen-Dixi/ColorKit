//
//  PresentBaseViewController.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/13.
//  Copyright © 2018年 Dixi-Chen. All rights reserved.
//

import UIKit

class PresentBaseViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissvc))
        self.modalPresentationStyle = .fullScreen
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    private func dismissvc(){
        dismiss(animated: true, completion: nil)
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if(motion == UIEvent.EventSubtype.motionShake){
            dismiss(animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
