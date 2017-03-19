//
//  CirculateScrollview.m
//  adTest
//
//  Created by 吴柳燕 on 2017/3/19.
//  Copyright © 2017年 吴柳燕. All rights reserved.
//  参考链接：http://www.jb51.net/article/103066.htm
//

#import "CirculateScrollview.h"


#define ViewWidth self.frame.size.width
#define ViewHeight self.frame.size.height
#define AllImageCount self.imageArray.count-1

@interface CirculateScrollview()<UIScrollViewDelegate>
{
    NSInteger endImageCount;//左边图片
    NSInteger oneImageCount;//中间图片[当前看到的图片]
    NSInteger secondImageCount;//右边图片
}
@property (nonatomic,strong)UIImageView *endImageView;
@property (nonatomic,strong)UIImageView *oneImageView;
@property (nonatomic,strong)UIImageView *secondImageView;
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation CirculateScrollview


-(instancetype)initWithFrame:(CGRect)frame WithImageArr:(NSArray *)imageArr autoNextpageDurationTime:(CGFloat)durationTime
{
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(imageArr.count >= 1, @"CirculateScrollview未设置图片或图片数为0");
        self.imageArray = [NSMutableArray arrayWithArray: imageArr];
        self.autoNextpageDurationTime = durationTime;
        
    }
    return self;
}

-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}

- (void)drawRect:(CGRect)rect {
    self.circulateScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
    
    endImageCount = self.imageArray.count-1;
    oneImageCount = 0;
    secondImageCount = 1;
    
    self.circulateScrollView.showsHorizontalScrollIndicator = NO;
    self.circulateScrollView.pagingEnabled = YES;
    self.circulateScrollView.delegate = self;
    self.circulateScrollView.bounces = NO;
    
    self.circulateScrollView.contentOffset = CGPointMake(ViewWidth, 0);
    
    self.backgroundColor = [UIColor whiteColor];
    
    if (!self.imageArray.count) {
        NSLog(@"图片数组为空");
        return;
    }
    
  
    UITapGestureRecognizer *imagetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectImageView)];
   
    
    
    //若广告数量少于2张则不采用三屏复用技术
    if (self.imageArray.count<=1){
        self.circulateScrollView.contentSize = CGSizeMake(ViewWidth, ViewHeight);
        
        self.endImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        self.endImageView.image = self.imageArray[endImageCount];
        self.endImageView.userInteractionEnabled = YES;
        [self.endImageView addGestureRecognizer:imagetap];

        [self.circulateScrollView addSubview:self.endImageView];
        [self addSubview:self.circulateScrollView];
        
    }else{
        self.circulateScrollView.contentSize = CGSizeMake(ViewWidth*3, ViewHeight);
        
        //左
        self.endImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        self.endImageView.image = self.imageArray[endImageCount];
        [self.circulateScrollView addSubview:self.endImageView];
        //中
        self.oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth, 0, ViewWidth, ViewHeight)];
        self.oneImageView.image = self.imageArray[oneImageCount];
        self.oneImageView.userInteractionEnabled = YES;
        [self.oneImageView addGestureRecognizer:imagetap];
        [self.circulateScrollView addSubview:self.oneImageView];
        //右
        self.secondImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth*2, 0, ViewWidth, ViewHeight)];
        self.secondImageView.image = self.imageArray[secondImageCount];
        [self.circulateScrollView addSubview:self.secondImageView];
        [self addSubview:self.circulateScrollView];
        [self pageNumControl];
        
        if (self.autoNextpageDurationTime > 0) {
            __weak typeof(self) weakSelf = self;
           self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoNextpageDurationTime repeats:YES block:^(NSTimer * _Nonnull timer) {
               //翻到下一页
               if (self.autoNextpageAnimationTime <= 0) {
                   self.autoNextpageAnimationTime = 0.2f;
               }
               [UIView animateWithDuration:self.autoNextpageAnimationTime animations:^{
                     weakSelf.circulateScrollView.contentOffset = CGPointMake(ViewWidth*2, 0);
               }];
             
               [weakSelf resetTheScrollView];
            }];
        }
    }
    
    
    
    
    
}

-(void)didSelectImageView
{
    if ([self.delegate respondsToSelector:@selector(circulateScrollview:didSelectItemWithIndex:)]) {
         [self.delegate circulateScrollview:self didSelectItemWithIndex:oneImageCount];
    }
   
}

//添加页符
-(void)pageNumControl
{
    if (!self.pageCtl) {
        self.pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, ViewHeight-20, ViewWidth, 20)];
        self.pageCtl.backgroundColor = [UIColor lightGrayColor];
        self.pageCtl.currentPageIndicatorTintColor = [UIColor greenColor];
        self.pageCtl.pageIndicatorTintColor = [UIColor whiteColor];
        self.pageCtl.alpha = 0.7;
    }
    self.pageCtl.numberOfPages = AllImageCount+1;
    [self addSubview:self.pageCtl];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
    if (self.timer) {
       [self.timer setFireDate:[NSDate distantFuture]];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");

     if (self.timer) {
         [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.autoNextpageDurationTime]];
     }
    [self resetTheScrollView];
}
-(void)resetTheScrollView
{
    if (self.circulateScrollView.contentOffset.x == 0) {
        endImageCount--;
        oneImageCount--;
        secondImageCount--;
        if (endImageCount<0) {
            endImageCount = AllImageCount;
        }else if (oneImageCount<0){
            oneImageCount = AllImageCount;
        }
        //适配2张图片
        if (secondImageCount<0){
            secondImageCount = AllImageCount;
        }
        //NSLog(@"endImageCount=%ld oneImageCount=%ld secondImageCount=%ld",endImageCount,oneImageCount,secondImageCount);
        
    }else if(self.circulateScrollView.contentOffset.x == ViewWidth*2){
        endImageCount++;
        oneImageCount++;
        secondImageCount++;
        if (endImageCount>AllImageCount) {
            endImageCount = 0;
        }else if (oneImageCount>AllImageCount){
            oneImageCount = 0;
        }
        //适配2张图片
        if (secondImageCount>AllImageCount){
            secondImageCount = 0;
        }
    }
    //重新加载显示当前位置的图片
    self.circulateScrollView.contentOffset = CGPointMake(ViewWidth, 0);
    self.endImageView.image = self.imageArray[endImageCount];
    self.oneImageView.image = self.imageArray[oneImageCount];
    self.secondImageView.image = self.imageArray[secondImageCount];
    self.pageCtl.currentPage = oneImageCount;
}
-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
