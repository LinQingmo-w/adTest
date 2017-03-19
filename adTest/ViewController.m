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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CirculateScrollview *view = [[CirculateScrollview alloc] initWithFrame:CGRectMake(0, 0, 320, 200) WithImageArr:@[[UIImage imageNamed:@"IMG_0686.JPG"] ,[UIImage imageNamed:@"IMG_0701.JPG"],[UIImage imageNamed:@"IMG_0703.JPG"],[UIImage imageNamed:@"IMG_0702.JPG"],[UIImage imageNamed:@"yys.jpg"]/**/ ] autoNextpageDurationTime:2.0f];
    view.delegate = self;
//    UIPageControl *pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 20, 320, 20)];
//    pageCtl.backgroundColor = [UIColor redColor];
//    pageCtl.currentPageIndicatorTintColor = [UIColor orangeColor];
//    pageCtl.pageIndicatorTintColor = [UIColor blueColor];
//    pageCtl.alpha = 0.3;
//    view.pageCtl = pageCtl;
//    view.autoNextpageAnimationTime = 1.0f;
    [self.view addSubview:view];
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
