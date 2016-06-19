using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;

public partial class secure_TradeMaster : System.Web.UI.Page
{
    DataClassesDataContext dc = new DataClassesDataContext();
    List<bric_Trade_Master> lstTradeMst = new List<bric_Trade_Master>();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
           LoadData();
        }        
    }
    private void LoadData()
    {

        var client = (from x in dc.bric_customers
                      select x).ToList();
        ddlClient.DataTextField = "CustomerId";
        ddlClient.DataValueField = "CustomerId";
        ddlClient.DataSource = client;
        ddlClient.DataBind();
        ddlClient.Items.Insert(0, new ListItem("--Select Client--", "0"));

        lstTradeMst = (from x in dc.bric_Trade_Masters
                      orderby x.Id descending
                      select x).ToList();
        grid.DataSource = lstTradeMst;
        grid.DataBind();
    }
    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            var result = (from x in dc.bric_Trade_Masters
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            dc.bric_Trade_Masters.DeleteAllOnSubmit(result);
            dc.SubmitChanges();
            LoadData();
        }
        if (e.CommandName == "edit")
        {
            var result = (from x in dc.bric_Trade_Masters
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            if (result.Count > 0)
            {
                Response.Redirect("~/secure/AddTrade.aspx?ref=" + result[0].Id);
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

    protected void ddlClient_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlClient.SelectedValue != "0")
        {
            var shp = (from x in dc.bric_CustomerSites
                       where x.CustomerNumber == ddlClient.SelectedValue
                       select x).ToList();
            ddlSiteAddress.DataTextField = "SiteAddress";
            ddlSiteAddress.DataValueField = "SiteAddress";
            ddlSiteAddress.DataSource = shp;
            ddlSiteAddress.DataBind();
            ddlSiteAddress.Items.Insert(0, new ListItem("--Select--", "0"));
        }
        else
        {
            ddlSiteAddress.Items.Clear();
            ddlSiteAddress.Items.Insert(0, new ListItem("--Select--", "0"));
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>datepicker();</script>", false);
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetItemName(string Id)
    {
        if (Id == "0")
        {
            return "";
        }
        else
        {
            using (var dc = new DataClassesDataContext())
            {
                var result = (from x in dc.bric_items
                              where x.Id == Convert.ToInt32(Id)
                              select x).ToList();
                return result[0].ItemName;
            }
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<string> GetPurchaseOrder(string strOrderNo)
    {
        using (var dc = new DataClassesDataContext())
        {
            var result = (from x in dc.bric_PurchaseOrders
                          where x.OrderId.Contains(strOrderNo)
                          select x.OrderId).ToList();
            return result.ToList();
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static bric_PurchaseOrder GetPurchaseOrderDetail(string strOrderNo)
    {
        using (var dc = new DataClassesDataContext())
        {
            var result = (from x in dc.bric_PurchaseOrders
                          where x.OrderId == strOrderNo
                          select x).ToList();
            return result[0];
        }
    }

    protected void lbtnCreateInvoice_Click(object sender, EventArgs e)
    {
        bric_InvoiceMst inv = new bric_InvoiceMst();
        inv.InvoiceDate= DateFormater.ConvertToDate(DateTime.Today.ToString("dd/MM/yyyy"));
        inv.InvoiceNo="INV-";
        dc.bric_InvoiceMsts.InsertOnSubmit(inv);
        dc.SubmitChanges();
        inv.InvoiceNo = "INV-" + String.Format("{0:D3}", inv.Id);
        dc.SubmitChanges();

        foreach (GridViewRow dept in grid.Rows)
        {
            //Label respCount = (Label)dept.FindControl("lblResponse").Text
            int rowIndex = dept.RowIndex;
            CheckBox chk = (CheckBox)grid.Rows[rowIndex].FindControl("chkItem");
            if (chk.Checked == true)
            {
                HiddenField lbl = (HiddenField)grid.Rows[rowIndex].FindControl("hdnTradeId");
                bric_InvoiceItem objitem = new bric_InvoiceItem();
                objitem.InvoiceId = inv.Id;
                objitem.TradeId = Convert.ToInt32(lbl.Value);
                dc.bric_InvoiceItems.InsertOnSubmit(objitem);
                dc.SubmitChanges();                
            }
        }
        Response.Redirect("~/Secure/InvoiceList.aspx");
    }

    protected void lbtnSearch_Click(object sender, EventArgs e)
    {
        string strClient = "";
        string strShipDetail = "";
        if (ddlClient.SelectedValue != "0")
        {
            strClient = ddlClient.SelectedValue;
        }
        if (ddlSiteAddress.SelectedValue != "0")
        {
            strShipDetail = ddlSiteAddress.SelectedValue;
        }

        lstTradeMst = (from x in dc.bric_Trade_Masters
                       join p in dc.bric_PurchaseOrders on x.POrderId equals p.OrderId
                       where p.CustomerId.Contains(strClient) && p.ShippingAddress.Contains(strShipDetail)
                       orderby x.Id descending
                       select x).ToList();
        grid.DataSource = lstTradeMst;
        grid.DataBind();


    }

    protected void lbtnDownload_Click(object sender, EventArgs e)
    {
        //using (XLWorkbook wb = new XLWorkbook())
        //{
        //    wb.Worksheets.Add(dt, "Customers");

        //    Response.Clear();
        //    Response.Buffer = true;
        //    Response.Charset = "";
        //    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        //    Response.AddHeader("content-disposition", "attachment;filename=SqlExport.xlsx");
        //    using (MemoryStream MyMemoryStream = new MemoryStream())
        //    {
        //        wb.SaveAs(MyMemoryStream);
        //        MyMemoryStream.WriteTo(Response.OutputStream);
        //        Response.Flush();
        //        Response.End();
        //    }
        //}

        //var data = new[]{
        //                new{ Name="Ram", Email="ram@techbrij.com", Phone="111-222-3333" },
        //                new{ Name="Shyam", Email="shyam@techbrij.com", Phone="159-222-1596" },
        //                new{ Name="Mohan", Email="mohan@techbrij.com", Phone="456-222-4569" },
        //                new{ Name="Sohan", Email="sohan@techbrij.com", Phone="789-456-3333" },
        //                new{ Name="Karan", Email="karan@techbrij.com", Phone="111-222-1234" },
        //                new{ Name="Brij", Email="brij@techbrij.com", Phone="111-222-3333" }
        //       };


        //Response.ClearContent();
        //Response.AddHeader("content-disposition", "attachment;filename=Contact.xls");
        //Response.AddHeader("Content-Type", "application/vnd.ms-excel");
        //using (System.IO.StringWriter sw = new System.IO.StringWriter())
        //{
        //    using (System.Web.UI.HtmlTextWriter htw = new System.Web.UI.HtmlTextWriter(sw))
        //    {
        //        GridView grid1 = new GridView();
        //        grid1.DataSource = data;
        //        grid1.DataBind();
        //        grid1.RenderControl(htw);
        //        Response.Write(sw.ToString());
        //    }
        //}

        //Response.End();
    }

    protected void grid_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grid.PageIndex = e.NewPageIndex;
        LoadData();
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>datepicker();</script>", false);
    }
}