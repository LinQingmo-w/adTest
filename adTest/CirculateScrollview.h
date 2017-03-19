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

@property (nonatomic,strong)NSMutableArray *imageArray;//图片数组
@property (nonatomic,strong)UIScrollView *circulateScrollView;//广告
@property (nonatomic,assign)CGFloat autoNextpageDurationTime;//自动翻页间隔时间
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,weak)id<CirculateScrollviewProtocol>delegate;
//自定义项，需要了在初始化时自定义，否则按默认显示
@property (nonatomic,assign)CGFloat autoNextpageAnimationTime;//自动翻页动画时间，默认0.2f
@property (nonatomic,strong)UIPageControl *pageCtl;//自定义翻页下标，可定义背景色等页面常量，个数由数组下标决定，不需自定义

-(instancetype)initWithFrame:(CGRect)frame WithImageArr:(NSArray *)imageArr autoNextpageDurationTime:(CGFloat)durationTime;

/*
 三屏复用广告
 适用范围:网络请求或固定本地的广告图片
 适用所有数量广告，广告>=2时自动采用三屏复用技术,定时自动翻页，当设置时间为0的时候不自动翻页
 使用方法:例
 在需要添加广告的控制器里面
 
 CirculateScrollview *view = [[CirculateScrollview alloc] initWithFrame:CGRectMake(0, 0, 320, 200) WithImageArr:@[[UIImage imageNamed:@"IMG_0686.JPG"] ,[UIImage imageNamed:@"IMG_0701.JPG"],[UIImage imageNamed:@"IMG_0703.JPG"],[UIImage imageNamed:@"IMG_0702.JPG"],[UIImage imageNamed:@"yys.jpg"] ] time:3.0f];
view.delegate = self;
[self.view addSubview:view];


 
 */


/*
 图片转换NSData方法
 测试可用
 NSData * data = UIImageJPEGRepresentation(image, 1);
 */

@end
