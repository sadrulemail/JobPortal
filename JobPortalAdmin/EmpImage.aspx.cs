using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Drawing;
using System.IO;

public partial class EmpImage : System.Web.UI.Page
{
    int Width = 0;
    int Height = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!String.IsNullOrEmpty(Request.QueryString["EMPID"]))
        {
            string EmpID = "";
            try
            {
                HttpCachePolicy cachePolicy = Response.Cache;
                cachePolicy.SetCacheability(HttpCacheability.ServerAndPrivate);
                cachePolicy.VaryByParams["EMPID"] = true;
                cachePolicy.VaryByParams["W"] = true;
                cachePolicy.VaryByParams["H"] = true;
                cachePolicy.VaryByParams["imgid"] = true;
                cachePolicy.SetOmitVaryStar(true);
                cachePolicy.SetExpires(DateTime.Now + TimeSpan.FromHours(6));
                cachePolicy.SetValidUntilExpires(true);
                //cachePolicy.SetLastModified(new DateTime(2010, 03, 02, 12, 0, 0));



                EmpID = Request.QueryString["EMPID"];
                EmpID = (EmpID.Split(','))[0];
                string TableName = "Emp_Pic";



                try
                {
                    Width = int.Parse(Request.QueryString["W"].ToString());
                }
                catch (Exception) { }
                try
                {
                    Height = int.Parse(Request.QueryString["H"].ToString());
                }
                catch (Exception) { }

                string Query = "SELECT TOP 1 Picture FROM TblUserDB.dbo." + TableName;
                Query += " WHERE EMPID='" + EmpID + "'";
                byte[] logo = fetchScalar(Query, Width, Height);
                Response.ContentType = "Image/JPEG";
                Response.BinaryWrite(logo);
            }
            catch (Exception)
            {
                Response.ContentType = "Image/JPEG";
                try
                {
                    Response.ContentType = "Image/JPEG";
                    string NoImageFile = "Images/NoFace.jpg";
                    if (EmpID.ToUpper().StartsWith("G"))
                    {
                        NoImageFile = "Images/NoGroupFace.png";
                    }
                    //byte[] noimage = File.ReadAllBytes(NoImageFile);
                    //Bitmap b = new Bitmap(NoImageFile);
                    //MemoryStream ms = GetImage(Width, Height, b);

                    //Response.BinaryWrite(ms.ToArray());
                    Response.Redirect(NoImageFile, true);
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
            SqlConnection myConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);

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
}