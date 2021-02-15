namespace Test_CvPrint
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.txtCVID = new System.Windows.Forms.TextBox();
            this.txtKeycode = new System.Windows.Forms.TextBox();
            this.txtEmail = new System.Windows.Forms.TextBox();
            this.btnShowPdf = new System.Windows.Forms.Button();
            this.txtSharedKey = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // txtCVID
            // 
            this.txtCVID.Enabled = false;
            this.txtCVID.Location = new System.Drawing.Point(12, 12);
            this.txtCVID.Name = "txtCVID";
            this.txtCVID.Size = new System.Drawing.Size(100, 20);
            this.txtCVID.TabIndex = 0;
            this.txtCVID.Text = "5";
            // 
            // txtKeycode
            // 
            this.txtKeycode.Enabled = false;
            this.txtKeycode.Location = new System.Drawing.Point(12, 38);
            this.txtKeycode.Name = "txtKeycode";
            this.txtKeycode.Size = new System.Drawing.Size(280, 20);
            this.txtKeycode.TabIndex = 0;
            this.txtKeycode.Text = "5868716E-054E-427C-9E6D-B630AD7C1821";
            // 
            // txtEmail
            // 
            this.txtEmail.Enabled = false;
            this.txtEmail.Location = new System.Drawing.Point(12, 64);
            this.txtEmail.Name = "txtEmail";
            this.txtEmail.Size = new System.Drawing.Size(196, 20);
            this.txtEmail.TabIndex = 0;
            this.txtEmail.Text = "ashik.email@gmail.com";
            // 
            // btnShowPdf
            // 
            this.btnShowPdf.Location = new System.Drawing.Point(12, 116);
            this.btnShowPdf.Name = "btnShowPdf";
            this.btnShowPdf.Size = new System.Drawing.Size(196, 63);
            this.btnShowPdf.TabIndex = 1;
            this.btnShowPdf.Text = "Show PDF";
            this.btnShowPdf.UseVisualStyleBackColor = true;
            this.btnShowPdf.Click += new System.EventHandler(this.btnShowPdf_Click);
            // 
            // txtSharedKey
            // 
            this.txtSharedKey.Location = new System.Drawing.Point(80, 90);
            this.txtSharedKey.Name = "txtSharedKey";
            this.txtSharedKey.Size = new System.Drawing.Size(128, 20);
            this.txtSharedKey.TabIndex = 2;
            this.txtSharedKey.Text = "9Ajvzx85ZF";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 93);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(62, 13);
            this.label1.TabIndex = 3;
            this.label1.Text = "Shared Key";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(355, 233);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtSharedKey);
            this.Controls.Add(this.btnShowPdf);
            this.Controls.Add(this.txtEmail);
            this.Controls.Add(this.txtKeycode);
            this.Controls.Add(this.txtCVID);
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Test CV Print";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox txtCVID;
        private System.Windows.Forms.TextBox txtKeycode;
        private System.Windows.Forms.TextBox txtEmail;
        private System.Windows.Forms.Button btnShowPdf;
        private System.Windows.Forms.TextBox txtSharedKey;
        private System.Windows.Forms.Label label1;
    }
}

