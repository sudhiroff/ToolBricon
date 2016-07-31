using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class secure_LoanAccount : System.Web.UI.Page
{
    DataClassesDataContext dc = new DataClassesDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            LoadData();
        }
    }

    private void LoadData()
    {
        var result = (from x in dc.bric_LoanMasters
                      orderby x.Id descending
                      select x).ToList();
        grid.DataSource = result;
        grid.DataBind();
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (btnSubmit.Text == "Update")
        {
            var result = (from x in dc.bric_LoanMasters
                          where x.Id == Convert.ToInt32(hdnId.Value)
                          select x).ToList();
            if (result.Count > 0)
            {
                result[0].Borrower_LanderName = txtName.Text;
                result[0].LoanType = ddlLoanType.SelectedValue;
                result[0].PrincipalAmt = Convert.ToDecimal(txtPrinAmt.Text);
                result[0].IntrestRate = Convert.ToDecimal(txtIntrest.Text);
                result[0].StartDate = DateFormater.ConvertToDate(txtStartDate.Text);
                result[0].ContactDetail = txtContactDetail.Text;
                //string strAccountNumber = "";
                //if (ddlLoanType.SelectedValue == "Lended")
                //{
                //    strAccountNumber = "BC/LEN/" + txtName.Text.Substring(0, 3).ToUpper() + "/" + String.Format("{0:D3}", result[0].Id);
                //}
                //else
                //{
                //    strAccountNumber = "BC/BOR/" + txtName.Text.Substring(0, 3).ToUpper() + "/" + String.Format("{0:D3}", result[0].Id);
                //}
                //result[0].LoanNumber = strAccountNumber;
                dc.SubmitChanges();
                hdnId.Value = "0";
                btnSubmit.Text = "Submit";
            }
        }
        else
        {
            bric_LoanMaster obj = new bric_LoanMaster();
            obj.Borrower_LanderName = txtName.Text;
            obj.LoanType = ddlLoanType.SelectedValue;
            obj.PrincipalAmt = Convert.ToDecimal(txtPrinAmt.Text);
            obj.IntrestRate = Convert.ToDecimal(txtIntrest.Text);
            obj.StartDate = DateFormater.ConvertToDate(txtStartDate.Text);
            obj.ContactDetail = txtContactDetail.Text;
            obj.EntryDate = DateTime.Today;
            obj.LoanNumber = "BC/";
            dc.bric_LoanMasters.InsertOnSubmit(obj);
            dc.SubmitChanges();
            string strAccountNumber = "";
            if(ddlLoanType.SelectedValue== "Lended")
            {
                strAccountNumber = "BC/LEN/" + txtName.Text.Substring(0, 3).ToUpper() + "/" + String.Format("{0:D3}", obj.Id);
            }
            else
            {
                strAccountNumber = "BC/BOR/" + txtName.Text.Substring(0, 3).ToUpper() + "/" + String.Format("{0:D3}", obj.Id);
            }
            obj.LoanNumber = strAccountNumber;
            dc.SubmitChanges();
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('hide');</script>", false);
        txtName.Text = "";
        txtIntrest.Text = "";
        txtPrinAmt.Text = "";
        txtStartDate.Text = "";
        ddlLoanType.SelectedValue = "Loan";
        LoadData();
    }
    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            var result = (from x in dc.bric_LoanMasters
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            dc.bric_LoanMasters.DeleteAllOnSubmit(result);
            dc.SubmitChanges();
            LoadData();
        }
        if (e.CommandName == "edit")
        {
            var result = (from x in dc.bric_LoanMasters
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            if (result.Count > 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('show');</script>", false);
                txtName.Text = result[0].Borrower_LanderName;
                ddlLoanType.SelectedValue = result[0].LoanType;
                txtPrinAmt.Text = result[0].PrincipalAmt.ToString();
                txtStartDate.Text = DateFormater.GetDate(result[0].StartDate);
                txtIntrest.Text = result[0].IntrestRate.ToString();
                txtContactDetail.Text = result[0].ContactDetail;
                btnSubmit.Text = "Update";
                hdnId.Value = result[0].Id.ToString();
            }
        }
    }
    protected void grid_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

    }
    protected void grid_RowEditing(object sender, GridViewEditEventArgs e)
    {
        e.NewEditIndex = -1;
    }
}