//
//  SMSwitch.h
//
//  Created by Zeacone on 2017/1/22.
//  Copyright © 2017年 Zeacone. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SwitchType) {
    kSwitchTypePure,
    kSwitchTypeImage,
    kSwitchTypeText,
} NS_ENUM_AVAILABLE_IOS(7_0);

@protocol SMSwitchDelegate <NSObject>

- (void)isOn:(BOOL)on;

@end

@interface SMSwitch : UIControl

@property (nonatomic, weak) id<SMSwitchDelegate> delegate;


/**
 设置和获取开关状态
 */
@property (nonatomic, assign) BOOL on;


/**
 内部指示图片相对于父视图的边距，默认为3
 */
@property (nonatomic, assign) CGFloat padding;


/**
 控制开关控件大小，默认为30。具体数值关系如下：
 width = sideLength * 2 + padding * 3
 height = sideLength + padding * 2
 */
@property (nonatomic, assign) CGFloat sideLength;

@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) UIImage *rightImage;
@property (nonatomic, strong) UIImage *indicatorImage;

/**
 左边和右边指示图片的显示大小，不能超过sideLength
 */
@property (nonatomic, assign) CGSize contentImageSize;


/**
 开关在打开状态下的背景颜色
 */
@property (nonatomic, strong) UIColor *onColor;


/**
 开关在关闭状态下的背景颜色
 */
@property (nonatomic, strong) UIColor *offColor;


/**
 开关的几种显示形式
 */
@property (nonatomic, assign) SwitchType switchType;

@end
