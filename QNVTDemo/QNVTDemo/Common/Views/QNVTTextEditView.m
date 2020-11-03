//
//  QNVTTextEditView.m
//  QNVTDemo
//
//  Created by 李政勇 on 2020/9/16.
//  Copyright © 2020 Hermes. All rights reserved.
//

#import "QNVTTextEditView.h"

@interface QNVTTextEditView () <UITextFieldDelegate>

@property(nonatomic, strong) UIView* contentView;

@property(nonatomic, strong) UITextField* textField;
@property(nonatomic, strong) UIButton* confirmBtn;

@end

@implementation QNVTTextEditView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _contentView = [UIView new];
    _textField = [UITextField new];
    _textField.font = [UIFont systemFontOfSize:14];
    _textField.textColor = UIColor.whiteColor;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn addTarget:self action:@selector(didEndEditing) forControlEvents:UIControlEventTouchUpInside];

    _contentView.backgroundColor = UIColor.blackColor;
    _textField.backgroundColor = QNVTCOLOR(383838);
    [_confirmBtn setImage:[UIImage imageNamed:@"text_edit_confirm"] forState:UIControlStateNormal];

    [self addSubview:_contentView];
    [_contentView addSubview:_textField];
    [_contentView addSubview:_confirmBtn];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoradWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)setText:(NSString*)text {
    _text = text;
    _textField.text = text;
}

- (void)didEndEditing {
    [_textField endEditing:YES];
    if (self.didEndEditBlock) {
        _didEndEditBlock(_textField.text);
    }

    [self hid];
}

- (void)keyBoradWillChange:(NSNotification*)noti {
    NSDictionary* dic = noti.userInfo;
    CGRect end = [dic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [dic[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    CGFloat posy = self.bounds.size.height - [self convertRect:end fromView:[UIApplication sharedApplication].keyWindow].origin.y;
    posy = MAX(0, posy);
    CGRect bounds = self.bounds;
    bounds.origin.y = posy;

    [UIView animateWithDuration:duration animations:^{ self.bounds = bounds; }];
}

- (void)showInView:(UIView*)view {
    self.backgroundColor = UIColor.clearColor;
    self.frame = view.bounds;
    [view addSubview:self];

    [self layoutIfNeeded];
    [self.textField becomeFirstResponder];

    [UIView animateWithDuration:0.2 animations:^{ self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7]; }];
}

- (void)hid {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2
        animations:^{ self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0]; }
        completion:^(BOOL finished) {
            [self removeFromSuperview];
            self.userInteractionEnabled = YES;
        }];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSInteger width = self.frame.size.width;
    NSInteger height = self.frame.size.height;
    _contentView.frame = CGRectMake(0, height - 70, width, 70);
    _textField.frame = CGRectMake(20, 16, width - 87, 38);
    _confirmBtn.frame = CGRectMake(width - 54, 13, 44, 44);
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [touches anyObject];
    if (!CGRectContainsPoint(_contentView.frame, [touch locationInView:self])) {
        [self hid];
    }
}

#pragma mark - textFiled delegate

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [self didEndEditing];
    return YES;
}

@end
