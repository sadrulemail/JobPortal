using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using Microsoft.Exchange.WebServices.Data;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;

namespace JobPortal
{
    public partial class Signup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Title = "Create Trust Bank Job Portal Account";

            if (!IsPostBack)
            {
                //PanelStatus.Visible = false;
                //ImgChallenge.Src = "captcha.ashx?rand=" + RandomNumer() + RandomNumer();
            }

            SqlConnection.ClearAllPools();

            //Panel1.Visible = true;
            //Panel1.Visible = false;
            //PanelFacebook.Visible = true;
            //lblStatus.Text = "An email has been sent to ashik.email@gmail.com containing a verification Url. Please check your email account and click on that Url to proceed next. It may take a minute or more to receive the email.";

            //Facebook Random iFrame
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

        protected string RandomNumer()
        {
            return (new Random().Next()).ToString();
        }

        protected void cmd_Click(object sender, EventArgs e)
        {
            //ClientMsg(Request.Url.OriginalString.Split('?')[0]);
            string Url_Email_Verify = Request.Url.Scheme + "://" + Request.Url.Host + ":" + Request.Url.Port + Request.ApplicationPath + "/Email_Verify.aspx";
            Url_Email_Verify = Url_Email_Verify.Replace(":80/", "/").Replace(":443/", "/");
            //ClientMsg(Url_Email_Verify);
            //return;

            if (IsPostBack)
            {
                txtEmail.Attributes.Add("value", txtEmail.Text);
                txtPassword.Attributes.Add("value", txtPassword.Text);
                txtConformPassword.Attributes.Add("value", txtConformPassword.Text);
            }

            if (!Common.isEmailAddress(txtEmail.Text))
            {
                txtCaptcha.Text = "";
                CommonControl1.ClientMsg("Please enter a valid email address.", txtEmail);
                //txtEmail.Focus();

                return;
            }

            TrustCaptcha captcha = new TrustCaptcha();
            if (txtCaptcha.Text != string.Format("{0}", Session[TrustCaptcha.SESSION_CAPTCHA]))
            {
                //txtCaptcha.Focus();
                txtCaptcha.Text = "";
                CommonControl1.ClientMsg("Please enter correct Challenge Key.", txtCaptcha);
                return;
            }

            bool Done = false;
            string MsgBody = "";
            string MsgSubject = "";
            string Msg = "";

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Email_Varify_Insert";

                conn.ConnectionString = System.Configuration.ConfigurationManager
                                .ConnectionStrings["JobPortalConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand(Query, conn))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@Email", System.Data.SqlDbType.VarChar).Value = txtEmail.Text.Trim();
                    cmd.Parameters.Add("@FullName", System.Data.SqlDbType.VarChar).Value = txtFullName.Text.Trim();
                    cmd.Parameters.Add("@Mobile", System.Data.SqlDbType.BigInt).Value = txtMobile.Text.Trim().Replace("+", "").Replace(" ", "").Replace("-", "");
                    cmd.Parameters.Add("@Password", System.Data.SqlDbType.NVarChar).Value = txtPassword.Text;
                    //cmd.Parameters.Add("@Type", System.Data.SqlDbType.Int).Value = dboReqType.SelectedItem.Value;
                    cmd.Parameters.Add("@Url_Email_Verify", System.Data.SqlDbType.VarChar).Value = Url_Email_Verify;

                    SqlParameter SQL_Done = new SqlParameter("@Done", SqlDbType.Bit);
                    SQL_Done.Direction = ParameterDirection.InputOutput;
                    SQL_Done.Value = Done;
                    cmd.Parameters.Add(SQL_Done);

                    SqlParameter SQL_MsgBody_Out = new SqlParameter("@MsgBody_Out", SqlDbType.VarChar, 10000);
                    SQL_MsgBody_Out.Direction = ParameterDirection.InputOutput;
                    SQL_MsgBody_Out.Value = MsgBody;
                    cmd.Parameters.Add(SQL_MsgBody_Out);

                    SqlParameter SQL_MsgSubject_Out = new SqlParameter("@MsgSubject_Out", SqlDbType.VarChar, 255);
                    SQL_MsgSubject_Out.Direction = ParameterDirection.InputOutput;
                    SQL_MsgSubject_Out.Value = MsgSubject;
                    cmd.Parameters.Add(SQL_MsgSubject_Out);

                    SqlParameter SQL_Msg_Out = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                    SQL_Msg_Out.Direction = ParameterDirection.InputOutput;
                    SQL_Msg_Out.Value = Msg;
                    cmd.Parameters.Add(SQL_Msg_Out);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                    //{
                    //    if (sdr.HasRows)
                    //    {
                    //        while (sdr.Read())
                    //        {
                    //            //KeyCode = string.Format("{0}", sdr["KeyCode"]);
                    //        }
                    //    }
                    //}

                    Done = (bool)SQL_Done.Value;
                    MsgSubject = string.Format("{0}", SQL_MsgSubject_Out.Value);
                    MsgBody = string.Format("{0}", SQL_MsgBody_Out.Value);
                    Msg = string.Format("{0}", SQL_Msg_Out.Value);
                }

                if (Done)
                {
                    //Send Email
                    string EmailType = Common.getValueOfKey("EmailType");
                    string ExchangeUrl = Common.getValueOfKey("ExchangeUrl");
                    string ExchangeUserName = Common.getValueOfKey("ExchangeUserName");
                    string ExchangeUserPassword = Common.getValueOfKey("ExchangeUserPassword");

                    try
                    {
                        ExchangeService service = new ExchangeService(ExchangeVersion.Exchange2013);
                        service.Url = new Uri(ExchangeUrl);

                        ServicePointManager.ServerCertificateValidationCallback =
                            delegate(Object obj, X509Certificate certificate, X509Chain chain, SslPolicyErrors error)
                            {
                                return true;
                            };
                        service.UseDefaultCredentials = false;
                        service.Credentials = new WebCredentials(ExchangeUserName, ExchangeUserPassword);

                        EmailMessage message = new EmailMessage(service);
                        message.Subject = MsgSubject;
                        message.Body = new MessageBody(BodyType.HTML, string.Format("{0}", MsgBody).Replace("\n", "<br />"));


                        message.ToRecipients.Add(txtEmail.Text.Trim());                       

                        message.Send();
                        lblStatus.Text = Msg;
                    }
                    catch (Exception ex)
                    {
                        CommonControl1.ClientMsg("<b>Unable to send email.</b><br />" + ex.Message, cmd);
                        return;
                    }
                }
                else
                {
                    CommonControl1.ClientMsg(Msg, txtEmail);
                    return;
                }
                    
                PanelStatus.Visible = true;
                Panel1.Visible = false;
                PanelFacebook.Visible = true;     
                
            }
        }
    }
}