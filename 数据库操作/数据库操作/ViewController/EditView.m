//
//  EditView.m
//  数据库操作
//
//  Created by cguo on 2017/5/27.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "EditView.h"
#import "TableTool.h"
#import <UIKit/UIKit.h>

@interface EditView ()

@end
@implementation EditView




+(void)EditProductWhenEncryWayChange
{
    
    
    NSString *key = @"CFBundleShortVersionString";
    NSString *IsEncryKey=@"ischangeEncry";
    
 

      [[NSNotificationCenter defaultCenter]postNotificationName:@"EditProduct" object:self];
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    // 获得沙盒中存储的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    
    
    if (![currentVersion isEqualToString:sanboxVersion]) {
        NSString *sanBoxEncry=[[NSUserDefaults standardUserDefaults]stringForKey:IsEncryKey];
        if (![sanBoxEncry isEqualToString:isEncry] && [isEncry isEqualToString:@"NO"]) {
            //版本更新了并且数据库是否加密的选择也改变了，需要退出程序，避免数据库切换出错
            
      
            [self exitApplication];
        
            
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:isEncry forKey:IsEncryKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
+(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
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
