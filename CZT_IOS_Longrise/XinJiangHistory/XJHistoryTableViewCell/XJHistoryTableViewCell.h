//
//  XJHistoryTableViewCell.h
//  CZT_IOS_Longrise
//
//  Created by 张博林 on 16/1/21.
//  Copyright © 2016年 程三. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XJHistoryTableViewCellDelegate <NSObject>

-(void)pushNextViewControllerWith:(NSString *)state and:(NSString *)appcaseno and:(NSString *)isbespeak and:(NSString *)scepicoverd and:(NSString *)dampicoverd and:(NSString *)acctype;

@end

@interface XJHistoryTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *caseaddress;
@property (nonatomic, copy) NSString *scebegintime;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *dampicoverd;
@property (nonatomic, copy) NSString *isbespeak;
@property (nonatomic, copy) NSString *scepicoverd;
@property (nonatomic, copy) NSString *acctype;
@property (nonatomic, copy) NSString *appcaseno;

@property (weak, nonatomic) IBOutlet UIButton *currentTakePhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *responseTakePhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *goToAppointmentBtn;


@property (weak, nonatomic) IBOutlet UILabel *acctypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *caseStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *accidentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;
@property (weak, nonatomic) IBOutlet UILabel *appointmentLabel;

@property (weak, nonatomic) IBOutlet UIButton *currentBtn;
@property (weak, nonatomic) IBOutlet UIButton *responsBtn;
@property (weak, nonatomic) IBOutlet UIButton *appointmentBtn;


@property (assign,nonatomic)id <XJHistoryTableViewCellDelegate>delegate;

@end
