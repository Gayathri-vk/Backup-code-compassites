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
using Newtonsoft.Json;

namespace CNMSWebAPI.Controllers.Process
{
    public class BOQController : ApiController
    {
        HttpContext httpContext = HttpContext.Current;
        string message = "";
        int clientid = 0;
        Boolean status = true;
        public HttpResponseMessage Get()
        {
            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });

        }
        
        [HttpGet]
        public HttpResponseMessage Get(int id)
        {
            //intstring[] split = new string[2];
            //split = id.Split('/');
            //int a1 = Convert.ToInt32(split[0].ToString());
            //int b1 = Convert.ToInt32(split[1].ToString());
           string authHeader = this.httpContext.Request.Headers["Authorization"];
            clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                //clientid = 1;
                var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                if (dbt != null)
                {
                    using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id="+dbt.DB_Username+ ";Password=" + dbt.DB_Password + ";"))
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
                            da = new SqlDataAdapter("select *,case when p.Type in ('FL') then ISNULL((select b.BlockName from BlockDetails b where b.BlockId=p.RefId and p.Type='FL'),'')+'-'+p.Name when p.Type in ('LR','UR') then ISNULL((select b.BlockName from BlockDetails b where b.BlockId=p.RefId and p.Type in ('LR','UR') ),'')+'-'+p.Name else p.Name end as 'Description' from ProjectDescriptionDetails p  where p.ProjectId=" + myproj, connection);
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
                            da = new SqlDataAdapter("select * from MainItemMaster p  where p.ProjectId=" + myproj, connection);
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
                            //da = new SqlDataAdapter("select  Priority,ISNULL(Predec,'') as Predec,bd.ProjectId,bd.TaskId as id,RefId,ParentId,bd.DescriptionId as locationId,bd.DescriptionName as 'text',mainItemId,ISNULL(bd.MainItem,'') as name,ISNULL(bd.SubItem,'') as subitem,ISNULL(bd.SubSubItem,'') as subsubitem,ISNULL(BoqRef,'') as boq,Task as task,ISNULL(Unit,'') as unit,ISNULL(Qty,0) as qty,ISNULL(UnitRate,0) as urate,ISNULL(TotalCost,0) as tcost,WorkdonePer as progress,StartDate as start_date,EndDate as end_date,Duration,dep,Priority,ISNULL(BOQRefId,'') as BOQRefId,CASE WHEN  WorkdonePer=100 THEN CONVERT(VARCHAR(20),Workdonedate,101) ELSE '' END AS Workdonedate ,ISNULL(Workdonecost,0) as wcost,Flag, case when RefId=0 then 'project' else '' end as ptype,ISNULL((select top 1 RStartDate from dbo.BoqReviseDetails  p where p.Flag='F' and  p.BOQId=bd.BOQId order by ReviseId desc),'') as RStartDate,ISNULL((select top 1 REndDate from dbo.BoqReviseDetails  p  where  p.Flag='F' and p.BOQId=bd.BOQId  order by ReviseId desc),'') as REndDate,ISNULL((select top 1 bb.TaskId from  dbo.BoqEntryDetails bb where bb.RefId=3 and bb.ProjectId=bd.ProjectId group by TaskId having  Max(Duration)=(select top 1 Max(Duration) from  dbo.BoqEntryDetails b where b.RefId=3 and b.ProjectId=bd.ProjectId  group by TaskId)),0) as Criticaltaskid from dbo.BoqEntryDetails bd  where bd.ProjectId=" + myproj, connection);
                            da = new SqlDataAdapter("select Priority, ISNULL(Predec, '') as Predec,bd.ProjectId,bd.TaskId as id,RefId,ParentId,bd.DescriptionId as locationId,bd.DescriptionName as 'text',mainItemId,ISNULL(bd.MainItem, '') as name,ISNULL(bd.SubItem, '') as subitem,ISNULL(bd.SubSubItem, '') as subsubitem,ISNULL(BoqRef, '') as boq,Task as task,ISNULL(Unit, '') as unit,ISNULL(Qty, 0) as qty,ISNULL(UnitRate, 0) as urate,ISNULL(TotalCost, 0) as tcost,WorkdonePer as progress,StartDate as start_date,EndDate as end_date,Duration,dep,Priority,ISNULL(BOQRefId, '') as BOQRefId,CASE WHEN  WorkdonePer = 100 THEN CONVERT(VARCHAR(20),Workdonedate,101) ELSE '' END AS Workdonedate ,ISNULL(Workdonecost, 0) as wcost,Flag, case when RefId = 0 then 'project' else '' end as ptype,ISNULL((select top 1 RStartDate from dbo.BoqReviseDetails p where p.Flag = 'F' and  p.BOQId = bd.BOQId order by ReviseId desc),'') as RStartDate,ISNULL((select top 1 REndDate from dbo.BoqReviseDetails p  where p.Flag = 'F' and p.BOQId = bd.BOQId  order by ReviseId desc),'') as REndDate,ISNULL((select  bb.Criticaltaskid from dbo.CriticalPathDetails bb where bb.BOQId = bd.BOQId and bb.ProjectId = bd.ProjectId),0) as Criticaltaskid from dbo.BoqEntryDetails bd  where bd.ProjectId = " + myproj, connection);
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
                                    if (dt1.Rows[i]["Duration"].ToString() != "")
                                        n.Duration = Convert.ToDecimal(dt1.Rows[i]["Duration"].ToString());
                                    if (dt1.Rows[i]["end_date"].ToString() != "")
                                        n.end_date = Convert.ToDateTime(dt1.Rows[i]["end_date"].ToString()).ToString("yyyy-MM-dd");
                                    n.id = Convert.ToInt64(dt1.Rows[i]["id"].ToString());
                                    n.name = dt1.Rows[i]["name"].ToString();
                                    n.progress = Convert.ToDecimal(dt1.Rows[i]["progress"].ToString());
                                    n.qty = Convert.ToDecimal(dt1.Rows[i]["qty"].ToString());
                                    if (dt1.Rows[i]["start_date"].ToString() != "")
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
                                    n.flag = dt1.Rows[i]["Flag"].ToString();
                                    n.type = dt1.Rows[i]["ptype"].ToString();
                                    n.RStartDate = dt1.Rows[i]["RStartDate"].ToString();
                                    n.REndDate = dt1.Rows[i]["REndDate"].ToString();
                                    if (n.RStartDate == "1/1/1900 12:00:00 AM")
                                        n.RStartDate = "";
                                    else
                                        n.RStartDate = Convert.ToDateTime(n.RStartDate).ToString("yyyy-MM-dd");
                                    if (n.REndDate == "1/1/1900 12:00:00 AM")
                                        n.REndDate = "";
                                    else
                                        n.REndDate = Convert.ToDateTime(n.REndDate).ToString("yyyy-MM-dd");
                                    if (dt1.Rows[i]["Criticaltaskid"].ToString() != "")
                                        n.Criticaltaskid = Convert.ToInt64(dt1.Rows[i]["Criticaltaskid"].ToString());
                                    else
                                        n.Criticaltaskid = 0;
                                    n.Predec = dt1.Rows[i]["Predec"].ToString();
                                    n.Priority = Convert.ToInt64(dt1.Rows[i]["Priority"].ToString());

                                    p1.Add(n);
                                    //IF($O6>0,$M6*$O6,0)

                                    links l = new links();
                                    l.id = Convert.ToInt64(dt1.Rows[i]["ParentId"].ToString());
                                    l.source = Convert.ToInt64(dt1.Rows[i]["ParentId"].ToString());
                                    l.target = Convert.ToInt64(dt1.Rows[i]["id"].ToString());
                                    l.type = dt1.Rows[i]["Priority"].ToString();

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
                        else if (id == 4)
                        {
                            dt1 = new DataTable();
                            da = new SqlDataAdapter("select *,ISNULL((case when LinkType=4 then 3 else LinkType end),0) as LinkType1,ISNULL((select top 1  WorkdonePer from BoqEntryDetails p where p.BOQId=bd.BOQId  and ProjectId="+ myproj + "),0) as Worper,ISNULL((select top 1  Flag from BoqEntryDetails p where p.BOQId=bd.BOQId  and ProjectId=" + myproj + "),0) as BoqFlg from dbo.BOQLinkDetails bd  where  bd.ProjectId=" + myproj, connection);
                            da.Fill(dt1);
                            if (dt1.Rows.Count > 0)
                            {
                                List<links> p1 = new List<links>();

                                for (int i = 0; i < dt1.Rows.Count; i++)
                                {
                                    if (dt1.Rows[i]["BoqFlg"].ToString() == "P")
                                    {

                                        if (dt1.Rows[i]["Flag"].ToString() == "P")
                                        {
                                            links n = new links();
                                            n.id = Convert.ToInt64(dt1.Rows[i]["TaskId"].ToString());

                                            n.source = Convert.ToInt64(dt1.Rows[i]["SourceId"].ToString());
                                            n.target = Convert.ToInt64(dt1.Rows[i]["TargetId"].ToString());
                                            n.type = dt1.Rows[i]["LinkType1"].ToString();
                                            n.color = dt1.Rows[i]["Mcolor"].ToString();
                                            p1.Add(n);
                                        }
                                    }
                                    else
                                    {
                                    

                                        links n = new links();
                                        decimal wrper = Convert.ToDecimal(dt1.Rows[i]["Worper"].ToString());
                                        


                                        if (wrper != 100)
                                        {
                                            if (dt1.Rows[i]["Flag"].ToString() == "R")
                                            {
                                                
                                                    n.id = Convert.ToInt64(dt1.Rows[i]["TaskId"].ToString());

                                                    n.source = Convert.ToInt64(dt1.Rows[i]["SourceId"].ToString());
                                                    n.target = Convert.ToInt64(dt1.Rows[i]["TargetId"].ToString());
                                                    n.type = dt1.Rows[i]["LinkType1"].ToString();
                                                    n.color = dt1.Rows[i]["Mcolor"].ToString();
                                            }

                                         }
                                         else
                                          {
                                                n.id = Convert.ToInt64(dt1.Rows[i]["TaskId"].ToString());
                                                n.source = Convert.ToInt64(dt1.Rows[i]["SourceId"].ToString());
                                                n.target = Convert.ToInt64(dt1.Rows[i]["TargetId"].ToString());
                                                n.type = dt1.Rows[i]["LinkType1"].ToString();
                                                n.color = dt1.Rows[i]["Mcolor"].ToString();
                                            }
                                        p1.Add(n);
                                    }
                                        
                                    
                                    
                                }
                                connection.Close();
                                return Request.CreateResponse(HttpStatusCode.OK, p1);

                            }
                            else
                            {
                                //dt1 = new DataTable();
                                //////da = new SqlDataAdapter("select Priority, case when dep!='' then (select TaskId from dbo.BoqEntryDetails fd where fd.BoqRefId=bd.dep and  fd.ProjectId=" + myproj + ") else ParentId end ParentId,TaskId,BOQId,Task,case when (select b.TaskId from dbo.BoqEntryDetails b where   b.BOQType=bd.BOQType and b.ParentId='0' and  b.ProjectId=" + myproj+ ")=bd.ParentId then 1   when RefId=3 then 2 when bd.ParentId='0' then 1 else   1 end RefId, case when (select b.TaskId from dbo.BoqEntryDetails b where   b.BOQType=bd.BOQType and b.ParentId='0' and  b.ProjectId=" + myproj + ")=bd.ParentId then 'orange'   when RefId=3 then 'green' when bd.ParentId='0' then 'blue' else   'blue'  end as color from dbo.BoqEntryDetails bd  where bd.ProjectId=" + myproj, connection);
                                //da = new SqlDataAdapter("select Priority,TaskId, case when bd.dep !='' then (select b.TaskId from dbo.BoqEntryDetails b where b.ProjectId=" + myproj + " and   bd.dep=b.BOQRefId) when Predec !='' then (select b.TaskId from dbo.BoqEntryDetails b where   b.ProjectId=" + myproj + " and bd.Predec=b.BOQRefId) else TaskId end  sources, case when (select b.TaskId from dbo.BoqEntryDetails b where   b.BOQType=bd.BOQType and b.ParentId='0' and  b.ProjectId=" + myproj + ")=bd.ParentId then 'orange'   when RefId=3 then 'green' when bd.ParentId='0' then 'blue' else   'blue'  end as color from dbo.BoqEntryDetails bd  where bd.ProjectId=" + myproj, connection);
                                //da.Fill(dt1);

                                //if (dt1.Rows.Count > 0)
                                //{
                                //    List<links> p1 = new List<links>();

                                //    for (int i = 0; i < dt1.Rows.Count; i++)
                                //    {
                                //        links n = new links();
                                //        n.id = Convert.ToInt64(dt1.Rows[i]["TaskId"].ToString());
                                //        //n.source = Convert.ToInt64(dt1.Rows[i]["ParentId"].ToString());
                                //        n.source = Convert.ToInt64(dt1.Rows[i]["sources"].ToString());
                                //        n.target = Convert.ToInt64(dt1.Rows[i]["TaskId"].ToString());
                                //        n.type = dt1.Rows[i]["Priority"].ToString();
                                //        // n.color = dt1.Rows[i]["color"].ToString();
                                //        n.color = "orange";
                                //        p1.Add(n);
                                //    }
                                //    connection.Close();
                                //    return Request.CreateResponse(HttpStatusCode.OK, p1);

                                //}
                                //else
                                //{
                                message = "";
                                return Request.CreateResponse(HttpStatusCode.OK);
                                //}
                            }

                        }
                        else if (id == 5)
                        {

                            DataTable dt3 = new DataTable();

                            DateTime enddate = new DateTime();
                            DateTime startdate = new DateTime();
                            da = new SqlDataAdapter("select ProjectId,End_Date,Start_Date from ProjectMaster p  where p.ClientId=" + clientid, connection);
                            da.Fill(dt3);
                            if (dt3.Rows.Count > 0)
                            {

                                enddate = Convert.ToDateTime(dt3.Rows[0][1].ToString());
                                startdate = Convert.ToDateTime(dt3.Rows[0][2].ToString());
                            }

                            dt1 = new DataTable();
                            da = new SqlDataAdapter("select bd.BOQId,ISNULL((select top 1 ReviseType from dbo.BoqReviseDetails p where p.Flag = 'F' and  p.BOQId = bd.BOQId order by ReviseId desc),'') as ReviseType,ISNULL((select top 1 RStartDate from dbo.BoqReviseDetails p where p.Flag = 'F' and  p.BOQId = bd.BOQId order by ReviseId desc),'') as RStartDate,ISNULL((select top 1 REndDate from dbo.BoqReviseDetails p  where p.Flag = 'F' and p.BOQId = bd.BOQId  order by ReviseId desc),'') as REndDate,Priority,bd.ProjectId,bd.TaskId as id,RefId,ParentId,bd.DescriptionId as locationId,bd.DescriptionName as 'text',mainItemId,ISNULL(bd.MainItem,'') as name,ISNULL(bd.SubItem,'') as subitem,ISNULL(bd.SubSubItem,'') as subsubitem,ISNULL(BoqRef,'') as boq,Task as task,ISNULL(Unit,'') as unit,ISNULL(Qty,0) as qty,ISNULL(UnitRate,0) as urate,ISNULL(TotalCost,0) as tcost,WorkdonePer as progress,StartDate as start_date,EndDate as end_date,ISNULL(bd.Duration,0) as Duration,bd.dep,Priority,ISNULL(bd.BOQRefId,'') as BOQRefId,CASE WHEN  WorkdonePer=100 THEN CONVERT(VARCHAR(20),Workdonedate,101) ELSE '' END AS Workdonedate ,ISNULL(Workdonecost,0) as wcost ,bd.Flag,ISNULL((select COUNT(*) from HolidayMaster h where h.HolidayDate between bd.StartDate and bd.EndDate),0) as Holidaycount from dbo.BoqEntryDetails bd   where BOQType='P' and bd.ProjectId=" + myproj, connection);
                            da.Fill(dt1);
                            List<BoqModel> bo1 = new List<BoqModel>();
                            if (dt1.Rows.Count > 0)
                            {
                                ///left join dbo.CriticalPathDetails c on c.BOQId=bd.BOQId and c.Flag='P' c.Criticaltaskid,ISNULL(c.Predec,'') as dep,ISNULL(c.dep,'') as Predec,
                                BoqModel b1 = new BoqModel();
                                List<Task> p1 = new List<Task>();
                                List<links> l1 = new List<links>();
                                for (int i = 0; i < dt1.Rows.Count; i++)
                                {
                                    Task n = new Task();
                                    n.ProjectId = dt1.Rows[i]["ProjectId"].ToString();
                                    n.boq = dt1.Rows[i]["boq"].ToString();
                                    
                                    if (dt1.Rows[i]["Duration"].ToString() != "")
                                        n.Duration = Convert.ToDecimal(dt1.Rows[i]["Duration"].ToString());
                                    if (dt1.Rows[i]["end_date"].ToString() != "")
                                        n.end_date = Convert.ToDateTime(dt1.Rows[i]["end_date"].ToString()).ToString("yyyy-MM-dd");
                                    else
                                        //n.end_date = "1900-01-01";
                                        n.end_date = startdate.AddDays(1).ToString("yyyy-MM-dd");
                                    n.id = Convert.ToInt64(dt1.Rows[i]["id"].ToString());
                                    n.name = dt1.Rows[i]["name"].ToString();
                                    n.progress = Convert.ToDecimal(dt1.Rows[i]["progress"].ToString());
                                    n.qty = Convert.ToDecimal(dt1.Rows[i]["qty"].ToString());
                                    if (dt1.Rows[i]["start_date"].ToString() != "")
                                        n.start_date = Convert.ToDateTime(dt1.Rows[i]["start_date"].ToString()).ToString("yyyy-MM-dd");
                                    else
                                        //n.start_date = "1900-01-01";
                                        n.start_date = startdate.ToString("yyyy-MM-dd");
                                    n.RStartDate = dt1.Rows[i]["RStartDate"].ToString();
                                    n.REndDate = dt1.Rows[i]["REndDate"].ToString();
                                    if (n.RStartDate == "1/1/1900 12:00:00 AM")
                                        n.RStartDate = "";
                                    else
                                        n.RStartDate = Convert.ToDateTime(n.RStartDate).ToString("yyyy-MM-dd");
                                    if (n.REndDate == "1/1/1900 12:00:00 AM")
                                    {
                                        n.REndDate = "";
                                        n.RDuration = 0;
                                    }
                                    else
                                    { 
                                        n.REndDate = Convert.ToDateTime(n.REndDate).ToString("yyyy-MM-dd");
                                        
                                        TimeSpan t = Convert.ToDateTime(n.REndDate) - Convert.ToDateTime(n.RStartDate);
                                        double NrOfDays = t.TotalDays;
                                        n.RDuration = (decimal)NrOfDays;
                                    }

                                    n.ReviseType = dt1.Rows[i]["ReviseType"].ToString();
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
                                    n.flag = dt1.Rows[i]["Flag"].ToString();
                                    n.HDuration= Convert.ToInt64(dt1.Rows[i]["Holidaycount"].ToString());
                                    n.Priority = Convert.ToInt64(dt1.Rows[i]["Priority"].ToString());
                                    
                                    string flg = "";
                                    long bqid = Convert.ToInt64(dt1.Rows[i]["BOQId"].ToString());
                                    if (dt1.Rows[i]["Flag"].ToString() == "P")
                                    {
                                        flg = "P";
                                        DataTable dt12 = new DataTable();
                                        da = new SqlDataAdapter("select c.Criticaltaskid,ISNULL(c.Predec,'') as dep,ISNULL(c.dep,'') as Predec,ISNULL(Slack,0) as Slack  from CriticalPathDetails c where Flag='" + flg + "' and c.BOQId=" + bqid + " and ProjectId=" + myproj, connection);
                                        da.Fill(dt12);
                                        if (dt12.Rows.Count > 0)
                                        {

                                            n.dep = dt12.Rows[0]["dep"].ToString();
                                            n.Predec = dt12.Rows[0]["Predec"].ToString();
                                            if (dt12.Rows[0]["Criticaltaskid"].ToString() != "")
                                                n.Criticaltaskid = Convert.ToInt64(dt12.Rows[0]["Criticaltaskid"].ToString());
                                            else
                                                n.Criticaltaskid = 0;
                                            n.Slack = Convert.ToDecimal(dt12.Rows[0]["Slack"].ToString());
                                        }

                                    }
                                    else
                                    {
                                        



                                        if (n.progress != 100)
                                        {
                                            flg = "R";
                                            DataTable dt12 = new DataTable();
                                            da = new SqlDataAdapter("select top 1 c.Criticaltaskid,ISNULL(c.Predec,'') as dep,ISNULL(c.dep,'') as Predec,ISNULL(Slack,0) as Slack from CriticalPathDetails c where Flag='" + flg + "' and c.BOQId=" + bqid + " and ProjectId=" + myproj + " order by CriticalId desc", connection);
                                            da.Fill(dt12);
                                            if (dt12.Rows.Count > 0)
                                            {

                                                n.dep = dt12.Rows[0]["dep"].ToString();
                                                n.Predec = dt12.Rows[0]["Predec"].ToString();
                                                if (dt12.Rows[0]["Criticaltaskid"].ToString() != "")
                                                    n.Criticaltaskid = Convert.ToInt64(dt12.Rows[0]["Criticaltaskid"].ToString());
                                                else
                                                    n.Criticaltaskid = 0;
                                                n.Slack = Convert.ToDecimal(dt12.Rows[0]["Slack"].ToString());
                                            }

                                            
                                            

                                        }
                                        else
                                        {
                                            flg = "P";
                                            DataTable dt12 = new DataTable();
                                            da = new SqlDataAdapter("select c.Criticaltaskid,ISNULL(c.Predec,'') as dep,ISNULL(c.dep,'') as Predec,ISNULL(Slack,0) as Slack  from CriticalPathDetails c where Flag='" + flg + "' and c.BOQId=" + bqid + " and ProjectId=" + myproj, connection);
                                            da.Fill(dt12);
                                            if (dt12.Rows.Count > 0)
                                            {

                                                n.dep = dt12.Rows[0]["dep"].ToString();
                                                n.Predec = dt12.Rows[0]["Predec"].ToString();
                                                if (dt12.Rows[0]["Criticaltaskid"].ToString() != "")
                                                    n.Criticaltaskid = Convert.ToInt64(dt12.Rows[0]["Criticaltaskid"].ToString());
                                                else
                                                    n.Criticaltaskid = 0;
                                                n.Slack = Convert.ToDecimal(dt12.Rows[0]["Slack"].ToString());
                                            }
                                        }
                                    }
                                    
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
                        else if (id == 6)
                        {

                            DataTable dt3 = new DataTable();

                            DateTime enddate = new DateTime();
                            DateTime startdate = new DateTime();
                            da = new SqlDataAdapter("select ProjectId,End_Date,Start_Date from ProjectMaster p  where p.ClientId=" + clientid, connection);
                            da.Fill(dt3);
                            if (dt3.Rows.Count > 0)
                            {

                                enddate = Convert.ToDateTime(dt3.Rows[0][1].ToString());
                                startdate = Convert.ToDateTime(dt3.Rows[0][2].ToString());
                            }

                            dt1 = new DataTable();
                            da = new SqlDataAdapter("select  bd.BOQId ,ISNULL((select top 1 RStartDate from dbo.BoqReviseDetails p where  p.BOQId = bd.BOQId order by ReviseId desc),'') as RStartDate,ISNULL((select top 1 REndDate from dbo.BoqReviseDetails p  where p.BOQId = bd.BOQId  order by ReviseId desc),'') as REndDate,c.Criticaltaskid,Priority,ISNULL(c.Predec,'') as dep,ISNULL(c.dep,'') as Predec,bd.ProjectId,bd.TaskId as id,RefId,ParentId,bd.DescriptionId as locationId,bd.DescriptionName as 'text',mainItemId,ISNULL(bd.MainItem,'') as name,ISNULL(bd.SubItem,'') as subitem,ISNULL(bd.SubSubItem,'') as subsubitem,ISNULL(BoqRef,'') as boq,Task as task,ISNULL(Unit,'') as unit,ISNULL(Qty,0) as qty,ISNULL(UnitRate,0) as urate,ISNULL(TotalCost,0) as tcost,WorkdonePer as progress,StartDate as start_date,EndDate as end_date,ISNULL(bd.Duration,0) as Duration,bd.dep,Priority,ISNULL(bd.BOQRefId,'') as BOQRefId,CASE WHEN  WorkdonePer=100 THEN CONVERT(VARCHAR(20),Workdonedate,101) ELSE '' END AS Workdonedate ,ISNULL(Workdonecost,0) as wcost ,bd.Flag,ISNULL(Slack,0) as Slack,ISNULL((select COUNT(*) from HolidayMaster h where h.HolidayDate between bd.StartDate and bd.EndDate),0) as Holidaycount  from dbo.BoqEntryDetails bd left join dbo.CriticalPathDetails c on c.BOQId=bd.BOQId and c.Flag='R'  where   BOQType='P'  and bd.Flag='V' and bd.ProjectId=" + myproj, connection);
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
                                    if (dt1.Rows[i]["Duration"].ToString() != "")
                                        n.RDuration = Convert.ToDecimal(dt1.Rows[i]["Duration"].ToString());

                                    if (dt1.Rows[i]["end_date"].ToString() != "")
                                        n.REndDate = Convert.ToDateTime(dt1.Rows[i]["end_date"].ToString()).ToString("yyyy-MM-dd");
                                    else
                                        n.REndDate = startdate.AddDays(1).ToString("yyyy-MM-dd");

                                    if (dt1.Rows[i]["start_date"].ToString() != "")
                                        n.RStartDate = Convert.ToDateTime(dt1.Rows[i]["start_date"].ToString()).ToString("yyyy-MM-dd");
                                    else
                                        n.RStartDate = startdate.ToString("yyyy-MM-dd");

                                    n.id = Convert.ToInt64(dt1.Rows[i]["id"].ToString());
                                    n.name = dt1.Rows[i]["name"].ToString();
                                    n.progress = Convert.ToDecimal(dt1.Rows[i]["progress"].ToString());
                                    n.qty = Convert.ToDecimal(dt1.Rows[i]["qty"].ToString());

                                   

                                    long BOQId = Convert.ToInt64(dt1.Rows[i]["BOQId"].ToString());
                                    DataTable dtt1 = new DataTable();
                                    da = new SqlDataAdapter("select top 1 ReviseType from BoqReviseDetails where Flag='F' and BOQId='" + BOQId + "' order by ReviseId desc", connection);
                                    da.Fill(dtt1);
                                    if (dtt1.Rows.Count > 0)
                                    {
                                        n.ReviseType = dtt1.Rows[0][0].ToString();
                                        n.start_date = dt1.Rows[i]["RStartDate"].ToString();
                                        n.end_date = dt1.Rows[i]["REndDate"].ToString();

                                        if (n.start_date == "1/1/1900 12:00:00 AM")
                                            n.start_date = n.RStartDate;
                                        else
                                            n.start_date = Convert.ToDateTime(n.start_date).ToString("yyyy-MM-dd");
                                        if (n.end_date == "1/1/1900 12:00:00 AM")
                                        {

                                            n.end_date = n.REndDate;
                                            n.Duration = 0;
                                        }
                                        else
                                        {
                                            n.end_date = Convert.ToDateTime(n.end_date).ToString("yyyy-MM-dd");
                                            TimeSpan t = Convert.ToDateTime(n.end_date) - Convert.ToDateTime(n.start_date);
                                            double NrOfDays = t.TotalDays;
                                            n.Duration = (decimal)NrOfDays;
                                        }
                                    }
                                    else
                                    {
                                        n.start_date = n.RStartDate;
                                        n.end_date = n.REndDate;
                                        n.Duration = n.RDuration;
                                        n.ReviseType = "";
                                    }
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
                                    n.flag = dt1.Rows[i]["Flag"].ToString();
                                    n.Predec = dt1.Rows[i]["Predec"].ToString();
                                    n.Priority = Convert.ToInt64(dt1.Rows[i]["Priority"].ToString());
                                    n.Slack = Convert.ToDecimal(dt1.Rows[i]["Slack"].ToString());
                                    if (dt1.Rows[i]["Criticaltaskid"].ToString() != "")
                                        n.Criticaltaskid = Convert.ToInt64(dt1.Rows[i]["Criticaltaskid"].ToString());
                                    else
                                        n.Criticaltaskid = 0;
                                    n.HDuration = Convert.ToInt64(dt1.Rows[i]["Holidaycount"].ToString());
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
                        else if (id == 7)
                        {
                            dt1 = new DataTable();
                            da = new SqlDataAdapter("select *,ISNULL((case when LinkType=4 then 3 else LinkType end),0) as LinkType1 from dbo.BOQLinkDetails bd  where  Flag='R' and bd.ProjectId=" + myproj, connection);
                            da.Fill(dt1);
                            if (dt1.Rows.Count > 0)
                            {
                                List<links> p1 = new List<links>();

                                for (int i = 0; i < dt1.Rows.Count; i++)
                                {
                                    //long BOQId = Convert.ToInt64(dt1.Rows[i]["BOQId"].ToString());
                                    //DataTable dtt1 = new DataTable();
                                    //da = new SqlDataAdapter("select top 1 ReviseType from BoqReviseDetails where  BOQId='" + BOQId + "' order by ReviseId desc", connection);
                                    //da.Fill(dtt1);
                                    //if (dtt1.Rows.Count > 0)
                                    //{
                                        links n = new links();
                                        n.id = Convert.ToInt64(dt1.Rows[i]["TaskId"].ToString());

                                        n.source = Convert.ToInt64(dt1.Rows[i]["SourceId"].ToString());
                                        n.target = Convert.ToInt64(dt1.Rows[i]["TargetId"].ToString());
                                        n.type = dt1.Rows[i]["LinkType1"].ToString();
                                        n.color = dt1.Rows[i]["Mcolor"].ToString();
                                        p1.Add(n);
                                    //}

                                  
                                }
                                connection.Close();
                                return Request.CreateResponse(HttpStatusCode.OK, p1);

                            }
                            else
                            {
                                message = "";
                                return Request.CreateResponse(HttpStatusCode.OK);
                            }
                        }
                        else if (id == 8)
                        {

                            DataTable dt3 = new DataTable();

                            DateTime enddate = new DateTime();
                            DateTime startdate = new DateTime();
                            da = new SqlDataAdapter("select ProjectId,End_Date,Start_Date from ProjectMaster p  where p.ClientId=" + clientid, connection);
                            da.Fill(dt3);
                            if (dt3.Rows.Count > 0)
                            {

                                enddate = Convert.ToDateTime(dt3.Rows[0][1].ToString());
                                startdate = Convert.ToDateTime(dt3.Rows[0][2].ToString());
                            }

                            dt1 = new DataTable();
                            da = new SqlDataAdapter("select c.Criticaltaskid,ISNULL(c.Predec,'') as dep,ISNULL(c.dep,'') as Predec,ISNULL(Slack,0) as Slack ,bd.BOQId,ISNULL((select top 1 RStartDate from dbo.BoqReviseDetails p where p.Flag = 'F' and  p.BOQId = bd.BOQId order by ReviseId desc),'') as RStartDate,ISNULL((select top 1 REndDate from dbo.BoqReviseDetails p  where p.Flag = 'F' and p.BOQId = bd.BOQId  order by ReviseId desc),'') as REndDate,Priority,bd.ProjectId,bd.TaskId as id,RefId,ParentId,bd.DescriptionId as locationId,bd.DescriptionName as 'text',mainItemId,ISNULL(bd.MainItem,'') as name,ISNULL(bd.SubItem,'') as subitem,ISNULL(bd.SubSubItem,'') as subsubitem,ISNULL(BoqRef,'') as boq,Task as task,ISNULL(Unit,'') as unit,ISNULL(Qty,0) as qty,ISNULL(UnitRate,0) as urate,ISNULL(TotalCost,0) as tcost,WorkdonePer as progress,StartDate as start_date,EndDate as end_date,ISNULL(bd.Duration,0) as Duration,bd.dep,Priority,ISNULL(bd.BOQRefId,'') as BOQRefId,CASE WHEN  WorkdonePer=100 THEN CONVERT(VARCHAR(20),Workdonedate,101) ELSE '' END AS Workdonedate ,ISNULL(Workdonecost,0) as wcost ,bd.Flag,ISNULL((select COUNT(*) from HolidayMaster h where h.HolidayDate between bd.StartDate and bd.EndDate),0) as Holidaycount  from dbo.BoqEntryDetails bd  left join CriticalPathDetails c on c.BOQId=bd.BOQId and c.Flag='P' where   BOQType='P' and bd.ProjectId=" + myproj, connection);
                            da.Fill(dt1);
                            List<BoqModel> bo1 = new List<BoqModel>();
                            if (dt1.Rows.Count > 0)
                            {
                                ///left join dbo.CriticalPathDetails c on c.BOQId=bd.BOQId and c.Flag='P' c.Criticaltaskid,ISNULL(c.Predec,'') as dep,ISNULL(c.dep,'') as Predec,
                                BoqModel b1 = new BoqModel();
                                List<Task> p1 = new List<Task>();
                                List<links> l1 = new List<links>();
                                for (int i = 0; i < dt1.Rows.Count; i++)
                                {
                                    Task n = new Task();
                                    n.ProjectId = dt1.Rows[i]["ProjectId"].ToString();
                                    n.boq = dt1.Rows[i]["boq"].ToString();

                                    if (dt1.Rows[i]["Duration"].ToString() != "")
                                        n.Duration = Convert.ToDecimal(dt1.Rows[i]["Duration"].ToString());
                                    if (dt1.Rows[i]["end_date"].ToString() != "")
                                        n.end_date = Convert.ToDateTime(dt1.Rows[i]["end_date"].ToString()).ToString("yyyy-MM-dd");
                                    else
                                        //n.end_date = "1900-01-01";
                                        n.end_date = startdate.AddDays(1).ToString("yyyy-MM-dd");
                                    n.id = Convert.ToInt64(dt1.Rows[i]["id"].ToString());
                                    n.name = dt1.Rows[i]["name"].ToString();
                                    n.progress = Convert.ToDecimal(dt1.Rows[i]["progress"].ToString());
                                    n.qty = Convert.ToDecimal(dt1.Rows[i]["qty"].ToString());
                                    if (dt1.Rows[i]["start_date"].ToString() != "")
                                        n.start_date = Convert.ToDateTime(dt1.Rows[i]["start_date"].ToString()).ToString("yyyy-MM-dd");
                                    else
                                        //n.start_date = "1900-01-01";
                                        n.start_date = startdate.ToString("yyyy-MM-dd");
                                    n.RStartDate = dt1.Rows[i]["RStartDate"].ToString();
                                    n.REndDate = dt1.Rows[i]["REndDate"].ToString();
                                    if (n.RStartDate == "1/1/1900 12:00:00 AM")
                                        n.RStartDate = "";
                                    else
                                        n.RStartDate = Convert.ToDateTime(n.RStartDate).ToString("yyyy-MM-dd");
                                    if (n.REndDate == "1/1/1900 12:00:00 AM")
                                        n.REndDate = "";
                                    else
                                        n.REndDate = Convert.ToDateTime(n.REndDate).ToString("yyyy-MM-dd");
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
                                    n.flag = dt1.Rows[i]["Flag"].ToString();

                                    n.Priority = Convert.ToInt64(dt1.Rows[i]["Priority"].ToString());

                                    n.HDuration = Convert.ToInt64(dt1.Rows[i]["Holidaycount"].ToString());

                                    n.dep = dt1.Rows[i]["dep"].ToString();
                                    n.Predec = dt1.Rows[i]["Predec"].ToString();
                                    if (dt1.Rows[i]["Criticaltaskid"].ToString() != "")
                                        n.Criticaltaskid = Convert.ToInt64(dt1.Rows[i]["Criticaltaskid"].ToString());
                                    else
                                        n.Criticaltaskid = 0;
                                    n.Slack = Convert.ToDecimal(dt1.Rows[i]["Slack"].ToString());



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
                        else if (id == 9)
                        {
                            dt1 = new DataTable();
                            da = new SqlDataAdapter("select *,ISNULL((case when LinkType=4 then 3 else LinkType end),0) as LinkType1 from dbo.BOQLinkDetails bd  where  Flag='P' and bd.ProjectId=" + myproj, connection);
                            da.Fill(dt1);
                            if (dt1.Rows.Count > 0)
                            {
                                List<links> p1 = new List<links>();

                                for (int i = 0; i < dt1.Rows.Count; i++)
                                {
                                    
                                    links n = new links();
                                    n.id = Convert.ToInt64(dt1.Rows[i]["TaskId"].ToString());

                                    n.source = Convert.ToInt64(dt1.Rows[i]["SourceId"].ToString());
                                    n.target = Convert.ToInt64(dt1.Rows[i]["TargetId"].ToString());
                                    n.type = dt1.Rows[i]["LinkType1"].ToString();
                                    n.color = dt1.Rows[i]["Mcolor"].ToString();
                                    p1.Add(n);
                                   

                                }
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
        public HttpResponseMessage Get(string id, int val,string sub)
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
                            
                            //da = new SqlDataAdapter("select DATEADD(day,1,EndDate) as start_date from dbo.BoqEntryDetails  p  where p.SubItem like '%" + sub + "%' and  p.ProjectId=" + myproj + " and BOQRefId='" + id+"'", connection);
                            da = new SqlDataAdapter("select DATEADD(day,1,EndDate) as start_date from dbo.BoqEntryDetails  p  where p.BOQRefId like '%" + id + "%' and  p.ProjectId=" + myproj + " and BOQRefId='" + id + "'", connection);
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

                            //da = new SqlDataAdapter("select DATEADD(day,1,EndDate) as start_date from dbo.BoqEntryDetails  p  where p.SubItem like '%" + sub + "%' and  p.ProjectId=" + myproj + " and BOQRefId='" + id+"'", connection);
                            da = new SqlDataAdapter("select DATEADD(day,1,EndDate) as start_date from dbo.BoqEntryDetails  p  where p.BOQRefId like '%" + id + "%' and  p.ProjectId=" + myproj + " and BOQRefId='" + id + "'", connection);
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
        public HttpResponseMessage Post(int id,HttpRequestMessage request)
        ///public HttpResponseMessage Post(int id ,[FromBody] BoqMaster locat)
        {
            try
            {
                BoqMaster locat = null;
                List<links> mylink = null;
                var liat1 = request.Content.ReadAsStringAsync().Result;

                string authHeader = this.httpContext.Request.Headers["Authorization"];
                clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
                int userid = Convert.ToInt32(Models.JwtAuthentication.GetTokenUserId(authHeader));

                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                    if (dbt != null)
                    {
                        if (id == 4)
                        {
                            mylink = JsonConvert.DeserializeObject<List<links>>(liat1);
                            if (mylink.Count > 0)
                            {


                                using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id=" + dbt.DB_Username + ";Password=" + dbt.DB_Password + ";"))
                                {
                                    long mypro = 0;
                                    DataTable dt1 = new DataTable();
                                    DateTime pdate = new DateTime();
                                    connection.Open();
                                    SqlDataAdapter da = new SqlDataAdapter("select ProjectId,Start_Date from ProjectMaster p  where p.ClientId=" + clientid, connection);
                                    da.Fill(dt1);
                                    if (dt1.Rows.Count > 0)
                                    {
                                        mypro = Convert.ToInt64(dt1.Rows[0][0].ToString());
                                        //pdate = Convert.ToDateTime(dt1.Rows[0][1].ToString());
                                    }

                                    if (mypro != 0)
                                    {
                                        string sql = "";
                                        SqlDataAdapter adapter = new SqlDataAdapter();
                                        sql = "delete from BOQLinkDetails  where Flag='R' and   BOQId in (select BOQId from BoqEntryDetails v where (v.BOQRefId like '%S%') and v.WorkdonePer!=100 and v. ProjectId=" + mypro + ") and ProjectId=" + mypro;
                                        adapter.DeleteCommand = new SqlCommand(sql, connection);
                                        adapter.DeleteCommand.ExecuteNonQuery();

                                        adapter = new SqlDataAdapter();
                                        sql = "Update BoqEntryDetails set dep='',Predec='' where  (BOQRefId like '%S%') and WorkdonePer!=100 and ProjectId =" + mypro;
                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                        adapter.UpdateCommand.ExecuteNonQuery();

                                        adapter = new SqlDataAdapter();
                                        sql = "Update CriticalPathDetails set dep='',ES=0,EF=0,LF=0,LS=0,Predec='',Slack=0,Criticaltaskid='' where Flag='R' and  (BOQRefId like '%S%') and  ProjectId=" + mypro;
                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                        adapter.UpdateCommand.ExecuteNonQuery();

                                        for (int j = 0; j < mylink.Count; j++)
                                        {
                                            long lid = Convert.ToInt64(mylink[j].id);
                                            long lsource = Convert.ToInt64(mylink[j].source);
                                            long ltarget = Convert.ToInt64(mylink[j].target);
                                            string ltype = mylink[j].type;
                                           

                                            sql = "Link_Update";
                                            cmd = new SqlCommand(sql, connection);
                                            cmd.CommandType = CommandType.StoredProcedure;
                                            cmd.Parameters.Add("@ProjectId", SqlDbType.BigInt).Value = mypro;
                                            cmd.Parameters.Add("@TaskId", SqlDbType.VarChar).Value = lid;
                                            cmd.Parameters.Add("@SourceId", SqlDbType.VarChar).Value = lsource;
                                            cmd.Parameters.Add("@TargetId", SqlDbType.VarChar).Value = ltarget;
                                            cmd.Parameters.Add("@LinkType", SqlDbType.VarChar).Value = ltype;
                                            cmd.Parameters.Add("@flag", SqlDbType.VarChar).Value = "R";
                                            cmd.CommandTimeout = 0;
                                            cmd.ExecuteNonQuery();

                                            DataTable dt11 = new DataTable();
                                            da = new SqlDataAdapter("select * from BoqEntryDetails where (BOQRefId like '%S%') and WorkdonePer!=100 and  ProjectId=" + mypro + " and  TaskId='" + lsource + "'", connection);
                                            da.Fill(dt11);
                                            if (dt11.Rows.Count > 0)
                                            {

                                                adapter = new SqlDataAdapter();
                                                sql = "Update CriticalPathDetails set EF=ISNULL(ES,0)+ISNULL(Duration,0) where Flag='R' and ProjectId=" + mypro + " and  TaskId='" + lsource + "'";
                                                adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                adapter.UpdateCommand.ExecuteNonQuery();

                                                DataTable dt2 = new DataTable();
                                                
                                                da = new SqlDataAdapter("select * from BOQLinkDetails where Flag='R' and ProjectId=" + mypro + " and  TargetId='" + ltarget + "'", connection);
                                                da.Fill(dt2);

                                                for (int i = 0; i < dt2.Rows.Count; i++)
                                                {
                                                    decimal dura = 0;
                                                    DataTable dt12 = new DataTable();
                                                    da = new SqlDataAdapter("select EF from CriticalPathDetails where Flag='R' and  ProjectId=" + mypro + " and  TaskId='" + lsource + "'", connection);
                                                    da.Fill(dt12);
                                                    if (dt12.Rows.Count > 0)
                                                    {
                                                        dura = Convert.ToDecimal(dt12.Rows[0][0].ToString());
                                                    }

                                                    DataTable dt4 = new DataTable();
                                                    da = new SqlDataAdapter("select b.BOQRefId,REndDate from BoqEntryDetails b join BoqReviseDetails r on b.BOQId=r.BOQId  where b.ProjectId=" + mypro + " and  TaskId='" + lsource + "' and ReviseType = (select top 1  rd.ReviseType from BoqReviseDetails rd where rd.BOQId=r.BOQId order by ReviseId desc)", connection);
                                                    da.Fill(dt4);
                                                    if (dt4.Rows.Count > 0)
                                                    {
                                                        DateTime edate = new DateTime();
                                                        if (dt4.Rows[0][1].ToString() == "")
                                                        {
                                                            edate = pdate;
                                                        }
                                                        else
                                                            edate = Convert.ToDateTime(dt4.Rows[0][1].ToString());


                                                        string sorid = dt4.Rows[0][0].ToString();
                                                      

                                                        decimal efva = 0;


                                                        decimal durva = 1;
                                                        DataTable dt5 = new DataTable();
                                                        da = new SqlDataAdapter("select * from BoqEntryDetails where Predec like '%" + sorid + "%' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'", connection);
                                                        da.Fill(dt5);
                                                        if (dt5.Rows.Count > 0)
                                                        {
                                                            durva = Convert.ToDecimal(dt5.Rows[0]["RDuration"].ToString());
                                                        }
                                                        else
                                                        {
                                                            DataTable dt3 = new DataTable();
                                                            da = new SqlDataAdapter("select Predec,ISNULL(RDuration,0) as Duration  from BoqEntryDetails where ProjectId=" + mypro + " and  TaskId='" + ltarget + "'", connection);
                                                            da.Fill(dt3);
                                                            if (dt3.Rows.Count > 0)
                                                            {
                                                                durva = Convert.ToDecimal(dt3.Rows[0][1].ToString());
                                                                if (dt3.Rows[0][0].ToString() != "")
                                                                {

                                                                    DataTable dt6 = new DataTable();
                                                                    da = new SqlDataAdapter("select EF,BOQRefId from CriticalPathDetails where Flag='R' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'", connection);
                                                                    da.Fill(dt6);
                                                                    if (dt6.Rows[0][0].ToString() != "")
                                                                    {
                                                                        efva = Convert.ToDecimal(dt6.Rows[0][0].ToString());

                                                                    }

                                                                    string sym = "," + sorid;

                                                                    //adapter = new SqlDataAdapter();
                                                                    //sql = "Update BoqEntryDetails set Predec=Predec+'" + sym + "' where  ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                    //adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                    //adapter.UpdateCommand.ExecuteNonQuery();

                                                                    adapter = new SqlDataAdapter();
                                                                    sql = "Update CriticalPathDetails set Predec=Predec+'" + sym + "',ES=" + efva + " where Flag='R' and  ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                    adapter.UpdateCommand.ExecuteNonQuery();

                                                                    
                                                                    adapter = new SqlDataAdapter();
                                                                    sql = "Update CriticalPathDetails set EF=ES+Duration where Flag='R' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                    adapter.UpdateCommand.ExecuteNonQuery();



                                                                }
                                                                else
                                                                {

                                                                    DateTime nedate = edate.AddDays((double)durva);
                                                                    //adapter = new SqlDataAdapter();
                                                                    //sql = "Update BoqEntryDetails set  RVStartDate='" + edate + "', RVEndDate='" + nedate + "',RDuration=" + durva + ", Predec='" + sorid + "' where ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                    //adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                    //adapter.UpdateCommand.ExecuteNonQuery();

                                                                    adapter = new SqlDataAdapter();
                                                                    sql = "";
                                                                    sql = "Boq_CriticaltaskUpdate";
                                                                    cmd = new SqlCommand(sql, connection);
                                                                    cmd.CommandType = CommandType.StoredProcedure;
                                                                    cmd.Parameters.Add("@Criticaltaskid", SqlDbType.VarChar).Value = locat.Criticaltaskid;
                                                                    cmd.Parameters.Add("@StartDate", SqlDbType.DateTime).Value = edate;
                                                                    cmd.Parameters.Add("@EndDate", SqlDbType.DateTime).Value = nedate;
                                                                    cmd.Parameters.Add("@Duration", SqlDbType.Int).Value = durva;
                                                                    cmd.Parameters.Add("@dep", SqlDbType.VarChar).Value = locat.dep;
                                                                    cmd.Parameters.Add("@Predec", SqlDbType.VarChar).Value = sorid;
                                                                    cmd.Parameters.Add("@Priority", SqlDbType.BigInt).Value = mypro;
                                                                    cmd.Parameters.Add("@TaskId", SqlDbType.VarChar).Value = ltarget;
                                                                    cmd.Parameters.Add("@Flag", SqlDbType.Int).Value = 2;
                                                                    cmd.CommandTimeout = 0;
                                                                    cmd.ExecuteNonQuery();


                                                                    if (j == 0)
                                                                    {
                                                                        adapter = new SqlDataAdapter();
                                                                        sql = "Update CriticalPathDetails set  ES=" + dura + " where Flag='R' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                        adapter.UpdateCommand.ExecuteNonQuery();
                                                                    }

                                                                    adapter = new SqlDataAdapter();
                                                                    sql = "Update CriticalPathDetails set  Predec='" + sorid + "' where Flag='R' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                    adapter.UpdateCommand.ExecuteNonQuery();

                                                                    adapter = new SqlDataAdapter();
                                                                    sql = "Update CriticalPathDetails set EF=ES+Duration  where Flag='R' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                    adapter.UpdateCommand.ExecuteNonQuery();

                                                                    DataTable dt10 = new DataTable();
                                                                    da = new SqlDataAdapter("select EF from CriticalPathDetails where Flag='R' and ProjectId=" + mypro + " and  BOQRefId='" + sorid + "'", connection);
                                                                    da.Fill(dt10);
                                                                    if (dt10.Rows.Count > 0)
                                                                    {
                                                                        decimal efvalnew = Convert.ToDecimal(dt10.Rows[0][0].ToString());
                                                                        if (j != 0)
                                                                        {
                                                                            adapter = new SqlDataAdapter();
                                                                            sql = "Update CriticalPathDetails set  ES=" + efvalnew + " where Flag='R' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                            adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                            adapter.UpdateCommand.ExecuteNonQuery();

                                                                            adapter = new SqlDataAdapter();
                                                                            sql = "Update CriticalPathDetails set EF=ES+Duration  where Flag='R' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                            adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                            adapter.UpdateCommand.ExecuteNonQuery();
                                                                        }
                                                                    }

                                                                  

                                                                }
                                                            }

                                                            string refid = "";
                                                            DataTable dt8 = new DataTable();
                                                            da = new SqlDataAdapter("select BOQRefId from CriticalPathDetails where Flag='R' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'", connection);
                                                            da.Fill(dt8);
                                                            if (dt8.Rows.Count > 0)
                                                            {
                                                                if (dt8.Rows[0][0].ToString() != "")
                                                                {

                                                                    refid = dt8.Rows[0][0].ToString();
                                                                }
                                                            }

                                                            dt8 = new DataTable();
                                                            da = new SqlDataAdapter("select dep from CriticalPathDetails where Flag='R' and ProjectId=" + mypro + " and  BOQRefId='" + sorid + "'", connection);
                                                            da.Fill(dt8);
                                                            if (dt8.Rows.Count > 0)
                                                            {

                                                                if (dt8.Rows[0][0].ToString() != "")
                                                                {


                                                                    adapter = new SqlDataAdapter();
                                                                    sql = "Update CriticalPathDetails set  dep=dep+'" + "," + refid + "' where Flag='R' and ProjectId=" + mypro + " and  BOQRefId='" + sorid + "'";
                                                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                    adapter.UpdateCommand.ExecuteNonQuery();


                                                                }
                                                                else
                                                                {
                                                                    adapter = new SqlDataAdapter();
                                                                    sql = "Update CriticalPathDetails set  dep='" + refid + "' where Flag='R' and ProjectId=" + mypro + " and  BOQRefId='" + sorid + "'";
                                                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                    adapter.UpdateCommand.ExecuteNonQuery();
                                                                }

                                                                ;
                                                            }



                                                        }
                                                    }





                                                }

                                            }
                                            //Mas Update
                                            DataTable dt9 = new DataTable();
                                            da = new SqlDataAdapter("select BOQId from CriticalPathDetails where Flag='R' and ProjectId=" + mypro + " and  Predec!='' ", connection);
                                            da.Fill(dt9);
                                            if (dt9.Rows.Count > 0)
                                            {

                                                for (int i = 0; i < dt9.Rows.Count; i++)
                                                {
                                                    long BOQId = Convert.ToInt64(dt9.Rows[i][0].ToString());

                                                    decimal maxdur = 0;
                                                    da = new SqlDataAdapter("Get_MaxEF", connection);
                                                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                                                    da.SelectCommand.Parameters.AddWithValue("@ProjectId", mypro);
                                                    da.SelectCommand.Parameters.AddWithValue("@BOQId", BOQId);
                                                    da.SelectCommand.Parameters.AddWithValue("@flag", "R");
                                                    da.SelectCommand.CommandTimeout = 0;
                                                    DataTable ds = new DataTable();
                                                    da.Fill(ds);
                                                    if (ds.Rows.Count > 0)
                                                    {

                                                        maxdur = Convert.ToDecimal(ds.Rows[0][0].ToString());
                                                        adapter = new SqlDataAdapter();
                                                        sql = "Update CriticalPathDetails set ES=" + maxdur + " where  Flag='R' and ProjectId=" + mypro + " and  BOQId='" + BOQId + "'";
                                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                        adapter.UpdateCommand.ExecuteNonQuery();

                                                        adapter = new SqlDataAdapter();
                                                        sql = "Update CriticalPathDetails set EF=ES+Duration where Flag='R' and ProjectId=" + mypro + " and  BOQId='" + BOQId + "'";
                                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                        adapter.UpdateCommand.ExecuteNonQuery();


                                                       



                                                    }
                                                }
                                            }

                                        }
                                        DataTable dt15 = new DataTable();
                                        da = new SqlDataAdapter("select ISNULL(EF,0) as EF,BOQId,dep from CriticalPathDetails where Flag='R' and (dep!='' or  Predec!='') and (BOQRefId like '%S%' ) and ProjectId=" + mypro, connection);
                                        da.Fill(dt15);
                                        if (dt15.Rows.Count > 0)
                                        {

                                            decimal maxLavel = Convert.ToDecimal(dt15.Compute("max([EF])", string.Empty));

                                            for (int i = dt15.Rows.Count; i-- > 0;)
                                            {
                                                decimal efvalnew = Convert.ToDecimal(dt15.Rows[i][0].ToString());
                                                string BOQRe = dt15.Rows[i][1].ToString();
                                                string dep = dt15.Rows[i][2].ToString();

                                                if ((i + 1) == dt15.Rows.Count)
                                                {
                                                    adapter = new SqlDataAdapter();
                                                    sql = "Update CriticalPathDetails set  LF=" + maxLavel + " where Flag='R' and ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                    adapter.UpdateCommand.ExecuteNonQuery();

                                                    adapter = new SqlDataAdapter();
                                                    sql = "Update CriticalPathDetails set  LS=LF-Duration where Flag='R' and ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                    adapter.UpdateCommand.ExecuteNonQuery();

                                                    adapter = new SqlDataAdapter();
                                                    sql = "Update CriticalPathDetails set  Slack=LF-EF where Flag='R' and ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                    adapter.UpdateCommand.ExecuteNonQuery();
                                                }
                                              

                                                if (dep != "")
                                                {

                                                    

                                                    if ((i + 1) != dt15.Rows.Count)
                                                    {
                                                        DataTable dt10 = new DataTable();
                                                        //da = new SqlDataAdapter("select LS from CriticalPathDetails where ProjectId=" + mypro + " and   BOQRefId='" + dep + "'", connection);
                                                        da = new SqlDataAdapter("Get_MInLF", connection);
                                                        da.SelectCommand.CommandType = CommandType.StoredProcedure;
                                                        da.SelectCommand.Parameters.AddWithValue("@ProjectId", mypro);
                                                        da.SelectCommand.Parameters.AddWithValue("@BOQId", BOQRe);
                                                        da.SelectCommand.Parameters.AddWithValue("@flag", "R");
                                                        da.SelectCommand.CommandTimeout = 0;
                                                        da.Fill(dt10);
                                                        if (dt10.Rows.Count > 0)
                                                        {
                                                            decimal ldsvalnew = Convert.ToDecimal(dt10.Rows[0][0].ToString());
                                                            adapter = new SqlDataAdapter();
                                                            sql = "Update CriticalPathDetails set  LF=" + ldsvalnew + " where Flag='R' and ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                            adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                            adapter.UpdateCommand.ExecuteNonQuery();



                                                            adapter = new SqlDataAdapter();
                                                            sql = "Update CriticalPathDetails set  LS=LF-Duration where Flag='R' and ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                            adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                            adapter.UpdateCommand.ExecuteNonQuery();

                                                            adapter = new SqlDataAdapter();
                                                            sql = "Update CriticalPathDetails set  Slack=LF-EF where Flag='R' and ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                            adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                            adapter.UpdateCommand.ExecuteNonQuery();



                                                        }

                                                    }


                                                }
                                                adapter = new SqlDataAdapter();
                                                sql = "Update CriticalPathDetails set  Criticaltaskid=TaskId where Flag='R' and ProjectId=" + mypro + " and Slack=0 and BOQId='" + BOQRe + "'";
                                                adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                adapter.UpdateCommand.ExecuteNonQuery();

                                            }
                                        }
                                    }
                                    else
                                    {
                                        status = false;
                                        message = "Update Not Possible";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    connection.Close();
                                }

                                message = "Updated Successfully";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {
                                status = false;
                                message = "Data Not Found";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }

                        }
                        else if (id == 3)
                        {


                            string msg = "";

                            BoqMaster model = null;

                            using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id=" + dbt.DB_Username + ";Password=" + dbt.DB_Password + ";"))
                            //using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";Integrated Security = True;"))
                            {
                                DataTable dt1 = new DataTable();
                                connection.Open();
                                long mypro = 0;
                                DateTime enddate = new DateTime();
                                SqlDataAdapter da = new SqlDataAdapter("select ProjectId,End_Date from ProjectMaster p  where p.ClientId=" + clientid, connection);
                                da.Fill(dt1);
                                if (dt1.Rows.Count > 0)
                                {
                                    mypro = Convert.ToInt64(dt1.Rows[0][0].ToString());
                                    enddate = Convert.ToDateTime(dt1.Rows[0][1].ToString());

                                }

                                if (mypro != 0)
                                {

                                    model = JsonConvert.DeserializeObject<BoqMaster>(liat1);
                                    if (model != null)
                                    {
                                        if (model.start_date == "")
                                        {
                                            status = false;
                                            message = "Enter Start Date";
                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                        }
                                        else if (model.end_date == "")
                                        {
                                            status = false;
                                            message = "Enter End Date";
                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                        }
                                        else if (model.dep != "")
                                        {
                                            DataTable dt5 = new DataTable();
                                            DateTime datet = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);

                                            da = new SqlDataAdapter("select StartDate as start_date from dbo.BoqEntryDetails  p  where  p.ProjectId=" + mypro + " and BOQRefId='" + model.dep + "'", connection);
                                            //da = new SqlDataAdapter("select StartDate as start_date from dbo.BoqEntryDetails  p  where p.SubItem like '%" + locat.subitem + "%' and  p.ProjectId=" + myproj + " and BOQRefId='" + locat.dep + "'", connection);
                                            da.Fill(dt5);

                                            if (dt5.Rows.Count == 0)
                                            {
                                                connection.Close();
                                                message = "Enter Successors doesn't exists";
                                                status = false;
                                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                            }
                                        }
                                        else if (model.Predec != "")
                                        {
                                            DataTable dt5 = new DataTable();


                                            da = new SqlDataAdapter("select StartDate as start_date from dbo.BoqEntryDetails  p  where  p.ProjectId=" + mypro + " and BOQRefId like '" + model.Predec.Substring(0, 2) + "%'", connection);

                                            da.Fill(dt5);

                                            if (dt5.Rows.Count == 0)
                                            {
                                                connection.Close();
                                                message = "Enter Predecessor doesn't exists";
                                                status = false;
                                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                            }
                                        }

                                        if (model.start_date != null && model.end_date != null)
                                        {

                                            DataTable dt3 = new DataTable();
                                            da = new SqlDataAdapter("select ProjectId,End_Date from ProjectMaster p  where p.ClientId=" + clientid, connection);
                                            da.Fill(dt3);
                                            if (dt3.Rows.Count > 0)
                                            {

                                                DateTime datet = DateTime.Parse(model.start_date);

                                                if (enddate < datet)
                                                {
                                                    if (model.flag == "F")
                                                    {
                                                        message = "Revise end date is greater than project date";
                                                        status = false;
                                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
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

                                        model = JsonConvert.DeserializeObject<BoqMaster>(liat1);
                                        if (model != null)
                                        {
                                            long BOQId = 0;
                                            DataTable dt4 = new DataTable();
                                            da = new SqlDataAdapter("select BOQId from BoqEntryDetails p  where Flag='V' and TaskId='" + model.id + "' and ProjectId = " + mypro, connection);
                                            da.Fill(dt4);
                                            if (dt4.Rows.Count > 0)
                                            {
                                                BOQId = Convert.ToInt64(dt4.Rows[0][0].ToString());
                                                if (model.flag == "F")
                                                {
                                                    string sql = "";
                                                    //SqlDataAdapter adapter = new SqlDataAdapter();
                                                    //sql = "Update BoqReviseDetails set FDate='" + DateTime.Now + "',Flag='F' where BOQId=" + BOQId;
                                                    //adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                    //adapter.UpdateCommand.ExecuteNonQuery();

                                                    SqlDataAdapter adapter = new SqlDataAdapter();
                                                    sql = "Update_BoqReviseDetails";
                                                    cmd = new SqlCommand(sql, connection);
                                                    cmd.CommandType = CommandType.StoredProcedure;
                                                    cmd.Parameters.Add("@ReviseType", SqlDbType.VarChar).Value = "";
                                                    cmd.Parameters.Add("@RStartDate", SqlDbType.DateTime).Value = DateTime.Now;
                                                    cmd.Parameters.Add("@REndDate", SqlDbType.DateTime).Value = DateTime.Now;
                                                    cmd.Parameters.Add("@RDuration", SqlDbType.Int).Value = 0;
                                                    cmd.Parameters.Add("@userid", SqlDbType.Int).Value = userid;
                                                    cmd.Parameters.Add("@SysDate", SqlDbType.DateTime).Value = DateTime.Now;
                                                    cmd.Parameters.Add("@BOQId", SqlDbType.Int).Value = BOQId;
                                                    cmd.Parameters.Add("@ProjectId", SqlDbType.BigInt).Value = mypro;
                                                    cmd.Parameters.Add("@Flag", SqlDbType.Int).Value = 3;
                                                    cmd.CommandTimeout = 0;
                                                    cmd.ExecuteNonQuery();
                                                    ok = "f";
                                                }
                                                else
                                                {
                                                    if (model.start_date != null && model.end_date != null)
                                                    {

                                                        string rev = "";
                                                        DataTable dtt1 = new DataTable();
                                                        da = new SqlDataAdapter("select top 1 ReviseType from BoqReviseDetails where Flag='F' and BOQId='" + BOQId + "' order by ReviseId desc", connection);
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


                                                        DateTime stateredDate = DateTime.Parse(model.start_date);

                                                        DateTime enedDate = DateTime.Parse(model.start_date).AddDays(model.duration);
                                                        if (stateredDate <= enedDate)
                                                        {
                                                            TimeSpan t = enedDate - stateredDate;
                                                            double NrOfDays = t.TotalDays;
                                                            int difday = model.duration;
                                                            if (model.duration == 0)
                                                                difday = (int)NrOfDays;
                                                            DataTable dtt2 = new DataTable();
                                                            da = new SqlDataAdapter("select * from BoqReviseDetails where ReviseType='" + rev + "' and BOQId='" + BOQId + "'", connection);
                                                            da.Fill(dtt2);
                                                            if (dtt2.Rows.Count == 0)
                                                            {
                                                                // DateTime stateredDate = DateTime.Parse(locat.RStartDate);
                                                                //DateTime enedDate = DateTime.Parse(locat.REndDate);
                                                               // SqlDataAdapter adapter = new SqlDataAdapter();
                                                                //string sql = "insert into BoqReviseDetails values(" + BOQId + ",'" + rev + "','" + stateredDate + "','" + enedDate + "','" + userid + "','" + DateTime.Now + "','P','" + DateTime.Now + "')";
                                                                //adapter.InsertCommand = new SqlCommand(sql, connection);
                                                                //adapter.InsertCommand.ExecuteNonQuery();

                                                                SqlDataAdapter adapter = new SqlDataAdapter();
                                                                string sql = "Update_BoqReviseDetails";
                                                                cmd = new SqlCommand(sql, connection);
                                                                cmd.CommandType = CommandType.StoredProcedure;
                                                                cmd.Parameters.Add("@ReviseType", SqlDbType.VarChar).Value = rev;
                                                                cmd.Parameters.Add("@RStartDate", SqlDbType.DateTime).Value = stateredDate;
                                                                cmd.Parameters.Add("@REndDate", SqlDbType.DateTime).Value = enedDate;
                                                                cmd.Parameters.Add("@RDuration", SqlDbType.Int).Value = difday;
                                                                cmd.Parameters.Add("@userid", SqlDbType.Int).Value = userid;
                                                                cmd.Parameters.Add("@SysDate", SqlDbType.DateTime).Value = DateTime.Now;
                                                                cmd.Parameters.Add("@BOQId", SqlDbType.Int).Value = BOQId;
                                                                cmd.Parameters.Add("@ProjectId", SqlDbType.BigInt).Value = mypro;
                                                                cmd.Parameters.Add("@Flag", SqlDbType.Int).Value = 0;
                                                                cmd.CommandTimeout = 0;
                                                                cmd.ExecuteNonQuery();

                                                                ok = "a";
                                                            }
                                                            else
                                                            {
                                                                string sql = "";
                                                                //SqlDataAdapter adapter = new SqlDataAdapter();
                                                                //sql = "Update BoqReviseDetails set RStartDate='" + model.start_date + "',REndDate='" + enedDate + "' where BOQId=" + BOQId;
                                                                //adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                //adapter.UpdateCommand.ExecuteNonQuery();

                                                                SqlDataAdapter adapter = new SqlDataAdapter();
                                                                sql = "Update_BoqReviseDetails";
                                                                cmd = new SqlCommand(sql, connection);
                                                                cmd.CommandType = CommandType.StoredProcedure;
                                                                cmd.Parameters.Add("@ReviseType", SqlDbType.VarChar).Value = "";
                                                                cmd.Parameters.Add("@RStartDate", SqlDbType.DateTime).Value = model.start_date;
                                                                cmd.Parameters.Add("@REndDate", SqlDbType.DateTime).Value = enedDate;
                                                                cmd.Parameters.Add("@RDuration", SqlDbType.Int).Value = difday;
                                                                cmd.Parameters.Add("@userid", SqlDbType.Int).Value = userid;
                                                                cmd.Parameters.Add("@SysDate", SqlDbType.DateTime).Value = DateTime.Now;
                                                                cmd.Parameters.Add("@BOQId", SqlDbType.Int).Value = BOQId;
                                                                cmd.Parameters.Add("@ProjectId", SqlDbType.BigInt).Value = mypro;
                                                                cmd.Parameters.Add("@Flag", SqlDbType.Int).Value = 1;
                                                                cmd.CommandTimeout = 0;
                                                                cmd.ExecuteNonQuery();

                                                                // sql = "";
                                                                // adapter = new SqlDataAdapter();
                                                                //sql = "Update BoqEntryDetails set RVStartDate='" + model.start_date + "',RVEndDate='" + enedDate + "',RDuration="+difday+" where BOQId=" + BOQId;
                                                                //adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                //adapter.UpdateCommand.ExecuteNonQuery();

                                                                adapter = new SqlDataAdapter();                                                                
                                                                sql = "Update_BoqReviseDetails";
                                                                cmd = new SqlCommand(sql, connection);
                                                                cmd.CommandType = CommandType.StoredProcedure;
                                                                cmd.Parameters.Add("@ReviseType", SqlDbType.VarChar).Value = "";
                                                                cmd.Parameters.Add("@RStartDate", SqlDbType.DateTime).Value = model.start_date;
                                                                cmd.Parameters.Add("@REndDate", SqlDbType.DateTime).Value = enedDate;
                                                                cmd.Parameters.Add("@RDuration", SqlDbType.Int).Value = difday;
                                                                cmd.Parameters.Add("@userid", SqlDbType.Int).Value = userid;
                                                                cmd.Parameters.Add("@SysDate", SqlDbType.DateTime).Value = DateTime.Now;
                                                                cmd.Parameters.Add("@BOQId", SqlDbType.Int).Value = BOQId;
                                                                cmd.Parameters.Add("@ProjectId", SqlDbType.BigInt).Value = mypro;
                                                                cmd.Parameters.Add("@Flag", SqlDbType.Int).Value = 2;
                                                                cmd.CommandTimeout = 0;
                                                                cmd.ExecuteNonQuery();

                                                                ok = "u";

                                                            }

                                                            SqlDataAdapter adapter1 = new SqlDataAdapter();
                                                            string sql1 = "Update CriticalPathDetails set Duration=" + difday + ",dep='" + model.dep + "' where Flag = 'R' and  TaskId=" + model.id;
                                                            adapter1.UpdateCommand = new SqlCommand(sql1, connection);
                                                            adapter1.UpdateCommand.ExecuteNonQuery();

                                                        }
                                                        else
                                                        {
                                                            status = false;
                                                            message = "Check Date";
                                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                                        }
                                                    }
                                                }

                                                //delete 100 work
                                                if (model.flag == "F")
                                                {
                                                    DataTable dt3 = new DataTable();

                                                    string botp = "";
                                                    //dt1 = new DataTable();

                                                    dt3 = new DataTable();
                                                    da = new SqlDataAdapter("select BOQType from BoqEntryDetails p  where p.BOQId=" + BOQId, connection);
                                                    da.Fill(dt3);
                                                    if (dt3.Rows.Count > 0)
                                                    {
                                                        botp = dt3.Rows[0][0].ToString();
                                                    }
                                                    string sql = "";
                                                    SqlDataAdapter adapter = new SqlDataAdapter();
                                                    sql = "delete from BoqReviseDetails  where  BOQId in (select BOQId from BoqEntryDetails where WorkdonePer=100 and BOQType='" + botp + "'  and ProjectId=" + mypro + ")";
                                                    adapter.DeleteCommand = new SqlCommand(sql, connection);
                                                    adapter.DeleteCommand.ExecuteNonQuery();
                                                    ok = "f";
                                                }
                                            }
                                            else
                                            {
                                                status = false;
                                                message = "No BOQ Revise Found";
                                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                            }
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
                                else
                                {
                                    connection.Close();
                                    message = "Check Project";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }
                            }

                        }

                        else if (id == 2)
                        {
                            mylink = JsonConvert.DeserializeObject<List<links>>(liat1);
                            if (mylink.Count > 0)
                            {


                                using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id=" + dbt.DB_Username + ";Password=" + dbt.DB_Password + ";"))
                                {
                                    long mypro = 0;
                                    DataTable dt1 = new DataTable();
                                    DateTime pdate = new DateTime();
                                    connection.Open();
                                    SqlDataAdapter da = new SqlDataAdapter("select ProjectId,Start_Date from ProjectMaster p  where p.ClientId=" + clientid, connection);
                                    da.Fill(dt1);
                                    if (dt1.Rows.Count > 0)
                                    {
                                        mypro = Convert.ToInt64(dt1.Rows[0][0].ToString());
                                        pdate = Convert.ToDateTime(dt1.Rows[0][1].ToString());
                                    }

                                    if (mypro != 0)
                                    {
                                        DataTable dt24 = new DataTable();
                                        da = new SqlDataAdapter("select * from BoqEntryDetails p  where Flag='V' and ProjectId = " + mypro, connection);
                                        da.Fill(dt24);
                                        if (dt24.Rows.Count > 0)
                                        {
                                            status = false;
                                            message = "Project is Freezed";
                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                        }

                                        string sql = "";
                                        SqlDataAdapter adapter = new SqlDataAdapter();
                                        sql = "delete from BOQLinkDetails  where Flag='P' and   BOQId in (select BOQId from BoqEntryDetails v where (v.BOQRefId like '%S%') and v. ProjectId=" + mypro + ") and ProjectId=" + mypro;
                                        adapter.DeleteCommand = new SqlCommand(sql, connection);
                                        adapter.DeleteCommand.ExecuteNonQuery();

                                        adapter = new SqlDataAdapter();
                                        sql = "Update BoqEntryDetails set dep='',Predec='' where  (BOQRefId like '%S%' ) and ProjectId =" + mypro;
                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                        adapter.UpdateCommand.ExecuteNonQuery();

                                        adapter = new SqlDataAdapter();
                                        sql = "Update CriticalPathDetails set dep='',ES=0,EF=0,LF=0,LS=0,Predec='',Slack=0,Criticaltaskid='' where Flag='P' and  (BOQRefId like '%S%') and  ProjectId=" + mypro;
                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                        adapter.UpdateCommand.ExecuteNonQuery();

                                        for (int j = 0; j < mylink.Count; j++)
                                        {
                                            long lid = Convert.ToInt64(mylink[j].id);
                                            if (lid != 0)
                                            {
                                                long lsource = Convert.ToInt64(mylink[j].source);
                                                long ltarget = Convert.ToInt64(mylink[j].target);
                                                string ltype = mylink[j].type;
                                                //foreach (var item in mylink)
                                                //{

                                                sql = "Link_Update";
                                                cmd = new SqlCommand(sql, connection);
                                                cmd.CommandType = CommandType.StoredProcedure;
                                                cmd.Parameters.Add("@ProjectId", SqlDbType.BigInt).Value = mypro;
                                                cmd.Parameters.Add("@TaskId", SqlDbType.VarChar).Value = lid;
                                                cmd.Parameters.Add("@SourceId", SqlDbType.VarChar).Value = lsource;
                                                cmd.Parameters.Add("@TargetId", SqlDbType.VarChar).Value = ltarget;
                                                cmd.Parameters.Add("@LinkType", SqlDbType.VarChar).Value = ltype;
                                                cmd.Parameters.Add("@flag", SqlDbType.VarChar).Value = "P";
                                                cmd.CommandTimeout = 0;
                                                cmd.ExecuteNonQuery();

                                                DataTable dt11 = new DataTable();
                                                da = new SqlDataAdapter("select * from BoqEntryDetails where (BOQRefId like '%S%') and  ProjectId=" + mypro + " and  TaskId='" + lsource + "'", connection);
                                                da.Fill(dt11);
                                                if (dt11.Rows.Count > 0)
                                                {

                                                    adapter = new SqlDataAdapter();
                                                    sql = "Update CriticalPathDetails set EF=ISNULL(ES,0)+ISNULL(Duration,0) where Flag='P' and ProjectId=" + mypro + " and  TaskId='" + lsource + "'";
                                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                    adapter.UpdateCommand.ExecuteNonQuery();

                                                    DataTable dt2 = new DataTable();
                                                    //connection.Open();
                                                    da = new SqlDataAdapter("select * from BOQLinkDetails where Flag='P' and ProjectId=" + mypro + " and  TargetId='" + ltarget + "'", connection);
                                                    da.Fill(dt2);

                                                    for (int i = 0; i < dt2.Rows.Count; i++)
                                                    {
                                                        decimal dura = 0;
                                                        DataTable dt12 = new DataTable();
                                                        da = new SqlDataAdapter("select EF from CriticalPathDetails where Flag='P' and  ProjectId=" + mypro + " and  TaskId='" + lsource + "'", connection);
                                                        da.Fill(dt12);
                                                        if (dt12.Rows.Count > 0)
                                                        {
                                                            dura = Convert.ToDecimal(dt12.Rows[0][0].ToString());
                                                        }

                                                        DataTable dt4 = new DataTable();
                                                        da = new SqlDataAdapter("select BOQRefId,EndDate from BoqEntryDetails where ProjectId=" + mypro + " and  TaskId='" + lsource + "'", connection);
                                                        da.Fill(dt4);
                                                        if (dt4.Rows.Count > 0)
                                                        {
                                                            DateTime edate = new DateTime();
                                                            if (dt4.Rows[0][1].ToString() == "")
                                                            {
                                                                edate = pdate;
                                                            }
                                                            else
                                                                edate = Convert.ToDateTime(dt4.Rows[0][1].ToString());


                                                            string sorid = dt4.Rows[0][0].ToString();
                                                            // if (sorid.Substring(0,1)!="P")

                                                            decimal efva = 0;


                                                            decimal durva = 1;
                                                            DataTable dt5 = new DataTable();
                                                            da = new SqlDataAdapter("select * from BoqEntryDetails where Predec like '%" + sorid + "%' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'", connection);
                                                            da.Fill(dt5);
                                                            if (dt5.Rows.Count > 0)
                                                            {
                                                                durva = Convert.ToDecimal(dt5.Rows[0]["Duration"].ToString());
                                                            }
                                                            else
                                                            {
                                                                DataTable dt3 = new DataTable();
                                                                da = new SqlDataAdapter("select Predec,ISNULL(Duration,0) as Duration  from BoqEntryDetails where ProjectId=" + mypro + " and  TaskId='" + ltarget + "'", connection);
                                                                da.Fill(dt3);
                                                                if (dt3.Rows.Count > 0)
                                                                {
                                                                    durva = Convert.ToDecimal(dt3.Rows[0][1].ToString());
                                                                    if (dt3.Rows[0][0].ToString() != "")
                                                                    {

                                                                        DataTable dt6 = new DataTable();
                                                                        da = new SqlDataAdapter("select EF,BOQRefId from CriticalPathDetails where Flag='P' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'", connection);
                                                                        da.Fill(dt6);
                                                                        if (dt6.Rows[0][0].ToString() != "")
                                                                        {
                                                                            efva = Convert.ToDecimal(dt6.Rows[0][0].ToString());

                                                                        }

                                                                        string sym = "," + sorid;

                                                                        adapter = new SqlDataAdapter();
                                                                        sql = "Update BoqEntryDetails set Predec=Predec+'" + sym + "' where  ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                        adapter.UpdateCommand.ExecuteNonQuery();

                                                                        adapter = new SqlDataAdapter();
                                                                        sql = "Update CriticalPathDetails set Predec=Predec+'" + sym + "',ES=" + efva + " where Flag='P' and  ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                        adapter.UpdateCommand.ExecuteNonQuery();

                                                                        //if (dt2.Rows.Count == (i+1))
                                                                        //{
                                                                        //    adapter = new SqlDataAdapter();
                                                                        //    sql = "Update CriticalPathDetails set  Duration=0 where ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                        //    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                        //    adapter.UpdateCommand.ExecuteNonQuery();
                                                                        //}

                                                                        adapter = new SqlDataAdapter();
                                                                        sql = "Update CriticalPathDetails set EF=ES+Duration where Flag='P' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                        adapter.UpdateCommand.ExecuteNonQuery();



                                                                    }
                                                                    else
                                                                    {

                                                                        DateTime nedate = edate.AddDays((double)durva);
                                                                        adapter = new SqlDataAdapter();
                                                                        
                                                                        sql = "Boq_CriticaltaskUpdate";
                                                                        cmd = new SqlCommand(sql, connection);
                                                                        cmd.CommandType = CommandType.StoredProcedure;
                                                                        cmd.Parameters.Add("@Criticaltaskid", SqlDbType.VarChar).Value = "";
                                                                        cmd.Parameters.Add("@StartDate", SqlDbType.DateTime).Value = edate;
                                                                        cmd.Parameters.Add("@EndDate", SqlDbType.DateTime).Value = nedate;
                                                                        cmd.Parameters.Add("@Duration", SqlDbType.Int).Value = durva;
                                                                        cmd.Parameters.Add("@dep", SqlDbType.VarChar).Value = "";
                                                                        cmd.Parameters.Add("@Predec", SqlDbType.VarChar).Value = sorid;
                                                                        cmd.Parameters.Add("@Priority", SqlDbType.BigInt).Value = mypro;
                                                                        cmd.Parameters.Add("@TaskId", SqlDbType.VarChar).Value = ltarget;
                                                                        cmd.Parameters.Add("@Flag", SqlDbType.VarChar).Value = 1;
                                                                        cmd.CommandTimeout = 0;
                                                                        cmd.ExecuteNonQuery();

                                                                        //adapter = new SqlDataAdapter();
                                                                        //sql = "Update BoqEntryDetails set  StartDate='" + edate + "', EndDate='" + nedate + "',Duration=" + durva + ", Predec='" + sorid + "' where ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                        //adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                        //adapter.UpdateCommand.ExecuteNonQuery();


                                                                        DataTable dtt1 = new DataTable();
                                                                        da = new SqlDataAdapter("select MainItemId,SubItem from BoqEntryDetails where ProjectId=" + mypro + " and  TaskId='" + ltarget + "'", connection);
                                                                        da.Fill(dtt1);
                                                                        if (dtt1.Rows.Count > 0)
                                                                        {
                                                                            long mainItemId = Convert.ToInt64(dtt1.Rows[0][0].ToString());
                                                                            string subitem = dtt1.Rows[0][1].ToString();


                                                                            sql = "Boq_Update";
                                                                            cmd = new SqlCommand(sql, connection);
                                                                            cmd.CommandType = CommandType.StoredProcedure;
                                                                            cmd.Parameters.Add("@MainItemId", SqlDbType.BigInt).Value = mainItemId;
                                                                            cmd.Parameters.Add("@subitem", SqlDbType.VarChar).Value = subitem;
                                                                            cmd.Parameters.Add("@flag", SqlDbType.VarChar).Value = "P";
                                                                            cmd.Parameters.Add("@ProjectId", SqlDbType.BigInt).Value = mypro;
                                                                            cmd.Parameters.Add("@tasId", SqlDbType.VarChar).Value = ltarget;
                                                                            cmd.CommandTimeout = 0;
                                                                            cmd.ExecuteNonQuery();

                                                                        }

                                                                        if (j == 0)
                                                                        {
                                                                            adapter = new SqlDataAdapter();
                                                                            sql = "Update CriticalPathDetails set  ES=" + dura + " where Flag='P' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                            adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                            adapter.UpdateCommand.ExecuteNonQuery();
                                                                        }

                                                                        adapter = new SqlDataAdapter();
                                                                        sql = "Update CriticalPathDetails set  Predec='" + sorid + "' where Flag='P' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                        adapter.UpdateCommand.ExecuteNonQuery();

                                                                        adapter = new SqlDataAdapter();
                                                                        sql = "Update CriticalPathDetails set EF=ES+Duration  where Flag='P' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                        adapter.UpdateCommand.ExecuteNonQuery();

                                                                        DataTable dt10 = new DataTable();
                                                                        da = new SqlDataAdapter("select EF from CriticalPathDetails where Flag='P' and ProjectId=" + mypro + " and  BOQRefId='" + sorid + "'", connection);
                                                                        da.Fill(dt10);
                                                                        if (dt10.Rows.Count > 0)
                                                                        {
                                                                            decimal efvalnew = Convert.ToDecimal(dt10.Rows[0][0].ToString());
                                                                            if (j != 0)
                                                                            {
                                                                                adapter = new SqlDataAdapter();
                                                                                sql = "Update CriticalPathDetails set  ES=" + efvalnew + " where Flag='P' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                                adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                                adapter.UpdateCommand.ExecuteNonQuery();

                                                                                adapter = new SqlDataAdapter();
                                                                                sql = "Update CriticalPathDetails set EF=ES+Duration  where Flag='P' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'";
                                                                                adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                                adapter.UpdateCommand.ExecuteNonQuery();
                                                                            }
                                                                        }

                                                                        //string refid1 = "";
                                                                        //DataTable dt7 = new DataTable();
                                                                        //da = new SqlDataAdapter("select dep from CriticalPathDetails where ProjectId=" + mypro + " and  TaskId='" + lsource + "'", connection);
                                                                        //da.Fill(dt7);
                                                                        //if (dt7.Rows[0][0].ToString() != "")
                                                                        //{

                                                                        //    refid1 = dt7.Rows[0][0].ToString();

                                                                        //    DataTable dt8 = new DataTable();
                                                                        //    da = new SqlDataAdapter("select LS from CriticalPathDetails where ProjectId=" + mypro + " and  dep='" + refid1 + "'", connection);
                                                                        //    da.Fill(dt8);
                                                                        //    if (dt8.Rows[0][0].ToString() != "")
                                                                        //    {
                                                                        //        refid1 = dt8.Rows[0][0].ToString();
                                                                        //        adapter = new SqlDataAdapter();
                                                                        //        sql = "Update CriticalPathDetails set  LF='" + refid1 + "' where ProjectId=" + mypro + " and  TaskId='" + lsource + "'";
                                                                        //        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                        //        adapter.UpdateCommand.ExecuteNonQuery();
                                                                        //    }
                                                                        //}

                                                                    }
                                                                }

                                                                string refid = "";
                                                                DataTable dt8 = new DataTable();
                                                                da = new SqlDataAdapter("select BOQRefId from CriticalPathDetails where Flag='P' and ProjectId=" + mypro + " and  TaskId='" + ltarget + "'", connection);
                                                                da.Fill(dt8);
                                                                if (dt8.Rows.Count > 0)
                                                                {
                                                                    if (dt8.Rows[0][0].ToString() != "")
                                                                    {

                                                                        refid = dt8.Rows[0][0].ToString();
                                                                    }
                                                                }

                                                                dt8 = new DataTable();
                                                                da = new SqlDataAdapter("select dep from CriticalPathDetails where Flag='P' and ProjectId=" + mypro + " and  BOQRefId='" + sorid + "'", connection);
                                                                da.Fill(dt8);
                                                                if (dt8.Rows.Count > 0)
                                                                {

                                                                    if (dt8.Rows[0][0].ToString() != "")
                                                                    {


                                                                        adapter = new SqlDataAdapter();
                                                                        sql = "Update CriticalPathDetails set  dep=dep+'" + "," + refid + "' where Flag='P' and ProjectId=" + mypro + " and  BOQRefId='" + sorid + "'";
                                                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                        adapter.UpdateCommand.ExecuteNonQuery();


                                                                    }
                                                                    else
                                                                    {
                                                                        adapter = new SqlDataAdapter();
                                                                        sql = "Update CriticalPathDetails set  dep='" + refid + "' where Flag='P' and ProjectId=" + mypro + " and  BOQRefId='" + sorid + "'";
                                                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                        adapter.UpdateCommand.ExecuteNonQuery();
                                                                    }

                                                                    ;
                                                                }



                                                            }
                                                        }





                                                    }

                                                }
                                                //Mas Update
                                                DataTable dt9 = new DataTable();
                                                da = new SqlDataAdapter("select BOQId from CriticalPathDetails where Flag='P' and ProjectId=" + mypro + " and  Predec!='' ", connection);
                                                da.Fill(dt9);
                                                if (dt9.Rows.Count > 0)
                                                {

                                                    for (int i = 0; i < dt9.Rows.Count; i++)
                                                    {
                                                        long BOQId = Convert.ToInt64(dt9.Rows[i][0].ToString());

                                                        decimal maxdur = 0;
                                                        da = new SqlDataAdapter("Get_MaxEF", connection);
                                                        da.SelectCommand.CommandType = CommandType.StoredProcedure;
                                                        da.SelectCommand.Parameters.AddWithValue("@ProjectId", mypro);
                                                        da.SelectCommand.Parameters.AddWithValue("@BOQId", BOQId);
                                                        da.SelectCommand.Parameters.AddWithValue("@flag", "P");
                                                        da.SelectCommand.CommandTimeout = 0;
                                                        DataTable ds = new DataTable();
                                                        da.Fill(ds);
                                                        if (ds.Rows.Count > 0)
                                                        {

                                                            maxdur = Convert.ToDecimal(ds.Rows[0][0].ToString());
                                                            adapter = new SqlDataAdapter();
                                                            sql = "Update CriticalPathDetails set ES=" + maxdur + " where  Flag='P' and ProjectId=" + mypro + " and  BOQId='" + BOQId + "'";
                                                            adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                            adapter.UpdateCommand.ExecuteNonQuery();

                                                            adapter = new SqlDataAdapter();
                                                            sql = "Update CriticalPathDetails set EF=ES+Duration where Flag='P' and ProjectId=" + mypro + " and  BOQId='" + BOQId + "'";
                                                            adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                            adapter.UpdateCommand.ExecuteNonQuery();


                                                            //DataTable dt10 = new DataTable();
                                                            //da = new SqlDataAdapter("select EF,BOQRefId from CriticalPathDetails where ProjectId=" + mypro + " and   BOQId='" + BOQId + "'", connection);
                                                            //da.Fill(dt10);
                                                            //if (dt10.Rows.Count > 0)
                                                            //{
                                                            //    decimal efvalnew = Convert.ToDecimal(dt10.Rows[0][0].ToString());
                                                            //    string BOQRe = dt10.Rows[0][1].ToString();
                                                            //    adapter = new SqlDataAdapter();
                                                            //    sql = "Update CriticalPathDetails set  ES=" + efvalnew + " where ProjectId=" + mypro + " and  Predec='" + BOQRe + "'";
                                                            //    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                            //    adapter.UpdateCommand.ExecuteNonQuery();

                                                            //    adapter = new SqlDataAdapter();
                                                            //    sql = "Update CriticalPathDetails set  EF=ES+Duration where ProjectId=" + mypro + " and Predec='" + BOQRe + "'";
                                                            //    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                            //    adapter.UpdateCommand.ExecuteNonQuery();

                                                            //}



                                                        }
                                                    }
                                                }

                                            }
                                            DataTable dt15 = new DataTable();
                                            da = new SqlDataAdapter("select ISNULL(EF,0) as EF,BOQId,dep from CriticalPathDetails where Flag='P' and (dep!='' or  Predec!='') and (BOQRefId like '%S%' ) and ProjectId=" + mypro, connection);
                                            da.Fill(dt15);
                                            if (dt15.Rows.Count > 0)
                                            {

                                                decimal maxLavel = Convert.ToDecimal(dt15.Compute("max([EF])", string.Empty));

                                                for (int i = dt15.Rows.Count; i-- > 0;)
                                                {
                                                    decimal efvalnew = Convert.ToDecimal(dt15.Rows[i][0].ToString());
                                                    string BOQRe = dt15.Rows[i][1].ToString();
                                                    string dep = dt15.Rows[i][2].ToString();

                                                    if ((i + 1) == dt15.Rows.Count)
                                                    {
                                                        adapter = new SqlDataAdapter();
                                                        sql = "Update CriticalPathDetails set  LF=" + maxLavel + " where Flag='P' and ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                        adapter.UpdateCommand.ExecuteNonQuery();

                                                        adapter = new SqlDataAdapter();
                                                        sql = "Update CriticalPathDetails set  LS=LF-Duration where Flag='P' and ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                        adapter.UpdateCommand.ExecuteNonQuery();

                                                        adapter = new SqlDataAdapter();
                                                        sql = "Update CriticalPathDetails set  Slack=LF-EF where Flag='P' and ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                        adapter.UpdateCommand.ExecuteNonQuery();
                                                    }
                                                    //else
                                                    //{

                                                    //    adapter = new SqlDataAdapter();
                                                    //    sql = "Update CriticalPathDetails set  LF=" + efvalnew + " where ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                    //    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                    //    adapter.UpdateCommand.ExecuteNonQuery();
                                                    //}

                                                    if (dep != "")
                                                    {

                                                        //adapter = new SqlDataAdapter();
                                                        //sql = "Update CriticalPathDetails set  LS=LF-Duration where ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                        //adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                        //adapter.UpdateCommand.ExecuteNonQuery();

                                                        //adapter = new SqlDataAdapter();
                                                        //sql = "Update CriticalPathDetails set  Slack=LF-EF where ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                        //adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                        //adapter.UpdateCommand.ExecuteNonQuery();

                                                        if ((i + 1) != dt15.Rows.Count)
                                                        {
                                                            DataTable dt10 = new DataTable();
                                                            //da = new SqlDataAdapter("select LS from CriticalPathDetails where ProjectId=" + mypro + " and   BOQRefId='" + dep + "'", connection);
                                                            da = new SqlDataAdapter("Get_MInLF", connection);
                                                            da.SelectCommand.CommandType = CommandType.StoredProcedure;
                                                            da.SelectCommand.Parameters.AddWithValue("@ProjectId", mypro);
                                                            da.SelectCommand.Parameters.AddWithValue("@BOQId", BOQRe);
                                                            da.SelectCommand.Parameters.AddWithValue("@flag", "P");
                                                            da.SelectCommand.CommandTimeout = 0;
                                                            da.Fill(dt10);
                                                            if (dt10.Rows.Count > 0)
                                                            {
                                                                decimal ldsvalnew = Convert.ToDecimal(dt10.Rows[0][0].ToString());
                                                                adapter = new SqlDataAdapter();
                                                                sql = "Update CriticalPathDetails set  LF=" + ldsvalnew + " where Flag='P' and ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                                adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                adapter.UpdateCommand.ExecuteNonQuery();



                                                                adapter = new SqlDataAdapter();
                                                                sql = "Update CriticalPathDetails set  LS=LF-Duration where Flag='P' and ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                                adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                adapter.UpdateCommand.ExecuteNonQuery();

                                                                adapter = new SqlDataAdapter();
                                                                sql = "Update CriticalPathDetails set  Slack=LF-EF where Flag='P' and ProjectId=" + mypro + " and BOQId='" + BOQRe + "'";
                                                                adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                                adapter.UpdateCommand.ExecuteNonQuery();



                                                            }

                                                        }


                                                    }
                                                    adapter = new SqlDataAdapter();
                                                    sql = "Update CriticalPathDetails set  Criticaltaskid=TaskId where Flag='P' and ProjectId=" + mypro + " and Slack=0 and BOQId='" + BOQRe + "'";
                                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                                    adapter.UpdateCommand.ExecuteNonQuery();

                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        status = false;
                                        message = "Update Not Possible";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    connection.Close();
                                }

                                message = "Updated Successfully";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {
                                status = false;
                                message = "Data Not Found";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }

                        }
                        else

                        {
                            locat = JsonConvert.DeserializeObject<BoqMaster>(liat1);

                            if (locat.id != null)
                            {


                                using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id=" + dbt.DB_Username + ";Password=" + dbt.DB_Password + ";"))
                                //using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";Integrated Security = True;"))
                                {
                                    DataTable dt1 = new DataTable();
                                    connection.Open();
                                    SqlDataAdapter da = new SqlDataAdapter("select * from BoqEntryDetails where  TaskId='" + locat.id + "'", connection);
                                    da.Fill(dt1);



                                    decimal cost = locat.qty * locat.urate;
                                    DataTable dt3 = new DataTable();
                                    long myproj = 0;
                                    DateTime enddate = new DateTime();
                                    DateTime startdate = new DateTime();
                                    da = new SqlDataAdapter("select ProjectId,End_Date,Start_Date from ProjectMaster p  where p.ClientId=" + clientid, connection);
                                    da.Fill(dt3);
                                    if (dt3.Rows.Count > 0)
                                    {
                                        myproj = Convert.ToInt64(dt3.Rows[0][0].ToString());
                                        enddate = Convert.ToDateTime(dt3.Rows[0][1].ToString());
                                        startdate = Convert.ToDateTime(dt3.Rows[0][2].ToString());
                                    }
                                    DataTable dt24 = new DataTable();
                                    da = new SqlDataAdapter("select * from BoqEntryDetails p  where Flag='V' and ProjectId = " + myproj, connection);
                                    da.Fill(dt24);
                                    if (dt24.Rows.Count > 0)
                                    {
                                        status = false;
                                        message = "Project is Freezed";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    if (locat.flag == "V")
                                    {
                                        DataTable dt4 = new DataTable();
                                        da = new SqlDataAdapter("select * from BoqEntryDetails p  where Flag='V' and ProjectId = " + myproj, connection);
                                        da.Fill(dt4);
                                        if (dt4.Rows.Count > 0)
                                        {
                                            status = false;
                                            message = "Project is Already Freezed";
                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                        }
                                        else
                                        {
                                            SqlDataAdapter adapter = new SqlDataAdapter();
                                            string sql = "insert into CriticalPathDetails select ProjectId,BOQId,TaskId,BOQRefId,'',Duration,0,0,'',0,0,0,'','R' as Flag from dbo.CriticalPathDetails where Flag='P' and ProjectId = " + myproj;
                                            adapter.InsertCommand = new SqlCommand(sql, connection);
                                            adapter.InsertCommand.ExecuteNonQuery();


                                            //sql = "insert into BOQLinkDetails select BOQId,ProjectId,TaskId,SourceId,TargetId,LinkType,Mcolor,'R' as Flag from BOQLinkDetails  where Flag='P'  and ProjectId = " + myproj;
                                            //adapter.InsertCommand = new SqlCommand(sql, connection);
                                            //adapter.InsertCommand.ExecuteNonQuery();
                                            

                                            sql = "Update BoqEntryDetails set Flag='V', RVStartDate=StartDate,RVEndDate=EndDate,RDuration=Duration where BOQType='P' and ProjectId=" + myproj;
                                            adapter.UpdateCommand = new SqlCommand(sql, connection);
                                            adapter.UpdateCommand.ExecuteNonQuery();
                                            connection.Close();
                                            message = "Freeze Successfully";
                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                        }
                                    }

                                    if (locat.locationname == "")
                                    {
                                        status = false;
                                        message = "Enter Loaction";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }



                                    if (dt1.Rows.Count > 0)
                                    {



                                        if (locat.start_date == "")
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
                                        else if (locat.dep != "")
                                        {
                                            DataTable dt5 = new DataTable();
                                            DateTime datet = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 0, 0, 0);

                                            da = new SqlDataAdapter("select StartDate as start_date from dbo.BoqEntryDetails  p  where  p.ProjectId=" + myproj + " and BOQRefId='" + locat.dep + "'", connection);
                                            //da = new SqlDataAdapter("select StartDate as start_date from dbo.BoqEntryDetails  p  where p.SubItem like '%" + locat.subitem + "%' and  p.ProjectId=" + myproj + " and BOQRefId='" + locat.dep + "'", connection);
                                            da.Fill(dt5);

                                            if (dt5.Rows.Count == 0)
                                            {
                                                connection.Close();
                                                message = "Enter Successors doesn't exists";
                                                return Request.CreateResponse(HttpStatusCode.OK);
                                            }
                                        }
                                        else if (locat.Predec != "")
                                        {
                                            DataTable dt5 = new DataTable();


                                            da = new SqlDataAdapter("select StartDate as start_date from dbo.BoqEntryDetails  p  where  p.ProjectId=" + myproj + " and BOQRefId like '" + locat.Predec.Substring(0, 2) + "%'", connection);

                                            da.Fill(dt5);

                                            if (dt5.Rows.Count == 0)
                                            {
                                                connection.Close();
                                                message = "Enter Predecessor doesn't exists";
                                                return Request.CreateResponse(HttpStatusCode.OK);
                                            }
                                        }
                                        else if (locat.start_date != "")
                                        {
                                            if (startdate.AddDays(-1) > Convert.ToDateTime(locat.start_date))
                                            {
                                                status = false;
                                                message = "Start date is less than project date";
                                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                            }
                                        }
                                        else if (locat.end_date != "")
                                        {
                                            if (enddate < Convert.ToDateTime(locat.end_date))
                                            {
                                                status = false;
                                                message = "End date is greater than project date";
                                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                            }
                                        }

                                        DateTime stateredDate = DateTime.Parse(locat.start_date);
                                        //DateTime enedDate = DateTime.ParseExact(locat.end_date, "dd/MM/yyyy", null);
                                        //DateTime enedDate = DateTime.Parse(locat.end_date);
                                        DateTime enedDate = DateTime.Parse(locat.start_date).AddDays(locat.duration);
                                        if (stateredDate <= enedDate)
                                        {
                                            TimeSpan t = enedDate - stateredDate;
                                            double NrOfDays = t.TotalDays;
                                            int difday = locat.duration;
                                            if (locat.duration == 0)
                                                difday = (int)NrOfDays;

                                            SqlDataAdapter adapter = new SqlDataAdapter();
                                            string sql = "";
                                            sql = "Boq_CriticaltaskUpdate";
                                            cmd = new SqlCommand(sql, connection);
                                            cmd.CommandType = CommandType.StoredProcedure;
                                            if(locat.Criticaltaskid!=null)
                                            cmd.Parameters.Add("@Criticaltaskid", SqlDbType.VarChar).Value = locat.Criticaltaskid;
                                            else
                                                cmd.Parameters.Add("@Criticaltaskid", SqlDbType.VarChar).Value = "";
                                            cmd.Parameters.Add("@StartDate", SqlDbType.DateTime).Value = stateredDate;
                                            cmd.Parameters.Add("@EndDate", SqlDbType.DateTime).Value = enedDate;
                                            cmd.Parameters.Add("@Duration", SqlDbType.Int).Value = difday;
                                            cmd.Parameters.Add("@dep", SqlDbType.VarChar).Value = locat.dep;
                                            cmd.Parameters.Add("@Predec", SqlDbType.VarChar).Value = locat.Predec;
                                            cmd.Parameters.Add("@Priority", SqlDbType.BigInt).Value = locat.Priority;
                                            cmd.Parameters.Add("@TaskId", SqlDbType.VarChar).Value = locat.id;
                                            cmd.Parameters.Add("@Flag", SqlDbType.Int).Value = 0;
                                            cmd.CommandTimeout = 0;
                                            cmd.ExecuteNonQuery();
                                             //string sql = "Update BoqEntryDetails set Criticaltaskid= '" + locat.Criticaltaskid + "', StartDate='" + stateredDate + "',EndDate='" + enedDate + "',Duration=" + difday + ",dep='" + locat.dep + "',Predec='" + locat.Predec + "',Priority=" + locat.Priority + " where TaskId=" + locat.id;
                                            //string sql = "Update BoqEntryDetails set DescriptionId='" + locat.location + "',MainItemId='" + locat.mainitem + "',SubItem='" + locat.subitem + "',SubSubItem='" + locat.subsubitem + "',StartDate='" + stateredDate + "',EndDate='" + enedDate + "',BoqRef='" + locat.boq + "',Duration=" + difday + ",Task='" + locat.task + "',Unit='" + locat.unit + "',Qty=" + locat.qty + ",UnitRate=" + locat.urate + ",TotalCost=" + cost + " where TaskId=" + locat.id;
                                            //string sql = "Update BoqEntryDetails set DescriptionId='" + locat.locationId + "',DescriptionName='" + locat.text + "',MainItemId='" + locat.mainItemId + "',MainItem='" + locat.name + "',SubItem='" + locat.subitem + "',SubSubItem='" + locat.subsubitem + "',BoqRef='" + locat.boq + "',Task='" + locat.task + "',unit='" + locat.unit + "',qty=" + locat.qty + ",UnitRate=" + locat.urate + ",TotalCost=" + locat.tcost + ",WorkdonePer=" + locat.progress + ",StartDate='" + locat.start_date + "',EndDate='" + locat.end_date + "',Duration=" + locat.Duration + ",Priority=" + locat.dep + ",RefId='" + locat.id + "' where TaskId=" + locat.taskId;
                                            //adapter.UpdateCommand = new SqlCommand(sql, connection);
                                            //adapter.UpdateCommand.ExecuteNonQuery();

                                            //if (locat.mainItemId == 0)
                                            //{
                                            //    adapter = new SqlDataAdapter();
                                            //    sql = "Update CriticalPathDetails set Duration=0 ,dep='" + locat.dep + "' where TaskId=" + locat.id;
                                            //    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                            //    adapter.UpdateCommand.ExecuteNonQuery();
                                            //}
                                            //else
                                            //{
                                            adapter = new SqlDataAdapter();
                                            sql = "Update CriticalPathDetails set Duration=" + difday + ",dep='" + locat.dep + "' where Flag = 'P' and  TaskId=" + locat.id;
                                            adapter.UpdateCommand = new SqlCommand(sql, connection);
                                            adapter.UpdateCommand.ExecuteNonQuery();
                                            //   }
                                            if (locat.step > 2)
                                            {


                                                sql = "Boq_Update";
                                                cmd = new SqlCommand(sql, connection);
                                                cmd.CommandType = CommandType.StoredProcedure;
                                                cmd.Parameters.Add("@MainItemId", SqlDbType.BigInt).Value = locat.mainItemId;
                                                cmd.Parameters.Add("@subitem", SqlDbType.VarChar).Value = locat.subitem;
                                                cmd.Parameters.Add("@flag", SqlDbType.VarChar).Value = "P";
                                                cmd.Parameters.Add("@ProjectId", SqlDbType.BigInt).Value = myproj;
                                                cmd.Parameters.Add("@tasId", SqlDbType.VarChar).Value = locat.id;
                                                cmd.CommandTimeout = 0;
                                                cmd.ExecuteNonQuery();
                                            }

                                            connection.Close();
                                            message = "Update Successfully";
                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                        }
                                        else
                                        {
                                            status = false;
                                            message = "Check Date";
                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                        }
                                    }
                                    else
                                    {
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


                                        string brefid = "";
                                        da = new SqlDataAdapter("Get_BOQRefid", connection);
                                        da.SelectCommand.CommandType = CommandType.StoredProcedure;
                                        da.SelectCommand.Parameters.AddWithValue("@refid", locat.step);
                                        da.SelectCommand.Parameters.AddWithValue("@ParentId", locat.parent);
                                        da.SelectCommand.Parameters.AddWithValue("@boqtype", "P");
                                        da.SelectCommand.Parameters.AddWithValue("@ProjectId", myproj);
                                        da.SelectCommand.CommandTimeout = 0;
                                        DataTable ds = new DataTable();
                                        da.Fill(ds);
                                        if (ds.Rows.Count > 0)
                                            brefid = ds.Rows[0][0].ToString();

                                        SqlDataAdapter adapter = new SqlDataAdapter();
                                        //string sql = "insert into BoqEntryDetails (ProjectId,DescriptionId,DescriptionName,MainItemId,MainItem,SubItem,SubSubItem,BoqRef,Task,Unit,Qty,UnitRate,TotalCost,WorkdonePer,StartDate,EndDate,Duration,Priority,RefId,TaskId,ParentId,ClientId,UserId,BOQType,BOQRefId,Workdonecost,Flag,dep) values(" + myproj + ",'" + locat.location + "','" + locat.locationname + "','" + locat.mainitem + "','" + locat.mainitemname + "','" + locat.subitem + "','" + locat.subsubitem + "','"+locat.boq+ "','" + locat.task + "','" + locat.unit + "',"+locat.qty+ "," + locat.urate + "," + cost + ",0,'" + stateredDate + "','" + enedDate + "'," + difday + ",0,'"  + locat.step  + "','"+locat.id + "','" + locat.parent + "',"+ clientid + ","+ userid +",'P','"+brefid+"',0,'P','"+locat.dep+"')";
                                        //string sql = "insert into BoqEntryDetails values(" + 1 + ",'" + locat.locationId + "','" + locat.text + "','" + locat.mainItemId + "','" + locat.name + "','" + locat.subitem + "','" + locat.subsubitem + "','" + locat.boq + "','" + locat.task + "','" + locat.unit + "'," + locat.qty + "," + locat.urate + "," + locat.tcost + "," + locat.progress + ",'" + locat.start_date + "','" + locat.end_date + "'," + locat.Duration + "," + locat.dep + ",'" + locat.id + "','" + locat.taskId + "')";
                                        //adapter.InsertCommand = new SqlCommand(sql, connection);
                                        //adapter.InsertCommand.ExecuteNonQuery();
                                        //(@myproj bigint,@location bigint,@locationname nvarchar(250),@mainitem bigint,@mainitemname nvarchar(250),@subitem nvarchar(250),
                                        //@subsubitem nvarchar(250),@boq nvarchar(100),@task nvarchar(250),@unit varchar(10),@qty decimal(18, 2),@urate decimal(18, 2),
                                        //@cost decimal(18, 2) ,@stateredDate datetime,@enedDate datetime,@difday decimal(18, 2),@step bigint,@id varchar(100),
                                        //(" + myproj + ", '" + locat.location + "', '" + locat.locationname + "', '" + locat.mainitem + "', '" + locat.mainitemname + "', '" + locat.subitem + "', 
                                        //'" + locat.subsubitem + "', '"+locat.boq+ "', '" + locat.task + "', '" + locat.unit + "', "+locat.qty+ ", " + locat.urate + ", " + cost + ", 0, '" + 
                                        //stateredDate + "', '" + enedDate + "', " + difday + ", 0, '"  + locat.step  + "', '"+locat.id + "', '" + locat.parent + "', "+ 
                                        //clientid + ", "+ userid +", 'P', '"+brefid+"', 0, 'P', '"+locat.dep+"')";
                                        string sql = "Save_BOQ";
                                        cmd = new SqlCommand(sql, connection);
                                        cmd.CommandType = CommandType.StoredProcedure;
                                        cmd.Parameters.Add("@myproj", SqlDbType.BigInt).Value = myproj;
                                        cmd.Parameters.Add("@location", SqlDbType.BigInt).Value = locat.location;
                                        cmd.Parameters.Add("@locationname", SqlDbType.VarChar).Value = locat.locationname;
                                        cmd.Parameters.Add("@mainitem", SqlDbType.BigInt).Value = locat.mainitem;
                                        cmd.Parameters.Add("@mainitemname", SqlDbType.VarChar).Value = locat.mainitemname;
                                        cmd.Parameters.Add("@subitem", SqlDbType.VarChar).Value = locat.subitem;
                                        cmd.Parameters.Add("@subsubitem", SqlDbType.VarChar).Value = locat.subsubitem;
                                        cmd.Parameters.Add("@boq", SqlDbType.VarChar).Value = locat.boq;
                                        cmd.Parameters.Add("@task", SqlDbType.VarChar).Value = locat.task;

                                        cmd.Parameters.Add("@unit", SqlDbType.VarChar).Value = locat.unit;
                                        cmd.Parameters.Add("@qty", SqlDbType.Decimal).Value = locat.qty;
                                        cmd.Parameters.Add("@urate", SqlDbType.Decimal).Value = locat.urate;
                                        cmd.Parameters.Add("@cost", SqlDbType.Decimal).Value = cost;
                                        //cmd.Parameters.Add("@stateredDate", SqlDbType.DateTime).Value = stateredDate;
                                        //cmd.Parameters.Add("@enedDate", SqlDbType.DateTime).Value = enedDate;
                                        //cmd.Parameters.Add("@difday", SqlDbType.Decimal).Value = difday;
                                        cmd.Parameters.Add("@step", SqlDbType.BigInt).Value = locat.step;
                                        cmd.Parameters.Add("@id", SqlDbType.VarChar).Value = locat.id;
                                        //@parent varchar(100),@clientid bigint,@userid bigint, @brefid varchar(20),@dep varchar(20))
                                        cmd.Parameters.Add("@parent", SqlDbType.VarChar).Value = locat.parent;
                                        cmd.Parameters.Add("@clientid", SqlDbType.BigInt).Value = clientid;
                                        cmd.Parameters.Add("@userid", SqlDbType.Int).Value = userid;
                                        cmd.Parameters.Add("@brefid", SqlDbType.VarChar).Value = brefid;
                                        cmd.Parameters.Add("@dep", SqlDbType.VarChar).Value = locat.dep;




                                        cmd.CommandTimeout = 0;
                                        cmd.ExecuteNonQuery();

                                        if (locat.step > 2)
                                        {
                                            //sql = "Update BoqEntryDetails set StartDate='" + locat.start_date + "' where MainItemId=" + locat.mainitem + " or  MainItemId=0 ";
                                            //adapter.UpdateCommand = new SqlCommand(sql, connection);
                                            //adapter.UpdateCommand.ExecuteNonQuery();

                                            //sql = "Update BoqEntryDetails set EndDate='" + locat.end_date + "' where (MainItemId=" + locat.mainitem + " or  MainItemId=0 ) and SubSubItem=''";
                                            //adapter.UpdateCommand = new SqlCommand(sql, connection);
                                            //adapter.UpdateCommand.ExecuteNonQuery();

                                            sql = "Boq_Update";
                                            cmd = new SqlCommand(sql, connection);
                                            cmd.CommandType = CommandType.StoredProcedure;
                                            cmd.Parameters.Add("@MainItemId", SqlDbType.BigInt).Value = locat.mainitem;
                                            cmd.Parameters.Add("@subitem", SqlDbType.VarChar).Value = locat.subitem;
                                            cmd.Parameters.Add("@flag", SqlDbType.VarChar).Value = "P";
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
                                status = false;
                                message = "Invalid Id";
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