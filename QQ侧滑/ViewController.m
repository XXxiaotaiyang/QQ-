//
//  ViewController.m
//  第二题(触摸事件)
//
//  Created by apple on 15-1-12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "CCRedView.h"
#define CHTopPadingY 100
#define CHRight 250
#define CHLeft -250
@interface ViewController ()
@property(nonatomic,weak)UIView *lightGrayView;
@property(nonatomic,weak)UIView *orangView;
@property(nonatomic,weak)UIView *redView;

@property(nonatomic,assign)BOOL draging;
@end

@implementation ViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
#warning 一定要移除
    [self.redView removeObserver:self forKeyPath:@"frame"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *blueView = [[UIView alloc] initWithFrame:self.view.bounds];
    blueView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:blueView];
    self.lightGrayView = blueView;
    
    UIView *orangView = [[UIView alloc] initWithFrame:self.view.bounds];
    orangView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:orangView];
    self.orangView = orangView;
    
    CCRedView *redView = [[CCRedView alloc] initWithFrame:self.view.bounds];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    self.redView = redView;
    
    // KVO监听frame的改变
    [self.redView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        if (self.redView.frame.origin.x < 0) {
            self.lightGrayView.hidden = YES;
            self.orangView.hidden = NO;
        } else if (self.redView.frame.origin.x > 0){
            self.lightGrayView.hidden = NO;
            self.orangView.hidden = YES;
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // 1.获得触摸对象
    UITouch *touch = [touches anyObject];
    
    // 2.当前触摸点
    CGPoint currentPoint = [touch locationInView:touch.view];
    // 3.获得上一次触摸点
    CGPoint previousPoint = [touch previousLocationInView:touch.view];
    
    // 4.计算x方向偏移量
    CGFloat offsetX = currentPoint.x - previousPoint.x;
    
    self.redView.frame = [self rectWithOffsetX:offsetX];
    
    self.draging = YES;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.draging && self.redView.frame.origin.x != 0) {
        [UIView animateWithDuration:0.1  animations:^{
            self.redView.frame = self.view.bounds;
        }];
        return;
    }
    CGFloat redViewX = self.redView.frame.origin.x;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    if (redViewX > screenW * 0.3) {
        redViewX = CHRight;
    } else if(CGRectGetMaxX(self.redView.frame) < screenW * 0.7) {
        redViewX = CHLeft;
    }
    CGFloat offsetX = redViewX - self.redView.frame.origin.x;
    [UIView animateWithDuration:0.1  animations:^{
        self.redView.frame = offsetX == 0 ? self.view.bounds :[self rectWithOffsetX:offsetX];
    }];
    self.draging = NO;
}

- (CGRect)rectWithOffsetX:(CGFloat)offsetX {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    // 1.计算y方向的偏移量
    CGFloat offsetY = offsetX * (CHTopPadingY / screenW);
    if (self.redView.frame.origin.x < 0) {
        offsetY *= -1;
    }
    CGRect frame = self.redView.frame;
    frame.origin.x += offsetX;
    frame.origin.y += offsetY;
    frame.size.height = screenH - 2 * frame.origin.y;
    return frame;
}
@end
