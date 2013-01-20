//
//  LBViewController.h
//  LisaBirthdayApp
//
//  Created by Aaron Kaufer on 1/16/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CODialog;
@interface LBViewController : UIViewController
- (IBAction)NewFolder:(id)sender;
- (IBAction)NewItem:(id)sender;
- (IBAction)refresh:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *listContent;
-(UIView*)createListItemWithIndex:(int)ind andTitle:(NSString*)title andType:(NSString*)itemType andQuantity:(NSString*)quan;
-(CGSize)calculateContentSize;
-(void)editItemOfIndex:(int)indexOfItem;
@property (strong)CODialog *dialog;
@property NSMutableArray *currentDirectory;
-(NSArray*)getCurrentList;
-(void)editFolder;
@end
