//
//  ViewController.m
//  QQBubble
//
//  Created by Felix on 2017/2/22.
//  Copyright © 2017年 FREEDOM. All rights reserved.
//

#import "ViewController.h"
#import "FLBubbleView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FLBubbleView *view = [[FLBubbleView alloc]initWithFrame:CGRectMake(0, 0, 30, 30) inView:self.view];
    view.center = self.view.center;
    view.springRatio = 20;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
