using System.IO;
using CrystalDecisions.Shared;
using System.Data.SqlClient;
using System.Data;
using System;

namespace CV_Report
{
    public class CV
    {
        public enum ExportType { PDF, WORD, HTML }
        public byte[] getBytes(string SharedKey, string PdfKeywords, ExportType ExportType, string conString)
        {
            CrystalReport1 cr = new CrystalReport1();
            ExportFormatType expType;

            using (DataSet ds = new DataSet())
            {
                SqlConnection con = new SqlConnection(conString);

                if (con.State == System.Data.ConnectionState.Closed) con.Open();


                using (SqlCommand oComm = new SqlCommand())
                {
                    oComm.Connection = con;
                    oComm.CommandText = "s_CV_Print";
                    oComm.CommandType = System.Data.CommandType.StoredProcedure;
                    oComm.Parameters.AddWithValue("@SharedKey", SharedKey);
                    SqlDataAdapter sda = new SqlDataAdapter(oComm);

                    sda.Fill(ds);

                    try
                    {
                        ds.Tables[0].TableName = "s_CV_Print";
                        ds.Tables[1].TableName = "s_Dependents";
                        ds.Tables[2].TableName = "s_Education_Browse";
                        ds.Tables[3].TableName = "s_Professional_Experience";
                        ds.Tables[4].TableName = "s_Training";
                        ds.Tables[5].TableName = "s_LanguageProficiency_browse";
                        ds.Tables[6].TableName = "s_Reference";
                        ds.Tables[7].TableName = "s_Member_Association";
                        ds.Tables[8].TableName = "s_CareerObjective_Browse";
                        ds.Tables[9].TableName = "s_Professional_Browse";
                        ds.Tables[10].TableName = "s_PreferedJobCategory";
                        ds.AcceptChanges();
                    }
                    catch (Exception) { }
                }                

                con.Close();
                cr.SetDataSource(ds);
            }

            //DataSet1.s_CV_PrintDataTable t1 = new DataSet1.s_CV_PrintDataTable();

            //cr.SetParameterValue("@ID", CVID);
            //cr.SetParameterValue("@Email", Email);
            //cr.SetParameterValue("@KeyCode", KeyCode);
            //cr.SetParameterValue("@UserID", CVID);
            

            cr.SummaryInfo.ReportTitle = "Trust Bank CV";
            cr.SummaryInfo.ReportAuthor = "Trust Bank In-House Software Development Team";
            cr.SummaryInfo.ReportSubject = "CV";
            cr.SummaryInfo.KeywordsInReport = PdfKeywords;

            switch(ExportType)
            {
                case ExportType.WORD:
                    expType = ExportFormatType.WordForWindows;
                    break;
                case ExportType.HTML:
                    expType = ExportFormatType.HTML40;
                    break;
                default:
                    expType = ExportFormatType.PortableDocFormat;
                    break;
            }


            byte[] arr = null;

            try
            {

                Stream st = cr.ExportToStream(expType);
                arr = new byte[st.Length];
                st.Read(arr, 0, (int)st.Length);
            }
            catch (Exception) { }
            finally
            {
                cr.Dispose();
            }

            return arr;
        }        
    }
}
