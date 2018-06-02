package equirectangular;

import java.math.*;
import java.io.File;
import java.io.IOException;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import javax.swing.JFrame;
import javax.swing.ImageIcon;
import javax.swing.JLabel;

import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.core.Scalar;


public class Equirectangular {

	static int PROJECTION_SIZE =  50;
	static int X_AXIS = 0;
	static int Y_AXIS = 0;
	static int Z_AXIS = 0;
	
	
	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub

		ImageIcon image_top, image_left, image_right, image_bottom, image_front, image_back;
		
		
		image_top = new ImageIcon("C:\\Users\\Raul Belze\\Desktop\\equi\\top.jpg");
		image_left = new ImageIcon("C:\\Users\\Raul Belze\\Desktop\\equi\\left.jpg");
		image_right = new ImageIcon("C:\\Users\\Raul Belze\\Desktop\\equi\\right.jpg");
		image_bottom = new ImageIcon("C:\\Users\\Raul Belze\\Desktop\\equi\\bottom.jpg");
		image_front = new ImageIcon("C:\\Users\\Raul Belze\\Desktop\\equi\\front.jpg");
		image_back = new ImageIcon("C:\\Users\\Raul Belze\\Desktop\\equi\\back.jpg");
	
		Mat img = new Mat();
		img.put(PROJECTION_SIZE, PROJECTION_SIZE, CvType.CV_8UC3);

		for (int row = 0; row < PROJECTION_SIZE; row++) {
			for (int col = 0; col < PROJECTION_SIZE; col++) {
				double phi = col / (double)PROJECTION_SIZE * 2 * Math.PI;
				double theta = row / (double)PROJECTION_SIZE * Math.PI - Math.PI;

				double radius = 1;
				double x = Math.sin(theta) * Math.cos(phi) * radius;
				double y = Math.sin(phi) * Math.sin(theta) * radius;
				double z = Math.cos(theta) * radius;

				int maximum_axis;
				boolean positive_axis;

				double u, v;
				
				if (Math.abs(x) > Math.abs(y)) {
					if (Math.abs(x) > Math.abs(z)) {
						maximum_axis = X_AXIS;
						positive_axis = x >= 0.0;
						u = y;
						v = z;
					}
					else {
						maximum_axis = Z_AXIS;
						positive_axis = z >= 0.0;
						u = x;
						v = y;
					}
				}
				else {
					if (Math.abs(y) > Math.abs(z)) {
						maximum_axis = Y_AXIS;
						positive_axis = y >= 0.0;
						u = x;
						v = z;
					}
					else {
						maximum_axis = Z_AXIS;
						positive_axis = z >= 0.0;
						u = x;
						v = y;
					}
				}

				switch (maximum_axis) {
				case X_AXIS:
					if (positive_axis) {
						img.put(row, col) = image_front.at<Vec3b>(int((u + 1) / 2.0 * (image_front.rows - 1)), int((v + 1) / 2.0 * (image_front.cols - 1)));}
					else
						projection.at<Vec3b>(row, col) =
						image_back.at<Vec3b>(
							int((u + 1) / 2.0 * (image_back.rows - 1)),
							int((v + 1) / 2.0 * (image_back.cols - 1)));
					break;
				case Y_AXIS:
					if (positive_axis)
						projection.at<Vec3b>(row, col) =
						image_right.at<Vec3b>(
							int((u + 1) / 2.0 * (image_right.rows - 1)),
							int((v + 1) / 2.0 * (image_right.cols - 1)));
					else
						projection.at<Vec3b>(row, col) =
						image_left.at<Vec3b>(
							int((u + 1) / 2.0 * (image_left.rows - 1)),
							int((v + 1) / 2.0 * (image_left.cols - 1)));
					break;
				case Z_AXIS:
					if (positive_axis)
						projection.at<Vec3b>(row, col) =
						image_top.at<Vec3b>(
							int((u + 1) / 2.0 * (image_top.rows - 1)),
							int((v + 1) / 2.0 * (image_top.cols - 1)));
					else
						projection.at<Vec3b>(row, col) =
						image_bottom.at<Vec3b>(
							int((u + 1) / 2.0 * (image_bottom.rows - 1)),
							int((v + 1) / 2.0 * (image_bottom.cols - 1)));
					break;
				}
			}
		}
		
		frame.pack();
		frame.setVisible(true);
		
	}

}
