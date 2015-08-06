//
//  PersonalDataViewController.h
//  MyAnime
//
//  Created by qianfeng on 15/6/13.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProtocol.h"

@interface PersonalDataViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (nonatomic, copy) NSString *userHeadString;

@property (nonatomic, copy) NSString *userNameString;


@property (nonatomic, copy) NSString *phoneString;

@property (nonatomic, copy) NSString *passwordString;


@property (nonatomic, copy) void(^block)(NSString *nameString,NSInteger number);

@property (nonatomic, weak) id<MyProtocol>delegate;

@end
