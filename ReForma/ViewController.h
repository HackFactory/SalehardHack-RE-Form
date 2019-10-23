//
//  ViewController.h
//  ReForma
//
//  Created by Vladislav Shakhray on 23.10.2019.
//  Copyright © 2019 Vladislav Shakhray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSArray<NSArray<NSString *> *> *data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

