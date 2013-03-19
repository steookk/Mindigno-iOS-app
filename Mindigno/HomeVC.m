//
//  HomeVC.m
//  Mindigno
//
//  Created by Enrico on 07/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import "HomeVC.h"
#import "Mindigno.h"
#import "MicroPost.h"
#import "UIImageView+WebCache.h"
#import "ButtonWithBadge.h"
#import "MicroPostDetailVC.h"
#import "IndignatiVC.h"
#import "CommentsVC.h"
#import "NotificationKeys.h"

#define CELL_ROW_HEIGHT_DEFAULT 200.0f

#define BUTTON_TUTTE_LE_INDIGNAZIONI_INDEX 0
#define BUTTON_SOLO_CHI_SEGUO_INDEX 1

@interface HomeVC ()

@end

@implementation HomeVC

@synthesize buttonPlus;

- (id) initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder: aDecoder];
    if (self) {
        
        arrayButtonTitle = [NSArray arrayWithObjects:@"Tutte le indignazioni", @"Solo chi seguo", nil];
        
        arrayMicroPost = [[Mindigno sharedMindigno] downloadMicroPosts];
        currentArrayMicroPost = arrayMicroPost;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogoutNotification) name:LOGOUT_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginNotification) name:LOGIN_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginSignupDiscarded) name:DISCARD_LOGIN_SIGNUP_NOTIFICATION object:nil];
    
    [scrollButtonBar setDataSourceBar:self];
    [scrollButtonBar setDelegateBar:self];
    [scrollButtonBar startInizialization];
    
    [tableViewMicroPost setDataSource:self];
    [tableViewMicroPost setDelegate:self];
    
    [tableViewMicroPost setEnabledRefresh: YES];
    [tableViewMicroPost setEnabledLazyLoad: YES];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [tableViewMicroPost reloadData];
}

///Start UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (int)[currentArrayMicroPost count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifierDefault = @"Row_MicroPost";
    static NSString *CellIdentifierVignetta = @"Row_MicroPost_Vignetta";
    
    NSString *CellIdentifier = CellIdentifierDefault;
    
    MicroPost *currentMicroPost = [currentArrayMicroPost objectAtIndex:indexPath.row];
    
    if ([currentMicroPost isVignetta]) {
        CellIdentifier = CellIdentifierVignetta;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
    ///
    
    UIImageView *imageViewThumb = (UIImageView*)[cell viewWithTag:1];
    //Default setting
    UIImage *placeHolder = [UIImage imageNamed:@"placeholder"];
    
    UILabel *labelTitle = (UILabel*)[cell viewWithTag:2];
    [labelTitle setText: [currentMicroPost title]];
    
    UILabel *labelDescription = (UILabel*)[cell viewWithTag:3];
    [labelDescription setText: [currentMicroPost description]];
    
    UILabel *labelSourceText = (UILabel*)[cell viewWithTag:4];
    [labelSourceText setHidden: NO];
    
    UIView *contentViewCreator = (UIView*)[cell viewWithTag:10];
    [contentViewCreator setHidden: YES];
    
    NSString *imgUrl = [currentMicroPost imageUrl];
    if (imgUrl != nil) {
        [imageViewThumb setImageWithURL:[NSURL URLWithString: imgUrl] placeholderImage:placeHolder];
    }
    
    if ([currentMicroPost isLink]) {
        [labelSourceText setText: [currentMicroPost sourceText]];
        
    } else {
        
        if ([currentMicroPost isUserCreator]) {
            
            [labelSourceText setHidden: YES];
            [contentViewCreator setHidden: NO];
            
            UILabel *labelPreposition = (UILabel*)[cell viewWithTag:11];
            UIImageView *imageViewAvatarUser = (UIImageView*)[cell viewWithTag:12];
            UILabel *labelUsername = (UILabel*)[cell viewWithTag:13];
            
            User *user = [currentMicroPost userCreator];
            
            [labelPreposition setText:[currentMicroPost preposition]];
            [imageViewAvatarUser setImageWithURL:[NSURL URLWithString: [user avatarUrl]] placeholderImage:placeHolder];
            [labelUsername setText:[user name]];
            
        } else {
            [labelSourceText setText: [currentMicroPost defaultText]];
        }
    }
    
    UILabel *labelCreatedAtText = (UILabel*)[cell viewWithTag:5];
    [labelCreatedAtText setText: [currentMicroPost createdAtText]];
    
    ButtonWithBadge *buttonIndignati = (ButtonWithBadge*)[cell viewWithTag:6];
    
    //Debug
    //[buttonIndignati setTitle:[currentMicroPost numberOfIndignati] forState:UIControlStateNormal];
    //NSLog(@"indignati number: \"%@\"", [currentMicroPost numberOfIndignati]);
    //
    
    //Quando non ci sono indignati allora non visualizzo il badge e rendo non cliccabile il pulsante
    BOOL zeroIndignati = [[currentMicroPost numberOfIndignati] intValue] == 0;
    [buttonIndignati setBadgeString:[currentMicroPost numberOfIndignati]];
    if (zeroIndignati) {
        [buttonIndignati hideBadge: YES];
        [buttonIndignati setUserInteractionEnabled: NO];
        [buttonIndignati setAlpha: 0.4];
    } else {
        [buttonIndignati hideBadge: NO];
        [buttonIndignati setUserInteractionEnabled: YES];
        [buttonIndignati setAlpha: 1.0];
    }
    
    ButtonWithBadge *buttonComments = (ButtonWithBadge*)[cell viewWithTag:7];
    
    //Debug
    //[buttonComments setTitle:[currentMicroPost numberOfComments] forState:UIControlStateNormal];
    //NSLog(@"commenti number: \"%@\"", [currentMicroPost numberOfComments]);
    //
    
    //Quando non ci sono commenti allora non visualizzo il badge e rendo non cliccabile il pulsante
    BOOL zeroCommenti = [[currentMicroPost numberOfComments] intValue] == 0;
    if (zeroCommenti) {
        [buttonComments hideBadge: YES];
        [buttonComments setUserInteractionEnabled: NO];
        [buttonComments setAlpha: 0.4];
    } else {
        [buttonComments setBadgeString:[currentMicroPost numberOfComments]];
        [buttonComments hideBadge: NO];
        [buttonComments setUserInteractionEnabled: YES];
        [buttonComments setAlpha: 1.0];
    }
    
    UIButton *buttonShare = (UIButton*)[cell viewWithTag:8];
    [buttonShare addTarget:self action:@selector(buttonShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonMindigno = (UIButton*)[cell viewWithTag:9];
    [buttonMindigno addTarget:self action:@selector(buttonMindignoClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonMindigno setSelected: [currentMicroPost isIndignato]];
    
    if ([currentMicroPost isVignetta]) {
        UIImageView *imageViewVignetta = (UIImageView*)[cell viewWithTag:15];
        
        NSString *vignettaUrl = [[currentMicroPost vignetta] vignettaUrl];
        [imageViewVignetta setImageWithURL:[NSURL URLWithString:vignettaUrl] placeholderImage:placeHolder];
    }
    
    return cell;
}
///Stop UITableViewDataSource

- (void) buttonShareClicked:(id)sender {
    
    //The indexPath must be taken from button and not from the tableView
    NSIndexPath *currentIndexPath = [tableViewMicroPost indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    MicroPost *currentMicroPost = [currentArrayMicroPost objectAtIndex: currentIndexPath.row];
    
    NSString *textToShare = [NSString stringWithFormat:@"%@ #mindigno", [currentMicroPost title]];
    [[Mindigno sharedMindigno] shareInfoOnViewController:self withText:textToShare imageName:nil url:[currentMicroPost micropostUrl]];
}

- (void) buttonMindignoClicked:(id)sender {
    //NSLog(@"buttonMindignoClicked");
    
    if (![[Mindigno sharedMindigno] isLoggedUser]) {
        UINavigationController *navController = (UINavigationController *) [[Mindigno sharedMindigno] apriModaleLogin];
        [self presentViewController:navController animated:YES completion:nil];
    
    } else {
    
        //The indexPath must be taken from button and not from the tableView
        NSIndexPath *currentIndexPath = [tableViewMicroPost indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        MicroPost *currentMicroPost = [currentArrayMicroPost objectAtIndex: currentIndexPath.row];
        
        UIButton *buttonMindigno = (UIButton*)sender;
        
        BOOL isIndignato = [buttonMindigno isSelected];
        if (!isIndignato) {
            BOOL ok = [[Mindigno sharedMindigno] indignatiSulMicroPostConID: [currentMicroPost micropostID]];
            
            if (ok) {
                [currentMicroPost addOneToNumberIndignati];
                [currentMicroPost setIsIndignato: !isIndignato];
            }
            
        } else {
            BOOL ok = [[Mindigno sharedMindigno] rimuoviIndignazioneSulMicroPostConID: [currentMicroPost micropostID]];
            
            if (ok) {
                [currentMicroPost removeOneToNumberIndignati];
                [currentMicroPost setIsIndignato: !isIndignato];
            }
        }
        
        [tableViewMicroPost reloadData];
    }
}

///Start UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    double defaultHeight = CELL_ROW_HEIGHT_DEFAULT;
    MicroPost *currentMicroPost = [currentArrayMicroPost objectAtIndex:indexPath.row];
    
    if ([currentMicroPost isVignetta]) {
        return defaultHeight*2;
        
    } else {
        return defaultHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"didSelectRowAtIndexPath clicked row number: %d", indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
///Stop UITableViewDelegate

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"homeToMicropostDetail"]) {
        
        NSIndexPath* currentIndexPath = [tableViewMicroPost indexPathForSelectedRow];
        NSLog(@"prepareForSegue clicked row number: %d", currentIndexPath.row);
        
        MicroPostDetailVC *microPostDetailVC = (MicroPostDetailVC*)[segue destinationViewController];
        [microPostDetailVC setCurrentMicroPost: [currentArrayMicroPost objectAtIndex:currentIndexPath.row]];
        
    } else if ([[segue identifier] isEqualToString:@"homeToIndignati"]) {
        
        //The indexPath must be taken from button and not from the tableView
        NSIndexPath *currentIndexPath = [tableViewMicroPost indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        //NSLog(@"homeToIndignati");
        
        NSLog(@"prepareForSegue clicked row number: %d", currentIndexPath.row);
        
        IndignatiVC *indignatiVC = (IndignatiVC*)[segue destinationViewController];
        [indignatiVC setCurrentMicroPost: [currentArrayMicroPost objectAtIndex: currentIndexPath.row]];
        
    } else if ([[segue identifier] isEqualToString:@"homeToComments"]) {
        
        //NSLog(@"homeToComments");
        
        //The indexPath must be taken from button and not from the tableView
        NSIndexPath *currentIndexPath = [tableViewMicroPost indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
        
        NSLog(@"prepareForSegue clicked row number: %d", currentIndexPath.row);
        
        CommentsVC *commentsDettailVC = (CommentsVC*)[segue destinationViewController];
        
        MicroPost *currentMicroPost = [currentArrayMicroPost objectAtIndex: currentIndexPath.row];
        [commentsDettailVC setCurrentMicroPost: currentMicroPost];
    }
}

//Start PullRefreshTableViewDelegate
- (void) tableViewHasRefreshed:(UITableView*)tableView {
    int indexButton = [scrollButtonBar indexOfCurrentSelectedButton];
    
    if (indexButton == BUTTON_TUTTE_LE_INDIGNAZIONI_INDEX) {
        //Tutte le indignazioni
        
        arrayMicroPost = [[Mindigno sharedMindigno] downloadMicroPosts];
        [tableViewMicroPost setEnabledLazyLoad:YES];
        [tableViewMicroPost reloadData];
    
    } else if (indexButton == BUTTON_SOLO_CHI_SEGUO_INDEX) {
        //Solo chi seguo
        
        //Se l'utente non è loggato
        if (![[Mindigno sharedMindigno] isLoggedUser]) {
            UINavigationController *navController = (UINavigationController *) [[Mindigno sharedMindigno] apriModaleLogin];
            [self presentViewController:navController animated:YES completion:nil];

        } else {
            arrayMicroPostOfFollowing = [[Mindigno sharedMindigno] downloadMicroPostsOfFollowing];
            [tableViewMicroPost setEnabledLazyLoad:YES];
            [tableViewMicroPost reloadData];
        }
    }
}

- (void) loadNewDataInBackgroundForTableView:(UITableView*)tableView {
    
    int indexButton = [scrollButtonBar indexOfCurrentSelectedButton];
    
    if (indexButton == BUTTON_TUTTE_LE_INDIGNAZIONI_INDEX) {
        
        //Ritorna nil se non ci sono più vecchi micropost
        NSArray *microposts = [[Mindigno sharedMindigno] downloadMoreOldMicroPosts];
        
        if (microposts == nil) {
            [tableViewMicroPost setEnabledLazyLoad:NO];
        }
    
    } else if (indexButton == BUTTON_SOLO_CHI_SEGUO_INDEX) {
    
        //Ritorna nil se non ci sono più vecchi micropost
        NSArray *micropostsFollowing = [[Mindigno sharedMindigno] downloadMoreOldMicroPostsOfFollowing];
        
        if (micropostsFollowing == nil) {
            [tableViewMicroPost setEnabledLazyLoad:NO];
        }
    }
    
    [tableViewMicroPost reloadData];
}
//Stop PullRefreshTableViewDelegate

//Start ScrollButtonBarDataSource
- (NSInteger) numberOfButtonsInScrollButtonBar:(ScrollButtonBar*)scrollButtonBar {
    return [arrayButtonTitle count];
}

- (void) setButtonProperties:(UIButton*)button withIndex:(NSInteger)index {
    
    NSString *title = [arrayButtonTitle objectAtIndex:index];
    [button setTitle:title forState:UIControlStateNormal];
    [[button titleLabel] setFont: [UIFont fontWithName:@"Arial" size:14]];
}

- (NSString*) backgroundImageUrlOfSelectedButton {
    
    return @"barra-gialla.png";
}
//Stop ScrollButtonBarDataSource

//Start ScrollButtonBarDelegate
- (void) buttonClicked:(UIButton*)button withIndex:(NSInteger)index {
    
    NSLog(@"Button clicked with title: %@", [[button titleLabel] text]);
    //NSLog(@"Button selected index: %d", [scrollButtonBar indexOfCurrentSelectedButton]);
    
    if (index == BUTTON_TUTTE_LE_INDIGNAZIONI_INDEX) {
        //Tutte le indignazioni
        currentArrayMicroPost = arrayMicroPost;
        
    } else if (index == BUTTON_SOLO_CHI_SEGUO_INDEX) {
        //Solo chi seguo
        
        //Se l'utente non è loggato
        if (![[Mindigno sharedMindigno] isLoggedUser]) {
            UINavigationController *navController = (UINavigationController *) [[Mindigno sharedMindigno] apriModaleLogin];
            [self presentViewController:navController animated:YES completion:nil];
            
        } else {
            
            arrayMicroPostOfFollowing = [[Mindigno sharedMindigno] microPostsOfFollowing];
            
            if ([arrayMicroPostOfFollowing count] == 0) {
                arrayMicroPostOfFollowing = [[Mindigno sharedMindigno] downloadMicroPostsOfFollowing];
            }
            
            currentArrayMicroPost = arrayMicroPostOfFollowing;
            
            [tableViewMicroPost setEnabledLazyLoad:YES];
        }
    }
    
    [tableViewMicroPost reloadData];
}
//Stop ScrollButtonBarDelegate

- (void) handleLogoutNotification {
    int indexButton = [scrollButtonBar indexOfCurrentSelectedButton];
    
    //Se quando faccio logout mi trovavo in Solo chi seguo, devo spostare il pulsante su Tutte le indignazioni
    if (indexButton == BUTTON_TUTTE_LE_INDIGNAZIONI_INDEX) {
        //Tutte le indignazioni
        arrayMicroPost = [[Mindigno sharedMindigno] downloadMicroPosts];
        [tableViewMicroPost reloadData];
        
    } else if (indexButton == BUTTON_SOLO_CHI_SEGUO_INDEX) {
        //Solo chi seguo
        [scrollButtonBar selectButtonWithIndex: BUTTON_TUTTE_LE_INDIGNAZIONI_INDEX];
    }
    
}

- (void) handleLoginNotification {
    int indexButton = [scrollButtonBar indexOfCurrentSelectedButton];
    
    //Se quando faccio login il pulsante è su Solo chi seguo, devo fare la giusta chiamata
    [self buttonClicked: [scrollButtonBar currentSelectedButton] withIndex:indexButton];
}

- (void) handleLoginSignupDiscarded {
    [scrollButtonBar selectButtonWithIndex: BUTTON_TUTTE_LE_INDIGNAZIONI_INDEX];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
