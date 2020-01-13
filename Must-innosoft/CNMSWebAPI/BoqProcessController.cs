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
    public class BoqProcessController : ApiController
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
                        DateTime datet = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);

                        da = new SqlDataAdapter("select distinct MainItemId, MainItem from dbo.BoqEntryDetails  p  where MainItemId!=0 and WorkdonePer!=100 and SubSubItem!=''  and '" + datet + "' < StartDate and Flag='V' and BOQType='P'  and  p.ProjectId=" + myproj, connection);                        
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
        public HttpResponseMessage Get(int id, int val)
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
                        if (val == 1)
                        {
                            dt1 = new DataTable();
                            DateTime datet = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);

                            da = new SqlDataAdapter("select distinct BOQID, SubSubItem from dbo.BoqEntryDetails  p  where MainItemId!=0 and WorkdonePer!=100 and SubSubItem!=''  and '" + datet + "' < StartDate and Flag='V' and BOQType='P' and  and p.ProjectId=" + myproj + " and MainItemId=" + id, connection);
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
                        else if (val == 2)
                        {
                            dt1 = new DataTable();
                            DateTime datet = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);

                            da = new SqlDataAdapter("select distinct MainItemId as SubItemId, SubItem from dbo.BoqEntryDetails p where SubItem!='' and MainItemId!=0 and WorkdonePer!=100 and SubSubItem!=''  and '" + datet + "' < StartDate  and Flag='V' and BOQType='P' and  p.ProjectId=" + myproj + " and MainItemId=" + id, connection);
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
                            dt1 = new DataTable();
                            DateTime datet = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);

                            da = new SqlDataAdapter("select distinct WorkdonePer as CompletedPer from dbo.BoqEntryDetails p where SubItem!='' and MainItemId!=0 and WorkdonePer!=100 and SubSubItem!=''  and '" + datet + "' < StartDate and Flag='V' and  and p.ProjectId=" + myproj + " and BOQId=" + id, connection);
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
                        if (id == 0)
                        {
                            dt1 = new DataTable();
                            DateTime datet = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);
                            //and '" + datet + "' <= EndDate 
                            da = new SqlDataAdapter("select BOQId, SubSubItem,SubItem,MainItem,WorkdonePer as CompletedPer,case when ISNULL((select top 1 RStartDate from dbo.BoqReviseDetails  p where p.Flag='F' and  p.BOQId=bd.BOQId order by ReviseId desc),'')='1900-01-01 00:00:00.000' then 'Workdone' else 'ReviseWorkdone' end as WorkdoneType from dbo.BoqEntryDetails  bd where WorkdonePer!=100 and SubSubItem!=''  and '" + datet + "' >= case when ISNULL((select top 1 RStartDate from dbo.BoqReviseDetails  p where p.Flag='F' and  p.BOQId=bd.BOQId order by ReviseId desc),'')='1900-01-01 00:00:00.000' then bd.StartDate else ISNULL((select top 1 RStartDate from dbo.BoqReviseDetails  p where p.Flag='F' and  p.BOQId=bd.BOQId order by ReviseId desc),'') end and Flag='V' and BOQType='P'  and bd.ProjectId=" + myproj, connection);
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


                            da = new SqlDataAdapter("select BOQId, SubSubItem from dbo.BoqEntryDetails  p  where WorkdonePer!=100 and SubSubItem!=''  and '" + datet + "' < StartDate and BOQType='P' and Flag='V' and  p.ProjectId=" + myproj, connection);
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
                        //else if (id == 2)
                        //{
                        //    dt1 = new DataTable();
                        //    DateTime datet = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);

                        //    da = new SqlDataAdapter("select BOQId,DescriptionName as name,MainItem,SubItem,SubSubItem,Task,WorkdonePer  as CompletedPer ,StartDate as Date from dbo.BoqEntryDetails  p  where  BOQType='P' and p.BOQId=" + id, connection);
                        //    da.Fill(dt1);

                        //    if (dt1.Rows.Count > 0)
                        //    {

                        //        connection.Close();
                        //        return Request.CreateResponse(HttpStatusCode.OK, dt1);

                        //    }
                        //    else
                        //    {
                        //        message = "";
                        //        return Request.CreateResponse(HttpStatusCode.OK);
                        //    }
                        //}
                        else if (id == 5)
                        {
                            var dat = (from c in ent.HolidayMasters
                                       where c.Status == "1" && c.ClientId == clientid
                                       select c
                                       ).ToList().AsEnumerable().Select(a => new
                                       {
                                           
                                           HolidayDate = a.HolidayDate.Value.ToString("dd-MM-yyyy")
                                       });

                            return Request.CreateResponse(HttpStatusCode.OK, dat);
                        }
                        else
                        {
                            dt1 = new DataTable();

                            da = new SqlDataAdapter("select BOQId,Task as SubSubItem,SubItem,MainItem,WorkdonePer as CompletedPer,case when ISNULL((select top 1 RStartDate from dbo.BoqReviseDetails  p where p.Flag='F' and  p.BOQId=bd.BOQId order by ReviseId desc),'')='1900-01-01 00:00:00.000' then 'Workdone' else 'ReviseWorkdone' end as WorkdoneType from dbo.BoqEntryDetails  bd  where WorkdonePer!=100 and RefId=3  and BOQType='V' and bd.ProjectId=" + myproj, connection);
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
                List<BOQTASK> model = null;
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


                    var liat = request.Content.ReadAsStringAsync().Result;
             if (liat !=null)
                {
                    
                    model = JsonConvert.DeserializeObject<List<BOQTASK>>(liat);
                    if (model.Count > 0)
                    {
                        var chk = model.GroupBy(x => x.BOQId).Select(y => y.First()).Distinct().ToList();
                        foreach (var item in chk)
                        {

                            //foreach (var item in model)
                            //{
                                
                                decimal GetPER = (item.WorkdonePer + item.CompletedPer);
                                if (GetPER > 100)
                                {
                                    status = false;
                                    message = "Workdone % ,Greaterthan 100 for SubSubItem - " + item.SubSubItem;
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }
                                        DateTime datet = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);

                                        DataTable dt3 = new DataTable();
                            long myproj = 0;
                            DateTime enddate = new DateTime();
                            SqlDataAdapter da = new SqlDataAdapter("select ProjectId,End_Date from ProjectMaster p  where p.ClientId=" + clientid, connection);
                            da.Fill(dt3);
                            if (dt3.Rows.Count > 0)
                            {
                                myproj = Convert.ToInt64(dt3.Rows[0][0].ToString());
                                enddate = Convert.ToDateTime(dt3.Rows[0][1].ToString());
                                            if (enddate < datet)
                                            {
                                                // status = false;
                                                msg = "Workdone date is greater than project date";
                                             //   return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                            }
                                        }
                            //}
                        }
                    }
                    else
                    {
                        status = false;
                        message = "No BOQ Process Found";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    }

                }








                string ok = "";

               
                        string subsubitm = "";
                        long MainItemId = 0;
                            string TaskId = "";
                            long mypro = 0;
                            var chk1 = model.GroupBy(x => x.BOQId).Select(y => y.First()).Distinct().ToList();
                            foreach (var item in chk1)
                            {
                                //foreach (var item in model)
                                //{

                                SqlDataAdapter da = new SqlDataAdapter("select * from BoqEntryDetails where  BOQId='" + item.BOQId + "'", connection);
                                da.Fill(dt1);
                                if (dt1.Rows.Count > 0)
                                {
                                                              
                                        subsubitm = dt1.Rows[0]["SubSubItem"].ToString();
                                        MainItemId = Convert.ToInt64(dt1.Rows[0]["MainItemId"].ToString());
                                    TaskId = dt1.Rows[0]["TaskId"].ToString();
                                    mypro = Convert.ToInt64(dt1.Rows[0]["ProjectId"].ToString());
                                    if (item.WorkdonePer != 0)
                                    {

                                        SqlDataAdapter adapter = new SqlDataAdapter();
                                        string sql = "insert into BoqDailyProcess values(" + item.WorkdonePer + "," + item.BOQId + ",'" + DateTime.Now + "','" + userid + "','"+ item.WorkdoneType + "')";
                                        adapter.InsertCommand = new SqlCommand(sql, connection);
                                        adapter.InsertCommand.ExecuteNonQuery();
                                        sql = "";
                                        adapter = new SqlDataAdapter();
                                        sql = "Update BoqEntryDetails set Workdonedate='" + DateTime.Now + "', WorkdonePer=WorkdonePer+" + item.WorkdonePer + ",Workdonecost=Convert(decimal,(TotalCost*(WorkdonePer+" + item.WorkdonePer + "))/100,2) where BOQId=" + item.BOQId;

                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                        adapter.UpdateCommand.ExecuteNonQuery();

                                        sql = "Boq_Update";
                                        cmd = new SqlCommand(sql, connection);
                                        cmd.CommandType = CommandType.StoredProcedure;
                                        cmd.Parameters.Add("@MainItemId", SqlDbType.BigInt).Value = MainItemId;
                                        cmd.Parameters.Add("@subitem", SqlDbType.VarChar).Value = subsubitm;
                                        cmd.Parameters.Add("@flag", SqlDbType.VarChar).Value = "VP";
                                        cmd.Parameters.Add("@ProjectId", SqlDbType.BigInt).Value = mypro;
                                        cmd.Parameters.Add("@tasId", SqlDbType.VarChar).Value = TaskId;
                                        cmd.CommandTimeout = 0;
                                        cmd.ExecuteNonQuery();

                                        ok = "a";

                                    }
                                    

                                }
                                else
                                {
                                    status = false;
                                    message = "Data Not Found " + subsubitm;
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }

                            }

                            if (ok != "")
                            {
                                connection.Close();
                                message = "Saved Successfully, "+ msg;
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

        //[HttpPost]
        //[Route("post")]
        //public HttpResponseMessage Post([FromBody] boqtasklist locat)
        //{
        //    try
        //    {

        //        string authHeader = this.httpContext.Request.Headers["Authorization"];
        //        clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
        //        int userid = Convert.ToInt32(Models.JwtAuthentication.GetTokenUserId(authHeader));


        //        if (locat.boqlistpro.Count > 0)
        //        {
        //            foreach (var item in locat.boqlistpro)
        //            {


        //                decimal GetPER = (item.WorkdonePer + item.CompletedPer);
        //                if (GetPER > 100)
        //                {
        //                    status = false;
        //                    message = "Workdone % ,Greaterthan 100 for SubSubItem - " + item.SubSubItem;
        //                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
        //                }


        //            }
        //        }
        //        else
        //        {
        //            status = false;
        //            message = "No BOQ Process Found";
        //            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
        //        }



        //        using (ConstructionDBEntities ent = new ConstructionDBEntities())
        //        {
        //            ent.Configuration.ProxyCreationEnabled = false;
        //            var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
        //            if (dbt != null)
        //            {
        //                using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";Integrated Security = True;"))
        //                {
        //                    DataTable dt1 = new DataTable();
        //                    connection.Open();
        //                    foreach (var item in locat.boqlistpro)
        //                    {
        //                        SqlDataAdapter da = new SqlDataAdapter("select * from BoqEntryDetails where  BOQId='" + item.BOQId + "'", connection);
        //                        da.Fill(dt1);
        //                        if (dt1.Rows.Count > 0)
        //                        {
        //                            if (item.WorkdonePer != 0)
        //                            {

        //                                SqlDataAdapter adapter = new SqlDataAdapter();
        //                                string sql = "insert into BoqDailyProcess values(" + item.WorkdonePer + "," + item.BOQId + ",'" + DateTime.Now + "','" + userid + "')";
        //                                adapter.InsertCommand = new SqlCommand(sql, connection);
        //                                adapter.InsertCommand.ExecuteNonQuery();
        //                                sql = "";
        //                                adapter = new SqlDataAdapter();
        //                                sql = "Update BoqEntryDetails set WorkdonePer=WorkdonePer+" + item.WorkdonePer + " where BOQId=" + item.BOQId;

        //                                adapter.UpdateCommand = new SqlCommand(sql, connection);
        //                                adapter.UpdateCommand.ExecuteNonQuery();



        //                            }

        //                        }
        //                    }
        //                    connection.Close();
        //                    message = "Saved Successfully";
        //                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });

        //                }
        //            }
        //            else
        //            {
        //                message = "DatabaseDetails not found";
        //                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
        //    }
        //}
    }
}
