//
//  ChartVC.swift
//  DemoApp
//
//  Created by VAIBHAV JOSHI on 12/04/21.
//

import UIKit

class ChartVC: UIViewController {
    
    //MARK:- Interface Builder Outlet Methods
    @IBOutlet private weak var chartView: SimplePieChartView!
    var dataArray: [TructData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dispatchedPayload = 0
        var waitingPayload = 0
        dataArray.forEach { (data) in
            if let payload = data.max_payload {
                if(data.status == "on_road") {
                    dispatchedPayload += payload
                }
                else {
                    waitingPayload += payload
                }
            }
        }
        chartView.segments = [Segment(color: .systemRed, value: CGFloat(dispatchedPayload)),
                              Segment(color: .systemGreen, value: CGFloat(waitingPayload))]
    }
}
