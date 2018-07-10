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
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
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
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = YodConfig.color.rgb(red: 30, green: 33, blue: 40)
        return contentView
    }()
    
    /// 标题
    private lazy var titleLabel: UILabel = {
        
        var titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = YodConfig.font.bold(size: 18)
        titleLabel.text = "选择日期"
        return titleLabel
    }()
    
    /// 年月份
    private lazy var dateLabel: UILabel = {
        
        var dateLabel = UILabel()
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        dateLabel.font = YodConfig.font.bold(size: 16)
        dateLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        return dateLabel
    }()
    
    /// 星期
    private lazy var weekView: CVCalendarMenuView = {
        
        var weekView = CVCalendarMenuView()
        weekView.menuViewDelegate = self
        return weekView
    }()
    
    /// 日历
    private lazy var calendarView: CVCalendarView = {
        
        var calendarView = CVCalendarView()
        calendarView.calendarAppearanceDelegate = self
        calendarView.calendarDelegate = self
        return calendarView
    }()
}

extension YodCalendarView: CVCalendarMenuViewDelegate, CVCalendarViewDelegate {
    
    // 日历类型
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    // 第一个星期
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    func shouldShowCustomSingleSelection() -> Bool {
        return true
    }
    
    // 日期更新时调用
    func presentedDateUpdated(_ date: CVDate) {
        dateLabel.text = date.globalDescription
    }
    
    // 标题样式
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .short
    }
    
    /// 取消横线
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
        return false
    }
    
    /// 取消自动选择月份第一天
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    /// 是否显示下个月和上个月
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func shouldAnimateResizing() -> Bool {
        return true
    }
    
    func shouldSelectDayView(_ dayView: DayView) -> Bool {
        if dayView.isOut {
            return false
        }
        
        return true
    }
    
    /// 日历滚动范围不能小于2016-01-01
    func disableScrollingBeforeDate() -> Date {
        return Date.start()
    }
    
    /// 日历滚动范围不能大于当前日期
    func disableScrollingBeyondDate() -> Date {
        return Date()
    }
}

extension YodCalendarView: CVCalendarViewAppearanceDelegate {
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        if status == .disabled {
            return YodConfig.color.rgb(red: 200, green: 200, blue: 200, alpha: 0.3)
        }
        return .white
    }
    
    func dayLabelPresentWeekdaySelectedBackgroundColor() -> UIColor {
        return .green
    }
    
    func dayLabelPresentWeekdayHighlightedBackgroundColor() -> UIColor {
        return .yellow
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        return YodConfig.color.theme
    }
}

// MARK: - Private
extension YodCalendarView {
    
    private func setupLayout() {
        
        coverView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self)
            make.height.equalTo(self.snp.width).multipliedBy(4/3)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView).offset(20)
            make.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        
        weekView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        
        calendarView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.top.equalTo(weekView.snp.bottom)
        }
    }
}
