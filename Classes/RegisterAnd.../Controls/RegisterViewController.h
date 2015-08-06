//
//  RegisterViewController.h
//  MyAnime
//
//  Created by qianfeng on 15/6/11.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (nonatomic, copy) void (^block)(NSDictionary *dic,NSString *phone,NSString *passwordString);

@end
