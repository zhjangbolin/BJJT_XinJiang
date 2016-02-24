//
//  XJHistoryTableViewCell.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/21.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "XJHistoryTableViewCell.h"

@implementation XJHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)btnClicked:(UIButton *)sender {
    
    if (sender == _currentBtn) {
        
        [_delegate pushNextViewControllerWith:@"1" and:_appcaseno and:_isbespeak and:_scepicoverd and:_dampicoverd and:_acctype];
        
    }else if (sender == _responsBtn){
        
        [_delegate pushNextViewControllerWith:@"2" and:_appcaseno and:_isbespeak and:_scepicoverd and:_dampicoverd and:_acctype];
    }else if (sender == _appointmentBtn){
        
        [_delegate pushNextViewControllerWith:@"3" and:_appcaseno and:_isbespeak and:_scepicoverd and:_dampicoverd and:_acctype];
        
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
