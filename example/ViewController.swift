//
//  ViewController.swift
//  example
//
//  Created by Zachary Gorak on 6/25/19.
//  Copyright © 2019 Zachary Gorak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: "https://yahoo.com")!, completionHandler: { data, response, error in
            print("Done")
        }).resume()
        
        session.dataTask(with: URL(string: "https://google.com")!).resume()
        
        session.downloadTask(with: URL(string: "https://zac.gorak.us/images/icons/github.png")!).resume()
        
        session.uploadTask(with: URLRequest(url: URL(string: "https://zac.gorak.us/put")!), from: "what".data(using: .ascii)!).resume()
    }

}

