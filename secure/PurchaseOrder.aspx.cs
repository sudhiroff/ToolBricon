using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;

public partial class secure_PurchaseOrder : System.Web.UI.Page
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
        var result = (from x in dc.bric_PurchaseOrders
                      orderby x.Id descending
                      select new
                      {
                          x.Id,
                          x.OrderDescription,
                          x.OrderId,
                          x.PODate,
                          x.ShippingAddress,
                          x.StartDate,
                          x.EndDate,
                          x.CustomerId
                      }).ToList();
        grid.DataSource = result;
        grid.DataBind();
    }
    protected void grid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "view")
        {
            var result = (from x in dc.bric_PO_Items
                          where x.POId == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            grdItem.DataSource = result;
            grdItem.DataBind();
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "none", "<script>$('#myModal').modal('show');</script>", false);
        }

        if (e.CommandName == "delete")
        {
            var result = (from x in dc.bric_PurchaseOrders
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            dc.bric_PurchaseOrders.DeleteAllOnSubmit(result);
            dc.SubmitChanges();
            LoadData();
        }
        if (e.CommandName == "edit")
        {
            var result = (from x in dc.bric_PurchaseOrders
                          where x.Id == Convert.ToInt32(e.CommandArgument)
                          select x).ToList();
            if (result.Count > 0)
            {
                Response.Redirect("~/secure/CreateOrder.aspx?ref=" + result[0].Id);
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
                              where x.ItemCode == Id
                              select x).ToList();
                return result[0].ItemName;
            }
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<bric_PO_Item> GetPOItem(string Id)
    {
        using (var dc = new DataClassesDataContext())
        {
            var result = (from x in dc.bric_PO_Items
                          where x.POId ==Convert.ToInt32(Id)
                          select x).ToList();
            return result.ToList();
        }
    }
}