//
//  TralierTableViewCell.m
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/25.
//  Copyright © 2016年 程三. All rights reserved.
//

#import "TralierTableViewCell.h"

@implementation TralierTableViewCell

- (void)awakeFromNib {
    
//    _adressLabel = [[MCTopAligningLabel alloc]initWithFrame:CGRectMake(_adressWarnLabel.frame.origin.x + _adressWarnLabel.bounds.size.width, _adressWarnLabel.frame.origin.y, 218, 100)];
//    [self.contentView addSubview:_adressLabel];
    
    // Initialization code
}

- (IBAction)phoneCallClicked:(id)sender {
    [self.delegate callWithPhoneNumber:_servicetel];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
