//
//  ViewController.m
//  ObjectiveCLabb3
//
//  Created by Christian Jäderberg on 2020-01-17.
//  Copyright © 2020 Christian Jäderberg. All rights reserved.
//

#import "TodoListViewController.h"

@interface TodoListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *todoTextField;
@property (weak, nonatomic) IBOutlet UIButton *addItemButton;

@property (nonatomic) NSMutableArray *items;

@end

@implementation TodoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // hide keyboard code
    self.todoTextField.delegate = self;
    
    // create array with dictionary items
    self.items = @[@{@"name": @"Gör det här", @"completed": @NO}, @{@"name": @"Gör det här också", @"completed": @YES}.mutableCopy].mutableCopy;
    
}

// hide keyboard when enter is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return true;
}

// add item button is pressed
- (IBAction)addItemButtonPressed:(id)sender {
    [self addNewItem];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    // get current list item
    NSDictionary *item = self.items[indexPath.row];
    
    cell.textLabel.text = item[@"name"];
    
    // check if item is completed, if so add checkmark
    if ([item[@"completed"] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

// a row is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // get current list item
    NSMutableDictionary *item = [self.items[indexPath.row] mutableCopy];
    
    // invert the status of completion for the item
    if ([item[@"completed"] boolValue]) {
        item[@"completed"] = @NO;
    } else {
        item[@"completed"] = @YES;
    }
    
    // save the changed item in the todolist array
    self.items[indexPath.row] = item;
    
    // check if item is completed or not and set the checkmark accordingly
    cell.accessoryType = ([item[@"completed"] boolValue]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    // deselect the row to remove grey selection
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)addNewItem {
    // get text from textfield
    NSString *newItemName = self.todoTextField.text;
    
    // check if textfield is empty, if it is show alert, otherwise save and show new todo item
    if (![newItemName isEqualToString:@""]) {
        // save current textfield-text as new todo-item
        NSMutableDictionary *newItem = @{@"name": newItemName, @"completed": @NO}.mutableCopy;
        [self.items addObject:newItem];
           
        // clear textfield
        self.todoTextField.text = @"";
           
        // show new item in tableview
        NSInteger indexPath = self.items.count - 1;
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        // create and show alert message
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Fel inmatning!" message:@"Du behöver skriva något" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:actionOk];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
