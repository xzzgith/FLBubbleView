//
//  FLBubbleView.m
//  QQBubble
//
//  Created by Felix on 2017/2/22.
//  Copyright © 2017年 FREEDOM. All rights reserved.
//

#import "FLBubbleView.h"

@implementation FLBubbleView
{
    CGRect _selfFrame;
    CGPoint _oriCenter;
    UIColor *_bubbleColor;
    UIColor *_shapeColor;
    
    CGFloat r1;//oriBubble radius
    CGFloat r2;//slideBubble radius
    
    CGFloat x1;
    CGFloat x2;
    CGFloat y1;
    CGFloat y2;
    CGFloat cosD;
    CGFloat sinD;
    CGFloat pointO1;
    CGFloat pointO2;
    CGPoint pointA;
    CGPoint pointB;
    CGPoint pointC;
    CGPoint pointD;
    CGPoint pointE;
    CGPoint pointF;
    
    UIView *_oriBubble;
    UIView *_slideBubble;
    
    CAShapeLayer *_shapeLayer;
    
    UIView *_containerView;
    
    UIBezierPath *path;
}

-(instancetype)initWithFrame:(CGRect)frame inView:(UIView*)view{
    self = [super initWithFrame:frame];
    _selfFrame = frame;
    _bubbleColor = [UIColor redColor];
    _containerView = view;
    r1 = frame.size.width/2.f;
    _shapeLayer = [CAShapeLayer layer];
    [view addSubview:self];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup{
    _oriBubble = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _selfFrame.size.width, _selfFrame.size.height)];
    _oriBubble.backgroundColor = _bubbleColor;
    _oriBubble.center = _containerView.center;
    _oriBubble.layer.cornerRadius = r1;
    _oriBubble.hidden = YES;
    [_containerView addSubview:_oriBubble];
    _oriCenter = _oriBubble.center;
    
    _slideBubble = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _selfFrame.size.width, _selfFrame.size.height)];
    _slideBubble.backgroundColor = _bubbleColor;
    r2 = _selfFrame.size.width/2;
    _slideBubble.layer.cornerRadius = r2;
    _slideBubble.center = _containerView.center;
    [_containerView addSubview:_slideBubble];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(slideTheBubble:)];
    [_slideBubble addGestureRecognizer:pan];
    
    
    
//   [self addBigSmallAnimation];

}

- (void)slideTheBubble:(UIPanGestureRecognizer *)pan{
    CGPoint slidePoint = [pan locationInView:_containerView];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _oriBubble.hidden = NO;
        _shapeColor = [UIColor redColor];
    }
    else if (pan.state == UIGestureRecognizerStateChanged){
        _slideBubble.center = slidePoint;
        if (r1 < 6) {
            //脱离
            _shapeColor = [UIColor clearColor];
            _oriBubble.hidden = YES;
            [_shapeLayer removeFromSuperlayer];
        }
        [self slipDisplay];
        
    }
    else if (pan.state == UIGestureRecognizerStateEnded ||
             pan.state == UIGestureRecognizerStateCancelled ||
             pan.state == UIGestureRecognizerStateFailed){
        
        if (r1<6) {
            //slideBubble boom!
        }else{
            //refresh
            _oriBubble.hidden = YES;
            _shapeColor = [UIColor clearColor];
             [_shapeLayer removeFromSuperlayer];
            /*
             dampingRatio（阻尼系数）
             范围 0~1 当它设置为1时，动画是平滑的没有振动的达到静止状态，越接近0 振动越大
             velocity （弹性速率）
             就是形变的速度，从视觉上看可以理解弹簧的形变速度，到动画结束，该速度减为0，所以，velocity速度越大，那么形变会越快，当然在同等时间内，速度的变化（就是速率）也会越快，因为速度最后都要到0。
             */
            [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.3f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                _slideBubble.center = _oriCenter;
            } completion:^(BOOL finished) {
               

            }];
        }
    }
}
- (void)slipDisplay{
    
    x1 = _oriBubble.center.x;
    y1 = _oriBubble.center.y;
    x2 = _slideBubble.center.x;
    y2 = _slideBubble.center.y;
    
    CGFloat o1o2 = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    
    if (o1o2 == 0) {
        cosD = 1;
        sinD = 0;
    }else{
        cosD = (y2-y1)/o1o2;
        sinD = (x2-x1)/o1o2;
    }
    
    r1 = _selfFrame.size.width/2  - o1o2/self.springRatio;
    pointA = CGPointMake(x1+r1*cosD, y1-r1*sinD);
    pointB = CGPointMake(x2+r2*cosD, y2-r2*sinD);
    pointC = CGPointMake(x2-r2*cosD, y2+r2*sinD);
    pointD = CGPointMake(x1-r1*cosD, y1+r1*sinD);
    pointE = CGPointMake(pointD.x+(o1o2/2)*sinD, pointD.y+(o1o2/2)*cosD);
    pointF = CGPointMake(pointA.x+(o1o2/2)*sinD, pointA.y+(o1o2/2)*cosD);
    
    
    [self drawTrail];
}
- (void)drawTrail{
    _oriBubble.bounds = CGRectMake(0, 0, r1*2, r1*2);
    _oriBubble.layer.cornerRadius = r1;
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:pointD];
    [path addQuadCurveToPoint:pointC controlPoint:pointE];
    [path addLineToPoint:pointB];
    [path addQuadCurveToPoint:pointA controlPoint:pointF];
    [path moveToPoint:pointD];
    
    if (_oriBubble.hidden == NO) {
        _shapeLayer.path = path.CGPath;
        _shapeLayer.fillColor = _shapeColor.CGColor;
        [_containerView.layer insertSublayer:_shapeLayer below:_slideBubble.layer];

    }
}
- (void)addBigSmallAnimation{
    CAKeyframeAnimation *pathAnimation =
    [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 5.0;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(
                                         _oriBubble.frame, _oriBubble.bounds.size.width / 2 -3,
                                         _oriBubble.bounds.size.width / 2 -3);
    
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [_oriBubble.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
    
    CAKeyframeAnimation *scaleX =
    [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1;
    scaleX.values = @[ @1.0, @1.1, @1.0 ];
    scaleX.keyTimes = @[ @0.0, @0.5, @1.0 ];
    scaleX.repeatCount = INFINITY;
    scaleX.autoreverses = YES;
    
    scaleX.timingFunction = [CAMediaTimingFunction
                             functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_oriBubble.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    
    
    CAKeyframeAnimation *scaleY =
    [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[ @1.0, @1.1, @1.0 ];
    scaleY.keyTimes = @[ @0.0, @0.5, @1.0 ];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleX.timingFunction = [CAMediaTimingFunction
                             functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_oriBubble.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
}
@end
