using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace Test_CvPrint
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btnShowPdf_Click(object sender, EventArgs e)
        {
            Cursor = Cursors.WaitCursor;
            CV_Report.CV cv = new CV_Report.CV();
            string conString = (getValue("JobPortalConnectionString"));

            byte[] cvBytes = cv.getBytes(txtSharedKey.Text, "Test", CV_Report.CV.ExportType.PDF, conString);

            if (cvBytes != null)
            {
                string FileName = Path.Combine(Path.GetTempPath(), txtCVID.Text + ".pdf");

                using (FileStream file = new FileStream(FileName, FileMode.Create, FileAccess.Write))
                {
                    file.Write(cvBytes, 0, cvBytes.Length);
                }

                System.Diagnostics.Process.Start(FileName);
            }
            else
            {
                MessageBox.Show("CV Loading Error.", "Pdf Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            
            Cursor = Cursors.Default;
        }

        private string getValue(string Key)
        {
            try
            {
                return string.Format("{0}", ConfigurationSettings.AppSettings[Key]);
            }
            catch (Exception) { return ""; }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            txtCVID.Text = "1";
            txtKeycode.Text = "";
            txtEmail.Text = "sadrul.email@gmail.com";
            txtSharedKey.Text = "545gOTlImA";
        }
    }
}
