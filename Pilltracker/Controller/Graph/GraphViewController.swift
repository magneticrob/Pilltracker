//
//  GraphViewController.swift
//  Pilltracker
//
//  Created by Rob Baker on 18/05/2019.
//  Copyright © 2019 Rob Baker. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {

    @IBOutlet weak var scatterChartView: ScatterChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupChartView()
        self.setDataCount(10, range: 5)
    }
    
    func setupChartView() {
        
        // Properties
        scatterChartView.delegate = self
        scatterChartView.chartDescription?.enabled = false
        scatterChartView.dragEnabled = true
        scatterChartView.setScaleEnabled(true)
        scatterChartView.maxVisibleCount = 200
        scatterChartView.pinchZoomEnabled = true
        
        // Legend
        let l = scatterChartView.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.font = .systemFont(ofSize: 14, weight: .light)
        l.xOffset = 5
        
        // Axes setup
        
        // X Axis
        let xAxis = scatterChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        
        // Y (left) Axis
        let yAxis = scatterChartView.leftAxis
        let morningDoseTime = ChartLimitLine(limit: 730, label: "Scheduled Morning Dose Time")
        yAxis.addLimitLine(morningDoseTime)
        
        let eveningDoseTime = ChartLimitLine(limit: 1930, label: "Scheduled Evening Dose Time")
        yAxis.addLimitLine(eveningDoseTime)
        yAxis.drawLimitLinesBehindDataEnabled = true
        
        // Disable other Y (right) axis
        scatterChartView.rightAxis.enabled = false
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let values1 = (0..<count).map { (i) -> ChartDataEntry in
            let times = [724, 729, 810, 830, 729, 745, 1000, 800, 810, 930, 729, 745]
            
            let val = times[i]
            return ChartDataEntry(x: Double(i), y: Double(val))
        }
        let values2 = (0..<count).map { (i) -> ChartDataEntry in
            let times = [1920, 1950, 2020, 2200, 2300, 1920, 1950, 2020, 1800, 1950]
            let val = times[i]
            return ChartDataEntry(x: Double(i), y: Double(val))
        }
        
        let morningDoses = ScatterChartDataSet(entries: values1, label: "Morning Dose")
        morningDoses.setScatterShape(.circle)
        morningDoses.setColor(ChartColorTemplates.colorful()[0])
        morningDoses.scatterShapeSize = 8
        morningDoses.drawValuesEnabled = false
        
        let eveningDoses = ScatterChartDataSet(entries: values2, label: "Evening Dose")
        eveningDoses.setScatterShape(.circle)
        eveningDoses.scatterShapeHoleColor = ChartColorTemplates.colorful()[3]
        eveningDoses.scatterShapeHoleRadius = 3.5
        eveningDoses.setColor(ChartColorTemplates.colorful()[1])
        eveningDoses.scatterShapeSize = 8
        eveningDoses.drawValuesEnabled = false
        
        let data = ScatterChartData(dataSets: [morningDoses, eveningDoses])
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))

        scatterChartView.data = data
    }
}

extension GraphViewController: ChartViewDelegate {
    
}
