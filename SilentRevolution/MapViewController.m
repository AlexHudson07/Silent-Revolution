#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "DetailsViewController.h"


@interface MapViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *eventButton;
@property (strong, nonatomic) IBOutlet UIButton *detailsButton;
@property (strong, nonatomic) IBOutlet UIButton *voteButton;
@property (strong, nonatomic) NSArray *locationsArray;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Silent Revolution";
    
    NSDictionary *dictionary =  @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                  NSFontAttributeName:[UIFont fontWithName:@"JuraMedium" size:35],
                                  };

    [self.navigationController.navigationBar setTitleTextAttributes: dictionary];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:123.f/255 green:174.f/255 blue:45.f/2555 alpha:1];

    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 41.89373984;
    coordinate.longitude = -87.63532979;

    //Design for Buttons
    self.eventButton.layer.cornerRadius = 8;
    self.detailsButton.layer.cornerRadius = 8;
    self.voteButton.layer.cornerRadius = 8;

    //Zooms in to Manhattan
    CLLocationDegrees longitude = -80.2241;
    CLLocationDegrees latitude =  25.7977;

    CLLocationCoordinate2D centerCoordinate;

    centerCoordinate.longitude = longitude;
    centerCoordinate.latitude = latitude;

    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = 0.30;
    coordinateSpan.longitudeDelta = 0.30;

    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = coordinateSpan;

    [self.mapView setRegion:region animated:NO];

    [self loadLocations];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - Parse Methods
-(void)loadLocations{

    PFQuery * query = [PFQuery queryWithClassName: @"Locations"];

    [query orderByAscending:@"Order"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        self.locationsArray = objects.mutableCopy;

        for (PFObject *object in self.locationsArray) {
            PFGeoPoint *point = object[@"Location"];

                if (point) {

                    MKPointAnnotation *busAnnotation = [[MKPointAnnotation alloc] init];

                    CLLocationCoordinate2D coordinate;

                    coordinate.latitude = point.latitude;
                    coordinate.longitude = point.longitude;

                    busAnnotation.coordinate = coordinate;

                    NSString *string = object[@"Event"];

                    NSString *string1 = @" ";

                    NSString *string2 = object[@"Time"];

                    string = [[string stringByAppendingString:string1] stringByAppendingString:string2];

                    busAnnotation.title = string;

                    [self.mapView addAnnotation:busAnnotation];
                }
        }
    }];
}

#pragma mark - MKMap Methods
//This Delegate method allowes you to modify the pins and the views above them
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView * pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"test"];

    //shows the business over the pin
    pin.canShowCallout = YES;

    pin.image = [UIImage imageNamed:@"pin2"];

     pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pin;
}

// When the anotation is tapped
//map zooms in tapped on pin
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"Pin was tapped: %@", view.annotation.title);

    CLLocationCoordinate2D centerCoordinate = view.annotation.coordinate;

    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = 0.01;
    coordinateSpan.longitudeDelta = 0.01;

    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = coordinateSpan;

    [self.mapView setRegion:region animated:YES];
}

//map zooms out when map user untaps pin
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{

    //Zooms in to Manhattan
    CLLocationDegrees longitude = -80.2241;
    CLLocationDegrees latitude =  25.7977;

    CLLocationCoordinate2D centerCoordinate;

    centerCoordinate.longitude = longitude;
    centerCoordinate.latitude = latitude;

    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = .30;
    coordinateSpan.longitudeDelta = .30;

    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = coordinateSpan;

    [self.mapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"You are about to get directions to the Revolution" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"User pressed ok");

        id <MKAnnotation> annotation = view.annotation;
        CLLocationCoordinate2D coordinate = [annotation coordinate];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        MKMapItem *mapitem = [[MKMapItem alloc] initWithPlacemark:placemark];
        mapitem.name = annotation.title;
        [mapitem openInMapsWithLaunchOptions:nil];

        [ac dismissViewControllerAnimated:YES completion:nil];
    }];


    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [ac dismissViewControllerAnimated:YES completion:nil];
    }];

        [ac addAction:cancel];
        [ac addAction:ok];

    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)onEventsButtonPressed:(id)sender
{

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"You leaving to go to The Silent Revolution website " message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"User pressed ok");

    NSURL *url = [NSURL URLWithString:@"http://www.thesilentrevolutionnyc.com/#!events/c9b1"];

    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }

        [ac dismissViewControllerAnimated:YES completion:nil];
    }];

    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [ac dismissViewControllerAnimated:YES completion:nil];
    }];

    [ac addAction:cancel];
    [ac addAction:ok];

    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)onDetailsButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"mapToDetails" sender:self];
}

- (IBAction)onVoteButtonPressed:(id)sender {

    [self performSegueWithIdentifier:@"mapToVote" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"mapToDetails"]){

        DetailsViewController *vc = segue.destinationViewController;
        vc.infoArray = self.locationsArray;
    }
}
-(IBAction)unwindToMapVC:(UIStoryboardSegue *)segue{}



@end
