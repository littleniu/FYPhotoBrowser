//
//  FYPhotoBrowser.m
//  weixin图片放大
//
//  Created by Charlie on 15/7/17.
//  Copyright (c) 2015年 Swift. All rights reserved.
//

#import "FYPhotoBrowser.h"



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
    UIViewContentMode  _currentContentMode ;//image的填充模式
    
}
@synthesize array = _array;
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
    _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.backgroundColor =[UIColor blackColor];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * _array.count, kScreenHeight);
    _scrollView.contentOffset  = CGPointMake(kScreenWidth * _index, 0) ;
    _scrollView.delegate = self ;
    _scrollView.pagingEnabled = YES ;
    [self addSubview:_scrollView];
    
    
    for (int i = 0; i < _array.count; i ++) {
        UIImageView * imageV= [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
        UIImage * defaultImage = nil; //默认图
        if (i == self.index) {
            defaultImage = _currentView.image ;
        }
        MBProgressHUD * hud = [[MBProgressHUD alloc]init];
        hud.mode = MBProgressHUDModeAnnularDeterminate ;
        [imageV addSubview:hud];
        [hud show:YES];
        [imageV sd_setImageWithURL:[NSURL URLWithString:_array[i]] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            hud.progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [hud hide:YES];
        }];
        imageV.contentMode =  UIViewContentModeScaleAspectFit ;
        imageV.tag = i ;
        imageV.userInteractionEnabled = YES ;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide:)];
        [imageV addGestureRecognizer:tap];
        [_scrollView addSubview:imageV];
    }
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kScreenHeight - 20, kScreenWidth, 20)];
    
    _pageControl.numberOfPages = _array.count ;
    //[_pageControl setValue:@(self.index) forKey:@"_currentPage"];
    _pageControl.currentPage = self.index ;
    [self addSubview:_pageControl];
    currentIndex = self.index ;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentePage = scrollView.contentOffset.x/kScreenWidth;
    _pageControl.currentPage = currentePage ;
    currentIndex = currentePage ;
}
-(void)hide:(UITapGestureRecognizer *)tap{
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
    imageV.contentMode =  _currentContentMode ;
    CGRect frame = [_currentView.superview convertRect:currentImageView.frame toView:self];
    [imageV sd_setImageWithURL:[NSURL URLWithString:_array[currentIndex]] placeholderImage:nil];
    [kkeyWindow addSubview:imageV];
    _scrollView.hidden = YES ;
    [UIView animateWithDuration:0.8 animations:^{
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
    _currentContentMode = view.contentMode;
}
-(void)layoutSubviews{
    if ( isFirstShow) {
        return ;
    }
    [self firstTimeShow];
}
-(void)firstTimeShow{
    isFirstShow = YES ;
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.contentMode =  UIViewContentModeScaleAspectFit ;
    CGRect frame = [_currentView.superview convertRect:_currentView.frame toView:self];
    imageV.image = _currentView.image;
    imageV.contentMode = _currentContentMode ;
    imageV.frame = frame;
    [self addSubview:imageV];
    
    [UIView animateWithDuration:0.8 animations:^{
        imageV.frame = kScreenBounds;
    } completion:^(BOOL finished) {
        if (finished) {
             [imageV removeFromSuperview];
            [self configUI];
        }
    }];
}
-(void)dealloc{
    self.array  = nil;
    _scrollView = nil;
    _fromView = nil ;
    _pageControl = nil ;
}
@end
