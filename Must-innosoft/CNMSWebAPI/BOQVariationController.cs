using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CNMSDataAccess;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using CNMSWebAPI.Models;

namespace CNMSWebAPI.Controllers.Process
{
    public class BOQVariationController : ApiController
    {
        HttpContext httpContext = HttpContext.Current;
        string message = "";
        int clientid = 0;
        Boolean status = true;
        public HttpResponseMessage Get()
        {
            string authHeader = this.httpContext.Request.Headers["Authorization"];
            clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                //clientid = 1;
                var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                if (dbt != null)
                {

                    using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id=" + dbt.DB_Username + ";Password=" + dbt.DB_Password + ";"))
                    //using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";Integrated Security = True;"))
                    {
                        DataTable dt1 = new DataTable();
                        long myproj = 0;

                        SqlDataAdapter da = new SqlDataAdapter("select ProjectId from ProjectMaster p  where p.ClientId=" + clientid, connection);
                        da.Fill(dt1);
                        if (dt1.Rows.Count > 0)
                        {
                            myproj = Convert.ToInt64(dt1.Rows[0][0].ToString());
                        }
                        connection.Open();

                        dt1 = new DataTable();
                        da = new SqlDataAdapter("select   VID as SubItemId,VariationName as SubItemName from dbo.VariationMaster bd where bd.ProjectId=" + myproj, connection);
                        da.Fill(dt1);

                        if (dt1.Rows.Count > 0)
                        {

                            connection.Close();
                            return Request.CreateResponse(HttpStatusCode.OK, dt1);

                        }
                        else
                        {
                            message = "";
                            return Request.CreateResponse(HttpStatusCode.OK);
                        }
                    }
                }
                else
                {
                    message = "DatabaseDetails not found";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                }
            }


        }
        [HttpGet]
        public HttpResponseMessage Get(int id)
        {
            
            string authHeader = this.httpContext.Request.Headers["Authorization"];
            clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                //clientid = 1;
                var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                if (dbt != null)
                {

                    using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id=" + dbt.DB_Username + ";Password=" + dbt.DB_Password + ";"))
                    //using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";Integrated Security = True;"))
                    {
                        DataTable dt1 = new DataTable();
                        long myproj = 0;
                        //dt1 = new DataTable();
                        SqlDataAdapter da = new SqlDataAdapter("select ProjectId from ProjectMaster p  where p.ClientId=" + clientid, connection);
                        da.Fill(dt1);
                        if (dt1.Rows.Count > 0)
                        {
                            myproj = Convert.ToInt64(dt1.Rows[0][0].ToString());
                        }
                        connection.Open();
                        if (id == 1)
                        {
                            dt1 = new DataTable();
                            da = new SqlDataAdapter("select bd.ProjectId,bd.TaskId as id,RefId,ParentId,bd.DescriptionId as locationId,bd.DescriptionName as 'text',mainItemId,ISNULL(bd.MainItem,'') as name,ISNULL(bd.SubItem,'') as subitem,ISNULL(bd.SubSubItem,'') as subsubitem,ISNULL(BoqRef,'') as boq,Task as task,ISNULL(Unit,'') as unit,ISNULL(Qty,0) as qty,ISNULL(UnitRate,0) as urate,ISNULL(TotalCost,0) as tcost,WorkdonePer as progress,StartDate as start_date,EndDate as end_date,Duration, dep,Priority,ISNULL(BOQRefId,'') as BOQRefId ,CASE WHEN  WorkdonePer=100 THEN CONVERT(VARCHAR(20),Workdonedate,101) ELSE '' END AS Workdonedate,ISNULL(Workdonecost,0) as wcost  from dbo.BoqEntryDetails bd  where BOQType='V' and bd.ProjectId=" + myproj, connection);
                            da.Fill(dt1);
                            List<BoqModel> bo1 = new List<BoqModel>();
                            if (dt1.Rows.Count > 0)
                            {
                                BoqModel b1 = new BoqModel();
                                List<Task> p1 = new List<Task>();
                                List<links> l1 = new List<links>();
                                for (int i = 0; i < dt1.Rows.Count; i++)
                                {
                                    Task n = new Task();
                                    n.ProjectId = dt1.Rows[i]["ProjectId"].ToString();
                                    n.boq = dt1.Rows[i]["boq"].ToString();
                                    n.dep = dt1.Rows[i]["dep"].ToString();
                                    n.Duration = Convert.ToDecimal(dt1.Rows[i]["Duration"].ToString());
                                    n.end_date = Convert.ToDateTime(dt1.Rows[i]["end_date"].ToString()).ToString("yyyy-MM-dd");
                                    n.id = Convert.ToInt64(dt1.Rows[i]["id"].ToString());
                                    n.name = dt1.Rows[i]["name"].ToString();
                                    n.progress = Convert.ToDecimal(dt1.Rows[i]["progress"].ToString());
                                    n.qty = Convert.ToDecimal(dt1.Rows[i]["qty"].ToString());
                                    n.start_date = Convert.ToDateTime(dt1.Rows[i]["start_date"].ToString()).ToString("yyyy-MM-dd");
                                    n.subitem = dt1.Rows[i]["subitem"].ToString();
                                    n.subsubitem = dt1.Rows[i]["subsubitem"].ToString();
                                    n.task = dt1.Rows[i]["task"].ToString();
                                    n.tcost = Convert.ToDecimal(dt1.Rows[i]["tcost"].ToString());
                                    n.text = dt1.Rows[i]["text"].ToString();
                                    n.unit = dt1.Rows[i]["unit"].ToString();
                                    n.urate = Convert.ToDecimal(dt1.Rows[i]["urate"].ToString());
                                    n.mainItemId = Convert.ToInt32(dt1.Rows[i]["mainItemId"].ToString());
                                    n.locationId = Convert.ToInt32(dt1.Rows[i]["locationId"].ToString());
                                    n.step = Convert.ToInt32(dt1.Rows[i]["RefId"].ToString());
                                    n.parent = Convert.ToInt64(dt1.Rows[i]["ParentId"].ToString());
                                    n.boqrefId = dt1.Rows[i]["BOQRefId"].ToString();
                                    n.Workdonedate = dt1.Rows[i]["Workdonedate"].ToString();
                                    n.wcost = Convert.ToDecimal(dt1.Rows[i]["wcost"].ToString());
                                    p1.Add(n);


                                    links l = new links();
                                    l.id = Convert.ToInt64(dt1.Rows[i]["ParentId"].ToString());
                                    l.source = Convert.ToInt64(dt1.Rows[i]["ParentId"].ToString());
                                    l.target = Convert.ToInt64(dt1.Rows[i]["id"].ToString());
                                    l.type = dt1.Rows[i]["RefId"].ToString();

                                    l1.Add(l);
                                }

                                b1.Links = l1;
                                b1.Tasks = p1;
                                bo1.Add(b1);
                                connection.Close();
                                return Request.CreateResponse(HttpStatusCode.OK, p1);
                            }
                            else
                            {
                                message = "";
                                return Request.CreateResponse(HttpStatusCode.OK);
                            }

                        }
                        else
                        {
                            message = "";
                            return Request.CreateResponse(HttpStatusCode.OK);
                        }
                    }
                }
                else
                {
                    message = "DatabaseDetails not found";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                }
            }
        }
        public SqlCommand cmd;
        public HttpResponseMessage Post([FromBody] BoqMaster locat)
        {
            try
            {
                if (locat.id != null)
                {
                    string authHeader = this.httpContext.Request.Headers["Authorization"];
                    clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
                    int userid = Convert.ToInt32(Models.JwtAuthentication.GetTokenUserId(authHeader));

                    using (ConstructionDBEntities ent = new ConstructionDBEntities())
                    {
                        ent.Configuration.ProxyCreationEnabled = false;
                        var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                        if (dbt != null)
                        {

                            using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id=" + dbt.DB_Username + ";Password=" + dbt.DB_Password + ";"))
                            //using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";Integrated Security = True;"))
                            {
                                DataTable dt1 = new DataTable();
                                connection.Open();
                                SqlDataAdapter da = new SqlDataAdapter("select * from BoqEntryDetails where  TaskId='" + locat.id + "'", connection);
                                da.Fill(dt1);

                                DateTime stateredDate = DateTime.Parse(locat.start_date);
                                DateTime enedDate = DateTime.Parse(locat.end_date);
                                TimeSpan t = enedDate - stateredDate;
                                double NrOfDays = t.TotalDays;
                                decimal difday = locat.duration;
                                if (locat.duration == 0)
                                    difday = (int)NrOfDays + 1;

                                decimal cost = locat.qty * locat.urate;

                                if (locat.locationname == "")
                                {
                                    status = false;
                                    message = "Enter Loaction";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }

                                if (locat.step == 0)
                                {

                                    if (locat.mainitem == "")
                                    {
                                        status = false;
                                        message = "Enter Main Item";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                }
                                else if (locat.step > 3)
                                {
                                    if (locat.subsubitem == "")
                                    {
                                        status = false;
                                        message = "Enter Sub Sub Item";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    else if (locat.boq == "")
                                    {
                                        status = false;
                                        message = "Enter Boq Ref.";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    else if (locat.task == "")
                                    {
                                        status = false;
                                        message = "Enter Task";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    else if (locat.qty == 0)
                                    {
                                        status = false;
                                        message = "Enter Qty";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    else if (locat.urate == 0)
                                    {
                                        status = false;
                                        message = "Enter Rate";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    else if (locat.start_date == "")
                                    {
                                        status = false;
                                        message = "Enter Start Date";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    else if (locat.end_date == "")
                                    {
                                        status = false;
                                        message = "Enter End Date";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }

                                }
                                else if (locat.step > 2)
                                {
                                    if (locat.subitem == "")
                                    {
                                        status = false;
                                        message = "Enter Sub Item";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                }

                                if (dt1.Rows.Count > 0)
                                {

                                    SqlDataAdapter adapter = new SqlDataAdapter();
                                    string sql = "Update BoqEntryDetails set DescriptionId='" + locat.location + "',MainItemId='" + locat.mainitem + "',SubItem='" + locat.subitem + "',SubSubItem='" + locat.subsubitem + "',StartDate='" + stateredDate + "',EndDate='" + enedDate + "',BoqRef='" + locat.boq + "',Duration=" + difday + ",Task='" + locat.task + "',Unit='" + locat.unit + "',Qty=" + locat.qty + ",UnitRate=" + locat.urate + ",TotalCost=" + cost + " where TaskId=" + locat.id;
                                    
                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                    adapter.UpdateCommand.ExecuteNonQuery();
                                    connection.Close();
                                    message = "Update Successfully";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }
                                else
                                {
                                    DataTable dt3 = new DataTable();
                                    long myproj = 0;

                                    da = new SqlDataAdapter("select ProjectId from ProjectMaster p  where p.ClientId=" + clientid, connection);
                                    da.Fill(dt3);
                                    if (dt3.Rows.Count > 0)
                                    {
                                        myproj = Convert.ToInt64(dt3.Rows[0][0].ToString());
                                    }

                                    string brefid = "";
                                    da = new SqlDataAdapter("Get_BOQRefid", connection);
                                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                                    da.SelectCommand.Parameters.AddWithValue("@refid", locat.step);
                                    da.SelectCommand.Parameters.AddWithValue("@ParentId", locat.parent);
                                    da.SelectCommand.Parameters.AddWithValue("@boqtype", "V");
                                    da.SelectCommand.Parameters.AddWithValue("@ProjectId", myproj); 
                                    da.SelectCommand.CommandTimeout = 0;
                                    DataTable ds = new DataTable();
                                    da.Fill(ds);
                                    if (ds.Rows.Count > 0)
                                        brefid = ds.Rows[0][0].ToString();

                                    string sub = locat.subitem.Replace("'", "");
                                    string boq = locat.boq.Replace("'", "");
                                    
                                    SqlDataAdapter adapter = new SqlDataAdapter();
                                    string sql = "insert into BoqEntryDetails values(" + myproj + ",'" + locat.location + "','" + locat.locationname + "','" + locat.mainitem + "','" + locat.mainitemname + "','" + sub + "','" + locat.subsubitem + "','" + boq + "','" + locat.task + "','" + locat.unit + "'," + locat.qty + "," + locat.urate + "," + cost + ",0,'" + stateredDate + "','" + enedDate + "'," + difday + ",0,'" + locat.step + "','" + locat.id + "','" + locat.parent + "'," + clientid + "," + userid + ",'" + DateTime.Now + "','V','" + brefid + "',0,'P','" + locat.dep + "')";

                                    adapter.InsertCommand = new SqlCommand(sql, connection);
                                    adapter.InsertCommand.ExecuteNonQuery();

                                    if (locat.step > 2)
                                    {
                                        
                                        sql = "Boq_Update";
                                        cmd = new SqlCommand(sql, connection);
                                        cmd.CommandType = CommandType.StoredProcedure;
                                        cmd.Parameters.Add("@MainItemId", SqlDbType.BigInt).Value = locat.mainitem;
                                        cmd.Parameters.Add("@subitem", SqlDbType.VarChar).Value = locat.subitem;
                                        cmd.Parameters.Add("@flag", SqlDbType.VarChar).Value = "V";
                                        cmd.Parameters.Add("@ProjectId", SqlDbType.BigInt).Value = myproj;
                                        cmd.Parameters.Add("@tasId", SqlDbType.VarChar).Value = locat.id;
                                        cmd.CommandTimeout = 0;
                                        cmd.ExecuteNonQuery();
                                    }

                                    connection.Close();
                                    message = "Saved Successfully";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }
                            }
                        }
                        else
                        {
                            message = "DatabaseDetails not found";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                    }
                }
                else
                {
                    status = false;
                    message = "Invalid Id";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                }

            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
        }

    
}
}

