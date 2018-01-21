//
//  ADSearchBar.h
//  ADSearchBar
//
//  Created by alisandagdelen on 19.01.2018.
//


#import <UIKit/UIKit.h>

@class ADSearchBar;

@protocol ADSearchBarDelegate <NSObject>

@optional
- (void)ADSearchBarSearchButtonClicked:(ADSearchBar * _Nonnull)searchBar;

- (void)ADSearchBarCancelButtonClicked:(ADSearchBar * _Nonnull)searchBar;

- (BOOL)ADSearchBarShouldBeginEditing:(ADSearchBar * _Nonnull)searchBar;

- (void)ADSearchBarTextDidBeginEditing:(ADSearchBar * _Nonnull)searchBar;

- (BOOL)ADSearchBarShouldEndEditing:(ADSearchBar * _Nonnull)searchBar;

- (void)ADSearchBarTextDidEndEditing:(ADSearchBar * _Nonnull)searchBar;

- (BOOL)ADSearchBar:(ADSearchBar * _Nonnull)searchBar shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString * _Nonnull)string;


@end

IB_DESIGNABLE

@interface ADSearchBar : UIView <UITextFieldDelegate>

@property (nonatomic, strong) IBInspectable UIImage * _Nullable lensImage;
@property (nonatomic, weak) IBOutlet UITextField * _Nullable searchTextField;
@property (nonatomic, assign) IBInspectable id <ADSearchBarDelegate> _Nullable delegate;
@property (nonatomic, strong) NSString * _Nonnull text;
@property (nonatomic, assign) UIFont * _Nullable font;
@property (nonatomic, assign) UIColor * _Nullable placeHolderColor;
@property (nonatomic, weak) IBOutlet UIView * _Nullable searchFieldsContainerView;
@property (nonatomic, weak) IBOutlet UIButton * _Nullable cancelButton;

@property (nonatomic, strong) NSString * _Nullable placeHolderStr;
@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, strong) IBInspectable UIColor * _Nullable textColor;

@end

