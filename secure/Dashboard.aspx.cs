using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class secure_Dashboard : System.Web.UI.Page
{
    DataClassesDataContext dc = new DataClassesDataContext();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            var inv = (from x in dc.bric_InvoiceMsts
                       select x.Id).Count();
            lblInvoice.InnerHtml = "<div class='huge'>"+inv+" </div><div> Total Invoice!</div>";

            var trade = (from x in dc.bric_Trade_Masters
                       select x.Id).Count();
            lblTrade.InnerHtml = "<div class='huge'>" + trade + " </div><div> Total Trade!</div>";

            var rate = (from x in dc.bric_PurchaseOrders
                         select x.Id).Count();
            lblRate.InnerHtml = "<div class='huge'>" + rate + " </div><div> Total Rate cards!</div>";

            var sup = (from x in dc.bric_suppliers
                        select x.Id).Count();
            lblSup.InnerHtml = "<div class='huge'>" + sup + " </div><div> Total Rate cards!</div>";
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static List<TradeInv> TradeInvChart()
    {
        using (var dc = new DataClassesDataContext())
        {
            List<TradeInv> result = new List<TradeInv>();
            result = (from x in dc.GET_Trade_InvChart()
                      select new TradeInv
                      {
                          Month = x.TradeDate.ToString() + "/" + DateTime.Today.Year.ToString(),
                          Inv = x.InvCount,
                          Trdae = x.TradeCount
                      }).ToList();
            return result;
        }
    }
    public class TradeInv
    {
        public string Month { get; set; }
        public Int32 Trdae { get; set; }
        public Int32 Inv { get; set; }
    }
}