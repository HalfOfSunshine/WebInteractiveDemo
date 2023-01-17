//
//  ViewController.m
//  InteractiveDemo
//
//  Created by 麻明康 on 2023/1/16.
//

#import "ViewController.h"
#import "PresentedNavViewController.h"
#import "PresentedVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];
    [btn setTitle:@"presentNav" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor systemPinkColor];
    [btn addTarget:self action:@selector(presentNav) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)presentNav{
    PresentedNavViewController *nav = [[PresentedNavViewController alloc]initWithRootViewController:[PresentedVC new]];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
}

@end
