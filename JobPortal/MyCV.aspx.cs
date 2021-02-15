using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing.Drawing2D;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SD = System.Drawing;
using System.Drawing.Drawing2D;

namespace JobPortal
{
    public partial class MyCV : System.Web.UI.Page
    {
        string ID;
        string LoginID;
        string FileKey_EmpSign;
        string UploadTempFile;
        string ImageName;
        bool isInfoEditable = true;     
        string UploadPath;
        string UploadCropFile;
        int MaxImageSizePx_ToSaveDB;

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Form.Attributes.Add("enctype", "multipart/form-data");

            try
            {
                if (!Directory.Exists(Server.MapPath("Upload/"))) Directory.CreateDirectory(Server.MapPath("Upload/"));
                //Response.Write(UploadTempFile);
            }
            catch (Exception) { }

            if (!IsPostBack)
            {
                Session["FILENAME"] = "";
                Random R = new Random(DateTime.Now.Millisecond +
                                DateTime.Now.Second * 1000 +
                                DateTime.Now.Minute * 60000 +
                                DateTime.Now.Hour * 3600000);
                hidTime.Value = string.Format("{0}", R.Next());

                this.Title = "My CV - Trust Bank Job Portal";

            }
            else
            {
                DataListCV_Completion.DataBind();
            }

            try
            {
                if (!Directory.Exists(Server.MapPath("Upload/"))) Directory.CreateDirectory(Server.MapPath("Upload/"));
                ImageName = string.Format("{0}_{1}_{2}.jpg", Session["USERID"], Session.SessionID, hidTime.Value);
                UploadTempFile = Server.MapPath("Upload/" + ImageName);
                UploadCropFile = Server.MapPath("Upload/crop_" + ImageName);
                UploadPath = Server.MapPath("Upload/");
                //Response.Write(UploadTempFile);
            }
            catch (Exception) { }
        }

        public bool getIsEditable() { return true; }

        protected void dboDivision2_SelectedIndexChanged1(object sender, EventArgs e)
        {
            DropDownList dboDistrict2 = ((DropDownList)DetailsViewPersonal.FindControl("dboDistrict2"));
            dboDistrict2.Items.Clear();
            dboDistrict2.DataBind();
        }

        protected void dboDistrict2_DataBound(object sender, EventArgs e)
        {
            DropDownList dboDistrict2 = ((DropDownList)DetailsViewPersonal.FindControl("dboDistrict2"));
            String District = ((HiddenField)(DetailsViewPersonal.FindControl("hidDistrict"))).Value;

            try
            {
                foreach (ListItem LI in dboDistrict2.Items)
                    if (LI.Value == District)
                        LI.Selected = true;
                    else
                        LI.Selected = false;
            }
            catch (Exception) { }

            DropDownList dboThana2 = ((DropDownList)DetailsViewPersonal.FindControl("dboThana2"));
            dboThana2.Items.Clear();
            dboThana2.DataBind();
        }

        protected void dboDistrict2_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList dboThana2 = ((DropDownList)DetailsViewPersonal.FindControl("dboThana2"));
            dboThana2.Items.Clear();
            dboThana2.DataBind();

            String Thana = ((HiddenField)(DetailsViewPersonal.FindControl("hidThana"))).Value;

            try
            {
                foreach (ListItem LI in dboThana2.Items)
                    if (LI.Value == Thana)
                        LI.Selected = true;
                    else
                        LI.Selected = false;
            }
            catch (Exception) { }
        }
        protected void dboThana2_DataBound(object sender, EventArgs e)
        {
            DropDownList dbo = (DropDownList)sender;
            String Thana2 = ((HiddenField)(DetailsViewPersonal.FindControl("hidThana"))).Value;

            try
            {
                foreach (ListItem LI in dbo.Items)
                    if (LI.Value == Thana2)
                        LI.Selected = true;
                    else
                        LI.Selected = false;
            }
            catch (Exception)
            {
                //dbo.Items[0].Value = Thana;
            }
        }
        protected void dboThanaP_DataBound(object sender, EventArgs e)
        {
            DropDownList dboP = (DropDownList)sender;
            String ThanaP = ((HiddenField)(DetailsViewPersonal.FindControl("hidThanaP"))).Value;

            try
            {
                foreach (ListItem LI in dboP.Items)
                    if (LI.Value == ThanaP)
                        LI.Selected = true;
                    else
                        LI.Selected = false;
            }
            catch (Exception)
            {
                //dbo.Items[0].Value = Thana;
            }
        }
        protected void SqlDataSourcePersonal_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            DataListPersonal.Visible = true;
            DataListPersonal.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewPersonal.ChangeMode(DetailsViewMode.ReadOnly);
            DetailsViewPersonal.Visible = false;
            //DetailsViewPersonal.SelectedIndex = -1;
            RefreshStastics();
        }

        protected void SqlDataSourceOthers_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            //DataListPersonal.Visible = true;
            //GridViewOthers.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewPersonal.ChangeMode(DetailsViewMode.ReadOnly);
            //DetailsViewOthers.Visible = false;
            //DetailsViewPersonal.SelectedIndex = -1;
            RefreshStastics();
        }

        protected void SqlDataSourceOthers_Updating(object sender, SqlDataSourceCommandEventArgs e)
        {
            ListBox jobcategory = (ListBox)DetailsViewOthers.FindControl("lbPreferedJobCategory");
            string obCategoryIDs = "";
            foreach (ListItem LI in jobcategory.Items)
                if (LI.Selected)
                    obCategoryIDs += LI.Value + ",";
            e.Command.Parameters["@PreferedJobCategory"].Value = obCategoryIDs;
        }

        protected void SqlDataSourceOthers_Inserting(object sender, SqlDataSourceCommandEventArgs e)
        {
            ListBox jobcategory = (ListBox)DetailsViewOthers.FindControl("lbPreferedJobCategory");
            string obCategoryIDs = "";
            foreach (ListItem LI in jobcategory.Items)
                if (LI.Selected)
                    obCategoryIDs += LI.Value + ",";
            e.Command.Parameters["@PreferedJobCategory"].Value = obCategoryIDs;
        }

        protected void lbPreferedJobCategory_DataBound(object sender, EventArgs e)
        {
            ListBox jobcategory = (ListBox)DetailsViewOthers.FindControl("lbPreferedJobCategory");
            string obCategoryIDs = ((HiddenField)DetailsViewOthers.FindControl("hidJobCategoryIDs")).Value;
            string[] ss = obCategoryIDs.Split(',');

            foreach (ListItem LI in jobcategory.Items)
                foreach (string s in ss)
                    if (s.Trim() == LI.Value)
                        LI.Selected = true;
            
        }
        protected void SqlDataSourcePersonal_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            //if (!Done)
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            int ID = (int)e.Command.Parameters["@ID"].Value;
            DataListPersonal.DataBind();
            DetailsViewPersonal.ChangeMode(DetailsViewMode.ReadOnly);
            DetailsViewPersonal.Visible = false;
            RefreshStastics();
        }

        protected void SqlDataSourceOthers_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            
            //GridViewOthers.DataBind();
            DetailsViewOthers.ChangeMode(DetailsViewMode.ReadOnly);
            //DetailsViewOthers.Visible = false;
            RefreshStastics();
        }
        protected void SqlDataSourceDependents_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            //if (!Done)
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            int ID = (int)e.Command.Parameters["@ID"].Value;
            DataListDependents.DataBind();
            DetailsViewDependents.ChangeMode(DetailsViewMode.ReadOnly);
            RefreshStastics();
        }

        protected void SqlDataSourceDependents_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            DataListDependents.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewDependents.ChangeMode(DetailsViewMode.ReadOnly);
            DataListDependents.SelectedIndex = -1;
            RefreshStastics();
        }
        protected void SqlDataSourcePersonal_Inserting(object sender, SqlDataSourceCommandEventArgs e)
        {
            e.Command.Parameters["@Present_ThanaID"].Value = ((DropDownList)DetailsViewPersonal.FindControl("dboThana2")).SelectedItem.Value;
            e.Command.Parameters["@Permanent_ThanaID"].Value = ((DropDownList)DetailsViewPersonal.FindControl("dboThanaP")).SelectedItem.Value;
        }
        protected void SqlDataSourcePersonal_Updating(object sender, SqlDataSourceCommandEventArgs e)
        {
            e.Command.Parameters["@Present_ThanaID"].Value = ((DropDownList)DetailsViewPersonal.FindControl("dboThana2")).SelectedItem.Value;
            e.Command.Parameters["@Permanent_ThanaID"].Value = ((DropDownList)DetailsViewPersonal.FindControl("dboThanaP")).SelectedItem.Value;
        }
        protected void DataListPersonal_EditCommand(object source, DataListCommandEventArgs e)
        {

        }
        protected void SqlDataSourcePersonalGrid_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (e.AffectedRows > 0 && DetailsViewPersonal.CurrentMode == DetailsViewMode.ReadOnly)
                DetailsViewPersonal.Visible = false;
        }
        protected void DataListPersonal_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                DetailsViewPersonal.Visible = true;
                DetailsViewPersonal.ChangeMode(DetailsViewMode.Edit);
                DataListPersonal.Visible = false;
            }
        }

        protected void DataListObjectives_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                DetailsViewCareerObjective.Visible = true;
                DetailsViewCareerObjective.ChangeMode(DetailsViewMode.Edit);
                //DataListObjectives.Visible = false;
            }
        }
        protected void SqlDataSourceInterestGrid_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            //DetailsViewPersonalInterest.Visible = e.AffectedRows == 0;
        }

        protected void SqlDataSourceCareerObjectiveGrid_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            DetailsViewCareerObjective.Visible = e.AffectedRows == 0;
        }

        protected void SqlDataSourceInterestGrid_Deleted(object sender, SqlDataSourceStatusEventArgs e)
        {
            //DetailsViewPersonalInterest.DataBind();
            //DetailsViewPersonalInterest.Visible = true;
        }

        protected void SqlDataSourceCareerObjectiveGrid_Deleted(object sender, SqlDataSourceStatusEventArgs e)
        {
            DetailsViewCareerObjective.DataBind();
            DetailsViewCareerObjective.Visible = true;
            RefreshStastics();
        }
       

        protected void FileUpload1_UploadedFileError(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {

        }

        

        

        protected void cmdTest_Click(object sender, EventArgs e)
        {
            System.Threading.Thread.Sleep(3000);
        }

        protected void dboDivisionP_SelectedIndexChanged1(object sender, EventArgs e)
        {
            DropDownList dboDistrictP = ((DropDownList)DetailsViewPersonal.FindControl("dboDistrictP"));
            dboDistrictP.Items.Clear();
            dboDistrictP.DataBind();
        }

        protected void dboDistrictP_DataBound(object sender, EventArgs e)
        {
            DropDownList dboDistrictP = ((DropDownList)DetailsViewPersonal.FindControl("dboDistrictP"));
            String DistrictP = ((HiddenField)(DetailsViewPersonal.FindControl("hidDistrictP"))).Value;
            //UserControl1.ClientMsg(DistrictP);
            //return;
            try
            {
                foreach (ListItem LI in dboDistrictP.Items)
                    if (LI.Value == DistrictP)
                        LI.Selected = true;
                    else
                        LI.Selected = false;
            }
            catch (Exception) { }

            DropDownList dboThanaP = ((DropDownList)DetailsViewPersonal.FindControl("dboThanaP"));
            dboThanaP.Items.Clear();
            dboThanaP.DataBind();
        }

        protected void DetailsViewDependents_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                DataListDependents.SelectedIndex = -1;
            }
        }

        public string getResultText(object Result, object Marks_CGPA, object Total_CGPA)
        {
            string RetVal = "";

            switch (string.Format("{0}", Result))
            {
                case "Appeared":
                    RetVal = "Appeared";
                    break;
                case "Enrolled":
                    RetVal = "Enrolled";
                    break;
                case "Awarded":
                    RetVal = "Awarded";
                    break;
                case "Do not mention":
                    RetVal = "Do not mention";
                    break;
                case "Grade":
                    RetVal = string.Format("CGPA: {0} out of: {1}", Marks_CGPA, Total_CGPA);
                    break;
                default:
                    RetVal = string.Format("{0}", Result) + string.Format(", Marks: {0}", Marks_CGPA);
                    break;
            }

            return RetVal;
        }

        protected void DataListEducation_SelectedIndexChanged(object sender, EventArgs e)
        {
            DetailsViewEducation.ChangeMode(DetailsViewMode.Edit);
            DetailsViewEducation.Focus();
        }

        protected void DataListProfessionalQualification_SelectedIndexChanged(object sender, EventArgs e)
        {
            DetailsViewProfessionalQualification.ChangeMode(DetailsViewMode.Edit);
            DetailsViewProfessionalQualification.Focus();
        }

        protected void DataListExperience_SelectedIndexChanged(object sender, EventArgs e)
        {
            DetailsViewExperience.ChangeMode(DetailsViewMode.Edit);
            DetailsViewExperience.Focus();
        }
        protected void DetailsViewMembership_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                GridViewMemberAssociation.SelectedIndex = -1;
            }
        }
        protected void SqlDataSourceExperience_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            DataListExperience.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewExperience.ChangeMode(DetailsViewMode.ReadOnly);
            RefreshStastics();
        }

        protected void SqlDataSourceExperience_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            DataListExperience.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewExperience.ChangeMode(DetailsViewMode.ReadOnly);
            DataListExperience.SelectedIndex = -1;
            RefreshStastics();
        }
        protected void GridViewExperience_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            DetailsViewExperience.ChangeMode(DetailsViewMode.Edit);
            DetailsViewExperience.Focus();
        }

        protected void GridViewOthers_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            DetailsViewOthers.ChangeMode(DetailsViewMode.Edit);
            DetailsViewOthers.Focus();
        }

        protected void SqlDataSourceEducation_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            DataListEducation.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewEducation.ChangeMode(DetailsViewMode.ReadOnly);
            DataListEducation.SelectedIndex = -1;
            RefreshStastics();
        }

        protected void SqlDataSourceProfessionalQualification_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            DataListProfessionalQualification.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewProfessionalQualification.ChangeMode(DetailsViewMode.ReadOnly);
            DataListProfessionalQualification.SelectedIndex = -1;
            RefreshStastics();
        }
        protected void DetailsViewExperience_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                DataListExperience.SelectedIndex = -1;
            }
        }
        protected void SqlDataSourceEducation_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            DataListEducation.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewEducation.ChangeMode(DetailsViewMode.ReadOnly);
            DataListEducation.SelectedIndex = -1;
            RefreshStastics();
        }

        protected void SqlDataSourceProfessionalQualification_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            DataListProfessionalQualification.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewProfessionalQualification.ChangeMode(DetailsViewMode.ReadOnly);
            DataListProfessionalQualification.SelectedIndex = -1;
            RefreshStastics();
        }
        protected void DataListEducation_DeleteCommand(object source, DataListCommandEventArgs e)
        {
            SqlDataSourceEducation.DeleteParameters["ID"].DefaultValue = e.CommandArgument.ToString();
            SqlDataSourceEducation.Delete();
            DataListEducation.DataBind();
            UserControl1.ClientMsg("Successfully Deleted.");
            RefreshStastics();
        }

        protected void DataListProfessionalQualification_DeleteCommand(object source, DataListCommandEventArgs e)
        {
            SqlDataSourceProfessionalQualificationGrid.DeleteParameters["ID"].DefaultValue = e.CommandArgument.ToString();
            SqlDataSourceProfessionalQualificationGrid.Delete();
            DataListProfessionalQualification.DataBind();
            UserControl1.ClientMsg("Successfully Deleted.");
            RefreshStastics();
        }

        protected void DataListExperience_DeleteCommand(object source, DataListCommandEventArgs e)
        {
            SqlDataSourceExperienceGrid.DeleteParameters["ID"].DefaultValue = e.CommandArgument.ToString();
            SqlDataSourceExperienceGrid.Delete();
            DataListExperience.DataBind();
            UserControl1.ClientMsg("Successfully Deleted.");
            RefreshStastics();
        }
        protected void DataListDependents_DeleteCommand(object source, DataListCommandEventArgs e)
        {
            SqlDataSourceDependents.DeleteParameters["ID"].DefaultValue = e.CommandArgument.ToString();
            SqlDataSourceDependents.Delete();
            DataListDependents.DataBind();
            UserControl1.ClientMsg("Successfully Deleted.");
            RefreshStastics();
        }
        protected void DataListDependents_SelectedIndexChanged(object sender, EventArgs e)
        {
            DetailsViewDependents.ChangeMode(DetailsViewMode.Edit);
            DetailsViewDependents.Focus();
        }
        protected void DetailsViewEducation_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                DataListEducation.SelectedIndex = -1;
            }
        }

        protected void DetailsViewProfessionalQualification_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                DataListProfessionalQualification.SelectedIndex = -1;
            }
        }

        protected void DataListPersonal_DeleteCommand(object sender, DataListCommandEventArgs e)
        {
            SqlDataSourcePersonalGrid.DeleteParameters["ID"].DefaultValue = e.CommandArgument.ToString();
            SqlDataSourcePersonalGrid.Delete();
            UserControl1.ClientMsg("Successfully Deleted.");
            DetailsViewPersonal.Visible = true;
            DetailsViewPersonal.DataBind();
            SqlDataSourcePersonalGrid.DataBind();
            //DetailsViewPersonal.ChangeMode(DetailsViewMode.Insert);
            RefreshStastics();
        }

        private void RefreshStastics()
        {
            DataListCV_Completion.DataBind();
        }

        protected void DataListObjectives_DeleteCommand(object sender, DataListCommandEventArgs e)
        {
            //SqlDataSourcePersonalGrid.DeleteParameters["ID"].DefaultValue = e.CommandArgument.ToString();
            //SqlDataSourcePersonalGrid.Delete();
            //UserControl1.ClientMsg("Successfully Deleted.");
            //DetailsViewPersonal.Visible = true;
            //DetailsViewPersonal.DataBind();
            //SqlDataSourcePersonalGrid.DataBind();
            //DetailsViewPersonal.ChangeMode(DetailsViewMode.Insert);
        }

        protected void dboDistrictP_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList dboThanaP = ((DropDownList)DetailsViewPersonal.FindControl("dboThanaP"));
            dboThanaP.Items.Clear();
            dboThanaP.DataBind();

            String ThanaP = ((HiddenField)(DetailsViewPersonal.FindControl("hidThanaP"))).Value;

            try
            {
                foreach (ListItem LI in dboThanaP.Items)
                    if (LI.Value == ThanaP)
                        LI.Selected = true;
                    else
                        LI.Selected = false;
            }
            catch (Exception) { }
        }

        protected void DetailsViewPersonal_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                DataListPersonal.SelectedIndex = -1;
                DetailsViewPersonal.Visible = false;
                DataListPersonal.Visible = true;
            }
        }
        protected void GridViewMemberAssociation_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            DetailsViewMembership.ChangeMode(DetailsViewMode.Edit);
            DetailsViewMembership.Focus();
        }
        protected void SqlDataSourceMembership_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            GridViewMemberAssociation.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewMembership.ChangeMode(DetailsViewMode.ReadOnly);
            GridViewMemberAssociation.SelectedIndex = -1;
            RefreshStastics();
        }
        protected void SqlDataSourceMembership_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            GridViewMemberAssociation.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewMembership.ChangeMode(DetailsViewMode.ReadOnly);
            GridViewMemberAssociation.SelectedIndex = -1;
            RefreshStastics();
        }
        protected void DetailsViewTraining_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                GridViewTraining.SelectedIndex = -1;
            }
        }
        protected void DetailsViewLanguageProficiency_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                GridViewLanguageProficiency.SelectedIndex = -1;
            }
        }
        protected void GridViewLanguageProficiency_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            DetailsViewLanguageProficiency.ChangeMode(DetailsViewMode.Edit);
            DetailsViewLanguageProficiency.Focus();
        }

        protected void GridViewTraining_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            DetailsViewTraining.ChangeMode(DetailsViewMode.Edit);
            DetailsViewTraining.Focus();
        }


        protected void SqlDataSourceTraining_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            GridViewTraining.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewTraining.ChangeMode(DetailsViewMode.ReadOnly);
            GridViewTraining.SelectedIndex = -1;
            RefreshStastics();
        }

        protected void SqlDataSourceLanguageProficiency_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;

            GridViewLanguageProficiency.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewLanguageProficiency.ChangeMode(DetailsViewMode.ReadOnly);
            GridViewLanguageProficiency.SelectedIndex = -1;
            RefreshStastics();
            
        }

        protected void SqlDataSourceTraining_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            GridViewTraining.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewTraining.ChangeMode(DetailsViewMode.ReadOnly);
            RefreshStastics();
        }

        protected void SqlDataSourceLanguageProficiency_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;

            GridViewLanguageProficiency.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewLanguageProficiency.ChangeMode(DetailsViewMode.ReadOnly);
            RefreshStastics();
        }

        protected void SqlDataSourceInterest_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            //GridViewInterest.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            //DetailsViewPersonalInterest.ChangeMode(DetailsViewMode.ReadOnly);
            RefreshStastics();
        }

        protected void SqlDataSourceCareerObjective_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            //GridViewCareerObjective.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewCareerObjective.ChangeMode(DetailsViewMode.ReadOnly);
            RefreshStastics();
        }

        protected void SqlDataSourceInterest_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            //GridViewInterest.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            //DetailsViewPersonalInterest.ChangeMode(DetailsViewMode.ReadOnly);
            RefreshStastics();
        }

        protected void SqlDataSourceCareerObjective_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            //GridViewCareerObjective.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewCareerObjective.ChangeMode(DetailsViewMode.ReadOnly);
            RefreshStastics();
        }

        protected void DetailsViewPersonalInterest_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                //GridViewInterest.SelectedIndex = -1;
                //DetailsViewPersonalInterest.Visible = false;
            }
        }

        protected void DetailsViewCareerObjective_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                //GridViewCareerObjective.SelectedIndex = -1;
                //DetailsViewCareerObjective.Visible = false;
            }
        }
        protected void GridViewInterest_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            //DetailsViewPersonalInterest.Visible = true;
            //DetailsViewPersonalInterest.ChangeMode(DetailsViewMode.Edit);
            //DetailsViewPersonalInterest.Focus();
        }

        protected void GridViewCareerObjective_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
        {
            DetailsViewCareerObjective.Visible = true;
            DetailsViewCareerObjective.ChangeMode(DetailsViewMode.Edit);
            DetailsViewCareerObjective.Focus();
        }

        protected void DetailsViewRef_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                DataListReferences.SelectedIndex = -1;
            }
        }

        protected void DetailsViewOthers_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                //GridViewOthers.SelectedIndex = -1;
            }
        }
        protected void DataListReferences_SelectedIndexChanged(object sender, EventArgs e)
        {
            //DetailsViewRef.Visible = true;
            DetailsViewRef.ChangeMode(DetailsViewMode.Edit);
            DetailsViewRef.Focus();
        }
        protected void DataListReferences_DeleteCommand(object source, DataListCommandEventArgs e)
        {
            SqlDataSourceRef.DeleteParameters["ID"].DefaultValue = e.CommandArgument.ToString();
            SqlDataSourceRef.Delete();
            DataListReferences.DataBind();
            UserControl1.ClientMsg("Successfully Deleted.");
            RefreshStastics();
        }
        protected void SqlDataSourceRef_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            DataListReferences.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewRef.ChangeMode(DetailsViewMode.ReadOnly);
            DataListReferences.SelectedIndex = -1;
            RefreshStastics();
        }
        protected void SqlDataSourceRef_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (e.AffectedRows == 0)
            {
                //tabHistory.Visible = false;
            }
        }
        protected void SqlDataSourceRef_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
            bool Done = (bool)e.Command.Parameters["@Done"].Value;
            int ID = (int)e.Command.Parameters["@ID"].Value;
            DataListReferences.DataBind();
            UserControl1.ClientMsg(string.Format("{0}", Msg));
            DetailsViewRef.ChangeMode(DetailsViewMode.ReadOnly);
            DataListReferences.SelectedIndex = -1;
            RefreshStastics();

        }

        protected void DetailsViewCareerObjective_DataBound(object sender, EventArgs e)
        {
            DetailsViewCareerObjective.Fields[DetailsViewCareerObjective.Fields.Count - 1].Visible =
                !(DetailsViewCareerObjective.CurrentMode == DetailsViewMode.ReadOnly);
        }

        protected void DetailsViewOthers_DataBound(object sender, EventArgs e)
        {
            DetailsViewOthers.Fields[DetailsViewOthers.Fields.Count - 1].Visible =
                !(DetailsViewOthers.CurrentMode == DetailsViewMode.ReadOnly);
        }
        
        
        
        protected void TabContainer1_ActiveTabChanged(object sender, EventArgs e)
        {
            //DetailsView1.ChangeMode(DetailsViewMode.ReadOnly);
            Session["ProfileTab"] = TabContainer1.ActiveTabIndex;

            //if (TabContainer1.ActiveTab == tabHistory)
            {
                //GridViewPasswordHistory.DataBind();
                //UserControl1.ClientMsg(TabContainer1.ActiveTab.ID);
                //SqlDSChangePassword_Log_Show.DataBind();
            }


        }


        public void FileUpload1_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                Session["FILENAME"] = FileUpload1.FileName.Trim();
                if (FileUpload1.FileBytes.Length > (2 * 1024 * 1024))
                {
                    throw new Exception("Invalid File Size");
                }
                FileUpload1.SaveAs(UploadTempFile);
                FileInfo FI = new FileInfo(UploadTempFile);
                FI.CreationTime = DateTime.Now;
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message);
            }
        }

        protected void cmdUpload_Click(object sender, EventArgs e)
        {
            Panel1.Visible = false;
            pnlCrop.Visible = true;
            imgCrop.ImageUrl = "Images/loader.gif";
            imgCrop.Attributes.Add("loadimg", "Upload/" + ImageName);
            PanelProfileImage.Visible = false;
        }

        protected void btnCrop_Click(object sender, EventArgs e)
        {
            int w = 200;
            int h = 200;
            int x = 0;
            int y = 0;

            try
            {
                w = (int)double.Parse(W.Value);
                h = (int)double.Parse(H.Value);
                x = (int)double.Parse(X.Value);
                y = (int)double.Parse(Y.Value);
            }
            catch (Exception)
            {
            }
            byte[] CropImage = Crop(UploadPath + ImageName, w, h, x, y);
            using (MemoryStream ms = new MemoryStream(CropImage, 0, CropImage.Length))
            {
                ms.Write(CropImage, 0, CropImage.Length);
                using (SD.Image CroppedImage = SD.Image.FromStream(ms, true))
                {
                    string SaveTo = UploadPath + "crop_" + ImageName;

                    MaxImageSizePx_ToSaveDB = int.Parse(UserControl1.getValueOfKey("MaxImageSizePx_ToSaveDB"));

                    if (CroppedImage.Width > MaxImageSizePx_ToSaveDB)
                        UserControl1.ResizeImage((System.Drawing.Bitmap)CroppedImage, MaxImageSizePx_ToSaveDB, MaxImageSizePx_ToSaveDB, 90, SaveTo);
                    else
                        CroppedImage.Save(SaveTo, CroppedImage.RawFormat);

                    pnlCrop.Visible = false;
                    pnlCropped.Visible = true;
                    imgCropped.ImageUrl = imgCrop.ImageUrl = "Upload/crop_" + ImageName;
                }
            }
            cmdSave.Visible = true;
            File.Delete(UploadTempFile);            ;
            //DeleteOldUploadedFiles();
        }

        private void DeleteOldUploadedFiles()
        {
            try
            {
                string[] Files = Directory.GetFiles(Server.MapPath("Upload/"));
                foreach (string FileName in Files)
                    if (File.GetCreationTime(FileName) < DateTime.Now.AddHours(-3) || FileName.Contains(Session.SessionID))
                        File.Delete(FileName);
            }
            catch (Exception) { }
        }

        static byte[] Crop(string Img, int Width, int Height, int X, int Y)
        {
            try
            {
                using (SD.Image OriginalImage = SD.Image.FromFile(Img))
                {
                    using (SD.Bitmap bmp = new SD.Bitmap(Width, Height))
                    {
                        bmp.SetResolution(OriginalImage.HorizontalResolution, OriginalImage.VerticalResolution);
                        using (SD.Graphics Graphic = SD.Graphics.FromImage(bmp))
                        {
                            Graphic.SmoothingMode = SmoothingMode.AntiAlias;
                            Graphic.InterpolationMode = InterpolationMode.HighQualityBicubic;
                            Graphic.PixelOffsetMode = PixelOffsetMode.HighQuality;
                            Graphic.DrawImage(OriginalImage, new SD.Rectangle(0, 0, Width, Height), X, Y, Width, Height, SD.GraphicsUnit.Pixel);
                            MemoryStream ms = new MemoryStream();
                            bmp.Save(ms, OriginalImage.RawFormat);
                            return ms.GetBuffer();
                        }
                    }
                }
            }
            catch (Exception Ex)
            {
                throw (Ex);
            }
        }

        protected void DetailsViewPersonal_DataBound(object sender, EventArgs e)
        {
            //if (DetailsViewPersonal.CurrentMode == DetailsViewMode.ReadOnly)
            //{
            //    string SharedKey = string.Format("{0}", DataBinder.Eval(DetailsViewPersonal.DataItem, "ShareKey"));
            //}
        }
        protected void cmdSave_Click(object sender, EventArgs e)
        {
            if (!ckhAgree.Checked)
            {
                UserControl1.ClientMsg("You have to ensure this is your picture.");
                return;
            }

            SaveImageToDB();
            Response.Redirect("MyCV.aspx", true);
        }
        private void SaveImageToDB()
        {
            lblUploadStatus.Text = "";

            try
            {
                //bool test = File.Exists(UploadTempFile);
                lblUploadStatus.Text = Session["FILENAME"].ToString();
                //return;
            }
            catch (Exception ex)
            {
                lblUploadStatus.Text = "E: " + ex.Message;
                return;
            }

            try
            {
                string FileName = Session["FILENAME"].ToString();
                //FileInfo FI = new FileInfo(FileName);
                //string Extension = FileName.Substring(FileName.Trim().Length - 4, 4).ToUpper().Replace(".", "");
                string Extension = (Path.GetExtension(FileName)).Replace(".", "").ToUpper();
                switch (Extension)
                {
                    case "JPEG":
                    case "JPG":
                        byte [] FileContent = ReadFile(UploadCropFile);
                        InsertData(FileContent, true, FileName, Extension);

                        File.Delete(UploadCropFile);
                        DeleteOldUploadedFiles();
                        cmdSave.Visible = false;
                        break;
                    default:
                        lblUploadStatus.Text = "Only JPG files can be uploaded.";
                        //lblUploadStatus.Text = "Only ZIP files can be Uploaded.";
                        //ClientScript.RegisterClientScriptBlock(GetType(), "alertMsg", "<script>alert('File type error.');</script>"); break;
                        break;
                }
            }
            catch (Exception ex)
            {
                lblUploadStatus.Text = ex.Message;
            }

            try
            {
                File.Delete(UploadTempFile);
            }
            catch (Exception) { }
        }

        protected byte[] ReadFile(string filePath)
        {
            byte[] buffer;
            FileStream fileStream = new FileStream(filePath, FileMode.Open, FileAccess.Read);
            try
            {
                int length = (int)fileStream.Length;  // get file length
                buffer = new byte[length];            // create buffer
                int count;                            // actual number of bytes read
                int sum = 0;                          // total number of bytes read

                // read until Read method returns 0 (end of the stream has been reached)
                while ((count = fileStream.Read(buffer, sum, length - sum)) > 0)
                    sum += count;  // sum is a buffer offset for next reading
            }
            finally
            {
                fileStream.Close();
            }
            return buffer;
        }

        private void InsertData(byte[] content, bool IsInsertNew, string FileName, string Extension)
        {
          
            SqlConnection objConn = null;
            SqlCommand objCom = null;
            try
            {
                objConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["WebDBConnectionString"].ConnectionString);
                objCom = new SqlCommand("s_Profile_Pic_Insert", objConn);
                objCom.CommandType = CommandType.StoredProcedure;

                objCom.Parameters.Add("@ID", SqlDbType.Int).Value = Session["USERID"].ToString();
                objCom.Parameters.Add("@Picture", SqlDbType.Image).Value = content;

                if (objConn.State == ConnectionState.Closed)
                    objConn.Open();
                int i = objCom.ExecuteNonQuery();
                objConn.Close();
                Panel1.Visible = false;
                pnlCropped.Visible = false;
                lblUploadStatus.Text = "Your profile picture has been changed.";
                //HttpResponse.RemoveOutputCacheItem(string.Format("/EmpImage.aspx?EMPID={0}", Session["EMPID"]));
                //HttpResponse.RemoveOutputCacheItem(string.Format("/EmpImage.aspx?EMPID={0}&W=200", Session["EMPID"]));

            }
            catch (Exception ex)
            {
                lblUploadStatus.Text = "Error: " + ex.Message;
            }
            RefreshStastics();
        }

        protected void DataListPersonal_ItemDataBound(object sender, DataListItemEventArgs e)
        {
            string SharedKey = string.Format("{0}", DataBinder.Eval(e.Item.DataItem, "ShareKey"));
            if (SharedKey.Trim().Length > 0)
                litPrint.Text = string.Format("<a target='_blank' href='CV.ashx?q={0}'>Print</a>", SharedKey);
        }
    }
}