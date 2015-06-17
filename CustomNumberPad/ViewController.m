//
//  ViewController.m
//  Custom NumberPad
//
//  Created by ZK on 15/6/17.
//  Copyright (c) 2015年 ZK. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    UIButton *_pointBtn;
}
@property(nonatomic, strong) UITextField *textF;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.textF.keyboardType = UIKeyboardTypeNumberPad;
    self.textF.borderStyle = UITextBorderStyleRoundedRect;
    self.textF.backgroundColor = [UIColor redColor];
    self.textF.center = self.view.center;
    [self.textF addTarget:self action:@selector(editingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.view addSubview:self.textF];
}

#pragma mark - 监听相应通知
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 处理TextField响应事件
- (void)editingDidBegin:(UITextField *)textF {
    [self configPointInKeyBoardButton];
}
#pragma mark - 自定义"点"按钮
- (void)configPointInKeyBoardButton {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (_pointBtn == nil) {
        _pointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pointBtn.frame = CGRectMake(0, screenHeight, 106, 53);
        _pointBtn.backgroundColor = [UIColor clearColor];
        [_pointBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_pointBtn setTitle:@"." forState:UIControlStateNormal];
        [_pointBtn addTarget:self action:@selector(pointAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [self performSelector:@selector(addPointButton) withObject:nil afterDelay:0.0f];
}

- (void)addPointButton {
    UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    [tempWindow addSubview:_pointBtn];
}

#pragma mark - 处理"点"按钮响应事件
- (void)pointAction {
    if (![self.textF.text isEqualToString:@""] && ![self.textF.text containsString:@"."]) {
        [self.textF insertText:_pointBtn.titleLabel.text];
    }
}

#pragma mark - 处理键盘响应事件
- (void)handleKeyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if (_pointBtn) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        _pointBtn.transform = CGAffineTransformTranslate(_pointBtn.transform, 0, -53);
        [UIView commitAnimations];
    }
    
}

- (void)handleKeyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (_pointBtn.superview) {
        [UIView animateWithDuration:animationDuration animations:^{
            _pointBtn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [_pointBtn removeFromSuperview];
            _pointBtn = nil;
        }];
    }
}

#pragma mark - 处理视图响应事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textF resignFirstResponder];
}
@end