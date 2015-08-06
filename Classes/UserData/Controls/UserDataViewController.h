//
//  UserDataViewController.h
//  MyAnime
//
//  Created by qianfeng on 15/6/10.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDataViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;


@property (nonatomic, copy) NSString *idString;

@property (nonatomic, assign) BOOL selectJump;


@end
