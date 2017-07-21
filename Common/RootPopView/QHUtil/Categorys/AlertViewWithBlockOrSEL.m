//
//  AlertViewWithBlockOrSEL.m
//  QHSimpleFrame
//
//  Created by imqiuhang on 15/4/1.
//  Copyright (c) 2015年 imqiuhang. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


#import "AlertViewWithBlockOrSEL.h"

typedef void (^MEAlertViewButtonButtonTapped)();

@interface MEAlertViewButton : NSObject
- (id)initWithTitle:(NSString *)title onTapped:(void(^)())tappedBlock;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) MEAlertViewButtonButtonTapped tappedBlock;
@end

@implementation MEAlertViewButton

- (id)initWithTitle:(NSString *)title onTapped:(void(^)())tappedBlock {
    self = [super init];
    if (self) {
        self.title = title;
        self.tappedBlock = tappedBlock;
    }
    
    return self;
}

@end

@interface AlertViewWithBlockOrSEL()
@property (nonatomic, assign) id<UIAlertViewDelegate> alertViewDelegate;
@property (nonatomic, strong) NSMutableArray *alertViewButtons;
- (void)addButton:(MEAlertViewButton *)button;
@end

@implementation AlertViewWithBlockOrSEL

#pragma mark - Constructors

- (id)initWithTitle:(NSString *)title message:(NSString *)message {
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        self.delegate = self;
        self.alertViewButtons = [NSMutableArray array];
    }
    
    return self;
}


- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate {
    self = [self initWithTitle:title message:message];
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}


#pragma mark - Public

- (void)setCancelButtonWithTitle:(NSString *)title {
    [self addOtherButtonWithTitle:title];
    self.cancelButtonIndex = self.numberOfButtons - 1;
}


- (void)setCancelButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    [self addOtherButtonWithTitle:title target:target action:action];
    self.cancelButtonIndex = self.numberOfButtons - 1;
}


- (void)setCancelButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action withObject:(id)object {
    [self addOtherButtonWithTitle:title target:target action:action withObject:object];
    self.cancelButtonIndex = self.numberOfButtons - 1;
}


- (void)setCancelButtonWithTitle:(NSString *)title onTapped:(void(^)())tappedBlock {
    [self addOtherButtonWithTitle:title onTapped:tappedBlock];
    self.cancelButtonIndex = self.numberOfButtons - 1;
}


- (void)addOtherButtonWithTitle:(NSString *)title {
    MEAlertViewButton *alertViewButton = [[MEAlertViewButton alloc] initWithTitle:title onTapped:nil];
    
    [self addButton:alertViewButton];
}


- (void)addOtherButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    MEAlertViewButton *alertViewButton = [[MEAlertViewButton alloc] initWithTitle:title onTapped:^{
        [target performSelector:action];
    }];
    
    [self addButton:alertViewButton];
}


- (void)addOtherButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action withObject:(id)object {
    MEAlertViewButton *alertViewButton = [[MEAlertViewButton alloc] initWithTitle:title onTapped:^{
        [target performSelector:action withObject:object];
    }];
    
    [self addButton:alertViewButton];
}


- (void)addOtherButtonWithTitle:(NSString *)title onTapped:(void(^)())tappedBlock {
    MEAlertViewButton *alertViewButton = [[MEAlertViewButton alloc] initWithTitle:title onTapped:tappedBlock];
    
    [self addButton:alertViewButton];
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.alertViewButtons.count > buttonIndex) {
        MEAlertViewButton *button = [self.alertViewButtons objectAtIndex:buttonIndex];
        if (button.tappedBlock) button.tappedBlock();
    }
    
    if ([self.alertViewDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.alertViewDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}


- (void)alertViewCancel:(UIAlertView *)alertView {
    if ([self.alertViewDelegate respondsToSelector:@selector(alertViewCancel:)]) {
        [self.alertViewDelegate alertViewCancel:alertView];
    } else if (self.cancelButtonIndex != -1) {
        [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:NO];
    }
}


- (void)willPresentAlertView:(UIAlertView *)alertView {
    if ([self.alertViewDelegate respondsToSelector:@selector(willPresentAlertView:)]) {
        [self.alertViewDelegate willPresentAlertView:alertView];
    }
}


- (void)didPresentAlertView:(UIAlertView *)alertView {
    if ([self.alertViewDelegate respondsToSelector:@selector(didPresentAlertView:)]) {
        [self.alertViewDelegate didPresentAlertView:alertView];
    }
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([self.alertViewDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)]) {
        [self.alertViewDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([self.alertViewDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)]) {
        [self.alertViewDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
    }
}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    if ([self.alertViewDelegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)]) {
        return [self.alertViewDelegate alertViewShouldEnableFirstOtherButton:alertView];
    } else {
        return YES;
    }
}


#pragma mark - UIAlertView

- (void)setDelegate:(id)delegate {
    if (self.delegate) {
        
        self.alertViewDelegate = delegate;
    } else {
        
        [super setDelegate:delegate];
    }
}


#pragma mark - Private

- (void)addButton:(MEAlertViewButton *)button {
    [self addButtonWithTitle:button.title];
    [self.alertViewButtons addObject:button];
}

@end

#pragma clang diagnostic pop
