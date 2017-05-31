


//
//  ViewController.m
//  数据库操作
//
//  Created by cguo on 2017/3/22.
//  Copyright © 2017年 zjq. All rights reserved.
//

#import "ViewController.h"
#import "FileUtils.h"
#import "PathUtils.h"
#import "TableTool.h"
#import "EncryptUtils.h"
#import "NSObject+SQLService.h"
#import "ProductModel.h"
#import "EditView.h"
#import "Masonry.h"
@interface ViewController ()<UIAlertViewDelegate>

{
    UIView *view1;
    UIView *view2;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [EditView EditProductWhenEncryWayChange];
//      [self Sqlite];
    
}
-(void)Sqlite
{
    ProductModel *model=[[ProductModel alloc]init];
    model.name=@"2342";
    model.price=23.23;
    model.ID=@"123";
    model.url=@"dfeufh";
    model.age=142;
    [model SaveDateWithModelInSQL];
    NSMutableArray *arr=[ProductModel GetAllModelArrByTable];
    NSLog(@"%ld",arr.count);
    ProductModel *model12=[ProductModel GetModelByTableWithId:@"123"];
    NSLog(@"%@",model12.url);
    

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    
    [EditView EditProductWhenEncryWayChange];
}


@end

