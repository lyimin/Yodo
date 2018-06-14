//
//  YodCalendarView.swift
//  Yod
//
//  Created by eamon on 2018/6/7.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import CVCalendar

let CalendarView = YodCalendarView(frame: UIScreen.main.bounds)

class YodCalendarView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(coverView)
        addSubview(contentView)
        
        contentView.addSubview(weekView)
        contentView.addSubview(calendarView)
        
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        weekView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    public func show() {
        
    }
    
  
    //MARK: - Getter | Setter
    
    var currentCalendar: Calendar = Calendar(identifier: .gregorian)
    
    /// 遮盖层
    private lazy var coverView: UIView = {
        
        var coverView = UIView()
        coverView.backgroundColor = .black
        coverView.alpha = 0.3
        return coverView
    }()
    
    private lazy var contentView: UIView = {
        
        var contentView = UIView()
        contentView.backgroundColor = YodConfig.color.rgb(red: 30, green: 33, blue: 40)
        return contentView
    }()
    
    /// 星期
    private lazy var weekView: CVCalendarMenuView = {
        
        var weekView = CVCalendarMenuView()
        weekView.delegate = self
        return weekView
    }()
    
    /// 日历
    private lazy var calendarView: CVCalendarView = {
        
        var calendarView = CVCalendarView()
        calendarView.calendarAppearanceDelegate = self
        calendarView.delegate = self
        return calendarView
    }()
}

extension YodCalendarView: CVCalendarMenuViewDelegate, CVCalendarViewDelegate {
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
        return false
    }
    
    /// 取消自动选择月份第一天
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func shouldScrollOnOutDayViewSelection() -> Bool {
        return false
    }
    
    func shouldAnimateResizing() -> Bool {
        return false
    }
}

extension YodCalendarView: CVCalendarViewAppearanceDelegate {
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        if status == .out {
            return YodConfig.color.rgb(red: 200, green: 200, blue: 200, alpha: 0.3)
        }
        return .white
    }
    
//    @objc optional func dayLabelWeekdaySelectedTextColor() -> UIColor
}

// MARK: - Private
extension YodCalendarView {
    
    private func setupLayout() {
        
        coverView.snp.makeConstraints { (make) in
            <#code#>
        }
        
        weekView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(contentView)
            make.height.equalTo(20)
        }
        
        calendarView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(weekView.snp.bottom)
//            make.height.equalTo(350)
        }
    }
}