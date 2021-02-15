using System;
using System.Drawing.Imaging;
using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;

namespace JobPortal
{
    public partial class T : System.Web.UI.Page
    {
        const long MAX_PHOTO_SIZE = 400 * 1024;
        static int Times = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            //Label1.Text = Session["USERID"].ToString();
            

            var photo = "C:\\T\\2.jpg";
           
            var photoName = Path.GetFileNameWithoutExtension(photo);

            var fi = new FileInfo(photo);
            //Console.WriteLine("Photo: " + photo);
            //Console.WriteLine(fi.Length);

            if (fi.Length > MAX_PHOTO_SIZE)
            {
                
                using (var image = Image.FromFile(photo))
                {
                    SaveImage((Bitmap)image, 600, 600, 90, "C:\\T\\New.jpg");
                    //using (MemoryStream stream = ResizeImage(image, 400, 400))
                    //{
                    //    Image photo1 = Image.FromStream(stream);
                        
                    //    string fileName = "C:\\T\\" + photoName + "-smaller.jpg";
                    //    File.Create(fileName);
                    //    {
                    //        photo1.Save(fileName);
                    //    }
                    //}
                }
                //Console.WriteLine("File resized.");
            }

            Label1.Text = Times.ToString();
        }



        private static MemoryStream DownscaleImage(Image photo)
        {
            MemoryStream resizedPhotoStream = new MemoryStream();

            long resizedSize = 0;
            var quality = 50;
            //long lastSizeDifference = 0;
            do
            {
                resizedPhotoStream.SetLength(0);

                EncoderParameters eps = new EncoderParameters(1);
                eps.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, (long)quality);
                ImageCodecInfo ici = GetEncoderInfo("image/jpeg");

                photo.Save(resizedPhotoStream, ici, eps);
                resizedSize = resizedPhotoStream.Length;

                //long sizeDifference = resizedSize - MAX_PHOTO_SIZE;
                //Console.WriteLine(resizedSize + "(" + sizeDifference + " " + (lastSizeDifference - sizeDifference) + ")");
                //lastSizeDifference = sizeDifference;
                quality--;
                Times++;

            } while (resizedSize > MAX_PHOTO_SIZE);

            resizedPhotoStream.Seek(0, SeekOrigin.Begin);

            return resizedPhotoStream;
        }

        public void SaveImage(Bitmap image, int maxWidth, int maxHeight, int quality, string filePath)
        {
            // Get the image's original width and height
            int originalWidth = image.Width;
            int originalHeight = image.Height;

            // To preserve the aspect ratio
            float ratioX = (float)maxWidth / (float)originalWidth;
            float ratioY = (float)maxHeight / (float)originalHeight;
            float ratio = Math.Min(ratioX, ratioY);

            // New width and height based on aspect ratio
            int newWidth = (int)(originalWidth * ratio);
            int newHeight = (int)(originalHeight * ratio);

            // Convert other formats (including CMYK) to RGB.
            Bitmap newImage = new Bitmap(newWidth, newHeight, PixelFormat.Format24bppRgb);

            // Draws the image in the specified size with quality mode set to HighQuality
            using (Graphics graphics = Graphics.FromImage(newImage))
            {
                graphics.CompositingQuality = CompositingQuality.HighQuality;
                graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
                graphics.SmoothingMode = SmoothingMode.HighQuality;
                graphics.DrawImage(image, 0, 0, newWidth, newHeight);
            }

            // Get an ImageCodecInfo object that represents the JPEG codec.
            ImageCodecInfo imageCodecInfo = GetEncoderInfo("image/jpeg");

            // Create an Encoder object for the Quality parameter.
            Encoder encoder = Encoder.Quality;

            // Create an EncoderParameters object. 
            EncoderParameters encoderParameters = new EncoderParameters(1);

            // Save the image as a JPEG file with quality level.
            EncoderParameter encoderParameter = new EncoderParameter(encoder, quality);
            encoderParameters.Param[0] = encoderParameter;
            newImage.Save(filePath, imageCodecInfo, encoderParameters);
        }

        /// <summary>
        /// Method to get encoder infor for given image format.
        /// </summary>
        /// <param name="format">Image format</param>
        /// <returns>image codec info.</returns>
        //private ImageCodecInfo GetEncoderInfo(ImageFormat format)
        //{
        //    return ImageCodecInfo.GetImageDecoders().SingleOrDefault(c => c.FormatID == format.Guid);
        //}

        private static ImageCodecInfo GetEncoderInfo(String mimeType)
        {
            int j;
            ImageCodecInfo[] encoders;
            encoders = ImageCodecInfo.GetImageEncoders();
            for (j = 0; j < encoders.Length; ++j)
            {
                if (encoders[j].MimeType == mimeType)
                    return encoders[j];
            }
            return null;
        }

        public MemoryStream ResizeImage(Image sourceImage, int maxWidth, int maxHeight)
        {
            // Determine which ratio is greater, the width or height, and use
            // this to calculate the new width and height. Effectually constrains
            // the proportions of the resized image to the proportions of the original.
            double xRatio = (double)sourceImage.Width / maxWidth;
            double yRatio = (double)sourceImage.Height / maxHeight;
            double ratioToResizeImage = Math.Max(xRatio, yRatio);
            int newWidth = (int)Math.Floor(sourceImage.Width / ratioToResizeImage);
            int newHeight = (int)Math.Floor(sourceImage.Height / ratioToResizeImage);

            // Create new image canvas -- use maxWidth and maxHeight in this function call if you wish
            // to set the exact dimensions of the output image.
            Bitmap newImage = new Bitmap(newWidth, newHeight, PixelFormat.Format32bppRgb);

            // Render the new image, using a graphic object
            using (Graphics newGraphic = Graphics.FromImage(newImage))
            {
                // Set the background color to be transparent (can change this to any color)
                newGraphic.Clear(Color.Transparent);

                // Set the method of scaling to use -- HighQualityBicubic is said to have the best quality
                newGraphic.InterpolationMode = InterpolationMode.HighQualityBicubic;

                // Apply the transformation onto the new graphic
                Rectangle sourceDimensions = new Rectangle(0, 0, sourceImage.Width, sourceImage.Height);
                Rectangle destinationDimensions = new Rectangle(0, 0, newWidth, newHeight);
                newGraphic.DrawImage(sourceImage, destinationDimensions, sourceDimensions, GraphicsUnit.Pixel);
            }

            MemoryStream memoryStream = new MemoryStream();
            newImage.Save(memoryStream, System.Drawing.Imaging.ImageFormat.Jpeg);

            //newImage.Save("C:\\T\\222.jpg");
            // Image has been modified by all the references to it's related graphic above. Return changes.
            return memoryStream;
        }
    }
}