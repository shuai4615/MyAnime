//
//  AlbumViewController.h
//  MyAnime
//
//  Created by qianfeng on 15/6/9.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *title_Label;

@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *yellowLabel;

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;


@property (nonatomic, copy) NSString *idString;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end
