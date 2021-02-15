using System;
using System.Web;

namespace JobPortal
{
    /// <summary>
    /// Summary description for CV_Print
    /// </summary>
    public class CV_Print : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string SharedKey = string.Format("{0}", context.Request.QueryString["q"]);

            try
            {

                CV_Report.CV cv = new CV_Report.CV();

                string conString = System.Configuration.ConfigurationManager
                               .ConnectionStrings["JobPortalConnectionString"].ConnectionString;
                byte[] output = cv.getBytes(SharedKey, "", CV_Report.CV.ExportType.PDF, conString);

                context.Response.Clear();
                context.Response.AddHeader("content-disposition", "inline; filename=\"" + "Trust_Bank_CV" + ".pdf\"");
                context.Response.AddHeader("content-length", output.Length.ToString());
                context.Response.ContentType = "application/pdf";
                context.Response.AddHeader("Pragma", "public");
                context.Response.AddHeader("X-Content-Type-Options", "nosniff");
                context.Response.AddHeader("X-Download-Options", "noopen");
                context.Response.BinaryWrite(output);
                context.Response.Flush();
                context.Response.Close();
            }
            catch (Exception) 
            {
                //context.Response.Write(ex.Message);
                throw new HttpException(404, "Not Found"); 
            }            
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