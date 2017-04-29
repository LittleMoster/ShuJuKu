//
//  ProductModel.h
//  数据库操作
//
//  Created by cguo on 2017/4/1.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject


@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)int age;
@property(nonatomic,assign)double price;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *ID;

@end
