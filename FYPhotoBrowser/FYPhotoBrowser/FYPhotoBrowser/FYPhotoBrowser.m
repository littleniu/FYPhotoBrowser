//
//  FYPhotoBrowser.m
//  weixin图片放大
//
//  Created by Charlie on 15/7/17.
//  Copyright (c) 2015年 Swift. All rights reserved.
//

#import "FYPhotoBrowser.h"

#define kBackSizeTime 0.4

@implementation FYPhotoBrowser
{
    UIScrollView * _scrollView;//底部的scroller
   // NSArray * _array;
    UIView * _fromView;
    UIPageControl * _pageControl;
    NSInteger _index;
    UIImageView * _currentView ;
    BOOL isFirstShow;
    NSInteger currentIndex ;
    
    CGFloat _lastScale;
    
}
@synthesize imagesUrlArray = _array;
@synthesize index = _index ;
-(instancetype)initWithImageUrlString:(NSArray *)urlArray atIndex:(NSInteger)index FromView:(UIView *)fromView
{
       if ( self = [super initWithFrame:kScreenBounds]) {
        self.backgroundColor = [UIColor blackColor];
        _array = [NSArray arrayWithArray:urlArray];
        self.index = index ;
        _fromView = fromView;
        return self ;
    }
    return  nil ;
}
-(void)configUI{
    _lastScale = 1.0 ;
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.backgroundColor =[UIColor blackColor];
    
    _scrollView.contentOffset  = CGPointMake(kScreenWidth * _index, 0) ;
    _scrollView.delegate = self ;
    _scrollView.pagingEnabled = YES ;
    _scrollView.showsHorizontalScrollIndicator = NO ;
    _scrollView.showsVerticalScrollIndicator = NO ;
    [self addSubview:_scrollView];
    
    NSInteger imagesCount ;
    if (self.imagesUrlArray.count) {
        imagesCount = self.imagesUrlArray.count ;
    }else if (self.imagesArray.count){
        imagesCount = self.imagesArray.count ;
    }
    _scrollView.contentSize = CGSizeMake(kScreenWidth * imagesCount, kScreenHeight);
    for (int i = 0; i < imagesCount; i ++) {
        UIImageView * imageV= [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
        UIImage * defaultImage = nil; //默认图
        if (i == self.index) {
            defaultImage = _currentView.image ;
        }else{
            if (self.imagesArray.count > i) {
                defaultImage = self.imagesArray[i];
            }
        }
        MBProgressHUD * hud = [[MBProgressHUD alloc]init];
        hud.mode = MBProgressHUDModeAnnularDeterminate ;
        
        
        if (self.isFromNet) {
            [imageV addSubview:hud];
            [hud show:YES];
            [imageV sd_setImageWithURL:[NSURL URLWithString:_array[i]] placeholderImage:defaultImage options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                hud.progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [hud hide:YES];
            }];

        }else if (self.imagesArray.count > i){
            imageV.image = [self.imagesArray objectAtIndex:i];
        }
        imageV.contentMode =  UIViewContentModeScaleAspectFit ;
        imageV.tag = i ;
        imageV.userInteractionEnabled = YES ;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide:)];
        [imageV addGestureRecognizer:tap];
        
        UIPinchGestureRecognizer * pin =[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaleImage:)];
        [imageV addGestureRecognizer:pin];
        
        UIScrollView * scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
        scroll.minimumZoomScale = 0.5f;
        scroll.maximumZoomScale = 2.0f;
        scroll.delegate = self ;
        [scroll addSubview:imageV];
        [_scrollView addSubview:imageV];
    }
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kScreenHeight - 20, kScreenWidth, 20)];
    _pageControl.numberOfPages = imagesCount ;
    _pageControl.currentPage = self.index ;
    [self addSubview:_pageControl];
    currentIndex = self.index ;
}

-(void)scaleImage:(UIPinchGestureRecognizer *)sender{
    
    
   // CGFloat width = sender.view.frame.size.width ;
    
    
    CGFloat value;
    if (sender.state ==  UIGestureRecognizerStateEnded) {
        _lastScale = 1.0 ;
       // NSLog(@"end");
        [UIView animateWithDuration:0.25 animations:^{
             sender.view.frame = CGRectMake(kScreenWidth * sender.view.tag, 0, kScreenWidth, kScreenHeight);
        }];
       
        return ;
    }
    else if(sender.state == UIGestureRecognizerStateChanged) {
        double scaleValue = 1.0 + sender.scale - _lastScale;
       ;
        value = scaleValue ;
        CGAffineTransform   treans =  (sender.view.transform);
        CGAffineTransform   transNew =CGAffineTransformScale( treans, value, value);
        sender.view.transform = transNew ;
        _lastScale = sender.scale ;
    // NSLog(@"value:%f  now:%f  last:%f",sender.scale,scaleValue,_lastScale);
    }

    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentePage = scrollView.contentOffset.x/kScreenWidth;
    _pageControl.currentPage = currentePage ;
    currentIndex = currentePage ;
    [self setDefaultSize];
}
-(void)setDefaultSize{
    for (int i = 0; i < _scrollView.subviews.count; i ++) {
        UIView * subView = (UIView *)_scrollView.subviews[i];
        for (int j = 0; j <subView.subviews.count; j ++) {
            UIView * item = subView.subviews[j];
            if ([item isKindOfClass:[UIImageView class]]) {
                item.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight) ;
            NSLog(@"j is %d",j);
            }
            
        }
    }
}
-(void)hide:(UITapGestureRecognizer *)tap{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    NSInteger index = _pageControl.currentPage ;
    NSLog(@"现在是点击的%ld图片",(long)index);
    
    UIView * currentImageView;
    for (int i = 0; i < _currentView.superview.subviews.count; i ++) {
        UIView * view =_currentView.superview.subviews[i];
        if (view.tag == currentIndex) {
            currentImageView = view ;
        }
    }
    
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:kScreenBounds];
    imageV.contentMode =  UIViewContentModeScaleAspectFit ;
    CGRect frame = [_currentView.superview convertRect:currentImageView.frame toView:self];
    if (self.isFromNet) {
        [imageV sd_setImageWithURL:[NSURL URLWithString:_array[currentIndex]] placeholderImage:nil];
    }else {
        if (currentIndex < self.imagesArray.count) {
            imageV.image =[self.imagesArray objectAtIndex:currentIndex];
        }
    }
        [kkeyWindow addSubview:imageV];
    _scrollView.hidden = YES ;
    [UIView animateWithDuration:kBackSizeTime animations:^{
        imageV.frame = frame;
    } completion:^(BOOL finished) {
        [imageV removeFromSuperview];
        [self removeFromSuperview];
    }];

}
- (void)showWithView:(UIView *)view {
    UIWindow * keywindow =[UIApplication sharedApplication].keyWindow ;
    assert(&keywindow);
    [keywindow addSubview:self];
    _currentView =(UIImageView *) view ;
}
-(void)layoutSubviews{
    if ( isFirstShow) {
        return ;
    }
    [self firstTimeShow];
}
-(void)firstTimeShow{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    isFirstShow = YES ;
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.contentMode =  UIViewContentModeScaleAspectFit ;
    CGRect frame = [_currentView.superview convertRect:_currentView.frame toView:self];
    imageV.image = _currentView.image;
    imageV.contentMode = UIViewContentModeScaleAspectFit ;
    imageV.frame = frame;
    [self addSubview:imageV];
    
    [UIView animateWithDuration:kBackSizeTime animations:^{
        imageV.frame = kScreenBounds;
    } completion:^(BOOL finished) {
        if (finished) {
             [imageV removeFromSuperview];
            [self configUI];
        }
    }];
}
-(void)dealloc{
    self.imagesArray  = nil;
    self.imagesUrlArray = nil;
    _scrollView = nil;
    _fromView = nil ;
    _pageControl = nil ;
}
@end
