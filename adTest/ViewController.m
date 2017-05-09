//
//  ViewController.m
//  adTest
//
//  Created by 吴柳燕 on 2017/3/19.
//  Copyright © 2017年 吴柳燕. All rights reserved.
//

#import "ViewController.h"
#import "CirculateScrollview.h"

@interface ViewController ()<CirculateScrollviewProtocol>
@property (nonatomic, retain) CirculateScrollview *circleView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     _circleView = [[CirculateScrollview alloc] initWithFrame:CGRectMake(0, 0, 320, 200) WithImageArr:@[[UIImage imageNamed:@"IMG_0686.JPG"]] autoNextpage:YES animation:YES showPageBtn:NO];
  
    _circleView.delegate = self;
    
//    UIPageControl *pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 20, 320, 20)];
//    pageCtl.backgroundColor = [UIColor redColor];
//    pageCtl.currentPageIndicatorTintColor = [UIColor orangeColor];
//    pageCtl.pageIndicatorTintColor = [UIColor blueColor];
//    pageCtl.alpha = 0.3;
//    view.pageCtl = pageCtl;
    //    view.autoNextpageAnimationTime = 1.0f;
 
    [self.view addSubview:_circleView];
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _circleView.imageArray =@[[UIImage imageNamed:@"IMG_0686.JPG"] ,[UIImage imageNamed:@"IMG_0701.JPG"],[UIImage imageNamed:@"IMG_0703.JPG"],[UIImage imageNamed:@"IMG_0702.JPG"],[UIImage imageNamed:@"yys.jpg"]].mutableCopy;
        [_circleView reloadScrollView];
//    });
}
-(void)circulateScrollview:(CirculateScrollview *)CirculateScrollview didSelectItemWithIndex:(NSInteger)currentIndex
{
     NSLog(@"selectOne %ld" , (long)currentIndex );
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
