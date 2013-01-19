//
//  LBViewController.m
//  LisaBirthdayApp
//
//  Created by Aaron Kaufer on 1/16/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import "LBViewController.h"
#import "ODSDataStorage.h"

@interface LBViewController ()

@end

@implementation LBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   /* [ODSDataStorage setData:[NSArray arrayWithObjects:
                             [NSDictionary dictionaryWithObjectsAndKeys:@"eggs",@"title",@"item",@"type", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"milk",@"title",@"folder",@"type", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"eggs2",@"title",@"item",@"type", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"milk2",@"title",@"folder",@"type", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"eggs3",@"title",@"item",@"type", nil],
                             [NSDictionary dictionaryWithObjectsAndKeys:@"milk3",@"title",@"folder",@"type", nil],
                             
                            nil] forThisAppWithKey:@"list"]; */
    //[ODSDataStorage loadURL:@"ASKProductsDatabase4499-LisaBirthdayApp={\"a\":\"d\"}" forMethod:@"POST"];
    [ODSDataStorage setValue:@"hello" withKey:@"goodbye"];
    NSLog(@"%@",[ODSDataStorage onlineData]);
    
    //[self refresh:nil];
}

- (CGSize)calculateContentSize{
    CGSize content;
    NSArray *appData = [ODSDataStorage getDataForThisAppWithKey:@"list"];
    int count = [appData count];
    content = CGSizeMake(320, 80*count+320);
    return content;
}

- (IBAction)NewFolder:(id)sender {
}

- (IBAction)NewItem:(id)sender {
}

- (IBAction)refresh:(id)sender {
    [self.listContent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.listContent setBackgroundColor:[UIColor grayColor]];
    CGSize contentSize = [self calculateContentSize];
    [self.listContent setContentSize:contentSize];
    NSArray *listEntries = [ODSDataStorage getDataForThisAppWithKey:@"list"];
    for (int i = 0; i<(contentSize.height-320)/80; i++) {
        NSDictionary *itemProperties = [listEntries objectAtIndex:i];
        UIView *item = [self createListItemWithIndex:i andTitle:[itemProperties objectForKey:@"title"] andType:[itemProperties objectForKey:@"type"]];
        [self.listContent addSubview:item];
    }
    
}
-(UIView*)createListItemWithIndex:(int)ind andTitle:(NSString*)title andType:(NSString*)itemType{
    CGRect itemFrame = CGRectMake(0, ind*80, 320, 80);
    UIView *item = [[UIView alloc] initWithFrame:itemFrame];
    [item setBackgroundColor:[UIColor blackColor]];
    int tag = ([itemType isEqualToString:@"item"])?100:200;
    [item setTag:tag+ind];
    
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton setFrame:CGRectMake(0, 0, 320, 80)];
    [itemButton setBackgroundColor:[UIColor blackColor]];
    [itemButton addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [itemButton setTag:tag+ind];
    [item addSubview:itemButton];
    
    UIImageView *itemIcon = [[UIImageView alloc] initWithImage:([itemType isEqualToString:@"item"])?[UIImage imageNamed:@"shoplist.png"]:[UIImage imageNamed:@"folder.png"]];
    [itemIcon setFrame:CGRectMake(20, 10, 60, 60)];
    [item addSubview:itemIcon];
    
    UILabel *itemTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 240, 80)];
    [itemTitle setBackgroundColor:[UIColor blackColor]];
    [itemTitle setFont:[UIFont fontWithName:@"Helvetica" size:22]];
    [itemTitle setTextColor:[UIColor whiteColor]];
    [itemTitle setNumberOfLines:4];
    [itemTitle setTextAlignment:NSTextAlignmentCenter];
    [itemTitle setText:title];
    [item addSubview:itemTitle];
    
    return item;
}
-(void)itemPressed:(UIView*)item{
   // [self.listContent scrollRectToVisible:CGRectMake(0, 0, 320, 80) animated:YES];
    [self.listContent scrollRectToVisible:CGRectMake(0, item.frame.origin.y+280, 320, 80) animated:YES];
    
}
-(void)editItem:(UIView*)item{
    
}


@end















