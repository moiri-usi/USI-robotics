#include "opencv2/opencv.hpp"

#include <iostream>
#include <stdio.h>

#define PAPER_WIDTH 250
#define PAPER_HEIGHT 170

using namespace std;
using namespace cv;

void detectAndDraw( Mat& img, Mat& cameraMatrix, Mat& distCoeffs, Mat& tfPerspective, void* captPoints );
void CallBackFunc(int event, int x, int y, int flags, void* userdata);

int main( int argc, const char** argv )
{
    CvCapture* capture = 0;
    Mat frame, frameCopy;
    Mat cameraMatrix, distCoeffs, tfPerspective;
    vector<Point2f> worldCoord;
    vector<Point2f> captPoints;
    worldCoord.push_back(Point2f(0, 0));
    worldCoord.push_back(Point2f(PAPER_WIDTH, 0));
    worldCoord.push_back(Point2f(PAPER_WIDTH, PAPER_HEIGHT));
    worldCoord.push_back(Point2f(0, PAPER_HEIGHT));

    string filename = (argc > 1) ? argv[1] : "out_camera_data.xml";

    FileStorage fs;
    fs.open(filename, FileStorage::READ);

    fs["Camera_Matrix"] >> cameraMatrix;
    fs["Distortion_Coefficients"] >> distCoeffs;

    // capture from cam 0
    capture = cvCaptureFromCAM( 0 );

    // open window to display results
    cvNamedWindow( "result", 1 );
    setMouseCallback("result", CallBackFunc, &captPoints);

    // start capture
    if( capture )
    {
        cout << "In capture ..." << endl;
        bool coordDone = false;
        for(;;)
        {
            IplImage* iplImg = cvQueryFrame( capture );
            frame = iplImg;
            if( frame.empty() )
                break;
            if( iplImg->origin == IPL_ORIGIN_TL )
                frame.copyTo( frameCopy );
            else
                flip( frame, frameCopy, 0 );

            if ( (captPoints.size() == 4) && !coordDone) {
                //undistortPoints(captPoints, captPoints, cameraMatrix, distCoeffs);
                tfPerspective = getPerspectiveTransform(captPoints, worldCoord);
                coordDone = true;
            }

            // use the captured frame and do the magic
            detectAndDraw( frameCopy, cameraMatrix, distCoeffs, tfPerspective, &captPoints );

            if( waitKey( 10 ) >= 0 )
                goto _cleanup_;
        }

        waitKey(0);

_cleanup_:
        cvReleaseCapture( &capture );
    }

    cvDestroyWindow("result");

    return 0;
}

void CallBackFunc(int event, int x, int y, int flags, void* userdata)
{
    vector<Point2f>*data = (vector<Point2f>*)userdata;
    if  (( event == EVENT_LBUTTONDOWN ) && ( data->size() < 4 ))
    {
        data->push_back(Point2f(x, y));
    }
}

void detectAndDraw( Mat& img, Mat& cameraMatrix, Mat& distCoeffs, Mat& tfPerspective, void* captPoints )
{
    Mat imgBlob, imgSrc, imgCorner;
    int whiteCnt = 0;
    int xCnt = 1;
    int yCnt = 1;
    int xCoord = 0;
    int yCoord = 0;
    vector<Point2f> center, newCenter;
    vector<Point2f>*cp = (vector<Point2f>*)captPoints;

    /* undistort image, using xml file from demo */
    undistort(img, imgSrc, cameraMatrix, distCoeffs);

    /* draw clicked points */
    for (size_t i = 0; i < cp->size(); i++) {
        circle(imgSrc, (*cp)[i], 3, Scalar(255,0,0), -1, 8, 0 );
    }

    /* convert RGB image to HSV image */
    cvtColor(imgSrc, imgBlob, CV_BGR2HSV);

    /* red color detection */
    //inRange(imgBlob, Scalar(0, 100, 0), Scalar(3, 255, 150), imgBlob2);
    //inRange(imgBlob, Scalar(175, 100, 0), Scalar(180, 255, 150), imgBlob);
    //bitwise_or(imgBlob, imgBlob2, imgBlob);
    /* green color detection */

    inRange(imgBlob, Scalar(30, 50, 0), Scalar(60, 255, 150), imgBlob);

    /* remove artefacts */
    GaussianBlur(imgBlob, imgBlob, Size(9, 9), 2, 2);
    threshold(imgBlob, imgBlob, 200, 255, THRESH_BINARY);

    /* calculate radius and center of the circle */
    for (size_t i = 0; i < imgBlob.size().height; i++) {
        whiteCnt = countNonZero(imgBlob.row(i));
        if (whiteCnt > 1) {
            yCoord += i;
            yCnt++;
        }
    }
    for (size_t i = 0; i < imgBlob.size().width; i++) {
        whiteCnt = countNonZero(imgBlob.col(i));
        if (whiteCnt > 1) {
            xCoord += i;
            xCnt++;
        }
    }
    center.push_back(Point2f(xCoord/xCnt+1, yCoord/yCnt+1));
    cout << "direct: " << center << endl;
    /* calculate real position */
    if (tfPerspective.rows > 0) {
        perspectiveTransform(center, newCenter, tfPerspective);
        cout << "perspective: " << newCenter << endl; // */
    }

    int radius = cvRound((xCnt + yCnt)/4)+3;

    /* draw the circle center */
    circle(imgSrc, center[0], 3, Scalar(0,255,0), -1, 8, 0 );
    /* draw the circle outline */
    circle(imgSrc, center[0], radius, Scalar(0,0,255), 1, 8, 0 );

    /* display the original image with circle */
    cv::imshow( "result", imgSrc );
}
