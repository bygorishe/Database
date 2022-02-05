using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Odbc;

namespace bd_8
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        public static OdbcConnection connection;
        protected void Page_Load(object sender, EventArgs e)
        {
            connection = new OdbcConnection();
            connection.ConnectionString = "Dsn=PostgseSQL16;data source=postgresql.students.ami.nstu.ru;database=students;user id=pmi-b8506;password=Hojewev7;schema=pmib8506";
            try
            {
                connection.Open();
                TextBox1.Text = "Connectoin success\n";
            }
            catch
            {
                TextBox1.Text = "Connection failed\n";
            }
        }

        private DataTable GetTable()
        {
            DataTable dataTable = new DataTable();
            dataTable.Columns.Add(new DataColumn("n_spj", typeof(string)));
            dataTable.Columns.Add(new DataColumn("n_post", typeof(string)));
            dataTable.Columns.Add(new DataColumn("n_det", typeof(string)));
            dataTable.Columns.Add(new DataColumn("n_izd", typeof(string)));
            dataTable.Columns.Add(new DataColumn("kol", typeof(int)));
            dataTable.Columns.Add(new DataColumn("date_post", typeof(DateTime)));
            dataTable.Columns.Add(new DataColumn("price", typeof(int)));

            string request = "SELECT * from pmib8506.spj order by 4, 1";
            var command = new OdbcCommand(request, connection);
            OdbcTransaction transaction = null;
            try
            {
                transaction = connection.BeginTransaction();
                command.Transaction = transaction;
                OdbcDataReader dataReader = command.ExecuteReader();
                while (dataReader.Read())
                {
                    DataRow dataRow = dataTable.NewRow();
                    dataRow["n_spj"] = dataReader[0].ToString().Trim();
                    dataRow["n_post"] = dataReader[1].ToString().Trim();
                    dataRow["n_det"] = dataReader[2].ToString().Trim();
                    dataRow["n_izd"] = dataReader[3].ToString().Trim();
                    dataRow["kol"] = dataReader[4].ToString().Trim();
                    dataRow["date_post"] = dataReader[5].ToString().Trim();
                    dataRow["price"] = dataReader[6].ToString().Trim();
                    dataTable.Rows.Add(dataRow);
                }
                dataReader.Close();
                transaction.Commit();
            }
            catch (Exception ex)
            {
                TextBox1.Text = ex.Message;
                transaction.Rollback();
            }
            return dataTable;
        }

        protected void Click1(object sender, EventArgs e)
        {
            if (panel1.Visible == true)
                panel1.Visible = false;
            else
            {
                string request = "SELECT n_izd from pmib8506.j";
                OdbcCommand command = new OdbcCommand(request, connection);
                List<string> izdList = new List<string>();
                OdbcTransaction transaction = null;
                try
                {
                    transaction = connection.BeginTransaction();
                    command.Transaction = transaction;
                    OdbcDataReader dataReader = command.ExecuteReader();
                    while (dataReader.Read())
                        izdList.Add(dataReader[0].ToString().Trim());

                    IZD.DataSource = izdList;
                    IZD.DataBind();


                    dataReader.Close();
                    transaction.Commit();
                }
                catch (Exception ex) // Обработка ошибок
                {
                    TextBox1.Text = ex.Message;
                    transaction.Rollback();
                }
                panel1.Visible = true;
            }
        }

        protected void Click2(object sender, EventArgs e)
        {
            if (panel2.Visible == true)
                panel2.Visible = false;
            else
            {
                string request = "SELECT n_izd from pmib8506.j";
                OdbcCommand command = new OdbcCommand(request, connection);
                List<string> izdList = new List<string>();
                OdbcTransaction transaction = null;
                try
                {
                    transaction = connection.BeginTransaction();
                    command.Transaction = transaction;
                    OdbcDataReader dataReader = command.ExecuteReader();
                    while (dataReader.Read())
                        izdList.Add(dataReader[0].ToString().Trim());

                    IZD2.DataSource = izdList;
                    IZD2.DataBind();


                    dataReader.Close();
                    transaction.Commit();
                }
                catch (Exception ex) // Обработка ошибок
                {
                    TextBox1.Text = ex.Message;
                    transaction.Rollback();
                }
                panel2.Visible = true;
            }
        }

        protected void Request1(object sender, EventArgs e)
        {
            TextBox1.Text = null;
            string str_izd = IZD.SelectedValue;
            int kolvo;

            OdbcTransaction transaction = null;
            try
            {
                kolvo = Int32.Parse(KolTextBox.Text);
                if (kolvo <= 0)
                {
                    TextBox1.Text = "Выбрана неверное количество!";
                    return;
                }
            }
            catch
            {
                TextBox1.Text = "Не выбрано количество для формирования запроса №1!";
                return;
            }    
            
            string request = "select p.*, t1.need_det - t2.summa  as lack from pmib8506.p join (select q.n_izd, q.n_det, q.kol * :kol_param as need_det from pmib8506.q where q.n_izd = :izd_param) t1 on t1.n_det = p.n_det join (select spj.n_izd, spj.n_det, sum(spj.kol) as summa from pmib8506.spj group by spj.n_izd, spj.n_det having spj.n_izd = :izd_param) t2 on t2.n_det = p.n_det where t2.summa < t1.need_det ";

            var command = new OdbcCommand(request, connection);

            command.Parameters.AddWithValue("kol_param", kolvo);
            command.Parameters.AddWithValue("izd_param", str_izd);
            try
            {
                transaction = connection.BeginTransaction();
                command.Transaction = transaction;
                DataTable dataTable = new DataTable();
                dataTable.Columns.Add(new DataColumn("n_det", typeof(string)));
                dataTable.Columns.Add(new DataColumn("name", typeof(string)));
                dataTable.Columns.Add(new DataColumn("cvet", typeof(string)));
                dataTable.Columns.Add(new DataColumn("ves", typeof(int)));
                dataTable.Columns.Add(new DataColumn("town", typeof(string)));
                dataTable.Columns.Add(new DataColumn("lack", typeof(int)));

                OdbcDataReader dataReader = command.ExecuteReader();
                while (dataReader.Read())
                {
                    DataRow dataRow = dataTable.NewRow();
                    dataRow["n_det"] = dataReader[0].ToString().Trim();
                    dataRow["name"] = dataReader[1].ToString().Trim();
                    dataRow["cvet"] = dataReader[2].ToString().Trim();
                    dataRow["ves"] = dataReader[3].ToString().Trim();
                    dataRow["town"] = dataReader[4].ToString().Trim();
                    dataRow["lack"] = dataReader[5].ToString().Trim();
                    dataTable.Rows.Add(dataRow);
                }
                dataReader.Close();

                GridView1.DataSource = dataTable;
                GridView1.DataBind();
                transaction.Commit();
            }
            catch (Exception ex)
            {
                TextBox1.Text = ex.Message;
                transaction.Rollback();
            }
        }

        protected void Request2(object sender, EventArgs e)
        {
            string str_izd = IZD2.SelectedValue;
            int kolvo;

            TextBox1.Text = null;
            DataTable dataTableBefore = GetTable();
            ViewState["Current table"] = dataTableBefore;
            GridView2.DataSource = dataTableBefore;
            GridView2.DataBind();          

            try
            {
                kolvo = Int32.Parse(TexBoxKol.Text);
                if (kolvo <= 0)
                {
                    TextBox1.Text = "Количество не может быть меньше или равно нулю!";
                    return;
                }
            }
            catch
            {
                TextBox1.Text = "Нет количесвта!";
                return;
            }

            string request = "update pmib8506.spj set kol = kol + :kolvo_papam where n_izd = :izd_papam and date_post = (select max(date_post) from pmib8506.spj a where a.n_izd = :izd_papam and a.n_det = spj.n_det)";

            var command = new OdbcCommand(request, connection);
            command.Parameters.AddWithValue("kolvo_papam", kolvo);
            command.Parameters.AddWithValue("izd_param", str_izd);

            OdbcTransaction transaction = null;
            try
            {
                transaction = connection.BeginTransaction();
                command.Transaction = transaction;
                OdbcDataReader dataReader = command.ExecuteReader();
                dataReader.Close();
                transaction.Commit();

                DataTable dataTable = GetTable();
                ViewState["New table"] = dataTable;
                GridView3.DataSource = dataTable;
                GridView3.DataBind();
            }
            catch (Exception ex)
            {
                TextBox1.Text = ex.Message;
                transaction.Rollback();
            }
        }
    }
}