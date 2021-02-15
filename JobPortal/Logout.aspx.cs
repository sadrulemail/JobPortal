using System;
using System.Web;

namespace JobPortal
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = "Logged Out - Trust Bank Job Portal";
            try
            {
                Session["USERNAME"] = null;
                Session.Abandon();
                string CookieName = "Login_";
                try
                {
                    HttpCookie cookie = new HttpCookie(CookieName);
                    cookie.Values.Add("Username", "");
                    cookie.Values.Add("Password", "");
                    cookie.Expires = DateTime.Now.AddYears(-20);
                    Response.Cookies.Add(cookie);
                }
                catch (Exception) { }
            }
            catch (Exception) { }
            //Response.Redirect("~/", true);

            try
            {
                string FBPages = Common.getValueOfKey("FbPages");
                string[] names = FBPages.Split(',');
                Random random = new Random();
                int index = random.Next(names.Length);



                FB_iFrame.Text = string.Format("<iframe src='//www.facebook.com/plugins/likebox.php?href=https%3A%2F%2Fwww.facebook.com%2F{0}&amp;width=290px&amp;height=290&amp;colorscheme=light&amp;show_faces=true&amp;header=true&amp;stream=false&amp;show_border=true&amp;appId=111198355565695' scrolling='no' frameborder='0' style='border:none; overflow:hidden; width:290px; height:290px;' allowTransparency='true'></iframe>"
                    , names[index]);



                // cmd.Text = Request.Browser.ScreenPixelsWidth.ToString();
            }
            catch (Exception) { }
        }
    }
}