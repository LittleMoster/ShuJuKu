//
//  EditView.m
//  数据库操作
//
//  Created by cguo on 2017/5/27.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "EditView.h"
#import "TableTool.h"
#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "ProductModel.h"
@interface EditView ()
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;

@end
@implementation EditView


-(void)setModel:(ProductModel *)model
{
    _model=model;
    self.label1.text=model.name;
    self.label2.text=model.url;
    self.label3.text=model.ID;
}
+(instancetype)ADDView
{
  return   [[[NSBundle mainBundle] loadNibNamed:@"EditView" owner:nil options:nil] lastObject];
}
+(void)EditProductWhenEncryWayChange
{
    
    
    NSString *key = @"CFBundleShortVersionString";
    NSString *IsEncryKey=@"ischangeEncry";
    
   [self exitApplication];

      [[NSNotificationCenter defaultCenter]postNotificationName:@"EditProduct" object:self];
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 获得沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    
    
    if (![currentVersion isEqualToString:sanboxVersion]) {
        NSString *sanBoxEncry=[[NSUserDefaults standardUserDefaults]stringForKey:IsEncryKey];
        if (![sanBoxEncry isEqualToString:isEncry] && [isEncry isEqualToString:@"NO"]) {
            //版本更新了并且数据库是否加密的选择也改变了，需要退出程序，避免数据库切换出错
            
      
            [[[ViewController alloc]init]exitApplication];
//            [self exitApplication];
        
            
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:isEncry forKey:IsEncryKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


+ (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
//     [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[UIApplication sharedApplication].keyWindow  cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIApplication sharedApplication].keyWindow.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}



- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
    
}

@end
