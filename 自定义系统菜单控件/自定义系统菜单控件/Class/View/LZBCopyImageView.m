//
//  LZBCopyImageView.m
//  自定义系统菜单控件
//
//  Created by apple on 16/5/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LZBCopyImageView.h"

@interface LZBCopyImageView ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation LZBCopyImageView
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame: frame])
    {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI
{
    self.userInteractionEnabled = YES;
    self.isCopyEnable = YES;
    [self addGestureRecognizer:self.longPressGesture];
}


- (void)setIsCopyEnable:(BOOL)isCopyEnable
{
    if(_isCopyEnable != isCopyEnable)
    {
        _isCopyEnable = isCopyEnable;
        self.longPressGesture.enabled = isCopyEnable;
        self.userInteractionEnabled =isCopyEnable;
    }
}



#pragma mark - 长按手势 业务逻辑处理
-(void)longPressGestureClick:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        [self showMenu];
    }
}

- (void)showMenu
{
    [self becomeFirstResponder];
    UIMenuController *memuVc = [UIMenuController sharedMenuController];
    memuVc.arrowDirection = UIMenuControllerArrowDefault;
    UIMenuItem *item1 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
    
    UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:@"粘贴" action:@selector(pasteAction:)];
    
    memuVc.menuItems =[NSArray arrayWithObjects: item1,item2, nil];
    //显示文字
    [memuVc setTargetRect:self.bounds inView:self];
    
    [memuVc setMenuVisible:YES animated:YES];
    
}



#pragma mark - 内部函数=========================================
#pragma mark -UIResponder

- (BOOL)canBecomeFirstResponder
{
    return self.isCopyEnable;
}
/**
 *  注意：一定不要加上这句,如果加上这句，就是出现memuVc.menuFrame = {0，0，0,0}
 */
//- (BOOL)becomeFirstResponder
//{
//    return YES;
//}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL result = NO;
    if(action == @selector(copyAction:)||
       (action == @selector(pasteAction:)))
    {
        result = self.isCopyEnable;
    }
    else
        result = [super canPerformAction:action withSender:sender];
    
    return result;
}
- (void)copyAction:(id)sender
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.image = self.image;
}

-(void)pasteAction:(id)sender
{
    self.contentMode = UIViewContentModeScaleToFill;
    self.clipsToBounds =YES;
    self.image = [UIPasteboard generalPasteboard].image;
}


#pragma mark - 初始化控件
- (UILongPressGestureRecognizer *)longPressGesture
{
    if(_longPressGesture == nil)
    {
        _longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureClick:)];
    }
    return _longPressGesture;
    
}



@end
