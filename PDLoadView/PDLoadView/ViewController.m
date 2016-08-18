//
//  ViewController.m
//  PDLoadView
//
//  Created by Panda on 16/8/18.
//  Copyright © 2016年 FLZC. All rights reserved.
//

#import "ViewController.h"
#import "PDLoading.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   self.view.backgroundColor = [UIColor whiteColor];
    PDLoading * load = [PDLoading shareLoadView];
    [self.view addSubview:load];
    [load showLoadingViewWithBlur];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
