using System;
using System.Drawing.Drawing2D;
using System.Drawing;
using System.Text;

namespace JobPortal
{
    public class TrustCaptcha
    {
        public static string SESSION_CAPTCHA = "CAPTCHA";

        const int default_width = 270;
        const int default_height = 70;
        const string font_name = "Verdana";

        protected Bitmap result = null;

        public int Width;
        public int Height;

        public TrustCaptcha()
        {
            InitBitmap(default_width, default_height);
            rnd = new Random();

            //System.Threading.Thread.Sleep(1000);
        }

        public TrustCaptcha(int width, int height)
        {
            InitBitmap(width, height);
        }

        protected void InitBitmap(int width, int height)
        {
            result = new Bitmap(width, height);
            Width = width;
            Height = height;
            rnd = new Random();
        }

        public PointF Noise(PointF p, double eps)
        {
            p.X = Convert.ToSingle(rnd.NextDouble() * eps * 2 - eps) + p.X;
            p.Y = Convert.ToSingle(rnd.NextDouble() * eps * 2 - eps) + p.Y;
            return p;
        }

        public PointF Wave(PointF p, double amp, double size)
        {
            p.Y = Convert.ToSingle(Math.Sin(p.X / size) * amp) + p.Y;
            p.X = Convert.ToSingle(Math.Sin(p.X / size) * amp) + p.X;
            return p;
        }

        public GraphicsPath RandomWarp(GraphicsPath path)
        {
            // Add line //
            int PsCount = 10;
            PointF[] curvePs = new PointF[PsCount * 2];
            for (int u = 0; u < PsCount; u++)
            {
                curvePs[u].X = u * (Width / PsCount);
                curvePs[u].Y = Height / 2;
            }
            for (int u = PsCount; u < (PsCount * 2); u++)
            {
                curvePs[u].X = (u - PsCount) * (Width / PsCount);
                curvePs[u].Y = Height / 2 + 2;
            }

            path.AddLines(curvePs);

            //
            double eps = Height * 0.05;

            double amp = rnd.NextDouble() * (double)(Height / 3);
            double size = rnd.NextDouble() * (double)(Width / 4) + Width / 8;

            double offset = (double)(Height / 3);


            PointF[] pn = new PointF[path.PointCount];
            byte[] pt = new byte[path.PointCount];

            GraphicsPath np2 = new GraphicsPath();

            GraphicsPathIterator iter = new GraphicsPathIterator(path);
            for (int i = 0; i < iter.SubpathCount; i++)
            {
                GraphicsPath sp = new GraphicsPath();
                bool closed;
                iter.NextSubpath(sp, out closed);

                Matrix m = new Matrix();
                m.RotateAt(Convert.ToSingle(rnd.NextDouble() * 30 - 15), sp.PathPoints[0]);

                //m.Shear(Convert.ToSingle( rnd.NextDouble()*offset-offset ),Convert.ToSingle( rnd.NextDouble()*offset-offset/2 ));
                //m.Shear(1,1);

                //m.Scale(0.5f + Convert.ToSingle(rnd.NextDouble()), 0.5f + Convert.ToSingle(rnd.NextDouble()), MatrixOrder.Prepend);

                m.Translate(-1 * i, 0);
                sp.Transform(m);
                np2.AddPath(sp, true);
            }


            for (int i = 0; i < np2.PointCount; i++)
            {
                //pn[i] = Noise( path.PathPoints[i] , eps);
                pn[i] = Wave(np2.PathPoints[i], amp, size);
                pt[i] = np2.PathTypes[i];
            }

            GraphicsPath newpath = new GraphicsPath(pn, pt);
            return newpath;
        }

        Random rnd;

        public string DrawCaptcha(int len)
        {
            //string str = "";
            //for (int i = 0; i < len; i++)
            //{
            //    int n = rnd.Next() % 10;
            //    str += n.ToString();
            //}
            StringBuilder builder = new StringBuilder();
            Random random = new Random();
            char ch;
            for (int i = 0; i < len; i++)
            {
                ch = Convert.ToChar(Convert.ToInt32(Math.Floor(10 * random.NextDouble() + 48)));
                builder.Append(ch);
            }

            //return builder.ToString();
            DrawText(builder.ToString());
            return builder.ToString();
        }

        public void DrawText(string aText)
        {
            Graphics g = Graphics.FromImage(result);
            int startsize = Height;
            Font f = new Font("Verdana", startsize, FontStyle.Bold, GraphicsUnit.Pixel);

            do
            {
                f = new Font(font_name, startsize, GraphicsUnit.Pixel);
                startsize--;
            } while ((g.MeasureString(aText, f).Width >= Width) || (g.MeasureString(aText, f).Height >= Height));
            SizeF sf = g.MeasureString(aText, f);
            int width = Convert.ToInt32(sf.Width);
            int height = Convert.ToInt32(sf.Height);

            int x = Convert.ToInt32(Math.Abs((double)width - (double)Width) * rnd.NextDouble());
            int y = Convert.ToInt32(Math.Abs((double)height - (double)Height) * rnd.NextDouble());

            //////// Paths ///
            GraphicsPath path = new GraphicsPath(FillMode.Alternate);

            FontFamily family = new FontFamily(font_name);
            int fontStyle = (int)(FontStyle.Regular);
            float emSize = f.Size;
            Point origin = new Point(x, y);
            StringFormat format = StringFormat.GenericDefault;

            path.AddString(aText, family, fontStyle, emSize, origin, format);

            path = RandomWarp(path);
            /// Path ///

            g.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAliasGridFit;
            Rectangle rect = new Rectangle(0, 0, Width, Height);
            g.FillRectangle(new System.Drawing.Drawing2D.LinearGradientBrush(rect, Color.White, Color.LightGray, 0f), rect);
            //g.DrawString(aText, f, new SolidBrush(Color.Black), x, y);
            g.SmoothingMode = SmoothingMode.AntiAlias;
            g.FillPath(new SolidBrush(Color.Black), path);
            // Dispose //
            g.Dispose();
        }

        public Bitmap Result
        {
            get
            {
                return result;
            }
        }
    }
}