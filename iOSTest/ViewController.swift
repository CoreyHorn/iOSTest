//
//  ViewController.swift
//  iOSTest
//
//  Created by Corey Horn on 2/1/19.
//  Copyright © 2019 Snag. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let events = PublishSubject<Event>()

//    var presenter: Presenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        Observable.just("1").subscribe(onNext: { it in
//            NSLog(it)
//        })
        
//        presenter = Presenter(events: events)
        
//        presenter.state.drive(onNext: { state in
//            state.
//        })
    }


}

