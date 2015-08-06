//
//  ValidationViewController.h
//  MyAnime
//
//  Created by qianfeng on 15/6/13.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidationViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *againButton;


@property (nonatomic, copy) NSString *phoneString;

@property (weak, nonatomic) IBOutlet UITextField *myTextField;


@property (nonatomic, copy) NSString *resetOrSetString;


@end
