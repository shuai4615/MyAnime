//
//  PersonalViewController.h
//  MyAnime
//
//  Created by qianfeng on 15/6/8.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProtocol.h"

@interface PersonalViewController : UIViewController<MyProtocol>

@property (weak, nonatomic) IBOutlet UILabel *yellowLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (nonatomic, copy) NSString *userID;

@end
