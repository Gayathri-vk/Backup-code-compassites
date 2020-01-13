using CNMSDataAccess;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace CNMSWebAPI.Models
{
    public class BOQReviseController : ApiController
    {
        HttpContext httpContext = HttpContext.Current;
        string message = "";
        int clientid = 0;
        Boolean status = true;
        [HttpGet]
        public HttpResponseMessage Get(int id)
        {
            string authHeader = this.httpContext.Request.Headers["Authorization"];
            clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
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
                        long myproj = 0;

                        SqlDataAdapter da = new SqlDataAdapter("select ProjectId from ProjectMaster p  where p.ClientId=" + clientid, connection);
                        da.Fill(dt1);
                        if (dt1.Rows.Count > 0)
                        {
                            myproj = Convert.ToInt64(dt1.Rows[0][0].ToString());
                        }
                        connection.Open();
                        if (id == 0)
                        {
                            dt1 = new DataTable();
                            DateTime datet = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);
                            //and '" + datet + "' <= EndDate 
                            da = new SqlDataAdapter("select BOQId, SubSubItem,SubItem,MainItem,WorkdonePer,CONVERT(varchar(15),StartDate,103) as start_date,CONVERT(varchar(15),EndDate,103) as end_date,case when ISNULL((select top 1 RStartDate from dbo.BoqReviseDetails r where r.Flag='P' and r.BOQId=p.BOQId order by ReviseId desc),'')='1900-01-01 00:00:00.000' then StartDate else ISNULL((select top 1 RStartDate from dbo.BoqReviseDetails r where r.Flag='P' and r.BOQId=p.BOQId order by ReviseId desc),'') end as revice_start_date,case when ISNULL((select top 1 REndDate from dbo.BoqReviseDetails r where r.Flag='P' and r.BOQId=p.BOQId order by ReviseId desc),'')='1900-01-01 00:00:00.000' then EndDate else ISNULL((select top 1 REndDate from dbo.BoqReviseDetails r where r.Flag='P' and r.BOQId=p.BOQId order by ReviseId desc),'') end as revice_end_date  from dbo.BoqEntryDetails  p  where WorkdonePer!=100 and SubSubItem!='' and BOQType='P'  and Flag='V'  and p.ProjectId=" + myproj, connection);
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
                        else if (id == 1)
                        {
                            dt1 = new DataTable();
                            DateTime datet = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);
                            //and '" + datet + "' <= EndDate 
                            da = new SqlDataAdapter("select BOQId,Task as SubSubItem,SubItem,MainItem,WorkdonePer,CONVERT(varchar(15),StartDate,103) as start_date,CONVERT(varchar(15),EndDate,103) as end_date,case when ISNULL((select top 1 RStartDate from dbo.BoqReviseDetails r where r.Flag='P' and r.BOQId=p.BOQId order by ReviseId desc),'')='1900-01-01 00:00:00.000' then StartDate else ISNULL((select top 1 RStartDate from dbo.BoqReviseDetails r where r.Flag='P' and r.BOQId=p.BOQId order by ReviseId desc),'') end as revice_start_date,case when ISNULL((select top 1 REndDate from dbo.BoqReviseDetails r where r.Flag='P' and r.BOQId=p.BOQId order by ReviseId desc),'')='1900-01-01 00:00:00.000' then EndDate else ISNULL((select top 1 REndDate from dbo.BoqReviseDetails r where r.Flag='P' and r.BOQId=p.BOQId order by ReviseId desc),'') end as revice_end_date  from dbo.BoqEntryDetails  p  where WorkdonePer!=100  and BOQType='V' and RefId=3 and Flag='P'  and p.ProjectId=" + myproj, connection);
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
                        else if (id == 2)
                        {
                            dt1 = new DataTable();
                            
                            
                            da = new SqlDataAdapter("select ReviseType,RStartDate,REndDate,DescriptionName as name,MainItem as mainItem,SubItem as subitem,SubSubItem as subsubitem,BoqRef as boq,Task as task,StartDate as start_date,EndDate as end_date,TaskId as id from dbo.BoqReviseDetails  p join  dbo.BoqEntryDetails e on p.BOQId=e.BOQId  where p.Flag='F' and e.ProjectId=" + myproj, connection);
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
                        else if (id == 3)
                        {
                            dt1 = new DataTable();


                            da = new SqlDataAdapter("select ReviseType,CONVERT(varchar(15),RStartDate,103) as revice_start_date,CONVERT(varchar(15),REndDate,103) as revice_end_date,p.BOQId, SubSubItem,SubItem,MainItem,WorkdonePer,CONVERT(varchar(15),StartDate,103) as start_date,CONVERT(varchar(15),EndDate,103) as end_date from dbo.BoqReviseDetails  p join  dbo.BoqEntryDetails e on p.BOQId=e.BOQId  where e.WorkdonePer=100 and p.Flag='P' and BOQType='P' and e.ProjectId=" + myproj, connection);
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
                        else if (id == 4)
                        {
                            dt1 = new DataTable();


                            da = new SqlDataAdapter("select ReviseType,CONVERT(varchar(15),RStartDate,103) as revice_start_date,CONVERT(varchar(15),REndDate,103) as revice_end_date,p.BOQId,Task as SubSubItem,SubItem,MainItem,WorkdonePer,CONVERT(varchar(15),StartDate,103) as start_date,CONVERT(varchar(15),EndDate,103) as end_date from dbo.BoqReviseDetails  p join  dbo.BoqEntryDetails e on p.BOQId=e.BOQId  where e.WorkdonePer=100 and p.Flag='P' and BOQType='V' and e.ProjectId=" + myproj, connection);
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
        [HttpPost]
        [Route("post")]
        public HttpResponseMessage Post(HttpRequestMessage request)
        {
            try
            {

                string msg = "";
                string authHeader = this.httpContext.Request.Headers["Authorization"];
                clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
                int userid = Convert.ToInt32(Models.JwtAuthentication.GetTokenUserId(authHeader));
                List<BOQREV> model = null;
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
                            long myproj = 0;
                            var liat1 = request.Content.ReadAsStringAsync().Result;
                            if (liat1 != null)
                            {

                                model = JsonConvert.DeserializeObject<List<BOQREV>>(liat1);
                                if (model.Count > 0)
                                {
                                    foreach (var item in model)
                                    {
                                        if (item.revice_start_date != null && item.revice_end_date != null)
                                        {
                                            DateTime enddate = new DateTime();
                                        DataTable dt3 = new DataTable();
                                        SqlDataAdapter da = new SqlDataAdapter("select ProjectId,End_Date from ProjectMaster p  where p.ClientId=" + clientid, connection);
                                        da.Fill(dt3);
                                            if (dt3.Rows.Count > 0)
                                            {
                                                DateTime datet = DateTime.Parse(item.revice_end_date);
                                                myproj = Convert.ToInt64(dt3.Rows[0][0].ToString());
                                                enddate = Convert.ToDateTime(dt3.Rows[0][1].ToString());
                                                if (enddate < datet)
                                                {
                                                    if(item.ftype=="F")
                                                    { 
                                                    message = "Revise end date is greater than project date";
                                                    status = false;
                                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            string ok = "";
                            string subsubitm = "";
                            var liat = request.Content.ReadAsStringAsync().Result;
                            if (liat != null)
                            {

                                model = JsonConvert.DeserializeObject<List<BOQREV>>(liat);
                                if (model.Count > 0)
                                {
                                    foreach (var item in model)
                                    {
                                        if (model[0].ftype == "F")
                                        {
                                            string  sql = "";
                                            SqlDataAdapter adapter = new SqlDataAdapter();
                                            sql = "Update BoqReviseDetails set FDate='" + DateTime.Now + "',Flag='F' where BOQId=" + item.BOQId;
                                            adapter.UpdateCommand = new SqlCommand(sql, connection);
                                            adapter.UpdateCommand.ExecuteNonQuery();
                                            ok = "f";
                                        }
                                        else
                                        { 
                                        if (item.revice_start_date!=null && item.revice_end_date != null)
                                        { 
                                        string rev = "";
                                        DataTable dtt1 = new DataTable();
                                        SqlDataAdapter da = new SqlDataAdapter("select top 1 ReviseType from BoqReviseDetails where  ProjectId='" + myproj + "' order by ReviseId desc", connection);
                                        da.Fill(dtt1);
                                        if (dtt1.Rows.Count > 0)
                                        {
                                            rev = dtt1.Rows[0]["ReviseType"].ToString();
                                            string[] split = new string[2];
                                            split = rev.Split(' ');
                                            int rcont = Convert.ToInt32(split[1]) + 1;
                                            rev = "REVISE " + rcont;
                                        }
                                        else
                                            rev = "REVISE 1";

                                                DataTable dtt2 = new DataTable();
                                                da = new SqlDataAdapter("select * from BoqReviseDetails where ReviseType='"+ rev + "' and BOQId='" + item.BOQId + "'", connection);
                                                da.Fill(dtt2);
                                                if (dtt2.Rows.Count == 0)
                                                {
                                                    DateTime stateredDate = DateTime.Parse(item.revice_start_date);
                                                    DateTime enedDate = DateTime.Parse(item.revice_end_date);
                                                    SqlDataAdapter adapter = new SqlDataAdapter();
                                                    string sql = "insert into BoqReviseDetails values(" + item.BOQId + ",'" + rev + "','" + stateredDate + "','" + enedDate + "','" + userid + "','" + DateTime.Now + "','P','" + DateTime.Now + "',"+ myproj + ")";
                                                    adapter.InsertCommand = new SqlCommand(sql, connection);
                                                    adapter.InsertCommand.ExecuteNonQuery();
                                                    ok = "a";
                                                }
                                                else
                                                {
                                                    string sql = "";
                                                    SqlDataAdapter adapter = new SqlDataAdapter();
                                                    sql = "Update BoqReviseDetails set RStartDate='" + item.revice_start_date + "',REndDate='" + item.revice_end_date + "' where ReviseType='" + rev+"' and BOQId=" + item.BOQId;
                                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                    adapter.UpdateCommand.ExecuteNonQuery();
                                                    ok = "u";
                                                }
                                        }
                                    }
                                    }

                                    //delete 100 work
                                    if (model[0].ftype == "F")
                                    {
                                        DataTable dt3 = new DataTable();
                                        
                                        string botp = "";
                                        //dt1 = new DataTable();
                                        SqlDataAdapter da = new SqlDataAdapter("select ProjectId from ProjectMaster p  where p.ClientId=" + clientid, connection);
                                        da.Fill(dt3);
                                        if (dt3.Rows.Count > 0)
                                        {
                                            myproj = Convert.ToInt64(dt3.Rows[0][0].ToString());
                                        }
                                        dt3 = new DataTable();
                                        da = new SqlDataAdapter("select BOQType from BoqEntryDetails p  where p.BOQId=" + model[0].BOQId, connection);
                                        da.Fill(dt3);
                                        if (dt3.Rows.Count > 0)
                                        {
                                            botp = dt3.Rows[0][0].ToString();
                                        }
                                        //string sql = "";
                                        //SqlDataAdapter adapter = new SqlDataAdapter();
                                        //sql = "delete from BoqReviseDetails  where  BOQId in (select BOQId from BoqEntryDetails where WorkdonePer=100 and BOQType='"+ botp + "'  and ProjectId=" + myproj+")";
                                        //adapter.DeleteCommand = new SqlCommand(sql, connection);
                                        //adapter.DeleteCommand.ExecuteNonQuery();
                                        

                                        //sql = "";
                                        //adapter = new SqlDataAdapter();
                                        //sql = "delete from BOQLinkDetails  where Flag='R' and BOQId in (select BOQId from BoqEntryDetails where WorkdonePer=100 and BOQType='" + botp + "'  and ProjectId=" + myproj + ")";
                                        //adapter.DeleteCommand = new SqlCommand(sql, connection);
                                        //adapter.DeleteCommand.ExecuteNonQuery();
                                        //ok = "f";



                                    }
                                }
                                else
                                {
                                    status = false;
                                    message = "No BOQ Revise Found";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }

                            }
                            
                            
                            if (ok == "a")
                            {
                                connection.Close();
                                message = "Saved Successfully, " + msg;
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else if (ok == "u")
                            {
                                connection.Close();
                                message = "Updated Successfully, " + msg;
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else if (ok == "f")
                            {
                                connection.Close();
                                message = "Freeze Successfully, " + msg;
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {
                                status = false;
                                message = "Data Not Saved " + subsubitm;
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
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
        }
    }
}
