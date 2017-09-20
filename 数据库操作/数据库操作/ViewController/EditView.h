//
//  EditView.h
//  数据库操作
//
//  Created by cguo on 2017/5/27.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModel;

@interface EditView : UIView


+(void)EditProductWhenEncryWayChange;

@property(nonatomic,strong)ProductModel *model;
+(instancetype)ADDView;
@end
