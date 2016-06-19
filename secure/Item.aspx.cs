using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class secure_Item : System.Web.UI.Page
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
        var result = (from x in dc.bric_items
                      select new {
                          Id=x.Id,
                          x.ItemCode,
                          x.ItemName,
                          x.MeasureUnit,
                          x.TaxPercent,
                          IsCalculateByDimenson = x.IsCalculateByDimenson == true?"Yes":"No"
                      }).ToList();
        grid.DataSource = result;
        grid.DataBind();
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (btnSubmit.Text == "Update")
        {
            var result = (from x in dc.bric_items
                          where x.Id == Convert.ToInt32(hdnId.Value)
                          select x).ToList();
            if (result.Count > 0)
            {
                result[0].ItemName = txtItem.Text;
                result[0].ItemCode = txtCode.Text;
                result[0].MeasureUnit = txtMeausre.Text;
                result[0].TaxPercent = Convert.ToDecimal(txtTax.Text);
                result[0].IsCalculateByDimenson = chkAutoCal.Checked;
                dc.SubmitChanges();
                hdnId.Value = "0";
                btnSubmit.Text = "Submit";
            }
        }
        else
        {
            bric_item obj = new bric_item();
            obj.ItemName = txtItem.Text;
            obj.ItemCode = txtCode.Text;
            obj.MeasureUnit = txtMeausre.Text;
            obj.TaxPercent = Convert.ToDecimal(txtTax.Text);
            obj.IsCalculateByDimenson = chkAutoCal.Checked;
            dc.bric_items.InsertOnSubmit(obj);
            dc.SubmitChanges();
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('hide');$('body').removeClass('modal-open');</script>", false);
        txtItem.Text = "";
        txtCode.Text = "";
        txtMeausre.Text = "";
        txtTax.Text = "";
        LoadData();
    }
    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            //var result = (from x in dc.bric_items
            //              where x.Id == Convert.ToInt32(e.CommandArgument)
            //              select x).ToList();
            //dc.bric_items.DeleteAllOnSubmit(result);
            //dc.SubmitChanges();
            //LoadData();
        }
        if (e.CommandName == "edit")
        {
            var result = (from x in dc.bric_items
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            if (result.Count > 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('show');</script>", false);
                txtItem.Text = result[0].ItemName;
                txtCode.Text = result[0].ItemCode;
                txtMeausre.Text = result[0].MeasureUnit;
                txtTax.Text = Convert.ToString(result[0].TaxPercent);
                chkAutoCal.Checked = result[0].IsCalculateByDimenson;
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