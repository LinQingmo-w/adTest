//
//  CirculateScrollview.h
//  adTest
//
//  Created by 吴柳燕 on 2017/3/19.
//  Copyright © 2017年 吴柳燕. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CirculateScrollview;
@protocol CirculateScrollviewProtocol <NSObject>
@optional
-(void)circulateScrollview:(CirculateScrollview *)CirculateScrollview didSelectItemWithIndex:(NSInteger)currentIndex;

@end

@interface CirculateScrollview : UIView

@property (nonatomic, strong) NSMutableArray *imageArray;//图片数组
@property (nonatomic, strong) UIScrollView *circulateScrollView;//广告
@property (nonatomic, assign) NSInteger currentIndex;//当前第几个
@property (nonatomic, weak) id<CirculateScrollviewProtocol>delegate;

//自定义项，需要了在初始化时自定义，否则按默认显示
@property (nonatomic, assign) BOOL isAutoNextPage;//是否自动翻页，默认yes,不设置自动翻页时间则默认2s
@property (nonatomic, assign) CGFloat autoNextpageDurationTime;//自动翻页间隔时间
@property (nonatomic, assign) BOOL noAnimation;//是否不显示翻页动画 默认有动画
@property (nonatomic, assign) CGFloat autoNextpageAnimationTime;//自动翻页动画时间，默认0.2f
@property (nonatomic, assign) BOOL isShowPageBtn;//是否显示下一页按钮 默认不显示
@property (nonatomic, retain) UIButton *nextbtn;//上一页按钮，用于自定义view
@property (nonatomic, retain) UIButton *preBtn;//下一页按钮，用于自定义view
@property (nonatomic, assign) BOOL isShowPageCtl;//是否显示翻页下标 默认显示
@property (nonatomic, strong)UIPageControl *pageCtl;//自定义翻页下标，可定义背景色等页面常量，个数由数组下标决定，不需自定义

/**
 创建view

 @param frame 大小
 @param imageArr 数据源（之后可以改）
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame WithImageArr:(NSArray *)imageArr;

/**
 初始化方法

 @param frame 大小
 @param imageArr 数据源（之后可以改）
 @param autoNextpage 是否自动翻页
 @param animation 是否有翻页动画
 @param showPageBtn 是否显示下一页按钮
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame WithImageArr:(NSArray *)imageArr autoNextpage:(BOOL)autoNextpage animation:(BOOL)animation showPageBtn:(BOOL)showPageBtn ;


/**
 下一页
 */
- (void)nextPage;

/**
 上一页
 */
- (void)previousPage;

/**
 刷新动画
 */
- (void)reloadScrollView;//刷新页面


/*
 图片转换NSData方法
 测试可用
 NSData * data = UIImageJPEGRepresentation(image, 1);
 */

@end
