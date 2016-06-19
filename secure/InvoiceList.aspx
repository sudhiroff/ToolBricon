<%@ Page Title="" Language="C#" MasterPageFile="~/secure/Site.master" AutoEventWireup="true" CodeFile="InvoiceList.aspx.cs" Inherits="secure_InvoiceList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
        
        });

      function printDiv() {
            var divToPrint = document.getElementById('<%=area.ClientID%>');
            newWin = window.open('PrintOrder.aspx', 'InvoiceDetails', 'width=760,height=400');            
            newWin.document.write(divToPrint.outerHTML);
            newWin.document.close();
            newWin.focus();
            newWin.print();
            newWin.close();
       }
</script>
<div class="row">
        <asp:UpdatePanel ID="uppanel" runat="server">
            <ContentTemplate>
                <div class="col-lg-12">
                    <h3 class="page-header">
                        Invoice List</h3>
                </div>                
                <!-- /.col-lg-12 -->
                <div class="col-lg-12">
                    <asp:GridView ID="grid" runat="server" Width="100%" CssClass="table table-bordered" OnPageIndexChanging="grid_PageIndexChanging"
                        AutoGenerateColumns="false" ShowHeader="true" EmptyDataText="No record found" PageSize="10" AllowPaging="true" PagerStyle-CssClass="pagination-sm pagination"
                        ShowHeaderWhenEmpty="true" OnRowCommand="grid_RowCommand" OnRowDeleting="grid_RowDeleting"
                        OnRowEditing="grid_RowEditing">
                        <Columns>
                            <asp:BoundField HeaderText="Invoice No." DataField="InvoiceNo" />
                            <asp:BoundField HeaderText="Date" DataField="InvoiceDate" />
                            <asp:BoundField HeaderText="Sales Person" DataField="SalesPerson" />
                            <asp:BoundField HeaderText="Client" DataField="Client" />
                            <asp:TemplateField ItemStyle-Width="200px">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtnEdit" Text="Tax Invoice" CssClass="btn btn-xs btn-info" runat="server" CommandName="view" CommandArgument='<%# Eval("Id") %>'></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton1" Text="Item Statement" CssClass="btn btn-xs btn-info" runat="server" CommandName="edit" CommandArgument='<%# Eval("Id") %>'></asp:LinkButton>                                  
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>                
                <div class="col-lg-12 mdl">
                    <!-- Modal -->
                    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
                        data-backdrop="false">
                        <div class="modal-dialog modal-lg" role="document" style="width:860px">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span></button>                                    
                                </div>
                                <div class="modal-body clearfix">
                                    <div id="area" runat="server" style="width:760px;margin:0 auto;">
                                        <style type="text/css">
                                            .border td{
                                                border:1px solid #ddd;
                                                padding:5px;
                                            }
                                            .table-bordered {
                                                border: 1px solid #ddd;
                                            }
                                            .table-bordered > thead > tr > th,
                                            .table-bordered > tbody > tr > th,
                                            .table-bordered > tfoot > tr > th,
                                            .table-bordered > thead > tr > td,
                                            .table-bordered > tbody > tr > td,
                                            .table-bordered > tfoot > tr > td {
                                                border: 1px solid #ddd;
                                            }
                                            .table-bordered > thead > tr > th,
                                            .table-bordered > thead > tr > td {
                                                border-bottom-width: 2px;
                                            }
                                        </style>
                                        <table width="100%" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="width:50%">                                                   
                                                    <img id="imgCompanyLogo" runat="server" alt="" src="~/Images/client.jpg" />
                                                </td>
                                                <td style="width:50%" align="right" valign="top">
                                                    <h3 style="padding:0px;margin:0px">TAX INVOICE</h3>
                                                </td>
                                            </tr>
                                            <tr><td colspan="2" style="height:10px"></td></tr>
                                            <tr>
                                                <td>
                                                    <h4 style="padding:0px;margin:0px"><asp:Label ID="lblCompanyName" runat="server" Text="Company Name"></asp:Label></h4>
                                                    <span id="lblAddresLine1" runat="server">Mayur Vihar phae 1</span><br />
                                                    <span id="lblAddresLine2" runat="server">Delhi 110091</span><br />
                                                    <span id="lblCompanyPhone" runat="server">Phone : 123456788, Fax : 1312312</span>
                                                </td>
                                                <td align="right" valign="bottom">
                                                    Invoice no. : <span id="lblInvNumber" runat="server"></span><br />
                                                    Date. : <span id="lblInvDate" runat="server"></span><br />
                                                    TIN\CST No. : <span id="lblTinCst" runat="server"></span><br />
                                                </td>
                                            </tr>
                                            <tr><td colspan="2" style="height:15px"></td></tr>
                                            <tr>
                                                <td style="border:1px solid #ddd;border-right:none;padding:5px">
                                                    <strong>To:</strong><br />
                                                    <span id="lblToCompanyName" runat="server"></span><br />
                                                    <span id="lblToAddresLine1" runat="server"></span><br />
                                                    Phone : <span id="lblToPhone" runat="server">123456788</span>
                                                </td>
                                                <td style="text-align:right;border:1px solid #ddd;padding:5px">
                                                    <strong>Ship To:</strong><br />
                                                    <span id="lblShipToCompanyName" runat="server"></span><br />
                                                    <span id="lblShipToAddresLine1" runat="server"></span><br />
                                                    Phone : <span id="lblShipToPhone" runat="server"></span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" style="height: 15px"></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <table class="border" width="100%" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td style="width:33%;border-bottom:none">Salesperson</td>
                                                            <td style="width:33%;border-bottom:none">Purchaser’s TIN No.</td>
                                                            <td style="width:34%;border-bottom:none">P.O. Number</td>
                                                        </tr>
                                                        <tr>
                                                            <td> <asp:Label ID="lblSalesPerson" runat="server"></asp:Label></td>
                                                            <td> <asp:Label ID="lblPurTin" runat="server"></asp:Label></td>
                                                            <td> <asp:Label ID="lblPoNumber" runat="server"></asp:Label></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                           <%-- <tr>
                                                <td colspan="2" style="height: 15px"></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <strong>Comment or special instruction:</strong><br />
                                                    <p id="lblCommnetInstruction" runat="server">As with other pseudo-class selectors it is recommended to precede it with a tag name or some other selector otherwise, the universal selector. </p>
                                                </td>
                                            </tr>--%>
                                            <tr>
                                                <td colspan="2" style="height: 15px"></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <table width="100%" cellpadding="0" cellspacing="0" class="table-bordered">
                                                        <tr>
                                                            <td style="width: 10%; padding: 3px 0 3px 5px;"><strong>Sr. No.</strong></td>
                                                            <td style="width: 55%; padding: 3px 0 3px 5px;"><strong>Item Description</strong></td>
                                                            <td style="width: 10%; padding: 3px 0 3px 5px;"><strong>Quntity</strong></td>
                                                            <td style="width: 10%; padding: 3px 0 3px 5px;"><strong>Unit Price</strong></td>
                                                            <td style="width: 15%; padding: 3px 5px 3px 5px;" align="right"><strong>Total Amount</strong></td>
                                                        </tr>
                                                        <asp:Repeater ID="rptItem" runat="server">
                                                            <ItemTemplate>
                                                                <tr style="border-top: 1px solid #DDDDDD; min-height: 150px">
                                                                    <td style="padding: 3px 0 3px 5px;"><%#Container.ItemIndex + 1 %></td>
                                                                    <td style="padding: 3px 0 3px 5px;"><%#Eval("ItemDescription")%></td>
                                                                    <td style="padding: 3px 0 3px 5px;"><%#Eval("Quantity")%></td>
                                                                    <td style="padding: 3px 0 3px 5px;"><i class="fa fa-rupee"></i><%#Eval("UnitPrice")%></td>
                                                                    <td style="padding: 3px 5px 3px 5px;" align="right"><i class="fa fa-rupee"></i><%#Eval("SubTotal")%></td>
                                                                </tr>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                        <tr style="border-top: 1px solid #DDDDDD;">
                                                            <td colspan="4" align="right" style="padding-right: 20px">
                                                                <strong>Subtotal</strong><br />
                                                                <strong>Vat @ <span id="lblVatPercent" runat="server"></span></strong><br />
                                                                <strong>Transport and Handling Charges</strong><br />
                                                                <strong>Total Due</strong>
                                                            </td>
                                                            <td valign="top" class="grid-item" align="right" style="padding-right:5px">
                                                                <i class="fa fa-rupee"></i>
                                                                <asp:Label ID="lblSubTotal" runat="server"></asp:Label><br />
                                                                <i class="fa fa-rupee"></i>
                                                                <asp:Label ID="lblSalesTax" runat="server"></asp:Label><br />
                                                                 <i class="fa fa-rupee"></i><asp:Label ID="lblShippingCharge" runat="server"></asp:Label><br />
                                                                <i class="fa fa-rupee"></i>
                                                                <asp:Label ID="lblTotalDue" runat="server"></asp:Label><br />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" style="height:5px"></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" align="right">
                                                    <strong>In Words :&nbsp;</strong><span id="lblInWord" runat="server"></span>
                                                </td>
                                            </tr>
                                             <tr>
                                                <td colspan="2" style="height:5px;padding:30px 0 20px 0px;">
                                                    <h3 style="color:#8CB2E3">FOR BRICON</h3>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="border: 1px solid #ddd; padding:5px 20px 10px 5px;border-left:none;">
                                                    <span>E.&amp; O.E.</span><br />
                                                    <p>
                                                        Terms<br />
                                                         1. Goods Once sold will not be taken back .<br />
                                                        2 Intrest @18% P.A will be charged if the bill is not paid within 15 days
                                                            from the billing date .<br />3 All the disputes are Subject to Delhi
                                                            Jurisdiction. <br />4. No Claim will be entertained unless brought to
                                                            our notice within 24 hrs on receipt of goods.
                                                    </p>
                                                </td>
                                                <td style="border: 1px solid #ddd; padding: 5px;border-right:none;" align="right" valign="top">
                                                    <span>Cheque/ DDto be drwan in favour of <b>BRICON</b></span><br /><br />
                                                    <p>
                                                        Banks Transfer Detail:<br />
                                                        Syndicate Bank.<br />
                                                        B-2/11,Ashok Vihar ,Phase-2 Delhi 110052<br />
                                                        Bank Account Number : 90601010010601<br />
                                                        RTGS/NEFT IFSC : SYNB0009060<br />
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" align="center">
                                                    <span>"This is a system generated Invoice, does not require any signature"</span><br />
                                                    <span>If you have any questions concerning this invoice, contact Rakesh Yadav Mobile : +91 9821130611</span><br />
                                                    <strong>THANK YOU FOR YOUR BUSINESS!</strong>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <div class="modal-footer clearfix">
                                    <asp:Button ID="btnClose" class="btn btn-default" runat="server" Text="Close" data-dismiss="modal" />
                                    <asp:Button ID="btnPrint" class="btn btn-default" runat="server" Text="Print" OnClientClick="printDiv();" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
       </asp:UpdatePanel>
    </div>
</asp:Content>

