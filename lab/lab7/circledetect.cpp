#include "opencv2/opencv.hpp"

#include <iostream>
#include <stdio.h>

using namespace std;
using namespace cv;

void detectAndDraw( Mat& img );

int main( int argc, const char** argv )
{
    CvCapture* capture = 0;
    Mat frame, frameCopy, image;
    string inputName;

    // go through possible input devices and select the first one that works -> CAM, AVI, image
    if( inputName.empty() || (isdigit(inputName.c_str()[0]) && inputName.c_str()[1] == '\0') )
    {
        capture = cvCaptureFromCAM( inputName.empty() ? 0 : inputName.c_str()[0] - '0' );
        int c = inputName.empty() ? 0 : inputName.c_str()[0] - '0' ;
        if(!capture) cout << "Capture from CAM " <<  c << " didn't work" << endl;
    }
    else if( inputName.size() )
    {
        image = imread( inputName, 1 );
        if( image.empty() )
        {
            capture = cvCaptureFromAVI( inputName.c_str() );
            if(!capture) cout << "Capture from AVI didn't work" << endl;
        }
    }
    else
    {
        image = imread( "lena.jpg", 1 );
        if(image.empty()) cout << "Couldn't read lena.jpg" << endl;
    }

    // open window to display results
    cvNamedWindow( "result", 1 );

    // start capture
    if( capture )
    {
        cout << "In capture ..." << endl;
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

            // use the captured frame and do the magic
            detectAndDraw( frameCopy );

            if( waitKey( 10 ) >= 0 )
                goto _cleanup_;
        }

        waitKey(0);

_cleanup_:
        cvReleaseCapture( &capture );
    }
    else
    {
        cout << "In image read" << endl;
        if( !image.empty() )
        {
            detectAndDraw( image );
            waitKey(0);
        }
        else if( !inputName.empty() )
        {
            /* assume it is a text file containing the
               list of the image filenames to be processed - one per line */
            FILE* f = fopen( inputName.c_str(), "rt" );
            if( f )
            {
                char buf[1000+1];
                while( fgets( buf, 1000, f ) )
                {
                    int len = (int)strlen(buf), c;
                    while( len > 0 && isspace(buf[len-1]) )
                        len--;
                    buf[len] = '\0';
                    cout << "file " << buf << endl;
                    image = imread( buf, 1 );
                    if( !image.empty() )
                    {
                        detectAndDraw( image );
                        c = waitKey(0);
                        if( c == 27 || c == 'q' || c == 'Q' )
                            break;
                    }
                    else
                    {
                        cerr << "Aw snap, couldn't read image " << buf << endl;
                    }
                }
                fclose(f);
            }
        }
    }

    cvDestroyWindow("result");

    return 0;
}

void detectAndDraw( Mat& img )
{
    Mat myImg;
    vector<Vec3f> circles;
    int whiteCnt = 0;
    int whiteCntOldX = 0;
    int whiteCntOldY = 0;
    int xCoord = 0;
    int yCoord = 0;

    /* convert RGB image to HSV image */
    cvtColor(img, myImg, CV_BGR2HSV);

    /* red color detection */
    //inRange(myImg, Scalar(0, 100, 0), Scalar(3, 255, 150), myImg2);
    //inRange(myImg, Scalar(175, 100, 0), Scalar(180, 255, 150), myImg);
    //bitwise_or(myImg, myImg2, myImg);
    
    /* green color detection */
    inRange(myImg, Scalar(30, 100, 0), Scalar(60, 255, 150), myImg);

    /* remove artefacts */
    GaussianBlur(myImg, myImg, Size(9, 9), 2, 2);
    threshold(myImg, myImg, 200, 255, THRESH_BINARY);

    /* calculate radius and center of the circle */
    for (size_t i = 0; i < myImg.size().height; i++) {
        whiteCnt = countNonZero(myImg.row(i));
        if (whiteCntOldY < whiteCnt) {
            whiteCntOldY = whiteCnt;
            yCoord = i;
        }
        whiteCnt = countNonZero(myImg.col(i));
        if (whiteCntOldX < whiteCnt) {
            whiteCntOldX = whiteCnt;
            xCoord = i;
        }
    }
    Point center(xCoord+1, yCoord+1);
    cout << center.x << ", " << center.y << endl;
    int radius = cvRound((whiteCntOldX + whiteCntOldY)/4)+1;

    /* draw the circle center */
    circle(myImg, center, 3, Scalar(0,255,0), -1, 8, 0 );
    /* draw the circle outline */
    circle(img, center, radius, Scalar(0,0,255), 3, 8, 0 );

    /* display the original image with circle */
    cv::imshow( "result", img );
}
