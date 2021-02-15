using System;
using System.Data.SqlClient;
using System.Globalization;
using System.Text.RegularExpressions;
using System.Web.UI;

public partial class TrustControl : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Culture = "en-NZ";
        SqlConnection.ClearAllPools();
    }
    public void ClientScriptStartup(string ScriptTxt)
    {
        ScriptManager.RegisterStartupScript(this.Page, this.Page.GetType(), "clientScript", ScriptTxt, true);
    }
    public void ClientIDFocus(string ClientID)
    {
        //ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "<script>document.getElementById('" + ClientID + "').focus();document.getElementById('" + ClientID + "').select();</script>", true);
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "$('#" + ClientID + "').focus().select();", true);
    }
    public void ClientMsg(string MsgTxt, Control focusControl)
    {
        string script1 = "";
        if (focusControl != null)
            script1 = "$('#" + focusControl.ClientID + "').focus();";
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "jAlert('" + MsgTxt + "','Trust Bank', function(r){" + script1 + "});", true);
    }
    public void ClientMsg(string MsgTxt)
    {
        ClientMsg(MsgTxt, null);
    }
    public void ClientScript(string ScriptTxt)
    {
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", ScriptTxt, true);
    }
    public bool isEmailAddress(string emailAddress)
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

    public string ToRelativeDate(object input)
    {
        try
        {
            return ToRelativeDate((DateTime)(input));
        }
        catch (Exception) { return string.Empty; }
    }

    public string ToRelativeDate(DateTime input)
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

    public string ToRecentDateTime(object input)
    {
        try
        {
            return ToRecentDateTime((DateTime)(input));
        }
        catch (Exception) { return string.Empty; }
    }

    public string ToRecentDateTime(DateTime input)
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

    public string ToRecentDate(object input)
    {
        try
        {
            return ToRecentDate((DateTime)(input));
        }
        catch (Exception) { return string.Empty; }
    }

    public string ToRecentDate(DateTime input)
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

    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }

    public CultureInfo Bangla
    {
        get
        {
            return new CultureInfo("bn-BD");
        }
    }
}