<%@ Page Title="" Language="C#" MasterPageFile="~/secure/Site.master" AutoEventWireup="true" CodeFile="PrintStatement.aspx.cs" Inherits="secure_PrintStatement" %>

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
                <div class="col-lg-12 mdl">                    
                    <div class="modal-body clearfix">
                        <div id="area" runat="server" style="width:960px;margin:0 auto;">
                                        <style type="text/css">
                                            .font-style{
                                               font-family: Arial, Helvetica, sans-serif;
                                               font-size: 13px;
                                            }
                                            .border td{
                                                border:1px solid #ddd;
                                                padding:5px;
                                            }
                                            .table-bordered {
                                                border: 1px solid #ddd;
                                                font-family: Arial, Helvetica, sans-serif;
                                               font-size: 13px;
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
                                        <table width="100%" cellpadding="0" cellspacing="0" class="font-style">
                                            <tr>
                                                <td style="width:50%">                                                   
                                                    
                                                </td>
                                                <td style="width:50%" align="right" valign="top">
                                                    <h3 style="padding:0px;margin:0px">STATEMENT INVOICE</h3>
                                                </td>
                                            </tr>
                                          
                                            <tr>
                                                <td colspan="2" style="height: 15px">
                                                    ******************************************************* Item Statement ************************************************************
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <table width="100%" cellpadding="0" cellspacing="0" class="table-bordered">
                                                        <tr>
                                                            <td style="width: 7%; padding: 3px 0 3px 5px;"><strong>Sr. No.</strong></td>
                                                            <td style="width: 33%; padding: 3px 0 3px 5px;"><strong>Item Name</strong></td>
                                                            <td style="width: 10%; padding: 3px 0 3px 5px;"><strong>Vehicle No.</strong></td>
                                                            <td style="width: 15%; padding: 3px 0 3px 5px;"><strong>Carrier dimension</strong></td>
                                                            <td style="width: 10%; padding: 3px 0 3px 5px;"><strong>Challan No.</strong></td>
                                                            <td style="width: 10%; padding: 3px 0 3px 5px;"><strong>Date</strong></td>
                                                            <td style="width: 5%; padding: 3px 0 3px 5px;"><strong>Qty</strong></td>
                                                            <td style="width: 10%; padding: 3px 5px 3px 5px;" align="right"><strong>Rate</strong></td>
                                                        </tr>
                                                        <asp:Repeater ID="rptItem" runat="server">
                                                            <ItemTemplate>
                                                                <tr style="border-top: 1px solid #DDDDDD; min-height: 150px">
                                                                    <td style="padding: 3px 0 3px 5px;"><%#Container.ItemIndex + 1 %></td>
                                                                    <td style="padding: 3px 0 3px 5px;"><%#Eval("ItemDescription")%></td>
                                                                    <td style="padding: 3px 0 3px 5px;"><%#Eval("VehicleNo")%></td>
                                                                    <td style="padding: 3px 0 3px 5px;"><%#Eval("Dimension")%></td>
                                                                    <td style="padding: 3px 0 3px 5px;"><%#Eval("ChallanNo")%></td>
                                                                    <td style="padding: 3px 0 3px 5px;"><%#String.Format("{0:dd/MM/yyyy}",Eval("Shipdate"))%></td>
                                                                    <td style="padding: 3px 0 3px 5px;"><%#Eval("Quantity")%></td>
                                                                    <td style="padding: 3px 5px 3px 5px;" align="right"><i class="fa fa-rupee"></i><%#Eval("UnitPrice")%></td>
                                                                </tr>
                                                            </ItemTemplate>
                                                        </asp:Repeater>                                                        
                                                    </table>
                                                </td>
                                            </tr>      
                                            <tr>
                                                <td colspan="2" style="height:100px"></td>
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
            </ContentTemplate>
       </asp:UpdatePanel>
    </div>
</asp:Content>

