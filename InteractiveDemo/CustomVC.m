//
//  CustomVC.m
//  InteractiveDemo
//
//  Created by 麻明康 on 2023/1/16.
//

#import "CustomVC.h"
#import "PresentedNavViewController.h"
@interface CustomVC ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) WKWebView *webView; //展示内容联盟用的webview

@end

@implementation CustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];

    self.navigationController.title = @"CustomVC";
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://cpu.baidu.com/1002/d77e414"]]];
    self.webPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    self.webPan.delegate = self;
    [self.view addGestureRecognizer:self.webPan];
    self.webPan.enabled = NO;
    
    [self setBackBarButton];

}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    PresentedNavViewController *nav = (PresentedNavViewController *)self.navigationController;
    if(gestureRecognizer == nav.pan){
        return self.navigationController.viewControllers.count > 1;
    }else if(gestureRecognizer == self.webPan){
        CGPoint translation = [self.webPan translationInView:self.view];
        if (fabs(translation.y) > fabs(translation.x)) {
            return NO; // user is scrolling vertically
        }
        return translation.x > 0;
    }
    return YES;
}


-(void) panHandler: (UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded && gesture == self.webPan) {
        CGPoint translation = [gesture translationInView:self.view];

        if (fabs(translation.y) > fabs(translation.x)) {
            return; // user is scrolling vertically
        }
        if (translation.x > 0){
            [self closeView];
        }
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"canGoBack"]) {
        BOOL v = [change[@"new"] boolValue];
        NSLog(@"======%@",v?@"YES":@"NO");
        PresentedNavViewController *nav = (PresentedNavViewController *)self.navigationController;
        nav.pan.enabled = !v;
        self.webPan.enabled = v;
    }
}


#pragma mark - getter
- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.scrollView.delegate = self;
        [_webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

- (BOOL)canGoBack{
    return [self.webView canGoBack];
}
- (BOOL)canGoForward{
    return [self.webView canGoForward];
}
- (void)goBack{
    if([self.webView canGoBack]){
        [self.webView goBack];
    }else{
//        [super goBack];
    }
}
- (void)goForward{
    if([self.webView goForward]){
        [self.webView goForward];
    }else{
        NSLog(@"这是最后一个页面了");
    }
}
- (void)dealloc {
    NSLog(@"=====dealloc");
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    
}


-(void)setBackBarButton{
    //返回按钮
    UIButton *backButton  =  [[UIButton alloc] init];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    backButton.userInteractionEnabled = YES;
    
    //    backButton.frame  =  CGRectMake(12.5, 0, 25, 25);
    // iOS 11 适配
    if (@available(iOS 11, *)) {
        backButton.frame  =  CGRectMake(2.5, 0, 22, 22);
    } else {
        backButton.frame  =  CGRectMake(12.5, 0, 22, 22);
    }
    if (@available(iOS 13.0, *)) {
        [backButton setImage:[UIImage systemImageNamed:@"chevron.backward"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage systemImageNamed:@"chevron.backward"] forState:UIControlStateHighlighted];
    } else {
        [backButton setTitle:@"Back" forState:UIControlStateNormal];
        [backButton setTitle:@"Back" forState:UIControlStateHighlighted];
    }
    backButton.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    [backButton addTarget: self action:@selector(closeView) forControlEvents: UIControlEventTouchUpInside];
    UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 22)];
    [leftview addSubview:backButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftview];
}

//返回按钮
-(void)closeView
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
