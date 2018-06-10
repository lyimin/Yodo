//
//  YodCalendarView.swift
//  Yod
//
//  Created by eamon on 2018/6/7.
//  Copyright © 2018年 com.eamon. All rights reserved.
//

import UIKit
import CVCalendar

class YodCalendarView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = YodConfig.color.rgb(red: 30, green: 33, blue: 40)
        
        weekView = CVCalendarMenuView()
        weekView.delegate = self
        addSubview(weekView)
        
        calendarView = CVCalendarView()
        calendarView.calendarAppearanceDelegate = self
        calendarView.delegate = self
        addSubview(calendarView)
        
        
        weekView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.height.equalTo(20)
        }
        
        calendarView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(weekView.snp.bottom)
            make.height.equalTo(350)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        weekView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }

    //MARK: - Getter | Setter
    
    var currentCalendar: Calendar = Calendar(identifier: .gregorian)
    
    /// 星期
    private var weekView: CVCalendarMenuView!
    
    /// 日历
    private var calendarView: CVCalendarView!
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
