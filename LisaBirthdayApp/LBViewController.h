//
//  LBViewController.h
//  LisaBirthdayApp
//
//  Created by Aaron Kaufer on 1/16/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBViewController : UIViewController
- (IBAction)NewFolder:(id)sender;
- (IBAction)NewItem:(id)sender;
- (IBAction)refresh:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *listContent;
-(UIView*)createListItemWithIndex:(int)ind andTitle:(NSString*)title andType:(NSString*)itemType;
-(CGSize)calculateContentSize;
-(void)editItem:(UIView*)item;
@end
