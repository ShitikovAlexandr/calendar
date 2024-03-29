//
//  NFEditTaskController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 5/31/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFEditTaskController.h"
#import "NFDatePicker.h"
#import "NFPickerView.h"
#import "NFSyncManager.h"
#import <UITextView+Placeholder.h>
#import "NFTagView.h"
#import "NFChackBox.h"
#import "NFTagCell.h"
#import "NFActivityIndicatorView.h"


@interface NFEditTaskController ()
<
UITextViewDelegate,
UITextFieldDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *valueTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *selectValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleOfTaskTextField;
@property (weak, nonatomic) IBOutlet UITextView *taskDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UITextField *starttextField;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;
@property (weak, nonatomic) IBOutlet UILabel *compliteLabel;
@property (weak, nonatomic) IBOutlet NFChackBox *compliteButton;
@property (strong, nonatomic) NFPickerView *valuePicker;
@property (strong, nonatomic) NSMutableArray *valuesArray;
@property (strong, nonatomic) NFDatePicker *datePickerStart;
@property (strong, nonatomic) NFDatePicker *datePickerEnd;
@property (assign, nonatomic) CGRect textFrame;
@property (strong, nonatomic) NSMutableArray *selectedTags;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NFActivityIndicatorView *indicator;
@end

@implementation NFEditTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Задача";
    self.selectedTags = [NSMutableArray array];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self setStartDataToDisplay];
    [self configurePickers];
    [self.compliteButton addTarget:self action:@selector(compliteTaskAction) forControlEvents:UIControlEventTouchDown];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NFTagCell" bundle:nil] forCellWithReuseIdentifier:@"NFTagCell"];
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDataToDisplay) name:PICKER_VIEW_IS_PRESSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endUpdate) name:END_UPDATE_DATA object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PICKER_VIEW_IS_PRESSED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:END_UPDATE_DATA object:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return _textFrame.size.height < 150.f ? 150 : _textFrame.size.height;
    } else if (indexPath.row == 2) {
        return 62.0;
    } else {
        return UITableViewAutomaticDimension;
    }
}

#pragma mark - UITextView

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    if (newFrame.size.height != textView.frame.size.height) {
        textView.frame = newFrame;
        self.textFrame = newFrame;
        NSLog(@"new frame height ");
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [textView becomeFirstResponder];
    }
}

#pragma mark - Actions

- (IBAction)saveOrCancelAction:(UIBarButtonItem *)sender {
    if (sender.tag == 2) {
        [self saveChanges];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Helpers

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    [dateFormater setDateFormat:@"LLLL, dd, yyyy HH:mm"];
    return [dateFormater stringFromDate:date];
}

//@"LLLL, dd, yyyy HH:mm"
//2017-04-27T15:30

- (NSString *)stringDate:(NSString *)stringInput
              withFormat:(NSString *)inputFormat
      dateStringToFromat:(NSString*)outputFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    NSDate *dateFromString = [dateFormatter dateFromString:stringInput];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:outputFormat];
    NSString* newDate = [dateFormatter1 stringFromDate:dateFromString];
    return newDate;
}

- (void)setStartDataToDisplay {
    self.taskDescriptionTextView.placeholder = @"Описание";
    if (_event) {
        _indicator = [[NFActivityIndicatorView alloc] initWithView:self.view];
        [_selectedTags addObjectsFromArray:_event.values];
        self.titleOfTaskTextField.text = _event.title;
        
        if (_event.eventDescription.length > 0) {
            self.taskDescriptionTextView.text = _event.eventDescription;
        }
        self.starttextField.text = [self stringDate:_event.startDate
                                         withFormat:@"yyyy-MM-dd'T'HH:mm:ss"
                                 dateStringToFromat:@"LLLL, dd, yyyy HH:mm"];
        
        self.endTextField.text = [self stringDate:_event.endDate
                                       withFormat:@"yyyy-MM-dd'T'HH:mm:ss"
                               dateStringToFromat:@"LLLL, dd, yyyy HH:mm"];
        self.compliteButton.selected = _event.isDone;
    } else {
        [self.saveButton setTitle:@"Сохранить"];
        self.title = @"Создание задачи";
        self.starttextField.text = [self stringFromDate:[NSDate date]];
        self.endTextField.text = [self stringFromDate:[NSDate  dateWithTimeIntervalSinceNow:900]];
    }
}

- (void)configurePickers {
    _datePickerStart = [[NFDatePicker alloc] initWithTextField:_starttextField];
    _datePickerStart.minimumDate = [NSDate date];
    _datePickerEnd = [[NFDatePicker alloc] initWithTextField:_endTextField];
    _datePickerEnd.minimumDate = [NSDate date];
    
    _valuesArray = [NSMutableArray arrayWithArray:[[NFTaskManager sharedManager] getAllValues]];
    //self.selectValueTextField.text = ((NFValue*)([_valuesArray firstObject])).valueTitle;
    _valuePicker = [[NFPickerView alloc] initWithDataArray:_valuesArray textField:_selectValueTextField   keyTitle:@"valueTitle"];
}

- (void)addDataToDisplay {
    if (_selectedTags.count < 2) {
        if (_selectedTags.count == 1) {
            NFValue *val = [_selectedTags firstObject];
            if ([val.valueId isEqualToString:[_valuePicker.lastSelectedItem valueId]]) {
                NSLog(@"value alredy exist");
            } else {
                [_selectedTags addObject:_valuePicker.lastSelectedItem];
                [self.collectionView.layer addAnimation:[self swipeTransitionToLeftSide:YES ] forKey:nil];
                [self.collectionView reloadData];
            }
        } else {
            [_selectedTags addObject:_valuePicker.lastSelectedItem];
            [self.collectionView.layer addAnimation:[self swipeTransitionToLeftSide:YES ] forKey:nil];
            [self.collectionView reloadData];
        }
    }
}

- (void)compliteTaskAction {
    _compliteButton.selected = !_compliteButton.selected;
    NSLog(@"complite button  pressed");
}

// tag collection view
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedTags.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NFTagCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"NFTagCell" forIndexPath:indexPath];
    NFValue *val = [self.selectedTags objectAtIndex:indexPath.item];
    [cell addDataToCell:val];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedTags removeObjectAtIndex:indexPath.item];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NFValue *val = [self.selectedTags objectAtIndex:indexPath.item];
    return [NFTagCell calculateSizeWithValue:val];
}

- (CATransition *)swipeTransitionToLeftSide:(BOOL)leftSide
{
    CATransition* transition = [CATransition animation];
    transition.startProgress = 0;
    transition.endProgress = 1.0;
    transition.type = kCATransitionPush;
    transition.subtype = leftSide ? kCATransitionFromRight : kCATransitionFromLeft;
    transition.duration = 0.3;
    return transition;
}

- (void)saveChanges {
    [_indicator startAnimating];
    if (!_event) {
        _event = [[NFEvent alloc] init];
    }
    [_event.values removeAllObjects];
    _event.values = [NSMutableArray array];
    _selectedTags.count > 0 ? [_event.values addObjectsFromArray:_selectedTags]: nil;
    _event.title = _titleOfTaskTextField.text;
    _event.eventDescription = _taskDescriptionTextView.text;
    _event.isDone = _compliteButton.selected;
    _event.startDate = [self stringDate:_starttextField.text
                             withFormat:@"LLLL, dd, yyyy HH:mm"
                     dateStringToFromat:@"yyyy-MM-dd'T'HH:mm:ss"];
    _event.endDate = [self stringDate:_endTextField.text
                             withFormat:@"LLLL, dd, yyyy HH:mm"
                     dateStringToFromat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSLog(@"start text %@",_starttextField.text);
    NSLog(@"end text %@", _endTextField.text);
    
    NSLog(@"new event is %@", _event);
    [[NFSyncManager sharedManager] writeEventToFirebase:_event];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NFSyncManager sharedManager]  updateAllData];
    });
}

- (void)endUpdate {
    [_indicator endAnimating];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
