//
//  ViewController.m
//  ReForma
//
//  Created by Vladislav Shakhray on 23.10.2019.
//  Copyright © 2019 Vladislav Shakhray. All rights reserved.
//

#import "ViewController.h"
#import "PromiseTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   _data = [[NSUserDefaults standardUserDefaults] objectForKey:@"promises"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"header1"];
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"header2"];
//
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"progress"];
//    [_tableView registerClass:[PromiseTableViewCell class] forCellReuseIdentifier:@"promise"];


    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3 + _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [tableView dequeueReusableCellWithIdentifier:@"header1"];
    } else if (indexPath.row == 1) {
        return [tableView dequeueReusableCellWithIdentifier:@"progress"];
    } else if (indexPath.row == 2) {
        return [tableView dequeueReusableCellWithIdentifier:@"header2"];
    } else {
        PromiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"promise"];
        cell.name.text = _data[indexPath.row - 3][0];
        
        cell.innerView.layer.cornerRadius = 10;
        if (indexPath.row <= 5) {
            cell.facepile.image = [UIImage imageNamed:[NSString stringWithFormat:@"face%d", indexPath.row- 2]];
        }
        
        [cell.innerView.layer setCornerRadius:10.0f];
        
        if (![_data[indexPath.row - 3][2] isEqualToString:@"huy"]) {
            cell.logo.image = [UIImage imageNamed:_data[indexPath.row - 3][2]];
        }
        
        //cell.innerView.clipsToBounds = YES
        cell.bottomView.layer.cornerRadius = 10.0f;
        cell.price.text = _data[indexPath.row - 3][1];
            // boorder
            [cell.innerView.layer setBorderColor:[UIColor clearColor].CGColor];
        //        [cell.innerView.layer setBorderWidth:1.5f];

            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Достижения" style:UIBarButtonItemStylePlain target:self action:@selector(achiv)];
            
            // drop shadow
            [cell.innerView.layer setShadowColor:[UIColor colorWithWhite:0.2 alpha:1.0].CGColor];
            [cell.innerView.layer setShadowOpacity:0.15];
            [cell.innerView.layer setShadowRadius:8.0];
            [cell.innerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
//            [cell.innerView addTarget:self ac
//    tion:@se/lector(contin:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < 3) {
//        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    int i = indexPath.row - 3;
    NSString *title = _data[i][0];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:_data[i][0]
                                   message:[NSString stringWithFormat:@"%@\nВыполнить до 30 октября", _data[i][1]]
                                   preferredStyle:UIAlertControllerStyleActionSheet];
     
    UIAlertAction* doneAction = [UIAlertAction actionWithTitle:@"Сделано" style:UIAlertActionStyleCancel
       handler:^(UIAlertAction * action) {
        
    }];
    UIAlertAction* friendsAction = [UIAlertAction actionWithTitle:@"Найти друзей" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
        [self findFriends];
    }];
    UIAlertAction* igAction = [UIAlertAction actionWithTitle:@"Поделиться" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
        [self shareViaInstagram];
    }];
    [igAction setValue:[[UIImage imageNamed:@"insta"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    
    UIAlertAction* dismissAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {}];
     
    [alert addAction:doneAction];
    [alert addAction:friendsAction];
    [alert addAction:dismissAction];
    [alert addAction:igAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)findFriends {
    //TODO: @mountainviewer

}

- (void)shareViaInstagram {
    //TODO: @mountainviewer
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 72.;
    } else if (indexPath.row == 1) {
        return 160;
    } else if (indexPath.row == 2) {
        return 72.;
    } else {
        return 174;

    }
}

@end
