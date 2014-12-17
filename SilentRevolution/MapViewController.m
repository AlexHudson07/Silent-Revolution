#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "DetailsViewController.h"


@interface MapViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *eventButton;
@property (strong, nonatomic) IBOutlet UIButton *detailsButton;
@property (strong, nonatomic) NSArray *locationsArray;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Silent Revolution";

    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:@"JuraMedium" size:40],
      NSFontAttributeName, nil]];

    NSDictionary *dictionary =  @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                  NSFontAttributeName:[UIFont fontWithName:@"JuraMedium" size:40]
                                  };

    [self.navigationController.navigationBar setTitleTextAttributes: dictionary];


    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:123.f/255 green:174.f/255 blue:45.f/2555 alpha:1];

    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 41.89373984;
    coordinate.longitude = -87.63532979;

    //Design for Buttons
    self.eventButton.layer.cornerRadius = 8;
    self.detailsButton.layer.cornerRadius = 8;

    //Zooms in to Manhattan
    CLLocationDegrees longitude = -73.9597;
    CLLocationDegrees latitude =  40.7903;

    CLLocationCoordinate2D centerCoordinate;

    centerCoordinate.longitude = longitude;
    centerCoordinate.latitude = latitude;

    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = 0.25;
    coordinateSpan.longitudeDelta = 0.25;

    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = coordinateSpan;

    [self.mapView setRegion:region animated:NO];

    [self loadLocations];
}


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
                    busAnnotation.title = object[@"Event"];

                    [self.mapView addAnnotation:busAnnotation];
                }
        }
    }];
}

//This Delegate method allowes you to modify the pins and the views above them
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView * pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"test"];

    //shows the business over the pin
    pin.canShowCallout = YES;

    pin.image = [UIImage imageNamed:@"pin"];

   //  pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];

    
    //pin.animatesDrop = YES;

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
    CLLocationDegrees longitude = -73.9597;
    CLLocationDegrees latitude =  40.7903;

    CLLocationCoordinate2D centerCoordinate;

    centerCoordinate.longitude = longitude;
    centerCoordinate.latitude = latitude;

    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = .25;
    coordinateSpan.longitudeDelta = .25;

    MKCoordinateRegion region;
    region.center = centerCoordinate;
    region.span = coordinateSpan;

    [self.mapView setRegion:region animated:YES];
}

- (IBAction)onEventsButtonPressed:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.thesilentrevolutionnyc.com/#!events/c9b1"];

    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }

}
- (IBAction)onDetailsButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"mapToDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailsViewController *vc = segue.destinationViewController;
    
    vc.infoArray = self.locationsArray;
}




@end
