using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using CNMSWebAPI.Models;
using CNMSDataAccess;

namespace CNMSWebAPI.Controllers.Reports
{
    public class BOQDetailReportController : ApiController
    {
        HttpContext httpContext = HttpContext.Current;
        string message = "";
        int clientid = 0;
        Boolean status = true;
        public HttpResponseMessage Get()
        {


            message = "";
            return Request.CreateResponse(HttpStatusCode.OK);
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
                            da = new SqlDataAdapter("select bd.DescriptionName as 'text',ISNULL(bd.MainItem,'') as name,ISNULL(bd.SubItem,'') as subitem,ISNULL(bd.SubSubItem,'') as subsubitem,ISNULL(BoqRef,'') as boq,Task as task,ISNULL(Unit,'') as unit,ISNULL(Qty,0) as qty,ISNULL(UnitRate,0) as urate,ISNULL(TotalCost,0) as tcost,WorkdonePer as progress,CASE WHEN  WorkdonePer=100 THEN CONVERT(VARCHAR(20),Workdonedate,101) ELSE '' END AS Workdonedate,ISNULL(Workdonecost,0) as wcost ,StartDate as start_date,EndDate as end_date,Duration as duration from dbo.BoqEntryDetails bd  where BOQType='P' and bd.ProjectId=" + myproj, connection);
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
                            da = new SqlDataAdapter("select bd.DescriptionName as 'text',ISNULL(bd.MainItem,'') as name,ISNULL(bd.SubItem,'') as subitem,ISNULL(bd.SubSubItem,'') as subsubitem,ISNULL(BoqRef,'') as boq,Task as task,ISNULL(Unit,'') as unit,ISNULL(Qty,0) as qty,ISNULL(UnitRate,0) as urate,ISNULL(TotalCost,0) as tcost,WorkdonePer as progress,CASE WHEN  WorkdonePer=100 THEN CONVERT(VARCHAR(20),Workdonedate,101) ELSE '' END AS Workdonedate,ISNULL(Workdonecost,0) as wcost ,StartDate as start_date,EndDate as end_date,Duration as duration from dbo.BoqEntryDetails bd where bd.MainItemId!='' and bd.SubItem='' and BOQType='P' and bd.ProjectId=" + myproj, connection);
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
                            da = new SqlDataAdapter("select bd.DescriptionName as 'text',ISNULL(bd.MainItem,'') as name,ISNULL(bd.SubItem,'') as subitem,ISNULL(bd.SubSubItem,'') as subsubitem,ISNULL(BoqRef,'') as boq,Task as task,ISNULL(Unit,'') as unit,ISNULL(Qty,0) as qty,ISNULL(UnitRate,0) as urate,ISNULL(TotalCost,0) as tcost,WorkdonePer as progress,CASE WHEN  WorkdonePer=100 THEN CONVERT(VARCHAR(20),Workdonedate,101) ELSE '' END AS Workdonedate,ISNULL(Workdonecost,0) as wcost ,StartDate as start_date,EndDate as end_date,Duration as duration from dbo.BoqEntryDetails bd where bd.MainItemId!='' and bd.SubItem!=''  and bd.SubSubItem='' and BOQType='P' and bd.ProjectId=" + myproj, connection);
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
                            da = new SqlDataAdapter("select bd.DescriptionName as 'text',ISNULL(bd.MainItem,'') as name,ISNULL(bd.SubItem,'') as subitem,ISNULL(bd.SubSubItem,'') as subsubitem,ISNULL(BoqRef,'') as boq,Task as task,ISNULL(Unit,'') as unit,ISNULL(Qty,0) as qty,ISNULL(UnitRate,0) as urate,ISNULL(TotalCost,0) as tcost,WorkdonePer as progress,CASE WHEN  WorkdonePer=100 THEN CONVERT(VARCHAR(20),Workdonedate,101) ELSE '' END AS Workdonedate,ISNULL(Workdonecost,0) as wcost ,StartDate as start_date,EndDate as end_date,Duration as duration from dbo.BoqEntryDetails bd where bd.MainItemId!='' and bd.SubItem!=''  and bd.SubSubItem!='' and BOQType='P' and bd.ProjectId=" + myproj, connection);
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
                            da = new SqlDataAdapter("select bd.DescriptionName as 'text',ISNULL(bd.MainItem,'') as name,ISNULL(bd.SubItem,'') as subitem,ISNULL(bd.SubSubItem,'') as subsubitem,ISNULL(BoqRef,'') as boq,Task as task,ISNULL(Unit,'') as unit,ISNULL(Qty,0) as qty,ISNULL(UnitRate,0) as urate,ISNULL(TotalCost,0) as tcost,WorkdonePer as progress,CASE WHEN  WorkdonePer=100 THEN CONVERT(VARCHAR(20),Workdonedate,101) ELSE '' END AS Workdonedate,ISNULL(Workdonecost,0) as wcost ,StartDate as start_date,EndDate as end_date,Duration as duration from dbo.BoqEntryDetails bd  where BOQType='V' and bd.ProjectId=" + myproj, connection);
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
                        else {

                            da = new SqlDataAdapter("CriticalPath_Report", connection);
                            da.SelectCommand.CommandType = CommandType.StoredProcedure;
                            da.SelectCommand.Parameters.AddWithValue("@ProjectId", myproj);                           
                            
                            da.SelectCommand.CommandTimeout = 0;
                            DataTable ds = new DataTable();
                            da.Fill(ds);
                            if (ds.Rows.Count > 0)
                            {

                                connection.Close();
                                return Request.CreateResponse(HttpStatusCode.OK, ds);

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
        }
}
