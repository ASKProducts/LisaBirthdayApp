//
//  LBViewController.m
//  LisaBirthdayApp
//
//  Created by Aaron Kaufer on 1/16/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import "LBViewController.h"
#import "ODSDataStorage.h"
#import "CODialog.h"
#import "LBAppDelegate.h"

#define ATTACK_CURRENT_DIRECTORY(action) \
NSMutableArray *fullList = [ODSDataStorage getValueForKey:@"list"]; \
NSMutableArray *temp = fullList; \
for (int i = 1; i<self.currentDirectory.count; i++) { \
    NSMutableArray *newArray; \
    for (NSDictionary *item in temp) { \
        if([[item objectForKey:@"title"] isEqualToString:[self.currentDirectory objectAtIndex:i]] && [[item objectForKey:@"type"] isEqualToString:@"folder"]) \
            newArray = [item objectForKey:@"contents"]; \
    } \
    temp = newArray; \
} \
action \
[ODSDataStorage setValue:fullList withKey:@"list"]; 

@interface LBViewController ()

@end
/*[ODSDataStorage setValue:[NSArray arrayWithObjects:
 [NSDictionary dictionaryWithObjectsAndKeys:@"eggs",@"title",@"item",@"type",@"2",@"quantity", nil],
 
 [NSDictionary dictionaryWithObjectsAndKeys:@"folder1",@"title",@"folder",@"type",@"2",@"quantity",[NSMutableArray arrayWithObjects:
 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Back",@"title",@"back",@"type", nil],
 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Edit",@"title",@"edit",@"type", nil],
 
 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"eggs4",@"title",@"item",@"type",@"2",@"quantity", nil],
 
 [NSMutableDictionary dictionaryWithObjectsAndKeys:@"eggs5",@"title",@"item",@"type",@"2",@"quantity", nil],
 
 nil]
 
 ,@"contents", nil],
 
 [NSDictionary dictionaryWithObjectsAndKeys:@"eggs2",@"title",@"item",@"type",@"2",@"quantity", nil],
 [NSDictionary dictionaryWithObjectsAndKeys:@"eggs3",@"title",@"item",@"type",@"2",@"quantity", nil],
 
 nil] withKey:@"list"];*/

@implementation LBViewController

- (void)viewDidLoad
{
    

    //log the data, initialize the dialog box, restart the directory array, and refresh the screen
    NSLog(@"%@",[ODSDataStorage onlineData]);
    self.dialog = [CODialog dialogWithWindow:[(LBAppDelegate*)[UIApplication sharedApplication].delegate window]];
    self.currentDirectory = [NSMutableArray arrayWithObjects:@"Main", nil];
    [self refresh:nil];
}

-(NSArray*)getCurrentList{
    //get the online value for the entire list
    NSArray *list = [ODSDataStorage getValueForKey:@"list"];
    
    //loop through self.currentDirectory until we are inside of the current folder and return that array
    for (int i = 1; i<self.currentDirectory.count; i++) {
        NSArray *nextList;
        for (NSDictionary *item in list) {
            if([[item objectForKey:@"title"] isEqualToString:[self.currentDirectory objectAtIndex:i]] && [[item objectForKey:@"type"] isEqualToString:@"folder"])
                nextList = [item objectForKey:@"contents"];
        }
        if(nextList)list = nextList;
    }
    return list;
}

- (CGSize)calculateContentSize{
    CGSize content;
    NSArray *appData = [self getCurrentList];
    int count = [appData count];
    content = CGSizeMake(320, 80*count);
    return content;
}

- (IBAction)NewFolder:(id)sender {
    [self.dialog resetLayout];
    
    self.dialog.dialogStyle = CODialogStyleDefault;
    self.dialog.title = @"New Folder";
    
    [self.dialog addTextFieldWithPlaceholder:@"Name" secure:NO];
    
    [self.dialog addButtonWithTitle:@"Cancel" target:self selector:@selector(cancel:)];
    [self.dialog addButtonWithTitle:@"Create" target:self selector:@selector(createFolder:) highlighted:YES];
    [self.dialog showOrUpdateAnimated:YES];
}

- (IBAction)NewItem:(id)sender {
    
    [self.dialog resetLayout];
    
    self.dialog.dialogStyle = CODialogStyleDefault;
    self.dialog.title = @"New Item";
    
    [self.dialog addTextFieldWithPlaceholder:@"Item" secure:NO];
    [self.dialog addTextFieldWithPlaceholder:@"Quantity" secure:NO];
    
    [self.dialog addButtonWithTitle:@"Cancel" target:self selector:@selector(cancel:)];
    [self.dialog addButtonWithTitle:@"Create" target:self selector:@selector(createItem:) highlighted:YES];
    [self.dialog showOrUpdateAnimated:YES];
}
-(void)createItem:(id)sender{
    [self.dialog hideAnimated:YES];
    
    NSMutableDictionary *newItem = [NSMutableDictionary dictionary];
    [newItem setValue:@"item" forKey:@"type"];
    [newItem setValue:[self.dialog textForTextFieldAtIndex:0] forKey:@"title"];
    [newItem setValue:[self.dialog textForTextFieldAtIndex:1] forKey:@"quantity"];
    
    ATTACK_CURRENT_DIRECTORY([temp addObject:newItem];)
    
    [self refresh:nil];
}
-(void)createFolder:(id)sender{
    [self.dialog hideAnimated:YES];
    
    NSMutableDictionary *newFolder = [NSMutableDictionary dictionary];
    [newFolder setValue:@"folder" forKey:@"type"];
    [newFolder setValue:[self.dialog textForTextFieldAtIndex:0] forKey:@"title"];
    [newFolder setValue:@"" forKey:@"quantity"];
    NSMutableArray *newContents = [NSMutableArray arrayWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Back",@"title",@"back",@"type", nil],[NSMutableDictionary dictionaryWithObjectsAndKeys:@"Edit",@"title",@"edit",@"type", nil], nil];
    [newFolder setValue:newContents forKey:@"contents"];
    
    ATTACK_CURRENT_DIRECTORY([temp addObject:newFolder];)
    
    [self refresh:nil];
}

//the function refresh sets up the scroll view with small UIView's called items. it gets called everytime a change is made to the online database or the refresh button is pressed
- (IBAction)refresh:(id)sender {
    
    //beign by initializing the scroll view
    [self.listContent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.listContent setBackgroundColor:[UIColor grayColor]];
    
    //calculate how big the scroll view must be by multiplying the number of items in the directory by the set height (80)
    CGSize contentSize = [self calculateContentSize];
    [self.listContent setContentSize:contentSize];
    
    //retrieve an array of the values in the current directory (visit the function to see more)
    NSArray *listEntries = [self getCurrentList];
    
    //loop through each of the items in the current directory, and build and display them in the scroll view using [self createListItemWithIndex]
    for (int i = 0; i<(contentSize.height)/80; i++) {
        NSDictionary *itemProperties = [listEntries objectAtIndex:i];
        UIView *item = [self createListItemWithIndex:i andTitle:[itemProperties objectForKey:@"title"] andType:[itemProperties objectForKey:@"type"] andQuantity:[itemProperties objectForKey:@"quantity"]];
        [self.listContent addSubview:item];
    }
    
}
-(UIView*)createListItemWithIndex:(int)ind andTitle:(NSString*)title andType:(NSString*)itemType andQuantity:(NSString*)quan{
    //build the containing view of proper size and location and type
    CGRect itemFrame = CGRectMake(0, ind*80, 320, 80);
    UIView *item = [[UIView alloc] initWithFrame:itemFrame];
    [item setBackgroundColor:[UIColor blackColor]];
    int tag = ([itemType isEqualToString:@"item"])?100:([itemType isEqualToString:@"folder"])?200:([itemType isEqualToString:@"back"])?300:400;
    [item setTag:tag+ind];
    
    //make a giant transparent button on top of it all, and link it to [self itemPressed:]
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton setFrame:CGRectMake(0, 0, 320, 80)];
    [itemButton setBackgroundColor:[UIColor blackColor]];
    [itemButton addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [itemButton setTag:tag+ind];
    [item addSubview:itemButton];
    
    // make the icon for the item based on its type
    UIImageView *itemIcon = [[UIImageView alloc] initWithImage:(tag==100)?[UIImage imageNamed:@"shoplist.png"]:(tag==200)?[UIImage imageNamed:@"folder.png"]:(tag==300)?[UIImage imageNamed:@"back.png"]:[UIImage imageNamed:@"edit-icon.png"]];
    [itemIcon setFrame:CGRectMake(20, 10, 60, 60)];
    [item addSubview:itemIcon];
    
    // finally build the giant label that desplays the actual text of the item
    UILabel *itemTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 240, 80)];
    [itemTitle setBackgroundColor:[UIColor blackColor]];
    [itemTitle setFont:[UIFont fontWithName:@"Helvetica" size:22]];
    [itemTitle setTextColor:[UIColor whiteColor]];
    [itemTitle setNumberOfLines:4];
    [itemTitle setTextAlignment:NSTextAlignmentCenter];
    [itemTitle setText:title];
    if(tag==100)
        [itemTitle setText:[title stringByAppendingFormat:@" (%@)",quan]];
    [item addSubview:itemTitle];
    
    return item;
}
-(void)itemPressed:(UIView*)item{
    //figure out what type of item was pressed, then go accordingly
    int indexOfItem =(item.tag%100);
    
    switch (item.tag-indexOfItem) {
        case 100: //item
            [self editItemOfIndex:indexOfItem];
            break;
        case 200: //folder
            [self.currentDirectory addObject:[[[self getCurrentList] objectAtIndex:indexOfItem] valueForKey:@"title"]];
            [self refresh:nil];
            break;
        case 300: //back
            [self.currentDirectory removeLastObject];
            [self refresh:nil];
            break;
        case 400: //edit
            [self editFolder];
            break;
        default:
            break;
    }

}
-(void)editFolder{
    [self.dialog resetLayout];
    
    self.dialog.dialogStyle = CODialogStyleDefault;
    self.dialog.title = [self.currentDirectory lastObject];
    
    [self.dialog addTextFieldWithPlaceholder:@"Name" secure:NO];
    
    [self.dialog addButtonWithTitle:@"Cancel" target:self selector:@selector(cancel:)];
    [self.dialog addButtonWithTitle:@"Delete" target:self selector:@selector(removeFolder:) highlighted:YES];
    [self.dialog addButtonWithTitle:@"Save" target:self selector:@selector(saveFolderEdit:) highlighted:YES];
    [self.dialog showOrUpdateAnimated:YES];
}
-(void)removeFolder:(id)sender{
    [self.dialog hideAnimated:YES];
    NSMutableArray *fullList = [ODSDataStorage getValueForKey:@"list"];
    NSMutableArray *temp = fullList; 
    for (int i = 1; i<self.currentDirectory.count-1; i++) {
        NSMutableArray *newArray; 
        for (NSDictionary *item in temp) { 
            if([[item objectForKey:@"title"] isEqualToString:[self.currentDirectory objectAtIndex:i]] && [[item objectForKey:@"type"] isEqualToString:@"folder"]) 
                newArray = [item objectForKey:@"contents"]; 
        } 
        temp = newArray; 
    } 
    for (int i = 0;i<temp.count; i++) {
        if([[[temp objectAtIndex:i] objectForKey:@"title"] isEqualToString:[self.currentDirectory lastObject]] && [[[temp objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"folder"]){
            [temp removeObjectAtIndex:i];
            break;
        }
    }
    [ODSDataStorage setValue:fullList withKey:@"list"];
    
    [self.currentDirectory removeLastObject];
    [self refresh:nil];
}
-(void)saveFolderEdit:(id)sender{
    [self.dialog hideAnimated:YES];
    NSMutableArray *fullList = [ODSDataStorage getValueForKey:@"list"];
    NSMutableArray *temp = fullList;
    for (int i = 1; i<self.currentDirectory.count-1; i++) {
        NSMutableArray *newArray;
        for (NSDictionary *item in temp) {
            if([[item objectForKey:@"title"] isEqualToString:[self.currentDirectory objectAtIndex:i]] && [[item objectForKey:@"type"] isEqualToString:@"folder"])
                newArray = [item objectForKey:@"contents"];
        }
        temp = newArray;
    }
    for (int i = 0;i<temp.count; i++) {
        if([[[temp objectAtIndex:i] objectForKey:@"title"] isEqualToString:[self.currentDirectory lastObject]] && [[[temp objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"folder"]){
            [[temp objectAtIndex:i] setValue:[self.dialog textForTextFieldAtIndex:0] forKey:@"title"];
            break;
        }
    }
    [ODSDataStorage setValue:fullList withKey:@"list"];
}
-(void)editItemOfIndex:(int)indexOfItem{
    NSDictionary *itemDict = [[self getCurrentList] objectAtIndex:indexOfItem];
    NSString *item = [itemDict valueForKey:@"title"];
    NSString *quantity = [itemDict valueForKey:@"quantity"];
    
    
    [self.dialog resetLayout];
    
    self.dialog.dialogStyle = CODialogStyleDefault;
    self.dialog.title = item;
    self.dialog.subtitle = [NSString stringWithFormat:@"Quantity: %@ \n\nEdit:",quantity];
    self.dialog.tag = indexOfItem;
    
    [self.dialog addTextFieldWithPlaceholder:@"Item" secure:NO];
    
    [self.dialog addTextFieldWithPlaceholder:@"Quantity" secure:NO];
    //[self.dialog addTextFieldWithPlaceholder:@"Pin" secure:NO];
    
    [self.dialog addButtonWithTitle:@"Cancel" target:self selector:@selector(cancel:)];
    [self.dialog addButtonWithTitle:@"Delete" target:self selector:@selector(removeItem:) highlighted:YES];
    [self.dialog addButtonWithTitle:@"Save" target:self selector:@selector(saveEdit:) highlighted:YES];
    [self.dialog showOrUpdateAnimated:YES];
}

-(void)cancel:(id)sender{
    [self.dialog hideAnimated:YES];
    
}
-(void)removeItem:(id)sender{
    [self.dialog hideAnimated:YES];
    
    ATTACK_CURRENT_DIRECTORY([temp removeObjectAtIndex:self.dialog.tag];)
    
    [self refresh:nil];
}
-(void)saveEdit:(id)sender{
    [self.dialog hideAnimated:YES];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[self getCurrentList]];
    NSMutableDictionary *newItem = [NSMutableDictionary dictionaryWithDictionary:[arr objectAtIndex:self.dialog.tag]];
    if([self.dialog textForTextFieldAtIndex:0]!=nil && [self.dialog textForTextFieldAtIndex:0]!=@"")[newItem setValue:[self.dialog textForTextFieldAtIndex:0] forKey:@"title"];
    if([self.dialog textForTextFieldAtIndex:1]!=nil && [self.dialog textForTextFieldAtIndex:1]!=@"")[newItem setValue:[self.dialog textForTextFieldAtIndex:1] forKey:@"quantity"];
    //[arr replaceObjectAtIndex:self.dialog.tag withObject:newItem];
    
    ATTACK_CURRENT_DIRECTORY([temp replaceObjectAtIndex:self.dialog.tag withObject:newItem];)
    
    [self refresh:nil];
    
    //[arr replaceObjectAtIndex:self.dialog.tag withObject:[NSDictionary dictionaryWithObjectsAndKeys:[self], nil]
}



@end















