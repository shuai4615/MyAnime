//
//  SetHeadImageViewController.m
//  MyAnime
//
//  Created by qianfeng on 15/6/15.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import "SetHeadImageViewController.h"

@interface SetHeadImageViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSInteger _num;
    
    BOOL _flag;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation SetHeadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self creatUI];
}

-(void)creatUI{
    
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",];
    
    for (int i = 0; i < array.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(16+76*(i%4), 100+(i/4)*80, 60, 60)];
        
        [self.view addSubview:imgView];
        
        imgView.tag = i + 1;
        
        imgView.userInteractionEnabled = YES;
        
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesAction:)];
        
        [imgView addGestureRecognizer:tap];
    }
    
}

-(void)gesAction:(UITapGestureRecognizer *)ges{
    
    _bgView.center = ges.view.center;
    
    _num = ges.view.tag;
    
    _flag = YES;
}

//完成
- (IBAction)successAction:(id)sender {
    
    //判断有没有点击
    if (_flag) {
        
        if (_block) {
            
            _block(_num);
        }
    }else{
        
        if (_block) {
            
            _block(1);
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//从图库获取图片
- (IBAction)tuKuImageAction:(UIButton *)sender {
    
    UIImagePickerController *pickCtl = [[UIImagePickerController alloc] init];
    //设置代理
    pickCtl.delegate = self;
    //设置是否允许编辑
    pickCtl.allowsEditing = YES;
    /*
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary,
     UIImagePickerControllerSourceTypeCamera,
     UIImagePickerControllerSourceTypeSavedPhotosAlbum
     };
     */
    //设置图片来源
    pickCtl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //展示相册
    [self presentViewController:pickCtl animated:YES completion:nil];
}

#pragma mark-PickerController的代理方法

//图片选取完毕，调用这个方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //获取选中的图片
    //UIImagePickerControllerEditedImage的key值用来获取剪切到的图片
    //UIImagePickerControllerOriginalImage的key值用来获取原图
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    
    //送到编辑个人资料页面
    if (_photoLibraryBlock) {
        
        self.photoLibraryBlock(image);
    }
    
    //关闭相册
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
