using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class secure_Settings : System.Web.UI.Page
{
    DataClassesDataContext dc = new DataClassesDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            LoadMasterData();
        }
    }

    private void LoadMasterData()
    {
        var result = (from x in dc.bric_Settings
                      select x).ToList();
        if (result.Count > 0)
        {
            txtName.Text=result[0].Name;
            txtAddressLine1.Text= result[0].RegAddressLine1;
            txtAddressLine2.Text = result[0].RegAddressLine2;
            txtContactPerson.Text= result[0].ContactPerson;
            txtPhnNumber.Text= result[0].PhoneNumber;
            txtBranchAddress.Text= result[0].BranchAddressLine1;
            txtTinNumber.Text= result[0].TinCstNo;

            lblName.Text = result[0].Name;
            lblAddress.Text = result[0].RegAddressLine1 + result[0].RegAddressLine2;
            lblContactPerson.Text = result[0].ContactPerson;
            lblPhnNumber.Text = result[0].PhoneNumber;
            lblBranchAddress.Text = result[0].BranchAddressLine1;
            lblTinNumber.Text = result[0].TinCstNo;
            imgLogo.Src= "~/Images/"+ result[0].CompanyLogo;
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        var result = (from x in dc.bric_Settings
                      select x).ToList();
        if (result.Count > 0)
        {
            result[0].Name = txtName.Text;
            result[0].RegAddressLine1 = txtAddressLine1.Text;
            result[0].RegAddressLine2 = txtAddressLine2.Text;
            result[0].ContactPerson =txtContactPerson.Text;
            result[0].PhoneNumber = txtPhnNumber.Text;
            result[0].BranchAddressLine1 = txtBranchAddress.Text;
            result[0].TinCstNo = txtTinNumber.Text;
            if (uploadImage.FileName != null && uploadImage.FileName != "")
            {
                string strFileName = "logo" + System.IO.Path.GetExtension(uploadImage.FileName);
                uploadImage.SaveAs(Server.MapPath("~/Images/" + strFileName));
                result[0].CompanyLogo = strFileName;
            }
            dc.SubmitChanges();
        }
        else
        {
            bric_Setting obj = new bric_Setting();
            obj.Name = txtName.Text;
            obj.RegAddressLine1 = txtAddressLine1.Text;
            obj.RegAddressLine2 = txtAddressLine2.Text;
            obj.ContactPerson = txtContactPerson.Text;
            obj.PhoneNumber = txtPhnNumber.Text;
            obj.BranchAddressLine1 = txtBranchAddress.Text;
            obj.TinCstNo = txtTinNumber.Text;
            dc.bric_Settings.InsertOnSubmit(obj);
            dc.SubmitChanges();
        }
        Response.Redirect("~/Secure/Settings.aspx");
    }
}