<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Navigation.ascx.cs" Inherits="UserControls_Navigation" %>
<div class="navbar-default sidebar" role="navigation">
    <div class="sidebar-nav navbar-collapse">
        <ul class="nav" id="side-menu">
            <li>
                <a href="Dashboard.aspx"><i class="fa fa-dashboard fa-fw"></i>Dashboard</a>
            </li>
            <li>
                <a href="~/secure/PurchaseOrder.aspx" runat="server"><i class="fa fa-list-ul fa-fw"></i>Purchase Order</a>
            </li>
            <li>
                <a href="~/secure/TradeMaster.aspx" runat="server"><i class="fa fa-list-ul fa-fw"></i>Trade Master</a>
            </li>
            <li>
                <a href="#"><i class="fa fa-wrench fa-fw"></i>Invoice<span class="fa arrow"></span></a>
                <ul class="nav nav-second-level">
                    <li>
                        <a href="~/secure/InvoiceList.aspx" runat="server"><i class="fa fa-list-ul fa-fw"></i>&nbsp;View Invoice</a>
                    </li>
                    <li>
                        <a href="~/secure/Create-Invoice.aspx" runat="server"><i class="fa fa-file-text fa-fw"></i>&nbsp;Create Invoice</a>
                    </li>
                </ul>
            </li>
            <li>
                <a href="~/secure/LoanAccount.aspx" runat="server"><i class="fa fa-list-ul fa-fw"></i> Loan Accounts</a>
            </li>            
            <li>
                <a href="~/secure/Cashbook.aspx" runat="server"><i class="fa fa-file-text fa-fw"></i> Daily Cash book</a>
            </li>
            <li>
                <a href="#"><i class="fa fa-edit fa-fw"></i> Balance Sheet </a>
            </li>
            <li>
                <a href="#"><i class="fa fa-bar-chart-o fa-fw"></i> Reports</a>
            </li>
            <li>
                <a href="#"><i class="fa fa-wrench fa-fw"></i>Configuration<span class="fa arrow"></span></a>
                <ul class="nav nav-second-level">
                    
                    <li>
                        <a href="#"><i class="fa fa-users fa-fw"></i>Customer<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <li>
                                <a href="~/secure/Customer.aspx" runat="server">&nbsp;&nbsp;&nbsp;&nbsp<i class="fa fa-list-ul"></i> Customer List</a>
                            </li>
                            <li>
                                <a href="~/secure/CustomerSiteAddress.aspx" runat="server">&nbsp;&nbsp;&nbsp;&nbsp<i class="fa fa-file-text fa-fw"></i> Site Address</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="~/secure/Supplier.aspx" runat='server'><i class="fa fa-users fa-fw"></i>Supplier</a>
                    </li>
                    <li>
                        <a href="~/secure/Item.aspx" runat="server"><i class="fa fa-cogs fa-fw"></i>Item configuration</a>
                    </li>
                    <li>
                        <a href="~/secure/Vehicles.aspx" runat="server"><i class="fa fa-truck fa-fw"></i>Vehicle</a>
                    </li>
                    <li>
                        <a href="~/secure/FinancialYear.aspx" runat="server"><i class="fa fa-tachometer fa-fw"></i>Financial year</a>
                    </li>
                    <%-- <li>
                                    <a href="~/secure/Currency.aspx" runat="server">Currency</a>
                                </li>--%>
                    <li>
                        <a href="~/secure/PaymentMode.aspx" runat="server"><i class="fa fa-credit-card fa-fw"></i>Type of Payment</a>
                    </li>
                     <li>
                        <a href="~/secure/TransactionCategory.aspx" runat="server"><i class="fa fa-credit-card fa-fw"></i>Transaction Category</a>
                    </li>
                     <li>
                        <a href="~/secure/TransactionRef.aspx" runat="server"><i class="fa fa-credit-card fa-fw"></i>Transaction Ref.</a>
                    </li>
                </ul>
                <!-- /.nav-second-level -->
            </li>
        </ul>
    </div>
    <!-- /.sidebar-collapse -->
</div>
<!-- /.navbar-static-side -->
