using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.IO;
using ClosedXML.Excel;

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

        var sup = (from x in dc.bric_suppliers
                      select x).ToList();
        ddlSuplierNo.DataTextField = "SupplierId";
        ddlSuplierNo.DataValueField = "SupplierId";
        ddlSuplierNo.DataSource = sup;
        ddlSuplierNo.DataBind();
        ddlSuplierNo.Items.Insert(0, new ListItem("--Select Suplier--", "0"));
        

        lstTradeMst = (from x in dc.bric_Trade_Masters
                       orderby x.Id descending
                      select x).ToList();
        grid.DataSource = lstTradeMst;
        grid.DataBind();
        lblCount.InnerText = lstTradeMst.Count.ToString();
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
        string strSuplier = ddlSuplierNo.ClientID == "0" ? "" : ddlSuplierNo.SelectedValue;       

        if (ddlClient.SelectedValue != "0")
        {
            strClient = ddlClient.SelectedValue;
        }
        if (ddlSiteAddress.SelectedValue != "0")
        {
            strShipDetail = ddlSiteAddress.SelectedValue;
        }
        if (!String.IsNullOrEmpty(txtFromDate.Text))
        {
            DateTime dtShipDateFrom = DateFormater.ConvertToDate(txtFromDate.Text);
            DateTime dtShipDateTo = DateFormater.ConvertToDate(txtToDate.Text);
            lstTradeMst = (from x in dc.bric_Trade_Masters
                           join p in dc.bric_PurchaseOrders on x.POrderId equals p.OrderId
                           where p.CustomerId.Contains(strClient) && p.ShippingAddress.Contains(strShipDetail) && x.SuplierId.Contains(strSuplier)
                           && dtShipDateFrom <= x.Shipdate && dtShipDateTo >= x.Shipdate
                           orderby x.Id descending
                           select x).ToList();
        }
        else {
            lstTradeMst = (from x in dc.bric_Trade_Masters
                           join p in dc.bric_PurchaseOrders on x.POrderId equals p.OrderId
                           where p.CustomerId.Contains(strClient) && p.ShippingAddress.Contains(strShipDetail) && x.SuplierId.Contains(strSuplier)
                           orderby x.Id descending
                           select x).ToList();
        }
        grid.DataSource = lstTradeMst;
        grid.DataBind();
        lblCount.InnerText = lstTradeMst.Count.ToString();

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>datepicker();</script>", false);
    }

    protected void lbtnDownload_Click(object sender, EventArgs e)
    {
        string constr = ConfigurationManager.ConnectionStrings["BriconToolConnectionString"].ConnectionString;
        using (SqlConnection con = new SqlConnection(constr))
        {
            string query = "";
            if (txtdFromDate.Text!="" && txtdToDate.Text!="")
            {               
                query = "SELECT * FROM bric_Trade_Master where Shipdate>='" + DateFormater.ConvertToDate(txtdFromDate.Text).ToString("MM/dd/yyyy")+ "' and Shipdate<='" + DateFormater.ConvertToDate(txtdToDate.Text).ToString("MM/dd/yyyy") + "'";
            }
            else
            {
                query = "SELECT * FROM bric_Trade_Master";
            }
            using (SqlCommand cmd = new SqlCommand(query))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    cmd.Connection = con;
                    sda.SelectCommand = cmd;
                    using (DataTable dt = new DataTable())
                    {
                        sda.Fill(dt);
                        using (XLWorkbook wb = new XLWorkbook())
                        {
                            wb.Worksheets.Add(dt, "Customers");

                            Response.Clear();
                            Response.Buffer = true;
                            Response.Charset = "";
                            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                            Response.AddHeader("content-disposition", "attachment;filename=TradeMaster.xlsx");
                            using (MemoryStream MyMemoryStream = new MemoryStream())
                            {
                                wb.SaveAs(MyMemoryStream);
                                MyMemoryStream.WriteTo(Response.OutputStream);
                                Response.Flush();
                                Response.End();
                            }
                        }
                        txtdFromDate.Text = "";
                        txtdToDate.Text = "";
                    }
                }
            }
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>datepicker();</script>", false);
    }

    protected void grid_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grid.PageIndex = e.NewPageIndex;
        LoadData();
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>datepicker();</script>", false);
    }
}