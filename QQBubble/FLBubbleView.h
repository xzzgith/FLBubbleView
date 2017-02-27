//
//  FLBubbleView.h
//  QQBubble
//
//  Created by Felix on 2017/2/22.
//  Copyright © 2017年 FREEDOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLBubbleView : UIView
-(instancetype)initWithFrame:(CGRect)frame inView:(UIView*)view;
@property (nonatomic,assign) CGFloat springRatio;

@end
