//
//  CZRedView.m
//  第二题(触摸事件)
//
//  Created by apple on 15-1-12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CCRedView.h"

@implementation CCRedView

- (void)dealloc {
#warning 一定要移除
    NSLog(@"%s", __func__);
    [self removeObserver:self forKeyPath:@"frame"];
}


@end
