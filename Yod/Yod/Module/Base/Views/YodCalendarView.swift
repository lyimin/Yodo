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
        
        initData()
        
        addSubview(coverView)
        addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(todayLabel)
        contentView.addSubview(todayRightBtn)
        contentView.addSubview(dateLabel)
        contentView.addSubview(weekView)
        contentView.addSubview(calendarView)
        
        setupLayout()
        
        dateLabel.text = currDate.desc
        calendarView.presentedDate = currDate
    }

    private func initData() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "zh-CN")
        currCalendar = calendar
        
        currDate = CVDate(date: date, calendar: calendar)
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
        UIView.animate(withDuration: 0.2) {
            self.coverView.alpha = 0.5
            self.contentView.alpha = 1
            self.contentView.transform = CGAffineTransform.identity
        }

    }
    
    @objc public func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.coverView.alpha = 0
            self.contentView.alpha = 0
            self.contentView.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    //MARK: - Getter | Setter
    public var date: Date = Date()
    private var currCalendar: Calendar!
    private var currDate: CVDate!
    
    typealias SelectedDateCallBack = (_ date: YodDate) -> Void
    
    public var callBack: SelectedDateCallBack?
    
    /// 遮盖层
    private lazy var coverView: UIView = {
        
        var coverView = UIView()
        coverView.viewAddTarget(target: self, action: #selector(dismiss))
        coverView.backgroundColor = .black
        coverView.alpha = 0
        return coverView
    }()
    
    private lazy var contentView: UIView = {
        
        var contentView = UIView()
        contentView.alpha = 0
        contentView.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        contentView.layer.cornerRadius = 20
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
    
    /// 今日
    private lazy var todayLabel: UILabel = {
        
        var todayLabel = UILabel()
        todayLabel.textColor = .white
        todayLabel.font = YodConfig.font.bold(size: 18)
        todayLabel.text = Date().format(withDateFormat: "yyyy年MM月dd日")
        return todayLabel
    }()
    
    private lazy var todayRightBtn: UIButton = {
        
        var today = UIButton()
        today.setBackgroundImage(UIImage(color: YodConfig.color.rgb(red: 39, green: 41, blue: 49)), for: .normal)
        today.layer.cornerRadius = 20
        today.titleLabel?.font = YodConfig.font.bold(size: 16)
        today.setTitleColor(YodConfig.color.gary.withAlphaComponent(0.4), for: .normal)
        today.setTitle("今天", for: .normal)
        today.isUserInteractionEnabled = false
        return today
    }()
    
    /// 年月份
    private lazy var dateLabel: UILabel = {
        
        var dateLabel = UILabel()
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        dateLabel.font = YodConfig.font.bold(size: 16)
        return dateLabel
    }()
    
    /// 星期
    private lazy var weekView: CVCalendarMenuView = {
        
        var weekView = CVCalendarMenuView()
        weekView.calendar = currCalendar
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
    
    // 日期更新时调用
    func presentedDateUpdated(_ date: CVDate) {
        dateLabel.text = date.desc
    }
    
    /// 是否显示下个月和上个月
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func shouldAnimateResizing() -> Bool {
        return true
    }
    
    /// 取消自动选择月份第一天
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        
        return false
    }
    
    // 标题样式
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .short
    }
    
    /// 只能选中单个日期
    func shouldShowCustomSingleSelection() -> Bool {
        return true
    }
    
    /// 取消横线
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
        return false
    }

    
    func shouldSelectDayView(_ dayView: DayView) -> Bool {
        if dayView.isOut {
            return false
        }
        
        return true
    }
    
    // 选中日期后回调
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        delay(delay: 0.2) {
            self.dismiss()
            if let callback = self.callBack {
                callback(YodDate(date: dayView.date.callbackDesc))
            }
        }
    }
    
    /// 最迟的可选时间（今日）
    func latestSelectableDate() -> Date {
        return Date()
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
    
    
    // 日期栏
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        
        if status == .disabled {
            return YodConfig.color.gary.withAlphaComponent(0.4)
        }
        return .white
    }
    
    func dayLabelWeekdayFont() -> UIFont {
        return YodConfig.font.bold(size: 14)
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        return YodConfig.color.theme
    }
    
    
    // 星期栏
    
    func dayOfWeekTextColor() -> UIColor {
        return YodConfig.color.gary.withAlphaComponent(0.6)
    }
    
    func dayOfWeekFont() -> UIFont {
        return YodConfig.font.bold(size: 14)
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
            make.height.equalTo(500)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView).offset(30)
            make.height.equalTo(20)
        }
        
        todayRightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        todayLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(todayRightBtn.snp.left).offset(-10)
            make.centerY.height.equalTo(todayRightBtn)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(todayLabel.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        
        weekView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
            make.height.equalTo(20)
        }
        
        calendarView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
            make.top.equalTo(weekView.snp.bottom)
            make.height.equalTo(280)
        }
    }
}


extension CVDate {
    public var desc: String {
        return String(format: "%d年%02d月", year, month)
    }
    public var callbackDesc: String {
        return String(format: "%d-%02d-%02d", year, month, day)
    }
}
