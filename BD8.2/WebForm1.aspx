<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="bd_8.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <%--<asp:SqlDataSource ID="townDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:studentsConnectionString %>" ProviderName="<%$ ConnectionStrings:studentsConnectionString.ProviderName %>" SelectCommand="SELECT pmib8112.p.town AS towns FROM students.pmib8112.p"></asp:SqlDataSource>--%>
        <asp:Panel ID="panel" runat="server">
            <div>
                <asp:TextBox Style="margin-top: 7px" ID="TextBox1" runat="server" Width="797px"></asp:TextBox>
                Errors
                <asp:Button ID="Button3" runat="server" OnClick="Click1" Text="Запрос1" Width="90px" />
                <asp:Button ID="Button4" runat="server" OnClick="Click2" Text="Запрос2" Width="90px" />
            </div>

            <asp:Panel ID="panel1" runat="server" Visible="false">
                <div>
                    <br />
                    ЗАПРОС 1
            <br />
                    <div>
                        Получить информацию о деталях, которых в настоящий момент не хватает для изготовления заданного количества указанного изделия.
                    </div>
                    Выберите изделие:
            <asp:DropDownList ID="IZD" runat="server" Width="100px" />
                    <br />
                    Выберете количество:
            <asp:TextBox ID="KolTextBox" runat="server" TextMode="Number" />
                    <br />
                    <asp:Button ID="Button1" runat="server" Text="Exe" Width="90px" OnClick="Request1" />
                    <br />
                    <br />
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False">
                        <Columns>
                            <asp:BoundField DataField="n_det" HeaderText="n_post" />
                            <asp:BoundField DataField="name" HeaderText="name" />
                            <asp:BoundField DataField="cvet" HeaderText="reiting" />
                            <asp:BoundField DataField="ves" HeaderText="reiting" />
                            <asp:BoundField DataField="town" HeaderText="town" />
                            <asp:BoundField DataField="lack" HeaderText="lack" />
                        </Columns>
                    </asp:GridView>
                </div>
            </asp:Panel>


            <asp:Panel ID="panel2" runat="server" Visible="false">
                <div>
                    <br />
                    <br />
                    ЗАПРОС 2
            <br />
                    <div>Вставить поставщика с заданными параметрами</div>
                    Количество
                <asp:TextBox ID="TexBoxKol" runat="server" ToolTip="kol" Width="100px" TextMode="Number" />
                    <br />
                    Выберите изделие:
                <asp:DropDownList ID="IZD2" runat="server" Width="100px" />
                    <br />
                    <asp:Button ID="Button2" runat="server" Text="Exe" Width="90px" OnClick="Request2" />
                </div>
                <div>
                    <div style="float: left;">
                        Таблица SPJ до запроса
                <br />
                        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False">
                            <Columns>
                                <asp:BoundField DataField="n_spj" HeaderText="n_spj" />
                                <asp:BoundField DataField="n_post" HeaderText="n_post" />
                                <asp:BoundField DataField="n_det" HeaderText="n_det" />
                                <asp:BoundField DataField="n_izd" HeaderText="n_izd" />
                                <asp:BoundField DataField="kol" HeaderText="kol" />
                                <asp:BoundField DataField="date_post" HeaderText="date_post" />
                                <asp:BoundField DataField="price" HeaderText="price" />
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div style="float: right;">
                        Таблица SPJ после запроса
                <br />
                        <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False">
                            <Columns>
                                <asp:BoundField DataField="n_spj" HeaderText="n_spj" />
                                <asp:BoundField DataField="n_post" HeaderText="n_post" />
                                <asp:BoundField DataField="n_det" HeaderText="n_det" />
                                <asp:BoundField DataField="n_izd" HeaderText="n_izd" />
                                <asp:BoundField DataField="kol" HeaderText="kol" />
                                <asp:BoundField DataField="date_post" HeaderText="date_post" />
                                <asp:BoundField DataField="price" HeaderText="price" />
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </asp:Panel>
        </asp:Panel>
    </form>
    <div runat="server">
        &nbsp;
    </div>
</body>
</html>
