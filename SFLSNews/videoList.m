//
//  videoList.m
//  AVTEST
//
//  Created by 皓斌 朱 on 12-2-3.
//  Copyright 2012年 sfls. All rights reserved.
//

#import "videoList.h"
#import "videoContent.h"
#import "video.h"
@implementation videoList
@synthesize listOfVideo,xmlDocument,videoContentList,mySmallClass;
-(void)xmlDocumentDelegateParsingFinished:(XMLDocument *)paramSender{
    listOfVideo=self.xmlDocument.rootElement.children;//这是所有的vido层面的群
    NSLog(@"the small class list has%@",[listOfVideo componentsJoinedByString:@"haha"]);
    if ([listOfVideo count]==0) {
        return;
    }
    int i;
    int j;
    
    XMLelement *tempelement2;
    XMLelement *tempelement;
    videoContentList=[[NSMutableArray alloc]init];
    for (i=0; i<=[listOfVideo count]-1; i++) {
        tempelement=[listOfVideo objectAtIndex:i];
        videoContent *newVideoContent=[[videoContent alloc]init];
        for (j=0; j<=[tempelement.children count]-1; j++) {//这是单个video下的属性群
            tempelement2=[tempelement.children objectAtIndex:j];
            switch (j) {
                case 0:
                    newVideoContent.videoisHot=tempelement2.text;
                    break;
                case 1:
                    newVideoContent.hotImage=tempelement2.text;
                    break;
                case 2:
                    newVideoContent.videoName=tempelement2.text;
                    break;
                case 3:
                    newVideoContent.videoInfo=tempelement2.text;
                    break;
                case 4:
                    newVideoContent.videoPath=tempelement2.text;
                    break;
                    
                default:
                    break;
            }
        }
        [videoContentList addObject:newVideoContent];
        [newVideoContent release];
        NSLog(@"the count of video is %i",videoContentList.count);

//NSLog(@"%@",newVideoContent.videoName);
        
         
        //[newVideoContent release];
    }
    
    NSLog(@"the first video is%@",[videoContentList objectAtIndex:1]);
    [self.tableView reloadData];
    NSLog(@"the 2 video is%@",[videoContentList objectAtIndex:2]);
    [self.tableView reloadData];
    
    
}
-(void)xmlDocumentDelegateParsingFailed:(XMLDocument *)paramSender withError:(NSError *)paramError{
    NSLog(@"Parse xml failed");
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //NSString *title=self.title;
    NSString *title=mySmallClass;
    NSString *xmlPath=[NSString stringWithFormat: @"http://teacher.sfls.cn/sflsapp/video/creatVideo.asp?query=videolist&smallclassname=%@",title];
    NSLog(@"%@",xmlPath);
    XMLDocument *newDocument=[[XMLDocument alloc]initWithDelegate:self];
    self.xmlDocument=newDocument;
    [newDocument release];
    [self.xmlDocument parseRemoteXMLWithURL:xmlPath];
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [videoContentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    videoContent *newVideoContent4TableView=[videoContentList objectAtIndex:[indexPath row]];
    cell.textLabel.text=newVideoContent4TableView.videoName;
    return cell;
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    videoContent *newVideoContent=[self.videoContentList objectAtIndex:[indexPath row]];
    video *newVideo=[[video alloc]init];
    newVideo.newVideoContent=newVideoContent;
    newVideo.title=newVideoContent.videoName;
    [self.navigationController pushViewController:newVideo animated:YES];
    


}

@end
