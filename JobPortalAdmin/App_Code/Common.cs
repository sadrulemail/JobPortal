using System;
using System.Configuration;
using System.Web;
using System.IO;
using System.IO.Compression;
using System.Text.RegularExpressions;
using System.Data.SqlClient;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for Common
/// </summary>
public static class Common
{
    public static string ToRelativeDate(object input)
    {
        try
        {
            return ToRelativeDate((DateTime)(input));
        }
        catch (Exception) { return string.Empty; }
    }

    public static string ToRelativeDate(DateTime input)
    {
        string suffix = "ago";
        TimeSpan difference = (DateTime.Now - input);
        double millisecondsDifference = difference.TotalMilliseconds;

        if ((millisecondsDifference < 0))
        {
            suffix = "from now";
            millisecondsDifference = Math.Abs(millisecondsDifference);
        }

        double seconds = millisecondsDifference / 1000;
        double minutes = seconds / 60;
        double hours = minutes / 60;
        double days = hours / 24;
        double years = days / 365;

        string relativeDate = string.Empty;

        if ((seconds < 45))
        {
            relativeDate = "less than a minute";
        }
        else if ((seconds < 90))
        {
            relativeDate = "about a minute";
        }
        else if ((minutes < 45))
        {
            relativeDate = string.Format("{0} minutes", Math.Round(minutes));
        }
        else if ((minutes < 90))
        {
            relativeDate = "about an hour";
        }
        else if ((hours < 24))
        {
            relativeDate = string.Format("about {0} hours", Math.Round(hours));
        }
        else if ((hours < 48))
        {
            relativeDate = "a day";
        }
        else if ((days < 30))
        {
            relativeDate = string.Format("{0} days", Math.Floor(days));
        }
        else if ((days < 60))
        {
            relativeDate = "about a month";
        }
        else if ((days < 365))
        {
            relativeDate = string.Format("{0} months", Math.Floor(days / 30));
        }
        else if ((years < 2))
        {
            relativeDate = "about a year";
        }
        else
        {
            relativeDate = string.Format("{0} years", Math.Floor(years));
        }
        return relativeDate + " " + suffix;
    }

    public static string ToRecentDateTime(object input)
    {
        try
        {
            return ToRecentDateTime((DateTime)(input));
        }
        catch (Exception) { return string.Empty; }
    }

    public static string ToRecentDateTime(DateTime input)
    {
        string RetVal = "";

        TimeSpan difference = (DateTime.Now.Date - input.Date);
        double millisecondsDifference = difference.TotalMilliseconds;
        double seconds = millisecondsDifference / 1000;
        double minutes = seconds / 60;
        double hours = minutes / 60;
        double days = hours / 24;
        double years = days / 365;

        if (input.Date == DateTime.Now.Date)
            RetVal = String.Format("{0:h:mm tt}", input);
        else if (days < 2)
            RetVal = "Yesterday, " + String.Format("{0:h:mm tt}", input);
        else if (days < 7)
            RetVal = String.Format("{0:dddd, h:mm tt}", input);
        else if (DateTime.Now.Year == input.Date.Year)
            RetVal = String.Format("{0:d MMM, h:mm tt}", input);
        else
            RetVal = String.Format("{0:d MMM yyyy, h:mm tt}", input);

        return RetVal.Replace(".", "");
    }

    public static string ToRecentDate(object input)
    {
        try
        {
            return ToRecentDate((DateTime)(input));
        }
        catch (Exception) { return string.Empty; }
    }

    public static string ToRecentDate(DateTime input)
    {
        TimeSpan difference = (DateTime.Now.Date - input.Date);
        double millisecondsDifference = difference.TotalMilliseconds;
        double seconds = millisecondsDifference / 1000;
        double minutes = seconds / 60;
        double hours = minutes / 60;
        double days = hours / 24;
        double years = days / 365;

        string RetVal = "";
        if (input.Date == DateTime.Now.Date)
            RetVal = "Today";
        else if (days < 2)
            RetVal = "Yesterday";
        else if (days < 7)
            RetVal = String.Format("{0:dddd}", input);
        else if (DateTime.Now.Year == input.Date.Year)
            RetVal = String.Format("{0:d MMMM}", input);
        else
            RetVal = String.Format("{0:d MMMM yyyy}", input);

        return RetVal.Replace(".", "");
    }

    public static byte[] Compress(byte[] buffer)
    {
        MemoryStream ms = new MemoryStream();
        GZipStream zip = new GZipStream(ms, CompressionMode.Compress, true);
        zip.Write(buffer, 0, buffer.Length);
        zip.Close();
        ms.Position = 0;

        MemoryStream outStream = new MemoryStream();

        byte[] compressed = new byte[ms.Length];
        ms.Read(compressed, 0, compressed.Length);

        byte[] gzBuffer = new byte[compressed.Length + 4];
        Buffer.BlockCopy(compressed, 0, gzBuffer, 4, compressed.Length);
        Buffer.BlockCopy(BitConverter.GetBytes(buffer.Length), 0, gzBuffer, 0, 4);
        return gzBuffer;
    }

    public static byte[] Decompress(byte[] gzBuffer)
    {
        MemoryStream ms = new MemoryStream();
        int msgLength = BitConverter.ToInt32(gzBuffer, 0);
        ms.Write(gzBuffer, 4, gzBuffer.Length - 4);

        byte[] buffer = new byte[msgLength];

        ms.Position = 0;
        GZipStream zip = new GZipStream(ms, CompressionMode.Decompress);
        zip.Read(buffer, 0, buffer.Length);

        return buffer;
    }

    public static string isRole_ALL_TBL_EMP_YN(HttpContext context)
    {
        return isRoleYN("ALL_TBL_EMP", context);
    }

    public static string isRole_ALL_BRANCH_YN(HttpContext context)
    {
        return isRoleYN("ALL_BRANCH", context);
    }

    public static string isRoleYN(string RoleName, HttpContext context)
    {
        try
        {
            string[] Roles = context.Session["ROLES"].ToString().Split(',');
            foreach (string Role in Roles)
                if (Role.Trim().ToLower() == RoleName.Trim().ToLower())
                    return "Y";
            return "N";
        }
        catch (Exception)
        {
            return "N";
        }
    }

    public static string FileSize(object val)
    {
        float SizeVal = (float.Parse(val.ToString()));
        string size = "Unknown Size";
        if (SizeVal > 0)
        {
            if (SizeVal >= 1073741824)
                size = String.Format("{0:##.###}", (SizeVal / 1073741824)) + " GB";
            else if (SizeVal >= 1048576)
                size = String.Format("{0:##.##}", (SizeVal / 1048576)) + " MB";
            else if (SizeVal >= 1024)
                size = String.Format("{0:##}", (SizeVal / 1024)) + " KB";
            else
                size = String.Format("{0:##}", (SizeVal)) + " Bytes";
        }
        return size;
    }

    public static string getNumbers(string FileName)
    {
        string RetVal = FileName;

        Regex rgx = new Regex("[^0-9]");   //take only numbers 
        RetVal = rgx.Replace(RetVal, "");
        return RetVal;
    }

    public static string getEmpID(string FileName)
    {
        FileName = Path.GetFileNameWithoutExtension(FileName);
        string RetVal = FileName;

        Regex rgx = new Regex("[^0-9]");   //take only numbers 
        RetVal = rgx.Replace(RetVal, "");

        RetVal = (int.Parse(RetVal)).ToString();

        return RetVal;
    }

    public static string getExtensionImage(object Filename)
    {
        string Pre = "Images/ext/";
        string RetVal = "";
        string Extension = Path.GetExtension(Filename.ToString()).Replace(".", "");
        //return Extension;

        switch (Extension.ToUpper().Trim())
        {
            case "DOC":
            case "DOCX":
                RetVal = Pre + "doc.gif";
                break;
            case "XLS":
            case "XLSX":
            case "XLSM":
            case "XLT":
            case "XLTX":
                RetVal = Pre + "xls.gif";
                break;
            case "PPT":
            case "PPTX":
            case "PPTM":
            case "POTX":
            case "POTM":
            case "PPS":
            case "PPSX":
                RetVal = Pre + "ppt.gif";
                break;
            case "ZIP":
            case "RAR":
            case "TAR":
            case "7ZIP":
                RetVal = Pre + "zip.gif";
                break;
            case "TXT":
            case "INI":
            case "BAT":
                RetVal = Pre + "txt.gif";
                break;
            case "PDF":
                RetVal = Pre + "pdf.gif";
                //RetVal[1] = "50px";
                break;
            //RetVal[0] = "Images/loading.gif";
            //RetVal[1] = "80px";
            //RetVal[2] = "attachthumb";
            //RetVal[3] = string.Format("AttachShow.ashx?AID={0}&KEY={1}&W=80", AID, FileKey);
            //break;
            case "JPG":
            case "JPEG":
            case "GIF":
            case "PNG":
            case "BMP":
            case "TIF":
                RetVal = Pre + "jpg.gif";
                //RetVal[1] = "80px";
                //RetVal[2] = "attachthumb";
                //RetVal[3] = string.Format("AttachShow.ashx?AID={0}&KEY={1}&W=80", AID, FileKey);
                //RetVal[4] = "lightbox";
                break;
            default:
                RetVal = Pre + "attach.gif";
                break;
        }
        return RetVal;
    }

    public static bool isEmailAddress(string emailAddress)
    {
        //string patternLenient = @"\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*";
        //Regex reLenient = new Regex(patternLenient);

        string patternStrict = @"^(([^<>()[\]\\.,;:\s@\""]+"
              + @"(\.[^<>()[\]\\.,;:\s@\""]+)*)|(\"".+\""))@"
              + @"((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
              + @"\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+"
              + @"[a-zA-Z]{2,}))$";
        Regex reStrict = new Regex(patternStrict);

        //bool isLenientMatch = reLenient.IsMatch(emailAddress);
        //return isLenientMatch;

        bool isStrictMatch = reStrict.IsMatch(emailAddress);
        return isStrictMatch;
    }

    public static string getNewRefID()
    {
        string _RefID = " ";

        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_get_Passport_RefID";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                SqlParameter RefID = new SqlParameter("@RefID", SqlDbType.VarChar, 14);
                RefID.Direction = ParameterDirection.InputOutput;
                RefID.Value = _RefID;

                cmd.Parameters.Add(RefID);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();

                _RefID = string.Format("{0}", RefID.Value);
            }
        }
        return _RefID.Trim();
    }

    public static string getPayments_Passport_Type(string RefID)
    {
        string RetVal = " ";

        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "SELECT [Type] FROM [dbo].[Payments_Passport] WHERE RefID = '" + RefID + "'";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;

                cmd.Connection = conn;
                conn.Open();

                SqlDataReader r = cmd.ExecuteReader();
                
                while (r.Read())
                {
                    RetVal = string.Format("{0}", r["Type"]);
                }

                r.Close();
                          
            }
        }
        return RetVal.Trim();
    }

    public static void WriteLog(string Page, string LogText)
    {
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_ErrorLog_Insert";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@Page", System.Data.SqlDbType.VarChar).Value = Page;
                cmd.Parameters.Add("@Msg", System.Data.SqlDbType.VarChar).Value = LogText;
                cmd.Connection = conn;
                if (conn.State == ConnectionState.Closed) conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }

    //public static void WriteLog(string LogText)
    //{
    //    try
    //    {
    //        using (StreamWriter _testData = new StreamWriter(HttpContext.Current.Request.MapPath("~/Log/" + DateTime.Now.Date.ToString("yyyy_MM_dd") + ".txt"), true))
    //        {
    //            _testData.WriteLine(DateTime.Now.ToString("hh:mm:ss tt") + " : " + LogText); // Write the file.
    //        }
    //    }
    //    catch (Exception) { }
    //}

    public static string getHTML(string _Title, string _Body, string _ImageFileName, string _Width)
    {
        StringBuilder sb = new StringBuilder();

        sb.AppendLine("<html>");
        sb.AppendLine("<title>" + _Title + "</title>");
        sb.AppendLine("<link href='./CSS/StyleSheet.css' rel='stylesheet' type='text/css' />");
        sb.AppendLine("<body>");
            sb.AppendLine("<div style='margin: 0 auto; padding: 50px' align='center'>");
                sb.AppendLine("<div class='group' style='width: "+ _Width +";'>");
                    sb.AppendLine("<h4 style='text-align: center'>"+ _Title + "</h4>");
                    sb.AppendLine("<div style='padding: 20px; text-align: left'>");
                        sb.AppendLine("<table><tr><td valign='top' style='padding-right: 25px'>");
                            sb.AppendLine("<img src='Images/" + _ImageFileName + "' />");
                        sb.AppendLine("</td><td valign='top'>");
                            sb.AppendLine(_Body);
                        sb.AppendLine("</td></tr></table>");
                    sb.AppendLine("</div>");
                sb.AppendLine("</div>");
            sb.AppendLine("</div>");
        sb.AppendLine("</body>");
        sb.AppendLine("</html>");
        return sb.ToString();
    }

    

    public static string getValueOfKey(string KeyName)
    {
        try
        {
            return string.Format("{0}", System.Configuration.ConfigurationSettings.AppSettings[KeyName]);
        }
        catch (Exception) { return string.Empty; }
    }
}