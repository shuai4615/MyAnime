//
//  MoreCommentsViewController.h
//  MyAnime
//
//  Created by qianfeng on 15/6/11.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreCommentsViewController : UIViewController

@property (nonatomic, copy) NSString *idString;


@property (weak, nonatomic) IBOutlet UIScrollView *MyScrollView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *MyStepper;

@property (weak, nonatomic) IBOutlet UITextField *MyTextField;



@property (weak, nonatomic) IBOutlet UIView *TFbgView;


@end
