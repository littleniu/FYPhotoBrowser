//
//  FYImage.m
//  weixin图片放大
//
//  Created by Charlie on 15/7/20.
//  Copyright (c) 2015年 Swift. All rights reserved.
//

#import "FYImageView.h"

@implementation FYImageView
{
    id _target;
    SEL _action;
}

-(void)addTarget:(id)obj action:(SEL)action{
    self.userInteractionEnabled = YES ;
    if (obj && action) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:obj action:action];
        [self addGestureRecognizer:tap];
    }
}

@end
