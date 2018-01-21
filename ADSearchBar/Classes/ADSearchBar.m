//
//  ADSearchBar.m
//  ADSearchBar
//
//  Created by alisandagdelen on 19.01.2018.
//

#import "ADSearchBar.h"


@interface ADSearchBar()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContainerLeft;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *containerRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *extraCancelWConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textfieldRightConstraint;
@property (nonatomic, strong) ADSearchBar * _Nonnull view;
@property (nonatomic, assign) CGRect orginalFrame;
@end

@implementation ADSearchBar

#pragma mark - Init methods

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self xibSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self xibSetup];
    }
    return self;
}

#pragma mark - UI setup methods
- (void) xibSetup
{
    UINib *nib = [UINib nibWithNibName:@"ADSearchBar" bundle: [NSBundle bundleForClass:[self class]]];
    self.view = [nib instantiateWithOwner:self options:nil].firstObject;
    self.view.frame = [self bounds];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    [self addSubview:self.view];
    
    self.orginalFrame = [self bounds];
    [self addCancelButton];
    [self customizeTextfield];
}

- (void) willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    self.searchTextField.delegate = self;
    self.searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.searchTextField setReturnKeyType:UIReturnKeySearch];
    [self.searchTextField setTextColor:self.textColor];
}

-(void)didMoveToSuperview {
    
    if (self.placeHolderColor) {
        self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeHolderStr attributes:@{NSForegroundColorAttributeName: self.placeHolderColor}];
    }else{
        self.searchTextField.placeholder = self.placeHolderStr;
    }
}

-(void)customizeTextfield {
    NSString *placeHolderString = NSLocalizedString(@"Search", nil);
    self.placeHolderStr = [placeHolderString stringByAppendingString:@"                                                                                                            "];
    self.placeHolderColor = [UIColor grayColor];
    [self setTextColor:[UIColor grayColor]];
}

- (void) addImageToTextfield:(UIImage*)image {
    UIImageView * iconImageView = [[UIImageView alloc] initWithImage:image];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(20, -1, 15, 15)];
    [iconImageView setFrame:CGRectMake(7,-1, 15, 15)];
    [paddingView addSubview:iconImageView];
    self.searchTextField.leftView = paddingView;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
}


#pragma mark - Utility methods

- (void)addCancelButton {
    if ([self.cancelButton.titleLabel.text isEqualToString:@"Button"]) {
        [self.cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    }
    
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //        self.cancelButton.hidden = YES;
    [self hideCancel];
}

-(void) showCancel{
    
    if (!self.cancelButton.hidden) {
        return;
    }
    
    self.cancelButton.hidden = NO;
    CGRect frame = self.searchFieldsContainerView.frame;
    frame.size.width -= 80;
    
    CGRect frame2 = self.cancelButton.frame;
    frame2.size.width = 60;
    frame2.origin.x -= 60;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.searchFieldsContainerView.frame = frame;
        self.cancelButton.frame = frame2;
        self.extraCancelWConstraint.constant = 60;
        self.containerRightConstraint.constant = 10;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

-(void) hideCancel{
    
    CGRect frame = self.searchFieldsContainerView.frame;
    frame.size.width += 80;
    
    CGRect frame2 = self.cancelButton.frame;
    frame2.size.width = 0;
    frame2.origin.x += 60;
    [UIView animateWithDuration:0.15 animations:^{
        self.searchFieldsContainerView.frame = frame;
        self.cancelButton.frame = frame2;
        self.extraCancelWConstraint.constant = 0;
        self.containerRightConstraint.constant = -10;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.cancelButton.hidden = YES;
    }];
}

- (BOOL) resignFirstResponder{
    return [self.searchTextField resignFirstResponder];
}

- (void) cancelAction:(id) sender{
    
    self.searchTextField.text = @"";
    if (!self.searchTextField.isFirstResponder) {
        [self hideCancel];
    }
    [self resignFirstResponder];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ADSearchBarCancelButtonClicked:)]) {
        [self.delegate ADSearchBarCancelButtonClicked:self];
    }
}

#pragma mark - GET SET methods

-(void)setText:(NSString * _Nonnull)text {
    self.searchTextField.text = text;
}

-(void)setShowsCancelButton:(BOOL)showsCancelButton {
    
    _showsCancelButton = showsCancelButton;
    if (showsCancelButton) {
        [self showCancel];
    } else {
        [self hideCancel];
    }
}

-(NSString *) text{
    return self.searchTextField.text;
}

-(void) setFont:(UIFont *)font{
    _font = font;
    [self.searchTextField setFont:font];
}

-(void) setTextColor:(UIColor *)color{
    _textColor = color;
    if (self.searchTextField.superview) {
        [self.searchTextField setTextColor:color];
    }
}

- (void) setPlaceHolderColor:(UIColor *)color{
    _placeHolderColor = color;
    
    if (self.searchTextField) {
        self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeHolderStr attributes:@{NSForegroundColorAttributeName: color}];
    }
    
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self showCancel];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ADSearchBarShouldBeginEditing:)]) {
        [self.delegate ADSearchBarShouldBeginEditing:self];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ADSearchBarTextDidBeginEditing:)]) {
        [self.delegate ADSearchBarTextDidBeginEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  
    if (self.delegate) {
        [self.delegate ADSearchBar:self shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField.text.length <= 0) {
        [self hideCancel];
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ADSearchBarShouldEndEditing:)]) {
        [self.delegate ADSearchBarShouldEndEditing:self];
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    if (self.searchTextField.text.length <= 0) {
        return NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ADSearchBarSearchButtonClicked:)]) {
        [self.delegate ADSearchBarSearchButtonClicked:self];
    }else{
        [self.searchTextField resignFirstResponder];
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ADSearchBarTextDidEndEditing:)]) {
        [self.delegate ADSearchBarTextDidEndEditing:self];
    }
}

@end


