//
//  ProjectViewController.h
//  MyAnime
//
//  Created by qianfeng on 15/6/10.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *title_Label;

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, copy) NSString *title_LabelString;

@property (nonatomic, assign) NSInteger number;//用来判断是那个专题的更多


@end
