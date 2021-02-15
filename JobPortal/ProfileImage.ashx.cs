using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Drawing;
using System.IO;


namespace JobPortal
{
    /// <summary>
    /// Summary description for ProfileImage
    /// </summary>
    public class ProfileImage : IHttpHandler
    {
        int Width = 0;
        int Height = 0;

        public void ProcessRequest(HttpContext context)
        {
            if (!String.IsNullOrEmpty(context.Request.QueryString["id"]))
            {
                string ID = "";
                try
                {
                    HttpCachePolicy cachePolicy = context.Response.Cache;
                    cachePolicy.SetCacheability(HttpCacheability.ServerAndPrivate);
                    cachePolicy.VaryByParams["id"] = true;
                    cachePolicy.VaryByParams["W"] = true;
                    cachePolicy.VaryByParams["H"] = true;
                    cachePolicy.VaryByParams["keycode"] = true;
                    cachePolicy.SetOmitVaryStar(true);
                    cachePolicy.SetExpires(DateTime.Now + TimeSpan.FromHours(1));
                    cachePolicy.SetValidUntilExpires(true);

                    //System.Threading.Thread.Sleep(5000);


                    ID = context.Request.QueryString["id"];

                    int i = 0;
                    while (true)
                    {
                        string _ID = "";
                        _ID = (ID.Split(','))[i++];
                        if (_ID.Length > 0)
                        {
                            ID = _ID;
                            break;
                        }
                    }

                    string TableName = "ProfilePic";



                    try
                    {
                        Width = int.Parse(context.Request.QueryString["W"].ToString());
                    }
                    catch (Exception) { }
                    try
                    {
                        Height = int.Parse(context.Request.QueryString["H"].ToString());
                    }
                    catch (Exception) { }

                    string Query = "SELECT TOP 1 Picture FROM WebDB.dbo." + TableName;
                    Query += " WHERE ID='" + ID + "'";
                    byte[] logo = fetchScalar(Query, Width, Height);
                    context.Response.ContentType = "Image/JPEG";
                    context.Response.BinaryWrite(logo);
                }
                catch (Exception)
                {
                    context.Response.ContentType = "Image/JPEG";
                    try
                    {
                        context.Response.ContentType = "Image/JPEG";
                        string NoImageFile = "Images/NoFace.jpg";
                        if (ID.ToUpper().StartsWith("G"))
                        {
                            NoImageFile = "Images/NoGroupFace.jpg";
                        }
                        //byte[] noimage = File.ReadAllBytes(NoImageFile);
                        //Bitmap b = new Bitmap(NoImageFile);
                        //MemoryStream ms = GetImage(Width, Height, b);

                        //Response.BinaryWrite(ms.ToArray());
                        context.Response.Redirect(NoImageFile, true);
                    }
                    catch (Exception) { }
                }
            }
        }

        private byte[] fetchScalar(string query, int Width, int Height)
        {
            try
            {
                // connect to data source
                SqlConnection.ClearAllPools();
                SqlConnection myConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["WebDBConnectionString"].ConnectionString);

                // initialize command object with query
                SqlCommand myCmd = new SqlCommand(query, myConn);

                // open connection
                if (myConn.State == ConnectionState.Closed)
                    myConn.Open();

                // get scalar
                object scalar = myCmd.ExecuteScalar();

                // close connection
                myConn.Close();

                Bitmap b = (Bitmap)Bitmap.FromStream(new MemoryStream((byte[])scalar));

                MemoryStream ms = GetImage(Width, Height, b);
                return ms.ToArray();
            }
            catch (Exception)
            {
                return null;
            }
        }

        private static MemoryStream GetImage(int Width, int Height, Bitmap b)
        {
            Bitmap output;
            if (Width == 0)
                output = b;
            else if (Height == 0)
            {
                double newHeight = ((double)Width * (double)b.Height / (double)b.Width);
                output = new Bitmap(b, Width, (int)newHeight);
            }
            else
                output = new Bitmap(b, new Size(Width, Height));

            MemoryStream ms = new MemoryStream();
            output.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);
            return ms;
        }

        
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}