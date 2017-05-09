//
//  CirculateScrollview.m
//  adTest
//
//  Created by 吴柳燕 on 2017/3/19.
//  Copyright © 2017年 吴柳燕. All rights reserved.
//

#import "CirculateScrollview.h"
//#import <UIImageView+WebCache.h>


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
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.isAutoNextPage = YES;
    self.autoNextpageDurationTime = 2.0f;
    self.noAnimation = NO;
    self.autoNextpageAnimationTime = 0.2f;
    self.isShowPageBtn = NO;
    self.isShowPageCtl = YES;
    
    self.pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, ViewHeight-20, ViewWidth, 20)];
    self.pageCtl.currentPageIndicatorTintColor = [UIColor greenColor];
    self.pageCtl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageCtl.alpha = 1;
    
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.isAutoNextPage = YES;
        self.autoNextpageDurationTime = 2.0f;
        self.noAnimation = NO;
        self.autoNextpageAnimationTime = 0.2f;
        self.isShowPageBtn = NO;
        self.isShowPageCtl = YES;
        
        self.pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, ViewHeight-20, ViewWidth, 20)];
        self.pageCtl.currentPageIndicatorTintColor = [UIColor greenColor];
        self.pageCtl.pageIndicatorTintColor = [UIColor whiteColor];
        self.pageCtl.alpha = 1;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame WithImageArr:(NSArray *)imageArr
{
    self = [self init];
    NSAssert(imageArr.count >= 1, @"CirculateScrollview未设置图片或图片数为0");
    self.frame = frame;
    self.imageArray = [NSMutableArray arrayWithArray: imageArr];
    
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame WithImageArr:(NSArray *)imageArr autoNextpage:(BOOL)autoNextpage animation:(BOOL)animation showPageBtn:(BOOL)showPageBtn
{
    self = [self initWithFrame:frame WithImageArr:imageArr];
    self.isAutoNextPage = autoNextpage;
    
    self.isShowPageBtn = showPageBtn;
    
    return self;
}
//-(NSMutableArray *)imageArray
//{
//    if (!_imageArray) {
//        _imageArray = [[NSMutableArray alloc]init];
//    }
//    return _imageArray;
//}
- (void)reloadScrollView
{
    //    self.imageArray = [imageArr mutableCopy];
    [self drawRect:self.frame];
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
        [self imageView:self.endImageView setImageWithImage:self.imageArray[endImageCount]];
        self.endImageView.userInteractionEnabled = YES;
        [self.endImageView addGestureRecognizer:imagetap];
        
        [self.circulateScrollView addSubview:self.endImageView];
        [self addSubview:self.circulateScrollView];
        
    }else{
        self.circulateScrollView.contentSize = CGSizeMake(ViewWidth*3, ViewHeight);
        
        //左
        self.endImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        [self imageView:self.endImageView setImageWithImage:self.imageArray[endImageCount]];
        [self.circulateScrollView addSubview:self.endImageView];
        //中
        self.oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth, 0, ViewWidth, ViewHeight)];
        [self imageView:self.oneImageView setImageWithImage:self.imageArray[oneImageCount]];
        self.oneImageView.userInteractionEnabled = YES;
        [self.oneImageView addGestureRecognizer:imagetap];
        [self.circulateScrollView addSubview:self.oneImageView];
        //右
        self.secondImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth*2, 0, ViewWidth, ViewHeight)];
        [self imageView:self.secondImageView setImageWithImage:self.imageArray[secondImageCount]];
        [self.circulateScrollView addSubview:self.secondImageView];
        [self addSubview:self.circulateScrollView];
        
        if (self.isShowPageCtl) {
            [self pageNumControl];
        }
        
        
        //是否不显示动画
        if (self.noAnimation) {
            self.autoNextpageAnimationTime = 0.0f;
        }
        //是否自动翻页
        if (self.isAutoNextPage && self.autoNextpageDurationTime > 0) {
            //            __weak typeof(self) weakSelf = self;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoNextpageDurationTime target:self selector:@selector(timerBegin) userInfo:nil repeats:YES];
            
            //            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoNextpageDurationTime repeats:YES block:^(NSTimer * _Nonnull timer) {
            //                [weakSelf nextPage];
            //            }];
        }
        
        //是否显示下一页按钮
        if (self.isShowPageBtn) {
            if (!self.preBtn) {
                self.preBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
                self.preBtn.center = CGPointMake(self.preBtn.center.x ,self.frame.size.height/2);
                self.preBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
            }
            
            
            [self.preBtn addTarget:self action:@selector(preBtn) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.preBtn];
            
            if (!self.nextbtn) {
                self.nextbtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width -100, 0, 100, 80)];
                self.nextbtn.center = CGPointMake(self.nextbtn.center.x ,self.frame.size.height/2);
                self.nextbtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
            }
            [self.nextbtn addTarget:self action:@selector(nextbtn) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.nextbtn];
        }
    }
    
}
-(void)timerBegin
{
    [self nextPage];
}
- (void)nextPage
{
    
    [UIView animateWithDuration:self.autoNextpageAnimationTime animations:^{
        self.circulateScrollView.contentOffset = CGPointMake(ViewWidth*2, 0);
    }];
    
    [self resetTheScrollView];
    
}
- (void)previousPage
{
    [UIView animateWithDuration:self.autoNextpageAnimationTime animations:^{
        self.circulateScrollView.contentOffset = CGPointMake(0, 0);
    }];
    
    [self resetTheScrollView];
}

//设置图片 适配不同image类型
- (BOOL)imageView:(UIImageView *)imageView setImageWithImage:(id)image
{
    
    if ([image isKindOfClass:[NSString class]]) {
        if ([image hasPrefix:@"http"]) {
//            [imageView sd_setImageWithURL:image placeholderImage:PlaceholderImage];
        }else
        {
            imageView.image = [UIImage imageNamed:image];
        }
        return YES;
    }else if ([image isKindOfClass:[NSData class]])
    {
        imageView.image = [UIImage imageWithData:image];
        return YES;
    }else if ([image isKindOfClass:[UIImage class]])
    {
        imageView.image = image;
        return YES;
    }else
    {
        return NO;
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
    //    if (!self.pageCtl) {
    //    }
    self.pageCtl.frame = CGRectMake(0, ViewHeight-20, ViewWidth, 20);
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
    [self imageView:self.endImageView setImageWithImage:self.imageArray[endImageCount]];
    [self imageView:self.oneImageView setImageWithImage:self.imageArray[oneImageCount]];
    [self imageView:self.secondImageView setImageWithImage:self.imageArray[secondImageCount]];
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
