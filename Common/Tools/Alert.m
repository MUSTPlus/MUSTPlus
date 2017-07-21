//
//  Alert.m
//  MUST_Plus
//
//  Created by Cirno on 28/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//  优雅的弹窗

#import "Alert.h"
#import "BasicHead.h"

@interface Alert() <UITextFieldDelegate,CAAnimationDelegate>

@end

@implementation Alert{
    BOOL hasCancelBtn;
    NSMutableArray *argsArray;
    NSString *titleText;
    NSString *messageText;
}

/**
 *  处理通知
 */
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *  创建alertView
 *
 *  @param title             提示标题
 *  @param message           提示详情
 *  @param delegate          协议对象
 *  @param cancelButtonTitle 取消按钮名称
 *  @param otherButtonTitles 其他按钮
 *
 *  @return Alert
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;{
    self = [super init];
    if (self) {
        titleText = title;
        messageText = message;
        _lineSpacing = DEFAULT_LINE_SPACING;
        _paragraphSpacing = DEFAULT_LINE_SPACING;
        _contentAlignment = NSTextAlignmentCenter;
        _font = [UIFont systemFontOfSize:14];
        _alertStyle = AlertStyleDefault;
        if (delegate){
            _delegate = delegate;
        }
        argsArray = [[NSMutableArray alloc] init];
        hasCancelBtn = NO;
        if (cancelButtonTitle) {
            hasCancelBtn = YES;
            [argsArray insertObject:cancelButtonTitle atIndex:0];
        }
        va_list params; //定义一个指向个数可变的参数列表指针;
        va_start(params,otherButtonTitles);//va_start 得到第一个可变参数地址,
        id arg;
        if (otherButtonTitles) {
            //将第一个参数添加到array
            id prev = otherButtonTitles;
            [argsArray addObject:prev];
            //va_arg 指向下一个参数地址
            //这里是问题的所在 网上的例子，没有保存第一个参数地址，后边循环，指针将不会在指向第一个参数
            while( (arg = va_arg(params,id)) ){
                if ( arg ){
                    [argsArray addObject:arg];
                }
            }
            //置空
            va_end(params);
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needsDisplay) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    return self;
}

- (void)buttonClick:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]){
        [_delegate alertView:self clickedButtonAtIndex:sender.tag];
    }
    if (_clickBlock) {
        _clickBlock(self, sender.tag);
    }
    [self dismiss];
}

- (void)cancalClick:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(alertViewCancel:)]) {
        [_delegate alertViewCancel:self];
    }
    if (_cancelBlock) {
        if (_cancelBlock) {
            _cancelBlock(self);
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]){
        [_delegate alertView:self clickedButtonAtIndex:sender.tag];
    }
    if (_clickBlock) {
        _clickBlock(self, sender.tag);
    }
    [self dismiss];
}

/**
 *  显示alertView
 */
- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self needsDisplay];
        /*UIWindow *window = ((UIWindow *)[[UIApplication sharedApplication] windows][0]);*/
        UIWindow *window = ((UIWindow *)[UIApplication sharedApplication].keyWindow);
        [window addSubview:self];
        [window endEditing:YES];
        [self performPresentationAnimation];
    });
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if([[anim valueForKey:@"animType"] isEqualToString:@"popview"]) {
        [self removeFromSuperview];
        
    }
    
}

/**
 *  隐藏AlertView
 */
- (void)dismiss {
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animation];
    bounceAnimation.duration = 0.2;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:1.0],
                              
                              [NSNumber numberWithFloat:0.9],
                              
                              
                              nil];
    
    [bounceAnimation setValue:@"popview" forKey:@"animType"];
    bounceAnimation.delegate=self;
    [_alertView.layer addAnimation:bounceAnimation forKey:@"transform.scale"];
    [UIView animateWithDuration:0.15 animations:^{
        _alertView.alpha=0.0f;
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.window resignFirstResponder];
}

/**
 *  显示动画
 */
- (void)performPresentationAnimation{
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animation];
    bounceAnimation.duration = 0.1;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:0.91],
                              [NSNumber numberWithFloat:0.92],
                              [NSNumber numberWithFloat:0.93],
                              [NSNumber numberWithFloat:0.94],
                              [NSNumber numberWithFloat:0.95],
                              [NSNumber numberWithFloat:0.96],
                              [NSNumber numberWithFloat:0.97],
                              [NSNumber numberWithFloat:0.98],
                              [NSNumber numberWithFloat:0.99],
                              [NSNumber numberWithFloat:1.0],
                              nil];
    
    [_alertView.layer addAnimation:bounceAnimation forKey:@"transform.scale"];
    [UIView animateWithDuration:0.1 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
}

/**
 *  设置message字体
 *
 *  @param font UIFont
 */
- (void)setFont:(UIFont *)font{
    _font = font;
    _messageLabel.font = font;
}

/**
 *  设置message的对齐方式
 *
 *  @param contentAlignment NSTextAlignment
 */
- (void)setContentAlignment:(NSTextAlignment)contentAlignment{
    _contentAlignment = contentAlignment;
}

/**
 *  设置行距
 *
 */
- (void)setLineSpacing:(CGFloat)lineSpacing{
    _lineSpacing = lineSpacing;
}

/**
 *  这是段落间距
 *
 */
- (void)setParagraphSpacing:(CGFloat)paragraphSpacing{
    _paragraphSpacing = paragraphSpacing;
}

/*!
 *  设置Alert的类型
 *  @param alertStyle AlertStyle
 *  @since 3.0.4
 */
- (void)setAlertStyle:(AlertStyle)alertStyle {
    _alertStyle = alertStyle;
    void (^addKeybordNotification)()= ^(){
        // 键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    };
    switch (_alertStyle) {
        case AlertStyleDefault:
            // Default
            break;
        case AlertStylePlainTextInput:
            _textField = [[UITextField alloc] init];
            addKeybordNotification();
            break;
        case AlertStyleSecureTextInput:
            _textField = [[UITextField alloc] init];
            addKeybordNotification();
            break;
        case AlertStyleLoginAndPasswordInput:
            _textField = [[UITextField alloc] init];
            _passwordTextField = [[UITextField alloc] init];
            addKeybordNotification();
            break;
        default:
            break;
    }
}
CGRect getScreenBounds() {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) &&
        UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
    }
    return screenBounds;
}
/**
 *  刷新
 */
- (void)needsDisplay{
    if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = [[[UIApplication sharedApplication].keyWindow subviews] objectAtIndex:0].transform;
        }];
    }
    self.frame = [UIScreen mainScreen].bounds;
    
    CGRect screenBounds = getScreenBounds();
    // 设置背影半透明
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    if (_alertView) {
        [_alertView removeFromSuperview];
        _alertView = nil;
    }
    // 1.alertView
    _alertView = [[UIToolbar alloc] init];
    [self addSubview:_alertView];
    float width = 280;
    if (messageText && messageText.length > 100) {
        width = screenBounds.size.width-40;
    }
    _alertView.frame = CGRectMake(0, 0, width, 200);
    _alertView.layer.cornerRadius = 6;
    _alertView.layer.masksToBounds = YES;
    
    // 2.title
    _titleLabel = [[UILabel alloc] init];
    [_alertView addSubview:_titleLabel];
    _titleLabel.numberOfLines = 3;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.numberOfLines = 3;
    _titleLabel.text = [NSString stringWithFormat:@"%@", titleText];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = [UIColor colorWithRed:(0/255) green:(0/255) blue:(0/255) alpha:1];
    CGRect rect = [_titleLabel textRectForBounds:CGRectMake(0, 20, _alertView.frame.size.width-40, 100) limitedToNumberOfLines:3];
    rect.origin.x = 20;
    _titleLabel.frame = rect;
    _titleLabel.center = CGPointMake(CGRectGetWidth(_alertView.frame)/2, CGRectGetHeight(_titleLabel.frame)/2+15);
    
    //    // 3.imageView
    //    NSInteger imageTag = 821827;
    //    UIImageView *imageView = (UIImageView *)[self viewWithTag:imageTag];
    //    if (imageView == NULL) {
    //        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), 15, 20, 20)];
    //        imageView.image = [self getiImage];
    //        [_alertView addSubview:imageView];
    //    }
    CGFloat height = CGRectGetMaxY(_titleLabel.frame);
    
    if (messageText) {
        // 4.messageLabel
        _messageLabel = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame)+10, _alertView.frame.size.width-20, 35)];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.editable = NO;
        _messageLabel.scrollEnabled = NO;
        _messageLabel.selectable = NO;
        [_messageLabel flashScrollIndicators];   // 闪动滚动条
        [_alertView addSubview:_messageLabel];
        CGRect frame = _messageLabel.frame;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = _lineSpacing;
        style.paragraphSpacing = _paragraphSpacing;
        style.alignment = _contentAlignment;
        NSDictionary *dic = @{NSFontAttributeName:_font,NSParagraphStyleAttributeName:style};
        CGFloat broadWith = (_messageLabel.contentInset.left
                             + _messageLabel.contentInset.right
                             + _messageLabel.textContainerInset.left
                             + _messageLabel.textContainerInset.right
                             + _messageLabel.textContainer.lineFragmentPadding/*左边距*/
                             + _messageLabel.textContainer.lineFragmentPadding/*右边距*/);
        CGFloat textHeight = screenBounds.size.height>screenBounds.size.width?(screenBounds.size.height-64-49-100-(argsArray.count <= 2?44:argsArray.count*44)-20):(screenBounds.size.height-100-(argsArray.count <= 2?44:argsArray.count*44));
        CGSize size = [messageText boundingRectWithSize:CGSizeMake(_alertView.frame.size.width-20-broadWith, LINE_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
        CGFloat broadHeight  = (_messageLabel.contentInset.top
                                + _messageLabel.contentInset.bottom
                                + _messageLabel.textContainerInset.top
                                + _messageLabel.textContainerInset.bottom);
        CGSize adjustedSize = CGSizeMake(frame.size.width, size.height+broadHeight);
        frame.size.width = _alertView.frame.size.width-20;
        frame.size.height = adjustedSize.height;
        if (frame.size.height >= textHeight){
            frame.size.height = textHeight;
            _messageLabel.scrollEnabled = YES;   // 允许滚动
        }else{
            _messageLabel.scrollEnabled = NO;    // 不允许滚动
        }
        _messageLabel.frame = frame;
        _messageLabel.contentSize = CGSizeMake(_alertView.frame.size.width-20, size.height);
        [_messageLabel setAttributedText:[[NSAttributedString alloc] initWithString:messageText attributes:dic]];
        
        height = CGRectGetMaxY(_messageLabel.frame);
    }
    
    switch (_alertStyle) {
        case AlertStyleDefault:
            // Default
            break;
        case AlertStylePlainTextInput:
            _textField.frame = CGRectMake(20, height+5, _alertView.bounds.size.width-40, 40);
            _textField.layer.borderColor = [UIColor colorWithRed:0.5176 green:0.5176 blue:0.5176 alpha:1.0].CGColor;
            _textField.layer.borderWidth = 0.3;
            _textField.layer.cornerRadius = 2;
            _textField.delegate = self;
            _textField.backgroundColor = [UIColor clearColor];
            [_alertView addSubview:_textField];
            height = CGRectGetMaxY(_textField.frame);
            break;
        case AlertStyleSecureTextInput:
            _textField.frame = CGRectMake(20, height+5, _alertView.bounds.size.width-40, 40);
            _textField.layer.borderColor = [UIColor colorWithRed:0.5176 green:0.5176 blue:0.5176 alpha:1.0].CGColor;
            _textField.layer.borderWidth = 0.3;
            _textField.layer.cornerRadius = 2;
            [_textField setSecureTextEntry:YES];
            _textField.delegate = self;
            _textField.backgroundColor = [UIColor clearColor];
            [_alertView addSubview:_textField];
            height = CGRectGetMaxY(_textField.frame);
            break;
        case AlertStyleLoginAndPasswordInput:
            _textField.frame = CGRectMake(20, height+5, _alertView.bounds.size.width-40, 40);
            _textField.layer.borderColor = [UIColor colorWithRed:0.5176 green:0.5176 blue:0.5176 alpha:1.0].CGColor;
            _textField.layer.borderWidth = 0.3;
            _textField.layer.cornerRadius = 2;
            _textField.delegate = self;
            _textField.backgroundColor = [UIColor clearColor];
            [_alertView addSubview:_textField];
            height = CGRectGetMaxY(_textField.frame);
            
            _passwordTextField.frame = CGRectMake(20, height-0.3, _alertView.bounds.size.width-40, 40);
            _passwordTextField.layer.borderColor = [UIColor colorWithRed:0.5176 green:0.5176 blue:0.5176 alpha:1.0].CGColor;
            _passwordTextField.layer.borderWidth = 0.3;
            _passwordTextField.layer.cornerRadius = 2;
            [_passwordTextField setSecureTextEntry:YES];
            _passwordTextField.delegate = self;
            _passwordTextField.backgroundColor = [UIColor clearColor];
            [_alertView addSubview:_passwordTextField];
            height = CGRectGetMaxY(_passwordTextField.frame);
            break;
        default:
            break;
    }
    
    for (UIView *view in _alertView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    if (argsArray.count <= 2) {
        //这里循环 将看到所有参数
        for (int j = 0; j < [argsArray count]; j++){
            NSString *s = argsArray[j];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.frame = CGRectMake((CGRectGetWidth(_alertView.frame)+2)/argsArray.count*j-1, height+10, (CGRectGetWidth(_alertView.frame)+2)/argsArray.count, 44);
            button.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
            button.layer.borderWidth = 0.5;
            button.tag = j;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
//            [button setTitleColor:[UIColor colorWithRed:(57.0/255) green:(170.0/255) blue:(196.0/255) alpha:1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:95.0/255.0 green:167.0/255.0 blue:241.0/255.0 alpha:1] forState:UIControlStateNormal];

            [button setTitleColor:[UIColor colorWithRed:(132.0/255) green:(132.0/255) blue:(132.0/255) alpha:1] forState:UIControlStateHighlighted];
            
            [button setTitle:s forState:UIControlStateNormal];
            [_alertView addSubview:button];
            if (hasCancelBtn == YES){
                [button addTarget:self action:@selector(cancalClick:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        height += 54;
    } else {
        if (hasCancelBtn == YES){
            [argsArray addObject:argsArray[0]];
            [argsArray removeObjectAtIndex:0];
        }
        for (int j = 0; j < [argsArray count]; j++){
            NSString *s = argsArray[j];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.frame = CGRectMake(0, height, CGRectGetWidth(_alertView.frame), 44);
            button.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
            button.layer.borderWidth = 0.5;
            button.tag = j;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor colorWithRed:(57.0/255) green:(170.0/255) blue:(196.0/255) alpha:1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:(132.0/255) green:(132.0/255) blue:(132.0/255) alpha:1] forState:UIControlStateHighlighted];
            
            [button setTitle:s forState:UIControlStateNormal];
            [_alertView addSubview:button];
            if (hasCancelBtn == YES){
                [button addTarget:self action:@selector(cancalClick:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            height = CGRectGetMaxY(button.frame);
        }
    }
    CGRect rect2 =  _alertView.frame;
    rect2.size.height = height;
    _alertView.frame = rect2;
    _alertView.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height/2);
}

#pragma mark - search
/**
 *  显示键盘
 *
 */
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect screenBounds = getScreenBounds();
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        CGRect viewRect = _alertView.frame;
        viewRect.origin.y = CGRectGetHeight(screenBounds)-rect.size.height-viewRect.size.height-20;
        _alertView.frame = viewRect;
    }completion:^(BOOL finished) {
    }];
}

/**
 *  隐藏键盘
 *
 */
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        _alertView.center = self.center;
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_textField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

/**
 *  设置取消的Block copy
 *
 *  @param cancelBlock 取消的Block
 */
- (void)setCancelBlock:(CancelAlertBlock)cancelBlock{
    _cancelBlock = [cancelBlock copy];
}

/**
 *  设置点击的Block copy
 *
 *  @param clickBlock 点击的Block
 */
- (void)setClickBlock:(ClicksAlertBlock)clickBlock{
    _clickBlock = [clickBlock copy];
}

@end
